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
