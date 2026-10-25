#!/usr/bin/env python3
"""Standalone, pinned-source FPGA build and GitHub release worker (standard library only).

python tools/release_worker.py --start --version 1.9.1
python tools/release_worker.py --status --version 1.9.1
Logs/status: build/release-worker/<version>/. No Codex/model/API dependency.
"""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import struct
import subprocess
import sys
import tarfile
import time
import zipfile

ROOT = Path(__file__).resolve().parents[1]
REPO = 'LakoMoor/open-pocket-gbc'
TOOLS = Path(os.environ.get('TOOLS', 'E:/tools/oss-cad-suite'))
BASH = Path(os.environ.get('GIT_BASH', 'C:/Program Files/Git/bin/bash.exe'))
CREATE = {'creationflags': subprocess.CREATE_NO_WINDOW} if os.name == 'nt' else {}


def timing_ok(log):
    """nextpnr prints provisional and post-route timing; require the last result per clock."""
    results = {}
    for clock, result in re.findall(r"Max frequency for clock\s+'([^']+)':[^\n]*?\((PASS|FAIL)\b", log):
        results[clock] = result
    return bool(results) and all(result == 'PASS' for result in results.values())


def fs_bytes(text):
    bits = ''.join(line.strip() for line in text.splitlines() if line.strip() and not line.startswith('//'))
    if not bits or set(bits) - {'0', '1'} or len(bits) % 8:
        raise ValueError('Invalid Gowin bitstream text')
    data = bytes(int(bits[i:i+8], 2) for i in range(0, len(bits), 8))
    if not 100000 < len(data) < 0x100000:
        raise ValueError('Bitstream size is outside its flash partition')
    return data


def checksum(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class Worker:
    def __init__(self, version):
        self.version = version
        self.base = ROOT / 'build' / 'release-worker' / version
        self.base.mkdir(parents=True, exist_ok=True)
        self.statefile = self.base / 'status.json'
        self.source = self.base / 'source'
        self.assets = self.base / 'assets'
        self.env = dict(os.environ)
        # Do not inherit experimental feature defines from an interactive shell.
        for key in ('DEFS', 'OUT_DIR', 'SEEDS', 'NEXTPNR_EXTRA', 'PNR_OPTS', 'PACK_EXTRA'):
            self.env.pop(key, None)
        self.env['PATH'] = str(TOOLS / 'bin') + os.pathsep + str(TOOLS / 'lib') + os.pathsep + self.env['PATH']
        self.state = {'version': version, 'pid': os.getpid(), 'phase': 'starting'}

    def update(self, phase, **extra):
        self.state.update(phase=phase, updated_at=time.strftime('%Y-%m-%dT%H:%M:%S%z'), **extra)
        temp = self.statefile.with_suffix('.tmp')
        temp.write_text(json.dumps(self.state, indent=2), encoding='utf-8')
        temp.replace(self.statefile)
        print(phase, extra, flush=True)

    def run(self, args, *, cwd=None, timeout=900, capture=False, log='commands.log'):
        cwd = cwd or self.source
        if capture:
            return subprocess.check_output(args, cwd=cwd, env=self.env, text=True, encoding='utf-8', errors='replace', timeout=timeout, **CREATE).strip()
        with (self.base / log).open('a', encoding='utf-8') as out:
            out.write('\n$ ' + ' '.join(map(str, args)) + '\n'); out.flush()
            proc = subprocess.Popen(args, cwd=cwd, env=self.env, stdout=out, stderr=subprocess.STDOUT, **CREATE)
            try:
                result = proc.wait(timeout=timeout)
            except subprocess.TimeoutExpired:
                if os.name == 'nt':
                    subprocess.run(['taskkill', '/PID', str(proc.pid), '/T', '/F'], stdout=out, stderr=out, **CREATE)
                else:
                    proc.kill()
                proc.wait()
                raise RuntimeError('Command timed out: ' + str(args[0]))
            if result:
                raise RuntimeError(f'Command failed ({result}): {args[0]}; see {log}')

    def bash(self, command, **kwargs):
        return self.run([str(BASH), '-c', command], **kwargs)

    def prepare(self):
        self.run(['gh', 'auth', 'status'], cwd=ROOT, timeout=60)
        self.run(['git', 'fetch', 'origin', 'main'], cwd=ROOT, timeout=120)
        sha_file = self.base / 'source-sha.txt'
        if sha_file.exists():
            sha = sha_file.read_text().strip()
        else:
            sha = self.run(['git', 'rev-parse', 'origin/main'], cwd=ROOT, capture=True)
            sha_file.write_text(sha, encoding='ascii')
        self.update('snapshot', commit=sha)
        if not self.source.exists():
            archive = self.base / 'source.tar'
            self.run(['git', 'archive', '--format=tar', '-o', str(archive), sha], cwd=ROOT)
            self.source.mkdir()
            with tarfile.open(archive) as tar:
                tar.extractall(self.source, filter='data')
        main = (self.source / 'fw/src/main.c').read_text(encoding='utf-8')
        if f'#define FW_VERSION      "{self.version}"' not in main:
            raise RuntimeError('Pinned source firmware version does not match requested release')
        # No source edits after snapshot; only ignored build outputs are generated.
        self.assets.mkdir(exist_ok=True)
        return sha

    def checks_and_firmware(self):
        self.update('tests')
        self.bash('bash sim/tang/test_printer.sh')
        self.run(['node', '--test', 'tools/tests/web_protocol.test.mjs', 'tools/tests/i18n.test.mjs'])
        self.run(['node', '--check', 'docs/web/app.mjs'])
        self.update('firmware')
        self.bash('bash fw/build.sh', timeout=300)
        fw = (self.source / 'fw/build/fw.bin').read_bytes()
        if len(fw) < 8 or struct.unpack('<I', fw[:4])[0] != len(fw)-4 or len(fw) > 0x100000:
            raise RuntimeError('Invalid firmware header/size')
        (self.assets / 'opgbc_fw.bin').write_bytes(fw)

    def fpga(self, minimal=False):
        variant = 'minimal' if minimal else 'full'
        out = self.source / 'build' / variant
        out.mkdir(parents=True, exist_ok=True)
        synth = out / 'synth.json'
        # A first bounded attempt runs the project's exact synthesis flow; later
        # attempts reuse its netlist, with unchanged functionality and constraints.
        if not synth.exists():
            self.update('synthesis', variant=variant)
            command = f'OUT_DIR=build/{variant} SEEDS=1 NEXTPNR_EXTRA="--placer-heap-cell-placement-timeout 100000" '
            if minimal:
                command += 'DEFS="-D MINIMAL" PNR_OPTS="--pre-pack rtl/board/place.py --sdc rtl/board/clocks_min.sdc --vopt ioreg_in_iob" '
            try:
                self.bash(command + 'bash build.sh gbc_top', timeout=1200, log=f'{variant}-synthesis.log')
            except RuntimeError:
                if not synth.exists():
                    raise
        cst = 'rtl/board/tangnano20k.cst'
        sdc = 'rtl/board/clocks_min.sdc' if minimal else 'rtl/board/clocks.sdc'
        seeds = [21, 42, 7, 1, 3, 99, 1234, 5, 13, 77, 256, 8]
        profiles = [(['--placer-heap-cell-placement-timeout', '4096'], 'heap'),
                    (['--placer-heap-cell-placement-timeout', '4096', '--placer-heap-no-ctrl-set'], 'heap-no-ctrl'),
                    (['--placer-heap-cell-placement-timeout', '256'], 'heap-long')]
        for extra, profile in profiles:
            for seed in seeds:
                label = f'{variant}-{profile}-{seed}'
                routed = out / f'{profile}-{seed}.json'
                report = out / f'{profile}-{seed}.log'
                passed = out / f'{profile}-{seed}.passed'
                self.update('placement', variant=variant, profile=profile, seed=seed)
                if not passed.exists():
                    args = ['nextpnr-himbaechel', '-q', '-l', str(report), '--json', str(synth), '--write', str(routed),
                            '--device', 'GW2AR-LV18QN88C8/I7', '--vopt', 'family=GW2A-18C', '--vopt', f'cst={cst}',
                            '--pre-pack', 'rtl/board/place.py', '--sdc', sdc, '--vopt', 'ioreg_in_iob', '--seed', str(seed), *extra]
                    try:
                        # Intentionally NO --timing-allow-fail for release builds.
                        self.run(args, timeout=1200, log=label+'.txt')
                        if not timing_ok(report.read_text(errors='replace')):
                            raise RuntimeError('Missing or failing final timing report')
                        passed.write_text(self.state['commit'])
                    except (RuntimeError, subprocess.SubprocessError) as exc:
                        self.update('attempt_failed', variant=variant, profile=profile, seed=seed, error=str(exc))
                        continue
                if not routed.exists() or passed.read_text().strip() != self.state['commit']:
                    continue
                self.update('packing', variant=variant, profile=profile, seed=seed)
                packed = out / 'gbc_top.fs'
                self.run(['gowin_pack', '-d', 'GW2A-18C', '--mspi_as_gpio', '-o', str(packed), str(routed)], timeout=300)
                data = fs_bytes(packed.read_text())
                (self.assets / ('opgbc_fpga_min.bin' if minimal else 'opgbc_fpga.bin')).write_bytes(data)
                shutil.copy2(report, self.assets / f'{variant}-timing.log')
                return
        raise RuntimeError(f'All {variant} placement attempts failed. No release published. Logs: {out}')

    def publish(self, sha):
        self.update('packaging')
        with zipfile.ZipFile(self.assets / f'OpenPocketWeb-{self.version}.zip', 'w', zipfile.ZIP_DEFLATED) as archive:
            for file in (self.source / 'docs/web').iterdir():
                if file.is_file():
                    archive.write(file, file.name)
        manifest = {'commit': sha, 'version': self.version, 'hardware_tested': False,
                    'sha256': {p.name: checksum(p) for p in self.assets.iterdir() if p.is_file()}}
        (self.assets / 'build-manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
        notes = self.base / 'notes.md'
        notes.write_text(f'''Fix virtual Game Boy Printer detection and missed serial-byte wake-ups.

Update BOTH `opgbc_fw.bin` and the Full `opgbc_fpga.bin`. Minimal intentionally has no printer.
Enable Tools → Virtual Printer in a compatible game; finished pages appear under Last Print and /Prints on SD.
Includes the RU/EN browser remote. Native Studio 1.9 remains compatible; native installers build separately through GitHub Actions after the tag is pushed.

Validation: printer RTL regression, web protocol/localization tests, firmware build, Full and Minimal placement/routing with passing final timing. Not tested on physical hardware.
Source: {sha}. See build-manifest.json for SHA256 hashes.
''', encoding='utf-8')
        tag = 'v'+self.version
        # An existing release is resumed only for the exact same source tag.
        remote_tag = self.run(['git', 'ls-remote', 'origin', f'refs/tags/{tag}', f'refs/tags/{tag}^{{}}'], cwd=ROOT, capture=True)
        if remote_tag:
            hashes = {line.split()[0] for line in remote_tag.splitlines()}
            if sha not in hashes:
                raise RuntimeError('Existing release tag belongs to different source; refusing overwrite')
        result = subprocess.run(['gh', 'release', 'view', tag, '--repo', REPO, '--json', 'isDraft,targetCommitish'], capture_output=True, text=True, **CREATE)
        if result.returncode == 0:
            if not json.loads(result.stdout)['isDraft']:
                self.update('already_published', url=f'https://github.com/{REPO}/releases/tag/{tag}')
                return
            if not remote_tag and json.loads(result.stdout)['targetCommitish'] != sha:
                raise RuntimeError('Existing draft targets different source')
        else:
            self.run(['gh', 'release', 'create', tag, '--repo', REPO, '--target', sha, '--draft', '--title', f'Open Pocket GBC {self.version}', '--notes-file', str(notes)], timeout=180)
        self.update('uploading_draft')
        assets = [p for p in self.assets.iterdir() if p.is_file()]
        self.run(['gh', 'release', 'upload', tag, '--repo', REPO, '--clobber', *map(str, assets)], timeout=900)
        verify = self.base / 'download-verification'
        verify.mkdir(exist_ok=True)
        for file in assets:
            self.run(['gh', 'release', 'download', tag, '--repo', REPO, '--pattern', file.name, '--dir', str(verify), '--clobber'], timeout=300)
            if checksum(file) != checksum(verify / file.name):
                raise RuntimeError('Uploaded asset checksum mismatch: '+file.name)
        self.run(['gh', 'release', 'edit', tag, '--repo', REPO, '--draft=false', '--latest', '--notes-file', str(notes)], timeout=180)
        # Trigger the existing native desktop installer workflow after publishing;
        # publication itself never depends on a model or that separate workflow.
        if not remote_tag:
            try:
                self.run(['gh', 'workflow', 'run', 'studio.yml', '--repo', REPO, '--ref', tag], cwd=ROOT, timeout=180)
            except RuntimeError as exc:
                self.update('published_native_workflow_pending', error=str(exc))
        self.update('published', url=f'https://github.com/{REPO}/releases/tag/{tag}')

    def work(self):
        lock = self.base / 'worker.lock'
        # OS-held lock survives crashes safely and rejects duplicate workers.
        handle = lock.open('a+b')
        try:
            if os.name == 'nt':
                import msvcrt
                handle.seek(0); handle.write(b'0'); handle.flush(); handle.seek(0)
                msvcrt.locking(handle.fileno(), msvcrt.LK_NBLCK, 1)
            else:
                import fcntl
                fcntl.flock(handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except OSError:
            print('Release worker is already running.', flush=True)
            return 2
        try:
            sha = self.prepare()
            self.checks_and_firmware()
            self.fpga()
            self.fpga(minimal=True)
            self.publish(sha)
            return 0
        except Exception as exc:
            self.update('failed', error=str(exc))
            return 1
        finally:
            handle.close()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--version', default='1.9.1')
    parser.add_argument('--start', action='store_true')
    parser.add_argument('--status', action='store_true')
    args = parser.parse_args()
    if not re.fullmatch(r'\d+\.\d+\.\d+', args.version):
        parser.error('version must be x.y.z')
    worker = Worker(args.version)
    if args.status:
        print(worker.statefile.read_text() if worker.statefile.exists() else 'Not started')
        return 0
    if args.start:
        with (worker.base / 'worker.log').open('a', encoding='utf-8') as log:
            kwargs = {'creationflags': subprocess.DETACHED_PROCESS | subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.CREATE_NO_WINDOW} if os.name == 'nt' else {'start_new_session': True}
            proc = subprocess.Popen([sys.executable, str(Path(__file__).resolve()), '--version', args.version], cwd=ROOT, stdin=subprocess.DEVNULL, stdout=log, stderr=log, **kwargs)
        print(f'Started detached worker PID {proc.pid}. Status: {worker.statefile}')
        return 0
    return worker.work()


if __name__ == '__main__':
    sys.exit(main())
