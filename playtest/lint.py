#!/usr/bin/env python3
"""lint.py — checks this repo against its own teaching contract (STYLE.md).

The contract is public, so the checker is too. Run from the repo root:

    python playtest/lint.py

What it enforces (each rule cites the STYLE.md section it comes from):

- Voice: the banned words never appear in teaching text.
- Lesson anatomy: every lesson has its "you can stop here" line, a
  "Check yourself" section, and a "Sources" section.
- Starter files: every one opens with a comment block and offers its
  "one thing to try changing".
- Starter length: the ~80-line target, with a small forgiveness margin —
  a file past the margin is trying to teach two things.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

ROOT = Path(__file__).resolve().parent.parent

# STYLE.md "Voice": banned in teaching text. STYLE.md itself is exempt (it
# has to name them to ban them), and so is this folder.
BANNED = re.compile(r"\b(simply|just|obviously|easy|easier|trivial|trivially)\b",
                    re.IGNORECASE)
EXEMPT = {"STYLE.md"}

# STYLE.md "Godot starter-code rules": target ~80 lines. We allow drift to
# 110 before complaining — guards and comments earn their keep.
MAX_STARTER_LINES = 110

PROBLEMS: list[str] = []


def problem(path: Path, message: str) -> None:
    PROBLEMS.append(f"{path.relative_to(ROOT)} — {message}")


def lint_markdown() -> None:
    for path in sorted(ROOT.rglob("*.md")):
        if path.name in EXEMPT or "playtest" in path.parts:
            continue
        text = path.read_text(encoding="utf-8")
        for i, line in enumerate(text.splitlines(), 1):
            hit = BANNED.search(line)
            if hit:
                problem(path, f"line {i}: banned word \"{hit.group(0)}\" "
                              "(STYLE.md · Voice)")
        if path.name.startswith("lesson-"):
            lowered = text.lower()
            if "you can stop here" not in lowered:
                problem(path, "no \"you can stop here\" line "
                              "(STYLE.md · Lesson anatomy 6)")
            if "check yourself" not in lowered:
                problem(path, "no \"Check yourself\" section "
                              "(STYLE.md · Lesson anatomy 8)")
            if "## sources" not in lowered:
                problem(path, "no \"Sources\" section "
                              "(STYLE.md · Lesson anatomy 9)")


def lint_starters() -> None:
    for path in sorted(ROOT.rglob("starter/*")):
        if path.suffix not in (".gd", ".cs"):
            continue
        lines = path.read_text(encoding="utf-8").splitlines()
        first = lines[0].lstrip() if lines else ""
        if not (first.startswith("#") or first.startswith("/*")):
            problem(path, "does not open with the comment block "
                          "(STYLE.md · starter-code rules)")
        head = "\n".join(lines[:12]).lower()
        if "try" not in head:
            problem(path, "no \"one thing to try changing\" in the header "
                          "(STYLE.md · starter-code rules)")
        if len(lines) > MAX_STARTER_LINES:
            problem(path, f"{len(lines)} lines — past the ~80-line target "
                          "and the forgiveness margin; it may be teaching "
                          "two things (STYLE.md · starter-code rules)")


def main() -> int:
    lint_markdown()
    lint_starters()
    if PROBLEMS:
        print("The classroom drifted from its contract in "
              f"{len(PROBLEMS)} place(s):\n")
        for p in PROBLEMS:
            print("  " + p)
        print("\n(Each note names the STYLE.md rule it comes from.)")
        return 1
    print("Every file keeps the teaching contract (STYLE.md).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
