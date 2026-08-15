# one_turn.gd — World 4 / An Isolate Grows Roots, lesson 3: One Turn at a Time.
# An L-system root (lesson 2's grammar, worn upside down) grows downward in
# eased bursts — one burst per click. A click that arrives mid-turn is
# politely refused, and says so with a fading ring rather than an error.
# Try changing: TURN_SECONDS (a slower root), or EASE := false (feel the robot).
extends Node2D

const AXIOM := "X"  # lesson 2's plant, worn as a root
const RULES := { "X": "F+[[X]-X]-F[-FX]+X", "F": "FF" }
const ANGLE_DEG := 25.0
const GENERATIONS := 4
const STEP := 7.0                    # every root segment is this long
const START := Vector2(576, 40)      # top centre — roots hang from the seed
const TURNS := 13                    # growth arrives in thirteen bursts
const TURN_SECONDS := 2.6            # how long one burst takes
const EASE := true                   # false = linear growth, for comparison
const INK := Color(0.93, 0.95, 0.90)

var _segs: Array = []                # recorded segments: [from, to] pairs
var _total := 0.0                    # full length of the finished root
var _shown := 0.0                    # how much of it is visible right now
var _from := 0.0                     # _shown when the current turn began
var _to := 0.0                       # _shown promised by the end of it
var _t := 2.0                        # time through the turn; above 1 = resting
var _rings: Array = []               # [position, age] of politely refused taps

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))
	var word := AXIOM
	for i in GENERATIONS:            # the grammar from lesson 2
		var grown := ""
		for c in word:
			grown += str(RULES.get(c, c))
		word = grown
	var turn := deg_to_rad(ANGLE_DEG)  # degrees at the border, radians inside
	var pos := START
	var heading := PI / 2            # facing down: this plant is a root
	var bookmarks: Array = []
	for c in word:                   # the walk from lesson 1, recorded
		match c:
			"F":
				var next := pos + Vector2(cos(heading), sin(heading)) * STEP
				_segs.append([pos, next])
				pos = next
			"+": heading -= turn
			"-": heading += turn
			"[": bookmarks.push_back([pos, heading])
			"]":
				if bookmarks.is_empty():
					continue   # a ']' with no '[' — nothing to return to
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
	_total = STEP * _segs.size()

func _unhandled_input(event: InputEvent) -> void:
	# Left button only: a scroll wheel is also a mouse button, and a stray
	# scroll should not spend one of your thirteen turns.
	if event is InputEventMouseButton and event.pressed \
			and event.button_index == MOUSE_BUTTON_LEFT:
		if _t <= 1.0:                # mid-turn: the root declines, gently
			_rings.append([event.position, 0.0])
		elif _to < _total:           # resting, not yet finished: a turn begins
			_from = _shown
			_to = minf(_shown + _total / TURNS, _total)
			_t = 0.0

func _process(delta: float) -> void:
	if _t <= 1.0:
		_t = minf(_t + delta / TURN_SECONDS, 1.0)
		var p := 1.0 - pow(1.0 - _t, 3.0) if EASE else _t  # ease-out cubic (Penner)
		_shown = lerpf(_from, _to, p)
		if _t >= 1.0: _t = 2.0       # the turn ends; the root rests
	for ring in _rings: ring[1] += delta * 1.5
	_rings = _rings.filter(func(r): return r[1] < 1.0)
	queue_redraw()

func _draw() -> void:
	draw_circle(START, 4.0, INK)     # the seed, waiting
	for i in _segs.size():
		if STEP * (i + 1) <= _shown:
			draw_line(_segs[i][0], _segs[i][1], INK, 2.0)
		elif STEP * i < _shown:      # the one segment currently growing
			var tip: Vector2 = _segs[i][0].lerp(_segs[i][1], (_shown - STEP * i) / STEP)
			draw_line(_segs[i][0], tip, INK, 2.0)
			draw_circle(tip, 3.0, INK)
	for ring in _rings:
		draw_arc(ring[0], 10.0 + 14.0 * ring[1], 0.0, TAU, 24, Color(INK, 0.5 * (1.0 - ring[1])), 1.5)
