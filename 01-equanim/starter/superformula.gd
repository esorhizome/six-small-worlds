# superformula.gd — Six Small Worlds · World 1 (equanim) · Lesson 2.
# Draws one supershape (the superformula, Gielis 2003): a circle whose
# radius has a personality. Idles in a slow turn; drag left-right to turn
# it yourself; every dial is an Inspector slider.
# One thing to try changing: symmetry_m — 4 is the square family, 5 a
# starfish, 8 a daisy. Try 19 and see what you would name it.
extends Node2D

@export_range(0.0, 24.0, 0.5) var symmetry_m := 5.0    # repeats per lap
@export_range(0.1, 20.0, 0.1) var sharpness_n1 := 2.0  # overall pinch
@export_range(0.1, 20.0, 0.1) var sharpness_n2 := 7.0  # cos-side sharpness
@export_range(0.1, 20.0, 0.1) var sharpness_n3 := 7.0  # sin-side sharpness
@export_range(0.1, 4.0, 0.1) var stretch_a := 1.0      # across stretch
@export_range(0.1, 4.0, 0.1) var stretch_b := 1.0      # up-down stretch

const SIZE := 130.0            # pixels per 1 unit of radius
const MAX_RADIUS := 8.0        # a leash: see the note on _superformula below
const SEGMENTS := 720          # dots along the outline
const LAPS := 2.0              # walk the lap twice: odd m then closes too
const TURN_DEG_PER_SEC := 9.0  # idle turning speed
const DRAG_DEG_PER_PIXEL := 0.4  # how far one pixel of drag turns the card
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

var turn := 0.0  # the card's current turn, radians
var dragging := false

func _process(delta: float) -> void:
	position = get_viewport_rect().size / 2.0  # stay centred, even if resized
	if not dragging:
		# fmod keeps the angle small for ever — a card left turning overnight
		# should still be turning smoothly at breakfast.
		turn = fmod(turn + deg_to_rad(TURN_DEG_PER_SEC) * delta, TAU)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed
	elif event is InputEventMouseMotion and dragging:
		turn += deg_to_rad(DRAG_DEG_PER_PIXEL) * event.relative.x

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var theta := TAU * LAPS * float(i) / float(SEGMENTS)
		var r := _superformula(theta) * SIZE
		points.append(Vector2(r * cos(theta + turn), r * sin(theta + turn)))
	draw_polyline(points, INK, LINE_WIDTH, true)

# r(θ) = (|cos(m·θ/4)/a|^n2 + |sin(m·θ/4)/b|^n3)^(−1/n1)   — Gielis, 2003
#
# The −1/n1 exponent means small totals make big radii. With a low n1 the
# formula can ask for a radius of thousands, and the shape leaves the window
# by the top. That is the formula being honest, not you being wrong — so we
# put it on a leash at MAX_RADIUS and let the shape press against it.
func _superformula(theta: float) -> float:
	var part_cos := pow(abs(cos(symmetry_m * theta / 4.0) / stretch_a), sharpness_n2)
	var part_sin := pow(abs(sin(symmetry_m * theta / 4.0) / stretch_b), sharpness_n3)
	var total := part_cos + part_sin
	if is_zero_approx(total):
		return MAX_RADIUS
	return minf(pow(total, -1.0 / sharpness_n1), MAX_RADIUS)
