# Lesson 2 · The grammar of plants

**Promise:** by the end of this lesson, a branching plant fills your window —
grown, not drawn, from one starting letter and one rewrite rule.

## If this is your first time

This lesson stands on lesson 1's walking pen, but you don't need to have
typed any of it — every step below is a complete script you can paste whole.
If the words "stack" or "grammar" have ever been used at you unkindly,
today they arrive as a bookmark and a plant. Nothing here bites.

## See it first

Watch a plant grow in your mind — a time-lapse. Notice what it *doesn't* do:
it doesn't draw itself top to bottom like a pen would. Every growing tip
grows **at the same time**. The stem lengthens while every bud on it opens,
while every bud on *those* opens. Growth is something that happens
*everywhere at once*, to a structure that already exists.

Now the odd idea this lesson is built on: describe the plant as a **sentence**,
and growth as **editing**. Start with a one-letter sentence. Apply a rule —
"wherever you see this letter, replace it with this phrase" — to every letter
at once. The sentence gets longer. Do it again. And again. Each pass is a
**generation**, and the sentence's letters are turtle commands: after a few
generations you hand the sentence to lesson 1's pen, and the pen walks out
a plant.

This is an **L-system** — named for the botanist Aristid Lindenmayer, who
introduced the idea in 1968 to describe how simple filament-shaped organisms
develop, cell by cell. The all-at-once rewriting was the point: cells divide
all over an organism in the same season, not one after another, politely
queueing. Biology is parallel, so the grammar is too.

> ## The maths, small
>
> Three symbols:
>
> - **ω** (omega) — the *axiom*: the one-letter starting sentence.
> - **→** — *becomes*: the rewrite arrow. `A → AB` reads "every A becomes AB".
> - **n** — the *generation*: how many rewrite passes have happened.
>
> The whole plant we're growing today is these two rules:
>
> ```
> ω:  X
> X → F+[[X]-X]-F[-FX]+X
> F → FF
> ```
>
> In plain English: **X is a bud** — a plan for growth that draws nothing
> itself. Each generation, every bud becomes a little architecture of stem,
> turns, bookmarks, and five new buds-or-stems. **F is finished stem**, and
> stems keep thickening the plan by doubling (`F → FF`). Symbols with no
> rule (`+`, `-`, `[`, `]`) pass through unchanged, like punctuation.
>
> One number to feel the growth: this sentence is 1 symbol at the start,
> then 18, 89, 379, and **1,551 symbols by generation 4**. You will not be
> typing it by hand. That's the entire reason this lesson exists.

## Build it

### Step 1 — a rewriter, with the plant left out

One new idea: the rewrite loop, on a toy rule small enough to watch. New
script on a `Node2D` (or replace what's there):

```gdscript
extends Node2D

const AXIOM := "A"
const RULES := { "A": "AB", "B": "A" }
const GENERATIONS := 5

func _ready() -> void:
	var word := AXIOM
	print(word)
	for i in GENERATIONS:
		var grown := ""
		for c in word:
			var rule: String = RULES.get(c, c)  # no rule? keep the letter
			grown += rule
		word = grown
		print(word, "   (", word.length(), " letters)")
```

Run it and look at Godot's **Output** panel at the bottom. **Expected:**

```
A
AB   (2 letters)
ABA   (3 letters)
ABAAB   (5 letters)
ABAABABA   (8 letters)
ABAABABAABAAB   (13 letters)
```

Two things worth saying out loud. First: `RULES.get(c, c)` means "look up a
rule for this letter; if there isn't one, the letter survives unchanged" —
that second `c` is the whole mercy of the system. Second: count the lengths.
1, 2, 3, 5, 8, 13 — each is the sum of the previous two. The Fibonacci
numbers walked in uninvited, from a two-line grammar. (They'll do that.
World 2 met the same family in sunflower heads.)

### Step 2 — feed it the real plant

One new idea: rules where the replacement contains turtle commands. Change
only the three constants:

```gdscript
const AXIOM := "X"
const RULES := { "X": "F+[[X]-X]-F[-FX]+X", "F": "FF" }
const GENERATIONS := 4
```

and make the last print gentler, because the sentence is about to get long:

```gdscript
		print(word.substr(0, 40), "...   (", word.length(), " symbols)")
```

**Expected:** four lines whose lengths read `18`, `89`, `379`, `1551`. The
rewriter neither knows nor cares that `+` and `[` mean something to a pen —
it moves letters. The *meaning* lives entirely in whoever reads the sentence
next. (That division of labour — a dumb grower, a dumb walker, intelligence
in neither — is the most reusable trick in this whole world.)

### Step 3 — the bookmark, properly

One new idea (a review, if you took lesson 1's deep route): `[` bookmarks
the pen's position and heading; `]` returns to the newest bookmark.
Bookmarks stack — a branch can bookmark inside a branch — so the pen keeps
a pile of them and always opens the top one. Here is the walker alone, on a
hand-written sentence:

```gdscript
extends Node2D

const STEP := 60.0
const TURN_DEG := 45.0                # θ from lesson 1, wider for visibility
const START := Vector2(576, 500)
const INK := Color(0.93, 0.95, 0.90)

var commands := "F[+F][-F]F"

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _draw() -> void:
	var turn := deg_to_rad(TURN_DEG)  # degrees for humans, radians for Godot
	var pos := START
	var heading := -PI / 2            # facing up; screen y points down
	var bookmarks: Array = []
	var stroke := PackedVector2Array([pos])
	for c in commands:
		match c:
			"F":
				pos += Vector2(cos(heading), sin(heading)) * STEP
				stroke.append(pos)
			"+":
				heading -= turn
			"-":
				heading += turn
			"[":
				bookmarks.push_back([pos, heading])
			"]":
				if stroke.size() >= 2:
					draw_polyline(stroke, INK, 2.0)
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
				stroke = PackedVector2Array([pos])
	if stroke.size() >= 2:
		draw_polyline(stroke, INK, 2.0)
```

**Expected:** a sapling with two arms — stem, left arm, right arm, and the
stem carrying on upward *as if the arms had never happened*. That
as-if-nothing-happened is the bookmark doing its job. Without `[` and `]`,
the pen would wander off along the first arm and never come home.

### Step 4 — grower meets walker

Last new idea: pipe step 2's sentence into step 3's pen. This is the
complete [`starter/lsystem.gd`](starter/lsystem.gd):

```gdscript
extends Node2D

const AXIOM := "X"
const RULES := { "X": "F+[[X]-X]-F[-FX]+X", "F": "FF" }
const ANGLE_DEG := 25.0               # θ — the plant's signature angle
const GENERATIONS := 4                # 1,551 symbols; each +1 roughly ×4
const STEP := 7.0
const START := Vector2(576, 620)
const INK := Color(0.93, 0.95, 0.90)

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _grow() -> String:
	var word := AXIOM
	for i in GENERATIONS:
		var grown := ""
		for c in word:
			var rule: String = RULES.get(c, c)
			grown += rule
		word = grown
	return word

func _draw() -> void:
	var turn := deg_to_rad(ANGLE_DEG) # degrees for humans, radians for Godot
	var pos := START
	var heading := -PI / 2            # facing up; screen y points down
	var bookmarks: Array = []
	var stroke := PackedVector2Array([pos])
	for c in _grow():
		match c:
			"F":
				pos += Vector2(cos(heading), sin(heading)) * STEP
				stroke.append(pos)
			"+":
				heading -= turn
			"-":
				heading += turn
			"[":
				bookmarks.push_back([pos, heading])
			"]":
				if stroke.size() >= 2:
					draw_polyline(stroke, INK, 2.0)
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
				stroke = PackedVector2Array([pos])
	if stroke.size() >= 2:
		draw_polyline(stroke, INK, 2.0)
```

(The angle ritual from lesson 1 is still here: degrees in the constant for
us, one `deg_to_rad()` at the border for Godot, which thinks in radians.)

Before pressing F5, set `GENERATIONS := 1` and grow it by hand, one number
at a time:

- **Generation 1:** three short strokes and a kink. An unpromising twig.
  (The buds — every `X` — are invisible: they're plans, not wood.)
- **Generation 2:** a sapling. The twig is now *inside* it, thickened.
- **Generation 3:** recognisably a plant, leaning to one side. (It leans on
  purpose; the rule is not symmetric, and neither are plants.)
- **Generation 4:** the classic — a feathery, branching plant filling the
  window, every frond a smaller copy of the whole. This exact family of
  bracketed plants is the showpiece of *The Algorithmic Beauty of Plants*,
  chapter 1, and you have grown one from two rules and a letter.

If yours looks sparse or clipped at the window's edge, adjust `STEP` or
`START` — that's gardening, not debugging.

## You can stop here.

Generation 4 on screen is the whole promise kept: a plant nobody drew.
Everything below is for gardeners who want no two plants alike.

## Go deeper (optional) — a die inside the grammar

Our plant is identical every run, which is well-behaved and slightly
suspicious. Real plants share a *grammar*, not a blueprint — same species,
same habits of branching, and yet no two ferns match. L-systems have a
classical answer (*The Algorithmic Beauty of Plants*, §1.7, "Stochastic
L-systems"): give a letter **several** replacement options and roll a die
each time it's rewritten. Same rules, different dice, sibling plants.

Complete script — note the rules are now *lists*, and the rewriter picks
from them:

```gdscript
extends Node2D

const AXIOM := "F"
const RULES := {
	"F": ["F[+F]F[-F]F", "F[+F]F", "F[-F]F"],  # ABoP's classic trio
}
const ANGLE_DEG := 25.0
const GENERATIONS := 4
const STEP := 6.0
const START := Vector2(576, 620)
const INK := Color(0.93, 0.95, 0.90)

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.06, 0.07, 0.09))

func _grow() -> String:
	var word := AXIOM
	for i in GENERATIONS:
		var grown := ""
		for c in word:
			if RULES.has(c):
				var options: Array = RULES[c]
				grown += options.pick_random()   # the die
			else:
				grown += c
		word = grown
	return word

func _draw() -> void:
	var turn := deg_to_rad(ANGLE_DEG) # degrees for humans, radians for Godot
	var pos := START
	var heading := -PI / 2            # facing up; screen y points down
	var bookmarks: Array = []
	var stroke := PackedVector2Array([pos])
	for c in _grow():
		match c:
			"F":
				pos += Vector2(cos(heading), sin(heading)) * STEP
				stroke.append(pos)
			"+":
				heading -= turn
			"-":
				heading += turn
			"[":
				bookmarks.push_back([pos, heading])
			"]":
				if stroke.size() >= 2:
					draw_polyline(stroke, INK, 2.0)
				var mark: Array = bookmarks.pop_back()
				pos = mark[0]
				heading = mark[1]
				stroke = PackedVector2Array([pos])
	if stroke.size() >= 2:
		draw_polyline(stroke, INK, 2.0)
```

**Expected:** a plant — a different one every run. Press F5 five times:
some come out tall and sparse, some squat and bushy, and a tall one may
poke out of the top of the window like a plant that outgrew its pot. One
grammar, a forest of individuals. This is how a game gives every
neighbour's garden its own plants without an artist drawing any of them.

Open-ended prompt: make a *leaning* grammar — give the options unequal
turns (more `+` than `-`) and grow a hedge that has clearly heard about
wind. Then try weighting the die: put the same option into the list twice
and it becomes twice as likely.

## Check yourself

1. With the toy rules `A → AB`, `B → A`, what generation follows `ABA`?
2. Why do `+`, `-`, `[`, `]` survive rewriting untouched?
3. Generation 4 of the plant is 1,551 symbols. Roughly how many is
   generation 5 — and would you rather type it or grow it?

## Sources

- **Primary:** A. Lindenmayer, "Mathematical models for cellular
  interactions in development, Parts I–II", *Journal of Theoretical
  Biology* 18:280–315, 1968. Introduced parallel rewriting systems as a
  model of development in filament-shaped organisms — the papers this whole
  lesson is named after.
- **Secondary (free):** P. Prusinkiewicz & A. Lindenmayer, *The Algorithmic
  Beauty of Plants*, Springer, 1990 — free PDF at
  [algorithmicbotany.org/papers/#abop](http://algorithmicbotany.org/papers/#abop).
  Chapter 1 defines the turtle interpretation and the bracketed plants this
  lesson grows; §1.7 is the stochastic die.
- **Secondary (free):** Daniel Shiffman, *The Nature of Code*, free at
  [natureofcode.com](https://natureofcode.com) — the fractals chapter walks
  the same ideas in a browser, if you'd like a second telling.

---

<sub>**Answers:** 1. `ABAAB` — each `A` became `AB`, the `B` became `A`,
all in the same breath. 2. The rewriter looks up each letter in `RULES` and
falls back to the letter itself (`RULES.get(c, c)`); no rule means no
change. 3. About four times more — 6,263 symbols. Grow it. (Each `X`
becomes eighteen symbols containing four new `X`s, so the sentence roughly
quadruples per generation.)</sub>

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
