# Lesson 3 · A School That Thinks Together

*World 5 · Friendly Waters — lesson 3 of 3*

**Promise:** by the end of this lesson you'll have a school of fish with no
leader — sixty of them turning as one, following three rules and nobody.

## If this is your first time

You can begin the course here, though lesson 2's "arrows pinned to space" is a
gentle warm-up for this one. Setup in one breath: install
[Godot 4.3+](https://godotengine.org), new project, **Node2D** scene root,
attach a script, paste each block below over the whole file, press **F5**.
Reading along without a keyboard still counts as taking the lesson.

## See it first

Watch footage of a fish school or a starling murmuration and your brain
insists someone is in charge — a choreographer, a lead bird, a plan. There
isn't one. No fish can even *see* the whole school. Each one watches only its
few nearest neighbours and keeps three small promises about them. The
swirling, breathing, single-creature-of-many thing you see is nobody's
intention. It's what the three promises add up to.

Here they are, in playground language:

1. **Don't crowd me.** If someone's too close, ease away. *(Separation.)*
2. **Swim the way we're swimming.** Match your neighbours' general heading.
   *(Alignment.)*
3. **Don't leave me.** Drift toward the middle of your nearby group.
   *(Cohesion.)*

Notice the shape of this: no rule mentions the school. Each rule is local,
polite, and a little contradictory — stay close but not too close, be
yourself but agree. The school is the negotiation, sixty times a frame.

In 1987, Craig Reynolds put exactly this on a SIGGRAPH screen and called the
creatures *boids*. His paper named the rules collision avoidance, velocity
matching, and flock centering; the nicknames the field settled on —
separation, alignment, cohesion — are the ones we'll use.

## The maths, small

> **A recipe, not a formula** — boids has no single equation, and that's
> honest; Reynolds published a *procedure*. Three new symbols cover it.
>
> | symbol | say it as |
> |---|---|
> | *r* | the neighbour radius — how far away a fish still counts as company |
> | *v* | a fish's velocity — its heading and speed in one arrow |
> | *w* | a weight — one volume knob per rule (wₛ, wₐ, w꜀) |
>
> **wish = wₛ · (away from crowding) + wₐ · (along neighbours' heading) + w꜀ · (toward neighbours' middle)**
>
> In plain English: *each of the three rules proposes a direction (an arrow of
> length 1); each proposal is turned up or down by its weight; the fish adds
> them into one "wish" and bends its velocity a little toward it every frame.*
> All three proposals only ever look at neighbours within *r* — the rules are
> local or they are nothing.

That "bends a little" matters: the fish never teleports onto its wish, it
*steers* — which is why schools look muscled and alive instead of snapping to
attention like iron filings.

## Build it

### Step 1 — sixty fish, no rules yet

One idea: the cast before the play. Sixty positions, sixty random velocities,
little triangles that point where they're going. Paste over your whole script
and run.

```gdscript
extends Node2D

const FISH_COUNT := 60
const MAX_SPEED := 130.0         # pixels per second
const MIN_SPEED := 60.0          # fish never stall
const FISH_NOSE := 8.0           # triangle geometry, pixels
const FISH_TAIL := 6.0
const FISH_HALF_WIDTH := 4.0
const WATER_COLOUR := Color(0.02, 0.07, 0.13)
const FISH_COLOUR := Color(0.78, 0.88, 0.98, 0.95)

var positions: Array[Vector2] = []
var velocities: Array[Vector2] = []

func _ready() -> void:
	var view := get_viewport_rect().size
	for i in FISH_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		# TAU is one full turn — 360°, wearing its radian coat.
		velocities.append(Vector2.from_angle(randf() * TAU) * randf_range(MIN_SPEED, MAX_SPEED))

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	for i in FISH_COUNT:
		positions[i] += velocities[i] * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func draw_fish(pos: Vector2, vel: Vector2) -> void:
	var dir := vel.normalized()
	var side := dir.orthogonal()
	draw_colored_polygon(PackedVector2Array([
		pos + dir * FISH_NOSE,
		pos - dir * FISH_TAIL + side * FISH_HALF_WIDTH,
		pos - dir * FISH_TAIL - side * FISH_HALF_WIDTH,
	]), FISH_COLOUR)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), WATER_COLOUR)
	for i in FISH_COUNT:
		draw_fish(positions[i], velocities[i])
```

**Run it.** Confetti that swims: sixty strangers crossing a plaza, no two with
the same errand, wrapping doughnut-style at the screen edges (`fposmod` again,
if you took lesson 2). One vocabulary note: `randf() * TAU` picks a heading
anywhere in a full turn — TAU being 360° in the radian units code prefers.
This aimlessness is our "before" photo. Keep its memory; the transformation is
three steps long.

### Step 2 — rule one: personal space

One idea: **separation**. Each fish looks for anyone inside its personal-space
bubble and collects a push directly away from each intruder; then it bends its
velocity a little toward the summed push. Two matters of engine-room honesty
come with it, each worth one sentence: every fish decides from the *same
moment* (new velocities go into a fresh list, so nobody reacts to a
neighbour's future), and speeds get clamped to a sea-worthy range so no fish
stalls or rockets.

```gdscript
extends Node2D

const FISH_COUNT := 60
const SEPARATION_RADIUS := 26.0  # personal space, pixels
const MAX_SPEED := 130.0         # pixels per second
const MIN_SPEED := 60.0          # fish never stall
const STEER := 3.0               # how sharply a fish can bend toward its wish
const FISH_NOSE := 8.0           # triangle geometry, pixels
const FISH_TAIL := 6.0
const FISH_HALF_WIDTH := 4.0
const WATER_COLOUR := Color(0.02, 0.07, 0.13)
const FISH_COLOUR := Color(0.78, 0.88, 0.98, 0.95)

var positions: Array[Vector2] = []
var velocities: Array[Vector2] = []

func _ready() -> void:
	var view := get_viewport_rect().size
	for i in FISH_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		# TAU is one full turn — 360°, wearing its radian coat.
		velocities.append(Vector2.from_angle(randf() * TAU) * randf_range(MIN_SPEED, MAX_SPEED))

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	# Everyone decides from the same moment: tomorrow's velocities go into
	# a fresh list, so no fish reacts to a neighbour's future.
	var new_velocities: Array[Vector2] = []
	for i in FISH_COUNT:
		var away := Vector2.ZERO  # separation: pushes out of my space
		for j in FISH_COUNT:
			if i == j:
				continue
			var offset := positions[j] - positions[i]
			var dist := offset.length()
			if dist < SEPARATION_RADIUS and dist > 0.0:
				away -= offset / dist  # a unit push, straight away from j
		var vel := velocities[i]
		if away != Vector2.ZERO:
			vel = vel.lerp(away.normalized() * MAX_SPEED, minf(STEER * delta, 1.0))
		var speed := clampf(vel.length(), MIN_SPEED, MAX_SPEED)
		vel = vel.normalized() * speed
		new_velocities.append(vel)
	velocities = new_velocities
	for i in FISH_COUNT:
		positions[i] += velocities[i] * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func draw_fish(pos: Vector2, vel: Vector2) -> void:
	var dir := vel.normalized()
	var side := dir.orthogonal()
	draw_colored_polygon(PackedVector2Array([
		pos + dir * FISH_NOSE,
		pos - dir * FISH_TAIL + side * FISH_HALF_WIDTH,
		pos - dir * FISH_TAIL - side * FISH_HALF_WIDTH,
	]), FISH_COLOUR)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), WATER_COLOUR)
	for i in FISH_COUNT:
		draw_fish(positions[i], velocities[i])
```

**Run it.** Subtle, this one: mostly the same plaza, but near-collisions now
resolve with a small polite swerve. (Yes, the inner loop checks every fish
against every fish — 3,600 checks a frame. At sixty fish that's nothing; big
games sort neighbours into buckets first. We'll stay honest and direct.) If
your fish twitch violently, you likely typed `+=` for `-=` on the push —
they're *attracting* intruders, which is a different game.

### Step 3 — rule two: swim the way we're swimming

One idea: **alignment**, and with a second rule comes the *mixing desk*. Each
fish now also notices everyone within earshot — `NEIGHBOUR_RADIUS`, wider
than personal space — and averages their velocities into "the way we're
swimming". Two proposals (away from crowding, along the group's heading) get
blended, each with a weight, into one wish.

```gdscript
extends Node2D

const FISH_COUNT := 60
const NEIGHBOUR_RADIUS := 70.0   # how far a fish notices flockmates, pixels
const SEPARATION_RADIUS := 26.0  # personal space, pixels
const WEIGHT_SEPARATION := 1.6   # the mixing desk: each rule's volume
const WEIGHT_ALIGNMENT := 1.0
const MAX_SPEED := 130.0         # pixels per second
const MIN_SPEED := 60.0          # fish never stall
const STEER := 3.0               # how sharply a fish can bend toward its wish
const FISH_NOSE := 8.0           # triangle geometry, pixels
const FISH_TAIL := 6.0
const FISH_HALF_WIDTH := 4.0
const WATER_COLOUR := Color(0.02, 0.07, 0.13)
const FISH_COLOUR := Color(0.78, 0.88, 0.98, 0.95)

var positions: Array[Vector2] = []
var velocities: Array[Vector2] = []

func _ready() -> void:
	var view := get_viewport_rect().size
	for i in FISH_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		# TAU is one full turn — 360°, wearing its radian coat.
		velocities.append(Vector2.from_angle(randf() * TAU) * randf_range(MIN_SPEED, MAX_SPEED))

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	# Everyone decides from the same moment: tomorrow's velocities go into
	# a fresh list, so no fish reacts to a neighbour's future.
	var new_velocities: Array[Vector2] = []
	for i in FISH_COUNT:
		var away := Vector2.ZERO     # separation: pushes out of my space
		var heading := Vector2.ZERO  # alignment: my neighbours' velocities
		var flockmates := 0
		for j in FISH_COUNT:
			if i == j:
				continue
			var offset := positions[j] - positions[i]
			var dist := offset.length()
			if dist < NEIGHBOUR_RADIUS:
				flockmates += 1
				heading += velocities[j]
				if dist < SEPARATION_RADIUS and dist > 0.0:
					away -= offset / dist  # a unit push, straight away from j
		var vel := velocities[i]
		if flockmates > 0:
			var wish := away.normalized() * WEIGHT_SEPARATION
			wish += (heading / flockmates).normalized() * WEIGHT_ALIGNMENT
			if wish != Vector2.ZERO:
				vel = vel.lerp(wish.normalized() * MAX_SPEED, minf(STEER * delta, 1.0))
		var speed := clampf(vel.length(), MIN_SPEED, MAX_SPEED)
		vel = vel.normalized() * speed
		new_velocities.append(vel)
	velocities = new_velocities
	for i in FISH_COUNT:
		positions[i] += velocities[i] * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func draw_fish(pos: Vector2, vel: Vector2) -> void:
	var dir := vel.normalized()
	var side := dir.orthogonal()
	draw_colored_polygon(PackedVector2Array([
		pos + dir * FISH_NOSE,
		pos - dir * FISH_TAIL + side * FISH_HALF_WIDTH,
		pos - dir * FISH_TAIL - side * FISH_HALF_WIDTH,
	]), FISH_COLOUR)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), WATER_COLOUR)
	for i in FISH_COUNT:
		draw_fish(positions[i], velocities[i])
```

**Run it.** Traffic appears: lanes and rivers of fish agreeing about
direction, streaming past each other. It's genuinely pretty and genuinely not
a school yet — they agree on *where to go* but feel no pull to *be together*.
If yours already looks halfway organised, you're 90% of the way there —
organised is what rule three turns into *belonging*.

### Step 4 — rule three: don't leave me

One idea: **cohesion**. Alongside the other tallies, each fish averages its
neighbours' *positions* — the middle of its local group — and gains a third
proposal: drift that way. Three weights now sit on the desk.

```gdscript
extends Node2D

const FISH_COUNT := 60
const NEIGHBOUR_RADIUS := 70.0   # how far a fish notices flockmates, pixels
const SEPARATION_RADIUS := 26.0  # personal space, pixels
const WEIGHT_SEPARATION := 1.6   # the mixing desk: each rule's volume
const WEIGHT_ALIGNMENT := 1.0
const WEIGHT_COHESION := 0.9
const MAX_SPEED := 130.0         # pixels per second
const MIN_SPEED := 60.0          # fish never stall
const STEER := 3.0               # how sharply a fish can bend toward its wish
const FISH_NOSE := 8.0           # triangle geometry, pixels
const FISH_TAIL := 6.0
const FISH_HALF_WIDTH := 4.0
const WATER_COLOUR := Color(0.02, 0.07, 0.13)
const FISH_COLOUR := Color(0.78, 0.88, 0.98, 0.95)

var positions: Array[Vector2] = []
var velocities: Array[Vector2] = []

func _ready() -> void:
	var view := get_viewport_rect().size
	for i in FISH_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		# TAU is one full turn — 360°, wearing its radian coat.
		velocities.append(Vector2.from_angle(randf() * TAU) * randf_range(MIN_SPEED, MAX_SPEED))

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	# Everyone decides from the same moment: tomorrow's velocities go into
	# a fresh list, so no fish reacts to a neighbour's future.
	var new_velocities: Array[Vector2] = []
	for i in FISH_COUNT:
		var away := Vector2.ZERO     # separation: pushes out of my space
		var heading := Vector2.ZERO  # alignment: my neighbours' velocities
		var centre := Vector2.ZERO   # cohesion: my neighbours' positions
		var flockmates := 0
		for j in FISH_COUNT:
			if i == j:
				continue
			var offset := positions[j] - positions[i]
			var dist := offset.length()
			if dist < NEIGHBOUR_RADIUS:
				flockmates += 1
				heading += velocities[j]
				centre += positions[j]
				if dist < SEPARATION_RADIUS and dist > 0.0:
					away -= offset / dist  # a unit push, straight away from j
		var vel := velocities[i]
		if flockmates > 0:
			var wish := away.normalized() * WEIGHT_SEPARATION
			wish += (heading / flockmates).normalized() * WEIGHT_ALIGNMENT
			wish += (centre / flockmates - positions[i]).normalized() * WEIGHT_COHESION
			if wish != Vector2.ZERO:
				vel = vel.lerp(wish.normalized() * MAX_SPEED, minf(STEER * delta, 1.0))
		var speed := clampf(vel.length(), MIN_SPEED, MAX_SPEED)
		vel = vel.normalized() * speed
		new_velocities.append(vel)
	velocities = new_velocities
	for i in FISH_COUNT:
		positions[i] += velocities[i] * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func draw_fish(pos: Vector2, vel: Vector2) -> void:
	var dir := vel.normalized()
	var side := dir.orthogonal()
	draw_colored_polygon(PackedVector2Array([
		pos + dir * FISH_NOSE,
		pos - dir * FISH_TAIL + side * FISH_HALF_WIDTH,
		pos - dir * FISH_TAIL - side * FISH_HALF_WIDTH,
	]), FISH_COLOUR)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), WATER_COLOUR)
	for i in FISH_COUNT:
		draw_fish(positions[i], velocities[i])
```

**Run it.** There it is. Groups condense out of the traffic, swell as they
recruit passers-by, split around nothing and re-merge — a school, schooling.
Nobody leads it. You wrote no code for "the school" — check if you like;
there's no such variable. Sit with that for a second: you built a *them* out
of sixty *me*s.

### Step 5 — play the mixing desk

One idea: the weights are not implementation details — they're the *design*.
Reynolds gave the rules; every school since has been somebody's taste in
weights. Your step-4 file is already the finished instrument; here it is one
last time, wearing the comment header it keeps in this folder. This exact
text also lives at [`starter/boids.gd`](starter/boids.gd).

```gdscript
# boids.gd — World 5 · Friendly Waters · Lesson 3 (A School That Thinks Together)
# Draws 60 fish schooling with no leader. Each fish follows three rules
# about its neighbours — separation, alignment, cohesion (Reynolds 1987) —
# and nothing else. The school is what the rules add up to.
# Try changing: the three WEIGHT_ constants. Set one to 0.0 and watch
# what the school forgets how to do.
extends Node2D

const FISH_COUNT := 60
const NEIGHBOUR_RADIUS := 70.0   # how far a fish notices flockmates, pixels
const SEPARATION_RADIUS := 26.0  # personal space, pixels
const WEIGHT_SEPARATION := 1.6   # the mixing desk: each rule's volume
const WEIGHT_ALIGNMENT := 1.0
const WEIGHT_COHESION := 0.9
const MAX_SPEED := 130.0         # pixels per second
const MIN_SPEED := 60.0          # fish never stall
const STEER := 3.0               # how sharply a fish can bend toward its wish
const FISH_NOSE := 8.0           # triangle geometry, pixels
const FISH_TAIL := 6.0
const FISH_HALF_WIDTH := 4.0
const WATER_COLOUR := Color(0.02, 0.07, 0.13)
const FISH_COLOUR := Color(0.78, 0.88, 0.98, 0.95)

var positions: Array[Vector2] = []
var velocities: Array[Vector2] = []

func _ready() -> void:
	var view := get_viewport_rect().size
	for i in FISH_COUNT:
		positions.append(Vector2(randf() * view.x, randf() * view.y))
		# TAU is one full turn — 360°, wearing its radian coat.
		velocities.append(Vector2.from_angle(randf() * TAU) * randf_range(MIN_SPEED, MAX_SPEED))

func _process(delta: float) -> void:
	var view := get_viewport_rect().size
	# Everyone decides from the same moment: tomorrow's velocities go into
	# a fresh list, so no fish reacts to a neighbour's future.
	var new_velocities: Array[Vector2] = []
	for i in FISH_COUNT:
		var away := Vector2.ZERO     # separation: pushes out of my space
		var heading := Vector2.ZERO  # alignment: my neighbours' velocities
		var centre := Vector2.ZERO   # cohesion: my neighbours' positions
		var flockmates := 0
		for j in FISH_COUNT:
			if i == j:
				continue
			var offset := positions[j] - positions[i]
			var dist := offset.length()
			if dist < NEIGHBOUR_RADIUS:
				flockmates += 1
				heading += velocities[j]
				centre += positions[j]
				if dist < SEPARATION_RADIUS and dist > 0.0:
					away -= offset / dist  # a unit push, straight away from j
		var vel := velocities[i]
		if flockmates > 0:
			var wish := away.normalized() * WEIGHT_SEPARATION
			wish += (heading / flockmates).normalized() * WEIGHT_ALIGNMENT
			wish += (centre / flockmates - positions[i]).normalized() * WEIGHT_COHESION
			if wish != Vector2.ZERO:
				vel = vel.lerp(wish.normalized() * MAX_SPEED, minf(STEER * delta, 1.0))
		var speed := clampf(vel.length(), MIN_SPEED, MAX_SPEED)
		vel = vel.normalized() * speed
		new_velocities.append(vel)
	velocities = new_velocities
	for i in FISH_COUNT:
		positions[i] += velocities[i] * delta
		positions[i] = Vector2(fposmod(positions[i].x, view.x), fposmod(positions[i].y, view.y))
	queue_redraw()

func draw_fish(pos: Vector2, vel: Vector2) -> void:
	var dir := vel.normalized()
	var side := dir.orthogonal()
	draw_colored_polygon(PackedVector2Array([
		pos + dir * FISH_NOSE,
		pos - dir * FISH_TAIL + side * FISH_HALF_WIDTH,
		pos - dir * FISH_TAIL - side * FISH_HALF_WIDTH,
	]), FISH_COLOUR)

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), WATER_COLOUR)
	for i in FISH_COUNT:
		draw_fish(positions[i], velocities[i])
```

Now play it, one experiment at a time, running between each:

- `WEIGHT_COHESION := 0.0` — the school dissolves into aligned traffic:
  motion without belonging.
- `WEIGHT_ALIGNMENT := 0.0` (cohesion back on) — clumps that mill and boil in
  place: belonging without direction.
- `WEIGHT_SEPARATION := 0.0` — the school packs itself into an uncomfortable
  crystal: belonging without respect.
- `NEIGHBOUR_RADIUS := 200.0` — with everyone counting as company, you tend
  to get one giant consensus blob; at `40.0`, many small shy parties.

**Run each.** Zeroing one knob at a time and naming what the school *forgets*
is the entire craft of this system. There is no correct setting. There is only
the school you meant.

## You can stop here.

A school that thinks together, with no thinker: promise kept, and with it this
world's quiet thesis. Notice what the school is *for* in *Friendly Waters*:
nothing attacks anyone. The game has no combat and no health bar anywhere in
its ocean — its "enemies" are misunderstandings, and company itself is the
mechanic. Three local kindnesses, weighted to taste, are enough to make sixty
strangers into a *them*. Everything below is bonus — including the shyest
member of the cast.

## Go deeper (optional)

- **The trust shimmer — Baro's mechanic, named.** In *Friendly Waters*, Baro
  is a hadal snailfish, and strangers can't see him clearly: he's drawn
  through a shimmer of noise that resolves as trust grows. (His real-world
  cousins are gelatinous, translucent, soft-bodied — the deepest-living
  fishes known; one, *Pseudoliparis swirei*, was described from the Mariana
  Trench at depths approaching 8,000 m — Gerringer et al., 2017. The game
  turns "hard to see clearly" into the whole character.) Lesson 2's noise plus
  this lesson's school is everything the effect needs: draw one fish as
  several noise-scattered guesses, and let the scatter's amplitude be
  **(1 − trust)**.

  Add these near your other constants and variables:

  ```gdscript
  const SHIMMER_PIXELS := 14.0  # how far a stranger's outline wanders
  const GHOSTS := 5             # how many guesses a stranger's eye makes
  const BARO_COLOUR := Color(1.0, 0.8, 0.75, 0.4)

  var shimmer := FastNoiseLite.new()  # default settings are fine here
  var trust := 0.0                    # 0 = stranger, 1 = friend
  var time := 0.0
  ```

  At the top of `_process`, let time pass and let the arrow keys stand in for
  earned trust (→ raises it, ← lowers it):

  ```gdscript
  	time += delta
  	trust = clampf(trust + Input.get_axis("ui_left", "ui_right") * 0.4 * delta, 0.0, 1.0)
  ```

  Give `draw_fish` an optional colour, and make fish zero shy:

  ```gdscript
  func draw_fish(pos: Vector2, vel: Vector2, colour: Color = FISH_COLOUR) -> void:
  	var dir := vel.normalized()
  	var side := dir.orthogonal()
  	draw_colored_polygon(PackedVector2Array([
  		pos + dir * FISH_NOSE,
  		pos - dir * FISH_TAIL + side * FISH_HALF_WIDTH,
  		pos - dir * FISH_TAIL - side * FISH_HALF_WIDTH,
  	]), colour)

  func _draw() -> void:
  	draw_rect(Rect2(Vector2.ZERO, get_viewport_rect().size), WATER_COLOUR)
  	for i in range(1, FISH_COUNT):
  		draw_fish(positions[i], velocities[i])
  	# Baro is fish zero. Strangers see several possible Baros;
  	# the scatter is (1 - trust) loud.
  	var amplitude := SHIMMER_PIXELS * (1.0 - trust)
  	for g in GHOSTS:
  		var wobble := Vector2(
  				shimmer.get_noise_2d(time * 90.0, g * 37.0),
  				shimmer.get_noise_2d(time * 90.0, g * 37.0 + 500.0)) * amplitude
  		draw_fish(positions[0] + wobble, velocities[0], BARO_COLOUR)
  ```

  Run it and hold →. The five guesses converge as trust climbs, and at
  **trust = 1** the noise falls silent: the guesses agree, and there he is —
  one clear, gentle, tadpole-shaped fellow who was there the whole time.
  Nothing transformed. You only stopped being a stranger.
- **Performance, honestly.** Our neighbour search is every-against-every.
  Past a few hundred fish, real projects bin positions into a coarse grid and
  check only nearby bins — same rules, faster bookkeeping.
- **Open prompt:** in the snippet, trust is a held arrow key. In a game it
  has to be *earned*. Design three concrete acts that should move that
  number — and decide: should trust ever fall on its own, or only when
  something breaks it?

## Check yourself

1. Name the three rules, and what each one watches about the neighbours.
2. Predict before you try it: what does the school look like with
   `WEIGHT_COHESION := 0.0`?
3. Why do new velocities go into a fresh list instead of being written
   straight back while the loop runs?

<details>
<summary>Answers (the repo's version of printing them upside-down)</summary>

1. Separation watches neighbours' positions that are *too close* (and pushes
   away); alignment watches neighbours' velocities (and matches them);
   cohesion watches neighbours' average position (and drifts toward it).
2. Aligned traffic with no pull to gather: streams and lanes that never
   condense into groups — motion without belonging.
3. So every fish decides from the same moment. Written in place, fish 59
   would react to fish 0's *already updated* velocity — a subtle unfairness
   that makes the simulation order-dependent.

</details>

## Sources

- **Primary (free):** C. Reynolds, "Flocks, Herds, and Schools: A Distributed
  Behavioral Model", *Computer Graphics* (SIGGRAPH), 21(4):25–34, 1987. The
  boids paper: three local rules, no leader. Reynolds keeps a free companion
  page at [red3d.com/cwr/boids](https://www.red3d.com/cwr/boids/).
- **Primary:** M. E. Gerringer et al., description of *Pseudoliparis swirei*,
  the Mariana hadal snailfish, *Zootaxa*, 2017. Baro's real-world cousin —
  among the deepest-living fishes known.
- **Secondary (free):** Daniel Shiffman, *The Nature of Code*,
  [natureofcode.com](https://natureofcode.com) — the autonomous-agents
  chapter walks flocking at book pace, with running examples, for free.

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
