# Playtest — proof the lessons build what they promise

Two small tools, standard-library Python 3.10+, no installs:

```bash
python playtest/sim.py
```

**The simulator** re-runs the mathematics of every starter file in this repo —
no Godot, no Unity — and checks it against the exact claims the lessons make.
Thirty-eight checks, fixed seeds, same verdict on every machine. A sample:

- Rule 90 really grows Pascal's triangle mod 2 (compared cell by cell).
- The golden angle really packs a colony without collisions — and 137.3°
  really grows the arms the lesson warns about.
- The L-system's fourth generation really is 1,551 symbols.
- Sixty boids really do align (polarization 0.16 → 0.81 in 25 s), and no fish
  ever leaves its speed limits.
- The comfort ramp really saturates inside its rails, and the owed-sight
  fairness floor holds at every dial position.

```bash
python playtest/lint.py
```

**The linter** holds the repo to its own public teaching contract
([STYLE.md](../STYLE.md)): banned words stay banned, every lesson keeps its
"you can stop here" line, its "Check yourself" and its "Sources", and starter
files stay near the 80-line target.

## Why this exists

Two reasons, one per audience:

1. **For this classroom** — lessons and starter code are written separately,
   and separate things drift. The simulator is the tripwire: if a claim and
   its code disagree, publishing waits.
2. **For you** — this is a worked example of testing game mathematics without
   booting an engine. Your game's heart is (we hope, by now) a handful of
   small rules; small rules fit in plain functions, and plain functions can be
   checked in milliseconds. Steal the pattern: port the rule, state the
   invariant, assert it. The
   [Build Your Own World](../00-course/build-your-own.md) guide walks
   through doing this for a game of yours.

If a check ever fails, the failure names the lesson whose claim drifted.
That is the computer asking a clarifying question — not a verdict on you.
