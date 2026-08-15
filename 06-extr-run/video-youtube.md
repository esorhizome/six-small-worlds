# World 6 · EXTR, run! — YouTube scripts (E16–E18)

*Three episodes, one per lesson, 13–15 minutes of speech each. Format per
STYLE: cold open with the finished visual and no logo, beats table
(timecode · on screen · spoken), B-roll cues in italics, end card in the last
15 seconds. Every episode description links: this repo → the lesson file →
the sources, pinned.*

---

## E16 · Speed, ramps, fairness

**Cold open (0:00–0:20).** *Game view: the finished Lesson 1 scene — a cube
sprinting into the distance, speed readout climbing, a green line reaching
ahead of it like a headlight.* One spoken line:

> "This little line is a promise. At this speed, the player is owed three
> metres of warning — and in the next fourteen minutes, we're going to prove
> it."

### Beats

| Time | On screen | Spoken |
|---|---|---|
| 0:00–0:20 | The finished scene, readout climbing, green line stretching. *B-roll: slow dolly alongside the running cube.* | (Cold open line, above.) |
| 0:20–1:05 | Whiteboard card: "World 6 · EXTR, run! — motion that feels kind". The three-lesson map. | "Welcome to World 6 — the last world, and the first one that moves *you*. This mini-series builds an endless runner core with no meanness in it: today, speed and fairness. Next time, lane changes with feel. Then, difficulty that never punishes. As always: there's a marked stop-here point, and stopping there counts as finishing." |
| 1:05–2:30 | *B-roll: a street corner; someone turns their head toward an off-screen call. Freeze on the moment between.* | "Stand somewhere quiet and have a friend call your name. There's a slice of time between the sound and your head turning. It's brief. It's human. And no amount of practice deletes it. Every player who ever touches your game brings that slice with them. So here's the question a runner has to answer: when the screen is rushing forward, how much road does a person *need* between 'I can see it' and 'it has arrived'? That's not a mood. That's a length. In metres. And it grows with speed." |
| 2:30–3:50 | Maths card: v = v₀ + a·t, each symbol labelled in words. | "Three symbols today, that's the whole budget. v — speed, metres per second. a — how much speed grows each second. t — seconds since the run began. The formula reads: today's speed is the starting speed, plus the per-second gain times the seconds that have passed. That's motion with constant acceleration — it's in OpenStax College Physics, free, link below. And v-nought isn't a fourth symbol, by the way. It's the same v with a timestamp: the speed when the run began." |
| 3:50–5:00 | Unity: new project, cube, new script `RunnerSpeed`. Type the six-line version. Press Play — the cube sails away. | "Empty scene. One cube. One script. We move forward a little every frame, scaled by delta time, so six metres per second means the same thing on every machine. Play — and it runs. Forever. If your cube has sailed off into the void: perfect. Sailing means it works. Select it and watch the Z position climb in the Inspector." |
| 5:00–6:10 | Add `_acceleration` and `_runTime`; the formula line typed on screen, then Play. *B-roll: Inspector numbers ticking.* | "Now the ramp — and look at this: the formula goes in almost verbatim. Speed equals start speed plus acceleration times run time. One line of physics, one line of code. Play again. Same cube, but now it pulls away with growing urgency. Six metres a second… seven… nine… and it will not stop. Which is a problem, and not a small one." |
| 6:10–7:10 | Add `_maxSpeed` and `Mathf.Min`. Graph overlay: a ramp meeting a ceiling. | "Here's why every real runner caps its speed. The warning distance we owe the player grows with speed — forever. Eventually it's longer than anything a screen can show, and no level designer alive can honour it. So: Mathf.Min. The ramp, or the ceiling, whichever is smaller. With our defaults, fifteen seconds of climb, then a civilised twelve metres per second, for the rest of time. A start, a slope, a cap — that's the speed architecture of the whole genre." |
| 7:10–8:20 | Add `OnGUI`; the readout appears, counts 6.0 → 12.0. | "A system you can read is a system you can trust, so let's make it say the number out loud. OnGUI — no setup, no packages, one label. Play. Watch the corner: six point oh, six point four, seven point one… and it parks at twelve. You are watching the equation happen, one frame at a time. Honestly, this readout is half the debugging you'll ever need in this world." |
| 8:20–10:00 | Card: "180–250 ms — simple visual reaction (Kosinski 2008, review)". *B-roll: a thumb hovering over a phone screen.* | "Now the human. There's a long-standing free review by Robert Kosinski at Clemson that gathers decades of measured reaction times. For a simple visual signal — see the thing, respond — laboratory results sit roughly between a hundred and eighty and two hundred and fifty milliseconds. Laboratories are kind places. Buses are not. Sunlight is not. So we design at the cautious end: a quarter of a second, as a floor. And because the phone itself spends time — the touch screen, the display — we add a small device margin on top. That margin isn't a measurement, it's an allowance. It's tunable. It's ours." |
| 10:00–11:30 | Maths card: warning distance = v × t_react. Then: the gizmo code, green and yellow segments explained. | "So here's the rule this entire world stands on. The warning distance you owe the player equals current speed times their reaction time. We leave 'warning distance' written as words — the words are the point. It's a debt. And debts should be visible, so we draw it: OnDrawGizmos, a green line for the human share, a yellow sliver for the device margin, reaching out in front of the runner, recomputed every frame." |
| 11:30–12:40 | Play. Split screen: readout and the line growing together; the moment the ramp caps. *B-roll: close-up of the line settling at 3.0 m.* | "Play, and watch both at once. The speed climbs — the line stretches. Speed climbs, line stretches. And then the ramp meets the ceiling, and the green line parks at exactly three metres. Twelve metres per second, times a quarter of a second: three metres of sight, owed, minimum. That line is now a contract. Any obstacle spawner we ever write must place things beyond it — not because it's polite, but because an inequality says so." |
| 12:40–13:30 | The stop-here card. Then quick flashes: track scrolling toward a still player; a mid-air jump with a longer line. | "And you can stop here. A ramp, a ceiling, a readout, and an honest gizmo — that's the lesson, complete. If you're still hungry: real runners often keep the player still and scroll the *world* — the maths doesn't change, it's all relative speed. And here's a question to sleep on: mid-jump, a player can't dodge. Should the owed distance grow while they're airborne?" |
| 13:30–13:45 | *B-roll: EXTR, run! dev footage — the small alien mid-run, a distraction ahead, plenty of road between them.* | "In EXTR, run!, obstacles are called distractions, and the design docs say a distraction is a spark — never a threat. This line is how a game keeps that promise. A spark you can see coming is a delight. A spark you can't is an ambush." |
| 13:45–14:00 | End card. | (End card, below.) |

**End card (13:45–14:00).**
- **What exists now:** a runner speed system that is provably fair — ramp,
  ceiling, readout, and the player's reaction time drawn in the air.
- **What the next episode grows:** the same cube learns to *dance* — one lane
  change, three personalities, switched live in the Inspector.
- **One breath of the game:** "Every distraction in EXTR, run! is placed beyond
  that green line. Kindness, as an inequality."

---

## E17 · Lane changes that feel good

**Cold open (0:00–0:20).** *Game view: the cube performing lane changes while
the Mode dropdown is flipped live — robotic, buttery, eager, in sequence.* One
spoken line:

> "Same cube. Same distance. Same quarter of a second. Three completely
> different personalities — and the only thing changing is one dropdown."

### Beats

| Time | On screen | Spoken |
|---|---|---|
| 0:00–0:20 | Mode dropdown flipped mid-play; the three feels back to back. *B-roll: extreme slow motion of each dodge.* | (Cold open line, above.) |
| 0:20–1:00 | Episode card: "E17 · Lane changes that feel good". | "Last time we made speed fair. Today we make movement *feel* like something. This is the episode where game feel stops being a mystery and becomes a formula you can point at — three of them, actually, each one line long. Stop-here point included, as always." |
| 1:00–2:20 | *B-roll: a train easing into a platform; a hand sliding a book across a table; a lift arriving.* | "Watch a train arrive. It doesn't hold one speed and then switch off — it eases, sheds pace, settles. Slide a book across a table: your arm starts it gently and lands it gently without being asked. Every moving thing you've ever watched spends part of its journey speeding up and part slowing down. A computer does neither. Tell it 'be thirty percent of the way there at thirty percent of the time' and it obeys — with perfect, eerie indifference. Your eye catches it instantly, even when you can't name it. Today we name it." |
| 2:20–3:30 | Maths card: t = progress, 0 to 1. Then: position = from + (to − from) × t. | "One new symbol this episode — one. t is progress through a single move: zero at departure, one at arrival. Not seconds — a fraction of the journey. And here is lerp, taught honestly: position equals where you started, plus t's worth of the gap. At t equals nought-point-two-five, you are a quarter of the way there. That's it. That is the entire secret of linear interpolation — there isn't any more to it." |
| 3:30–4:40 | Unity: cube, `LaneMover` script, the blunt version. Play: teleporting between lanes. | "Build time. A lane is a number — minus one, zero, plus one — times a width. Keys change the number; the cube's x position follows it. Play. Arrow keys. And it… teleports. It works, and it feels terrible. Keep that feeling — it's the 'before' photo. If your cube is snapping between three spots, everything is wired; snapping means the lanes exist and the system has no opinion about time yet." |
| 4:40–6:00 | Add duration, from, to, elapsed; the honest lerp. Play: sliding, constant pace. Caption: "linear = robotic". | "Now give the move a duration and track t. Each frame: clamp progress, then from plus gap times t. Play — and it slides. Better! And also… off, somehow. It moves like a filing cabinet drawer: constant pace, dead stop. Here's the one sentence this whole episode exists to hand you: **linear motion reads as robotic because real things accelerate.** Write that on a sticky note. It explains half the 'cheap-feeling' games you've ever played." |
| 6:00–7:20 | Maths card: t′ = 3t² − 2t³. Graph drawn slowly: the S-curve. Slope arithmetic on screen. | "The fix isn't more code — it's reshaping time before the movement uses it. Meet smoothstep: three t squared, minus two t cubed. Same start, same end, different middle. And you can audit its manners with school algebra: at t equals zero it's zero, at one it's one, and its slope — six t minus six t squared — is zero at *both* ends. Soft departure and soft landing, guaranteed by the polynomial itself. No trust required." |
| 7:20–8:30 | Maths card: t′ = 1 − (1 − t)³. Graph: steep start, long settle. | "Shape three: Penner's ease-out cubic. One minus, one-minus-t, cubed. At departure its slope is three — *triple* linear — and it glides to zero at arrival. This is the shape of eagerness: leave in a hurry, spend the rest of the trip being graceful about it. Robert Penner's easing chapter is free online and it's the vocabulary every engine borrowed. Link below." |
| 8:30–9:50 | The enum + `Shape()` function typed; Inspector shows the Mode dropdown. Play: flip between all three, several dodges each. | "Now the trick that makes this a *lesson* instead of a lecture: an enum. Three cases in one Shape function — raw t, smoothstep, ease-out — and Unity turns the enum into a dropdown in the Inspector. Which means the feel of your game is now a setting you can flip while it plays. Play. Linear: the filing cabinet. SmoothStep: the same quarter-second, but it breathes. EaseOutCubic: off the line instantly, then a velvet stop. Same distance. Same duration. Three personalities." |
| 9:50–11:00 | Mashing keys mid-move; the cube retargets smoothly. Code close-up: `_fromX = transform.position.x`. | "One quiet, professional detail. Mash a key mid-move. No snap — because every move departs 'from wherever we are', not from the old lane centre. Interruptions stay smooth. Players will never once notice this, and that is exactly the point. Feel is mostly things nobody notices going wrong." |
| 11:00–12:00 | *B-roll: EXTR, run! dev footage — a dodge around a distraction.* Stop-here card. | "So which one is EXTR? She's a chorus of minds in one small, hyperactive body — her dodge answers the thumb *now* and settles like a landing bird. That's the ease-out family. And you can stop here: switching modes in the Inspector mid-play *is* the lesson. You've felt, in your own hands, that game feel is a choice of curve." |
| 12:00–12:45 | Quick flashes: RunnerSpeed added to the same cube — diagonal swerves; a hand-sketched graph of all three curves; `t * t` typed and felt. | "Bonus paths: drop Lesson 1's RunnerSpeed onto the same cube — forward speed and lateral easing compose without argument, and suddenly that diagonal swerve is an endless runner. Sketch the three curves on paper and check yourself against the formulas. And try t-squared — ease-*in* — to feel why runners avoid it: the answer arrives late." |
| 12:45–13:00 | End card. | (End card, below.) |

**End card (12:45–13:00).**
- **What exists now:** one LaneMover, three feels, switchable mid-play — and
  the sentence that explains them: linear reads as robotic because real things
  accelerate.
- **What the next episode grows:** the last system — difficulty that rises only
  when the player shows comfort, and randomness that deals instead of rolls.
- **One breath of the game:** "EXTR's lane change ships as an ease-out. A
  chorus of minds, one small body — eager off the line, graceful on arrival."

---

## E18 · Difficulty as comfort

**Cold open (0:00–0:20).** *Unity Console filling with sentences: "Clean run —
opening the door 0.062 wider. dial 0.21 → speed 7.2 m/s, gap 17.1 m".* One
spoken line:

> "This difficulty system has never punished anyone — and it prints the
> receipts to prove it."

### Beats

| Time | On screen | Spoken |
|---|---|---|
| 0:00–0:20 | The Console narrating gentle decisions, line after line. *B-roll: slow push-in on one sentence.* | (Cold open line, above.) |
| 0:20–1:10 | Episode card: "E18 · Difficulty as comfort". Two icons: a clock with a cross through it; a die with a cross through it. | "Final lesson of the course — episode nineteen is something else entirely, and I'll tell you about it at the end. Today we retire two quiet cruelties most runners ship without thinking. One: difficulty that rises on a clock, whether or not you were coping. Two: raw randomness, which is occasionally vicious by pure arithmetic. In their place: a comfort ramp, and a bag you deal from." |
| 1:10–2:40 | *B-roll: a swimming lesson — shallow end, a hand letting go of the rail.* The design-doc quote on screen, highlighted as it's read. | "Picture a swimming teacher with one rule: nobody moves toward the deep end on a schedule. You move when you float without holding the rail — and if a lesson goes badly, you drift back a little. No ceremony. No comment. That's the rule the real game runs on. From the EXTR, run! design documentation — in development, so this text is the game speaking: the difficulty curves 'advance a step only when a level is completed without taking a hit, and settle back a step after a rough one. Difficulty follows demonstrated comfort, not the clock.' In the fiction, EXTR's bosses adjust her route out of curiosity, never judgement. In the systems? About twelve lines of C#. Let's write them." |
| 2:40–4:00 | Flow-channel diagram: skill on one axis, challenge on the other; the channel between "anxiety" and "boredom". Citations card: Csikszentmihalyi 1990 · Chen 2006. | "There's a research frame for why this works. Csikszentmihalyi, 1990, described *flow* — the state where challenge and skill are matched — as a channel between anxiety, too hard for you, and boredom, too gentle. Jenova Chen's MFA thesis, 2006, free online, mapped that channel onto games and argued difficulty should adapt to keep the player inside it. Look at what our rule does: a no-hit run is evidence you're not anxious — step up. A hit is evidence the upper wall is near — step back. The comfort ramp is the flow channel, written as an if-statement." |
| 4:00–5:10 | Unity: cube, `ComfortRamp` script, blunt version. Play; press C, C, C, H; Console prints. | "Build. A dial from zero to one. Two keys: C reports a clean run, H reports a hit — later these come from your game; today they come from your fingers. Every step the same size, direction chosen by the report. Play, click the Game view so it hears the keyboard, and tap: point-one-five… point-two… and H walks it politely back. The house rule is already alive. Everything from here is refinement." |
| 5:10–6:40 | Maths card: step = r × d × (1 − d), "Verhulst, 1838". The S-curve drawn; step sizes printed on screen as C is tapped: 0.045, 0.062, 0.082, 0.103, 0.125, 0.116, 0.093… | "Now the steps get manners. Pierre Verhulst, 1838, proposed this for populations: growth equals rate, times how much there is, times how much room is left. Swap it in — step equals r times d times one-minus-d — and listen to the step sizes as I tap C: small at first, swelling through the middle, shrinking as the ceiling nears. That's the famous S-curve, dealt one clean run at a time. Difficulty that *saturates* instead of exploding. And one honest footnote: at exactly zero or one, the step is zero — a parked dial can never move — so we keep the dial strictly inside with a small floor and ceiling." |
| 6:40–8:00 | The final script: dial drives speed (6→12) and gap (20→6); the `Mathf.Max` fairness floor highlighted. | "A dial is only a difficulty system once it drives something. Two lerps — Lesson 2's honest kind: speed climbs from gentle to full as d rises; the gap between obstacles tightens from generous to snug. And then one line I want framed on a wall: the gap may never dip below speed times the reaction budget. Lesson 1's owed sight, inherited as a hard floor. The dial can want whatever it likes — the contract outranks it." |
| 8:00–9:00 | Play: the label on screen, C and H tapped, full sentences printing. Stop-here card. | "Play. Every report prints a full sentence: clean run, door opens zero-point-oh-six wider, dial point-two-one, speed seven-point-two, gap seventeen. Rough run? One settled step back — never a punishment multiplier, never a reset. Read a few aloud. It's oddly moving, a difficulty system with good manners. And you can stop here: a comfort ramp printing its gentle decisions is the finished system, same rule as the shipping game." |
| 9:00–10:30 | Dice versus dealt cards. On-screen arithmetic: 1-in-4 repeat, 1-in-16 triple. *B-roll: a die rolling the same face three times.* | "Bonus round: the other cruelty. Dice have no memory. Four obstacle types, drawn independently: every draw has a one-in-four chance of repeating the last, so one time in sixteen you get a triple — the same demand, three times, wall wall wall. Over a thousand obstacles that's dozens of accidental cruelties, and no tuning fixes it, because the dice can't remember being cruel. Cards can. Once the ace of spades is dealt, it *cannot* come again until the shuffle. Generous games deal; they don't roll." |
| 10:30–12:00 | The ShuffleBag class typed; a bag animation: four tiles in, shuffle, dealt out, refill. Card: "Tetris Guideline 'Random Generator' — the 7-bag (community-documented)". | "So: the shuffle bag. Every obstacle type goes in, the bag is shuffled, you deal until it's empty, refill, repeat. Twenty-five lines, on screen now. This is design lore with a famous pedigree — modern Tetris deals its seven pieces exactly this way, the Guideline's 'Random Generator', the 7-bag, documented lovingly by its community for years. Not academia. Lore. The good kind — tested by a billion games." |
| 12:00–13:00 | On-screen finger-counting proof: streaks stop at 2; any 8 consecutive draws contain a full 4-bag; "for Tetris's seven: twelve". | "And two guarantees come free — you can prove both on your fingers. Streaks stop at two: inside a bag there are no repeats, so the worst case is the last card of one bag matching the first of the next. And nothing droughts: with four types, any eight consecutive draws contain one complete bag, so two copies of the same obstacle are never more than six strangers apart. Run the same arithmetic on Tetris's seven pieces and you get the community's famous twelve. Weighted difficulty? Put three 'hop's and one 'spin' in the bag — the weights are copy counts, and the guarantees scale with them." |
| 13:00–14:00 | *B-roll: everything at once — ramp gizmo, eased dodges, Console decisions, the bag dealing.* The world-6 map, all three lessons ticked. | "Step back and look at what exists. A speed ramp that owes the player sight and pays it, every frame. A dodge that answers the thumb and lands like a bird. A difficulty dial that rises only on demonstrated comfort, settles back without ceremony, saturates by Verhulst instead of exploding. And randomness that deals fairly because it remembers. That's an endless runner core with no fail state and no meanness — and every claim in it traces to a source or to arithmetic you can check on paper. The real game adds one more house rule on top: infinite lives. A stumble pauses the run; it never ends it. Assignments, in EXTR's world, cannot be failed." |
| 14:00–14:45 | *B-roll: EXTR, run! dev footage — the small alien veering, something wonderful growing where she veered.* Then: a store-page silhouette, a calendar. | "Which brings us to next episode — and next episode is not a lesson. For nineteen episodes this studio has been teaching you the insides of its own games, and there's exactly one honest way to end that: we publish one. For real. The store page, the release build, the button, and the first hour after the button. Everything this course taught, pointed at one shipping game. Bring biscuits." |
| 14:45–15:00 | End card. | (End card, below.) |

**End card (14:45–15:00).**
- **What exists now:** a difficulty system that never punishes — comfort-gated,
  logistic-shaped, fair-bagged, and narrating every gentle decision.
- **What the next episode grows:** E19 — not a lesson. The studio publishes,
  for real, with the audience that learned its insides. Stopping counts as
  finishing; so does shipping.
- **One breath of the game:** "EXTR's bosses are curious, not controlling — and
  so is this difficulty curve."

---

*Script text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
