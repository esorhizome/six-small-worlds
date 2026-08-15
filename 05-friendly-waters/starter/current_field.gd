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
