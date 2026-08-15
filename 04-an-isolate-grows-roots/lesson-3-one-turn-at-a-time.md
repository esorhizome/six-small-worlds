# Lesson 3 · One turn at a time

**Promise:** by the end of this lesson, a root system grows down your screen
in bursts — one burst per click, each burst surging then settling — and if
you click again mid-burst, it politely declines. Growth that refuses to be
hurried.

## If this is your first time

This lesson joins lesson 1's pen to lesson 2's grammar and makes the result
*move*. As always, every step is a complete paste-and-run script, so you can
start here if you like — the earlier ideas are re-introduced as they arrive.
The only maths today is one small cube, and it comes with cushions.

## See it first

Picture a progress bar filling at perfectly constant speed. Now picture a
cat stretching: fast at first, then slower, slower, settling into place.
One of these reads as machinery and one reads as alive, and the difference
is not *what* moves but *how the speed changes*. Constant speed is the one
thing living movement never does.

Animators have a word for shaping speed over time: **easing**. Today we take
the plant from lesson 2, point it downward so it becomes a root system, and
grow it in eased bursts — surge, settle, rest — instead of all at once.

And one more thing, because this world is built from a real game: the bursts
arrive **one per click, and only one**. Clicking during a burst does nothing
except draw a small fading ring where you tapped — an acknowledgment, not a
scolding. In *An Isolate Grows Roots*, Florence's root-legs grow exactly this
way, one deliberate turn at a time, and taps during a turn are refused.
Patience is not the loading screen there. Patience is the game.

> ## The maths, small
>
> Two symbols:
>
> - **t** — time through the current burst, *normalised*: 0 means "the burst
>   is starting", 1 means "the burst is done". (Whatever the burst's real
>   length in seconds, we divide it away first.)
> - **e(t)** — the *eased* progress: how far along the growth actually is
>   at time t.
>
> Linear growth is `e(t) = t` — progress equals time, the robot option. The
> one we want is **ease-out cubic**, from Robert Penner's classic chapter
> (2002) that gave games their standard easing vocabulary:
>
> ```
> e(t) = 1 − (1 − t)³
> ```
>
> In plain English: measure how much time *remains* (1 − t), cube it so it
> shrinks dramatically, and use that as how much progress remains. The
> result starts at full speed and lands with none — a burst, then a
> settling. One number to feel it: at half time, t = 0.5, the eased version
> has already covered 1 − 0.5³ = **0.875** — seven-eighths of the burst in
> half its time. That front-loaded surge is what reads as *growth* rather
> than *filling*.

## Build it

### Step 1 — the root, measured

One new idea: instead of drawing while walking, we *record* the walk — every
segment into a list — so that later we can draw any fraction of it. Two
small changes of scenery, both named honestly: the plant now starts at the
**top** of the screen with a heading of `PI / 2`, which points *down* the
screen (Godot's y-axis grows downward, as lesson 1 warned) — the same
grammar, hung from a seed, is a root system. And as before, the angle is
written in degrees for us and converted once with `deg_to_rad()` for Godot,
which thinks in radians.

New script on a `Node2D`:

```gdscript
extends Node2D

const AXIOM := "X"
const RULES := { "X": "F+[[X]-X]-F[-FX]+X", "F": "FF" }
const ANGLE_DEG := 25.0
const GENERATIONS := 4
const STEP := 7.0                    # every root segment is this long
const START := Vector2(576, 40)      # top centre — roots hang from the seed
const INK := Color(0.93, 0.95, 0.90)

var _segs: Array = []                # recorded segments: [from, to] pairs

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))
	var word := AXIOM
	for i in GENERATIONS:            # the grammar from lesson 2
		var grown := ""
		for c in word:
			grown += str(RULES.get(c, c))
		word = grown
	var turn := deg_to_rad(ANGLE_DEG)
	var pos := START
	var heading := PI / 2            # facing down: this plant is a root
	var bookmarks: Array = []
	for c in word:                   # the walk from lesson 1, recorded
		match c:
			"F":
				var next := pos + Vector2(cos(heading), sin(heading)) * STEP
				_segs.append([pos, next])
				pos = next
			"+": heading -= turn
			"-": heading += turn
			"[": bookmarks.push_back([pos, heading])
			"]":
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]

func _draw() -> void:
	draw_circle(START, 4.0, INK)     # the seed
	for s in _segs:
		draw_line(s[0], s[1], INK, 2.0)
```

**Expected:** the lesson-2 plant, upside-down — a root system hanging from a
pale seed at the top of the window, complete and motionless. Because every
segment is the same length (`STEP`), the recording gives us a ruler for
free: segment number `i` ends at total length `STEP × (i + 1)`. We'll lean
on that ruler for the rest of the lesson.

### Step 2 — growth, the robot way

One new idea: a variable `_shown` — how many pixels of root are visible —
that rises over time while `_draw()` draws only that much. Replace the
`_draw` function and add the rest below it (everything above `_draw` stays
as in step 1):

```gdscript
const GROW_SECONDS := 8.0            # add this line up with the other consts

var _shown := 0.0                    # add this line next to var _segs

func _process(delta: float) -> void:
	var total := STEP * _segs.size()
	_shown = minf(_shown + total / GROW_SECONDS * delta, total)
	queue_redraw()

func _draw() -> void:
	draw_circle(START, 4.0, INK)
	for i in _segs.size():
		if STEP * (i + 1) <= _shown:               # fully grown segments
			draw_line(_segs[i][0], _segs[i][1], INK, 2.0)
		elif STEP * i < _shown:                    # the one growing right now
			var tip: Vector2 = _segs[i][0].lerp(_segs[i][1], (_shown - STEP * i) / STEP)
			draw_line(_segs[i][0], tip, INK, 2.0)
			draw_circle(tip, 3.0, INK)             # a growing tip
```

**Expected:** the root unrolls itself over eight seconds, segment by
segment, retracing the turtle's own journey — including the hops back to
bookmarks. Watch it once admiringly and once critically. Critically, it's
a conveyor belt: perfectly constant speed, the print head of a plotter.
Nothing alive moves like that. (If yours draws instantly, check that
`_process` made it in — `_draw` alone is a photograph; `_process` is the
film.)

### Step 3 — turns, and the polite refusal

One new idea — the turn contract: growth comes in **thirteen bursts** (this
studio has a thing about thirteens; humour it), each burst starts on a
click, and clicks *during* a burst are acknowledged with a fading ring and
otherwise refused. Here is the complete file — this is
[`starter/one_turn.gd`](starter/one_turn.gd). Before running it, set
`EASE := false`; we'll earn the `true` in a moment.

```gdscript
extends Node2D

const AXIOM := "X"
const RULES := { "X": "F+[[X]-X]-F[-FX]+X", "F": "FF" }
const ANGLE_DEG := 25.0
const GENERATIONS := 4
const STEP := 7.0                    # every root segment is this long
const START := Vector2(576, 40)      # top centre — roots hang from the seed
const TURNS := 13                    # growth arrives in thirteen bursts
const TURN_SECONDS := 2.6            # how long one burst takes
const EASE := true                   # false = linear growth, for comparison
const INK := Color(0.93, 0.95, 0.90)

var _segs: Array = []                # recorded segments: [from, to] pairs
var _total := 0.0                    # full length of the finished root
var _shown := 0.0                    # how much of it is visible right now
var _from := 0.0                     # _shown when the current turn began
var _to := 0.0                       # _shown promised by the end of it
var _t := 2.0                        # time through the turn; above 1 = resting
var _rings: Array = []               # [position, age] of politely refused taps

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))
	var word := AXIOM
	for i in GENERATIONS:            # the grammar from lesson 2
		var grown := ""
		for c in word:
			grown += str(RULES.get(c, c))
		word = grown
	var turn := deg_to_rad(ANGLE_DEG)  # degrees at the border, radians inside
	var pos := START
	var heading := PI / 2            # facing down: this plant is a root
	var bookmarks: Array = []
	for c in word:                   # the walk from lesson 1, recorded
		match c:
			"F":
				var next := pos + Vector2(cos(heading), sin(heading)) * STEP
				_segs.append([pos, next])
				pos = next
			"+": heading -= turn
			"-": heading += turn
			"[": bookmarks.push_back([pos, heading])
			"]":
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
	_total = STEP * _segs.size()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if _t <= 1.0:                # mid-turn: the root declines, gently
			_rings.append([event.position, 0.0])
		elif _to < _total:           # resting, not yet finished: a turn begins
			_from = _shown
			_to = minf(_shown + _total / TURNS, _total)
			_t = 0.0

func _process(delta: float) -> void:
	if _t <= 1.0:
		_t = minf(_t + delta / TURN_SECONDS, 1.0)
		var p := 1.0 - pow(1.0 - _t, 3.0) if EASE else _t  # ease-out cubic (Penner)
		_shown = lerpf(_from, _to, p)
		if _t >= 1.0: _t = 2.0       # the turn ends; the root rests
	for ring in _rings: ring[1] += delta * 1.5
	_rings = _rings.filter(func(r): return r[1] < 1.0)
	queue_redraw()

func _draw() -> void:
	draw_circle(START, 4.0, INK)     # the seed, waiting
	for i in _segs.size():
		if STEP * (i + 1) <= _shown:
			draw_line(_segs[i][0], _segs[i][1], INK, 2.0)
		elif STEP * i < _shown:      # the one segment currently growing
			var tip: Vector2 = _segs[i][0].lerp(_segs[i][1], (_shown - STEP * i) / STEP)
			draw_line(_segs[i][0], tip, INK, 2.0)
			draw_circle(tip, 3.0, INK)
	for ring in _rings:
		draw_arc(ring[0], 10.0 + 14.0 * ring[1], 0.0, TAU, 24, Color(INK, 0.5 * (1.0 - ring[1])), 1.5)
```

**Expected (with `EASE := false`):** a seed, waiting. Click — one thirteenth
of the root grows over 2.6 seconds, at that same conveyor-belt pace. Now
click again *while it's growing*: a soft ring blooms under your cursor and
fades, and the root does not speed up. Click during the rest and the next
turn begins. When all thirteen turns are spent, the root is whole and
further clicks change nothing — done is done, and done is calm.

That ring is the lesson's second idea in one image: refusal without
punishment. The tap costs nothing, breaks nothing, and is *seen* — it draws
a ring, not an error. The game's whole personality lives in that ring.

### Step 4 — the ease

Set `EASE := true`. Run it. Click.

**Expected:** the same thirteen turns, transformed. Each click now *surges*
— most of the burst arrives in the first second — then settles into
stillness like something exhaling. Toggle `EASE` back and forth once more
and you'll never need convincing again: the linear root is a machine
filling a quota; the eased root is a thing that *grew*. One line of maths —
`1 − (1 − t)³` — is the entire difference.

## You can stop here.

Two eased turns of growth on click — surge, rest, surge, rest — and a
polite ring for your impatience: that's the promise kept, and it's the
signature system of a real game, running from a file you understand
entirely. If your bursts feel too quick or too languid, `TURN_SECONDS` is
yours to tune; that's taste, not homework.

## Go deeper (optional) — the root seeks your touch

Real roots steer. The place where the steering is *sensed* is the tip: in
1880, Charles Darwin and his son Francis glued tiny squares of card to one
side of seedling root tips and watched the roots bend away from the touch;
interfere with the tip itself and the steering stopped, even though the
bending happens further back. Their conclusion has a sentence botanists
still quote — that the root tip "acts like the brain of one of the lower
animals". (*The Power of Movement in Plants*, 1880 — free at
darwin-online.org.uk, and genuinely charming to read.)

So let's give our root something to sense. We'll call the pointer
**moisture** — water being a thing real roots care about — and bend every
growing tip's heading a few degrees toward it. The variation below keeps it
deliberate, in the spirit of the game: your **first** click plants the water
somewhere on screen; the root's whole plan leans toward it; later clicks
grow turns as before.

Three additions. First, two new lines near the top of the file (next to the
other consts and vars):

```gdscript
const PULL := 0.05                   # how thirstily each step leans (0 = not at all)

var _moisture := Vector2.INF         # no water yet
var _word := ""                      # the grown sentence, kept for re-walking
```

Second, split `_ready` so the walk can be redone, and add the lean — replace
`_ready` entirely with these two functions:

```gdscript
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))
	_word = AXIOM
	for i in GENERATIONS:
		var grown := ""
		for c in _word:
			grown += str(RULES.get(c, c))
		_word = grown
	_walk()

func _walk() -> void:
	_segs.clear()
	var turn := deg_to_rad(ANGLE_DEG)
	var pos := START
	var heading := PI / 2
	var bookmarks: Array = []
	for c in _word:
		match c:
			"F":
				if _moisture != Vector2.INF:   # lean a little toward the water
					heading = lerp_angle(heading, (_moisture - pos).angle(), PULL)
				var next := pos + Vector2(cos(heading), sin(heading)) * STEP
				_segs.append([pos, next])
				pos = next
			"+": heading -= turn
			"-": heading += turn
			"[": bookmarks.push_back([pos, heading])
			"]":
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
	_total = STEP * _segs.size()
```

Third, teach the first click its new job — replace `_unhandled_input`
entirely:

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if _moisture == Vector2.INF: # the first touch plants the water
			_moisture = event.position
			_walk()
			queue_redraw()
		elif _t <= 1.0:
			_rings.append([event.position, 0.0])
		elif _to < _total:
			_from = _shown
			_to = minf(_shown + _total / TURNS, _total)
			_t = 0.0
```

If you'd like to *see* the water, add one line inside `_draw`, right after
the seed: `if _moisture != Vector2.INF: draw_circle(_moisture, 5.0, Color(INK, 0.3))`.

**Expected:** click once near a corner — nothing grows yet, but the water is
planted. Then click through the turns and watch the same grammar arrive
*bent*: the whole system drifts toward your touch, and branches that would
have grown away curl around like they've heard something. `PULL := 0.05`
means each step surrenders 5% of the angle between "where I was heading"
and "where the water is"; try `0.02` for a hint and `0.15` for open thirst.

Open-ended prompt (a real weekend project, and the game's actual mechanic):
make the moisture *follow* the pointer live, steering only the not-yet-grown
future. The catch to respect: the already-grown past must never rewrite
itself — so you'll need to remember each segment's bend once it has grown,
and re-lean only what hasn't. Roots don't un-grow. Neither should yours.

## Check yourself

1. For ease-out cubic, how much of the burst has arrived at half time
   (t = 0.5)?
2. In `one_turn.gd`, which single condition decides that a click gets a
   ring instead of a new turn?
3. Linear and eased growth both take 2.6 seconds per turn. Which one
   *arrives* with zero speed — and why does that read as "alive"?

## Sources

- **Secondary (free):** Robert Penner's easing chapter (2002), free at
  [robertpenner.com/easing](http://robertpenner.com/easing) — the origin of
  ease-out cubic and its whole family.
- **Primary (and charming):** C. Darwin & F. Darwin, *The Power of Movement
  in Plants*, 1880 — the root-tip experiments, free at
  [darwin-online.org.uk](https://darwin-online.org.uk).
- **Secondary (free):** P. Prusinkiewicz & A. Lindenmayer, *The Algorithmic
  Beauty of Plants*, 1990 — free PDF at
  [algorithmicbotany.org/papers/#abop](http://algorithmicbotany.org/papers/#abop);
  chapter 1 is where our root's grammar lives.

---

<sub>**Answers:** 1. 1 − (1 − 0.5)³ = 1 − 0.125 = 0.875 — seven-eighths.
That early surge is the "burst". 2. `if _t <= 1.0` — a turn is still
running, so the click is answered with a ring and nothing else. 3. The
eased one: the slope of 1 − (1 − t)³ flattens to zero at t = 1, so it
decelerates into stillness — settling, like a living thing — where linear
motion stops like a switch was thrown.</sub>
