import importlib.util
import pathlib
import sys
import unittest


PROBE_PATH = pathlib.Path(__file__).parents[1] / "probes" / "limit_probe.py"
SPEC = importlib.util.spec_from_file_location("limit_probe", PROBE_PATH)
assert SPEC and SPEC.loader
probe = importlib.util.module_from_spec(SPEC)
sys.modules["limit_probe"] = probe
SPEC.loader.exec_module(probe)


class LimitParserTests(unittest.TestCase):
    def test_parses_claude_usage_without_spacing_after_percent(self):
        result = probe.parse_claude_usage(
            """
            Current session
            ████████ 19%used
            Resets 12pm (Europe/Berlin)
            Current week (all models)
            ███████ 18%used
            Resets Sep 10 at 2am (Europe/Berlin)
            +50% weekly limits promo
            """
        )

        self.assertTrue(result.ok)
        self.assertEqual([window.percent_left for window in result.windows], [81, 82])
        self.assertEqual(result.windows[1].resets, "Sep 10 at 2am (Europe/Berlin)")

    def test_parses_codex_status(self):
        result = probe.parse_codex_status(
            """
            5h limit: [████████] 89% left (resets 12:10)
            Weekly limit: [████████] 98% left (resets 07:10 on 15 Sep)
            """
        )

        self.assertTrue(result.ok)
        self.assertEqual([window.percent_used for window in result.windows], [11, 2])
        self.assertEqual(result.windows[0].resets, "12:10")


if __name__ == "__main__":
    unittest.main()
