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
		# A fish whose three wishes cancelled exactly would have no direction
		# left, and normalising nothing gives nothing — it would hang still
		# for ever. If that happens, it keeps yesterday's heading.
		if vel.is_zero_approx():
			vel = velocities[i]
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
