# rose_garden.gd — Six Small Worlds · World 2 · Lesson 2 (build A): the garden
# Draws 26 rose curves, r = cos(k·θ) for k = 1..26, one per letter A–Z —
# the same family that grows the Garden in upgrade Biotech.
# Odd k blooms k petals; even k blooms 2k. Count them and check.
# One thing to try changing: SATURATION, or swap cos for sin and spot the turn.

extends Node2D

const FLOWER_COUNT := 26   # one flower per letter of the alphabet
const COLUMNS := 6         # grid width; 26 flowers make five rows, minus a gap
const SEGMENTS := 360      # points along each curve — more means smoother
const MARGIN := 20.0       # breathing room around the grid, in pixels
const FLOWER_FILL := 0.38  # how much of its grid cell a flower fills
const LINE_WIDTH := 1.5
const SATURATION := 0.5    # 0 = ghostly, 1 = neon


func _ready() -> void:
	# This garden is drawn once, not every frame — so when the window changes
	# shape we ask for one fresh drawing at the new size.
	get_viewport().size_changed.connect(queue_redraw)


func _draw() -> void:
	var view := get_viewport_rect().size
	var rows := int(ceil(float(FLOWER_COUNT) / float(COLUMNS)))
	var cell := Vector2((view.x - MARGIN * 2.0) / float(COLUMNS),
			(view.y - MARGIN * 2.0) / float(rows))
	var radius := minf(cell.x, cell.y) * FLOWER_FILL
	for i in FLOWER_COUNT:
		var col := i % COLUMNS
		var row := int(float(i) / float(COLUMNS))
		var centre := Vector2(MARGIN, MARGIN) + Vector2(
				(float(col) + 0.5) * cell.x, (float(row) + 0.5) * cell.y)
		_draw_rose(centre, radius, i + 1)
		# String.chr turns a character number into a letter: 65 is "A", 66 "B"…
		draw_string(ThemeDB.fallback_font, centre + Vector2(-4.0, -radius - 6.0),
				String.chr(65 + i), HORIZONTAL_ALIGNMENT_LEFT, -1, 12,
				Color(0.6, 0.6, 0.68))


func _draw_rose(centre: Vector2, radius: float, k: int) -> void:
	var points := PackedVector2Array()
	points.resize(SEGMENTS + 1)
	for s in SEGMENTS + 1:
		var theta := TAU * float(s) / float(SEGMENTS)  # TAU = one full turn
		var r := radius * cos(float(k) * theta)
		points[s] = centre + Vector2(cos(theta), sin(theta)) * r
	var hue := float(k - 1) / float(FLOWER_COUNT)
	draw_polyline(points, Color.from_hsv(hue, SATURATION, 0.95), LINE_WIDTH, true)
