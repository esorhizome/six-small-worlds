# World 3 · Tidepool Keeper — kindness on a timer

*From the game* **Tidepool Keeper** — *a pocket tidepool you keep kind.*
Creatures visit while you're away — uncapped and guilt-free — leave gifts,
and dance their thanks as drawn patterns. A Pattern Journal collects the
dances, page by page, as friendships deepen. The pool runs on a tide clock,
not a daily streak: away a month, come back to a month of guestbook entries,
and nothing has wilted, expired, or judged you.

This world teaches the machinery under that kindness. It turns out that being
gentle to a player is a mathematical position: you need spirals that grow the
way living shells grow, arrivals that behave like honest randomness rather
than a schedule, and a clock borrowed from the moon. Three lessons, three
runnable starter files, and by the end you'll have built the heart of an
away-time visit system — the genre's kindest mechanic.

The game itself is in development; these lessons describe it only at
store-page level and spoil nothing. The machinery is yours to keep.

## The lessons

| # | Lesson | The promise | The maths you'll meet | Starter file |
|---|---|---|---|---|
| 1 | [Two spirals, one shell](lesson-1-two-spirals-one-shell.md) | Both classic spirals side by side — and you'll know which one is alive | Archimedean vs logarithmic spirals; polar coordinates; the nautilus myth-check | [starter/spirals.gd](starter/spirals.gd) |
| 2 | [Visitors while you're away](lesson-2-visitors-while-youre-away.md) | A month of guestbook entries simulated in one second | Poisson arrivals; exponential gaps (−ln(u)/λ); the M2 tide clock | [starter/visits.gd](starter/visits.gd) |
| 3 | [The thank-you dance](lesson-3-the-thank-you-dance.md) | A creature draws its signature pattern, growing with friendship | Rose curves r = cos(kθ) as signatures; friendship as a drawing window; slow spin | [starter/thanks_dance.gd](starter/thanks_dance.gd) |

Every lesson has a marked **"you can stop here"** line, and stopping there
counts as finishing. Lesson 1 assumes nothing; lessons 2 and 3 stand alone
too, with pointers back where they help.

## The videos

- **Long course:** episodes [E07–E09](video-youtube.md) — full scripts with
  beats tables, B-roll cues, and end cards, per the
  [long-form course map](../00-course/longform-youtube.md).
- **Short course:** [four clips](video-tiktok.md) — Hook, Build, Twist,
  Bridge — per the [short-form course map](../00-course/shortform-tiktok.md).

## What you need

Godot 4.3+ and nothing else. Each starter file is one script on one Node2D —
no scenes to download, no assets, no plugins. Make a 2D scene, attach the
script, paste, press F5 (choose *Select Current* the first time Godot asks).
Lesson 1, Step 1 walks through it click by click. No maths prerequisites
beyond knowing what sin and cos look like on a calculator; θ, e, λ, ln, and k
are all introduced on the spot, in words, three at most per lesson.

## House rules, kept

Like the game, like the whole classroom: no streaks, no deadlines, nothing
expires. The starter code waits in this folder; the tide will still be
running whenever you arrive.

## Combined sources

Everything this world claims, traceable. Each lesson lists its own subset;
this is the union.

- **Primary:** Archimedes, *On Spirals*, c. 225 BC — defined the constant-gap
  spiral (a point moving steadily along a steadily turning line). Free in
  T. L. Heath's translation, *The Works of Archimedes* (1897), at
  [archive.org](https://archive.org/details/worksofarchimede00arch).
- **Primary:** C. Falbo, "The Golden Ratio — A Contrary Viewpoint", *The
  College Mathematics Journal* 36(2), 2005, pp. 123–134 — measured chambered
  nautilus shells: growth ratios 1.24–1.43, average about 1.33; the nautilus
  is a logarithmic spiral, not the golden spiral.
- **Historical:** Jacob Bernoulli named the logarithmic spiral *spira
  mirabilis* (1692) and asked for it on his tombstone; the mason carved an
  Archimedean spiral instead. **Secondary (free):** MacTutor History of
  Mathematics archive — [Equiangular Spiral](https://mathshistory.st-andrews.ac.uk/Curves/Equiangular/),
  [Bernoulli's tomb](https://mathshistory.st-andrews.ac.uk/Extras/Bernoulli_tomb/),
  and [Rhodonea Curves](https://mathshistory.st-andrews.ac.uk/Curves/Rhodonea/)
  (rose curves, named by Guido Grandi in the 1720s; odd k → k petals, even
  k → 2k).
- **Secondary (free):** D'Arcy Thompson, *On Growth and Form* (1917) — shells
  as equiangular (logarithmic) spirals; the coiled-cylinder versus
  coiled-cone picture. Free at
  [archive.org](https://archive.org/details/ongrowthform00thom).
- **Secondary (free):** C. M. Grinstead & J. L. Snell, *Introduction to
  Probability* (AMS) — the Poisson distribution and the exponential density;
  independent arrivals at rate λ have exponentially distributed gaps. Free
  PDF: [math.dartmouth.edu/~prob/prob/prob.pdf](https://math.dartmouth.edu/~prob/prob/prob.pdf).
- **Secondary (free):** NOAA National Ocean Service education, *Tides and
  Water Levels* — ["Frequency of Tides — The Lunar Day"](https://oceanservice.noaa.gov/education/tutorial_tides/tides05_lunarday.html):
  lunar day 24 h 50 min; high tides about 12 h 25 min apart. NOAA Tides &
  Currents lists the principal lunar semidiurnal constituent as **M2**,
  period ≈ 12.42 h. *Historical note:* William Thomson (later Lord Kelvin)
  began harmonic tide prediction in 1867.
- **House favourite:** Daniel Shiffman, *The Nature of Code* — free at
  [natureofcode.com](https://natureofcode.com) — randomness, oscillation, and
  polar coordinates, all in a voice this classroom admires.
