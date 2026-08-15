# Six Small Worlds

*Learn the maths that grows games — one small world at a time.*

This is the public classroom for six games currently growing in one small studio.
Each "world" is a mini-series of written lessons with runnable starter code. You
build the signature system of each game yourself, from zero, and along the way you
meet the real mathematics underneath it — with sources, so you can retrace
everything we claim.

The games themselves are still in development. These lessons don't spoil them;
they teach you the machinery, and the machinery is yours to keep.

## Who this is for

Two kinds of student, deliberately:

- **The curious beginner.** You've never coded. Every lesson starts with pictures
  and intuition, and every line of code is explained. You can watch along without
  typing anything and still leave with the idea.
- **The coder with rusty maths.** You can read a script, but "phyllotaxis" and
  "L-system" are strangers. The maths boxes and the source lists are for you.

If a lesson ever feels like too much: every lesson has a marked **"you can stop
here"** line. Stopping there still counts as finishing.

## What you need

- **Godot 4.3+** (free, ~100 MB, [godotengine.org](https://godotengine.org)) for
  worlds 1–5. Every starter file is a single script on a single node — no assets,
  no plugins, nothing to download beyond the engine.
- **Unity 2022 LTS or newer** (free personal licence) for world 6 only.
- No maths prerequisites past knowing what sin and cos look like on a calculator.
  Anything else, we build on the spot.

## The six worlds

| # | World | From the game | You will build | The maths you'll meet |
|---|---|---|---|---|
| 1 | [equanim](01-equanim/) | *equanim* — a calm gallery of turning mathematics | A turning wireframe gallery card | Parametric curves, the superformula, rotating 3D to 2D |
| 2 | [upgrade Biotech](02-upgrade-biotech/) | *upgrade Biotech* — an idle game of two curious immortals | A colony that grows by one rule | Vogel's phyllotaxis, rose curves, cellular automata, times-table circles |
| 3 | [Tidepool Keeper](03-tidepool-keeper/) | *Tidepool Keeper* — a pocket tidepool you keep kind | Creatures that visit while you're away and dance their thanks | Spirals (Archimedean vs logarithmic), Poisson arrivals, the tide clock |
| 4 | [An Isolate Grows Roots](04-an-isolate-grows-roots/) | *An Isolate Grows Roots* — a shy flower grows a forest of friends | Roots that grow one deliberate turn at a time | Turtle graphics, L-systems, easing |
| 5 | [Friendly Waters](05-friendly-waters/) | *Friendly Waters* — two friends cross the ocean in opposite directions | Light that fades with depth, currents, and a school of fish | Exponential attenuation, vector fields, boids |
| 6 | [EXTR, run!](06-extr-run/) | *EXTR, run!* — a hyperactive alien terraformer on assignment | A fair, kind endless-runner core | Kinematics, easing, reaction-time budgets, difficulty as comfort |

Worlds are ordered so each one's maths leans on the last. Start at 1 if you're
new; drop in anywhere if you're not.

## The two courses

- **[Long-form course](00-course/longform-youtube.md)** — the full journey,
  episode by episode (YouTube or any long-video home). Ends with the real
  publication of a real game from this studio.
- **[Short-form mini-course](00-course/shortform-tiktok.md)** — the same worlds
  in 15–60 second bites (TikTok / Shorts / Reels). Every clip stands alone;
  together they form a ladder into the long course.

## Beyond the lessons

- **[Build Your Own World](00-course/build-your-own.md)** — the bridge from
  following along to making a game of yours: the one-rule rule, a five-rung
  sketch ladder for building quickly, and three disciplines for building well.
- **[Fun-ishment: a field guide](00-course/design-contrast.md)** — the
  punitive machinery most modern games run on (streaks, decay, FOMO timers,
  the escalating drip), each pattern named and sourced — and, world by world,
  what these six games do with the same mathematical levers instead.
- **[Playtest](playtest/)** — run `python playtest/sim.py` and every starter's
  mathematics is re-checked against the exact claims its lesson makes; 38
  checks, no engine needed. Also a worked example of testing your own game's
  maths, per Build Your Own World.

## House rules of this classroom

1. **Forgiving by default.** Nothing here shames you for not knowing. "Beginner"
   is a starting line, not a level.
2. **One new idea per step.** If a step needs two ideas, it becomes two steps.
3. **Sources or it didn't happen.** Every mathematical claim traces to a primary
   or secondary source listed at the end of the lesson — and we prefer sources
   you can read for free, legally, today.
4. **Everything runs.** Starter code is complete files, not fragments. Paste,
   press play, see the thing.
5. **No pressure mechanics.** Like the games themselves: no streaks, no
   deadlines, nothing expires. The lessons wait for you.

## Licence

Code: MIT. Lesson text and video scripts: CC BY 4.0. The six games themselves
are **not** part of this licence; they remain the studio's own.
