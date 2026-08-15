# times_table.gd — Six Small Worlds · World 2 · Lesson 2 (build B): times-table circle
# N points ring a circle; a straight chord joins each point k to (k × M) mod N.
# M = 2 wraps the two-times table into a cardioid — a heart made of straight lines.
# Arrow keys: left/right change M, up/down change N. Hold right and watch it travel.
# One thing to try changing: START_TABLE → 3 for a nephroid, or 51 for lace.

extends Node2D

const START_POINTS := 200      # N — how many points around the rim
const START_TABLE := 2         # M — which times table we draw
const POINTS_STEP := 10        # how far up/down move N
const RADIUS_FRACTION := 0.45  # circle size as a share of the window
const LINE_WIDTH := 1.0
const CHORD_COLOR := Color(0.95, 0.6, 0.5, 0.7)
const RIM_COLOR := Color(0.5, 0.5, 0.58)
const LABEL_COLOR := Color(0.8, 0.8, 0.85)

var n := START_POINTS
var m := START_TABLE


func _ready() -> void:
	# Drawn once per change, not every frame — so a resized window asks for
	# one fresh drawing at the new size.
	get_viewport().size_changed.connect(queue_redraw)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_RIGHT: m += 1
			KEY_LEFT: m = maxi(m - 1, 1)
			KEY_UP: n += POINTS_STEP
			KEY_DOWN: n = maxi(n - POINTS_STEP, 10)
		queue_redraw()


func _point(index: int, centre: Vector2, radius: float) -> Vector2:
	# TAU is radians for "one full turn"; the -PI/2 starts point 0 at 12 o'clock.
	var angle := TAU * float(index % n) / float(n) - PI * 0.5
	return centre + Vector2(cos(angle), sin(angle)) * radius


func _draw() -> void:
	var view := get_viewport_rect().size
	var centre := view * 0.5
	var radius := minf(view.x, view.y) * RADIUS_FRACTION
	draw_arc(centre, radius, 0.0, TAU, 128, RIM_COLOR, 1.0, true)
	for k in n:
		draw_line(_point(k, centre, radius), _point(k * m, centre, radius),
				CHORD_COLOR, LINE_WIDTH, true)
	draw_string(ThemeDB.fallback_font, Vector2(16.0, 28.0),
			"N = %d   M = %d   (arrow keys)" % [n, m],
			HORIZONTAL_ALIGNMENT_LEFT, -1, 14, LABEL_COLOR)
