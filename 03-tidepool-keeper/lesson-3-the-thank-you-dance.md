# Lesson 3 · The thank-you dance

*By the end of this lesson, a creature draws its signature pattern above the
water — one shy petal on a first visit, and for a best friend, the full
unhurried mandala, slowly turning.*

## If this is your first time

You can begin here — nothing below requires the previous lessons' code. If
you built World 2, the star of this lesson is an old friend returning: the
rose curve from the Garden. If you didn't, one short paragraph in the maths
box tells you everything the flower needs you to know.

## See it first

Think about how a friend signs a birthday card. The signature is always
recognisably *theirs* — same loops, same slant — but how much they write
depends on how well they know you. A colleague gets initials. An old friend
gets the full flourish and a postscript.

Tidepool Keeper's creatures say thank you the same way. Every species has one
signature pattern it draws above the water — the same shape its whole life.
What changes is *how much of the shape it trusts you with*. On a first visit:
a single small petal, sketched quickly, done. As friendship deepens, the same
pattern returns with more of itself — more petals, drawn larger, taking its
time. Best-friend status earns the complete mandala, once, unhurried, with a
slow turn like something catching the light. In the finished game these
drawings are collected in the Pattern Journal, a naturalist's notebook of
every dance you've been trusted with. Tonight you'll build the dance itself:
one species, two friendship levels, side by side.

The reward, notice, is not a number going up. The reward is *more of the same
beauty*. That's the whole design philosophy of this world, in one screen.

## The maths, small

> **Three new symbols**, each in words:
>
> - **k** — the species' signature number: which pattern this creature draws.
> - **f** — the friendship level, 1 to 5: how much of the pattern appears.
> - **t** — time since the dance began: how far the pen has travelled, and
>   how far the whole drawing has slowly turned.
>
> **The rose curve** (returning from World 2 — or meeting you now):
>
> ```
> r = cos(k·θ)
> ```
>
> *In words: as the pen turns through angle θ, its distance from the centre
> breathes in and out, k times faster than the turning.* Each breath is a
> petal. When k is odd you get exactly k petals; when k is even you get 2k.
> These are the rhodonea ("rose") curves, named by Guido Grandi in the 1720s
> because they looked like roses — which remains the correct reaction.
>
> **Friendship as a window.** An odd-k rose is complete after half a turn —
> 180 degrees, which the code will call π radians (that's the whole
> degrees-to-radians switch for this lesson). We let friendship decide how
> much of that span exists at all:
>
> ```
> θ runs from 0 to (f / 5) · 180°
> ```
>
> *In words: a level-1 friend gets one-fifth of the pattern; a level-5 friend
> gets all of it.* With k = 5 the arithmetic aligns perfectly: each
> friendship level is exactly one more petal.
>
> **Size and spin** are gentler still: the drawing's radius grows with f, and
> the finished shape rotates slowly with t — a constant, calm few degrees per
> second. Growth says *our friendship is bigger*; the spin says *this moment
> is alive*.

## Build it

**Step 1 — one whole rose, holding still.** New scene, one Node2D, attach a
script (Lesson 1, Step 1 has the click-by-click). Paste:

```gdscript
# thanks_dance.gd — Lesson 3, milestone 1: one whole rose, holding still
extends Node2D

const SPECIES_K := 5.0          # the signature number (odd k draws k petals)
const FULL_SPAN_RAD := PI       # an odd-k rose completes in half a turn (180°)
const DANCE_SIZE := 120.0       # radius of the pattern, pixels
const STEP_DEG := 1.0           # degrees between pen positions
const LINE_WIDTH := 2.0
const INK := Color(0.92, 0.97, 0.95)
const SEA := Color(0.03, 0.09, 0.11)

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	var points := PackedVector2Array()
	var step := deg_to_rad(STEP_DEG)   # degrees at the boundary, radians inside
	var theta := 0.0
	while theta <= FULL_SPAN_RAD:
		var r := cos(SPECIES_K * theta) * DANCE_SIZE
		points.append(size * 0.5 + Vector2(cos(theta), sin(theta)) * r)
		theta += step
	draw_polyline(points, INK, LINE_WIDTH)
```

**Expected result:** a five-petal rose, centred, still. Count the petals.
Change `SPECIES_K` to 7.0 and count again — a different species' signature.
(Put it back to 5.0 before Step 2 so our petal-counting stays tidy.) If you
see a circle instead, check that `cos(SPECIES_K * theta)` multiplies *inside*
the cosine — the computer is asking which of the two numbers you meant to
breathe with.

**Step 2 — friendship decides how much rose.** Now the window: friendship
level 1 to 5 chooses how far θ is allowed to travel, and how large the
pattern draws. Replace the script:

```gdscript
# thanks_dance.gd — Lesson 3, milestone 2: friendship decides how much rose
extends Node2D

const SPECIES_K := 5.0          # the signature number (odd k draws k petals)
const FULL_SPAN_RAD := PI       # an odd-k rose completes in half a turn (180°)
const FRIENDSHIP := 1           # try 1, then 3, then 5
const FRIEND_MAX := 5           # friendship levels in this little world
const BASE_SIZE := 26.0         # radius of a level-1 dance, pixels
const SIZE_PER_LEVEL := 22.0    # extra radius per friendship level, pixels
const STEP_DEG := 1.0           # degrees between pen positions
const LINE_WIDTH := 2.0
const INK := Color(0.92, 0.97, 0.95)
const SEA := Color(0.03, 0.09, 0.11)

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	var theta_full := FULL_SPAN_RAD * float(FRIENDSHIP) / float(FRIEND_MAX)
	var dance_size := BASE_SIZE + SIZE_PER_LEVEL * float(FRIENDSHIP - 1)
	var points := PackedVector2Array()
	var step := deg_to_rad(STEP_DEG)   # degrees at the boundary, radians inside
	var theta := 0.0
	while theta <= theta_full:
		var r := cos(SPECIES_K * theta) * dance_size
		points.append(size * 0.5 + Vector2(cos(theta), sin(theta)) * r)
		theta += step
	draw_polyline(points, INK, LINE_WIDTH)
```

**Expected result:** at `FRIENDSHIP := 1`, one small petal — a creature that
met you this morning. Change to 3: three petals, larger. Change to 5: the
whole rose, largest. Run all three; you're watching a relationship in three
screenshots.

**Step 3 — and now, the dance.** A drawing that appears all at once is a
diagram; a drawing that *arrives* is a dance. We give the pen a speed, let
time reveal the curve, and set the finished shape turning slowly. Two dances
share the screen: friendship 1 on the left, friendship 5 on the right. This
is the full starter file ([starter/thanks_dance.gd](starter/thanks_dance.gd)):

```gdscript
# thanks_dance.gd — World 3 · Tidepool Keeper · Lesson 3 "The thank-you dance"
# One species' signature pattern (a rose curve, r = cos(k·θ)) danced twice:
#   left  — friendship level 1: one small petal, drawn quickly, then held
#   right — friendship level 5: the full mandala, unhurried
# The pattern draws itself in, grows with friendship, and turns slowly.
# One thing to try changing: SPECIES_K — every species signs with its own k.
extends Node2D

const SPECIES_K := 5.0          # the signature number (odd k draws k petals)
const FULL_SPAN_RAD := PI       # an odd-k rose completes in half a turn (180°)
const FRIEND_MAX := 5           # friendship levels in this little world
const BASE_SIZE := 26.0         # radius of a level-1 dance, pixels
const SIZE_PER_LEVEL := 22.0    # extra radius per friendship level, pixels
const PEN_SPEED := 0.5          # radians of θ drawn per second — the tempo
const SPIN_DEG_PER_SEC := 4.0   # the slow turn (degrees here, radians inside)
const STEP_DEG := 1.0           # degrees between pen positions
const LINE_WIDTH := 2.0
const INK := Color(0.92, 0.97, 0.95)
const SEA := Color(0.03, 0.09, 0.11)

var elapsed := 0.0   # seconds since the dance began

func _process(delta: float) -> void:
	elapsed += delta
	queue_redraw()

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	draw_dance(Vector2(size.x * 0.28, size.y * 0.5), 1)
	draw_dance(Vector2(size.x * 0.72, size.y * 0.5), 5)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(size.x * 0.28 - 48.0, size.y * 0.85), "first visit",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, INK)
	draw_string(font, Vector2(size.x * 0.72 - 52.0, size.y * 0.85), "best friend",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, INK)

func draw_dance(centre: Vector2, friendship: int) -> void:
	# Friendship decides how much of the rose exists at all...
	var theta_full := FULL_SPAN_RAD * float(friendship) / float(FRIEND_MAX)
	# ...and the pen has drawn only as far as time allows. That IS the dance.
	var theta_now := minf(elapsed * PEN_SPEED, theta_full)
	var dance_size := BASE_SIZE + SIZE_PER_LEVEL * float(friendship - 1)
	var spin := deg_to_rad(SPIN_DEG_PER_SEC) * elapsed
	var step := deg_to_rad(STEP_DEG)
	var points := PackedVector2Array()
	var theta := 0.0
	while theta <= theta_now:
		var r := cos(SPECIES_K * theta) * dance_size
		points.append(centre + Vector2(cos(theta + spin), sin(theta + spin)) * r)
		theta += step
	if points.size() >= 2:
		draw_polyline(points, INK, LINE_WIDTH)
```

Three small ideas hold it up. `_process(delta)` accumulates `elapsed` and
calls `queue_redraw()`, so the picture refreshes every frame. `theta_now`
is the pen's honest position: time multiplied by tempo, but never past what
friendship allows — `minf` is the chaperone. And the spin is added to the
*position* angle (`theta + spin`) while the rose's breathing (`cos(SPECIES_K
* theta)`) stays untouched, so the finished shape rotates rigidly instead of
morphing.

**Expected result:** the left dance finishes its single petal in about a
second and rests, turning gently — polite, brief, complete. The right dance
is still going: petal after petal at the same pen speed, taking around six
seconds to close the mandala, because there is five times more of it and it
declines to hurry. Both keep slowly rotating afterwards. Sit and watch one
full mandala arrive without touching anything. That patience is the mechanic.

**You can stop here.** One creature, two friendships, both dances on screen —
the reward that is also the collection. Below is bonus territory.

## Go deeper (optional)

- **A different species.** Change `SPECIES_K` to 7.0 (seven petals), then
  4.0 — and count. Even k gives *2k* petals, but only if you also give it
  room: an even-k rose needs a full turn, so set `FULL_SPAN_RAD := TAU`.
- **A stranger signature.** k doesn't have to be a whole number. Try
  `SPECIES_K := 2.5` with `FULL_SPAN_RAD := 2.0 * TAU` (the curve needs two
  full turns — 720° — to find its way home). Some species are like that.
- **A question to sit with:** the level-5 dance takes five times longer with
  the same `PEN_SPEED`. Suppose you "fixed" that by speeding the pen up for
  higher levels, so every dance lasted one second. What exactly would be
  lost? Whom would the dance be for, then?
- **Open prompt:** sketch (on paper — no code) a Pattern Journal page for one
  species: five friendship stages of one signature on a single page. What
  goes where, and what does the empty fifth slot promise a player without
  threatening them?

## Check yourself

1. A species signs with k = 7. How many petals in its complete pattern?
2. With k = 5 and friendship level 3 of 5, how many petals appear?
3. The best-friend dance draws for longer even though `PEN_SPEED` never
   changed. Why?

<details>
<summary>Answers (the internet's version of printing them upside down)</summary>

1. Seven — odd k draws exactly k petals.
2. Three — friendship 3 opens three-fifths of the 180° window, and with
   k = 5 each fifth is exactly one petal.
3. Because friendship widened the window: there is five times more θ to
   travel at the same tempo. The dance is longer because there is more to
   say, not because anything slowed down.

</details>

## Sources

- **Secondary (free):** MacTutor History of Mathematics archive —
  [Rhodonea Curves](https://mathshistory.st-andrews.ac.uk/Curves/Rhodonea/).
  Named by Guido Grandi in the 1720s; odd k gives k petals, even k gives 2k.
- **Secondary (free):** this repo's own
  [World 2, Lesson 2 — "A garden from an equation"](../02-upgrade-biotech/)
  (episode E05), where the rose curve first blooms; and Lesson 1 of this
  world for r and θ.
- **House favourite:** Daniel Shiffman, *The Nature of Code* (free,
  [natureofcode.com](https://natureofcode.com)) — angles, oscillation, and
  polar coordinates, gently.

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
