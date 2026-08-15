# Lesson 3 · Wireframes that turn

*By the end of this lesson, a wire cube is turning on your flat 2D screen —
eight dots, twelve lines, and the two dials from lesson 1 doing all the work.*

## If this is your first time

You can begin here, but this lesson leans on lesson 1's one idea — sin and
cos as two wagging dials — so a ten-minute detour there will repay itself.
You need Godot 4.3 or newer. As always, the **you can stop here** line marks
a finished, satisfying version; everything after it is a gift, not a debt.

## See it first

Build a cube out of drinking straws — twelve straws, eight blobs of glue —
and hold it in torchlight against a wall. The shadow is flat. It has no
depth, no far side, no near side. And yet, as you turn the cube in your
fingers, nobody watching the wall doubts for a second that they are seeing a
cube turn.

That shadow is the whole lesson. A screen is a wall: it can only ever show
flat pictures. So-called 3D graphics is the art of holding a shape in an
imaginary hand, turning it, and computing where its shadow lands — many times
a second. Today we do the smallest honest version of that:

- keep a list of the cube's eight corners as *numbers*;
- turn them all, together, with two dials — one turn side-to-side, one nod
  forward — the same cos and sin as lesson 1;
- flatten each turned corner onto the wall, and draw the twelve straws.

No camera, no engine magic, no hidden help. Eight dots, honestly pushed
around.

## The maths, small

> **Three new symbols, each named in words.**
>
> | symbol | say it | what it is |
> |---|---|---|
> | `z` | "depth" | a third address: how far *into* the screen a point sits |
> | `α` | "alpha, the yaw" | the turn dial — spinning left-right, like a record |
> | `β` | "beta, the pitch" | the nod dial — tipping forward, like a bow |
>
> To turn a point `(x, y, z)` about the vertical axis by yaw `α`, graphics
> people write a **rotation matrix**:
>
> ```text
>           [  cos α   0   sin α ]        x' =  x·cos α + z·sin α
> around Y: [    0     1     0   ]   i.e. y' =  y
>           [ −sin α   0   cos α ]        z' = −x·sin α + z·cos α
> ```
>
> Read the table in words: *each new coordinate is a mix of the old ones, and
> the matrix says how much of each goes in.* The pattern to keep: **cos keeps
> your own coordinate, sin borrows from the other one** — x and z gently
> trade places as the dial turns, while y sits on the axis and rides along
> unchanged. It is lesson 1's circle recipe, wearing a suit.
>
> The nod is the same table rotated to face the other axis — now y and z do
> the trading, by pitch `β`:
>
> ```text
> y'' = y'·cos β − z'·sin β
> z'' = y'·sin β + z'·cos β
> ```
>
> Last, the flattening. Keep x, keep y, and let z go — thank it for its
> service. Dropping depth like this is called an **orthographic projection**,
> and it is the humblest projection there is: no lens, no vanishing point,
> honest as a shadow at noon.
>
> (Degrees when we speak, radians in the code, `deg_to_rad` at the border —
> same treaty as always.)

## Build it

### Step 1 — a third card

As before: a fresh 2D scene, one `Node2D`, attach a script, clear it out.
(**F6** runs the scene you are looking at.)

### Step 2 — eight corners, twelve edges

One new idea: *a 3D point is three numbers* — Godot calls that a `Vector3`.
We list the corners, list which corner joins which, flatten with no turning
at all, and draw:

```gdscript
extends Node2D
# Lesson 3, step 2 — a cube stored as numbers, flattened, not yet turned.

const CORNERS := [
	Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(1, 1, -1), Vector3(-1, 1, -1),
	Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(1, 1, 1), Vector3(-1, 1, 1),
]
const EDGES := [
	[0, 1], [1, 2], [2, 3], [3, 0],  # the back face
	[4, 5], [5, 6], [6, 7], [7, 4],  # the front face
	[0, 4], [1, 5], [2, 6], [3, 7],  # four struts between them
]
const SCALE_PX := 140.0  # 1 maths unit = this many pixels
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _draw() -> void:
	var flat := PackedVector2Array()
	for corner in CORNERS:
		flat.append(_project(corner))
	for edge in EDGES:
		draw_line(flat[edge[0]], flat[edge[1]], INK, LINE_WIDTH, true)

# Orthographic projection: keep x and y, let z go.
func _project(p: Vector3) -> Vector2:
	return Vector2(p.x, p.y) * SCALE_PX
```

Every corner is one maths unit from the centre along each axis, so the cube
is 2 units wide and `SCALE_PX` turns maths units into pixels. The `EDGES`
list holds pairs of corner *numbers* — twelve pairs, one straw each. Count
them; a famous check at the end of this lesson will ask.

**Run it:** a single square. Not broken — the computer is asking a
clarifying question: *"you dropped z; the front face lands exactly on the
back face — how would you like to tell them apart?"* All eight corners are on
screen, hiding in perfect pairs. We answer by turning.

### Step 3 — the first dial: yaw

One new idea: *rotate every corner before projecting.* The `_turn` function
below is the maths box's first table, written as two plain lines — cos keeps,
sin borrows:

```gdscript
extends Node2D
# Lesson 3, step 3 — the yaw dial: the cube spins like a record.

const CORNERS := [
	Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(1, 1, -1), Vector3(-1, 1, -1),
	Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(1, 1, 1), Vector3(-1, 1, 1),
]
const EDGES := [
	[0, 1], [1, 2], [2, 3], [3, 0],
	[4, 5], [5, 6], [6, 7], [7, 4],
	[0, 4], [1, 5], [2, 6], [3, 7],
]
const SCALE_PX := 140.0
const YAW_DEG_PER_SEC := 24.0  # the turn dial's speed
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

var yaw := 0.0  # radians

func _ready() -> void:
	position = get_viewport_rect().size / 2.0

func _process(delta: float) -> void:
	yaw += deg_to_rad(YAW_DEG_PER_SEC) * delta
	queue_redraw()

func _draw() -> void:
	var flat := PackedVector2Array()
	for corner in CORNERS:
		flat.append(_project(_turn(corner)))
	for edge in EDGES:
		draw_line(flat[edge[0]], flat[edge[1]], INK, LINE_WIDTH, true)

# Yaw: x and z trade places gradually; y rides unchanged.
func _turn(p: Vector3) -> Vector3:
	return Vector3(
		p.x * cos(yaw) + p.z * sin(yaw),
		p.y,
		-p.x * sin(yaw) + p.z * cos(yaw))

func _project(p: Vector3) -> Vector2:
	return Vector2(p.x, p.y) * SCALE_PX
```

The degrees-to-radians treaty again: the speed is written in degrees and
crosses the border through `deg_to_rad`.

**Run it:** the square wakes up. Faces slide across each other; the shape
narrows to a sliver and widens again. It reads more like a box folding flat
than a cube — because we can spin it, but never see its top. Honest progress:
one dial down, one to go.

### Step 4 — the second dial: pitch

One new idea: *a second rotation, straight after the first.* Yaw the point,
then nod the result — y and z trade, by `β`. This final version is kept for
you at [`starter/wire_cube.gd`](starter/wire_cube.gd):

```gdscript
# wire_cube.gd — Six Small Worlds · World 1 (equanim) · Lesson 3.
# A wire cube turning on a 2D screen: eight corners as Vector3, turned by
# two dials (yaw about Y, then pitch about X), flattened by dropping z,
# and drawn as twelve lines. No 3D engine — sin and cos push every corner.
# One thing to try changing: PITCH_DEG_PER_SEC to 0.0 — watch the cube
# lose its top and turn back into a folding square.
extends Node2D

const CORNERS := [
	Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(1, 1, -1), Vector3(-1, 1, -1),
	Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(1, 1, 1), Vector3(-1, 1, 1),
]
const EDGES := [
	[0, 1], [1, 2], [2, 3], [3, 0],  # back face
	[4, 5], [5, 6], [6, 7], [7, 4],  # front face
	[0, 4], [1, 5], [2, 6], [3, 7],  # four struts between them
]
const SCALE_PX := 140.0         # 1 maths unit = this many pixels
const YAW_DEG_PER_SEC := 24.0   # turn about the vertical axis
const PITCH_DEG_PER_SEC := 9.0  # nod about the horizontal axis
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

var yaw := 0.0    # radians
var pitch := 0.0  # radians

func _process(delta: float) -> void:
	position = get_viewport_rect().size / 2.0  # stay centred, even if resized
	yaw += deg_to_rad(YAW_DEG_PER_SEC) * delta
	pitch += deg_to_rad(PITCH_DEG_PER_SEC) * delta
	queue_redraw()

func _draw() -> void:
	var flat := PackedVector2Array()
	for corner in CORNERS:
		flat.append(_project(_turn(corner)))
	for edge in EDGES:  # twelve edges, one line each — count them, Euler will ask
		draw_line(flat[edge[0]], flat[edge[1]], INK, LINE_WIDTH, true)

# The lesson-1 dials, twice over: yaw trades x with z, pitch trades y with z.
# cos keeps your own coordinate, sin borrows the other — that is the matrix.
func _turn(p: Vector3) -> Vector3:
	var yawed := Vector3(
		p.x * cos(yaw) + p.z * sin(yaw),
		p.y,
		-p.x * sin(yaw) + p.z * cos(yaw))
	return Vector3(
		yawed.x,
		yawed.y * cos(pitch) - yawed.z * sin(pitch),
		yawed.y * sin(pitch) + yawed.z * cos(pitch))

# Orthographic projection: keep x and y, let z go.
func _project(p: Vector3) -> Vector2:
	return Vector2(p.x, p.y) * SCALE_PX
```

The two dial speeds are deliberately different (24 and 9 degrees per second),
so the tumble takes a long time to repeat itself — the cube keeps finding new
angles to show you.

**Run it:** there it is. A wire cube, turning on its own, tops and corners
and all — on a screen that only ever drew flat lines. If yours turns the
opposite way to a friend's, one of you has a mirrored sign in `_turn`; both
cubes are correct, like clocks seen from either side of the glass.

**You can stop here.** A cube turns on its own, and you know where every
line of it comes from. In *equanim* — the calm gallery this world is drawn
from — every card is exactly this: a wireframe held in numbers, turned, and
flattened onto the glass, 2,756 times across its 53 catalogues. You have
built the atom.

## Go deeper (optional)

- **Variation:** take the cube in hand. Bring lesson 2's drag gesture across
  and let the mouse drive the dials:

  ```gdscript
  const DRAG_DEG_PER_PIXEL := 0.4

  func _unhandled_input(event: InputEvent) -> void:
  	if event is InputEventMouseMotion and event.button_mask == MOUSE_BUTTON_MASK_LEFT:
  		yaw += deg_to_rad(DRAG_DEG_PER_PIXEL) * event.relative.x
  		pitch += deg_to_rad(DRAG_DEG_PER_PIXEL) * event.relative.y
  ```

  Sideways drag turns, upward drag nods — a gallery card you hold.
- **Variation:** new corners, same pipeline. An octahedron is six corners —
  `(±1, 0, 0)`, `(0, ±1, 0)`, `(0, 0, ±1)` — and twelve edges joining every
  corner to its four non-opposite fellows. The drawing code doesn't change
  at all; only the two lists do.
- **Question:** our projection drops z entirely, so far edges draw as large
  as near ones. Real eyes shrink the far. What would happen if, before
  dropping z, you divided x and y by `(4.0 - z)`? Try it.
- **Open prompt:** the cube and the octahedron belong to a family of exactly
  five perfectly regular solids — Euclid closed his *Elements* by
  constructing all five and showing no sixth can exist. Pick one you haven't
  drawn, list its corners on paper first, and hang it in your gallery.

## Check yourself

1. Count the cube's corners (V), edges (E) and faces (F), then compute
   V − E + F. Euler's formula says what you should get — for the cube and for
   every polyhedron without holes.
2. Before the dials, the flattened cube looked like one lone square. Why?
3. The octahedron has 6 corners, 12 edges, 8 faces. Does Euler's check still
   hold?

Answers are at the very bottom of this page.

## Sources

- **Primary:** L. Euler, "Elementa doctrinae solidorum", 1758. Where
  V − E + F = 2 — the polyhedron formula this lesson's check rests on — was
  first stated.
- **Primary:** Euclid, *Elements*, Book XIII (c. 300 BC). Constructs the five
  regular solids — our cube among them — and ends by showing there is no
  sixth. Free online in D. Joyce's Clark University edition:
  [aleph0.clarku.edu/~djoyce/java/elements/elements.html](http://aleph0.clarku.edu/~djoyce/java/elements/elements.html).
- **Secondary (free):** Daniel Shiffman, *The Nature of Code*,
  [natureofcode.com](https://natureofcode.com) — the Oscillation chapter is
  the sin-and-cos toolkit this lesson's rotation dials are built from.

## Answers

<details>
<summary>Unfold when ready</summary>

1. V = 8, E = 12, F = 6, so V − E + F = 8 − 12 + 6 = **2**. Euler's formula
   says every polyhedron without holes lands on 2, whatever its shape.
2. The orthographic projection keeps x and y and drops z — and an unturned
   cube's front face has exactly the same x and y as its back face, so the
   two squares land on the same pixels. Eight corners were there all along,
   in four perfect pairs.
3. 6 − 12 + 8 = **2**. It holds — and it will for any corner list you invent
   in the go-deeper, so long as the shape has no holes.

</details>

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
