# World 2 · upgrade Biotech — growth by one rule

*Three lessons. Four small rules. An idle game's entire visual world, grown in
front of you.*

## The world in one paragraph

*upgrade Biotech* is an idle game about two immortals in a world of
hyper-abundance, curing their boredom by cosmetically evolving — and eventually
reaching outward to go and look at things. It is built in Godot 4, roughly
33,000 lines of GDScript across 108 scripts, and it ships with **no binary
assets at all**: no sprites, no textures, no audio files. Every flower, page,
habitat and find in it is drawn, live, by mathematics. Its four collections are
four families of maths — the **Garden** is 26 rose-curve flowers, the
**Cabinet** is 64 Lissajous pages, the **Atlas** is 52 cellular-automata
habitats, and the **Expedition** is 104 times-table circles. And it keeps an
anti-chore contract with its player: no streaks, no daily anything, no offline
cap, nothing that expires. These lessons are taught under the same contract.
Every one has a marked **"you can stop here"** line, and stopping there counts
as finishing.

## What grows in this world

The theme of the series is **growth by one rule**. Each lesson hands you a rule
small enough to say out loud, and then you watch it produce more than it has
any right to.

- **[Lesson 1 · The Sunflower Rule](lesson-1-the-sunflower-rule.md)** — a
  colony accretes cell by cell before your eyes, packed the way a sunflower
  packs seeds: turn 137.508°, step out √n, place a cell. Vogel's phyllotaxis,
  1979, eleven lines of code.
- **[Lesson 2 · A Garden From an Equation](lesson-2-a-garden-from-an-equation.md)**
  — a 26-flower garden from `r = cos(kθ)`, one flower per letter of the
  alphabet, exactly the family that grows the game's Garden. Then a second
  small machine: times-table circles, where the two-times table folds itself
  into a heart.
- **[Lesson 3 · Worlds From Neighbours](lesson-3-worlds-from-neighbours.md)** —
  an entire habitat texture from one lookup rule. Elementary cellular automata:
  one row of cells, one byte, and Rule 90 grows the Sierpinski triangle down
  your screen. The same family grows the game's Atlas.

One family is missing on purpose: the Cabinet's Lissajous figures were World
1's opening episode. If you drew along there, you have already built a quarter
of this game's visual language without knowing it.

## Lesson index

| # | Lesson | Promise | Starter code | Long course |
|---|---|---|---|---|
| 1 | [The Sunflower Rule](lesson-1-the-sunflower-rule.md) | A colony accretes cell by cell before your eyes | [`starter/phyllotaxis.gd`](starter/phyllotaxis.gd) | E04 |
| 2 | [A Garden From an Equation](lesson-2-a-garden-from-an-equation.md) | 26 flowers from one equation, then a heart made of straight lines | [`starter/rose_garden.gd`](starter/rose_garden.gd) · [`starter/times_table.gd`](starter/times_table.gd) | E05 |
| 3 | [Worlds From Neighbours](lesson-3-worlds-from-neighbours.md) | An entire habitat texture from one lookup rule | [`starter/rule90.gd`](starter/rule90.gd) | E06 |

**Videos.** [`video-youtube.md`](video-youtube.md) holds the full scripts for
long-course episodes E04–E06. [`video-tiktok.md`](video-tiktok.md) holds this
world's four short clips — Hook, Build, Twist, Bridge, ladder positions 1, 3,
7 and 19 in the short course. The first three orbit Lesson 1's rule; the
Bridge pans across all three lessons and points home.

## Running the starters

1. Install **Godot 4.3 or newer** (free, [godotengine.org](https://godotengine.org)).
2. New project → new scene → add a single **Node2D** → attach a script.
3. Paste any starter file over the script's contents. Press **F5**.

No assets, no plugins, no downloads. If the engine underlines something in red,
that's the computer asking a clarifying question — the usual answers are a
missed line or a tab that became spaces.

## House rules, restated

Nothing in this world expires, streaks do not exist, and the lessons wait for
you. Each one marks the exact line where a satisfying build already runs;
everything past that line is a gift, not a debt. If your spiral comes out
lopsided or your triangle leans, you are most of the way there — lopsided
means it's drawing.

## Combined sources for this world

Every claim in the three lessons traces to one of these. Each lesson repeats
the ones it uses.

- **Primary:** H. Vogel, "A better way to construct the sunflower head",
  *Mathematical Biosciences* 44:179–189, 1979. The planted-spiral model —
  divergence angle 137.5°, radius proportional to √n.
- **Primary:** S. Wolfram, "Statistical mechanics of cellular automata",
  *Reviews of Modern Physics* 55:601–644, 1983. Elementary cellular automata,
  the 0–255 rule numbering, and Rule 90's self-similar triangle.
- **Historical:** G. Grandi, *Flores geometrici*, 1728. The rose ("rhodonea")
  curves, named by the man who studied them.
- **Secondary (free):** P. Prusinkiewicz & A. Lindenmayer, *The Algorithmic
  Beauty of Plants*, ch. 4 on phyllotaxis — free PDF at
  [algorithmicbotany.org](http://algorithmicbotany.org/papers/#abop).
- **Secondary (free):** MacTutor History of Mathematics archive, University of
  St Andrews — Grandi's biography and the rhodonea curve pages, including the
  odd/even petal-count rule.
- **Secondary (free):** S. Wolfram, *A New Kind of Science* — readable free at
  [wolframscience.com](https://www.wolframscience.com/nks/), for Rule 30's
  chaos and the wider elementary-automata gallery.
- **Secondary (free):** Mathologer, "Times Tables, Mandelbrot and the Heart of
  Mathematics", YouTube, 2015 — the cardioid hiding in the two-times table.
- **Secondary (free):** Anthony Pecorella, "The Math of Idle Games", GDC talk
  series, free on the GDC YouTube channel — cited once, for how idle games
  price their upgrades.
- **House favourite:** Daniel Shiffman, *The Nature of Code* (free,
  [natureofcode.com](https://natureofcode.com)) — a friendly companion for
  turning any of this maths into moving pictures.

## Spoiler stance

These lessons name the game, its four catalogue shapes, and its anti-chore
contract — store-page material, all of it. They do not touch its story, its
upgrade list, or the solutions to its gate puzzles. You are learning the
machinery, and the machinery is yours to keep.
