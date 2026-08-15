# wire_cube.gd — Six Small Worlds · World 1 (equanim) · Lesson 3.
# A wire cube turning on a 2D screen: eight corners as Vector3, turned by
# two dials (yaw about Y, then pitch about X), flattened by dropping z,
# and drawn as twelve lines. No 3D engine — sin and cos push every corner.
# One thing to try changing: PITCH_DEG_PER_SEC to 0.0 — watch the cube
# lose its top and turn back into a folding square.
extends Node2D

const CORNERS := [
	Vector3(-1, -1, -1), Vector3(1, -1, -1), Vector3(1, 1, -1), Vector3(-1, 1, -1),
	Vector3(-1, -1, 1), Vector3(1, -1, 1), Vector3(1, 1, 1), Vector3(-1, 1, 1),
]
const EDGES := [
	[0, 1], [1, 2], [2, 3], [3, 0],  # back face
	[4, 5], [5, 6], [6, 7], [7, 4],  # front face
	[0, 4], [1, 5], [2, 6], [3, 7],  # four struts between them
]
const SCALE_PX := 140.0         # 1 maths unit = this many pixels
const YAW_DEG_PER_SEC := 24.0   # turn about the vertical axis
const PITCH_DEG_PER_SEC := 9.0  # nod about the horizontal axis
const LINE_WIDTH := 2.0
const INK := Color(0.85, 0.9, 1.0)

var yaw := 0.0    # radians
var pitch := 0.0  # radians

func _process(delta: float) -> void:
	position = get_viewport_rect().size / 2.0  # stay centred, even if resized
	# fmod keeps each angle small for ever — a cube left turning overnight
	# should still be turning smoothly at breakfast.
	yaw = fmod(yaw + deg_to_rad(YAW_DEG_PER_SEC) * delta, TAU)
	pitch = fmod(pitch + deg_to_rad(PITCH_DEG_PER_SEC) * delta, TAU)
	queue_redraw()

func _draw() -> void:
	var flat := PackedVector2Array()
	for corner in CORNERS:
		flat.append(_project(_turn(corner)))
	for edge in EDGES:  # twelve edges, one line each — count them, Euler will ask
		draw_line(flat[edge[0]], flat[edge[1]], INK, LINE_WIDTH, true)

# The lesson-1 dials, twice over: yaw trades x with z, pitch trades y with z.
# cos keeps your own coordinate, sin borrows the other — that is the matrix.
func _turn(p: Vector3) -> Vector3:
	var yawed := Vector3(
		p.x * cos(yaw) + p.z * sin(yaw),
		p.y,
		-p.x * sin(yaw) + p.z * cos(yaw))
	return Vector3(
		yawed.x,
		yawed.y * cos(pitch) - yawed.z * sin(pitch),
		yawed.y * sin(pitch) + yawed.z * cos(pitch))

# Orthographic projection: keep x and y, let z go.
func _project(p: Vector3) -> Vector2:
	return Vector2(p.x, p.y) * SCALE_PX
