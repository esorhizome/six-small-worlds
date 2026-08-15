# lsystem.gd — World 4 / An Isolate Grows Roots, lesson 2: The Grammar of Plants.
# Draws the classic bracketed plant: axiom X is rewritten GENERATIONS times by
# RULES (every symbol at once), then lesson 1's turtle walks the grown sentence.
# Try changing: GENERATIONS (each +1 is roughly x4 symbols) or ANGLE_DEG.
extends Node2D

const AXIOM := "X"
const RULES := { "X": "F+[[X]-X]-F[-FX]+X", "F": "FF" }
const ANGLE_DEG := 25.0               # the plant's signature angle
const GENERATIONS := 4                # 1,551 symbols by generation 4
const STEP := 7.0                     # pixels per F
const START := Vector2(576, 620)      # bottom centre — plants grow up
const INK := Color(0.93, 0.95, 0.90)

var word := ""   # the grown sentence; built once, walked every redraw

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))
	word = _grow()   # grow once here, not on every frame the screen redraws
	print("lsystem: generation %d is %d symbols long." % [GENERATIONS, word.length()])

func _grow() -> String:
	var grown_word := AXIOM
	for i in GENERATIONS:
		var grown := ""
		for c in grown_word:
			var rule: String = RULES.get(c, c)  # no rule? the symbol survives
			grown += rule
		grown_word = grown
	return grown_word

func _draw() -> void:
	var turn := deg_to_rad(ANGLE_DEG) # degrees for humans, radians for Godot
	var pos := START
	var heading := -PI / 2            # facing up; the screen's y-axis points down
	var bookmarks: Array = []         # the pen's pile of bookmarks
	var stroke := PackedVector2Array([pos])
	for c in word:
		match c:
			"F":
				pos += Vector2(cos(heading), sin(heading)) * STEP
				stroke.append(pos)
			"+":
				heading -= turn       # left is minus because y points down
			"-":
				heading += turn
			"[":
				bookmarks.push_back([pos, heading])
			"]":
				if bookmarks.is_empty():
					# Your rules grew a ']' with no matching '[' — legal in a
					# grammar, impossible for a pen. We carry on drawing.
					print("lsystem: a ']' had no '[' to return to — carrying on.")
					continue
				if stroke.size() >= 2:
					draw_polyline(stroke, INK, 2.0)
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
				stroke = PackedVector2Array([pos])
	if stroke.size() >= 2:
		draw_polyline(stroke, INK, 2.0)
