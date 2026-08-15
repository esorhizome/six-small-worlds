# World 3 · Tidepool Keeper — short-form shot lists (4 clips)

*Format per [STYLE](../STYLE.md) and the
[short-form course map](../00-course/shortform-tiktok.md): four clips —
Hook, Build, Twist, Bridge — one idea each, text-on-screen lines ≤ 6 words,
captions always on, loop-closed where marked. Ladder positions: Hook #4,
Build #12, Twist #16, Bridge #21. Only the Bridge carries a CTA. Sound is the
studio's own procedural audio throughout — soft chimes on visit-dots, a low
tide swell under the waves. No strobing edits; the reduce-motion ethos
applies to cuts too.*

---

## Clip 1 · Hook — "Your game plays while you sleep"

**Hook line (≤ 8 words):** Your game plays while you sleep
**Length:** ~18 s · **Source footage:** [starter/visits.gd](starter/visits.gd) running

| Seconds | Shot | Text on screen |
|---|---|---|
| 0.0–1.5 | Black. One console line types itself: `Day 01 · 02:13 · a visitor came at high water` | Your game plays while you sleep |
| 1.5–6.0 | Full guestbook cascade pours down the screen, slightly sped up, chimes tick faster | I left for a month |
| 6.0–12.0 | Cut to the timeline view: teal tide wave breathing, visit dots popping on one by one along it | 120 visitors came anyway |
| 12.0–16.0 | Hold the finished week; the wave keeps moving, dots glint | No streaks. No guilt. |
| 16.0–18.0 | Quick flash of the one formula, then the empty timeline from frame one — loop closes | One line of maths |

**Caption:** A tidepool that welcomes guests while you're away — uncapped,
nothing expires. The maths is called a Poisson process, and it fits in one
line.
**Hashtags:** #gamedev #godot #cozygames #indiedev #mathisbeautiful
**CTA:** none — the loop is the CTA.
**Loop note:** last frame = first frame (empty timeline), so the cascade
restarts seamlessly.

---

## Clip 2 · Build — "Simulate a month of visitors in 1 second"

**Hook line (≤ 8 words):** Simulate a month of visitors in 1 second
**Length:** 60 s · **Source:** live screen-recording, big font, one rehearsed
take, ends running. Recurring reassurance line included per the course map.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0.0–3.0 | The finished result first: guestbook cascade, one second of it | A month. One second. |
| 3.0–10.0 | Editor, big font: type `var u := maxf(randf(), 0.0000001)` | Step 1: one random number |
| 10.0–18.0 | Type `-log(u)` around it; underline the minus sign | Step 2: take its log |
| 18.0–26.0 | Complete the line: `/ rate_per_hour`; the gap formula glows briefly | Step 3: divide by rate |
| 26.0–38.0 | The while loop: `t += ...` accumulating until 30 days; arrow follows t growing | Step 4: add gaps up |
| 38.0–50.0 | The print line with Day/hour/minute formatting; finger hovers, presses run | Step 5: print the month |
| 50.0–60.0 | The month pours down the Output panel in real time; hold on the final line `Nothing expired while you were gone.` | no maths degree needed |

**Caption:** Five steps: random fraction → natural log → divide by the rate →
add the gaps up → print. That's a Poisson process — the honest maths of
"visitors at an average rate".
**Hashtags:** #godot #gamedev #codewithme #learntocode
**CTA:** none — the clip ends running, which is the argument.
**Note:** every keystroke shown lands in the final file; no magic edits
between shots.

---

## Clip 3 · Twist — "Two spirals. Only one is alive."

**Hook line (≤ 8 words):** Two spirals. Only one is alive.
**Length:** ~30 s · **Source:** [starter/spirals.gd](starter/spirals.gd);
the one number changed is `LOG_GROWTH`. Invite duets/stitches.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0.0–2.5 | Both spirals side by side on dark water | Two spirals. One is alive. |
| 2.5–8.0 | Zoom to the right spiral; cursor highlights `LOG_GROWTH := 0.11` | This number is its pace |
| 8.0–13.0 | Change to `0.0`, run: the spiral collapses into a circle | Zero: a circle forever |
| 13.0–19.0 | Change to `0.3064` (and TURNS to 2), run: the curve blasts off screen | 1.618: the golden myth |
| 19.0–26.0 | Change to `0.18`, run: a cosy, believable shell settles in | Real shells grow at 1.33 |
| 26.0–30.0 | Three results tiled; then back to frame one — loop closes | What's your number? |

**Caption:** One constant, four worlds. Real nautilus shells measure about
1.33 growth per quarter turn (Falbo, 2005) — not the poster's 1.618. Change
the number, post what you get.
**Hashtags:** #maths #spiral #nautilus #godot #generativeart
**CTA:** none — the duet/stitch invitation ("what's your number?") is the
engagement, not a link.
**Loop note:** the tiled ending cuts back to the opening two-spiral frame.

---

## Clip 4 · Bridge — "The kindest mechanic in my tidepool"

**Hook line (≤ 8 words):** The kindest mechanic in my tidepool
**Length:** ~35 s · **The only clip with a CTA.** Points to the long course
(E07–E09) and this folder. Game content stays store-page level: away-time
visits, gifts, dances, Pattern Journal, tide clock.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0.0–3.0 | The level-5 thank-you dance completing its mandala, slowly turning | The kindest mechanic in my tidepool |
| 3.0–10.0 | Guestbook cascade, then the week timeline with dots riding the tide | Visits accrue while you're away |
| 10.0–17.0 | Side-by-side dances: one petal vs full mandala | Friendship draws more petals |
| 17.0–24.0 | Sketch/mock of a Pattern Journal page — five stages of one signature, last slot open | Every dance gets a page |
| 24.0–30.0 | The tide wave breathing under everything | Tide clock. Not streaks. |
| 30.0–35.0 | End card: the three episode titles stacked (E07 · E08 · E09) over the two spirals | Built in 3 free lessons |

**Caption:** In Tidepool Keeper, creatures visit while you're away — uncapped
and guilt-free — leave gifts, and dance their thanks as drawn patterns a
Pattern Journal collects. The whole system is three free lessons: spirals,
Poisson arrivals, rose-curve dances. Episodes E07–E09 of the long course.
**Hashtags:** #gamedev #cozygames #indiegame #godot #devlog
**CTA:** Full lessons and starter code are free — Six Small Worlds, World 3.
Link in bio.
**Note:** if used in the release window, this slot swaps to the store-page
reveal per the course map.
