# World 2 · upgrade Biotech — long-course scripts (E04–E06)

*Three episodes, one per lesson. Register: spoken, warmer and shorter-sentenced
than the written lessons. Batch-record all three in one sitting for a
consistent voice. Thumbnails are the payoff visuals themselves — the colony,
the garden grid, the Sierpinski triangle — not a face and an arrow.*

Every episode's description links: this repo → the specific lesson → the
sources. A pinned-comment block sits at the end of each script.

---

## E04 · The sunflower rule

**Lesson:** [lesson-1-the-sunflower-rule.md](lesson-1-the-sunflower-rule.md) ·
**Starter:** [`starter/phyllotaxis.gd`](starter/phyllotaxis.gd) ·
**Runtime target:** ~14 min.

**Have ready before recording:** the finished starter running; the Step 1–5
milestone files each saved separately; a browser tab with Vogel's paper title
visible; the 137.3 / 137.508 / 137.6 variants saved as three scenes.

### Cold open (0:00–0:20)

*Screen: the finished colony, mid-pour, cells streaming in to 2,000. No logo,
no name card, nothing else.*

**Say:** "Two thousand cells, packing themselves perfectly — and the whole
thing is one rule, short enough to say out loud."

### Beats

| Time | On screen | Say |
|---|---|---|
| 0:20–0:55 | Colony paused at full bloom. Small title: *E04 · The sunflower rule*. | "Hello, and welcome back to the workshop. Today we grow that. Not draw it — grow it, cell by cell, in front of us. By the end you'll have a living colony in Godot, built from one rule and about thirty lines. And as always in this course: there's a marked stopping point, and stopping there counts as finishing." |
| 0:55–1:50 | *B-roll: a real sunflower head, slow push-in. Then a pinecone. Then a daisy's eye.* | "First, look at the real thing. The middle of a sunflower. Notice the seeds aren't in rows. They're not in rings either. Your eye picks out spirals — winding out clockwise, and anticlockwise, at the same time, crossing each other. And every seed has its own pocket of space. Nothing's crowded in the middle. Nothing's wasted at the edge. Plants do this without a brain. So it can't be a hard calculation. It has to be a habit." |
| 1:50–2:40 | *B-roll: presenter's hand with a paper arrow on a pin — turn it, step outward, place a coin. Repeat three times.* | "Here's the habit. Turn by a fixed angle. Step a little further out. Place a seed. That's it — that's the entire choreography. Do it once, you've placed one seed. Do it two thousand times, you've made the thing in the opening shot. The plant repeats one dance move, and geometry does all the admin. Two questions decide everything: how far out do we step — and what angle do we turn?" |
| 2:40–3:40 | Whiteboard-style sketch: a disc, cells as equal tiles; the numbers n, r; "area grows like radius²". | "Question one: how far out? Fairness answers it. Say every cell claims the same amount of floor. Then after n cells, the colony needs n cells' worth of floor. But a disc's area grows with the *square* of its radius — double the radius, four times the floor. So if area has to grow like n, radius can only grow like the square root of n. That's the whole mystery of the square root: it's what equal room for everyone looks like from above." |
| 3:40–4:40 | Live Godot: the loop running with 90° instead of the golden angle — four spokes. Then 120° — three spokes. | "Question two: what angle? Let me show you the wrong answer first. Turn ninety degrees per cell — a quarter turn. Four spokes. Empty wedges between them. Because every fourth cell faces exactly the same way. A third of a turn? Three spokes. Any tidy fraction of a turn repeats itself eventually, and repeats are spokes, and spokes are wasted space." |
| 4:40–5:10 | The number 137.507764° large on screen; beneath it: 360° ÷ φ ÷ φ. Caption: *Vogel, 1979*. | "So you want the angle that is worst at repeating. Take a full turn, divide by the golden ratio — and divide by it again. You get about 137.5 degrees. The golden ratio is famously the number fractions approximate worst — the most irrational number, in a precise sense — which is exactly the job here: multiples that never line up, gaps that never form. The model is from a 1979 paper by Helmut Vogel, and it's the standard way to draw a sunflower head to this day." |
| 5:10–5:50 | Live Godot, big font: new project, Node2D, attach script. Type Step 1. Run: one dot. | "Let's build. New project, one Node2D, attach a script. Five lines: find the centre of the window, draw one circle there. Run — one pale dot. That's cell zero. Every great colony starts with someone." |
| 5:50–7:10 | Type Step 2 — constants, the loop. Run: 200 cells at once. Zoom into the constant `GOLDEN_ANGLE_DEG := 137.507764`. | "Now the rule, in code. Four constants — and notice the angle gets a name and all its digits. One line of housekeeping: we think in degrees, Godot draws in radians, so deg-to-rad does the border crossing once. Then the loop. For each cell: angle is n golden angles. Radius is spacing times root n. Turn those into an x and a y with cos and sin, draw a circle there. Run… and there it is. Two hundred cells, spirals both ways, nobody crowded. If yours looks lopsided — you're ninety percent of the way there. Lopsided means it's drawing. Check the angle's digits and run again." |
| 7:10–8:40 | Type Step 3 — `cells` counter, `_process`, `queue_redraw`. Run and let it grow. Cut between 0 s, 5 s, 17 s. | "But a colony that appears finished is a diagram. We want accretion. So: a counter, starting at zero, rising twelve cells a second — delta there keeps it steady whatever the frame rate — and each frame we redraw however many cells the counter has reached. Run it. And now — watch. Each new cell lands in a gap you hadn't noticed was there. Never touching. Never wasteful. Seventeen seconds, two hundred cells, and every single one is placed by the same two lines of maths." |
| 8:40–9:10 | Full-screen card: **You can stop here.** The 200-cell colony resting behind it. | "And here's the line. You can stop here. Two hundred cells bloomed from a rule you can say in one breath — that's the lesson, complete. Everything from here is bonus. No streaks, no homework. The next episode will still make sense. But if you're curious what a held button does to this…" |
| 9:10–10:20 | Type Step 4 — the input check, cap raised to 2,000. Hold SPACE. Cells pour. | "Idle games love a held button, so let's install one. While the mouse or the space bar is down, time runs ten times faster — one multiplier on the growth speed, that's the entire feature. And pouring needs somewhere to pour, so the cap goes up to two thousand. Hold… and it pours like sand into a jar. Here's what I want you to notice: at two hundred cells or at two thousand, the packing never falters. The rule doesn't have a good day or a bad day." |
| 10:20–11:10 | Type Step 5 — two colour constants, the `lerp` line. Run, pour to full. | "Last touch: history, painted. Old cells wear green, young cells wear pale gold, and lerp blends between them by age. Run. Now the rim is always the newest growth — the bloom reads outward, the way it actually grew. That's the finished starter file, byte for byte, in the repo." |
| 11:10–12:40 | Three windows side by side: 137.3°, 137.507764°, 137.6°. *B-roll: slow crossfade between them.* | "Now the experiment that sells the whole thing. Change the angle by two tenths of a degree — 137.3. Run. Spiral arms. Real gaps. Try 137.6 — different arms, same disease. Back to 137.507764 — perfection returns. This three-way comparison is a classic; Vogel's paper is built around it, and The Algorithmic Beauty of Plants — free PDF, link below — reprints it. A tenth of a degree is the difference between a sunflower and a broken fan. Nature isn't being approximately clever here. It's being exactly clever." |
| 12:40–13:20 | The colony pouring; quick cuts of the constants being tuned: SPACING, TICKS_PER_SECOND. | "Step back and look at what you actually built: no sprites, no textures, no downloads. A number n became a position, a colour, a moment in time. That's the whole craft this series teaches — data becoming picture. Games ship on this. One of mine ships on nothing else." |
| 13:20–13:45 | Three questions on screen, presenter reads them. Answers not shown. | "Before the end card, three questions to carry: One — which grows faster, the cell count or the colony's radius? Two — why does exactly ninety degrees make four spokes? Three — what does the spacing constant control, and what does it *not* control? Answers are at the bottom of the written lesson, politely hidden." |
| 13:45–14:00 | End card: left, the finished colony pouring; right, a rose curve beginning to trace. Repo link. | "So: what exists now — a colony that grows by one rule, with a pour button. Next episode, one equation with one dial grows a garden of twenty-six different flowers. And one breath about the studio's own game: *upgrade Biotech* draws every single thing you'll ever see in it — twenty-six flowers, sixty-four pages, fifty-two habitats, a hundred and four finds — from rules the size of today's. There is not one image file in the whole project. See you in the garden." |

### Pinned comment / description block

- Written lesson: `02-upgrade-biotech/lesson-1-the-sunflower-rule.md`
- Starter code: `02-upgrade-biotech/starter/phyllotaxis.gd`
- Sources: Vogel 1979, *Mathematical Biosciences* 44:179–189 · Prusinkiewicz &
  Lindenmayer, *The Algorithmic Beauty of Plants* ch. 4 (free PDF,
  algorithmicbotany.org)
- House rule: the stop-here line is at 8:40. Stopping there counts as
  finishing.

---

## E05 · A garden from an equation

**Lesson:** [lesson-2-a-garden-from-an-equation.md](lesson-2-a-garden-from-an-equation.md) ·
**Starters:** [`starter/rose_garden.gd`](starter/rose_garden.gd) ·
[`starter/times_table.gd`](starter/times_table.gd) ·
**Runtime target:** ~15 min.

**Have ready before recording:** both starters running; the single-rose Step 1
file with K variants; the times-table build at each milestone; footage of the
real game's Garden tab (thumbnails spinning) for the end card.

### Cold open (0:00–0:20)

*Screen: the 26-flower grid blooming in, letter by letter — then a hard cut to
the cardioid assembling from straight chords. No logo.*

**Say:** "Twenty-six different flowers from one equation — and then a heart,
made entirely of straight lines."

### Beats

| Time | On screen | Say |
|---|---|---|
| 0:20–0:50 | The garden grid, paused. Title: *E05 · A garden from an equation*. | "Welcome back. Two small machines today. Machine one grows a whole garden from a single equation with a single dial. Machine two has no curves in it at all — a circle of dots, some multiplication, and a shape nobody asked for. There's a resting point between them, and resting there counts as finishing." |
| 0:50–1:45 | Animation: a clock hand sweeping; a pen at its tip; the pen's distance breathing in and out, leaving a petal trail. | "Machine one, the intuition first. Put a pen on the end of a clock hand. If the pen keeps a fixed distance while the hand sweeps, you get a circle — that was episode one of this course. Now let the distance *breathe*. Out, in, out, in, like a tide, while the hand turns. Every swell of distance bulges the pen away from the centre — that's a petal. Every shrink pulls it back through the middle. One number decides the whole flower: how many times the distance breathes per lap." |
| 1:45–2:30 | *B-roll: MacTutor page for Grandi; the word RHODONEA large.* | "People met these curves early. In the 1720s an Italian mathematician, Guido Grandi, studied the family and named it — rhodonea. The roses. His book *Flores geometrici*, 1728, is the historical root of everything we draw today. Three hundred years later they still look like the future." |
| 2:30–3:20 | Maths card: r = cos(k × θ). Each symbol labelled in words. | "The equation, small. r equals cos of k times theta. Theta — the pen's angle, you know it from last episode. r — the pen's distance. And k, today's only new symbol: how many times the distance breathes per lap. Cosine is the breathing; k is the pace. That's the entire equation. Everything else today is watching k." |
| 3:20–4:00 | Card: **odd k → k petals · even k → 2k petals**. | "One rule to state before we build, because it looks like a misprint: if k is odd, you get k petals. If k is even, you get *twice* k. Five gives five; four gives eight. Why? When k is odd, the second half of the lap retraces the first — same petals again. When k is even, the two halves land apart, and every petal arrives twice over. Don't take my word — we're about to count." |
| 4:00–5:20 | Live Godot, big font: Step 1 typed — the single rose, K = 4. Run: eight petals. Count them on screen with dots. | "Build. One Node2D, one script. We sample the lap at three hundred and sixty points — for each one: theta runs zero to TAU, which is radians' name for a full turn; r is radius times cos of K theta; convert to x-y with cos and sin; collect the points; draw one polyline through them. Run. Count with me — eight petals. K was four. Even k, count doubled, exactly as promised." |
| 5:20–6:00 | Quick cuts: K := 5 (five petals), K := 2 (four), K := 1 (a circle), K := 7 (seven). | "Now play the dial. K is five: five fat petals — odd keeps its count. K is two: four. K is seven: seven. And K is one: a single circle, standing off-centre — the humblest member of the family. Keep that one in mind; it's about to be the letter A." |
| 6:00–7:30 | Step 2 typed: the helper function, the grid loop, the letter labels. Run: 26 labelled flowers. Slow pan across the grid. | "Now the garden. We wrap 'draw a rose' into a helper function so we can say it twenty-six times, and we stamp the grid: k runs one to twenty-six, A to Z, each flower its own hue, each wearing its letter. Run… and pan with me. A is a circle. B has four petals. C has three. Z, at the far end, is a wheel of lace with fifty-two petals. One equation. One dial. Twenty-six citizens. If some of yours look like faint tangles — that's what forty petals at thumbnail size honestly looks like. Make the window bigger and they resolve." |
| 7:30–8:00 | Full-screen card: **You can stop here.** The garden resting behind it. | "And here's today's line. You can stop here — a complete garden from one equation is a full day's magic. Machine two is bonus. But machine two is the one that got me into this…" |
| 8:00–8:50 | Animation: 10 points on a circle numbered 0–9; an arrow from 7 to 4 via "7 × 2 = 14 → 14 mod 10 = 4". | "Machine two needs three things. N points around a circle, numbered from zero. M, a times table. And one operation: mod — clock arithmetic. On a ten-point circle, point seven times two is fourteen — too big — so you keep walking round and land on four. Fourteen mod ten. That's all mod is: the remainder after wrapping. The rule of the machine: every point k draws one straight chord to point k times M, mod N." |
| 8:50–9:40 | Step 3 typed: the ring of 200 dots. Run. | "Stage first: two hundred dots, evenly spaced — TAU times k over N does the spacing, and a quarter-turn offset puts point zero at twelve o'clock. Run. A ring of dots. No maths visible yet. It's the moment before the orchestra tunes." |
| 9:40–11:00 | Step 4 typed: chords with M = 2. Run. The cardioid emerges. Slow zoom on the envelope. | "Now the chords. Every point phones its double: k to two-k mod N. Two hundred straight lines. Run. …There's a heart in it. Nobody drew that curve. Every line we drew is straight — the heart is the *envelope*, the shape the crowd of chords leans against. It's called a cardioid, from the Greek for heart, and it has been hiding in the two-times table since arithmetic began. This construction — and the best half hour you can spend on it — is Mathologer's 2015 video on times tables; link below." |
| 11:00–12:30 | Step 5 typed: variables + arrow keys + label. Live play: M=3, M=4, hold RIGHT through lace; N down to 30, up to 400. | "Last step, dials. N and M stop being constants and become variables; arrow keys nudge them and ask for a redraw. Now play. M is three: two lobes — a nephroid, the kidney to the cardioid's heart. M is four: three lobes. The M-times table draws M-minus-one lobes, all the way up — that pattern's in the Mathologer video too. Hold right and travel through families of lace. Drop N to thirty and you can watch single chords obey the rule; push it to four hundred and the envelope sharpens like a lens focusing." |
| 12:30–13:30 | *B-roll: the real game — the Garden tab, 26 rose thumbnails spinning; then an Expedition find card, chords assembling.* | "Now the reveal you may have guessed. The Garden in *upgrade Biotech* is this exact rose family — twenty-six flowers, A to Z, same equation, with one generalisation: the game lets k be a fraction, which buys it in-between flowers that take several laps to close. And the times-table circle? That's the game's Expedition — a hundred and four finds, every one an N and an M. The hundred and four pairs were chosen by measuring how different the figures look, so no two finds are near-twins. Everything you built today is production machinery." |
| 13:30–14:10 | Three questions on screen. | "Three questions to carry. One — how many petals for k equals seven, and for k equals eight? Two — on a ten-point circle with the two-times table, where does point seven send its chord? Three — what did Grandi name this curve family, and in which book? Answers hide at the bottom of the written lesson." |
| 14:10–14:25 | End card: garden left, cardioid centre, a faint Sierpinski triangle beginning to grow on the right. Repo link. | "What exists now: a twenty-six-flower garden and a heart made of straight lines. Next episode, the strangest machine of the series — one row of cells, one byte, and an entire alien habitat grows down the screen. And the breath of the real game: this exact family grows the Garden in *upgrade Biotech*, and the chord circles are its hundred and four Expedition finds. The garden is planted. See you at the loom." |

### Pinned comment / description block

- Written lesson: `02-upgrade-biotech/lesson-2-a-garden-from-an-equation.md`
- Starter code: `02-upgrade-biotech/starter/rose_garden.gd` ·
  `02-upgrade-biotech/starter/times_table.gd`
- Sources: Grandi, *Flores geometrici*, 1728 · MacTutor History of Mathematics
  archive (rhodonea curves; petal-count rule) · Mathologer, "Times Tables,
  Mandelbrot and the Heart of Mathematics", 2015
- House rule: the stop-here line is at 7:30. Stopping there counts as
  finishing.

---

## E06 · Worlds from neighbours

**Lesson:** [lesson-3-worlds-from-neighbours.md](lesson-3-worlds-from-neighbours.md) ·
**Starter:** [`starter/rule90.gd`](starter/rule90.gd) ·
**Runtime target:** ~14 min.

**Have ready before recording:** the starter at RULE 90, 30, 110, 184 saved as
four scenes; the random-seed variant; the eight-row lookup table as a full
graphic; footage of the real game's Atlas tab for the end card.

### Cold open (0:00–0:20)

*Screen: Rule 90 knitting down a black screen from a single cell, halfway to a
full Sierpinski triangle. No logo.*

**Say:** "Everything growing on this screen is one number between zero and two
hundred and fifty-five."

### Beats

| Time | On screen | Say |
|---|---|---|
| 0:20–0:55 | The completed triangle. Title: *E06 · Worlds from neighbours*. | "Welcome back. Today has no trigonometry in it at all. No angles, no sine, no cosine. Today's entire mathematical machinery is a table with eight rows — and from it, we grow textures that fill the screen: first order, then chaos. If you can read a bus timetable, you're qualified. And as ever: there's a marked stopping point, and stopping counts." |
| 0:55–1:50 | *B-roll: close-up of knitting, rows forming; then a woven basket; then frost growing on glass.* | "The intuition is knitting. Every stitch in a new row is decided by the stitches directly above it. You look up, you follow the pattern, you knit. Nobody knits a picture into row forty — the picture *emerges*, because it was implied by the pattern rule all along. Now shrink that idea to its bones: a row of cells, each one on or off. Each new cell looks at exactly three cells above it — upper-left, above, upper-right — and consults a rule. That's the whole machine." |
| 1:50–3:10 | The eight-row table, full screen, built row by row: ■■■→·, ■■·→■, ■·■→·, ■··→■, ·■■→■, ·■·→·, ··■→■, ···→·. | "Here's a rule, in full. A cell can see eight possible things above it — three parents, each on or off, two times two times two. So the rule is a table with eight rows: for each sight, be on or be off. Read the answers down the right-hand column: off, on, off, on, on, off, on, off. Now read that as binary: zero-one-zero-one-one-zero-one-zero. That's the number ninety. The table *is* the number. The number *is* the world. Eight rows, two choices each — two hundred and fifty-six possible universes, numbered 0 to 255. That numbering scheme is from Stephen Wolfram's 1983 paper, and the whole field calls these elementary cellular automata." |
| 3:10–3:40 | The table again, outer columns highlighted. | "One shortcut hiding in rule ninety, for the programmers: look only at the two *outer* parents. The new cell is on exactly when one — and only one — of them is on. One or the other but not both. That operation is XOR. Rule ninety is XOR wearing a byte." |
| 3:40–4:30 | Live Godot, big font: Step 1 typed. Run: one square, top centre. | "Build. One Node2D, one script. A row of cells the width of the window — a packed integer array, all zeroes — and we light a single cell in the middle. Draw each on-cell as a small square. Run: one square, top centre. That's our seed. Last episode a seed was a dot in a spiral; today it's the ancestor of everything below it." |
| 4:30–6:10 | Step 2 typed slowly; zoom on `left * 4 + mid * 2 + right` and `(RULE >> pattern) & 1`. Run: the full Sierpinski appears at once. | "Now the loom. For every new cell: gather three parents — the edges wrap, so the far left and far right are neighbours. Compute the pattern number: left counts four, middle counts two, right counts one. Then this line — RULE shifted right by pattern, AND one — that's 'read bit number *pattern* of the byte'. The lookup table, executed in one line. We build every row from the row before, top of the window to the bottom, and draw the lot. Run. …That is the Sierpinski triangle. A triangle made of three smaller triangles, made of three smaller ones, down to the pixel. Nobody drew a triangle. Eight table rows implied it, and your loop worked out the implication a hundred generations deep. If yours leans or tears at one edge — celebrate first, because a leaning triangle means the loom works — then check the four-two-one order." |
| 6:10–6:50 | Slow zoom into the triangle's self-similar corners. | "Mathematicians knew this shape a century before computers — and here it is, assembling itself out of local decisions. No cell knows about the triangle. Each one knows three parents and one byte. The pattern is nobody's plan. That idea — global structure from local rules — is most of what the word 'emergence' means, and you now have a working model of it." |
| 6:50–7:50 | Step 3 typed: rows counter, `_process`. Run: the triangle knits downward over ~5 s. | "One more step, because a texture that appears finished is wallpaper. A counter of visible rows rises twenty rows a second, and the world knits downward. Run — and watch the whole thing. This isn't a loading animation. Downward *is* how the mathematics proceeds — one generation per row. You're watching computation happen at a speed the eye can follow." |
| 7:50–8:20 | Full-screen card: **You can stop here.** The triangle completing behind it. | "Here's the line. You can stop here. Rule ninety has filled your screen from one cell and one byte. Everything after this is bonus — though the bonus is a plot twist." |
| 8:20–9:40 | RULE := 30. Run. Chaos boils down the screen. Split-screen with rule 90. | "Change one line. Rule thirty. Same loom, same seed, four bits' difference in the byte. Run. …Chaos. Not messiness — structured on the left flank, boiling on the right, never repeating. Rule thirty is the famous one: its centre column jumps around so unpredictably it has served as a random-number source. If you want to fall down this well, Wolfram's *A New Kind of Science* is readable free online, all fifteen hundred pages, and rule thirty is its star witness." |
| 9:40–10:40 | RULE := 110 (gliders and scaffolds), then RULE := 184 (traffic bands). Quick cuts. | "Two more universes, quickly. Rule one-ten: scaffolding with little gliders moving through it — this rule has been proven capable, in principle, of any computation at all. A byte that can run programs. And rule one-eight-four: read every on-cell as a car that advances when the space ahead is clear, and you're looking at the standard toy model of traffic — the jams drift backwards while the cars move forwards, which is exactly what your motorway does." |
| 10:40–11:40 | SEED_MODE := "random" with RULE 90: interfering triangles. Caption: *same seed number = same world, every run*. *B-roll: the game's Atlas tab, habitat cards.* | "One more dial: seed the first row with noise instead of one cell, and rule ninety's triangles interfere like rain on a pond. Notice the starter pins the random seed to a fixed number — so this 'random' world is the *same* world every run. That's not laziness; that's what makes a generated world a place instead of static. It's exactly how the Atlas in *upgrade Biotech* works: fifty-two alien habitats, each stored as one rule integer and a seed — every habitat the same place every visit. The fifty-two rules were picked by simulation, so none comes out blank, solid, or a twin of another." |
| 11:40–12:30 | Simple graph: cost curve rising by ×1.15 per level. Caption: *Pecorella, "The Math of Idle Games", GDC*. | "And since this world orbits an idle game, one sentence of its economics before we close: the standard idle-game move is geometric cost growth — each level of an upgrade costs around one-point-one-five times the one before, compounding the way our automaton's rows compound their parents — a pattern Anthony Pecorella's free GDC talks lay out with real published numbers, and the cost curve in *upgrade Biotech* starts at exactly that one-point-one-five. That's the go-deeper thread if the numbers call to you." |
| 12:30–13:10 | Three questions on screen. | "Three questions to carry. One — under rule ninety, a cell sees on-off-on above it: does it light? Two — how many patterns can a cell see, and how many rules exist? Three — why pin the random seed to a fixed number? Answers hide at the bottom of the written lesson." |
| 13:10–13:25 | End card: triangle left, rule 30 right; between them, a small spiral shell beginning to draw. Repo link. | "What exists now: entire worlds grown from neighbours — order from rule ninety, chaos from rule thirty, and a loom that runs all two hundred and fifty-six. The breath of the real game: this exact rule family grows the Atlas in *upgrade Biotech* — fifty-two habitats, each one integer. That's World Two complete: a colony, a garden, a heart, and a wilderness, all from rules you can say aloud. Next episode we leave for the tidepool — two spirals, one shell, and the kindest mechanic in the genre. Stopping counts as finishing. So does this." |

### Pinned comment / description block

- Written lesson: `02-upgrade-biotech/lesson-3-worlds-from-neighbours.md`
- Starter code: `02-upgrade-biotech/starter/rule90.gd`
- Sources: Wolfram 1983, *Reviews of Modern Physics* 55:601–644 · Wolfram,
  *A New Kind of Science* (free at wolframscience.com) · Pecorella, "The Math
  of Idle Games" (GDC, free on YouTube)
- House rule: the stop-here line is at 7:50. Stopping there counts as
  finishing.

---

*Script text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
