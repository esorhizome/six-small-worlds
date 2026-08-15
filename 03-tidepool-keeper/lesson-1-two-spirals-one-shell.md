# Lesson 1 · Two spirals, one shell

*By the end of this lesson, both classic spirals are drawn side by side on one
dark screen — and you'll know, at a glance, which one is alive.*

## If this is your first time

Welcome. You need Godot 4.3+ installed and nothing else — no assets, no
downloads, no maths beyond "a circle has 360 degrees". If you'd rather read
along without typing, that counts too; the pictures in your head are the
actual lesson, and the code is there whenever you want it.

## See it first

Picture a rope coiled flat on a ship's deck. Each ring of rope sits snugly
against the last, and every ring is the same thickness — because rope doesn't
grow. Measure the gap between any two neighbouring rings, anywhere in the
coil: same answer every time. Clock springs, rolled-up posters, liquorice
wheels — same family. This is the **Archimedean spiral**, and it's the spiral
of *things*.

Now picture a shell — say, the chambered nautilus. The creature inside adds
new shell at the opening as it grows, and here's the heart of it: **the animal
is bigger this month than last month**, so each new stretch of shell has to be
a bigger copy of the one before. Not "the same amount bigger" — *bigger in
proportion*. The rings don't keep a constant gap; they keep a constant
*ratio*. D'Arcy Thompson described the difference beautifully: a rope is a
coiled cylinder, but a shell is a cone coiled upon itself. This is the
**logarithmic spiral**, and it's the spiral of *growers*.

Even professionals mix these two up. Jacob Bernoulli, who studied the
logarithmic spiral in the 1690s and loved it so much he named it *spira
mirabilis* — "the marvellous spiral" — asked for it to be carved on his
tombstone in Basel, with the motto *Eadem mutata resurgo*: "though changed, I
rise again the same." The stonemason misunderstood the instructions and carved
an Archimedean spiral instead. It is still there, being politely wrong, three
centuries later. By the end of this lesson you will be able to walk past that
tombstone and quietly notice what the mason missed.

## The maths, small

> **Three new symbols**, each in words:
>
> - **r** — the radius: how far the pen is from the centre.
> - **θ** *(theta)* — how far around the pen has turned. (In pictures we'll
>   speak degrees; code will use radians.)
> - **e** — Euler's number, about 2.71828: the mathematics of compounding,
>   the "interest rate" constant.
>
> Two more letters appear, but they're only **numbers you choose**:
> *a* is where the spiral starts, *b* is its pace.
>
> **Archimedean spiral** (Archimedes, c. 225 BC):
>
> ```
> r = a + b·θ
> ```
>
> *In words: start at a, and every bit of turning **adds** the same bit of
> distance.* Each full turn adds the same gap. Rope. Clock spring.
>
> **Logarithmic spiral** (Bernoulli's spira mirabilis):
>
> ```
> r = a · e^(b·θ)
> ```
>
> *In words: start at a, and every bit of turning **multiplies** the distance
> by the same amount.* Each full turn scales the spiral by the same ratio.
> Shell. Grower.
>
> The whole lesson in one line: **adding makes a rope, multiplying makes a
> shell.**

**The myth-check.** You may have seen the poster: a nautilus shell with a
"golden spiral" drawn over it, claiming the shell grows by the golden ratio
φ ≈ 1.618 every quarter turn. It's a lovely poster and it isn't true. In 2005,
Clement Falbo published measurements of real chambered nautilus shells (taken
in 1999 at the California Academy of Sciences): the growth ratios ranged from
1.24 to 1.43, averaging about 1.33 — "not phi", as he put it, and not close.
The nautilus **is** a true logarithmic spiral, which is already wonderful. It
is **not** the golden spiral. When we've built our own spirals below, you'll
get to draw both paces and see the difference with your own eyes.

## Build it

**Step 1 — a scene to draw on.** Open Godot, make a new project, then: *Scene
→ New Scene → 2D Scene*. That gives you one Node2D — our whole stage. Click
the scroll icon next to it (Attach Script), accept the suggested name, and
you're in the code editor. Press F5 to run; Godot will ask which scene is the
main one — choose *Select Current*. **Expected result:** a window of quiet
nothing. That's a working pipeline, and it counts.

**Step 2 — the rope.** Replace the whole script with this. One switch to
announce, as always: the pictures upstairs used degrees, but code stores
angles in radians — `deg_to_rad()` makes the conversion at the door, once.

```gdscript
# spirals.gd — Lesson 1, milestone 1: the Archimedean spiral alone
extends Node2D

const TURNS := 5.0                # how many times the spiral winds around
const STEP_DEG := 2.0             # degrees between pen positions
const ARCH_START := 4.0           # a: starting radius, pixels
const ARCH_GAP_PER_TURN := 22.0   # the constant gap between rings, pixels
const LINE_WIDTH := 2.0
const INK := Color(0.92, 0.97, 0.95)
const SEA := Color(0.03, 0.09, 0.11)

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	draw_polyline(archimedean_points(size * 0.5), INK, LINE_WIDTH)

func archimedean_points(centre: Vector2) -> PackedVector2Array:
	# r = a + b·θ — every turn adds the same gap. A rope coiled on a deck.
	var points := PackedVector2Array()
	var b := ARCH_GAP_PER_TURN / TAU     # gap per turn -> growth per radian
	var step := deg_to_rad(STEP_DEG)     # degrees at the boundary, radians inside
	var theta := 0.0
	while theta <= TURNS * TAU:
		var r := ARCH_START + b * theta
		points.append(centre + Vector2(cos(theta), sin(theta)) * r)
		theta += step
	return points
```

How it works: the pen walks around in small angle steps; at each step we ask
the formula for `r`, then convert "angle and distance" into a screen position
with `cos` and `sin` (the two dials from World 1). `TAU` is the radian name
for one full turn — the same thing as 360°.

**Expected result:** a rope coil of five even rings, centred. Count the gaps
with your eye — all the same, top to bottom. If your spiral is lopsided or
half off screen, you are 90% of the way there: lopsided means it's drawing,
and the constants at the top are yours to nudge.

**Step 3 — the shell joins it.** Now the full file — both spirals, side by
side, with labels. Replace everything with:

```gdscript
# spirals.gd — World 3 · Tidepool Keeper · Lesson 1 "Two spirals, one shell"
# Draws the two classic spirals side by side on one dark screen:
#   left  — Archimedean, r = a + b·θ   (constant GAP: rope coils, clock springs)
#   right — logarithmic, r = a·e^(b·θ) (constant RATIO: shells — the owner grows)
# One thing to try changing: LOG_GROWTH. 0.11 doubles each turn; 0.18 is
# nautilus pace (Falbo 2005); 0.3064 is the golden spiral (set TURNS to 2!).
extends Node2D

const TURNS := 5.0                # how many times each spiral winds around
const STEP_DEG := 2.0             # degrees between pen positions
const ARCH_START := 4.0           # Archimedean a: starting radius, pixels
const ARCH_GAP_PER_TURN := 22.0   # the constant gap between rings, pixels
const LOG_START := 4.0            # logarithmic a: starting radius, pixels
const LOG_GROWTH := 0.11          # logarithmic b: growth pace per radian
const LINE_WIDTH := 2.0
const INK := Color(0.92, 0.97, 0.95)   # near-white line
const SEA := Color(0.03, 0.09, 0.11)   # dark tidepool background

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	var left_centre := Vector2(size.x * 0.28, size.y * 0.5)
	var right_centre := Vector2(size.x * 0.72, size.y * 0.5)
	draw_polyline(archimedean_points(left_centre), INK, LINE_WIDTH)
	draw_polyline(logarithmic_points(right_centre), INK, LINE_WIDTH)
	var font := ThemeDB.fallback_font
	draw_string(font, left_centre + Vector2(-44.0, 190.0), "same gap",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, INK)
	draw_string(font, right_centre + Vector2(-50.0, 190.0), "same ratio",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, INK)

func archimedean_points(centre: Vector2) -> PackedVector2Array:
	# r = a + b·θ — every turn adds the same gap. A rope coiled on a deck.
	var points := PackedVector2Array()
	var b := ARCH_GAP_PER_TURN / TAU         # gap per turn -> growth per radian
	var step := deg_to_rad(STEP_DEG)         # degrees at the boundary, radians inside
	var theta := 0.0
	while theta <= TURNS * TAU:
		var r := ARCH_START + b * theta
		points.append(centre + Vector2(cos(theta), sin(theta)) * r)
		theta += step
	return points

func logarithmic_points(centre: Vector2) -> PackedVector2Array:
	# r = a·e^(b·θ) — every turn MULTIPLIES the radius. A shell, because
	# the creature inside is bigger than it was a turn ago.
	var points := PackedVector2Array()
	var step := deg_to_rad(STEP_DEG)
	var theta := 0.0
	while theta <= TURNS * TAU:
		var r := LOG_START * exp(LOG_GROWTH * theta)
		points.append(centre + Vector2(cos(theta), sin(theta)) * r)
		theta += step
	return points
```

The only genuinely new line is `exp(LOG_GROWTH * theta)` — that's `e` raised
to the power `b·θ`, the multiplying engine. With `LOG_GROWTH` at 0.11, each
full turn multiplies the radius by very nearly 2: the shell doubles every
lap, calmly.

**Expected result:** rope on the left, shell on the right. The left one's
rings march outward in even steps; the right one starts as a tight whisper and
opens like a door. Look between them until the difference stops being a fact
and becomes a *feeling* — the left is finished, the right is going somewhere.

**You can stop here.** Both spirals are drawn, and you can tell which one is
alive. Everything below is a bonus for the curious.

## Go deeper (optional)

- **Draw the myth, then the animal.** The golden spiral is a logarithmic
  spiral that grows by φ ≈ 1.618 every quarter turn, which works out to
  `LOG_GROWTH := 0.3064`. Set that — and set `TURNS := 2.0`, because at that
  pace two turns already multiply the radius by about 47, and five turns
  would leave the county. Run it. Now run Falbo's measured average through
  the same quarter-turn recipe instead: 1.33 gives `LOG_GROWTH := 0.18`.
  That's nautilus pace — noticeably cosier. The poster's mistake is now on
  your screen, in your own handwriting.
- **A question to sit with:** why did `TURNS` have to shrink when the pace
  grew? What does that tell you about how quickly multiplication runs away,
  compared with addition?
- **Open prompt:** design the calmest spiral in the pool. Which family do you
  pick, and which two constants, and why? There's no wrong answer — there's
  only the answer you can defend to a friend.

## Check yourself

1. You measure a spiral and every neighbouring pair of rings is 22 pixels
   apart, all the way out. Which family is it?
2. A creature doubles in size every season, and its shell keeps a perfect
   diary of that. Which spiral is the diary written in, and what stays
   constant — the gap or the ratio?
3. True or false: the chambered nautilus shell is a golden spiral.

<details>
<summary>Answers (the internet's version of printing them upside down)</summary>

1. Archimedean — a constant gap is its whole personality.
2. Logarithmic — growth multiplies, so the ratio between turns stays
   constant while the gaps widen.
3. False. It is a logarithmic spiral, but Falbo's measurements averaged about
   1.33 per quarter turn, not the golden ratio's 1.618. Log-spiral: yes.
   Golden: no.

</details>

## Sources

- **Primary:** Archimedes, *On Spirals*, c. 225 BC. Defined the constant-gap
  spiral as a point moving at a steady speed along a steadily turning line.
  Free to read in T. L. Heath's translation, *The Works of Archimedes*
  (1897), at [archive.org](https://archive.org/details/worksofarchimede00arch).
- **Primary:** C. Falbo, "The Golden Ratio — A Contrary Viewpoint", *The
  College Mathematics Journal* 36(2), 2005, pp. 123–134. Measured real
  nautilus shells: ratios 1.24–1.43, average about 1.33 — logarithmic, not
  golden.
- **Secondary (free):** MacTutor History of Mathematics archive — the
  [Equiangular Spiral](https://mathshistory.st-andrews.ac.uk/Curves/Equiangular/)
  curve page and [Jacob Bernoulli's tomb](https://mathshistory.st-andrews.ac.uk/Extras/Bernoulli_tomb/).
  Bernoulli named the *spira mirabilis* (1692), asked for it on his
  tombstone, and received an Archimedean spiral from the mason instead.
- **Secondary (free):** D'Arcy Thompson, *On Growth and Form* (1917), free at
  [archive.org](https://archive.org/details/ongrowthform00thom) — the chapter
  on the equiangular spiral: shells as logarithmic spirals; the rope-versus-
  cone picture.
- **House favourite:** Daniel Shiffman, *The Nature of Code* (free,
  [natureofcode.com](https://natureofcode.com)) — a gentle home for
  polar-to-screen conversions and much else.
