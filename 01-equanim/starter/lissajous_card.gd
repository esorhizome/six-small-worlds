# lissajous_card.gd — Six Small Worlds · World 1 (equanim) · Lesson 1.
# Draws a Lissajous figure: x follows a cos dial at one speed, y follows a
# sin dial at another. A slow phase drift makes the flat curve appear to
# tumble in 3D. A bead rides the path to show the two dials at work.
# One thing to try changing: DIAL_A to 5.0 and DIAL_B to 4.0 — then watch.
extends Node2D

const DIAL_A := 3.0            # across-dial speed (a in x = cos(a·t))
const DIAL_B := 2.0            # up-down-dial speed (b in y = sin(b·t))
const SIZE := 220.0            # each dial's reach, in pixels
const SEGMENTS := 512          # dots along the curve; more = smoother
const DRIFT_DEG_PER_SEC := 12.0  # phase drift — this is what makes it turn
const BEAD_SECONDS := 6.0      # seconds for the bead's full lap
const BEAD_RADIUS := 6.0
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)
const BEAD := Color(1.0, 0.8, 0.4)

var phase := 0.0   # radians; the cos dial's slowly creeping head start
var bead_t := 0.0  # where the bead is along its lap, in radians

func _process(delta: float) -> void:
	position = get_viewport_rect().size / 2.0  # stay centred, even if resized
	# fmod keeps the angle small for ever — a card left turning overnight
	# should still be turning smoothly at breakfast.
	phase = fmod(phase + deg_to_rad(DRIFT_DEG_PER_SEC) * delta, TAU)
	bead_t = fmod(bead_t + TAU / BEAD_SECONDS * delta, TAU)
	queue_redraw()

func _draw() -> void:
	var points := PackedVector2Array()
	for i in range(SEGMENTS + 1):
		var t := TAU * float(i) / float(SEGMENTS)
		points.append(_curve_point(t))
	draw_polyline(points, INK, LINE_WIDTH, true)
	draw_circle(_curve_point(bead_t), BEAD_RADIUS, BEAD)

# The whole lesson in one function: two dials, one point.
func _curve_point(t: float) -> Vector2:
	var x := cos(DIAL_A * t + phase) * SIZE
	var y := sin(DIAL_B * t) * SIZE
	return Vector2(x, y)
