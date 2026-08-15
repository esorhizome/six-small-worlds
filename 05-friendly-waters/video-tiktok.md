# Friendly Waters — short-form shot lists (4 clips)

*World 5's entries in the [short-form mini-course](../00-course/shortform-tiktok.md).
Ladder positions #8 (Hook), #13 (Build), #17 (Twist), #23 (Bridge). House
rules: one idea per clip · text-on-screen lines ≤ 6 words · captions always
on · the visual is the star · loop-close Hooks and Twists · only the Bridge
carries a CTA · no strobing edits (the games' reduce-motion ethos applies to
cuts too). All footage is screen capture of the starter files in this folder.*

---

## Clip 1 · HOOK — "Why the deep sea is dark"

*Ladder #8. Full working title: "Why the deep sea is dark (it's one
equation)". Source: [starter/depth_light.gd](starter/depth_light.gd),
recorded vertical. ~18 s.*

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–2 | Full sunny glow in tropical blue, surface line crossing it. | "the sea, 0 m" |
| 2–7 | Descent begins; glow visibly shrinking; Sunlight-zone label slides past. | "every metre keeps 97.7%" |
| 7–11 | Twilight label passes; glow is a fingernail, then a dot, then gone; water goes ink. | "200 m: 1% left" |
| 11–14 | Black water; depth counter spinning; readout shows `1.0e-08 %`. | "1,000 m: sunlight, effectively gone" |
| 14–16 | Hold the dark; the equation fades in, bright. | "I = I₀ · e^(−k·z)" |
| 16–18 | Fast rewind to the sunny surface — the loop lands seamlessly on shot 1. | "one equation. whole ocean." |

**Caption:** Sunlight in seawater keeps the same fraction every metre — so it
plunges fast, then thins forever. By 1,000 m it's effectively gone (NOAA).
Law first written down in 1729. Built in Godot in ~75 lines. No maths degree
needed.

**Hashtags:** #deepsea #ocean #godot #gamedev #maths

**CTA:** none — the loop is the CTA (house rule: only the Bridge asks).

**Alt-text:** A glowing circle in blue water shrinks to nothing as a depth
counter descends through labelled ocean zones into black water; an equation
appears; the clip rewinds to the sunny surface.

---

## Clip 2 · BUILD — "Three rules make a school of fish"

*Ladder #13. A 60-second make-along from
[starter/boids.gd](starter/boids.gd): screen-recorded editor, big font, run
after every rule. Ends running. ~60 s.*

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–5 | The finished school turning as one. Then smash to an empty script. | "three rules. no leader." |
| 5–15 | Paste step-1 code (big font); F5: sixty triangles drift randomly. | "fish, no rules" |
| 15–28 | Highlight the separation block; F5: near-misses swerve politely. | "1 · personal space" |
| 28–41 | Highlight the alignment block; F5: lanes and rivers of agreement. | "2 · match your neighbours" |
| 41–52 | Highlight the cohesion line; F5: groups condense — a school, schooling. | "3 · drift toward company" |
| 52–60 | Zoom out; the school swells, splits, re-merges. Hold to end, running. | "no leader. 60 fish." then "no maths degree needed" |

**Caption:** Separation, alignment, cohesion — Craig Reynolds' boids, 1987.
Each fish only watches its neighbours; the school is what the three rules add
up to. Godot 4, one script, ~90 lines.

**Hashtags:** #godot #gamedev #boids #creativecoding #fish

**CTA:** none (house rule) — the Build ends on the running school, not an ask.

**Alt-text:** Code appears in an editor in three highlighted stages; after
each, triangles on a dark screen behave more like a fish school, ending with
sixty fish moving as one group with no leader.

---

## Clip 3 · TWIST — "Turn trust up. Watch him appear."

*Ladder #17. Change ONE number, get a new world — the twist number is
`trust`. Source: lesson 3's go-deeper shimmer added to
[starter/boids.gd](starter/boids.gd). ~20 s.*

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–3 | The school swims; among them a pale pink scribble of ghost-shapes — a fish you can't quite see. | "this is Baro" |
| 3–7 | Close on the scribble wobbling. Cut to one code line, big: `trust = 0.0`. | "strangers see him like this" |
| 7–14 | The value climbs live (0.2 → 0.5 → 0.8); the ghost-copies pull together; the wobble quietens. | "turn one number up" |
| 14–17 | `trust = 1.0` — the scatter is silent: one clear, gentle fish among the school. | "he was there all along" |
| 17–20 | Trust eases back toward 0; the shimmer creeps back in — loop lands on shot 1. | "try trust = 0.5" |

**Caption:** His outline is noise with volume (1 − trust). At trust = 1 the
noise is silent — no transformation, you only stopped being a stranger.
Baro's whole mechanic is one number. (His real-world cousins: hadal
snailfishes, the deepest-living fish known — Gerringer et al., 2017.) What
did you get at 0.5? Duets welcome.

**Hashtags:** #gamedev #godot #indiegame #wholesome #procedural

**CTA:** none (house rule) — the duet invite lives in the caption, the loop
does the rest.

**Alt-text:** A wobbling cluster of pale fish-shaped ghosts swims with a
school; as an on-screen number named trust rises to 1.0, the ghosts merge
into one clear fish; the number falls and the wobble returns.

---

## Clip 4 · BRIDGE — "An ocean with no health bar"

*Ladder #23. The only clip with a CTA: it points at the long course (E13–E15)
and the real game. Montage of all three starters plus one store-page-level
game frame. ~30 s.*

| Seconds | Shot | Text on screen |
|---|---|---|
| 0–4 | The lesson-1 descent: glow shrinking through the zones. | "her charge is her light" |
| 4–9 | The lesson-2 field: a bright speck swept sideways off its line by a current, resuming from where it landed. | "swept? you lose position" then "never progress" |
| 9–14 | The lesson-3 school parts and re-forms; the shimmer-fish resolves as trust climbs. | "trust makes him visible" |
| 14–20 | Three-way split screen: descent, snow, school — the whole world 5 kit. | "light · water · company" |
| 20–25 | One *Friendly Waters* mood frame (store-page level): a small bright swimmer descending, a shy shimmer rising to meet the same ocean. | "no combat. no health bar." |
| 25–30 | End card: the repo folder on screen, course episode numbers. | "full course, free" then "E13–E15 · link in bio" |

**Caption:** This is the actual machinery of *Friendly Waters*: an introvert
whose charge level is her light radius, a shy deep-sea fish whom trust makes
visible, five real ocean zones, and water that never punishes — being swept
costs position, never progress. All three systems are free lessons with
runnable Godot code: E13 light, E14 currents, E15 the school. Link in bio.

**Hashtags:** #indiegame #gamedev #godot #cozygames #learntocode

**CTA:** "Full course, free — episodes E13–E15, link in bio." (This clip is
the world's only ask, per the format contract.)

**Alt-text:** A montage: a glowing circle fades with ocean depth, snow
particles drift on currents, a fish school moves with no leader, and a
shimmering fish becomes clear; end card points to a free course.

---

*Script text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
