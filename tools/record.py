#!/usr/bin/env python3
"""Record the HDMI capture card while sending a button sequence, then make a GIF / MP4.

  python tools/record.py docs/img/menu.gif "1 M . D D . R R . M" --secs 8
  python tools/record.py docs/img/play.mp4 "2 +R 1.5 -R A" --secs 6

Needs ffmpeg (FFMPEG env var or on PATH) and a capture card named "USB2.0 HD" / "USB3.0 UHD".
The GIF is cropped to the 480p picture area and scaled to --width.
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile
import threading
import time

sys.path.insert(0, os.path.dirname(__file__))
from remote import Pad, find_port  # noqa: E402

FFMPEG = os.environ.get('FFMPEG', r'E:\tools\ffmpeg\ffmpeg-N-127617-g94cba3150c-win64-gpl\bin\ffmpeg.exe')


def capture_device():
    out = subprocess.run([FFMPEG, '-hide_banner', '-list_devices', 'true', '-f', 'dshow', '-i', 'dummy'],
                         capture_output=True, text=True, encoding='utf-8', errors='replace').stderr
    m = re.search(r'"(USB[23]\.0 U?HD)"', out)
    if not m:
        sys.exit('capture card not found')
    return m.group(1)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('out')
    ap.add_argument('seq', nargs='?', default='')
    ap.add_argument('--secs', type=float, default=6)
    ap.add_argument('--start', type=float, default=1.0, help='seconds of video before the sequence starts')
    ap.add_argument('--width', type=int, default=480)
    ap.add_argument('--fps', type=int, default=20)
    ap.add_argument('--full', action='store_true', help='keep the whole 16:9 frame (default: crop to 4:3)')
    ap.add_argument('--port')
    a = ap.parse_args()

    raw = os.path.join(tempfile.gettempdir(), 'opgbc_rec.mkv')
    rec = subprocess.Popen([FFMPEG, '-hide_banner', '-loglevel', 'error', '-y', '-f', 'dshow',
                            '-video_size', '1280x720', '-framerate', '30', '-rtbufsize', '200M',
                            '-i', 'video=' + capture_device(), '-t', str(a.secs + 1.5),
                            '-c:v', 'libx264', '-preset', 'ultrafast', '-crf', '12', raw])
    if a.seq:
        pad = Pad(a.port or find_port(), 0.12, 0.35)
        time.sleep(1.5 + a.start)          # device start-up + lead-in
        t = threading.Thread(target=pad.run, args=(a.seq,))
        t.start()
        t.join()
    rec.wait()

    crop = '' if a.full else 'crop=960:720:160:0,'
    vf = '%sfps=%d,scale=%d:-1:flags=lanczos' % (crop, a.fps, a.width)
    trim = ['-ss', '1.0']
    if a.out.endswith('.gif'):
        vf += ',split[s0][s1];[s0]palettegen=max_colors=128:stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=4'
        subprocess.run([FFMPEG, '-hide_banner', '-loglevel', 'error', '-y'] + trim + ['-i', raw, '-vf', vf, '-loop', '0', a.out], check=True)
    else:
        subprocess.run([FFMPEG, '-hide_banner', '-loglevel', 'error', '-y'] + trim + ['-i', raw, '-vf', vf,
                        '-c:v', 'libx264', '-pix_fmt', 'yuv420p', '-crf', '23', '-movflags', '+faststart', a.out], check=True)
    print('%s: %d KB' % (a.out, os.path.getsize(a.out) // 1024))


if __name__ == '__main__':
    main()
