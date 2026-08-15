# World 2 · upgrade Biotech — short-course shot lists

*Four clips, one idea each: Hook, Build, Twist, Bridge — ladder positions 1,
3, 7 and 19 in the short course. Vertical, captions always on, the visual is
the star. Text-on-screen lines stay under six words. Only the Bridge clip
carries a call-to-action; that's the house rule. Loop-close every Hook and
Twist so the restart is invisible.*

*Recording note: capture all four in one session, right after recording E04 —
same project files, same energy. All screen recordings run the starter files
in this folder at full window, big editor font for any code shots.*

---

## Clip 1 · HOOK — ladder #1

**Hook line (spoken + on screen):** "One rule. 137.5°. Every sunflower."
**Length:** 15 s · **Sound:** one soft synth pad, swelling with the pour;
no licensed music needed anywhere in this series — the studio's games
generate their own audio, and these clips inherit the habit.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–2 | Black screen; a single pale cell appears dead centre. | One rule. |
| 2–6 | Cells accrete one by one (phyllotaxis.gd, normal speed), spirals forming. | turn 137.5° · step out √n |
| 6–11 | Hold-to-pour kicks in; the colony floods to 2,000 cells. Slow push-in. | repeat 2000 times |
| 11–14 | Finished colony breathes (slow zoom out). | every sunflower does this |
| 14–15 | Fast collapse back to the single centre cell (reverse playback). | 137.5° |

**Loop-close:** the final frame is the opening frame — one cell, centre —
so the clip restarts seamlessly and the pattern re-grows forever.
**Caption:** A sunflower is one rule repeated. Vogel proved it in 1979. Built
live in Godot — no images, only maths.
**Hashtags:** #maths #godot #creativecoding #sunflower
**CTA:** none — the loop is the ask. (House rule: only the Bridge clip
points anywhere.)
**Alt text:** Dots appear one at a time around a centre point, forming a
sunflower-like spiral pattern that grows to two thousand dots.

---

## Clip 2 · BUILD — ladder #3

**Hook line (spoken + on screen):** "Code a sunflower in 60 seconds"
**Length:** 60 s · **Sound:** quiet keyboard clicks under a calm pad; spoken
line at the start only.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–4 | Finished colony pouring (the payoff first). Cut to empty Godot editor. | code a sunflower. 60 seconds. |
| 4–10 | New scene: one Node2D, script attached. Big font. | one node. one script. |
| 10–20 | Type the two constants: `GOLDEN_ANGLE_DEG := 137.507764`, `SPACING := 7.0`. | the whole secret: 137.5° |
| 20–34 | Type the loop: angle, radius, position, `draw_circle`. Steady pace, no cuts. | angle = n × 137.5° · radius = 7 × √n |
| 34–42 | Add the growth counter and `queue_redraw()`. | one cell per tick |
| 42–50 | First run: cells accrete from nothing. Genuine reaction beat. | it's growing |
| 50–57 | Add the pour input; hold SPACE; the colony floods. | hold to pour |
| 57–60 | Full bloom, resting. | no maths degree needed |

**Loop-close:** not required for Builds; end resting on the bloom.
**Caption:** Every line explained in the long course — this is Vogel's 1979
sunflower model, thirty lines of GDScript, zero assets. Lopsided first try
counts: lopsided means it's drawing.
**Hashtags:** #godot #codewithme #creativecoding #gamedev
**CTA:** none by design — the Bridge clip carries the pointer.
**Alt text:** Screen recording of GDScript being typed in Godot, ending with
a spiral colony of dots growing and then flooding in fast.

---

## Clip 3 · TWIST — ladder #7

**Hook line (spoken + on screen):** "Change 137.5 to 137.3. Watch."
**Length:** 20 s · **Sound:** the pad detunes when the angle changes, retunes
at the restore — the audio tells the same story as the picture.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–3 | The perfect colony at full bloom. Cursor lands on `137.507764`. | this angle is perfect |
| 3–5 | Edit the constant to `137.3`. Run. | change one digit |
| 5–9 | The colony grows spiral arms with gaps — visibly worse. | 137.3° = spokes |
| 9–13 | Edit to `137.6`. Run. Different arms, same disease. | 137.6° = different spokes |
| 13–17 | Restore `137.507764`. Run. Perfection floods back. | 0.2° broke it |
| 17–20 | Side-by-side triptych: 137.3 · 137.508 · 137.6. | what did your angle grow? |

**Loop-close:** final triptych dissolves back to the full-bloom shot the clip
opened on; the cursor lands on the constant again as it restarts.
**Duet/stitch invitation:** the last text card is the prompt — pick any angle,
post your colony. (An invitation, not a CTA: nothing to click.)
**Caption:** The golden angle is the most irrational turn there is — its
multiples never line up, so gaps never form. Two tenths of a degree either
side and the packing collapses. Try your own angle and duet me the wreckage.
**Hashtags:** #maths #generativeart #godot #goldenratio
**CTA:** none — the duet invitation lives on screen.
**Alt text:** A perfect spiral dot pattern breaks into spoked arms when one
number changes from 137.5 to 137.3, then heals when the number is restored.

---

## Clip 4 · BRIDGE — ladder #19

**Hook line (spoken + on screen):** "This grows the Garden in my game"
**Length:** 30 s · **Sound:** the game's own procedural audio, quietly — the
soundtrack is generated by code, same as the visuals.

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–4 | Real game footage: the Garden tab, 26 rose-curve flowers, thumbnails spinning. | this is my game |
| 4–8 | A flower detail card pen-traces itself from nothing. | 26 flowers = one equation |
| 8–13 | Cut to the Atlas tab: cellular-automata habitats, one growing downward. | 52 worlds = one byte each |
| 13–18 | Cut to an Expedition find: a times-table circle assembling from chords. | 104 finds = times tables |
| 18–23 | Quick montage: lesson starters running — colony, rose grid, cardioid, Rule 90. | you built all of these |
| 23–27 | The game's upgrade list scrolling, letter badges A–Z; everything drawn, nothing loaded. | zero image files |
| 27–30 | End card: repo name + the game's title card. | free lessons. link in bio. |

**Loop-close:** optional; the title card can cut back to the Garden tab.
**Caption:** upgrade Biotech has no sprites, no textures, no audio files —
every flower, habitat and find is grown from the maths in this free course.
Idle game, anti-chore rules: no streaks, no offline cap, nothing expires.
Lessons linked in bio.
**Hashtags:** #indiegame #idlegame #godot #gamedev #indiedev
**CTA:** the one allowed CTA — long course + free lessons, link in bio.
**Alt text:** Gameplay of an idle game showing galleries of code-drawn
flowers, textured habitats and string-art circles, intercut with the same
patterns running in a code editor.

---

*Script text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
