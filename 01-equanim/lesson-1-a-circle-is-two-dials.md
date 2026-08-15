# Lesson 1 · A circle is two dials

*By the end of this lesson, a woven loop of light is turning on your screen —
drawn by two dials called sin and cos.*

## If this is your first time

If you have never written a line of code, you are exactly who this lesson is
for; every line gets explained, and watching without typing still counts. You
will need Godot 4.3 or newer — free, about 100 MB, from
[godotengine.org](https://godotengine.org) — and nothing else. If anything
below feels like too much, look for the line that says **you can stop here**:
stopping there is finishing.

## See it first

Picture a record player, spinning, with a small peg glued near the edge of the
disc. Now light it from two directions at once.

From above, the peg's shadow on the wall slides **left and right, left and
right** — fast through the middle, slowing at each end, like a swing.

From the side, the peg's shadow on the floor slides **up and down** with the
same unhurried in-between rhythm.

Neither shadow knows anything about circles. Each one is a dial: a single
number, wagging back and forth forever. But watch the peg itself and the two
wags combine into a perfect circle. That is the whole secret of this lesson:

- a circle is not one clever thing — it is two humble dials wagging **in step**;
- let one dial reach further than the other and the circle squashes into an
  ellipse;
- let one dial wag **faster** than the other and the path weaves into a
  Lissajous figure — the looping ribbon this lesson promised you.

No symbols yet. Keep the record player.

## The maths, small

> **Three new symbols, each named in words.** (You have already met sin and
> cos — the two wagging shadows — on any calculator.)
>
> | symbol | say it | what it is |
> |---|---|---|
> | `t` | "time" | the one dial we turn; everything else follows it |
> | `a` | "the across speed" | how fast the left-right dial wags |
> | `b` | "the up-down speed" | how fast the up-down dial wags |
>
> The recipe for every point on the curve:
>
> ```text
> x = cos(a · t)
> y = sin(b · t)
> ```
>
> In plain English: *the point's across-position is the cos dial turned at
> speed `a`; its up-down position is the sin dial turned at speed `b`.* When
> `a` and `b` are equal and both dials reach equally far, the path is a
> circle. This way of describing a curve — every coordinate written as a
> recipe in `t` — is called **parametric**, and it is how a computer prefers
> its geometry.
>
> One honest sentence about angles: we will *talk* in degrees (360° is a full
> turn) because degrees are friendly, but the *code* keeps angles in radians,
> the computer's native accent — `TAU` is the code's word for one full turn.

## Build it

### Step 1 — make the room

1. Open Godot and click **New Project**. Name it anything (ours is called
   `six-small-worlds`), pick any renderer, click **Create & Edit**.
2. In the Scene dock (top left), click **2D Scene**. You now have one node
   called `Node2D` — a point in space that can draw.
3. Right-click that node, choose **Attach Script**, and accept the suggested
   name. A code editor opens with a few starter lines.
4. Delete everything in that editor — we bring our own.

Nothing is on screen yet. That is correct: an empty room, ready.

### Step 2 — a still circle

One new idea: *walk `t` around one full turn, cook each point with the recipe,
and join the dots.* Replace the whole script with this:

```gdscript
extends Node2D
# Lesson 1, step 2 — a still circle, dot by dot.

const SIZE := 220.0     # how far each dial reaches, in pixels
const SEGMENTS := 256   # how many dots we join; more = smoother
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

func _ready() -> void:
	position = get_viewport_rect().size / 2.0  # stand in the middle

func _draw() -> void:
	var points := PackedVector2Array()  # an empty string of beads
	for i in range(SEGMENTS + 1):
		var t := TAU * float(i) / float(SEGMENTS)  # 0 .. one full turn
		points.append(Vector2(cos(t) * SIZE, sin(t) * SIZE))
	draw_polyline(points, INK, LINE_WIDTH, true)
```

Reading it slowly, once:

- `_ready` runs when the scene wakes; we move our node to the centre.
- `_draw` is where a `Node2D` is allowed to paint. We collect points in a
  `PackedVector2Array` (a tidy list of 2D positions) and hand them to
  `draw_polyline`, which joins them with a line.
- `t` walks from `0` to `TAU` — remember, `TAU` is one full turn, radians
  being the code's accent for our spoken 360°.
- `SEGMENTS + 1` matters: the `+ 1` repeats the first dot at the end, closing
  the loop.

**Run it:** save the scene when Godot asks (any name), press **F5**, and
choose **Select Current** when Godot asks which scene is the main one. You
should see a pale ring resting on a dark grey window.

If instead you see red underlines in the editor, the computer is asking a
clarifying question — most often about indentation. Every line inside a
function starts with one Tab. If your circle is lopsided or partly off screen,
you are 90% of the way there: lopsided means it is drawing.

### Step 3 — make it turn

One new idea: *`_process(delta)` runs every frame, and `delta` is how many
seconds the last frame took — a metronome we can turn dials with.* We add a
travelling bead so you can watch the two dials work in real time:

```gdscript
extends Node2D
# Lesson 1, step 3 — the circle turns: a bead rides the two dials.

const SIZE := 220.0
const SEGMENTS := 256
const BEAD_SECONDS := 6.0   # seconds for one full lap
const BEAD_RADIUS := 6.0
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)
const BEAD := Color(1.0, 0.8, 0.4)

var bead_t := 0.0  # where the bead is along its lap, in radians

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _process(delta: float) -> void:
	bead_t = fmod(bead_t + TAU / BEAD_SECONDS * delta, TAU)
	queue_redraw()  # politely ask for a fresh _draw this frame

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var t := TAU * float(i) / float(SEGMENTS)
		points.append(Vector2(cos(t) * SIZE, sin(t) * SIZE))
	draw_polyline(points, INK, LINE_WIDTH, true)
	draw_circle(Vector2(cos(bead_t) * SIZE, sin(bead_t) * SIZE), BEAD_RADIUS, BEAD)
```

Two small courtesies in there: `queue_redraw()` is how we ask Godot to run
`_draw` again (it never repaints without being asked), and `fmod` wraps the
dial back to the start of each lap — angles are laps, not odometers.

**Run it:** a golden bead circles the ring, once every six seconds. Watch its
shadow in your mind: across, it is pure cos; up-down, pure sin. The circle
turns.

**You can stop here.** A turning circle, built from two dials you now
understand, is a finished thing. Everything below is bonus.

### Step 4 — let the dials reach differently

One new idea: *the two dials don't have to reach equally far.* Give each its
own size and the circle relaxes into an ellipse:

```gdscript
extends Node2D
# Lesson 1, step 4 — unequal reach: an ellipse.

const SIZE_ACROSS := 300.0  # the cos dial's reach
const SIZE_UP := 150.0      # the sin dial's reach
const SEGMENTS := 256
const BEAD_SECONDS := 6.0
const BEAD_RADIUS := 6.0
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)
const BEAD := Color(1.0, 0.8, 0.4)

var bead_t := 0.0

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _process(delta: float) -> void:
	bead_t = fmod(bead_t + TAU / BEAD_SECONDS * delta, TAU)
	queue_redraw()

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var t := TAU * float(i) / float(SEGMENTS)
		points.append(Vector2(cos(t) * SIZE_ACROSS, sin(t) * SIZE_UP))
	draw_polyline(points, INK, LINE_WIDTH, true)
	draw_circle(Vector2(cos(bead_t) * SIZE_ACROSS, sin(bead_t) * SIZE_UP), BEAD_RADIUS, BEAD)
```

**Run it:** a wide, calm ellipse, the bead sweeping fast along the flat sides
and unhurried around the ends. Same two dials; different reach.

### Step 5 — let the dials run at different speeds

One new idea: *speeds `a` and `b` from the maths box, finally in code.* We
also give the recipe a name — `_curve_point` — so the curve and the bead can
share it:

```gdscript
extends Node2D
# Lesson 1, step 5 — dials at different speeds: a Lissajous figure.

const DIAL_A := 3.0   # the across dial laps 3 times...
const DIAL_B := 2.0   # ...while the up-down dial laps twice
const SIZE := 220.0
const SEGMENTS := 512  # a wigglier path deserves more dots
const BEAD_SECONDS := 6.0
const BEAD_RADIUS := 6.0
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)
const BEAD := Color(1.0, 0.8, 0.4)

var bead_t := 0.0

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _process(delta: float) -> void:
	bead_t = fmod(bead_t + TAU / BEAD_SECONDS * delta, TAU)
	queue_redraw()

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var t := TAU * float(i) / float(SEGMENTS)
		points.append(_curve_point(t))
	draw_polyline(points, INK, LINE_WIDTH, true)
	draw_circle(_curve_point(bead_t), BEAD_RADIUS, BEAD)

func _curve_point(t: float) -> Vector2:
	return Vector2(cos(DIAL_A * t) * SIZE, sin(DIAL_B * t) * SIZE)
```

**Run it:** the ring is gone; in its place, a woven pretzel of light, and the
bead threading it without ever lifting off the path. This is a **Lissajous
figure** — the pattern you get whenever two vibrations at different speeds are
plotted against each other. Whole-number speeds like 3 and 2 matter: both
dials finish whole laps at the same instant, so the path closes and repeats.

### Step 6 — let it tumble

One new idea: *a slowly drifting head start.* Give the cos dial an offset that
creeps forward — a `phase` — and the flat weave begins to read as a solid
shape turning in space. Your eye supplies the third dimension free of charge.
This final version is also kept for you at
[`starter/lissajous_card.gd`](starter/lissajous_card.gd):

```gdscript
# lissajous_card.gd — Six Small Worlds · World 1 (equanim) · Lesson 1.
# Draws a Lissajous figure: x follows a cos dial at one speed, y follows a
# sin dial at another. A slow phase drift makes the flat curve appear to
# tumble in 3D. A bead rides the path to show the two dials at work.
# One thing to try changing: DIAL_A to 5.0 and DIAL_B to 4.0 — then watch.
extends Node2D

const DIAL_A := 3.0            # across-dial speed (a in x = cos(a·t))
const DIAL_B := 2.0            # up-down-dial speed (b in y = sin(b·t))
const SIZE := 220.0            # each dial's reach, in pixels
const SEGMENTS := 512          # dots along the curve; more = smoother
const DRIFT_DEG_PER_SEC := 12.0  # phase drift — this is what makes it turn
const BEAD_SECONDS := 6.0      # seconds for the bead's full lap
const BEAD_RADIUS := 6.0
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)
const BEAD := Color(1.0, 0.8, 0.4)

var phase := 0.0   # radians; the cos dial's slowly creeping head start
var bead_t := 0.0  # where the bead is along its lap, in radians

func _process(delta: float) -> void:
	position = get_viewport_rect().size / 2.0  # stay centred, even if resized
	phase += deg_to_rad(DRIFT_DEG_PER_SEC) * delta
	bead_t = fmod(bead_t + TAU / BEAD_SECONDS * delta, TAU)
	queue_redraw()

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var t := TAU * float(i) / float(SEGMENTS)
		points.append(_curve_point(t))
	draw_polyline(points, INK, LINE_WIDTH, true)
	draw_circle(_curve_point(bead_t), BEAD_RADIUS, BEAD)

# The whole lesson in one function: two dials, one point.
func _curve_point(t: float) -> Vector2:
	var x := cos(DIAL_A * t + phase) * SIZE
	var y := sin(DIAL_B * t) * SIZE
	return Vector2(x, y)
```

Note the border crossing: `DRIFT_DEG_PER_SEC` is written in friendly degrees,
and `deg_to_rad` converts it the moment it enters the code's radian world.

**Run it:** the weave turns over slowly, like a wire sculpture on a rotating
plinth. Jules Lissajous first saw curves like these in 1857 — as beams of
light bounced off small mirrors fixed to humming tuning forks — and engineers
still use them on oscilloscopes to compare two frequencies by eye. You made
one with two dials and a metronome.

## Go deeper (optional)

- **Variation:** try dial pairs 5 and 4, 7 and 6, 5 and 3. A question to sit
  with: the closer the two speeds, the more the figure looks like a circle
  seen from an angle — why might that be?
- **Variation:** set `DIAL_A` to a non-whole number such as `2.7`. The path
  never quite closes. What would it fill in, given forever?
- **Question:** the bead moves at constant `t`, yet visibly rushes some
  stretches and lingers on others. Which parts of the path does it rush?
- **Open prompt:** design a card you would hang in a gallery. Choose speeds, a
  reach, a drift, and an ink colour that feel *calm* to you — then write one
  sentence, as a caption, on why.

## Check yourself

1. For the path to be a circle, what must the two dials agree on?
2. Set `DIAL_A := 1.0` and `DIAL_B := 2.0`. What shape appears?
3. The code writes `TAU` where the lesson says "one full turn". How many
   degrees is that, and why does the code not say 360?

Answers are at the very bottom of this page.

## Sources

- **Primary:** J. Lissajous, "Mémoire sur l'étude optique des mouvements
  vibratoires", *Annales de chimie et de physique*, 1857. The origin of these
  curves: vibrations compared by light, mirror to mirror. Scans of the
  *Annales* are freely readable via the Bibliothèque nationale de France's
  Gallica archive ([gallica.bnf.fr](https://gallica.bnf.fr) — search the
  journal title and year).
- **Secondary (free):** Daniel Shiffman, *The Nature of Code*,
  [natureofcode.com](https://natureofcode.com) — the Oscillation chapter walks
  sin, cos, and angular motion at a beginner's pace, with running sketches.
- **Secondary:** J. Dennis Lawrence, *A Catalog of Special Plane Curves*,
  Dover, 1972. A field guide to named curves — the circle, the ellipse, and
  the Lissajous family sit in it alongside hundreds of relatives.

## Answers

<details>
<summary>Unfold when ready</summary>

1. Everything: the same speed (`a = b`) *and* the same reach. Same speed with
   different reach gives an ellipse.
2. A figure of eight lying on its side — the up-down dial wags twice for every
   single wag of the across dial, so the path crosses itself once in the
   middle.
3. 360°. Radians are the computer's native accent for angles, and `TAU` is
   the radian word for one full turn — we speak degrees, the code speaks
   radians, and `deg_to_rad` is the interpreter at the border.

</details>
