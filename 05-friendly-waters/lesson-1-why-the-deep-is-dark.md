# Lesson 1 · Why the Deep Is Dark

*World 5 · Friendly Waters — lesson 1 of 3*

**Promise:** by the end of this lesson you'll have a light that honestly fades
with depth — a glowing circle that keeps only what real seawater would let it
keep, while the five real ocean zones drift past at their true depths.

## If this is your first time

Welcome — you need no maths past what a calculator's buttons already know, and
watching along without typing still counts. Setup is five minutes: install
[Godot 4.3+](https://godotengine.org), make a new project, add a **Node2D** as
the scene root, attach a new script to it, and you have a place to paste every
code block below. Press **F5** to run (Godot will ask to set the current scene
as main — say yes).

## See it first

Think of car headlights in fog. Close to the car, the beams are fierce; a few
metres on, softer; further still, a suggestion; and at some distance the fog
has quietly kept all of it. No wall was hit. The light didn't stop — it was
*taxed*, a little, by every metre of fog it crossed.

Seawater runs the same tax office. Picture a hundred lanterns' worth of
sunlight at the surface. Sink a short way and the water has kept some fraction
— say half. Sink the *same distance again* and you don't lose another "half of
the original"; you lose half *of what you still have*. A hundred becomes
fifty, becomes twenty-five, becomes twelve-ish, becomes six. Equal steps down,
shrinking losses — because the ocean charges a percentage, never a flat fee.

Ride that all the way down and you get the ocean's floor plan, which is real
and wonderful (NOAA keeps the measurements):

- **Sunlight zone** (epipelagic) — the surface to about **200 m**. Enough light
  to live on. Nearly everything you picture when you picture "the sea" is here.
- **Twilight zone** (mesopelagic) — about **200 m to 1,000 m**. Light enough to
  glimpse shapes, not enough to grow anything.
- **Midnight zone** (bathypelagic) — about **1,000 m to 4,000 m**. Sunlight is
  effectively gone. Any light down here, something *made*.
- **The Abyss** (abyssopelagic) — about **4,000 m to 6,000 m**. Near-freezing,
  utterly dark.
- **The Hadal zone** — the trenches, **6,000 m down to about 11 km**. The
  deepest surveyed point, Challenger Deep, sits near **10,935 m**.

One equation explains the whole staircase. Let's meet it.

## The maths, small

> **The law of fading light** — three new symbols, no more.
>
> | symbol | say it as |
> |---|---|
> | *I* | the light that remains (*I₀* is the same dial read at the surface, depth zero) |
> | *k* | the water's appetite — what fraction of the light each metre eats |
> | *z* | your depth, in metres |
>
> **I = I₀ · e^(−k·z)**
>
> In plain English: *the light that remains is the light you started with,
> multiplied by the same survival fraction once for every metre you sink.*
> The letter **e** is Euler's number, about 2.718 — the number living behind
> your calculator's **eˣ** button. It's how mathematicians write "the same
> multiplier, applied continuously" without listing every metre by hand.
>
> The contrast that makes it click: a **linear** fade *subtracts* the same
> amount each metre, hits zero, and is done. An **exponential** fade *keeps*
> the same fraction each metre — so it plunges fast at first, then thins
> forever without quite reaching zero. Real water does the second one.

This law has three parents: **Pierre Bouguer** worked it out in 1729 — each
layer of a transparent medium keeps the same fraction of the light entering
it. **Johann Heinrich Lambert** restated it in *Photometria* (1760), and
**August Beer** (1852) tied the constant to how much absorbing stuff is
dissolved in the liquid. Chemists say "Beer–Lambert"; history says Bouguer got
there first.

For this lesson we choose **k = 0.023 per metre** — picked so that only 1% of
surface light survives to 200 m, which is the depth NOAA gives as the
practical floor of the sunlit zone. (Real k varies with the water's clarity
and even the light's colour; more on that in *Go deeper*.) Our k has lovely
manners:

| depth *z* | what remains, I/I₀ |
|---|---|
| 0 m | 100% |
| 30 m | about 50% — the light **halves every ~30 m** |
| 100 m | about 10% — a **tenth every 100 m** |
| 200 m | about 1% — the sunlit zone's floor |
| 1,000 m | about a **ten-billionth** — "effectively gone", as NOAA puts it |
| 10,935 m | a decimal point followed by roughly 107 zeros. The maths keeps going; the light, for every practical purpose, does not |

## Build it

### Step 1 — a sun in the water

One idea: draw the scene before it knows any physics. Paste this over your
script's contents and run it.

```gdscript
extends Node2D

func _draw() -> void:
	var view := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.05, 0.35, 0.6))
	draw_circle(view / 2.0, 220.0, Color(1.0, 0.96, 0.8))
```

**Run it.** A warm pale disc in tropical blue. Static, confident, unaware of
what's coming. If you see a grey screen instead, the script probably isn't
attached to the Node2D — click the node and check for the scroll icon.

### Step 2 — teach the screen how deep you are

One idea: a number called `depth` that you control. Hold ↓ to sink, ↑ to rise,
or scroll the mouse wheel. Nothing visual reacts yet except a readout — that's
the point of this step.

```gdscript
extends Node2D

const DESCEND_SPEED := 400.0   # metres of depth per held second
const WHEEL_STEP := 100.0      # metres per mouse-wheel notch
const MAX_DEPTH := 10935.0     # Challenger Deep, metres (NOAA)

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
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.05, 0.35, 0.6))
	draw_circle(view / 2.0, 220.0, Color(1.0, 0.96, 0.8))
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(24, 40), "depth  %d m" % int(depth),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(0.85, 0.9, 1.0))
```

**Run it.** Hold ↓ and the counter climbs to 10,935 and politely stops
(`clampf` is the seabed and the surface, in one line). The sun ignores you.
For one more step, the ocean is broken — and knowing *why* it's broken is
most of this lesson. If Godot underlines something red, read the message
calmly: it's the computer asking a clarifying question, usually about a
missing bracket or a stray space.

### Step 3 — apply the law

One idea, the lesson's heart: the radius obeys **I = I₀ · e^(−k·z)**. In code,
that whole sentence is one line — `exp(-K_PER_METRE * depth)` — a number
between 1 (surface) and nearly 0 (deep), which we call `survival` and multiply
into the radius.

```gdscript
extends Node2D

const K_PER_METRE := 0.023     # fraction of light the water eats, per metre
const SURFACE_RADIUS := 220.0  # glow radius at 0 m, in pixels
const DESCEND_SPEED := 400.0   # metres of depth per held second
const WHEEL_STEP := 100.0      # metres per mouse-wheel notch
const MAX_DEPTH := 10935.0     # Challenger Deep, metres (NOAA)

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
	var survival := exp(-K_PER_METRE * depth)  # the whole lesson, one line
	draw_rect(Rect2(Vector2.ZERO, view), Color(0.05, 0.35, 0.6))
	var radius := SURFACE_RADIUS * survival
	if radius > 0.5:
		draw_circle(view / 2.0, radius, Color(1.0, 0.96, 0.8))
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(24, 40), "depth  %d m" % int(depth),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(0.85, 0.9, 1.0))
	draw_string(font, Vector2(24, 64),
			"sunlight  %s %% of surface" % String.num_scientific(survival * 100.0),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.7, 0.8, 0.95))
```

**Run it.** Descend slowly and watch the disc collapse — big losses in the
first 100 m, then a fingernail, then a dot, then nothing you can see, all
before 300 m. Keep descending anyway and read the second line: the percentage
grows a longer and longer tail of zeros (Godot switches to scientific
notation, numbers like `1.02e-08`), because the maths never actually reaches
zero. Your screen is now telling the truth about the ocean. That moment where
the light dies embarrassingly early? Not a bug. That's the lesson.

### Step 4 — let everything obey the same law

One idea: *reuse* `survival`. The water's colour should fade by the same rule
as the glow — one law, worn twice. While we're here, the hard-edged disc
becomes three stacked circles (wide and faint, middle, core) so it reads as
light instead of a poker chip.

```gdscript
extends Node2D

const K_PER_METRE := 0.023     # fraction of light the water eats, per metre
const SURFACE_RADIUS := 220.0  # glow radius at 0 m, in pixels
const DESCEND_SPEED := 400.0   # metres of depth per held second
const WHEEL_STEP := 100.0      # metres per mouse-wheel notch
const MAX_DEPTH := 10935.0     # Challenger Deep, metres (NOAA)

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

	# The sunlight glow. Radius follows the law; under half a pixel we let it rest.
	var radius := SURFACE_RADIUS * survival
	if radius > 0.5:
		for layer in GLOW_LAYERS:
			draw_circle(centre, radius * layer[0], Color(1.0, 0.96, 0.8, layer[1]))

	# Readout: your depth, and what remains of the sun.
	var font := ThemeDB.fallback_font
	draw_string(font, Vector2(24, 40), "depth  %d m" % int(depth),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 17, Color(0.85, 0.9, 1.0))
	draw_string(font, Vector2(24, 64),
			"sunlight  %s %% of surface" % String.num_scientific(survival * 100.0),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.7, 0.8, 0.95))
```

**Run it.** Now the descent has atmosphere: the whole scene dims together,
tropical blue giving way to ink. `lerp` here means "blend between two colours
by this amount" — and the amount is `survival`, the very number the law hands
us. If your glow looks lopsided or your blues look different from mine, good:
you tuned a colour, which means you found the knobs.

### Step 5 — let the zones drift past

One idea: things at *fixed real depths*, sliding past you as you sink. Each
zone boundary lives at its NOAA depth; we convert "metres away from me" into
"pixels away from screen centre" and draw a line and a label when it's near.
This finished file also lives at [`starter/depth_light.gd`](starter/depth_light.gd).

```gdscript
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
			"sunlight  %s %% of surface" % String.num_scientific(survival * 100.0),
			HORIZONTAL_ALIGNMENT_LEFT, -1, 15, Color(0.7, 0.8, 0.95))
```

**Run it.** Hold ↓ and take the full trip — about half a minute. The Sunlight
zone's floor slides past as the glow gives out; Twilight and Midnight arrive
as names in the dark; and after a long, dark, honest while, the Challenger
Deep line rises to meet you at 10,935 m. Most of your descent happens in
water the sun never reaches. Now you know why — and by which equation.

## You can stop here.

You built the thing the promise promised: a light that fades by the real law,
through the real zones, to the real bottom. This is also the exact machine one
of our games swims inside: in *Friendly Waters*, Volta's electric charge **is
her light radius** — the resource isn't a bar in a corner of the screen, it's
the circle you can see by. One equation, doubling as an entire resource
economy. Everything below is bonus.

## Go deeper (optional)

- **Colours die in order.** Water is greedier for long wavelengths: reds are
  swallowed within the first few tens of metres, blues last longest — one
  reason underwater film drifts blue-green, and the deep reads as blue-black
  (NOAA's education pages walk through light in the sea). Try three glows —
  red, green, blue — each with its own `K_PER_METRE`, red's largest. Watch
  your sun die in colour order.
- **Draw the law itself.** Build a `PackedVector2Array` of points
  `(z, I(z))` for z from 0 to 1,000, scale to the screen, and
  `draw_polyline` it in a corner: a live graph of your own descent.
- **A fantasy k.** Set `K_PER_METRE := 0.002` and the Midnight zone keeps a
  little sky — a legal move for a game, as long as you know which law you're
  bending. Design question, open on purpose: *if light is a resource, what
  should k feel like — a difficulty setting, a mood, or a place?*
- **Somebody lives down there.** The deepest fishes known are hadal
  snailfishes; one, *Pseudoliparis swirei*, was described from the Mariana
  Trench from depths approaching 8,000 m (Gerringer et al., 2017). Baro — the
  friend you'll build toward in lesson 3 — is one of their kind.

## Check yourself

1. With our k, roughly what fraction of surface light remains at 200 m?
2. One fade *subtracts* the same amount each metre; one *keeps* the same
   fraction. Which is which, and which one can genuinely reach zero?
3. The light halves about every 30 m. After 90 m, roughly what's left?

<details>
<summary>Answers (the repo's version of printing them upside-down)</summary>

1. About 1% — that's what k = 0.023 was chosen to do, matching the sunlit
   zone's floor.
2. Subtracting is the linear fade, and it's the one that reaches zero;
   keeping a fraction is the exponential fade, which only approaches zero.
3. Three halvings: ½ × ½ × ½ = ⅛, so about 12–13%.

</details>

## Sources

- **Primary:** P. Bouguer, *Essai d'optique sur la gradation de la lumière*,
  1729. First statement of the exponential absorption law: each layer of a
  transparent medium keeps the same fraction of the light entering it.
- **Primary:** J. H. Lambert, *Photometria*, 1760. Restated and formalised
  the law that now carries his name.
- **Primary:** A. Beer, on the absorption of light in coloured liquids,
  *Annalen der Physik und Chemie*, 1852. Tied the attenuation constant to the
  concentration of the absorbing substance — completing the "Beer–Lambert"
  family.
- **Primary:** M. E. Gerringer et al., description of *Pseudoliparis swirei*,
  the Mariana hadal snailfish, *Zootaxa*, 2017. Among the deepest-living
  fishes known.
- **Secondary (free):** NOAA Ocean Exploration education pages,
  [oceanexplorer.noaa.gov](https://oceanexplorer.noaa.gov) — the five ocean
  zones and their depths; the photic zone's ~200 m floor; sunlight effectively
  absent below ~1,000 m; hadal depths to ~11 km (Challenger Deep ≈ 10,935 m).
