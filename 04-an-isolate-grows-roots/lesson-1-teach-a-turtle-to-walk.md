# Lesson 1 · Teach a turtle to walk

**Promise:** by the end of this lesson, a fern sprig grows on your screen from
four commands — and your initials appear on the way there.

## If this is your first time

Welcome — you're in the right room. You need Godot 4.3+ (free, about 100 MB,
[godotengine.org](https://godotengine.org)) and nothing else: no assets, no
plugins, no maths beyond what this page hands you. If you'd rather watch than
type today, that counts too; the ideas arrive either way.

## See it first

Stand up (or imagine standing up). Take two steps forward. Quarter-turn to
your left. Two more steps. Quarter-turn left again. Keep going, and you've
walked a square — without ever knowing your coordinates, without a single
number beyond "two steps" and "quarter turn". You knew only two things the
whole time: **where you are** and **which way you're facing**.

Now give that walker a pen, pointed at the floor. Every path becomes a
drawing. That walker-with-a-pen is called a **turtle**, and it understands a
tiny vocabulary:

- `F` — step forward, drawing a line
- `+` — turn left by some fixed angle
- `-` — turn right by the same angle

That's the whole language for today. A fourth command — a bookmark — arrives
at the end of this lesson, and those four together are enough to draw a fern.
Not a picture *of* a fern: the actual branching structure, grown line by line.

**Where the turtle comes from.** The turtle wasn't invented for graphics —
it was invented for children. In the late 1960s, Seymour Papert and
colleagues built the Logo language around a robot turtle that children
steered with commands; his book *Mindstorms* (1980) tells the story. The
deliberate inversion: instead of the computer teaching the child, the child
teaches the computer — you explain walking so clearly that a machine can do
it. Abelson and diSessa's *Turtle Geometry* (1981) then made the book-length
case that this is real mathematics, done on foot. This lesson is that idea,
pointed at plants.

> ## The maths, small
>
> Three symbols, all of them friendly:
>
> - **h** — the *heading*: the direction the turtle faces, as an angle.
> - **s** — the *step*: how far one `F` walks, in pixels.
> - **θ** (theta) — the *turn*: how many degrees one `+` or `-` rotates
>   the heading.
>
> The one formula that matters — where the turtle lands after one step:
>
> ```
> new position = old position + ( cos(h) · s ,  sin(h) · s )
> ```
>
> In plain English: cos and sin convert "an angle and a distance" into "how
> far across and how far down". That's their entire job here. If you've only
> ever met them as calculator buttons, this is what the buttons were for.
>
> We'll write angles in degrees, because humans think in degrees — and the
> code will convert them to radians at the last moment with `deg_to_rad()`,
> because Godot (like most engines) thinks in radians.

## Build it

### Step 1 — prove the pen exists

Make a new Godot project. In an empty scene, add a **Node2D**, attach a new
script to it, and paste this whole file in place of what's there:

```gdscript
extends Node2D

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _draw() -> void:
	draw_circle(Vector2(576, 324), 4.0, Color(0.93, 0.95, 0.90))
```

Press F5 and pick the current scene when Godot asks. **Expected:** a dark
window with one pale dot in the middle. That dot is the pen touching the
paper. If you see it, everything else in this world is downhill.

(`_draw()` is the function Godot calls when a node wants to draw itself;
we'll live inside it all lesson.)

### Step 2 — walk

One new idea: a loop that reads commands one letter at a time. Replace the
script with:

```gdscript
extends Node2D

const STEP := 60.0                    # s — pixels per F
const START := Vector2(576, 420)
const INK := Color(0.93, 0.95, 0.90)

var commands := "FFF"

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _draw() -> void:
	var pos := START
	var heading := -PI / 2            # h — facing up
	var walk := PackedVector2Array([pos])
	for c in commands:
		if c == "F":
			pos += Vector2(cos(heading), sin(heading)) * STEP
			walk.append(pos)
	draw_polyline(walk, INK, 2.0)
```

**Expected:** a vertical line, three steps tall, climbing from the start
point. Each `F` in `"FFF"` moved the pen once.

One honest wrinkle, named out loud: screens count the y-axis *downward*
(row 0 is the top row), so "up" is the negative direction — that's why the
starting heading is `-PI / 2` rather than `+`. Every 2D engine does this;
you've now met it once and it will never ambush you again.

### Step 3 — turn

One new idea: `+` and `-` change the heading and nothing else. Replace the
script with:

```gdscript
extends Node2D

const STEP := 60.0                    # s — pixels per F
const TURN_DEG := 90.0                # θ — degrees per + or -
const START := Vector2(576, 420)
const INK := Color(0.93, 0.95, 0.90)

var commands := "F+F+F+F"

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _draw() -> void:
	var turn := deg_to_rad(TURN_DEG)  # degrees for us, radians for Godot
	var pos := START
	var heading := -PI / 2            # h — facing up
	var walk := PackedVector2Array([pos])
	for c in commands:
		match c:
			"F":
				pos += Vector2(cos(heading), sin(heading)) * STEP
				walk.append(pos)
			"+":
				heading -= turn       # left is minus because y points down
			"-":
				heading += turn
	draw_polyline(walk, INK, 2.0)
```

**Expected:** a square. Walk, turn left, walk, turn left — your standing-up
square from "See it first", drawn by something that can't stand up.

Note the degree-to-radian handoff happens once, at the top: we think in
degrees, the machine works in radians, and `deg_to_rad()` is the border
crossing. And if your square came out as a staircase, you are one sign flip
from glory — check the `-=` and `+=` on `heading`. That's not a failure;
that's the computer asking which way you meant by "left".

### Step 4 — hand-drive it

No new code — new *strings*. You are now the grammar. Try each of these by
changing the two marked lines and re-running:

**A zigzag** (set `TURN_DEG` to `60.0`):

```gdscript
var commands := "F-F++F--F++F--F"
```

**Expected:** a line that climbs the screen in swings — lean right, lean
left, lean right. The doubled turns (`++`, `--`) swing the heading a full
120° each time, past vertical and out the other side; that overshoot is
what makes it a zigzag instead of a stair. The rights and lefts balance out
overall, so it still travels upward. You've drawn a graph without an
equation.

**A letter** (set `TURN_DEG` back to `90.0`):

```gdscript
var commands := "++FF+F"
```

**Expected:** the letter **L**. Read it aloud: the turtle starts facing up,
so `++` spins it half a turn to face down, `FF` draws the tall stroke, `+`
turns left (which, facing down, points it rightward across the screen), and
`F` draws the foot.

Now write your own initials. Letters with diagonals want `TURN_DEG := 45.0`
and more turns in a row (`--` for a sharper corner). If a letter comes out
lopsided, you are 90% of the way there — lopsided means the pen obeyed you,
and the remaining 10% is negotiation.

## You can stop here.

Your initials, drawn by a walking pen you taught yourself — that's the whole
foundation of this world, and it's on your screen. Lesson 2 will be here
whenever you want it (and it will not expire).

## Go deeper (optional)

### The fourth command: a bookmark

A fern is a stem that *pauses* to grow a side branch, then carries on as if
nothing happened. Our turtle can't do that yet — once it walks off along a
branch, it has forgotten where the stem was.

So we give it a bookmark:

- `[` — remember the current position and heading (place a bookmark)
- `]` — teleport back to the most recent bookmark (open the book there)

Bookmarks can nest — a branch can bookmark inside a branch — so the pen
keeps them in a pile and always returns to the top one. (Programmers call
this pile a *stack*; you may keep calling it a pile of bookmarks.)

Replace the script one last time — this is the complete
[`starter/turtle.gd`](starter/turtle.gd):

```gdscript
extends Node2D

const STEP := 24.0                    # s — pixels per F
const TURN_DEG := 25.0                # θ — degrees per + or -
const START := Vector2(576, 560)
const INK := Color(0.93, 0.95, 0.90)

var commands := "FF[+F[+F][-F]][-F[+F][-F]]F[+F][-F]F"

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _draw() -> void:
	var turn := deg_to_rad(TURN_DEG)  # degrees for us, radians for Godot
	var pos := START
	var heading := -PI / 2            # facing up; y points down, so up is minus
	var bookmarks: Array = []         # the pen's pile of bookmarks
	var stroke := PackedVector2Array([pos])
	for c in commands:
		match c:
			"F":
				pos += Vector2(cos(heading), sin(heading)) * STEP
				stroke.append(pos)
			"+":
				heading -= turn       # left is minus because y points down
			"-":
				heading += turn
			"[":
				bookmarks.push_back([pos, heading])
			"]":
				if stroke.size() >= 2:
					draw_polyline(stroke, INK, 2.0)
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
				stroke = PackedVector2Array([pos])
	if stroke.size() >= 2:
		draw_polyline(stroke, INK, 2.0)
```

**Expected:** a small fern sprig — a stem with paired branches, each branch
carrying two little leaflets, and a tuft at the top. Read the command
string slowly and you can hear it: *stem, stem, (branch left: stem, (leaflet
left) (leaflet right)), (same on the right), stem, (leaflet) (leaflet), tip.*

There it is: **a fern from four commands** — walk, turn left, turn right,
bookmark. Every plant in this world, including the roots Florence walks on,
speaks this exact language. The only thing wrong with our sprig is that a
human had to type every letter. Lesson 2 fixes that: the string will write
itself.

Open-ended prompt: hand-write a string that draws a comb. Then a snowflake. Then
an antler. Notice which of the three wants bookmarks and which don't.

## Check yourself

1. The turtle faces up and `TURN_DEG` is 90. After one `+`, which way does
   it face?
2. Why does the code call `deg_to_rad()` before using the angle?
3. In the fern string, what would happen if one `]` were missing?

## Sources

- **Primary:** H. Abelson & A. diSessa, *Turtle Geometry*, MIT Press, 1981.
  The full mathematical treatment of position-plus-heading drawing — the
  book this lesson is a doorway to.
- **Secondary (name + date):** S. Papert, *Mindstorms*, 1980. The Logo
  turtle's origin, told by its inventor: a machine children could teach.
- **Secondary (free):** P. Prusinkiewicz & A. Lindenmayer, *The Algorithmic
  Beauty of Plants*, 1990, chapter 1 — free PDF at
  [algorithmicbotany.org/papers/#abop](http://algorithmicbotany.org/papers/#abop).
  Defines the exact turtle commands (`F`, `+`, `-`, `[`, `]`) we use, and is
  where lesson 2 is headed.

---

<sub>**Answers:** 1. Left — west, toward the left edge of the screen (up
turned 90° anticlockwise). 2. We write angles in degrees because humans
think in degrees; Godot's cos and sin expect radians, so the number crosses
that border once, at the top. 3. The pen would never come back from that
bookmark — the branch would keep the pen, and everything after it would grow
from the branch tip instead of the stem. (Try it: deleting one `]` is a
legal experiment, and the mutant sprig is its own reward.)</sub>

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
