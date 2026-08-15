# Build Your Own World — from these lessons to a game of yours

*You have drawn a colony, grown a root, schooled sixty fish. This page is the
bridge from "I followed along" to "I made a thing that is mine" — quickly,
and well. The two are not in tension; the trick is knowing which one each
hour of work is for.*

## The one-rule rule

Every world in this course is a game whose visual and mechanical heart is
**one rule small enough to say out loud**:

- *turn 137.5°, step out √n* → a sunflower colony
- *each cell reads three parents, looks up one byte* → an entire habitat
- *three wishes: keep distance, match heading, drift to centre* → a school
- *step only after an unhurt run, step size r·d·(1−d)* → fair difficulty

So here is the whole method: **pick one rule, and spend your first session
making that rule visible.** Not a menu, not a save system, not a name. The
rule, on screen, moving. Every starter file in this repo is under about 80
lines — that is not a limitation we suffered, it is the size a heart turns
out to be.

If you cannot say your game's rule out loud yet, that is your first task,
and it costs zero code: finish the sentence *"the thing that grows is ___,
and it grows by ___."*

## Build quickly: the sketch ladder

Climb one rung per sitting. Every rung runs; every rung could be the last,
and stopping on any rung counts as finishing — the same contract as the
lessons.

1. **Rung 1 — the rule draws.** One script, one node, `_draw()`. Steal the
   skeleton of any starter here (they are MIT-licensed for exactly this).
   Constants at the top, named, with units in the comments.
2. **Rung 2 — the rule responds.** One input: a click, a held key, a drag.
   Watch how [phyllotaxis.gd](../02-upgrade-biotech/starter/phyllotaxis.gd)
   added "pour" — five lines, and suddenly it's a toy.
3. **Rung 3 — the rule remembers.** One number persists: a count, a level,
   a best. Now it's a game loop.
4. **Rung 4 — the rule greets you.** A title line, a restart, one sentence
   of instruction *in the world's own voice*. Now it's a game.
5. **Rung 5 — someone else plays it.** Watch them in silence. Where they
   frown, the game owes a clarifying answer — not the player an apology.

Two sessions per rung is a fine pace. Ten sittings to a playable, honest
thing beats ten weeks of scaffolding for a game that never appears.

## Build well: the three disciplines

Speed without these three turns into rework; with them, speed compounds.

**1. Name every number.** The starters here never write `137.508` twice —
it is `GOLDEN_ANGLE_DEG`, once, with a comment saying where it came from.
The first thing you will do to your game is *tune* it, and you can only tune
dials that have labels. In Godot, promote your favourites to `@export` and
tune while it runs, the way
[superformula.gd](../01-equanim/starter/superformula.gd) does.

**2. Test the maths without the engine.** Your rule fits in a plain
function, and plain functions can be checked in milliseconds. This repo's
own [playtest/sim.py](../playtest/sim.py) does this for all six worlds —
38 checks, no engine booted. The pattern to steal:

- *Port the rule* into a few lines of Python (or a second GDScript file).
- *State the invariant* — the sentence that must stay true: "speeds stay
  between MIN and MAX", "the dial never leaves its rails", "generation 4
  is 1,551 symbols".
- *Assert it* across the whole input range, with fixed seeds.

When a tuning session breaks something at midnight, the invariant catches it
at midnight, not in a player's review.

**3. Let errors be clarifying questions.** The turtle in World 4 meets a
`]` with no `[` and carries on, printing one line about it. Decide, for
your game, what refusal looks like — a ring, a shrug, a gentle sound — and
make it part of the world's voice. A crash scolds; a well-designed refusal
teaches.

## The kindness check

Before you bolt on any retention mechanic, take it through the three
questions in [the fun-ishment field guide](design-contrast.md): does it
reward presence or punish absence, who owns the clock, and would it survive
being explained? Build whatever you conclude — but conclude it on purpose,
with the pattern named, rather than inheriting the decade's defaults by
copy-paste.

## Scope: the "you can stop here" for projects

Lessons here mark the line where a satisfying build already runs. Projects
deserve the same mercy. Write yours down *before* you start:

> *"This project is finished when the rule is visible, responds to one
> input, and remembers one number."*

Everything past that line is a gift, not a debt. Six games are being built
alongside this course on exactly that contract — it scales.

## When you get stuck

- **The rule won't draw?** Return to the nearest starter file and change one
  constant at a time until it looks like your idea. That is not cheating;
  that is how the starters were written.
- **The maths fights back?** Every lesson's Sources section lists a free
  secondary source chosen for readability. Shiffman's *Nature of Code* and
  *The Algorithmic Beauty of Plants* cover most of what a small world needs.
- **Lost the thread entirely?** Post the sentence — "the thing that grows is
  ___, and it grows by ___" — wherever the course community lives, and
  someone will hand you your rule back, smaller.

A lopsided first build means it's building. Ship the sketch.
