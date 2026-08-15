# Lesson 2 · A Garden From an Equation

*By the end of this lesson, one equation with one dial will have grown a
26-flower garden — and, as an encore, the two-times table will fold itself
into a heart.*

## If this is your first time

You can start the series here; nothing below assumes Lesson 1 beyond the setup
ritual (new project → one Node2D → attach script → F5). If you *did* do
Lesson 1, two of today's symbols are old friends, and only one is new. Take
your time — there are two small builds today, with a marked resting point
between them.

## See it first

Picture a pen on the end of a clock hand. The hand sweeps round at a steady
pace. If the pen kept a fixed distance from the centre, it would draw a plain
circle. Instead, we let its distance *breathe* — out, in, out, in — like a
tide, while the hand turns. Every time the distance swells, the pen bulges
away from the centre and draws a petal; every time it shrinks through zero,
the pen passes back through the middle of the flower.

One number — how many times the distance breathes per lap — decides the whole
flower. Breathe three times per lap: three petals. Change that one dial and
you get a poppy, a daisy, a clover, a wheel of lace. Mathematicians met these
in the 1720s, when Guido Grandi studied them and named them **rhodonea** —
roses. We're going to plant twenty-six of them, one per letter of the
alphabet, which happens to be exactly what the Garden in *upgrade Biotech*
does.

Then, once the garden blooms, a second machine with no curves in it at all:
a circle of points, straight chords, and one multiplication — from which a
heart emerges uninvited.

## The maths, small

> **New symbols: 1.** (r and θ return from Lesson 1.)
>
> - **k** — the flower's number: how many times the radius breathes per lap.
> - **θ** (theta) — the pen's angle, sweeping 0° to 360° for one lap.
> - **r** — the pen's distance from the centre at that angle.
>
> **The rule (Grandi's rose):**
>
> r = cos(k × θ)
>
> **In plain English:** as the pen swings round, its distance from the centre
> rises and falls like a wave — and k sets how fast the wave beats. (We'll
> multiply r by a size in pixels so the flower is bigger than a full stop.)

**The petal-count rule — state it, then watch it.** For a whole number k:

- **odd k → k petals** (k = 5 gives five)
- **even k → 2k petals** (k = 4 gives eight)

That asymmetry looks like a misprint and isn't. When k is odd, the second half
of the lap retraces the first half's petals exactly, so you see k of them.
When k is even, the two halves land in different places and every petal
arrives twice over — 2k in all. You do not need to take my word for it: the
build makes it visible in about a minute, and the rule is stated plainly on
MacTutor's rhodonea-curve pages if you want it in writing.

## Build it

### Part A — the garden

#### Step 1 — one rose

One flower first, dial set to 4. Units, as always: prose speaks degrees, code
speaks radians, and `TAU` is radians' name for one full turn — so θ runs from
0 to TAU instead of 0° to 360°.

```gdscript
extends Node2D

const K := 4            # the one dial: petals beat K times per lap
const SEGMENTS := 360   # points along the curve — more means smoother
const RADIUS := 200.0   # flower size in pixels

func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	var points := PackedVector2Array()
	points.resize(SEGMENTS + 1)
	for s in SEGMENTS + 1:
		var theta := TAU * float(s) / float(SEGMENTS)
		var r := RADIUS * cos(float(K) * theta)
		points[s] = centre + Vector2(cos(theta), sin(theta)) * r
	draw_polyline(points, Color(0.95, 0.7, 0.8), 2.0, true)
```

Run it.

**You should see:** an eight-petalled rose. Eight, not four — K is even, so
the count doubles, exactly as promised. Now set `K := 5` and run again: five
petals, fatter, because odd k keeps its own count. Try `K := 2` (four petals),
`K := 7` (seven), `K := 1` (a single circle standing off-centre — the rose
family's letter A). If your flower looks like a scribble, count your commas
inside the loop; the computer is asking a clarifying question, not judging.

#### Step 2 — all twenty-six

Now the same rose, stamped in a grid, with k running 1 to 26 — A to Z. This
full file is [`starter/rose_garden.gd`](starter/rose_garden.gd), byte for
byte. The one new idea: a helper function, so "draw a rose" becomes a sentence
we can say twenty-six times.

```gdscript
# rose_garden.gd — Six Small Worlds · World 2 · Lesson 2 (build A): the garden
# Draws 26 rose curves, r = cos(k·θ) for k = 1..26, one per letter A–Z —
# the same family that grows the Garden in upgrade Biotech.
# Odd k blooms k petals; even k blooms 2k. Count them and check.
# One thing to try changing: SATURATION, or swap cos for sin and spot the turn.

extends Node2D

const FLOWER_COUNT := 26   # one flower per letter of the alphabet
const COLUMNS := 6         # grid width; 26 flowers make five rows, minus a gap
const SEGMENTS := 360      # points along each curve — more means smoother
const MARGIN := 20.0       # breathing room around the grid, in pixels
const FLOWER_FILL := 0.38  # how much of its grid cell a flower fills
const LINE_WIDTH := 1.5
const SATURATION := 0.5    # 0 = ghostly, 1 = neon

func _draw() -> void:
	var view := get_viewport_rect().size
	var rows := int(ceil(float(FLOWER_COUNT) / float(COLUMNS)))
	var cell := Vector2((view.x - MARGIN * 2.0) / float(COLUMNS),
			(view.y - MARGIN * 2.0) / float(rows))
	var radius := minf(cell.x, cell.y) * FLOWER_FILL
	for i in FLOWER_COUNT:
		var col := i % COLUMNS
		var row := int(float(i) / float(COLUMNS))
		var centre := Vector2(MARGIN, MARGIN) + Vector2(
				(float(col) + 0.5) * cell.x, (float(row) + 0.5) * cell.y)
		_draw_rose(centre, radius, i + 1)
		draw_string(ThemeDB.fallback_font, centre + Vector2(-4.0, -radius - 6.0),
				char(65 + i), HORIZONTAL_ALIGNMENT_LEFT, -1, 12, Color(0.6, 0.6, 0.68))

func _draw_rose(centre: Vector2, radius: float, k: int) -> void:
	var points := PackedVector2Array()
	points.resize(SEGMENTS + 1)
	for s in SEGMENTS + 1:
		var theta := TAU * float(s) / float(SEGMENTS)  # TAU = one full turn
		var r := radius * cos(float(k) * theta)
		points[s] = centre + Vector2(cos(theta), sin(theta)) * r
	var hue := float(k - 1) / float(FLOWER_COUNT)
	draw_polyline(points, Color.from_hsv(hue, SATURATION, 0.95), LINE_WIDTH, true)
```

Run it.

**You should see:** a 6-wide grid of twenty-six labelled flowers, A to Z, each
its own colour, marching from a lone circle at A to a 52-petalled wheel of
lace at Z. Sweep your eye along a row and watch the odd/even rule alternate:
1, 4, 3, 8, 5, 12… petals. (Two grid slots stay empty; the alphabet declines
to be thirty long.) If some flowers render as faint tangles, that is what 40+
petals at small size honestly look like — zoom the window larger and they
resolve.

**You can stop here.** You have grown a complete 26-flower garden from one
equation and one dial. The second machine below is bonus — a different
beauty, in exchange for one new operation.

### Part B — the times-table circle

The rose needed a curve. This machine needs only straight lines and the
multiplication you learned at seven years old.

> **The maths, small — part two. New symbols: 2, plus one operation.**
>
> - **N** — how many points stand around a circle, numbered 0 to N−1.
> - **M** — which times table we draw.
> - **mod** — clock arithmetic: the remainder after wrapping. On a circle of
>   N points, point numbers wrap round, so point (2 × 150) on a 200-point
>   circle is point 300 mod 200 = point 100.
>
> **The rule:** draw a straight chord from every point k to point
> (k × M) mod N.
>
> **In plain English:** each point phones its entry in the M-times table.
> Number too big for the circle? Keep walking round; the remainder answers.

#### Step 3 — a circle of points

```gdscript
extends Node2D

const N := 200          # points around the rim
const DOT_RADIUS := 1.5
const RADIUS_FRACTION := 0.45

func _draw() -> void:
	var view := get_viewport_rect().size
	var centre := view * 0.5
	var radius := minf(view.x, view.y) * RADIUS_FRACTION
	draw_arc(centre, radius, 0.0, TAU, 128, Color(0.5, 0.5, 0.58), 1.0, true)
	for k in N:
		var angle := TAU * float(k) / float(N) - PI * 0.5  # radians again; -PI/2 puts 0 at 12 o'clock
		draw_circle(centre + Vector2(cos(angle), sin(angle)) * radius,
				DOT_RADIUS, Color(0.6, 0.6, 0.7))
```

**You should see:** a ring of two hundred fine dots. No maths visible yet —
this is the stage before the play.

#### Step 4 — the two-times table, drawn

Replace the dots with chords: every point k connects to (k × 2) mod N.

```gdscript
extends Node2D

const N := 200          # points around the rim
const M := 2            # the times table we draw
const RADIUS_FRACTION := 0.45
const CHORD_COLOR := Color(0.95, 0.6, 0.5, 0.7)
const RIM_COLOR := Color(0.5, 0.5, 0.58)

func _point(index: int, centre: Vector2, radius: float) -> Vector2:
	var angle := TAU * float(index % N) / float(N) - PI * 0.5
	return centre + Vector2(cos(angle), sin(angle)) * radius

func _draw() -> void:
	var view := get_viewport_rect().size
	var centre := view * 0.5
	var radius := minf(view.x, view.y) * RADIUS_FRACTION
	draw_arc(centre, radius, 0.0, TAU, 128, RIM_COLOR, 1.0, true)
	for k in N:
		draw_line(_point(k, centre, radius), _point(k * M, centre, radius),
				CHORD_COLOR, 1.0, true)
```

Run it.

**You should see:** two hundred straight lines — and, made of nothing but
their overlaps, a heart-shaped curve glowing inside the circle. That shape is
a **cardioid** (from the Greek for heart), and nobody drew it: it is the
*envelope* of the chords, the shape their crowd leans against. The two-times
table has contained this heart all along. Mathologer's 2015 video on exactly
this construction is the finest half hour you can spend on it.

#### Step 5 — give it dials

Last step: make N and M changeable while it runs, because the twist is where
this machine sings. This full file is
[`starter/times_table.gd`](starter/times_table.gd). New idea: constants that
need to change stop being constants — they become variables, and a key press
nudges them and asks for a redraw.

```gdscript
# times_table.gd — Six Small Worlds · World 2 · Lesson 2 (build B): times-table circle
# N points ring a circle; a straight chord joins each point k to (k × M) mod N.
# M = 2 wraps the two-times table into a cardioid — a heart made of straight lines.
# Arrow keys: left/right change M, up/down change N. Hold right and watch it travel.
# One thing to try changing: START_TABLE → 3 for a nephroid, or 51 for lace.

extends Node2D

const START_POINTS := 200        # N — how many points around the rim
const START_TABLE := 2           # M — which times table we draw
const POINTS_STEP := 10          # how far up/down move N
const RADIUS_FRACTION := 0.45    # circle size as a share of the window
const LINE_WIDTH := 1.0
const CHORD_COLOR := Color(0.95, 0.6, 0.5, 0.7)
const RIM_COLOR := Color(0.5, 0.5, 0.58)
const LABEL_COLOR := Color(0.8, 0.8, 0.85)

var n := START_POINTS
var m := START_TABLE

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_RIGHT: m += 1
			KEY_LEFT: m = maxi(m - 1, 1)
			KEY_UP: n += POINTS_STEP
			KEY_DOWN: n = maxi(n - POINTS_STEP, 10)
		queue_redraw()

func _point(index: int, centre: Vector2, radius: float) -> Vector2:
	# TAU is radians for "one full turn"; the -PI/2 starts point 0 at 12 o'clock.
	var angle := TAU * float(index % n) / float(n) - PI * 0.5
	return centre + Vector2(cos(angle), sin(angle)) * radius

func _draw() -> void:
	var view := get_viewport_rect().size
	var centre := view * 0.5
	var radius := minf(view.x, view.y) * RADIUS_FRACTION
	draw_arc(centre, radius, 0.0, TAU, 128, RIM_COLOR, 1.0, true)
	for k in n:
		draw_line(_point(k, centre, radius), _point(k * m, centre, radius),
				CHORD_COLOR, LINE_WIDTH, true)
	draw_string(ThemeDB.fallback_font, Vector2(16.0, 28.0),
			"N = %d   M = %d   (arrow keys)" % [n, m],
			HORIZONTAL_ALIGNMENT_LEFT, -1, 14, LABEL_COLOR)
```

**You should see:** the cardioid, with a label in the corner. Tap RIGHT:
M = 3 grows a two-lobed **nephroid** (kidney). M = 4: three lobes. The
pattern — the M-times table draws M − 1 lobes — is laid out in the Mathologer
video, along with why. Hold RIGHT and the figure travels through families of
lace. Tap DOWN to thin the circle out and you can watch individual chords
obey the rule; tap UP toward 400 and the envelopes sharpen like a lens
focusing. (M = 1 connects every point to itself and draws nothing — the
one-times table has no gossip.)

## Go deeper (optional)

- **In the game.** The Garden in *upgrade Biotech* is this exact rose family
  — 26 flowers, A to Z — with one generalisation: the game allows k to be a
  fraction n/d, which buys it in-between flowers that need several laps to
  close. And the times-table circle is the game's fourth catalogue: the
  Expedition's 104 finds are all (N, M) pairs, chosen by an actual measurement
  of how different the figures look. Straight chords, no curves — the
  deliberately plainest family in the project, which is what lets it carry 104
  entries.
- **Swap `cos` for `sin`** in the rose and run the garden again. Same
  flowers, rotated. Can you say why before you look it up? (Hint: sin is cos
  arriving a quarter-turn late.)
- **An open question to carry:** the rose is one continuous pen line; the
  cardioid is the silhouette of two hundred straight ones. Which reads as more
  "alive" to you, and would your answer change if they moved?

## Check yourself

1. How many petals does k = 7 grow? And k = 8?
2. On a circle of N = 10 points with M = 2, where does point 7 send its
   chord?
3. What did Grandi name this curve family, and in which book?

<details>
<summary>Answers (guess first — guessing is part of the exercise)</summary>

1. Seven and sixteen. Odd keeps its number; even doubles it.
2. To point 4: 7 × 2 = 14, and 14 mod 10 = 4 — walk past zero and keep
   counting.
3. *Rhodonea* — the roses — in *Flores geometrici*, 1728.

</details>

## Sources

- **Historical:** G. Grandi, *Flores geometrici*, 1728. The rose (rhodonea)
  curves, from the mathematician who studied and named them.
- **Secondary (free):** MacTutor History of Mathematics archive, University of
  St Andrews — Grandi's biography and the rhodonea curve pages, which state
  the odd/even petal-count rule this lesson demonstrates.
- **Secondary (free):** Mathologer, "Times Tables, Mandelbrot and the Heart of
  Mathematics", YouTube, 2015. The cardioid in the two-times table, the
  nephroid in the three-times, and the M − 1 lobe pattern, with proofs kept
  gentle.

---

**Next lesson:** [Worlds From Neighbours](lesson-3-worlds-from-neighbours.md)
— one row of cells, one byte, and an entire habitat grows down your screen.

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
