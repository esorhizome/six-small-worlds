# World 4 · An Isolate Grows Roots — patience as a mechanic

*Three lessons · Godot 4.3+ · everything drawn in code · episodes E10–E12 of
the [long course](../00-course/longform-youtube.md)*

## The world

*An Isolate Grows Roots* is a cozy game currently growing in this studio.
Florence — a humanoid flower whose meadow was dug up by a wedding florist —
has been replanted at the lonely edge of an unfamiliar forest, certain his
neighbours are menacing. (They aren't. They're curious, and terrible at
introductions.) He grows a forest of friends where there were strangers.

The system you'll build here is the game's quietest, proudest trick:
**the progress bar is alive.** Florence's growing root-legs *are* his
progress, drawn live as a root system — no filling rectangle anywhere. And
growth happens **one deliberate turn at a time**: you act, the roots surge
and settle, and if you tap again mid-turn the game politely declines.
Patience isn't the tutorial's advice. Patience is the mechanic.

By the end of this world you will have built exactly that, from zero:

1. a pen that walks (turtle graphics),
2. a grammar that grows plants from one rewrite rule (L-systems),
3. growth that bursts, rests, and refuses to be hurried (easing + turns).

## The lessons

| # | Lesson | Promise | Starter file |
|---|---|---|---|
| 1 | [Teach a turtle to walk](lesson-1-teach-a-turtle-to-walk.md) | A fern sprig from four commands — and your initials on the way | [`starter/turtle.gd`](starter/turtle.gd) |
| 2 | [The grammar of plants](lesson-2-the-grammar-of-plants.md) | A branching plant from one rewrite rule | [`starter/lsystem.gd`](starter/lsystem.gd) |
| 3 | [One turn at a time](lesson-3-one-turn-at-a-time.md) | Growth that bursts, then rests — and refuses to be hurried | [`starter/one_turn.gd`](starter/one_turn.gd) |

Each lesson has a marked **"you can stop here"** line, and stopping there
counts as finishing. That's a repo-wide rule, but in this world it's also
the subject matter.

## Running the starters

Every starter is one complete script for one `Node2D` — no scenes, no
assets, no plugins.

1. Open Godot 4.3+, make a new empty project.
2. Add a `Node2D` to a new scene, attach the script, paste the file in.
3. Press F5 (run), pick the current scene when asked.

If something red appears in the output panel, that's the computer asking a
clarifying question, not a verdict. The lessons walk through the polite
answers.

## Where this world sits

The course orders its maths so each world leans on the last: world 3's
spirals were curves that grow by rule, and this world grows *structures* by
rule. World 5 will borrow lesson 3's easing the moment anything underwater
needs to move like it's alive.

## Videos

- [`video-youtube.md`](video-youtube.md) — full scripts for episodes
  E10 · *Teach a turtle to walk*, E11 · *The grammar of plants*,
  E12 · *One turn at a time*.
- [`video-tiktok.md`](video-tiktok.md) — the four short clips
  (Hook · Build · Twist · Bridge).

## Combined sources for this world

- **Primary:** A. Lindenmayer, "Mathematical models for cellular
  interactions in development, Parts I–II", *Journal of Theoretical
  Biology* 18:280–315, 1968. Introduced the parallel rewriting systems
  ("L-systems") this whole world runs on.
- **Primary (and charming):** C. Darwin & F. Darwin, *The Power of Movement
  in Plants*, 1880. The root tip really does sense and steer. Free at
  [darwin-online.org.uk](https://darwin-online.org.uk).
- **Secondary (free, the course's bible):** P. Prusinkiewicz &
  A. Lindenmayer, *The Algorithmic Beauty of Plants*, Springer, 1990. Free
  PDF at [algorithmicbotany.org/papers/#abop](http://algorithmicbotany.org/papers/#abop).
  Chapter 1 covers everything lessons 1–2 teach, with pictures worth the
  visit alone.
- **Secondary:** H. Abelson & A. diSessa, *Turtle Geometry*, MIT Press,
  1981. The book-length case that walking a pen is real mathematics.
- **Secondary (name + date):** S. Papert, *Mindstorms*, 1980 — where the
  Logo turtle's story is told by its inventor.
- **Secondary (free):** Robert Penner's easing chapter, free at
  [robertpenner.com/easing](http://robertpenner.com/easing) — the origin of
  the easing functions in lesson 3.
- **Secondary (free, house favourite):** Daniel Shiffman, *The Nature of
  Code*, free at [natureofcode.com](https://natureofcode.com) — the fractals
  chapter is a friendly second angle on L-systems.
