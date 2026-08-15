# Six Small Worlds — the long-form course

*Format: YouTube (or any long-video home) · 20 episodes · 12–18 min each ·
each episode = one written lesson in this repo, performed.*

## The shape of the course

Six mini-series, one per game, ordered so each world's maths leans on the
last — parametric curves (1) feed phyllotaxis (2), spirals (3) feed L-systems
(4), noise fields (5) feed motion feel (6). The final episode is not a lesson:
it's the real publication of a real game from this studio, live, with the
audience that learned its insides.

**The promise made in episode 0 and kept in episode 19:** *"By the end of this
course you'll have built the heart of six games — and watched one of them
actually ship."*

## Episode map

### E00 · Welcome to the workshop
The six worlds in six minutes. The house rules (no streaks, nothing expires,
stopping counts as finishing). Install Godot together, draw one circle in
_draw(), call it a day. *Deliverable: a circle. Genuinely.*

### World 1 · equanim — the gallery is the curriculum (3 eps)
- **E01 · A circle is two dials** — sin & cos as turning dials; parametric
  curves; draw a circle, then bend it into an ellipse and a Lissajous figure.
- **E02 · One formula, every flower** — the superformula (Gielis 2003); one
  equation morphing between star, square, petal; build an inspect-card that
  turns.
- **E03 · Wireframes that turn** — a cube in 3D, rotated by hand (rotation as
  two dials again), projected to 2D; Euler's V−E+F=2 as the check-yourself.
  *Series payoff: your own turning gallery card — the atom of equanim.*

### World 2 · upgrade Biotech — growth by one rule (3 eps)
- **E04 · The sunflower rule** — Vogel's phyllotaxis (turn 137.5°, step √n);
  why the golden angle and nothing else; a colony accretes cell by cell.
- **E05 · A garden from an equation** — rose curves r = cos(kθ); odd/even petal
  counts; times-table circles and the cardioid hiding in the 2× table.
- **E06 · Worlds from neighbours** — elementary cellular automata (Rule 90);
  one row of cells, one lookup rule, an entire habitat.
  *Series payoff: the visual language of an idle game with no assets at all.*

### World 3 · Tidepool Keeper — kindness on a timer (3 eps)
- **E07 · Two spirals, one shell** — Archimedean vs logarithmic spirals; why
  shells grow log-spirals (and why the nautilus is *not* the golden ratio).
- **E08 · Visitors while you're away** — Poisson arrivals; exponential gaps;
  simulate a month of guestbook entries in a second; the tide clock's 12 h 25 m.
- **E09 · The thank-you dance** — a creature draws its signature pattern;
  friendship level = iterations; the reward that is also the collection.
  *Series payoff: an away-time visit system — the genre's kindest mechanic.*

### World 4 · An Isolate Grows Roots — patience as a mechanic (3 eps)
- **E10 · Teach a turtle to walk** — turtle graphics; heading + step;
  your first fern from four commands.
- **E11 · The grammar of plants** — L-systems (Lindenmayer 1968); rewrite
  rules; branching with a stack; Florence's root-legs, grown live.
- **E12 · One turn at a time** — easing curves (Penner); growth that bursts
  then rests; taps refused mid-turn; why patience reads as life.
  *Series payoff: a root system that is also a progress bar.*

### World 5 · Friendly Waters — the ocean as maths (3 eps)
- **E13 · Why the deep is dark** — exponential attenuation (Beer–Lambert);
  the five real ocean zones to −11,000 m; charge = light radius, a resource
  you can *see*.
- **E14 · Currents you can trust** — vector fields; Perlin noise as weather;
  curl noise so currents never dead-end; marine snow as slow platforms.
- **E15 · A school that thinks together** — boids (Reynolds 1987): three rules,
  no leader; trust as a shimmer that resolves (noise amplitude → 0).
  *Series payoff: an ocean that behaves — light, water, and company.*

### World 6 · EXTR, run! — motion that feels kind (3 eps)
- **E16 · Speed, ramps, fairness** — v = v₀ + at; reaction-time budgets
  (~250 ms); deriving minimum spawn distance from speed. The maths of *fair*.
- **E17 · Lane changes that feel good** — lerp vs smoothstep vs eased curves;
  why linear motion feels robotic; tune it in the Inspector.
- **E18 · Difficulty as comfort** — ramps that advance only on unhurt runs;
  flow (Chen 2006); weighted bags so "random" never feels cruel.
  *Series payoff: an endless runner core with no fail state and no meanness.*

### E19 · Finale — we publish, for real
Not a lesson. The studio ships (store page walk-through, the release build,
the button press, the first hour after). Everything the course taught, pointed
at: the Garden is E05, the light radius is E13, the comfort ramp is E18.
Closing register: the course's own house rule — *stopping counts as finishing,
and so does shipping.*

## Cadence and packaging

- **Cadence:** one episode/week sustains 5 months — matching the studio's own
  build calendar, so the finale lands near a real release. Batch-record each
  world's 3 episodes in one sitting for consistency.
- **Thumbnails:** the visual payoff, not a face + arrow. These worlds are the
  most screenshot-able asset the studio owns.
- **Titles carry the maths honestly:** "One formula draws every flower
  (superformula, explained gently)" outperforms clickbait *and* keeps the
  contract with students.
- **Every description links:** this repo → the specific lesson → the sources.
  The repo is the retention loop; the videos are the front door.

## What each episode needs from this repo

Lesson text (the script's skeleton) · starter code (the live-coding safety
net) · sources list (pinned comment). All three ship in each world's folder.
