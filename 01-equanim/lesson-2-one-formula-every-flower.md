# Lesson 2 · One formula, every flower

*By the end of this lesson, one equation is morphing between star, square and
petal on a card you can drag to turn — with every dial exposed for tuning.*

## If this is your first time

Welcome — you can start the course here and be fine, though lesson 1's two
dials (sin and cos) get a warm mention throughout. You need Godot 4.3 or
newer and about twenty minutes. Watching without typing still counts, and the
**you can stop here** line arrives early in this one.

## See it first

Take a walk around a lamppost holding a rope tied to it. If the rope stays
the same length the whole way round, your footprints make a circle — a shape
with no opinions, the same in every direction.

Now let the rope *breathe* while you walk: lengthening, shortening,
lengthening again, in a steady rhythm — say five breaths per lap. Your
footprints bulge and pinch, bulge and pinch, five times: a starfish. Quicker,
shallower breaths make petals. Four square-shouldered breaths make, in fact,
a square.

That is the entire idea. A circle is "same distance, every direction". Give
the distance a rhythm — a *personality* — and one walking recipe produces
stars, squares, petals, and a surprising number of outlines you have met in
nature. In 2003 a botanist named Johan Gielis wrote the rhythm down as one
equation, now called the **superformula**. It looks fierce for about a
minute. Then it looks like a circle with a personality dial.

## The maths, small

> **Three new symbols, each named in words.**
>
> | symbol | say it | what it is |
> |---|---|---|
> | `θ` | "theta" — the facing | which direction you are looking from the centre |
> | `r` | "the radius" | how far the shape reaches in that direction |
> | `m` | "the repeats" | how many times the personality repeats per lap |
>
> The superformula (Gielis, 2003):
>
> ```text
> r(θ) = ( |cos(m·θ/4) / a| ^ n2  +  |sin(m·θ/4) / b| ^ n3 ) ^ (−1/n1)
> ```
>
> In plain English: *face a direction `θ`; take the two dials from lesson 1,
> repeated `m` times around the lap; sharpen each with a power; add them; the
> total tells you how far `r` this direction reaches.* Every direction gets
> its own radius. That is the personality.
>
> The five other letters — `a`, `b`, `n1`, `n2`, `n3` — are **dials, not
> vocabulary**: `a` and `b` stretch the shape across and up-down, and the
> three `n`s pinch or soften it. You will meet all five as named sliders in
> the code, so there is nothing here to memorise.
>
> One promise before we build: set every dial to its calmest — `m = 4`, all
> three `n`s at 2, `a` and `b` at 1 — and the equation quietly hands back
> `r = 1`. The circle was inside all along.
>
> (Angles again: we speak degrees, the code speaks radians, and one full lap
> is `TAU`.)

## Build it

### Step 1 — a new card

As in lesson 1: a fresh 2D scene, one `Node2D`, attach a script, delete the
starter lines. (Same project is fine — one scene per lesson keeps things
tidy. **F6** runs the scene you are looking at.)

### Step 2 — the formula, set to calm

One new idea: *polar drawing* — instead of two dials making x and y directly,
we walk the facing `θ` around a lap, ask the formula for a radius, and place
each dot at `(r·cos θ, r·sin θ)`. All dials start calm, so we expect a circle:

```gdscript
extends Node2D
# Lesson 2, step 2 — the superformula with every dial calm: a circle.

const SYMMETRY_M := 4.0    # personality repeats per lap
const SHARPNESS_N1 := 2.0  # overall pinch
const SHARPNESS_N2 := 2.0  # cos-side sharpness
const SHARPNESS_N3 := 2.0  # sin-side sharpness
const STRETCH_A := 1.0     # across stretch
const STRETCH_B := 1.0     # up-down stretch
const SIZE := 130.0        # pixels per 1 unit of radius
const SEGMENTS := 720      # dots around the outline
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var theta := TAU * float(i) / float(SEGMENTS)
		var r := _superformula(theta) * SIZE
		points.append(Vector2(r * cos(theta), r * sin(theta)))
	draw_polyline(points, INK, LINE_WIDTH, true)

# r(θ) = (|cos(m·θ/4)/a|^n2 + |sin(m·θ/4)/b|^n3)^(−1/n1)   — Gielis, 2003
func _superformula(theta: float) -> float:
	var part_cos := pow(abs(cos(SYMMETRY_M * theta / 4.0) / STRETCH_A), SHARPNESS_N2)
	var part_sin := pow(abs(sin(SYMMETRY_M * theta / 4.0) / STRETCH_B), SHARPNESS_N3)
	var total := part_cos + part_sin
	return 1.0 if total == 0.0 else pow(total, -1.0 / SHARPNESS_N1)
```

The `_superformula` function is the boxed equation, line for line: the
cos part, the sin part, added, then raised to `−1/n1`. (The guard on the last
line can never trigger with these dials — the computer appreciates
reassurance anyway.)

**Run it:** a modest circle. It looks like less than lesson 1 delivered, and
that is the point: the fierce-looking equation *contains* the circle, and you
have witnessed it. If you see a circle, the formula is alive and correct.

### Step 3 — wake the dials

One new idea: *the dials are the shape.* Change five constants — nothing
else — to these:

```gdscript
extends Node2D
# Lesson 2, step 3 — first supershape: a five-armed star.

const SYMMETRY_M := 5.0    # five repeats per lap
const SHARPNESS_N1 := 2.0
const SHARPNESS_N2 := 7.0
const SHARPNESS_N3 := 7.0
const STRETCH_A := 1.0
const STRETCH_B := 1.0
const SIZE := 130.0
const SEGMENTS := 720
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var theta := TAU * float(i) / float(SEGMENTS)
		var r := _superformula(theta) * SIZE
		points.append(Vector2(r * cos(theta), r * sin(theta)))
	draw_polyline(points, INK, LINE_WIDTH, true)

# r(θ) = (|cos(m·θ/4)/a|^n2 + |sin(m·θ/4)/b|^n3)^(−1/n1)   — Gielis, 2003
func _superformula(theta: float) -> float:
	var part_cos := pow(abs(cos(SYMMETRY_M * theta / 4.0) / STRETCH_A), SHARPNESS_N2)
	var part_sin := pow(abs(sin(SYMMETRY_M * theta / 4.0) / STRETCH_B), SHARPNESS_N3)
	var total := part_cos + part_sin
	return 1.0 if total == 0.0 else pow(total, -1.0 / SHARPNESS_N1)
```

**Run it:** a plump five-armed star — something like a starfish drawn by a
careful child. Your first supershape. If yours has six arms, you are one
integer away and the lesson is working: `m` counts the arms, and you have
proven it.

**You can stop here.** One equation, and it has already been a circle and a
star. That is the lesson's promise kept.

### Step 4 — the recipe wall

One new idea: *the dials are a vocabulary you can read.* Keep the code from
step 3 and try each row — change only the five dial constants:

| shape | `m` | `n1` | `n2` | `n3` | what to notice |
|---|---|---|---|---|---|
| circle | 4 | 2 | 2 | 2 | the calm setting from step 2 |
| star | 5 | 2 | 7 | 7 | arms grow *between* the repeats |
| square | 4 | 12 | 12 | 12 | high, equal `n`s square the shoulders |
| diamond | 4 | 1 | 1 | 1 | `n = 1` pulls the sides dead straight |
| petal / daisy | 8 | 1 | 3 | 3 | eight soft bulges, gently scalloped |

(`a` and `b` stay at 1 throughout — nudge one to 0.7 afterwards and watch the
whole family lean.) Read the pattern, not the numbers: `m` says *how many
times*, the `n`s say *how sharply*, `a` and `b` say *how stretched*. Star,
square, petal: one formula, morphing exactly as promised.

### Step 5 — put the dials on the outside

One new idea: *`@export` hands a variable to the editor.* Constants become
sliders in Godot's Inspector panel, so tuning stops needing the keyboard:

```gdscript
extends Node2D
# Lesson 2, step 5 — the dials become Inspector sliders.

@export_range(0.0, 24.0, 0.5) var symmetry_m := 5.0    # repeats per lap
@export_range(0.1, 20.0, 0.1) var sharpness_n1 := 2.0  # overall pinch
@export_range(0.1, 20.0, 0.1) var sharpness_n2 := 7.0  # cos-side sharpness
@export_range(0.1, 20.0, 0.1) var sharpness_n3 := 7.0  # sin-side sharpness
@export_range(0.1, 4.0, 0.1) var stretch_a := 1.0      # across stretch
@export_range(0.1, 4.0, 0.1) var stretch_b := 1.0      # up-down stretch

const SIZE := 130.0
const SEGMENTS := 720
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var theta := TAU * float(i) / float(SEGMENTS)
		var r := _superformula(theta) * SIZE
		points.append(Vector2(r * cos(theta), r * sin(theta)))
	draw_polyline(points, INK, LINE_WIDTH, true)

# r(θ) = (|cos(m·θ/4)/a|^n2 + |sin(m·θ/4)/b|^n3)^(−1/n1)   — Gielis, 2003
func _superformula(theta: float) -> float:
	var part_cos := pow(abs(cos(symmetry_m * theta / 4.0) / stretch_a), sharpness_n2)
	var part_sin := pow(abs(sin(symmetry_m * theta / 4.0) / stretch_b), sharpness_n3)
	var total := part_cos + part_sin
	return 1.0 if total == 0.0 else pow(total, -1.0 / sharpness_n1)
```

Click the `Node2D` in the Scene dock and the six dials appear in the
Inspector, named in words. Set them, run, look; stop, set, run again. (For
live tuning *while* it runs: run the scene, then switch the Scene dock to the
**Remote** tab, select the node, and drag the sliders — the shape obeys in
real time.)

**Run it:** the same star — but now the recipe wall from step 4 is a matter
of dragging sliders, no code edits at all.

### Step 6 — take the card in hand

One new idea: *listening to the mouse.* We let the card turn slowly on its
own, and hand you the turn whenever you drag — the inspect gesture. This
final version is kept for you at
[`starter/superformula.gd`](starter/superformula.gd):

```gdscript
# superformula.gd — Six Small Worlds · World 1 (equanim) · Lesson 2.
# Draws one supershape (the superformula, Gielis 2003): a circle whose
# radius has a personality. Idles in a slow turn; drag left-right to turn
# it yourself; every dial is an Inspector slider.
# One thing to try changing: symmetry_m — 4 is the square family, 5 a
# starfish, 8 a daisy. Try 19 and see what you would name it.
extends Node2D

@export_range(0.0, 24.0, 0.5) var symmetry_m := 5.0    # repeats per lap
@export_range(0.1, 20.0, 0.1) var sharpness_n1 := 2.0  # overall pinch
@export_range(0.1, 20.0, 0.1) var sharpness_n2 := 7.0  # cos-side sharpness
@export_range(0.1, 20.0, 0.1) var sharpness_n3 := 7.0  # sin-side sharpness
@export_range(0.1, 4.0, 0.1) var stretch_a := 1.0      # across stretch
@export_range(0.1, 4.0, 0.1) var stretch_b := 1.0      # up-down stretch

const SIZE := 130.0            # pixels per 1 unit of radius
const SEGMENTS := 720          # dots along the outline
const LAPS := 2.0              # walk the lap twice: odd m then closes too
const TURN_DEG_PER_SEC := 9.0  # idle turning speed
const DRAG_DEG_PER_PIXEL := 0.4  # how far one pixel of drag turns the card
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

var turn := 0.0  # the card's current turn, radians
var dragging := false

func _process(delta: float) -> void:
	position = get_viewport_rect().size / 2.0  # stay centred, even if resized
	if not dragging:
		turn += deg_to_rad(TURN_DEG_PER_SEC) * delta
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		turn += deg_to_rad(DRAG_DEG_PER_PIXEL) * event.relative.x

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var theta := TAU * LAPS * float(i) / float(SEGMENTS)
		var r := _superformula(theta) * SIZE
		points.append(Vector2(r * cos(theta + turn), r * sin(theta + turn)))
	draw_polyline(points, INK, LINE_WIDTH, true)

# r(θ) = (|cos(m·θ/4)/a|^n2 + |sin(m·θ/4)/b|^n3)^(−1/n1)   — Gielis, 2003
func _superformula(theta: float) -> float:
	var part_cos := pow(abs(cos(symmetry_m * theta / 4.0) / stretch_a), sharpness_n2)
	var part_sin := pow(abs(sin(symmetry_m * theta / 4.0) / stretch_b), sharpness_n3)
	var total := part_cos + part_sin
	return 1.0 if total == 0.0 else pow(total, -1.0 / sharpness_n1)
```

Three quiet details: the degrees-to-radians border crossing happens through
`deg_to_rad`, as always; `_unhandled_input` receives mouse events (press and
release set `dragging`; motion while dragging turns the card); and the
outline now walks **two laps** (`LAPS`) — for odd `m` with unequal
sharpness dials, the pattern needs a second lap to close, and a closed shape
drawn twice costs nothing.

**Run it:** your star turns on its own, unhurried. Drag it and it follows
your hand; let go and it resumes. Dials in the Inspector, gesture on the
card, parameters readable by anyone you show it to. That is an
inspect-card — the exact interaction at the heart of *equanim*, where every
card in the gallery is dragged and turned this same way.

## Go deeper (optional)

- **Variation:** morph over time. Add a target set of dials and glide each
  frame with `lerp` — for instance
  `sharpness_n2 = lerp(sharpness_n2, target_n2, delta)` — so star melts into
  square while you watch. Which in-between moments deserve names of their own?
- **Variation:** the stretch dials went untouched. Set `stretch_b` to 0.5
  and revisit the recipe wall — every shape leans into a new family.
- **Question:** set `symmetry_m` to 2.5. The outline refuses to close in two
  laps. How many laps would close it? (Whole-number `m` closes in one or two;
  halves want four.)
- **Open prompt:** curate a three-card catalogue. Pick three dial settings
  that feel like a family, write each one's dials as its caption, and give
  the catalogue a name.

## Check yourself

1. Which dial decides how many arms or petals the shape has?
2. What settings make the superformula hand back a perfect circle?
3. Why does the finished card walk the outline twice?

Answers are at the very bottom of this page.

## Sources

- **Primary:** J. Gielis, "A generic geometric transformation that unifies a
  wide range of natural and abstract shapes", *American Journal of Botany*
  90(3):333–338, 2003. The superformula's debut — a botanist's observation
  that one adjustment to the circle's equation reproduces an unexpected range
  of natural outlines. Free to read on the journal's site:
  [doi.org/10.3732/ajb.90.3.333](https://doi.org/10.3732/ajb.90.3.333).
- **Secondary (free):** Daniel Shiffman, *The Nature of Code*,
  [natureofcode.com](https://natureofcode.com) — the Oscillation chapter
  covers polar-to-Cartesian drawing (our `r·cos θ, r·sin θ` move) gently and
  with live sketches.
- **Secondary:** J. Dennis Lawrence, *A Catalog of Special Plane Curves*,
  Dover, 1972. The pre-superformula family album — circles, ellipses, roses
  and their named relatives, one page each.

## Answers

<details>
<summary>Unfold when ready</summary>

1. `m`, the repeats dial — it sets how many times the personality repeats per
   lap, which is what you count as arms or petals.
2. `m = 4`, `n1 = n2 = n3 = 2`, `a = b = 1`: the two dial parts become
   cos² + sin², which is always 1, and 1 raised to any power is 1 — so
   `r = 1` in every direction. Every dial calm, and the circle reappears.
3. With an odd `m` and unequal sharpness dials, one lap ends with the cos and
   sin parts swapped, so the outline hasn't closed yet; a second lap swaps
   them back. Shapes that close in one lap retrace themselves — nothing is
   lost.

</details>
