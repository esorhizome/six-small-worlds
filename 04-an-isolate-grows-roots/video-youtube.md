# World 4 · An Isolate Grows Roots — long-form scripts (E10–E12)

*Three episodes, one per lesson. Format per STYLE: cold open with the
finished visual and no logo, beats table (timecode · on screen · spoken),
B-roll cues in italics, end card in the last 15 seconds. Target 12–18
minutes of speech each; live-coding beats stretch naturally — the spoken
lines below are the fixed rails, and narrating-while-typing fills the rest.*

---

## E10 · Teach a turtle to walk

**Companion lesson:** [lesson-1-teach-a-turtle-to-walk.md](lesson-1-teach-a-turtle-to-walk.md)
**Starter:** [starter/turtle.gd](starter/turtle.gd)

### Cold open (0:00–0:20)

On screen: a dark window. A pale fern sprig draws itself, stroke by stroke,
branch by branch, and settles. No logo, no face, no music yet.

> Spoken: "This fern is four commands. By the end of this video, you'll
> speak all four."

### Beats

| Time | On screen | Spoken |
|---|---|---|
| 0:20–1:10 | Title card: *Teach a turtle to walk*. Then: *b-roll — feet pacing out a square on paving stones, filmed from above.* | "Here's the whole idea, and you can do it standing up. Walk forward. Quarter-turn left. Forward. Left again. You've walked a square — and you never once knew your coordinates. You only ever knew two things: where you are, and which way you're facing. Hold onto that. It's the entire trick." |
| 1:10–2:20 | *B-roll: a floor robot with a pen, or a screen turtle tracing lines; Logo-era aesthetic, recreated.* Caption: "Logo, late 1960s". | "That walker-with-a-pen is called a turtle, and it wasn't invented for graphics. It was invented for children. In the late sixties, Seymour Papert and his colleagues built a language called Logo around a little robot turtle — his book *Mindstorms*, from 1980, tells the story. And the idea was an inversion: instead of the computer teaching the child, the child teaches the computer. You explain walking so clearly that a machine can do it. That's all programming has ever been, and today we do it to grow plants." |
| 2:20–3:30 | Clean diagram: a dot, an arrow for heading, angle θ marked; the formula *new position = old + (cos h, sin h) × s* appears one piece at a time. | "Three ingredients. The heading — which way we're facing — call it h. The step — how far one stride goes — call it s. And the turn — how far one swivel rotates us — theta. One formula glues them: the new position is the old position, plus cos of the heading across, sin of the heading down, times the step. If cos and sin have only ever been calculator buttons to you: this is what the buttons were for. They turn 'an angle and a distance' into 'how far across, how far down'. That's their whole job today." |
| 3:30–4:40 | Screen capture: new Godot project, Node2D, attach script. Paste the six-line dot script. F5. A single pale dot. | "Godot, free engine, one node, one script — that's the whole setup for this entire world. We draw a single circle first. Run it. One dot. That dot is the pen touching the paper, and honestly, this is the hardest step of the episode — everything after this is downhill." |
| 4:40–6:30 | Live code: the command loop, `commands := "FFF"`, run — a vertical line climbs. Highlight `-PI / 2`. | "Now the walker. We read a string one letter at a time, and every F moves the pen one step along the heading. Three Fs — run it — a line, three steps tall. One confession before anyone gets ambushed by it: screens count the y-axis downward. Row zero is the top row. So 'up' is negative. Every 2D engine does this. You've now met it once, politely, and it will never surprise you again." |
| 6:30–8:30 | Live code: add `+` and `-` cases, `TURN_DEG := 90.0`, commands `"F+F+F+F"`. Run — a square. Then deliberately flip a sign and run: a staircase. Fix it. | "Turns change the heading and nothing else — plus for left, minus for right, ninety degrees each. Walk, turn, walk, turn — and there's the square you paced in the park. Notice the little ritual at the top: we write degrees, because humans think in degrees, and the code converts to radians once, at the border, because engines think in radians. And look — if you flip one sign you get a staircase instead of a square. That's not failure, that's the computer asking which way you meant by 'left'. Answer it and move on." |
| 8:30–10:30 | Live drive: `TURN_DEG := 60.0`, the zigzag string; then `90.0` and `"++FF+F"` — the letter L. Pause on it. | "Now you drive. Sixty-degree turns, doubled at the corners so the heading swings past vertical — a zigzag climbs the screen. Then this one: plus plus, F F, plus, F. Read it out loud before you run it. The turtle starts facing up, so two lefts spin it to face down, two steps draw the tall stroke, one more left points it across the screen, one step for the foot… it's an L. You can spell. Pause here and write your initials — genuinely, pause. Lopsided letters count. Lopsided means the pen obeyed you." |
| 10:30–11:20 | The stop-here card, full screen: "You can stop here. It counts." over the viewer-style initials. | "And you can stop here. I want to say that properly, because this course means it: initials drawn by a walking pen is the entire foundation of this world, and if you close the laptop now, you finished. Everything from here is bonus, and it will still be here tomorrow. Nothing in this classroom expires." |
| 11:20–13:30 | Live code: the bookmark cases `[` and `]`; then paste the sprig string; run. The fern sprig appears. Slow zoom. | "For the curious: the fourth command. A fern is a stem that pauses, grows a side branch, and carries on as if nothing happened. So we give the pen a bookmark. Open bracket: remember where I am and where I'm facing. Close bracket: go back there. Bookmarks stack — a branch can bookmark inside a branch — so the pen keeps a little pile of them. And now this string — stem, stem, branch with two leaflets, mirror it, more stem, canopy — run it… there's the fern from the cold open. Walk, turn left, turn right, bookmark. Four commands. The only thing wrong with it is that a human typed every letter — and that's next episode's whole subject." |
| 13:30–13:45 | *B-roll: the sprig re-drawing on loop.* | "The string wrote the plant. Next time, the string writes itself." |

### End card (13:45–14:00)

On screen: three panels — the dot, the initials, the sprig — then one beat
of the real game: a shy flower at a forest's edge, standing on root-legs.

> Spoken: "What exists now: a pen you can talk to, and a fern it can walk.
> Next episode, one rewrite rule grows the whole plant on its own. And if
> you're wondering where this is headed — in *An Isolate Grows Roots*, the
> game this world comes from, every root Florence stands on starts life as
> exactly this kind of string. See you there."

---

## E11 · The grammar of plants

**Companion lesson:** [lesson-2-the-grammar-of-plants.md](lesson-2-the-grammar-of-plants.md)
**Starter:** [starter/lsystem.gd](starter/lsystem.gd)

### Cold open (0:00–0:20)

On screen: an empty dark window. Then a full branching plant appears —
generation 4, feathery, leaning — held for a breath. No logo.

> Spoken: "Nobody drew this plant. It's one letter, and one rule, applied
> four times. Let me show you."

### Beats

| Time | On screen | Spoken |
|---|---|---|
| 0:20–1:20 | *B-roll: real time-lapse footage of a seedling — every tip moving at once.* | "Watch how a plant actually grows. It doesn't draw itself top to bottom like a pen would. Every growing tip grows at the same time — the stem lengthens while every bud on it opens, while every bud on those opens. Growth isn't a line being extended. It's an edit, applied everywhere at once, to a structure that already exists. Hold that thought, because today we take it literally." |
| 1:20–2:40 | Text on screen: "A → AB   B → A". The words rewrite themselves, generation by generation, letters cascading. | "Here's the literal version. Describe the plant as a sentence. Growth is a rule: wherever you see this letter, replace it with this phrase — every letter, all at once. Each pass is called a generation. This idea has a name and a birthday: L-systems, for Aristid Lindenmayer, a botanist, who published it in 1968 to describe how simple filament-shaped organisms develop, cell by cell. The all-at-once part was the point. Cells don't queue politely to divide. Biology is parallel, so the grammar is too." |
| 2:40–4:10 | Live code: the ten-line rewriter, toy rules, print. Output panel fills: A, AB, ABA, ABAAB, ABAABABA… lengths highlighted: 1, 2, 3, 5, 8, 13. | "Ten lines of code, no drawing yet. A becomes AB, B becomes A, print each generation. Run it. Now — don't look at the letters, look at the lengths. One, two, three, five, eight, thirteen. Each one is the sum of the previous two. Those are the Fibonacci numbers, and nobody invited them — they walked in out of a two-line grammar. If you took world 2, you've seen this family before, counting sunflower spirals. They do get around." |
| 4:10–5:30 | The plant rules appear, styled like a specimen label: ω: X · X → F+[[X]−X]−F[−FX]+X · F → FF · θ = 25°. | "Now the star of the episode. The axiom — the starting sentence — is one letter: X. Two rules. X becomes this little architecture — F's, turns, brackets, and five new X's. And F becomes FF. Read it as biology: X is a bud, a plan, invisible. F is finished stem. Every generation, buds unfold into stem-and-more-buds, and stems thicken by doubling. The plus, minus, and brackets? No rule — so they pass through unchanged, like punctuation. They're not for the grammar. They're for the pen that reads it later." |
| 5:30–6:40 | Live code: swap the constants, print lengths only: 18 … 89 … 379 … 1551. | "Feed it in. Generation one: eighteen symbols. Two: eighty-nine. Three: three hundred seventy-nine. Four: one thousand five hundred and fifty-one. Roughly quadrupling every pass — each X unfolds into eighteen symbols carrying four new X's. You were never going to type this. That's the entire reason this episode exists: the rewriter is a machine for typing what no one should." |
| 6:40–8:20 | Live code: the walker with `[` and `]`; hardcoded `"F[+F][-F]F"`. Run: a sapling with two arms. Annotate the bookmark pile as it pushes and pops. | "The pen needs one upgrade before it can read plant. Lesson one viewers have met it: the bookmark. Open bracket — remember position and heading. Close bracket — return there. They stack, like a pile of bookmarks, so a branch can branch. Watch this hand-written sentence: stem, bookmark, left arm, return, bookmark, right arm, return, more stem. The stem carries on as if the arms never happened. That 'as if nothing happened' is the bookmark earning its keep." |
| 8:20–10:40 | Live code: grower and walker joined — the full starter. Run at GENERATIONS = 1, then 2, then 3, then 4. Hold on 4. | "Now connect the two machines — the grower writes the sentence, the walker draws it. Neither is clever. That's the beauty. Generation one: three strokes and a kink. An unpromising twig — the buds are invisible, remember, they're plans, not wood. Generation two: a sapling, and the twig is inside it, thickened. Three: unmistakably a plant, leaning — it leans on purpose, the rule isn't symmetric and neither are plants. Four… there it is. The classic bracketed plant, the showpiece of a wonderful free book called *The Algorithmic Beauty of Plants* — link below, it costs nothing and it's full of these. One letter. Two rules. A plant." |
| 10:40–11:20 | Stop-here card over the generation-4 plant: "You can stop here. It counts." | "You can stop here — generation four on screen is the whole promise of this episode, kept. What follows is for gardeners who want no two plants alike, and it will wait for you." |
| 11:20–13:20 | Live code: rules become lists; `pick_random()`. Run five times, five different plants side by side in a strip. | "One more idea, straight from that book, section 1.7: stochastic L-systems. Real plants share a grammar, not a blueprint — same species, no two ferns match. So: give a letter several replacements, and roll a die every time you rewrite it. The code change is honestly this small — the rule becomes a list, and the rewriter picks one at random. Now run, and run again, and again. Tall and sparse. Squat and bushy. One that outgrew its pot. Same grammar, different dice — sibling plants. This is how a game fills every garden in a forest without an artist drawing a single plant." |
| 13:20–13:45 | *B-roll: a slow pan across a strip of a dozen generated plants, all different.* | "A forest of individuals, from one rule and a die. Next episode, we make it grow — and make it refuse to be rushed." |

### End card (13:45–14:00)

On screen: the generation-4 plant flips upside-down and becomes a root
system; beside it, the real game's shy flower, standing on root-legs.

> Spoken: "What exists now: a plant nobody drew, from one rewrite rule.
> Next episode it grows in real time, one deliberate turn at a time.
> Because in *An Isolate Grows Roots*, Florence's root-legs are exactly
> this grammar — grown live, while you play. Point a plant downwards and
> it becomes a root. See you there."

---

## E12 · One turn at a time

**Companion lesson:** [lesson-3-one-turn-at-a-time.md](lesson-3-one-turn-at-a-time.md)
**Starter:** [starter/one_turn.gd](starter/one_turn.gd)

### Cold open (0:00–0:20)

On screen: a pale seed at the top of a dark window. A click — roots surge
downward and settle. Another click — another surge. A third click lands
mid-surge: a soft ring blooms under the cursor, fades, and the roots do not
hurry. No logo.

> Spoken: "This root grows one turn at a time. And when I click too soon —
> it says no. Politely. That refusal is today's lesson."

### Beats

| Time | On screen | Spoken |
|---|---|---|
| 0:20–1:30 | *B-roll: a cat stretching, slow-motion; then a plain loading bar filling at constant speed. Cut between them twice.* | "Two movements. A cat stretching: fast, then slower, slower, settling. A loading bar: constant, metronomic, dead. The difference isn't what moves — it's how the speed changes. Constant speed is the one thing living movement never does. Animators have a word for shaping speed over time: easing. And today easing is the difference between a progress bar and a living thing." |
| 1:30–2:50 | The formula builds on screen: e(t) = 1 − (1 − t)³, next to a graph of linear vs ease-out cubic. A dot rides each curve. | "The whole episode's mathematics fits on one line, from Robert Penner's classic chapter — free online, link below — the chapter that gave games their easing vocabulary. Normalise time: t runs from zero to one across the burst. Linear is e of t equals t — the robot. Ease-out cubic: take the time remaining, one minus t, cube it, and call that the progress remaining. Watch the two dots race: the eased one has covered seven-eighths of the distance at half time, then spends the rest arriving. Starts at full speed, lands with none. Burst, then settling. That's the shape of growth." |
| 2:50–4:30 | Live code: lesson 2's plant, heading flipped to `PI / 2`, start moved to the top. Run: a root system, complete and still. | "Setup first. Take last episode's plant, move the start to the top of the window, and flip the heading to point down the screen — remember, y grows downward, so down is plus. Same grammar, hung from a seed: it's a root system now. And one structural change — instead of drawing while we walk, we record the walk. Every segment into a list. A drawing you can only look at; a recording you can measure, cut, and grow. Run it: the whole root, instantly. Beautiful and lifeless. We'll fix 'instantly'." |
| 4:30–6:10 | Live code: `_shown`, `_process`, the partial-segment draw with the little tip circle. Run: the root unrolls at constant speed over eight seconds. | "Every segment is the same length, so segment i ends at step-times-i-plus-one — the recording comes with a built-in ruler. So: one variable, how many pixels of root are visible, rising in process, and draw only that much — fully grown segments whole, plus a fraction of the one currently growing, with a little dot for the tip. Run. It unrolls, segment by segment, retracing the turtle's own journey. Watch it once admiringly. Then watch it critically: it's a conveyor belt. A plotter. Nothing alive moves like this." |
| 6:10–8:40 | Live code: turns — TURNS = 13, TURN_SECONDS, the click handler, the refusal rings. EASE set to false. Run: click, linear burst; click mid-burst, ring fades. | "Now the game's idea. Growth comes in thirteen bursts — this studio has a thing about thirteens, humour it — one burst per click. And here's the signature: a click during a burst does not queue, does not speed up, does not scold. It draws a small ring where you tapped, the ring fades, and the root keeps its own pace. Look at the code path: one condition — is a turn still running — and the answer is a ring instead of a turn. The tap costs nothing and is seen. Refusal without punishment. An entire game's personality in an if-statement." |
| 8:40–10:10 | Live code: `EASE := true`. Click through several turns. Then toggle back to false, then true again, side-by-side strip if possible. | "One line left — the cube. Ease true. Click… feel that? The burst arrives up front, then settles into stillness, like something exhaling. Toggle it off — quota being filled. On — growth. Off — machinery. On — alive. One line of maths, one minus one-minus-t cubed, is the entire difference. This is why easing is in every animation tool you've ever touched: it's the cheapest life you will ever buy." |
| 10:10–10:50 | Stop-here card over two eased turns playing out: "You can stop here. It counts." | "And you can stop here. Two eased turns of growth on a click, and a polite ring for your impatience — that's the promise kept. What you have running is the signature system of a real game, in a file you understand entirely. The rest is a garden path, not a staircase." |
| 10:50–12:00 | *B-roll: pages of Darwin's 1880 book (darwin-online), engravings of seedling radicles; a hand glueing a tiny card square to a root tip, recreated macro shot.* | "Before the bonus round, one true story, because it's too good to skip. Eighteen-eighty. Charles Darwin and his son Francis glue tiny squares of card to one side of seedling root tips — and the roots bend away from the touch. Interfere with the tip, and the steering stops, even though the bending happens further back. The tip senses; the root behind it obeys. Their book ends with a sentence botanists still quote: the root tip, they wrote, acts like the brain of one of the lower animals. Roots really do steer. It's measured. It's free to read. So let's give our root something to sense." |
| 12:00–14:00 | Live code: the moisture variation — first click plants a soft dot of "water", `lerp_angle` pull, re-walk. Run: the whole root system leans and curls toward the click. Try PULL 0.02, then 0.15. | "We'll call the pointer 'moisture' — water being a thing real roots care about. First click plants the water. Then, during the walk, every step surrenders five percent of the angle between where it was heading and where the water is — that's lerp-angle doing quiet work. Run it. Click near a corner… and the same grammar arrives bent. Branches that would have grown away curl around like they've heard something. Two percent is a hint. Fifteen is open thirst. And the weekend project, for the strong: make the moisture follow the pointer live, steering only the not-yet-grown future — the past must never rewrite itself. Roots don't un-grow. Neither should yours." |
| 14:00–14:15 | *B-roll: the finished root growing turn by turn, one last time, uninterrupted.* | "A root that grows when asked, rests when done, and declines when hurried. That's not a loading screen. That's a character." |

### End card (14:15–14:30)

On screen: the eased root beside footage of the real game — a shy flower at
the forest's edge, root-legs extending one turn at a time, a tap refused
with a gentle ring.

> Spoken: "What exists now: growth that bursts, rests, and refuses to be
> hurried. Florence's root-legs are this exact system, drawn live — in *An
> Isolate Grows Roots*, the progress bar is alive, and patience is the
> mechanic. Next episode we leave the forest for the ocean, and find out
> why the deep is dark — it's one equation. Bring a torch."
