# visits.gd — World 3 · Tidepool Keeper · Lesson 2 "Visitors while you're away"
# Simulates a month of tidepool visits in one blink, then shows week one.
#   Gaps between visits: exponential, gap = -ln(u)/λ  (Poisson arrivals).
#   Tide clock: one sine with the M2 lunar period, about 12 h 25 min (NOAA).
# Console: the whole month's guestbook. Screen: the first week as a timeline.
# One thing to try changing: VISITS_PER_DAY (try 24, then 0.5).
extends Node2D

const VISITS_PER_DAY := 4.0     # λ, the average arrival rate
const DAYS_AWAY := 30.0         # how long the pool kept its own company
const TIDE_PERIOD_H := 12.42    # M2, the main lunar tide: ~12 h 25 min (NOAA)
const DRAW_DAYS := 7.0          # how much of the month the timeline shows
const WAVE_HEIGHT := 60.0       # tide wave height on screen, pixels
const MARGIN := 80.0
const INK := Color(0.92, 0.97, 0.95)
const WAVE := Color(0.35, 0.75, 0.72)
const SEA := Color(0.03, 0.09, 0.11)

var visit_hours: Array[float] = []   # when each guest arrived, in hours

func _ready() -> void:
	# The timeline is drawn once, not every frame — so a resized window asks
	# for one fresh drawing at the new size.
	get_viewport().size_changed.connect(queue_redraw)
	randomize()   # a fresh month every run (use seed(3) to replay one month)
	var rate_per_hour := VISITS_PER_DAY / 24.0
	var t := 0.0
	while true:
		var u := maxf(randf(), 0.0000001)   # never exactly 0: ln(0) has no answer
		t += -log(u) / rate_per_hour        # the exponential gap: -ln(u)/λ
		if t > DAYS_AWAY * 24.0:
			break
		visit_hours.append(t)
	print_guestbook()

func print_guestbook() -> void:
	print("=== Guestbook: %d days away, %d visits ===" % [int(DAYS_AWAY), visit_hours.size()])
	for t in visit_hours:
		var day := int(t / 24.0) + 1
		var hour := int(t) % 24
		var minute := int(fmod(t, 1.0) * 60.0)
		print("Day %02d · %02d:%02d · a visitor came %s" % [day, hour, minute, tide_word(t)])
	print("=== Nothing expired while you were gone. ===")

func tide_height(t_hours: float) -> float:
	return sin(TAU * t_hours / TIDE_PERIOD_H)   # -1 low water .. +1 high water

func tide_word(t_hours: float) -> String:
	var h := tide_height(t_hours)
	if h > 0.5:
		return "at high water, when the pool brims"
	if h < -0.5:
		return "at low water, when the pool lies quiet"
	return "while the tide was turning"

func _draw() -> void:
	var size := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, size), SEA)
	var mid_y := size.y * 0.5
	var width := size.x - MARGIN * 2.0
	var window_h := DRAW_DAYS * 24.0
	var wave_points := PackedVector2Array()
	for i in int(window_h * 4.0) + 1:        # four pen positions per hour
		var t := i / 4.0
		var x := MARGIN + width * (t / window_h)
		wave_points.append(Vector2(x, mid_y - tide_height(t) * WAVE_HEIGHT))
	draw_polyline(wave_points, WAVE, 2.0)
	for t in visit_hours:
		if t > window_h:
			break
		var x := MARGIN + width * (t / window_h)
		draw_circle(Vector2(x, mid_y - tide_height(t) * WAVE_HEIGHT), 4.0, INK)
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(MARGIN, mid_y + WAVE_HEIGHT + 40.0),
		"week one · each dot is a guest, riding the tide it arrived on",
		HORIZONTAL_ALIGNMENT_LEFT, -1, 16, INK)
