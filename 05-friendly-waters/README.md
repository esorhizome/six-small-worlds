# World 5 · Friendly Waters

*The ocean as maths: light that fades honestly, water that pushes kindly,
and company with no leader.*

## From the game

*Friendly Waters* (in development at this studio, built in Godot) is about two
friends crossing the ocean in opposite directions. **Volta**, a pro-social
introvert with an electric charge, descends — and her charge level *is* her
light radius, so the resource she spends on others is the circle she sees by.
**Baro**, a shy hadal snailfish, ascends — strangers can't see him clearly,
only a shimmer that resolves as trust grows. Their world is the real ocean's
five zones, sunlight to hadal trench. The house contract: **no combat, no
health bar** — hazards are environmental, "enemies" are misunderstandings,
and being swept by a current costs position, never progress.

These lessons teach that game's three load-bearing systems, from zero. As
everywhere in this repo: systems, not story — nothing here spoils anything a
store page wouldn't say.

## The three lessons

| # | Lesson | Promise | The maths you'll meet | Starter file |
|---|---|---|---|---|
| 1 | [Why the Deep Is Dark](lesson-1-why-the-deep-is-dark.md) | A light that honestly fades with depth, through the five real zones | Exponential attenuation — I = I₀·e^(−k·z), the Beer–Lambert family | [`starter/depth_light.gd`](starter/depth_light.gd) |
| 2 | [Currents You Can Trust](lesson-2-currents-you-can-trust.md) | Water that pushes, drifts, and never dead-ends — 200 flecks of marine snow riding it | Vector fields; Perlin-style smooth noise; (go-deeper) curl noise | [`starter/current_field.gd`](starter/current_field.gd) |
| 3 | [A School That Thinks Together](lesson-3-a-school-that-thinks-together.md) | A school of fish with no leader — and a shy guest who appears at full trust | Boids: separation, alignment, cohesion (Reynolds 1987) | [`starter/boids.gd`](starter/boids.gd) |

The three stack on purpose: lesson 1 makes a *budget you can see*, lesson 2
makes *space that moves*, lesson 3 puts *company* in it. Together they're an
ocean that behaves.

Every lesson has a marked **"You can stop here."** line, and stopping there
counts as finishing. Lessons 2 and 3 stand alone if you want to drop in.

## Running the starter code

Each starter file is a complete program — no scenes to download, no assets,
no plugins.

1. Install [Godot 4.3+](https://godotengine.org) (free).
2. New project → add a **Node2D** as the scene root.
3. Attach a new script to it and paste in one starter file, replacing
   everything.
4. Press **F5** (accept "set as main scene").
5. Read the comment block at the top of the file — it names one thing worth
   changing first.

## The videos

- **[video-youtube.md](video-youtube.md)** — full scripts for long-form
  episodes **E13–E15** (one per lesson).
- **[video-tiktok.md](video-tiktok.md)** — shot lists for the world's four
  short clips: Hook, Build, Twist, Bridge (ladder #8, #13, #17, #23).

## Combined sources for this world

Every claim in these lessons traces to one of the following. Free-to-read
links are marked; per house rules, at least one per lesson costs nothing.

**Primary**

- P. Bouguer, *Essai d'optique sur la gradation de la lumière*, 1729 — first
  statement of exponential light attenuation: each layer keeps the same
  fraction.
- J. H. Lambert, *Photometria*, 1760 — restated and formalised the law.
- A. Beer, on the absorption of light in coloured liquids, *Annalen der
  Physik und Chemie*, 1852 — tied the constant to concentration; completes
  the "Beer–Lambert" family name.
- K. Perlin, "An Image Synthesizer", *Computer Graphics* (SIGGRAPH), 1985 —
  smooth gradient noise; ancestor of Godot's `FastNoiseLite`.
- R. Bridson, J. Hourihan & M. Nordenstam, "Curl-Noise for Procedural Fluid
  Flow", SIGGRAPH, 2007 — divergence-free flow from noise (lesson 2's
  go-deeper).
- C. Reynolds, "Flocks, Herds, and Schools: A Distributed Behavioral Model",
  *Computer Graphics* (SIGGRAPH), 21(4):25–34, 1987 — boids. **Free** at the
  author's page: [red3d.com/cwr/boids](https://www.red3d.com/cwr/boids/).
- M. E. Gerringer et al., description of *Pseudoliparis swirei*, the Mariana
  hadal snailfish, *Zootaxa*, 2017 — among the deepest-living fishes known;
  Baro's real-world cousin.

**Secondary (free)**

- NOAA Ocean Exploration education pages,
  [oceanexplorer.noaa.gov](https://oceanexplorer.noaa.gov) — the five ocean
  zones and their depths; photic zone ~200 m; sunlight effectively absent
  below ~1,000 m; hadal depths to ~11 km (Challenger Deep ≈ 10,935 m);
  marine snow.
- Daniel Shiffman, *The Nature of Code*,
  [natureofcode.com](https://natureofcode.com) — autonomous agents and flow
  fields, at book length, free.

## Where this world sits

Maths-wise, world 5 leans on world 4's patience (steady per-step rules) and
feeds world 6 directly: E14's noise fields return as motion *feel* in
*EXTR, run!*. Course maps: [long-form](../00-course/longform-youtube.md) ·
[short-form](../00-course/shortform-tiktok.md).
