from __future__ import annotations

import json
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

THEMES_DIR = Path(__file__).resolve().parents[1]


class GeneratorTests(unittest.TestCase):
    def setUp(self) -> None:
        self.temporary = tempfile.TemporaryDirectory()
        self.repo = Path(self.temporary.name) / "repo"
        self.root = self.repo / "themes"
        shutil.copytree(
            THEMES_DIR, self.root, ignore=shutil.ignore_patterns("__pycache__")
        )
        shutil.copytree(
            THEMES_DIR.parent / "stow" / "ghostty-themes",
            self.repo / "stow" / "ghostty-themes",
        )
        self.generator = self.root / "generate.py"

    def tearDown(self) -> None:
        self.temporary.cleanup()

    def run_generator(self, *arguments: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(self.generator), *arguments],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False,
        )

    def test_committed_outputs_are_current(self) -> None:
        result = self.run_generator("check")
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_missing_ansi_slot_is_rejected(self) -> None:
        definition = self.root / "definitions" / "clarity-paper.json"
        value = json.loads(definition.read_text())
        del value["palette"]["bright"]["cyan"]
        definition.write_text(json.dumps(value))

        result = self.run_generator("check")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("missing fields: cyan", result.stderr)

    def test_invalid_active_selection_is_rejected(self) -> None:
        selection = self.root / "selection.json"
        value = json.loads(selection.read_text())
        value["light"] = "clarity-dusk"
        selection.write_text(json.dumps(value))

        result = self.run_generator("check")

        self.assertNotEqual(result.returncode, 0)
        self.assertIn("is not a light theme", result.stderr)

    def test_check_detects_stale_and_extra_artifacts(self) -> None:
        paper = self.repo / "stow" / "ghostty-themes" / "clarity-paper"
        paper.write_text(paper.read_text() + "# stale\n")
        (paper.parent / "removed-theme").write_text("background = #000000\n")

        result = self.run_generator("check")

        self.assertEqual(result.returncode, 1)
        self.assertIn("stale: stow/ghostty-themes/clarity-paper", result.stderr)
        self.assertIn("unexpected: stow/ghostty-themes/removed-theme", result.stderr)

    def test_generate_removes_stale_artifacts_and_is_deterministic(self) -> None:
        generated = self.repo / "stow" / "ghostty-themes"
        extra = generated / "removed-theme"
        extra.write_text("background = #000000\n")
        first = self.run_generator("generate")
        self.assertEqual(first.returncode, 0, first.stderr)
        snapshot = {
            path.relative_to(self.repo): path.read_text()
            for path in sorted(generated.iterdir())
        }

        second = self.run_generator("generate")

        self.assertEqual(second.returncode, 0, second.stderr)
        self.assertFalse(extra.exists())
        self.assertEqual(
            snapshot,
            {
                path.relative_to(self.repo): path.read_text()
                for path in sorted(generated.iterdir())
            },
        )
        viewer_data = (self.root / "viewer" / "themes.generated.js").read_text()
        self.assertEqual(viewer_data.count('"id": "clarity-'), 4)


if __name__ == "__main__":
    unittest.main()
