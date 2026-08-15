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

func _ready() -> void:
	# These spirals are drawn once, not every frame — so when the window
	# changes shape we ask for one fresh drawing at the new size.
	get_viewport().size_changed.connect(queue_redraw)

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
