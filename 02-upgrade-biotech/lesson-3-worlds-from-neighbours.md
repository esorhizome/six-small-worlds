# Lesson 3 · Worlds From Neighbours

*By the end of this lesson, an entire habitat texture will grow down your
screen — woven from one rule so small it fits in a single byte.*

## If this is your first time

This lesson needs no trigonometry at all — no angles, no sin, no cos, and
nothing from Lessons 1 or 2 except the setup ritual (new project → one Node2D
→ attach script → F5). If you can read a bus timetable, you can read today's
entire mathematical machinery. It is a table with eight rows.

## See it first

Think of a row of knitting. Every stitch in the new row is decided by the
stitches directly above it — you look up, you follow the pattern, you knit.
Row after row, a texture emerges that nobody drew: it was *implied* by the
pattern rule, and the knitting merely worked out the consequences.

Now shrink the idea to its bones. A row of cells, each either **on** (■) or
**off** (·). To build the next row, every new cell looks at exactly three
cells above it — upper-left, directly above, upper-right — and consults a
rule that says, for each of the eight things it might see, whether to be on
or off. That's everything. No randomness, no memory, no artist.

The astonishment — and the reason a whole physics literature exists about
these things — is what the consequences look like. One such rule grows a
lace of nested triangles that mathematicians knew a century before computers.
A neighbouring rule grows static so convincingly random it has been used as a
random-number generator. The difference between those two universes is a
handful of flipped bits.

*upgrade Biotech* grows its whole Atlas this way: 52 alien habitats, each one
stored as a single integer. Today you build the loom.

## The maths, small

> **New symbols: 2.**
>
> - **p** — the pattern number: what a cell sees above it, read as a number
>   from 0 to 7. Left neighbour counts 4, the cell directly above counts 2,
>   right neighbour counts 1. See all three on: p = 4 + 2 + 1 = 7. See only
>   the right one: p = 1. See nothing: p = 0.
> - **R** — the rule, a number from 0 to 255. Written in binary, R is eight
>   bits — and bit number p is the answer to pattern p. The rule *is* the
>   lookup table, folded into one byte.
>
> **The rule, in a picture made of words — here R = 90:**
>
> | what the cell sees above (left · above · right) | pattern p | Rule 90 says |
> |---|---|---|
> | ■ ■ ■ | 7 | · |
> | ■ ■ · | 6 | ■ |
> | ■ · ■ | 5 | · |
> | ■ · · | 4 | ■ |
> | · ■ ■ | 3 | ■ |
> | · ■ · | 2 | · |
> | · · ■ | 1 | ■ |
> | · · · | 0 | · |
>
> **In plain English:** read the right-hand column top to bottom as binary —
> off, on, off, on, on, off, on, off — and you get 01011010, which is the
> number 90. The table is the number; the number is the world. Eight rows,
> two choices each, 2⁸ = 256 possible rules, and Wolfram's 1983 paper is
> where this numbering scheme comes from.

Stare at Rule 90's column a moment longer and a shortcut appears: the new
cell is **on exactly when one, and only one, of its two outer neighbours is
on**. (Check: ■·■ gives off; ■·· gives on.) Programmers call that operation
XOR — "one or the other but not both". Rule 90 is XOR wearing a byte.

## Build it

### Step 1 — a world one row tall

A world, at minimum: a row of cells, all off except one in the middle, drawn
as squares.

```gdscript
extends Node2D

const CELL_SIZE := 6.0
const ON_COLOR := Color(0.6, 0.9, 0.75)

var cols := 0
var first := PackedInt32Array()

func _ready() -> void:
	cols = int(get_viewport_rect().size.x / CELL_SIZE)
	first.resize(cols)          # a PackedInt32Array starts all zeroes
	first[int(cols / 2.0)] = 1  # one seed cell, centre stage

func _draw() -> void:
	for x in cols:
		if first[x] == 1:
			draw_rect(Rect2(float(x) * CELL_SIZE, 0.0, CELL_SIZE, CELL_SIZE),
					ON_COLOR, true)
```

Run it.

**You should see:** one small square at the top centre of the window. A
humble start — but that square is a *seed*, in precisely the sense Lesson 1's
cells were, and everything that follows grows from it.

### Step 2 — the lookup, and the whole cloth at once

Now the loom. `_next_row()` builds each child row from its parent: for every
cell, gather the three parents, compute the pattern number p, and read bit p
of RULE — that `(RULE >> p) & 1` line shifts the byte right p places and
keeps the last bit, which is exactly "look up row p of the table". The edges
wrap around, so the leftmost cell treats the rightmost as its neighbour. We
compute every row once, up front, and draw them all.

```gdscript
extends Node2D

const RULE := 90       # 0..255 — the whole world in one byte
const CELL_SIZE := 6.0
const ON_COLOR := Color(0.6, 0.9, 0.75)

var grid: Array[PackedInt32Array] = []
var cols := 0
var rows_total := 0

func _ready() -> void:
	var view := get_viewport_rect().size
	cols = int(view.x / CELL_SIZE)
	rows_total = int(view.y / CELL_SIZE)
	var first := PackedInt32Array()
	first.resize(cols)
	first[int(cols / 2.0)] = 1
	grid.append(first)
	for _y in rows_total - 1:
		grid.append(_next_row(grid[grid.size() - 1]))

func _next_row(parent: PackedInt32Array) -> PackedInt32Array:
	var child := PackedInt32Array()
	child.resize(cols)
	for x in cols:
		var left := parent[(x - 1 + cols) % cols]  # the row wraps at the edges
		var mid := parent[x]
		var right := parent[(x + 1) % cols]
		var pattern := left * 4 + mid * 2 + right  # 0..7, the parents as binary
		child[x] = (RULE >> pattern) & 1           # read bit `pattern` of RULE
	return child

func _draw() -> void:
	for y in rows_total:
		for x in cols:
			if grid[y][x] == 1:
				draw_rect(Rect2(float(x) * CELL_SIZE, float(y) * CELL_SIZE,
						CELL_SIZE, CELL_SIZE), ON_COLOR, true)
```

Run it.

**You should see:** the **Sierpinski triangle** — a triangle built of three
smaller triangles, each built of three smaller ones, down to the pixel —
filling the window instantly. Nobody drew a triangle. The eight-row table
implied it, and your loop worked out the implication a hundred rows deep. If
your triangle leans or has a torn edge, celebrate first (a leaning triangle
means the loom works) and then check the pattern line: left counts 4, middle
2, right 1, in that order.

### Step 3 — let it grow

A texture that appears complete is wallpaper. A texture that *grows* is a
habitat. Same trick as Lesson 1: a counter of visible rows rises with the
clock, and the world knits itself downward. This full file is
[`starter/rule90.gd`](starter/rule90.gd), byte for byte — including a
`SEED_MODE` dial we'll turn later.

```gdscript
# rule90.gd — Six Small Worlds · World 2 · Lesson 3: Worlds From Neighbours
# Grows an elementary cellular automaton down the screen, one row per tick.
# Every new cell reads its three parents (left, self, right) and looks its fate
# up in one byte: RULE. 90 grows the Sierpinski triangle; 30 grows chaos —
# the same family that grows the Atlas habitats in upgrade Biotech.
# One thing to try changing: RULE → 30, 110 or 184; or SEED_MODE → "random".

extends Node2D

const RULE := 90              # 0..255 — the whole world in one byte
const CELL_SIZE := 6.0        # pixel size of one cell
const ROWS_PER_SECOND := 20.0 # growth speed down the page
const SEED_MODE := "centre"   # "centre" = one live cell; "random" = noise row
const RANDOM_SEED := 26       # fixed, so "random" grows the same world each run
const ON_COLOR := Color(0.6, 0.9, 0.75)

var grid: Array[PackedInt32Array] = []
var cols := 0
var rows_total := 0
var rows_shown := 0.0

func _ready() -> void:
	var view := get_viewport_rect().size
	cols = int(view.x / CELL_SIZE)
	rows_total = int(view.y / CELL_SIZE)
	var first := PackedInt32Array()
	first.resize(cols)
	if SEED_MODE == "random":
		seed(RANDOM_SEED)
		for x in cols:
			first[x] = randi() % 2
	else:
		first[int(cols / 2.0)] = 1
	grid.append(first)
	for _y in rows_total - 1:
		grid.append(_next_row(grid[grid.size() - 1]))

func _next_row(parent: PackedInt32Array) -> PackedInt32Array:
	var child := PackedInt32Array()
	child.resize(cols)
	for x in cols:
		var left := parent[(x - 1 + cols) % cols]  # the row wraps at the edges
		var mid := parent[x]
		var right := parent[(x + 1) % cols]
		var pattern := left * 4 + mid * 2 + right  # 0..7, the parents as binary
		child[x] = (RULE >> pattern) & 1           # read bit `pattern` of RULE
	return child

func _process(delta: float) -> void:
	if rows_shown < float(rows_total):
		rows_shown = minf(rows_shown + ROWS_PER_SECOND * delta, float(rows_total))
		queue_redraw()

func _draw() -> void:
	for y in int(rows_shown):
		var row := grid[y]
		for x in cols:
			if row[x] == 1:
				draw_rect(Rect2(float(x) * CELL_SIZE, float(y) * CELL_SIZE,
						CELL_SIZE, CELL_SIZE), ON_COLOR, true)
```

Run it — and watch the whole thing.

**You should see:** the triangle knit itself downward, row by row, about five
seconds from seed to full screen. Growth downward is not a visual effect
bolted on: it is *how the mathematics actually proceeds*, one generation per
row. You are watching computation happen at a speed the eye can follow.

**You can stop here.** Rule 90 has filled your screen from a single cell and
one byte. Everything below is bonus — and the bonus is a plot twist.

### Step 4 (bonus) — one number, new universe

Change one line: `RULE := 30`. Run it.

**You should see:** chaos. Not messiness — *chaos*, structured on the left
flank, boiling on the right, never repeating, from the same single seed and
the same loom. Rule 30 is the famous one: its central column behaves so
unpredictably that it has served as a random-number source, and *A New Kind
of Science* spends many free-to-read pages on why a byte can do this. Then
try `RULE := 110` (scaffolding and gliders — a rule proven capable, in
principle, of any computation at all) and `RULE := 184` (the traffic rule:
read each ■ as a car obeying "advance if the space ahead is clear"). Four
bytes, four universes, one loom — that is the lesson, and you built it.

## Go deeper (optional)

- **Random seeding.** Set `SEED_MODE := "random"` and RULE back to 90: the
  triangles now interfere like ripples in rain. The starter fixes the random
  seed on purpose, so your "random" world is the same world every run — which
  is exactly how the game's Atlas can promise that habitat 30 is the *same
  place* every time you visit. Determinism is what makes a generated world a
  place rather than static.
- **In the game.** Each of the 52 Atlas habitats in *upgrade Biotech* is one
  rule integer plus one seed mode — chosen by simulation rather than taste,
  so that none of the 52 comes out blank, solid, or a twin of another. A
  performance note from its code: when rows get dense, the game merges each
  horizontal run of on-cells into a single rectangle before drawing, which
  cuts draw calls by an order of magnitude. Your version draws cell by cell,
  which is the right way to learn and a fine way to run.
- **One sentence of idle-game economics**, since this world orbits one: the
  standard idle-game move is *geometric cost growth* — each level of an
  upgrade costs about 1.15× the one before, so prices climb an ever-steepening
  curve the same way our automaton's rows compound their parents — a design
  pattern Anthony Pecorella's free GDC talks, "The Math of Idle Games", lay
  out with real published numbers (and *upgrade Biotech*'s own cost curve
  starts at exactly that 1.15).
- **An open question to carry:** Rule 90 forgot nothing (every row is
  recoverable from the seed) yet looks orderly; Rule 30 forgot nothing either,
  yet looks random. What would it take for a *player* to tell the difference
  between generated and hand-drawn? Would they ever need to?

## Check yourself

1. Under Rule 90, a cell sees ■ · ■ above it (both outer neighbours on,
   middle off). On or off?
2. How many possible patterns can a cell see, and how many possible rules
   exist in total?
3. Why does the starter fix `RANDOM_SEED := 26` instead of letting each run
   roll fresh dice?

<details>
<summary>Answers (guess first — guessing is part of the exercise)</summary>

1. Off. Rule 90 is XOR of the outer neighbours: both on means "not exactly
   one", so the cell stays dark. (That's pattern p = 5, and bit 5 of
   01011010 is 0.)
2. Eight patterns (2³ for three parents), and 256 rules (2⁸ — one on/off
   choice per pattern).
3. So the world is repeatable. A fixed seed makes the "random" habitat the
   same habitat on every visit — a *place* you can return to rather than
   noise that happened once. Change the number and you emigrate.

</details>

## Sources

- **Primary:** S. Wolfram, "Statistical mechanics of cellular automata",
  *Reviews of Modern Physics* 55:601–644, 1983. Established the elementary
  cellular automaton framework used here — the 0–255 rule numbering and the
  analysis of Rule 90's self-similar, nested-triangle structure.
- **Secondary (free):** S. Wolfram, *A New Kind of Science* — readable free
  at [wolframscience.com](https://www.wolframscience.com/nks/). The full
  picture-gallery of all 256 rules, including Rule 30's chaos and Rule 110's
  universality, at coffee-table scale.
- **Secondary (free):** Anthony Pecorella, "The Math of Idle Games", GDC talk
  series, free on the GDC YouTube channel — for the one sentence above on
  geometric cost growth.

---

**Next world:** [Tidepool Keeper](../03-tidepool-keeper/) — two spirals, one
shell, and the genre's kindest mechanic. (E07 in the long course.)
