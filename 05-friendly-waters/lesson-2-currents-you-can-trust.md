# Lesson 2 · Currents You Can Trust

*World 5 · Friendly Waters — lesson 2 of 3*

**Promise:** by the end of this lesson you'll have water that pushes, drifts,
and never dead-ends — an invisible field of currents with 200 flecks of
marine snow riding it.

## If this is your first time

You can start the course here; nothing in this lesson needs lesson 1's code
(only its spirit). Setup, if you skipped it: install
[Godot 4.3+](https://godotengine.org), new project, add a **Node2D** scene
root, attach a script, paste each block below over the whole file, press
**F5**. Watching without typing is a legitimate way to take this lesson.

## See it first

Look at a TV weather map — the kind with wind arrows. There's an arrow over
your town, an arrow over the next town, an arrow over every single place, even
the places between towns. Nobody drew infinity arrows; the map is a *rule*
that can answer "which way, and how hard?" wherever you ask.

That's the whole idea we're building: **an arrow pinned to every point of
space**. Water is the same picture with the labels changed — ask the ocean at
any point "which way do you push?" and it has an answer. A leaf dropped on the
map doesn't know anything; it reads the arrow under its feet, takes a step,
reads the next arrow, and suddenly it has a *journey*.

One more ingredient. If every arrow picked its direction at random —
independently, like static on an untuned TV — the leaf would jitter in place,
going nowhere, trusting nothing. Real currents are *smooth*: the arrow here
and the arrow one centimetre away mostly agree, and disagreements build up
gradually over distance. We want randomness with manners. That exists, it's
called noise — the smooth kind — and Godot ships it built in, so we get to be
users rather than implementers.

## The maths, small

> **A field from noise** — three new symbols, no more.
>
> | symbol | say it as |
> |---|---|
> | *F* | the field — *F*(x, y) is the arrow pinned at the point (x, y) |
> | *n* | the noise value at that point — a smooth random number between −1 and 1 |
> | *θ* | the heading we make from it (theta, an angle) |
>
> **θ = n(x, y) × 180°  and  F(x, y) = the arrow of length 1 pointing along θ**
>
> In plain English: *at every point, ask the noise for a number between −1
> and 1, stretch it into a compass heading between −180° and +180°, and pin
> a unit-length arrow pointing that way.* Because noise varies smoothly from
> point to point, neighbouring arrows mostly agree — which is exactly what
> makes it read as water instead of static.
>
> One switch to acknowledge, as always: the box speaks degrees, the code will
> speak radians — so `× 180°` becomes `* PI`, because π radians *is* 180°.

The smooth-noise trick has a name and a birthday: **Ken Perlin, "An Image
Synthesizer", SIGGRAPH 1985** — the paper that gave computer graphics its
weather. Godot's built-in `FastNoiseLite` is a modern descendant of that
family, which means the hard part of this lesson was solved forty years ago
and handed to you as one object.

## Build it

### Step 1 — pin arrows to space

One idea: a grid of arrows, all pointing east, so we can *see* space before we
give it opinions. Paste over your whole script and run.

```gdscript
extends Node2D

const ARROW_SPACING := 64.0   # gap between sketched field arrows, pixels
const ARROW_LEN := 16.0       # sketched arrow length, pixels

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.01, 0.05, 0.10))
	var y := ARROW_SPACING / 2.0
	while y < view.y:
		var x := ARROW_SPACING / 2.0
		while x < view.x:
			var foot := Vector2(x, y)
			var tip := foot + Vector2.RIGHT * ARROW_LEN
			draw_line(foot, tip, Color(0.3, 0.55, 0.7, 0.5), 1.0)
			draw_circle(tip, 1.5, Color(0.3, 0.55, 0.7, 0.7))
			x += ARROW_SPACING
		y += ARROW_SPACING
```

**Run it.** Combed water: a lattice of small dashes, each with a dot for a
head, all agreeing that east is the only direction worth having. (The field is
drawn only every 64 pixels, but remember what it stands for: an arrow at
*every* point. The grid is a sketch of infinity, not the infinity itself.)

### Step 2 — let noise choose the angles

One idea: replace "east" with "whatever the noise says here". We make one
`FastNoiseLite`, and write the lesson's key function: `field_at(p)`, which
turns a position into an arrow.

```gdscript
extends Node2D

const NOISE_SCALE := 0.003    # field frequency: smaller = broader currents
const FIELD_SEED := 7         # any integer; every seed is a different sea
const ARROW_SPACING := 64.0   # gap between sketched field arrows, pixels
const ARROW_LEN := 16.0       # sketched arrow length, pixels

var noise := FastNoiseLite.new()

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = NOISE_SCALE
	noise.seed = FIELD_SEED

func field_at(p: Vector2) -> Vector2:
	# Noise gives a value in -1..1. Scaled up, that is a heading anywhere
	# from -180° to +180° — the full compass (radians in code, so × PI).
	var angle := noise.get_noise_2d(p.x, p.y) * PI
	return Vector2.from_angle(angle)  # a unit arrow pointing that way

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.01, 0.05, 0.10))
	var y := ARROW_SPACING / 2.0
	while y < view.y:
		var x := ARROW_SPACING / 2.0
		while x < view.x:
			var foot := Vector2(x, y)
			var tip := foot + field_at(foot) * ARROW_LEN
			draw_line(foot, tip, Color(0.3, 0.55, 0.7, 0.5), 1.0)
			draw_circle(tip, 1.5, Color(0.3, 0.55, 0.7, 0.7))
			x += ARROW_SPACING
		y += ARROW_SPACING
```

**Run it.** A weather chart. Arrows near each other lean the same way; sweeps
and curls develop over longer distances. That neighbourly agreement is the
entire difference between noise and static — `randf()` in place of the noise
would give you a porcupine. Two knobs are worth a minute of play right now:
`NOISE_SCALE` (0.001 = broad lazy rivers, 0.01 = tight fussy eddies) and
`FIELD_SEED` (every integer is a different sea).

### Step 3 — drop one mote in

One idea: something that *reads* the field. Each frame, the mote asks
`field_at` which way the water pushes at its position, and takes that step.
The arrows drop to a fainter alpha — they're scenery now, not the star.

```gdscript
extends Node2D

const CURRENT_SPEED := 42.0   # push from the field, pixels per second
const NOISE_SCALE := 0.003    # field frequency: smaller = broader currents
const FIELD_SEED := 7         # any integer; every seed is a different sea
const ARROW_SPACING := 64.0   # gap between sketched field arrows, pixels
const ARROW_LEN := 16.0       # sketched arrow length, pixels

var noise := FastNoiseLite.new()
var mote := Vector2.ZERO

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = NOISE_SCALE
	noise.seed = FIELD_SEED
	mote = get_viewport_rect().size / 2.0

func field_at(p: Vector2) -> Vector2:
	# Noise gives a value in -1..1. Scaled up, that is a heading anywhere
	# from -180° to +180° — the full compass (radians in code, so × PI).
	var angle := noise.get_noise_2d(p.x, p.y) * PI
	return Vector2.from_angle(angle)  # a unit arrow pointing that way

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	mote += field_at(mote) * CURRENT_SPEED * delta
	mote = Vector2(fposmod(mote.x, view.x), fposmod(mote.y, view.y))
	queue_redraw()

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.01, 0.05, 0.10))
	var y := ARROW_SPACING / 2.0
	while y < view.y:
		var x := ARROW_SPACING / 2.0
		while x < view.x:
			var foot := Vector2(x, y)
			var tip := foot + field_at(foot) * ARROW_LEN
			draw_line(foot, tip, Color(0.3, 0.55, 0.7, 0.18), 1.0)
			draw_circle(tip, 1.5, Color(0.3, 0.55, 0.7, 0.28))
			x += ARROW_SPACING
		y += ARROW_SPACING
	draw_circle(mote, 2.0, Color(0.85, 0.92, 1.0, 0.8))
```

**Run it.** One bright speck sets off on a journey it never planned, bending
with the currents. The two `fposmod` lines wrap the screen like a doughnut:
sail off the right edge, arrive at the left. If your mote sits stubbornly
still, check that `_process` ends with `queue_redraw()` — without it Godot
sees no reason to repaint, which is a fair question for it to ask.

### Step 4 — two hundred motes

One idea: arrays. The mote becomes `positions`, a list of 200 starting points,
and everything the one mote did happens in a loop.

```gdscript
extends Node2D

const PARTICLE_COUNT := 200
const CURRENT_SPEED := 42.0   # push from the field, pixels per second
const NOISE_SCALE := 0.003    # field frequency: smaller = broader currents
const FIELD_SEED := 7         # any integer; every seed is a different sea
const ARROW_SPACING := 64.0   # gap between sketched field arrows, pixels
const ARROW_LEN := 16.0       # sketched arrow length, pixels

var noise := FastNoiseLite.new()
var positions: Array[Vector2] = []

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = NOISE_SCALE
	noise.seed = FIELD_SEED
	var view := get_viewport_rect().size
	for i in PARTICLE_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))

func field_at(p: Vector2) -> Vector2:
	# Noise gives a value in -1..1. Scaled up, that is a heading anywhere
	# from -180° to +180° — the full compass (radians in code, so × PI).
	var angle := noise.get_noise_2d(p.x, p.y) * PI
	return Vector2.from_angle(angle)  # a unit arrow pointing that way

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	for i in PARTICLE_COUNT:
		positions[i] += field_at(positions[i]) * CURRENT_SPEED * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.01, 0.05, 0.10))
	var y := ARROW_SPACING / 2.0
	while y < view.y:
		var x := ARROW_SPACING / 2.0
		while x < view.x:
			var foot := Vector2(x, y)
			var tip := foot + field_at(foot) * ARROW_LEN
			draw_line(foot, tip, Color(0.3, 0.55, 0.7, 0.18), 1.0)
			draw_circle(tip, 1.5, Color(0.3, 0.55, 0.7, 0.28))
			x += ARROW_SPACING
		y += ARROW_SPACING
	for i in PARTICLE_COUNT:
		draw_circle(positions[i], 2.0, Color(0.85, 0.92, 1.0, 0.8))
```

**Run it.** The field becomes visible twice over — once as faint arrows, once
as the paths of 200 travellers agreeing about them. Watch a while: specks that
start near each other tend to travel together. Currents make companions.

### Step 5 — make it snow

One idea: this is *marine snow* — a real, slow fall of organic flecks that
drifts down to feed the deep (NOAA's education pages cover it). Two touches
sell it: every fleck gets its own size, and everything sinks a little,
whatever the current says.

```gdscript
extends Node2D

const PARTICLE_COUNT := 200
const CURRENT_SPEED := 42.0   # push from the field, pixels per second
const SINK_SPEED := 10.0      # marine snow settles, pixels per second
const NOISE_SCALE := 0.003    # field frequency: smaller = broader currents
const FIELD_SEED := 7         # any integer; every seed is a different sea
const ARROW_SPACING := 64.0   # gap between sketched field arrows, pixels
const ARROW_LEN := 16.0       # sketched arrow length, pixels

var noise := FastNoiseLite.new()
var positions: Array[Vector2] = []
var sizes: Array[float] = []

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = NOISE_SCALE
	noise.seed = FIELD_SEED
	var view := get_viewport_rect().size
	for i in PARTICLE_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		sizes.append(randf_range(1.0, 2.6))

func field_at(p: Vector2) -> Vector2:
	# Noise gives a value in -1..1. Scaled up, that is a heading anywhere
	# from -180° to +180° — the full compass (radians in code, so × PI).
	var angle := noise.get_noise_2d(p.x, p.y) * PI
	return Vector2.from_angle(angle)  # a unit arrow pointing that way

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	for i in PARTICLE_COUNT:
		var velocity := field_at(positions[i]) * CURRENT_SPEED + Vector2(0.0, SINK_SPEED)
		positions[i] += velocity * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.01, 0.05, 0.10))
	var y := ARROW_SPACING / 2.0
	while y < view.y:
		var x := ARROW_SPACING / 2.0
		while x < view.x:
			var foot := Vector2(x, y)
			var tip := foot + field_at(foot) * ARROW_LEN
			draw_line(foot, tip, Color(0.3, 0.55, 0.7, 0.18), 1.0)
			draw_circle(tip, 1.5, Color(0.3, 0.55, 0.7, 0.28))
			x += ARROW_SPACING
		y += ARROW_SPACING
	for i in PARTICLE_COUNT:
		draw_circle(positions[i], sizes[i], Color(0.85, 0.92, 1.0, 0.8))
```

**Run it.** The drift gains a downward grain, and the mixed sizes read as
depth — small flecks feel far away. If yours looks more like a blizzard than a
snowfall, lower `SINK_SPEED` or `CURRENT_SPEED`; taste is allowed here, and
tuning a constant until water feels like water is real work, not cheating.

### Step 6 — let the weather itself turn

One idea: time as a third axis. Ask the noise a 3D question —
`get_noise_3d(x, y, t)` — and as `t` grows, the whole field eases from one
weather into the next. No arrow snaps; everything *becomes*. This finished
file also lives at [`starter/current_field.gd`](starter/current_field.gd).

```gdscript
# current_field.gd — World 5 · Friendly Waters · Lesson 2 (Currents You Can Trust)
# Draws a vector field made of smooth noise — an arrow pinned to every point
# of space — and 200 flecks of marine snow drifting along it, slowly sinking,
# while the weather itself turns.
# Try changing: NOISE_SCALE. 0.001 gives broad lazy rivers; 0.01 gives
# tight fussy eddies. (Then try TIME_DRIFT := 0.0 — frozen weather.)
extends Node2D

const PARTICLE_COUNT := 200
const CURRENT_SPEED := 42.0   # push from the field, pixels per second
const SINK_SPEED := 10.0      # marine snow settles, pixels per second
const NOISE_SCALE := 0.003    # field frequency: smaller = broader currents
const TIME_DRIFT := 12.0      # how quickly the weather itself changes
const ARROW_SPACING := 64.0   # gap between sketched field arrows, pixels
const ARROW_LEN := 16.0       # sketched arrow length, pixels
const FIELD_SEED := 7         # any integer; every seed is a different sea

var noise := FastNoiseLite.new()
var positions: Array[Vector2] = []
var sizes: Array[float] = []
var time := 0.0

func _ready() -> void:
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
	noise.frequency = NOISE_SCALE
	noise.seed = FIELD_SEED
	var view := get_viewport_rect().size
	for i in PARTICLE_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		sizes.append(randf_range(1.0, 2.6))

func field_at(p: Vector2) -> Vector2:
	# Noise gives a value in -1..1. Scaled up, that is a heading anywhere
	# from -180° to +180° — the full compass (radians in code, so × PI).
	var angle := noise.get_noise_3d(p.x, p.y, time * TIME_DRIFT) * PI
	return Vector2.from_angle(angle)  # a unit arrow pointing that way

func _process(delta: float) -> void:
	time += delta
	var view := get_viewport_rect().size
	for i in PARTICLE_COUNT:
		var velocity := field_at(positions[i]) * CURRENT_SPEED + Vector2(0.0, SINK_SPEED)
		positions[i] += velocity * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.01, 0.05, 0.10))
	# The field, sketched sparsely, so you can see what the snow feels.
	var y := ARROW_SPACING / 2.0
	while y < view.y:
		var x := ARROW_SPACING / 2.0
		while x < view.x:
			var foot := Vector2(x, y)
			var tip := foot + field_at(foot) * ARROW_LEN
			draw_line(foot, tip, Color(0.3, 0.55, 0.7, 0.18), 1.0)
			draw_circle(tip, 1.5, Color(0.3, 0.55, 0.7, 0.28))
			x += ARROW_SPACING
		y += ARROW_SPACING
	# The snow.
	for i in PARTICLE_COUNT:
		draw_circle(positions[i], sizes[i], Color(0.85, 0.92, 1.0, 0.8))
```

**Run it.** Leave it running while you make tea. The arrows lean, reconsider,
lean elsewhere; the snow obliges. It never repeats and never breaks, which is
a strange and lovely property for twelve constants and seventy lines to have.

## You can stop here.

Two hundred snow particles, drifting: promise kept. And notice what this water
*never does to anyone* — it pushes, carries, and redirects, but there is no
arrow that hurts. That's the *Friendly Waters* contract in miniature: in the
game, being swept by a current costs you **position, never progress**. The
ocean is allowed to be strong; it is not allowed to be cruel. Everything below
is bonus.

## Go deeper (optional)

- **The honest flaw: sinks.** Watch long enough (especially with
  `TIME_DRIFT := 0.0`) and you may find spots where arrows point *inward*
  from all sides — the snow slides in and can't leave, piling up like lint.
  Nothing in "noise → angle" promises that flow *out* of a region matches
  flow *in*; real incompressible water can't pile up like that, but our field
  never took physics.
- **The curl trick.** The fix with a famous name: instead of reading noise
  *as* the angle, read the noise's *slope* (which way is uphill) and move
  **sideways** to it — a quarter-turn from the gradient. Flow then follows
  the contour lines of the noise-hills, like wind along the isobars of a
  weather map, and since contours are closed loops, nothing ever piles up —
  no sinks, mathematically guaranteed. That construction is *curl noise*
  (R. Bridson, J. Hourihan & M. Nordenstam, SIGGRAPH 2007). A drop-in
  replacement for `field_at`, measuring the slope with four nearby samples:

  ```gdscript
  const SAMPLE_STEP := 1.0  # how far apart we sample to measure the slope

  func curl_field_at(p: Vector2) -> Vector2:
  	var t := time * TIME_DRIFT
  	var slope_x := (noise.get_noise_3d(p.x + SAMPLE_STEP, p.y, t)
  			- noise.get_noise_3d(p.x - SAMPLE_STEP, p.y, t)) / (2.0 * SAMPLE_STEP)
  	var slope_y := (noise.get_noise_3d(p.x, p.y + SAMPLE_STEP, t)
  			- noise.get_noise_3d(p.x, p.y - SAMPLE_STEP, t)) / (2.0 * SAMPLE_STEP)
  	return Vector2(slope_y, -slope_x).normalized()  # the gradient, turned 90°
  ```

  (The `.normalized()` keeps every current the same strength, trading a
  little physics for a lot of legibility — an honest swap as long as you know
  you made it.)
- **The readable version.** Daniel Shiffman's *The Nature of Code* builds
  noise-driven flow fields step by step, for free, at
  [natureofcode.com](https://natureofcode.com) — the friendliest long-form
  treatment of everything this lesson compressed.
- **Open prompt:** layer two fields — one broad and slow (`NOISE_SCALE`
  0.001), one tight and quick (0.01) — and add their arrows before moving the
  snow. Oceans have weather *and* climate. What third layer would yours have?

## Check yourself

1. What, in one phrase, lives at every point of a vector field?
2. Why smooth noise rather than a fresh random number at every point?
3. The maths box said θ = n × 180°, but the code says `n * PI`. Why the
   costume change?

<details>
<summary>Answers (the repo's version of printing them upside-down)</summary>

1. An arrow — a direction (and here, a strength of 1) pinned to that point.
2. Because neighbouring points must mostly agree for the motion to read as
   water; independent randomness gives jittering static, and nothing can
   *travel* through it.
3. Godot measures angles in radians: π radians and 180° are the same turn in
   different clothes. Degrees for talking, radians for code.

</details>

## Sources

- **Primary:** K. Perlin, "An Image Synthesizer", *Computer Graphics*
  (SIGGRAPH), 1985. The original smooth-noise paper; the gradient-noise
  family behind Godot's `FastNoiseLite` descends from it.
- **Primary:** R. Bridson, J. Hourihan & M. Nordenstam, "Curl-Noise for
  Procedural Fluid Flow", SIGGRAPH, 2007. The divergence-free (no sinks,
  no pile-ups) construction sketched in *Go deeper*.
- **Secondary (free):** Daniel Shiffman, *The Nature of Code*,
  [natureofcode.com](https://natureofcode.com) — the flow-fields material in
  the autonomous-agents chapters is this lesson, at book length and free.
- **Secondary (free):** NOAA Ocean Exploration education pages,
  [oceanexplorer.noaa.gov](https://oceanexplorer.noaa.gov) — marine snow, the
  real slow fall that feeds the deep.

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
