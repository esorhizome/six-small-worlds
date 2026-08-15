# Lesson 1 · The Sunflower Rule

*By the end of this lesson, a colony of cells will accrete — one cell at a
time, in front of you — and pack itself as neatly as a sunflower head.*

## If this is your first time

Welcome; you need no maths beyond "an angle is a turn" and no code beyond a
willingness to paste some. Install Godot 4.3+ (free, about 100 MB), and know
that watching along without typing still counts. If anything goes wrong, the
computer is not cross with you — it is asking a clarifying question.

## See it first

Look at the middle of a sunflower — or a pinecone, or a daisy's eye. The seeds
are not in rows and not in rings. Your eye finds spirals winding out both
clockwise and anticlockwise, crossing each other, and every seed sits in its
own pocket of space: no crowding at the centre, no wasteland at the rim.

Here is the surprise: the plant is not solving a hard packing puzzle. It is
repeating one small dance move, once per seed:

> **Turn by a fixed angle. Step a little further out. Place a seed. Repeat.**

That's the whole choreography. The fixed angle is about 137.5° — the *golden
angle* — and the "little further out" follows a square root. Two choices, and
everything the sunflower is famous for follows from them. Today you make the
same two choices in Godot and watch a colony assemble itself.

## The maths, small

> **New symbols: 3.**
>
> - **n** — the cell's number: 0 for the first cell, 1 for the next, and so on.
> - **θ** (theta) — the angle the cell sits at, measured round from some
>   starting direction.
> - **r** — the cell's distance from the centre.
>
> **The rule (Vogel, 1979):**
>
> θ = n × 137.508°  r = 7 × √n
>
> **In plain English:** cell number n stands n golden-angle turns round from
> cell zero, and √n spacings out from the centre. (The 7 is our spacing in
> pixels — any positive number works; Vogel writes it as a constant c.)

**Why √n?** Fairness. Suppose every cell claims the same amount of floor
space. After n cells, the colony's total floor area is n times one cell's
share. But the area of a disc grows with the *square* of its radius — double
the radius, four times the floor. So if area must grow like n, the radius can
only grow like √n. The square root is what "equal room for everyone" looks
like from above. That is the exact reasoning Vogel's model is built on.

**Why 137.508°?** Try a tidy angle and watch it fail. Turn 90° per cell and
you get four straight spokes with empty wedges between them — every fourth
cell lands on the same bearing. Turn by *any* fraction of a full turn (a
quarter, a third, three-eighths…) and sooner or later the bearings repeat and
the spokes appear. What you want is a turn that is as far from every fraction
as a turn can be — an angle whose multiples never quite line up. Divide a full
turn by the golden ratio φ twice, and you get 360° ÷ φ ÷ φ ≈ 137.5078°. The
golden ratio is, in a precise sense mathematicians are fond of, the number
*worst* approximated by fractions — which is exactly the job description here:
gaps that never line up. You will prove this to yourself in Go deeper by
nudging the angle a tenth of a degree and watching the pattern collapse.

## Build it

### Step 1 — a scene and a single cell

In Godot: new project → new scene → add one **Node2D** → attach a script.
Replace the script's contents with this:

```gdscript
extends Node2D

func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	draw_circle(centre, 4.0, Color(0.9, 0.9, 0.8))
```

Press **F5** (pick this scene as the main one when asked).

**You should see:** one pale dot in the middle of a dark window. That dot is
cell zero, and `_draw()` is the room where all our drawing will happen.

### Step 2 — two hundred cells, all at once

Now the rule itself. One honest sentence about units: we think in degrees,
Godot draws in radians, and `deg_to_rad()` is the border crossing — degrees go
in, radians come out, and we store the radian version.

```gdscript
extends Node2D

const GOLDEN_ANGLE_DEG := 137.507764  # 360° ÷ φ ÷ φ — the golden angle
const SPACING := 7.0                  # the c in r = c·√n; sets colony density
const CELL_RADIUS := 4.0
const CELL_COUNT := 200

func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	var golden_angle := deg_to_rad(GOLDEN_ANGLE_DEG)
	for n in CELL_COUNT:
		var angle := golden_angle * float(n)
		var radius := SPACING * sqrt(float(n))
		var pos := centre + Vector2(cos(angle), sin(angle)) * radius
		draw_circle(pos, CELL_RADIUS, Color(0.9, 0.9, 0.8))
```

Run it.

**You should see:** a round colony of two hundred dots, spirals swirling both
ways, denser at the heart and airy at the rim — a sunflower head in one loop.
If yours looks lopsided or oddly clumped, you are 90% of the way there:
lopsided means it's drawing, and the usual culprit is a typo in the angle
constant. Check the digits and run again.

### Step 3 — let it grow

A colony that appears fully formed is a diagram. A colony that *accretes* is
alive. We add a clock: a counter that rises a few cells per second, and a
redraw whenever it does. `_process(delta)` runs every frame; `delta` is how
many seconds that frame took, so `12.0 * delta` accumulates twelve cells'
worth of growth per second no matter the frame rate.

```gdscript
extends Node2D

const GOLDEN_ANGLE_DEG := 137.507764  # 360° ÷ φ ÷ φ — the golden angle
const SPACING := 7.0                  # the c in r = c·√n; sets colony density
const CELL_RADIUS := 4.0
const MAX_CELLS := 200
const TICKS_PER_SECOND := 12.0

var cells := 0.0
var golden_angle := deg_to_rad(GOLDEN_ANGLE_DEG)

func _process(delta: float) -> void:
	if cells < float(MAX_CELLS):
		cells = minf(cells + TICKS_PER_SECOND * delta, float(MAX_CELLS))
		queue_redraw()

func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	for n in int(cells):
		var angle := golden_angle * float(n)
		var radius := SPACING * sqrt(float(n))
		var pos := centre + Vector2(cos(angle), sin(angle)) * radius
		draw_circle(pos, CELL_RADIUS, Color(0.9, 0.9, 0.8))
```

Run it — and this time, watch.

**You should see:** the colony assemble itself, one cell per tick, each new
cell landing in a gap you didn't know was there. It takes about seventeen
seconds for all two hundred to bloom. Notice that no cell ever touches
another and no gap ever survives. That is the golden angle at work.

**You can stop here.** Two hundred cells have bloomed, one by one, from a rule
you can say in a sentence. Everything below is bonus.

### Step 4 (bonus) — hold to pour

Idle games love a held button. We give growth a throttle: while the left mouse
button or SPACE is down, time runs ten times faster. Pouring needs somewhere
to pour, so the cap rises to 2,000.

```gdscript
extends Node2D

const GOLDEN_ANGLE_DEG := 137.507764  # 360° ÷ φ ÷ φ — the golden angle
const SPACING := 7.0                  # the c in r = c·√n; sets colony density
const CELL_RADIUS := 4.0
const MAX_CELLS := 2000
const TICKS_PER_SECOND := 12.0
const POUR_MULTIPLIER := 10.0

var cells := 0.0
var golden_angle := deg_to_rad(GOLDEN_ANGLE_DEG)

func _process(delta: float) -> void:
	var speed := TICKS_PER_SECOND
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE):
		speed *= POUR_MULTIPLIER
	if cells < float(MAX_CELLS):
		cells = minf(cells + speed * delta, float(MAX_CELLS))
		queue_redraw()

func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	for n in int(cells):
		var angle := golden_angle * float(n)
		var radius := SPACING * sqrt(float(n))
		var pos := centre + Vector2(cos(angle), sin(angle)) * radius
		draw_circle(pos, CELL_RADIUS, Color(0.9, 0.9, 0.8))
```

**You should see:** gentle growth by default; hold the button and cells pour
in like sand into a jar — and the packing never falters, at 200 or at 2,000.

### Step 5 (bonus) — age, painted

One last touch: let the colony show its history. Old cells (small n) wear one
colour, young cells (large n) another, and `lerp` blends between them. This is
the full file — identical, byte for byte, to
[`starter/phyllotaxis.gd`](starter/phyllotaxis.gd).

```gdscript
# phyllotaxis.gd — Six Small Worlds · World 2 · Lesson 1: The Sunflower Rule
# Draws a colony that accretes one cell per tick using Vogel's 1979 model:
#   cell n sits at angle n × 137.508° (the golden angle), radius SPACING × √n.
# Hold the left mouse button or SPACE to pour cells in faster.
# One thing to try changing: GOLDEN_ANGLE_DEG → 137.3, and watch the arms appear.

extends Node2D

const GOLDEN_ANGLE_DEG := 137.507764  # 360° ÷ φ ÷ φ — the golden angle
const SPACING := 7.0                  # the c in r = c·√n; sets colony density
const CELL_RADIUS := 4.0              # size of one drawn cell, in pixels
const TICKS_PER_SECOND := 12.0        # unhurried growth speed
const POUR_MULTIPLIER := 10.0         # growth speed while pouring
const MAX_CELLS := 2000               # where the colony rests

const YOUNG_COLOR := Color(1.0, 0.95, 0.7)  # newest cells, at the rim
const OLD_COLOR := Color(0.55, 0.85, 0.6)   # oldest cells, at the heart

var cells := 0.0  # grows smoothly; we draw the whole-number part
var golden_angle := deg_to_rad(GOLDEN_ANGLE_DEG)  # degrees in, radians out


func _process(delta: float) -> void:
	var speed := TICKS_PER_SECOND
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE):
		speed *= POUR_MULTIPLIER
	if cells < float(MAX_CELLS):
		cells = minf(cells + speed * delta, float(MAX_CELLS))
		queue_redraw()


func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	var count := int(cells)
	for n in count:
		var angle := golden_angle * float(n)
		var radius := SPACING * sqrt(float(n))
		var pos := centre + Vector2(cos(angle), sin(angle)) * radius
		var age := float(n) / maxf(float(count), 1.0)  # 0 = oldest, 1 = newest
		draw_circle(pos, CELL_RADIUS, OLD_COLOR.lerp(YOUNG_COLOR, age))
```

**You should see:** a colony with a green heart and a pale golden rim — the
rim is always the newest growth, so the bloom reads outward, the way it grew.

## Go deeper (optional)

- **The tenth-of-a-degree experiment.** Set `GOLDEN_ANGLE_DEG := 137.3` and
  run. Spiral arms appear, with real gaps between them. Try `137.6`: different
  arms, same disease. Back to `137.507764`: perfection returns. This three-way
  comparison is a classic of the field — Vogel's paper is built around why
  only the golden angle packs evenly, and *The Algorithmic Beauty of Plants*
  reproduces the comparison in its phyllotaxis chapter. A tenth of a degree is
  the difference between a sunflower and a broken fan.
- **Turn the dials.** `SPACING` changes density without changing character —
  the pattern is scale-free. `TICKS_PER_SECOND` changes mood: at 2 it is
  meditative, at 120 it is a firework.
- **An open question to carry:** n currently controls two things — where a
  cell goes and what colour it wears. What else could n drive? Size? Wobble?
  At what point would the result stop reading as *growth* and start reading
  as decoration? There is no wrong answer; there is a game's art direction
  hiding in yours.

## Check yourself

1. Which grows faster as the colony gains cells — the cell count, or the
   colony's radius?
2. Why does turning exactly 90° per cell produce four spokes?
3. What does `SPACING` (Vogel's constant c) control — and name one thing it
   does *not* control.

<details>
<summary>Answers (guess first — guessing is part of the exercise)</summary>

1. The cell count. Radius grows like √n, so the hundredth cell is only ten
   spacings out, and quadrupling the population merely doubles the radius.
2. Because 90° is a quarter of a full turn: cells 0, 4, 8, 12… all face the
   same way, so every cell lands on one of four bearings. Any exact fraction
   of a turn repeats like this eventually; the golden angle never does.
3. It controls the physical spread — how many pixels apart the cells sit. It
   does not control the pattern itself: the spiral structure is identical at
   any spacing, which is why the same rule fits a daisy's eye and a
   sunflower's head.

</details>

## Sources

- **Primary:** H. Vogel, "A better way to construct the sunflower head",
  *Mathematical Biosciences* 44:179–189, 1979. Established the planted-spiral
  model this lesson builds: divergence angle 137.5°, radius proportional to
  √n, derived from equal-area packing.
- **Secondary (free):** P. Prusinkiewicz & A. Lindenmayer, *The Algorithmic
  Beauty of Plants*, chapter 4 (phyllotaxis) — free PDF at
  [algorithmicbotany.org](http://algorithmicbotany.org/papers/#abop). Presents
  Vogel's model and the divergence-angle comparison with pictures worth the
  download on their own.

---

**Next lesson:** [A Garden From an Equation](lesson-2-a-garden-from-an-equation.md)
— one equation with one dial grows 26 different flowers, and then the
two-times table folds itself into a heart.

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
