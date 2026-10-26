"""Exercise the actual firmware BMP header parser with a host compiler."""
import ctypes
from pathlib import Path
import shutil
import struct
import subprocess
import tempfile
import unittest
import os

ROOT = Path(__file__).resolve().parents[2]


class Info(ctypes.Structure):
    _fields_ = [(n, ctypes.c_uint32) for n in ('width', 'height', 'offset', 'stride')] + [
        ('bytes_per_pixel', ctypes.c_uint8), ('top_down', ctypes.c_uint8)]


class BitmapTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        (ROOT / 'build').mkdir(exist_ok=True)
        cls.tmp = tempfile.TemporaryDirectory(prefix='bmp-test-', dir=ROOT / 'build')
        compiler = os.environ.get('CC') or shutil.which('gcc')
        if not compiler:
            raise RuntimeError('Host GCC is required to verify the firmware BMP parser')
        library = Path(cls.tmp.name) / ('bmp.dll' if os.name == 'nt' else 'bmp.so')
        subprocess.run([compiler, '-shared', '-O2', '-fPIC', '-o', str(library), str(ROOT / 'fw/src/bmp.c')], check=True)
        cls.lib = ctypes.CDLL(str(library))
        cls.lib.bmp_parse.argtypes = [ctypes.POINTER(ctypes.c_uint8), ctypes.c_uint32, ctypes.POINTER(Info)]
        cls.lib.bmp_parse.restype = ctypes.c_int

    @classmethod
    def tearDownClass(cls):
        if os.name == 'nt':
            import _ctypes
            _ctypes.FreeLibrary(cls.lib._handle)
        cls.lib = None
        cls.tmp.cleanup()

    def parse(self, width=160, height=144, bits=24, offset=54, **overrides):
        row = ((abs(width) * (bits // 8) + 3) & ~3) if bits >= 8 else 0
        size = overrides.get('size', offset + row * abs(height))
        header = bytearray(54)
        header[:2] = b'BM'
        struct.pack_into('<I', header, 10, offset)
        struct.pack_into('<IiiHHI', header, 14, overrides.get('dib', 40), width, height, 1, bits, overrides.get('compression', 0))
        out = Info()
        data = (ctypes.c_uint8 * 54).from_buffer_copy(header)
        return self.lib.bmp_parse(data, size & 0xffffffff, ctypes.byref(out)), out

    def test_screenshot_and_printer_page(self):
        for height in (144, 2456):
            result, info = self.parse(height=height)
            self.assertEqual(result, 0)
            self.assertEqual((info.width, info.height, info.stride), (160, height, 480))

    def test_padding_and_top_down_bgrx(self):
        result, info = self.parse(width=3, height=-7, bits=32)
        self.assertEqual(result, 0)
        self.assertEqual((info.stride, info.top_down, info.bytes_per_pixel), (12, 1, 4))
        self.assertEqual(self.parse(width=3)[1].stride, 12)

    def test_rejects_compressed_indexed_truncated_and_invalid_dimensions(self):
        for kwargs in ({'compression': 1}, {'bits': 8}, {'size': 54}, {'offset': 12},
                       {'width': -1}, {'width': 4097}, {'height': 0}, {'height': -2147483648},
                       {'dib': 0xffffffff}):
            self.assertEqual(self.parse(**kwargs)[0], -1, kwargs)


if __name__ == '__main__':
    unittest.main()
