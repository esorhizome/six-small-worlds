# depth_light.gd — World 5 · Friendly Waters · Lesson 1 (Why the Deep Is Dark)
# Draws a descent through the five real ocean zones. The sunlight glow
# follows the real attenuation law I = I0 * e^(-k * z), so every metre
# keeps the same fraction of light — watch it go.
# Controls: hold ↓ / ↑ (or scroll the mouse wheel) to dive and rise.
# Try changing: K_PER_METRE. 0.023 is clear Earth ocean; 0.002 grows a
# fantasy sea where even the Midnight zone keeps a little sky.
extends Node2D

const K_PER_METRE := 0.023     # fraction of light the water eats, per metre
const SURFACE_RADIUS := 220.0  # glow radius at 0 m, in pixels
const DESCEND_SPEED := 400.0   # metres of depth per held second
const WHEEL_STEP := 100.0      # metres per mouse-wheel notch
const PIXELS_PER_METRE := 0.4  # how fast the zone lines drift past
const MAX_DEPTH := 10935.0     # Challenger Deep, metres (NOAA)

# Each mark: [depth in metres, label]. Real zone boundaries (NOAA).
const DEPTH_MARKS := [
	[0.0, "Sunlight zone · Epipelagic · 0 m"],
	[200.0, "Twilight zone · Mesopelagic · 200 m"],
	[1000.0, "Midnight zone · Bathypelagic · 1,000 m"],
	[4000.0, "The Abyss · Abyssopelagic · 4,000 m"],
	[6000.0, "Hadal zone · the trenches · 6,000 m"],
	[10935.0, "Challenger Deep · 10,935 m"],
]

# The soft glow: three circles, each [scale of radius, alpha].
const GLOW_LAYERS := [[1.6, 0.10], [1.15, 0.25], [1.0, 0.6]]

var depth := 0.0  # metres below the surface

func _process(delta: float) -> void:
	var dive := Input.get_axis("ui_up", "ui_down")  # ↓ is +1, ↑ is -1
	depth = clampf(depth + dive * DESCEND_SPEED * delta, 0.0, MAX_DEPTH)
	queue_redraw()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			depth = clampf(depth + WHEEL_STEP, 0.0, MAX_DEPTH)
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			depth = clampf(depth - WHEEL_STEP, 0.0, MAX_DEPTH)

func _draw() -> void:
	var view := get_viewport_rect().size
	var centre := view / 2.0
	var survival := exp(-K_PER_METRE * depth)  # the whole lesson, one line

	# The water obeys the same law as the glow.
	var water := Color(0.0, 0.02, 0.05).lerp(Color(0.05, 0.35, 0.6), survival)
	draw_rect(Rect2(Vector2.ZERO, view), water)

	# Zone boundaries drift past at their true depths.
	var font := ThemeDB.fallback_font
	for mark in DEPTH_MARKS:
		var mark_depth: float = mark[0]
		var label: String = mark[1]
		var y := centre.y + (mark_depth - depth) * PIXELS_PER_METRE
		if y > -40.0 and y < view.y + 40.0:
			draw_line(Vector2(0, y), Vector2(view.x, y), Color(0.5, 0.65, 0.8, 0.25), 1.0)
			draw_string(font, Vector2(24, y + 22), label,
					HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.6, 0.75, 0.9, 0.6))

	# The sunlight glow. Radius follows the law; under half a pixel we let it rest.
	var radius := SURFACE_RADIUS * survival
	if radius > 0.5:
		for layer in GLOW_LAYERS:
			draw_circle(centre, radius * layer[0], Color(1.0, 0.96, 0.8, layer[1]))

	# Readout: your depth, and what remains of the sun.
	draw_string(font, Vector2(24, 40), "depth  %d m" % int(depth),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(0.85, 0.9, 1.0))
	draw_string(font, Vector2(24, 64),
			"sunlight  %s of surface" % _percent_words(survival * 100.0),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.7, 0.8, 0.95))

# Near the surface a plain percentage reads best ("100.00 %"). Past the
# twilight zone the number needs scientific notation to stay a number at all
# ("1.2e-09 %"). We switch at the point where plain digits stop meaning
# anything — the readout should always be readable, at every depth.
func _percent_words(percent: float) -> String:
	if percent >= 0.01:
		return "%.2f %%" % percent
	return "%s %%" % String.num_scientific(percent)
