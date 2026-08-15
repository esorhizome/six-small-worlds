# phyllotaxis.gd — Six Small Worlds · World 2 · Lesson 1: The Sunflower Rule
# Draws a colony that accretes one cell per tick using Vogel's 1979 model:
#   cell n sits at angle n × 137.508° (the golden angle), radius SPACING × √n.
# Hold the left mouse button or SPACE to pour cells in faster.
# One thing to try changing: GOLDEN_ANGLE_DEG → 137.3, and watch the arms appear.

extends Node2D

const GOLDEN_ANGLE_DEG := 137.507764  # 360° ÷ φ ÷ φ — the golden angle
const SPACING := 7.0                  # the c in r = c·√n; sets colony density
const CELL_RADIUS := 4.0              # size of one drawn cell, in pixels
const TICKS_PER_SECOND := 12.0        # unhurried growth speed
const POUR_MULTIPLIER := 10.0         # growth speed while pouring
const MAX_CELLS := 2000               # where the colony rests

const YOUNG_COLOR := Color(1.0, 0.95, 0.7)  # newest cells, at the rim
const OLD_COLOR := Color(0.55, 0.85, 0.6)   # oldest cells, at the heart

var cells := 0.0  # grows smoothly; we draw the whole-number part
var golden_angle := deg_to_rad(GOLDEN_ANGLE_DEG)  # degrees in, radians out


func _ready() -> void:
	# Once the colony is full it stops asking to be redrawn, so a window
	# resized after that would leave it off-centre. One more drawing, then.
	get_viewport().size_changed.connect(queue_redraw)


func _process(delta: float) -> void:
	var speed := TICKS_PER_SECOND
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) or Input.is_key_pressed(KEY_SPACE):
		speed *= POUR_MULTIPLIER
	if cells < float(MAX_CELLS):
		cells = minf(cells + speed * delta, float(MAX_CELLS))
		queue_redraw()


func _draw() -> void:
	var centre := get_viewport_rect().size * 0.5
	var count := int(cells)
	for n in count:
		var angle := golden_angle * float(n)
		var radius := SPACING * sqrt(float(n))
		var pos := centre + Vector2(cos(angle), sin(angle)) * radius
		var age := float(n) / maxf(float(count), 1.0)  # 0 = oldest, 1 = newest
		draw_circle(pos, CELL_RADIUS, OLD_COLOR.lerp(YOUNG_COLOR, age))
