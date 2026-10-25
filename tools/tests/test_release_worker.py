import importlib.util
from pathlib import Path
import unittest

spec = importlib.util.spec_from_file_location('release_worker', Path(__file__).parents[1] / 'release_worker.py')
worker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(worker)


class ReleaseChecks(unittest.TestCase):
    def test_final_timing_overrides_provisional_result(self):
        log = "Max frequency for clock 'clk_sys': 30 MHz (FAIL at 33.75 MHz)\nMax frequency for clock 'clk_sys': 40 MHz (PASS at 33.75 MHz)"
        self.assertTrue(worker.timing_ok(log))
        self.assertFalse(worker.timing_ok(log + "\nMax frequency for clock 'clk_p': 20 MHz (FAIL at 27 MHz)"))

    def test_missing_timing_is_not_a_release(self):
        self.assertFalse(worker.timing_ok('placement failed'))

    def test_bitstream_conversion_and_partition_bounds(self):
        data = worker.fs_bytes('// Gowin\n' + '10100101' * 100001)
        self.assertEqual(data, bytes([0xa5]) * 100001)
        for text in ('', '0101', 'not a bitstream', '00000000'):
            with self.assertRaises(ValueError):
                worker.fs_bytes(text)


if __name__ == '__main__':
    unittest.main()
