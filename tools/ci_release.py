#!/usr/bin/env python3
"""Build/package release artifacts in GitHub Actions, always for the checked-out SHA."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shutil
import subprocess
import zipfile

from release_worker import ROOT, Worker, checksum


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('step', choices=['metadata', 'firmware', 'full', 'minimal', 'manifest'])
    args = parser.parse_args()
    version = re.search(r'#define FW_VERSION\s+"([0-9.]+)"', (ROOT / 'fw/src/main.c').read_text()).group(1)
    commit = subprocess.check_output(['git', 'rev-parse', 'HEAD'], text=True).strip()
    if args.step == 'metadata':
        if not re.fullmatch(r'\d+\.\d+\.\d+', version):
            raise SystemExit('Expected a semantic firmware version')
        studio = json.loads((ROOT / 'apps/studio/package.json').read_text())['version']
        android = (ROOT / 'apps/android/app/build.gradle.kts').read_text()
        if studio != version or f'versionName = "{version}"' not in android:
            raise SystemExit('Firmware, Studio and Android release versions must match')
        requested = os.environ.get('REQUESTED_VERSION', '')
        if requested and requested != version:
            raise SystemExit('Requested version does not match the checked-out source')
        if os.environ.get('GITHUB_OUTPUT'):
            with open(os.environ['GITHUB_OUTPUT'], 'a') as out:
                out.write(f'version={version}\ntag=v{version}\ncommit={commit}\n')
        print(version, commit)
        return
    if args.step == 'manifest':
        files = sorted(p for p in (ROOT / 'release-assets').iterdir() if p.is_file())
        required = ['opgbc_fw.bin', 'opgbc_fpga.bin', 'opgbc_fpga_min.bin',
                    f'OpenPocket-{version}.apk', f'OpenPocketWeb-{version}.zip',
                    f'OpenPocketStudio-{version}.exe']
        names = {p.name for p in files}
        if not set(required) <= names or not any(n.endswith('.dmg') for n in names) or not any(n.endswith('.AppImage') for n in names):
            raise SystemExit('Refusing an incomplete release: ' + str(sorted(set(required) - names)))
        manifest = {'version': version, 'commit': commit, 'hardware_tested': False,
                    'sha256': {p.name: checksum(p) for p in files}}
        (ROOT / 'release-assets/build-manifest.json').write_text(json.dumps(manifest, indent=2))
        (ROOT / 'release-assets/SHA256SUMS').write_text(''.join(f'{checksum(p)}  {p.name}\n' for p in files))
        return
    worker = Worker(version)
    worker.source = ROOT
    worker.state['commit'] = commit
    # Never fetch main or snapshot a different revision inside an Actions job.
    worker.assets.mkdir(parents=True, exist_ok=True)
    if args.step == 'firmware':
        worker.checks_and_firmware()
        worker.run(['python3', '-m', 'unittest', 'discover', '-s', 'tools/tests', '-p', 'test_*.py'])
        with zipfile.ZipFile(worker.assets / f'OpenPocketWeb-{version}.zip', 'w', zipfile.ZIP_DEFLATED) as out:
            for file in (ROOT / 'docs/web').iterdir():
                if file.is_file():
                    out.write(file, file.name)
    else:
        worker.fpga(minimal=args.step == 'minimal')
    output = ROOT / 'release-assets'
    output.mkdir(exist_ok=True)
    for file in worker.assets.iterdir():
        if file.is_file():
            shutil.copy2(file, output / file.name)


if __name__ == '__main__':
    main()
