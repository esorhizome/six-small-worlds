# rule90.gd — Six Small Worlds · World 2 · Lesson 3: Worlds From Neighbours
# Grows an elementary cellular automaton down the screen, one row per tick.
# Every new cell reads its three parents (left, self, right) and looks its fate
# up in one byte: RULE. 90 grows the Sierpinski triangle; 30 grows chaos —
# the same family that grows the Atlas habitats in upgrade Biotech.
# One thing to try changing: RULE → 30, 110 or 184; or SEED_MODE → "random".

extends Node2D

const RULE := 90              # 0..255 — the whole world in one byte
const CELL_SIZE := 6.0        # pixel size of one cell
const ROWS_PER_SECOND := 20.0 # growth speed down the page
const SEED_MODE := "centre"   # "centre" = one live cell; "random" = noise row
const RANDOM_SEED := 26       # fixed, so "random" grows the same world each run
const ON_COLOR := Color(0.6, 0.9, 0.75)

var grid: Array[PackedInt32Array] = []
var cols := 0
var rows_total := 0
var rows_shown := 0.0


func _ready() -> void:
	_build()
	# The world is exactly as wide as the window, so a resized window is a
	# different world. We grow it again from its first row.
	get_viewport().size_changed.connect(_build)


func _build() -> void:
	var view := get_viewport_rect().size
	# maxi(..., 1): a window can be dragged narrower than one cell, and a world
	# with no columns has nowhere to put its first live cell.
	cols = maxi(int(view.x / CELL_SIZE), 1)
	rows_total = maxi(int(view.y / CELL_SIZE), 1)
	grid.clear()
	rows_shown = 0.0
	var first := PackedInt32Array()
	first.resize(cols)
	if SEED_MODE == "random":
		seed(RANDOM_SEED)
		for x in cols:
			first[x] = randi() % 2
	else:
		first[int(cols / 2.0)] = 1
	grid.append(first)
	for _y in rows_total - 1:
		grid.append(_next_row(grid[grid.size() - 1]))


func _next_row(parent: PackedInt32Array) -> PackedInt32Array:
	var child := PackedInt32Array()
	child.resize(cols)
	for x in cols:
		var left := parent[(x - 1 + cols) % cols]  # the row wraps at the edges
		var mid := parent[x]
		var right := parent[(x + 1) % cols]
		var pattern := left * 4 + mid * 2 + right  # 0..7, the parents as binary
		child[x] = (RULE >> pattern) & 1           # read bit `pattern` of RULE
	return child


func _process(delta: float) -> void:
	if rows_shown < float(rows_total):
		rows_shown = minf(rows_shown + ROWS_PER_SECOND * delta, float(rows_total))
		queue_redraw()


func _draw() -> void:
	for y in int(rows_shown):
		var row := grid[y]
		for x in cols:
			if row[x] == 1:
				draw_rect(Rect2(float(x) * CELL_SIZE, float(y) * CELL_SIZE,
						CELL_SIZE, CELL_SIZE), ON_COLOR, true)
