# Lesson 2 · Visitors while you're away

*By the end of this lesson, you'll simulate a whole month of guestbook
entries in about one second — every visit timestamped, none of them demanded
of you.*

## If this is your first time

You can start the series here; nothing in this lesson needs Lesson 1's code.
You'll write two short scripts, and the only new machinery is one line of
arithmetic wearing a raincoat. If randomness has ever felt like the scary part
of programming, this is the lesson where it becomes a friend.

## See it first

Watch rain land on a single paving stone. You cannot say *when* the next drop
will hit it — but you can say roughly *how many* hit it per minute. The drops
don't queue politely: two land almost together, then the stone sits dry for a
while, then three arrive in quick succession. That clustering isn't broken
rain. That's what independent events at a steady average genuinely look like.

Now swap the paving stone for a tidepool, and the raindrops for visiting
creatures. Tidepool Keeper's kindest promise lives right here: the pool keeps
its own company while you're away. Come back after a month and there's a
month of guestbook entries waiting — uncapped, nothing wilted, nothing
expired, no streak to have broken. But a game can't sit for a month waiting
for real time to pass. It needs to *manufacture* the month, honestly, the
moment you return. Instead of waiting through the gaps between visits, we'll
learn to write the gaps down directly — and then fast-forward through all of
them in a blink.

One more thing the sea insists on: the pool itself breathes. Tides come in
and go out on a clock set by the moon, and it isn't a 12-hour clock or a
24-hour clock. It's stranger and lovelier than that, and it's the second half
of this lesson.

## The maths, small

> **Three new symbols**, each in words:
>
> - **λ** *(lambda)* — the average rate: visitors per hour. The one number
>   that describes how busy the pool is.
> - **u** — a random fraction between 0 and 1, drawn fresh each time. In
>   Godot this is `randf()`.
> - **ln** — the natural logarithm, the un-doing of last lesson's `e`.
>   (In GDScript, plain `log()` is the natural logarithm.)
>
> **The gap between one visit and the next:**
>
> ```
> gap = -ln(u) / λ
> ```
>
> *In words: draw a random fraction; take its natural logarithm, which is a
> negative number; flip the sign to make it a positive wait; divide by the
> rate so the wait comes out in hours.*
>
> Why it feels like rain: when `u` lands near 1, `ln(u)` is near 0 — a tiny
> gap, drops clustering. When `u` lands near 0, `ln(u)` is hugely negative —
> flipped positive, a long dry spell. Most gaps are short, a few are long,
> and the average gap is exactly **1/λ**. Gaps shaped like this follow the
> **exponential distribution**, and arrivals built from such gaps are called
> a **Poisson process** — the standard mathematics of "independent events at
> an average rate" (Grinstead & Snell have a free chapter on both).
>
> With λ at 4 visits per day (one per 6 hours on average): u = 0.9 gives a
> gap of about 38 minutes; u = 0.5 gives about 4.2 hours; u = 0.05 gives
> about 18 hours. Same formula, honest variety.
>
> **The tide clock** — no new symbols, one splendid number. Most coasts get
> two high tides per lunar day, and a lunar day is 24 hours 50 minutes,
> because the moon drifts along its orbit while the Earth spins. So high
> tides arrive about **12 hours 25 minutes** apart (NOAA). Oceanographers
> call the main lunar ingredient of the tide **M2**, period ≈ 12.42 hours,
> and the pool's freshness can ride one sine wave of that period:
>
> ```
> tide = sin(360° · t / 12.42 h)
> ```
>
> *In words: one smooth wave that repeats every 12 hours 25 minutes — +1 at
> high water, −1 at low.* The idea of predicting real tides by adding simple
> waves like this goes back to William Thomson (later Lord Kelvin), who began
> harmonic tide prediction in 1867. Our pool needs only the one wave.

## Build it

**Step 1 — ten gaps, printed.** New scene, one Node2D, attach a script
(Lesson 1, Step 1 has the click-by-click if you'd like it). Paste:

```gdscript
# visits.gd — Lesson 2, milestone 1: ten raindrop gaps, printed
extends Node2D

const VISITS_PER_DAY := 4.0   # λ, the average arrival rate

func _ready() -> void:
	randomize()   # fresh randomness every run
	var rate_per_hour := VISITS_PER_DAY / 24.0
	for i in 10:
		var u := maxf(randf(), 0.0000001)   # never exactly 0: ln(0) has no answer
		var gap_hours := -log(u) / rate_per_hour
		print("gap %d: %.1f hours" % [i + 1, gap_hours])
```

That `maxf(...)` line is worth a pause: `randf()` can, on a rare day, return
exactly 0, and `log(0)` is a question with no answer — the computer would ask
us to clarify, mid-month. We clarify in advance by never handing it a zero.

**Expected result:** ten uneven numbers in the Output panel — several small,
one or two whoppers, averaging somewhere near 6. Run it again: different
numbers, same *texture*. If your numbers don't match anyone else's, that is
the entire point.

**Step 2 — the month in one second.** Gaps become arrival times by adding
them up: first visit at gap₁, second at gap₁ + gap₂, and so on until the
month runs out. Replace the whole script:

```gdscript
# visits.gd — Lesson 2, milestone 2: a month of arrivals, printed
extends Node2D

const VISITS_PER_DAY := 4.0   # λ, the average arrival rate
const DAYS_AWAY := 30.0       # how long the pool kept its own company

var visit_hours: Array[float] = []   # when each guest arrived, in hours

func _ready() -> void:
	randomize()   # a fresh month every run (use seed(3) to replay one month)
	var rate_per_hour := VISITS_PER_DAY / 24.0
	var t := 0.0
	while true:
		var u := maxf(randf(), 0.0000001)   # never exactly 0: ln(0) has no answer
		t += -log(u) / rate_per_hour        # the exponential gap: -ln(u)/λ
		if t > DAYS_AWAY * 24.0:
			break
		visit_hours.append(t)
	print_guestbook()

func print_guestbook() -> void:
	print("=== Guestbook: %d days away, %d visits ===" % [int(DAYS_AWAY), visit_hours.size()])
	for t in visit_hours:
		var day := int(t / 24.0) + 1
		var hour := int(t) % 24
		var minute := int(fmod(t, 1.0) * 60.0)
		print("Day %02d · %02d:%02d · a visitor came by" % [day, hour, minute])
	print("=== Nothing expired while you were gone. ===")
```

**Expected result:** around 120 lines pour past — `Day 07 · 03:41 · a visitor
came by` — a whole month, in the time it took you to blink. Some
days hold five visits, some days one, the occasional day none. Your total
will wobble around 120 from run to run, and that wobble is randomness being
truthful, not sloppy.

**You can stop here.** You have simulated a month of away-time in one second,
and the guestbook proves it. That's the mechanic. Everything below adds the
sea.

**Step 3 — the tide clock joins.** The pool breathes on the M2 rhythm, so
let's stamp each visit with the water it arrived on. One switch to announce:
in the maths box we wrote the wave with 360°, but `sin()` in code wants
radians, so a full circle is `TAU` — that's the whole conversion. Replace the
script:

```gdscript
# visits.gd — Lesson 2, milestone 3: the guestbook learns the tide
extends Node2D

const VISITS_PER_DAY := 4.0     # λ, the average arrival rate
const DAYS_AWAY := 30.0         # how long the pool kept its own company
const TIDE_PERIOD_H := 12.42    # M2, the main lunar tide: ~12 h 25 min (NOAA)

var visit_hours: Array[float] = []   # when each guest arrived, in hours

func _ready() -> void:
	randomize()   # a fresh month every run (use seed(3) to replay one month)
	var rate_per_hour := VISITS_PER_DAY / 24.0
	var t := 0.0
	while true:
		var u := maxf(randf(), 0.0000001)   # never exactly 0: ln(0) has no answer
		t += -log(u) / rate_per_hour        # the exponential gap: -ln(u)/λ
		if t > DAYS_AWAY * 24.0:
			break
		visit_hours.append(t)
	print_guestbook()

func print_guestbook() -> void:
	print("=== Guestbook: %d days away, %d visits ===" % [int(DAYS_AWAY), visit_hours.size()])
	for t in visit_hours:
		var day := int(t / 24.0) + 1
		var hour := int(t) % 24
		var minute := int(fmod(t, 1.0) * 60.0)
		print("Day %02d · %02d:%02d · a visitor came %s" % [day, hour, minute, tide_word(t)])
	print("=== Nothing expired while you were gone. ===")

func tide_height(t_hours: float) -> float:
	return sin(TAU * t_hours / TIDE_PERIOD_H)   # -1 low water .. +1 high water

func tide_word(t_hours: float) -> String:
	var h := tide_height(t_hours)
	if h > 0.5:
		return "at high water, when the pool brims"
	if h < -0.5:
		return "at low water, when the pool lies quiet"
	return "while the tide was turning"
```

**Expected result:** the same month, now written like a naturalist kept it:
`Day 12 · 14:06 · a visitor came at high water, when the pool brims`. Notice
the highs don't land at the same clock time each day — they drift 50 minutes
later daily, because the moon does.

**Step 4 — draw the week.** A month of tide wiggles is about 58 cycles —
texture, not a picture. One week is about 13½ cycles — a picture. So we print
the month and *draw* week one. This is the full starter file
([starter/visits.gd](starter/visits.gd)):

```gdscript
# visits.gd — World 3 · Tidepool Keeper · Lesson 2 "Visitors while you're away"
# Simulates a month of tidepool visits in one blink, then shows week one.
#   Gaps between visits: exponential, gap = -ln(u)/λ  (Poisson arrivals).
#   Tide clock: one sine with the M2 lunar period, about 12 h 25 min (NOAA).
# Console: the whole month's guestbook. Screen: the first week as a timeline.
# One thing to try changing: VISITS_PER_DAY (try 24, then 0.5).
extends Node2D

const VISITS_PER_DAY := 4.0     # λ, the average arrival rate
const DAYS_AWAY := 30.0         # how long the pool kept its own company
const TIDE_PERIOD_H := 12.42    # M2, the main lunar tide: ~12 h 25 min (NOAA)
const DRAW_DAYS := 7.0          # how much of the month the timeline shows
const WAVE_HEIGHT := 60.0       # tide wave height on screen, pixels
const MARGIN := 80.0
const INK := Color(0.92, 0.97, 0.95)
const WAVE := Color(0.35, 0.75, 0.72)
const SEA := Color(0.03, 0.09, 0.11)

var visit_hours: Array[float] = []   # when each guest arrived, in hours

func _ready() -> void:
	randomize()   # a fresh month every run (use seed(3) to replay one month)
	var rate_per_hour := VISITS_PER_DAY / 24.0
	var t := 0.0
	while true:
		var u := maxf(randf(), 0.0000001)   # never exactly 0: ln(0) has no answer
		t += -log(u) / rate_per_hour        # the exponential gap: -ln(u)/λ
		if t > DAYS_AWAY * 24.0:
			break
		visit_hours.append(t)
	print_guestbook()

func print_guestbook() -> void:
	print("=== Guestbook: %d days away, %d visits ===" % [int(DAYS_AWAY), visit_hours.size()])
	for t in visit_hours:
		var day := int(t / 24.0) + 1
		var hour := int(t) % 24
		var minute := int(fmod(t, 1.0) * 60.0)
		print("Day %02d · %02d:%02d · a visitor came %s" % [day, hour, minute, tide_word(t)])
	print("=== Nothing expired while you were gone. ===")

func tide_height(t_hours: float) -> float:
	return sin(TAU * t_hours / TIDE_PERIOD_H)   # -1 low water .. +1 high water

func tide_word(t_hours: float) -> String:
	var h := tide_height(t_hours)
	if h > 0.5:
		return "at high water, when the pool brims"
	if h < -0.5:
		return "at low water, when the pool lies quiet"
	return "while the tide was turning"

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	var mid_y := size.y * 0.5
	var width := size.x - MARGIN * 2.0
	var window_h := DRAW_DAYS * 24.0
	var wave_points := PackedVector2Array()
	for i in int(window_h * 4.0) + 1:        # four pen positions per hour
		var t := i / 4.0
		var x := MARGIN + width * (t / window_h)
		wave_points.append(Vector2(x, mid_y - tide_height(t) * WAVE_HEIGHT))
	draw_polyline(wave_points, WAVE, 2.0)
	for t in visit_hours:
		if t > window_h:
			break
		var x := MARGIN + width * (t / window_h)
		draw_circle(Vector2(x, mid_y - tide_height(t) * WAVE_HEIGHT), 4.0, INK)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(MARGIN, mid_y + WAVE_HEIGHT + 40.0),
		"week one · each dot is a guest, riding the tide it arrived on",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, INK)
```

**Expected result:** the console still prints the month; the window now shows
a soft teal tide breathing across seven days, with a scatter of near-white
dots riding it — each dot one guest, sitting at exactly the water height it
arrived on. Clusters and quiet stretches, like the rain on the stone. If your
dots bunch oddly, run it again — some weeks are like that, and both of you
are correct.

## Go deeper (optional)

- **Make the tide matter.** Right now visits ignore the water. The honest way
  to bend a steady stream toward high tide is called **thinning**: generate
  arrivals as before, then *keep* each one only with probability
  `(1 + tide) / 2` — certain keep at high water, certain skip at low. One
  `if` statement with `randf()` does it. (Raise `VISITS_PER_DAY` to
  compensate, since thinning discards some guests.)
- **A question to sit with:** run the month five times and write down the
  five totals. They differ — yet λ never changed. What exactly did we
  promise the player, and what did we leave to the sea?
- **Open prompt:** a player returns after 90 days to roughly 360 entries.
  Scrolling all of them would be a chore, and this studio doesn't do chores.
  Design the kindest possible *welcome-back summary* — three lines, no
  numbers required. What do you tell them first?

## Check yourself

1. λ is 2 visitors per hour. What's the average gap between visitors?
2. Which draw produces the longer gap: u = 0.9 or u = 0.1 — and why?
3. High tides arrive 12 hours 25 minutes apart, not 12 hours exactly. Where
   do the extra 25 minutes come from?

<details>
<summary>Answers (the internet's version of printing them upside down)</summary>

1. Half an hour — the average gap is always 1/λ.
2. u = 0.1. The natural log of a small fraction is a large negative number;
   the minus sign flips it into a large positive wait. u = 0.9 sits near
   ln(1) = 0, so its gap is short.
3. From the moon's own motion: it drifts along its orbit while the Earth
   spins, so a lunar day is 24 h 50 min, and two tides per lunar day puts
   highs 12 h 25 min apart (NOAA).

</details>

## Sources

- **Secondary (free):** C. M. Grinstead & J. L. Snell, *Introduction to
  Probability* (AMS), free PDF via Dartmouth:
  [math.dartmouth.edu/~prob/prob/prob.pdf](https://math.dartmouth.edu/~prob/prob/prob.pdf)
  — the sections on the Poisson distribution and the exponential density:
  independent arrivals at rate λ have exponentially distributed gaps.
- **Secondary (free):** NOAA National Ocean Service education, *Tides and
  Water Levels* — ["Frequency of Tides — The Lunar Day"](https://oceanservice.noaa.gov/education/tutorial_tides/tides05_lunarday.html):
  lunar day 24 h 50 min; high tides 12 h 25 min apart. NOAA Tides & Currents
  station pages list the constituent by name: M2, the principal lunar
  semidiurnal, period ≈ 12.42 h.
- **Historical note:** William Thomson (later Lord Kelvin) began harmonic
  tide prediction — forecasting real tides by summing simple waves like
  M2 — in 1867.
- **House favourite:** Daniel Shiffman, *The Nature of Code* (free,
  [natureofcode.com](https://natureofcode.com)) — the randomness chapter, for
  more ways to make chance feel like weather instead of dice.
