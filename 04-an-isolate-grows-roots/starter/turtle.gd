# turtle.gd — World 4 / An Isolate Grows Roots, lesson 1: Teach a Turtle to Walk.
# Draws whatever COMMANDS spells: F walks forward drawing, + turns left, - turns
# right, [ bookmarks the pen's position and heading, ] returns to that bookmark.
# Try changing: COMMANDS (spell your initials) or TURN_DEG (90 = corners, 25 = plants).
extends Node2D

const STEP := 24.0                    # pixels per F
const TURN_DEG := 25.0                # degrees per + or - (converted once, below)
const START := Vector2(576, 560)
const INK := Color(0.93, 0.95, 0.90)

const COMMANDS := "FF[+F[+F][-F]][-F[+F][-F]]F[+F][-F]F"   # a fern sprig

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _draw() -> void:
	var turn := deg_to_rad(TURN_DEG)  # degrees for humans, radians for Godot
	var pos := START
	var heading := -PI / 2            # facing up; the screen's y-axis points down
	var bookmarks: Array = []         # the pen's pile of bookmarks
	var stroke := PackedVector2Array([pos])
	for c in COMMANDS:
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
					# A ']' with no matching '[' — the pen has nowhere to go back
					# to. We keep drawing rather than stopping: an unfinished
					# sentence still deserves its picture.
					print("turtle: a ']' had no '[' to return to — carrying on.")
					continue
				if stroke.size() >= 2:
					draw_polyline(stroke, INK, 2.0)
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
				stroke = PackedVector2Array([pos])
	if stroke.size() >= 2:
		draw_polyline(stroke, INK, 2.0)
