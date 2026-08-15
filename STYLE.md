# STYLE — the teaching contract

Authoring guide for every lesson, script, and starter file in this repo.
(Public on purpose: students deserve to see the contract they're taught under.)

## Voice

- Warm, unhurried, precise. We are a patient studio; the classroom matches.
- **Banned words:** "simply", "just", "obviously", "easy", "trivial". If it were
  obvious, the lesson wouldn't exist.
- Never scold. Errors are "the computer asking a clarifying question".
- Celebrate partial progress explicitly ("if your spiral is lopsided, you are
  90% of the way there — lopsided means it's drawing").
- British-adjacent gentle humour allowed; sarcasm about the student never.

## Lesson anatomy (every lesson, same skeleton)

1. **Title + one-line promise** — what will exist on screen by the end.
2. **"If this is your first time" note** — 2–3 sentences of reassurance and setup.
3. **See it first** — the visual/intuition, zero code, zero symbols.
4. **The maths, small** — a boxed section: at most **3 new symbols**, each named
   in words. Formula, then the same formula in plain English.
5. **Build it** — numbered steps. One new idea per step. Full code at each
   milestone, never diffs. Expected result described after each run.
6. **"You can stop here."** — an explicit line, placed where a satisfying
   version already runs. Everything after is bonus.
7. **Go deeper (optional)** — for the stronger student: variations, questions,
   one open-ended prompt.
8. **Check yourself** — 3 questions max, answers upside-down-style at the bottom.
9. **Sources** — see citation rules.

## Maths rules

- Concise and research-backed. State the result, show the one formula that
  matters, cite where it came from, move on.
- Primary source first when it's readable; always pair with a free secondary
  source a student can actually open today.
- Never claim more than the source supports (e.g. the nautilus shell is a
  logarithmic spiral, **not** the golden spiral — and we cite the correction).
- Degrees for beginners, radians in code, and one sentence acknowledging the
  switch every time it happens.

## Citation format

At lesson end, under `## Sources`:

- **Primary:** Author, "Title", *Journal/Book*, year. One line on what it
  established. Link if legally free.
- **Secondary (free):** at least one per lesson that costs nothing to read.
- House favourites (use freely): Prusinkiewicz & Lindenmayer, *The Algorithmic
  Beauty of Plants* (free PDF, algorithmicbotany.org); Daniel Shiffman, *The
  Nature of Code* (free, natureofcode.com); Robert Penner's easing chapter
  (free, robertpenner.com/easing); OpenStax *College Physics* (free).
- **Do not invent citations.** If unsure a source exists, leave it out.

## Godot starter-code rules (worlds 1–5)

- Godot **4.3+**, GDScript, one `Node2D` + one attached script per starter file.
  No scenes to download, no assets, no plugins — paste and press F5.
- Draw with `_draw()` + `queue_redraw()`; animate via `_process(delta)`.
- Use `PackedVector2Array` for polylines; `draw_polyline(points, color, width)`;
  `draw_circle(pos, r, color)`.
- Angles: `deg_to_rad()` at the boundary; store radians internally.
- Every file starts with a comment block: what it draws, which lesson it
  belongs to, and one thing to try changing.
- Magic numbers get names (`const GOLDEN_ANGLE_DEG := 137.507764`).
- Target length: under ~80 lines per starter file. If it wants to be longer,
  the lesson is trying to teach two things.

## Unity starter-code rules (world 6)

- Unity 2022 LTS+, C#, one MonoBehaviour per concept, no packages.
- Same comment-block convention. Prefer `[SerializeField]` fields with tooltips
  so beginners tune in the Inspector instead of the code.

## YouTube script format (per lesson, in `video-youtube.md`)

- **Cold open (0:00–0:20):** the finished visual, one spoken line, no logo.
- **Beats table:** timecode range · what's on screen · spoken line(s).
  Conversational register — scripts are said aloud, so shorter sentences than
  the written lesson.
- **B-roll cues** in *italics*.
- **End card (last 15 s):** what exists now, what the next episode grows,
  one breath of the studio's own game ("this is the rule that grows the
  Garden in upgrade Biotech").
- Target: 12–18 minutes of speech per lesson episode.

## TikTok shot-list format (per game, in `video-tiktok.md`)

- 4 clips per world: **Hook** (the wow), **Build** (60-second make-along),
  **Twist** (change one number, new world), **Bridge** (points to long course).
- Per clip: hook line ≤ 8 words · shot list with seconds · caption ·
  3–5 hashtags · CTA.
- Text-on-screen lines ≤ 6 words each. One idea per clip, same as lessons.

## Spoiler policy

Lessons teach systems, not stories. Name the game, show its aesthetic, quote
its house rules — never its plot beats, endings, or unreleased catalogue
contents beyond what a store page would say.
