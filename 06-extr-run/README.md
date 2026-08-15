# World 6 · EXTR, run!

*Motion that feels kind; the maths of fair.*

This is the world where the maths stops drawing and starts **moving you**. The
game behind it, *EXTR, run!* (in development), is a hybrid endless runner with
an unusual heart: EXTR is a collective — a whole chorus of minds — downloaded
into one small, hyperactive alien whose assignment is to terraform planets, to
plan. Obstacles in her world are called **distractions**, and a distraction is
a spark, never a threat: wherever she veers, she creates something wonderful
that was never in the plan. The game offers infinite lives as a house rule, and
its difficulty advances only when a run is completed without taking a hit —
comfort earns the next step, never the clock.

That philosophy turns out to be *provable*. A runner is fair when the player is
given enough distance to react at the current speed — and "enough" is a number
you can compute, live, every frame. A lane change feels alive when its motion
accelerates and settles the way real things do — and "the way real things do"
is a small polynomial. A difficulty curve is kind when it grows like a
population with a ceiling — and that curve has had a name since 1838. Three
lessons, three short scripts, one endless-runner core with no fail state and no
meanness in it.

## The lessons

| # | Lesson | You will build | The maths you'll meet |
|---|---|---|---|
| 1 | [Speed, ramps, fairness](lesson-1-speed-ramps-fairness.md) | A cube that auto-runs with a speed readout and a gizmo line showing the warning distance the player is owed | v = v₀ + a·t, speed caps, reaction-time budgets (~250 ms) |
| 2 | [Lane changes that feel good](lesson-2-lane-changes-that-feel-good.md) | One lane mover, three feels — switch them in the Inspector mid-play | Lerp (a fraction of the way there), smoothstep 3t² − 2t³, Penner's ease-out cubic |
| 3 | [Difficulty as comfort](lesson-3-difficulty-as-comfort.md) | A difficulty dial that rises only after a no-hit run, printing its gentle decisions | The flow channel, Verhulst's logistic growth, shuffle bags |

Starter code lives in [`starter/`](starter/): one C# file per lesson —
[`RunnerSpeed.cs`](starter/RunnerSpeed.cs), [`LaneMover.cs`](starter/LaneMover.cs),
[`ComfortRamp.cs`](starter/ComfortRamp.cs). Each is a complete MonoBehaviour
you tune from the Inspector; no packages, no assets, no prefabs.

## Setting up Unity (one paragraph, honestly)

World 6 is the odd sibling: it runs on **Unity 2022 LTS or newer** (free
personal licence, [unity.com](https://unity.com)) because the real game does.
Every lesson uses the same three-step setup: make a new 3D project, open the
default empty scene, add one cube (GameObject → 3D Object → Cube), then drag
the lesson's starter script from `starter/` onto that cube and press Play. If
Unity asks a clarifying question about the file name — the class name and the
file name must match, e.g. `RunnerSpeed` inside `RunnerSpeed.cs` — rename one
to agree with the other and it will be satisfied. That is the entire setup;
everything else in this world is tuned by selecting the cube and nudging
fields in the Inspector while the game runs.

## House rules, inherited

Same as the rest of the classroom, doubled here because the game demands it:
nothing in these lessons punishes you. Every lesson has a marked **"You can
stop here."** line, and stopping there counts as finishing. The runner you
build cannot be failed — which is not a simplification for beginners; it is
the actual design of the actual game.

## Combined sources for this world

- **Secondary (free):** OpenStax, *College Physics* ([openstax.org](https://openstax.org)) —
  motion with constant acceleration; the home of v = v₀ + a·t.
- **Secondary (free):** R. J. Kosinski (2008), "A Literature Review on Reaction
  Time", Clemson University — a long-standing free web review; simple visual
  reaction times sit roughly in the 180–250 ms band, so we design at 250 ms
  and up.
- **Secondary (free):** Robert Penner's easing chapter
  ([robertpenner.com/easing](http://robertpenner.com/easing)) — the vocabulary
  of eased motion, including the ease-out cubic.
- **Primary (free):** Jenova Chen (2006), "Flow in Games", MFA thesis, USC —
  free online; maps difficulty-versus-skill onto the flow channel. Behind it:
  M. Csikszentmihalyi, *Flow* (1990).
- **Historical (name + date):** P. Verhulst (1838) — the logistic function:
  growth proportional to what's there *and* to the room left.
- **Design lore:** the Tetris Guideline's "Random Generator" (the 7-bag),
  community-documented — the shuffle-bag idea in its most famous outfit.
- **The game's own:** "EXTR, run! design documentation (in development)" — the
  comfort-ramp rule and the fiction↔systems vocabulary (distraction, focus,
  nourishment).

## Where this world sits

Long-form course: episodes **E16–E18**, with the finale **E19** right behind
them — the studio publishing for real. Short-form ladder: clips **11, 15, 18,
24**. Scripts for both live in [`video-youtube.md`](video-youtube.md) and
[`video-tiktok.md`](video-tiktok.md).
