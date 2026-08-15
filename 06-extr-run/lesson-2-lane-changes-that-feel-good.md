# Lesson 2 · Lane changes that feel good

**Promise:** by the end of this lesson one cube will perform the exact same
lane change three different ways — robotic, buttery, eager — and you will
switch between the three feels from a dropdown in the Inspector *while the game
is running*. Same distance, same duration, three personalities.

## If this is your first time

Same setup as ever: empty scene, one cube, one new script named `LaneMover`
(the [world README](README.md#setting-up-unity-one-paragraph-honestly) has the
one-paragraph version). This lesson uses the arrow keys; if pressing them does
nothing and the Console mentions the *Input System package*, that is the
computer asking which keyboard-reading era you'd like — answer it in Edit →
Project Settings → Player → **Active Input Handling → Both**, let Unity
restart, and carry on.

## See it first

Watch a train arrive at a platform. It does not hold one speed and then halt as
if switched off — it eases, sheds pace, settles. Now slide a book across a
table with your hand: without being asked, your arm starts the book gently and
lands it gently. Every moving thing you have ever watched — doors, cats,
lifts, your own hand — spends part of its journey speeding up and part slowing
down.

A computer, left to itself, does neither. Tell it "be 30% of the way there at
30% of the time" and it will obey with perfect, eerie indifference — the same
pace at the first millimetre as at the last. Your eye clocks it instantly, even
if you can't name it. Here is the name, and it is the one sentence this lesson
exists to hand you:

**Linear motion reads as robotic because real things accelerate.**

The fix is not more code. It is a *reshaping of time* — three small formulas
that bend "how far along am I?" before the movement uses it. Game developers
call it easing, after Robert Penner's chapter that gave the shapes their
working vocabulary.

## The maths, small

> **New symbols this lesson: 1.** (Lesson 1's letters are off duty; we reuse
> the alphabet the way a small studio reuses props.)
>
> - **t** — progress through one move, from 0 (departure) to 1 (arrival). Not
>   seconds this time: a fraction of the journey. Seconds divided by the move's
>   duration, then clamped.
>
> **Lerp, honestly** (linear interpolation — a fraction of the way there):
>
> position = from + (to − from) × t
>
> *In plain English: start where you started, and add t's worth of the gap.
> At t = 0.25 you are a quarter of the way. That is the entire secret of
> lerp — there isn't any more.*
>
> **Smoothstep** (a reshaped t, written t′ — same letter, new costume):
>
> t′ = 3t² − 2t³
>
> *In plain English: nudge t so it leaves slowly, hurries in the middle, and
> lands slowly.* You can audit its manners with school algebra: at t = 0 it is
> 0, at t = 1 it is 3 − 2 = 1, and its slope 6t − 6t² equals zero at both ends —
> a soft departure and a soft landing, guaranteed by the polynomial itself.
>
> **Ease-out cubic** (Penner's family):
>
> t′ = 1 − (1 − t)³
>
> *In plain English: leave in a hurry, spend the rest of the trip settling.*
> At t = 0 the slope is 3 — three times faster than linear — and it glides to
> zero at arrival. This is the shape of eagerness.

Three formulas, one honest input, and every one of them ends exactly where it
began: 0 goes to 0, 1 goes to 1. Only the *middle* of the journey changes —
which is where feel lives.

## Build it

Setup: empty scene, one cube at the origin, script named `LaneMover` attached.
For a nicer view, drag the Main Camera up and back so you're looking slightly
down at the cube.

### Step 1 — lanes, the blunt way

One idea: a lane is a number (−1, 0, +1) and a width. Keys change the number;
the cube's x position is the number times the width. No motion yet — teleports.

```csharp
using UnityEngine;

public class LaneMover : MonoBehaviour
{
    [SerializeField, Tooltip("Centre-to-centre distance between lanes, in metres.")]
    private float _laneWidth = 2.5f;

    private int _lane;   // -1, 0, +1 — which lane we currently claim

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow) || Input.GetKeyDown(KeyCode.A))
            _lane = Mathf.Clamp(_lane - 1, -1, 1);
        if (Input.GetKeyDown(KeyCode.RightArrow) || Input.GetKeyDown(KeyCode.D))
            _lane = Mathf.Clamp(_lane + 1, -1, 1);

        Vector3 p = transform.position;
        transform.position = new Vector3(_lane * _laneWidth, p.y, p.z);
    }
}
```

**Run it.** Tap left and right (or A and D). The cube *teleports* between three
positions. It works, and it feels terrible — hold on to that feeling, it is the
"before" photo. If your cube snaps between spots, everything is wired
correctly; snapping is the system running with no opinion about time yet.

### Step 2 — the honest lerp

One idea: give the move a duration, track progress t from 0 to 1, and be
"t's worth of the way there" each frame. This is linear mode — the raw t.

```csharp
using UnityEngine;

public class LaneMover : MonoBehaviour
{
    [SerializeField, Tooltip("Centre-to-centre distance between lanes, in metres.")]
    private float _laneWidth = 2.5f;

    [SerializeField, Tooltip("Seconds one lane change takes, whatever its shape.")]
    private float _moveDuration = 0.25f;

    private int _lane;        // -1, 0, +1 — which lane we are headed to
    private float _fromX;     // where this move started
    private float _toX;       // where this move is going
    private float _elapsed;   // seconds since this move began

    private void Start()
    {
        _fromX = _toX = transform.position.x;
        _elapsed = _moveDuration;   // begin settled, not mid-move
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow) || Input.GetKeyDown(KeyCode.A)) StartMove(-1);
        if (Input.GetKeyDown(KeyCode.RightArrow) || Input.GetKeyDown(KeyCode.D)) StartMove(+1);

        // t is progress through the move: 0 = departure, 1 = arrival.
        _elapsed += Time.deltaTime;
        float t = Mathf.Clamp01(_elapsed / _moveDuration);

        // Lerp, honestly: from + (to - from) * fraction. Nothing more.
        float x = _fromX + (_toX - _fromX) * t;

        Vector3 p = transform.position;
        transform.position = new Vector3(x, p.y, p.z);
    }

    private void StartMove(int direction)
    {
        int target = Mathf.Clamp(_lane + direction, -1, 1);
        if (target == _lane) return;        // already in the outside lane

        _lane = target;
        _fromX = transform.position.x;      // depart from wherever we are
        _toX = _lane * _laneWidth;
        _elapsed = 0f;
    }
}
```

**Run it.** The cube now *slides* between lanes over a quarter of a second.
Better — and yet something is off, isn't it? It moves like a filing cabinet
drawer on rails: constant pace, dead stop. Try mashing a key mid-move, too —
because each move departs "from wherever we are", interruptions stay smooth
rather than snapping. That detail is doing quiet, professional work.

### Step 3 — the wardrobe of shapes

One idea: keep everything, and pass t through a `Shape()` function chosen by an
enum. An enum shows up in the Inspector as a dropdown — which means the feel of
your game becomes a setting you can flip while it plays. This is the finished
file (identical to [`starter/LaneMover.cs`](starter/LaneMover.cs)):

```csharp
/*  LaneMover.cs — World 6 · EXTR, run! · Lesson 2 (Lane changes that feel good)
 *  ---------------------------------------------------------------------------
 *  What it does: slides this object between three lanes on the left/right
 *  arrow keys (or A/D). The SAME move can be played three ways — pick the feel
 *  in the Inspector, even mid-Play:
 *    Linear       — raw t: a fraction of the way there, every frame the same
 *    SmoothStep   — 3t^2 - 2t^3: soft departure, soft landing
 *    EaseOutCubic — 1 - (1-t)^3: leaves in a hurry, settles gently (Penner)
 *  Setup: empty scene -> one cube -> attach this script -> press Play.
 *  One thing to try: set Move Duration to 1.5 and watch the three shapes slowly.
 */

using UnityEngine;

public class LaneMover : MonoBehaviour
{
    public enum EaseMode { Linear, SmoothStep, EaseOutCubic }

    [SerializeField, Tooltip("The feel. Switch this WHILE the game runs — that is the whole lesson.")]
    private EaseMode _mode = EaseMode.Linear;

    [SerializeField, Tooltip("Centre-to-centre distance between lanes, in metres.")]
    private float _laneWidth = 2.5f;

    [SerializeField, Tooltip("Seconds one lane change takes, whatever its shape.")]
    private float _moveDuration = 0.25f;

    private int _lane;        // -1, 0, +1 — which lane we are headed to
    private float _fromX;     // where this move started
    private float _toX;       // where this move is going
    private float _elapsed;   // seconds since this move began

    private void Start()
    {
        _fromX = _toX = transform.position.x;
        _elapsed = _moveDuration;   // begin settled, not mid-move
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.LeftArrow) || Input.GetKeyDown(KeyCode.A)) StartMove(-1);
        if (Input.GetKeyDown(KeyCode.RightArrow) || Input.GetKeyDown(KeyCode.D)) StartMove(+1);

        // t is progress through the move: 0 = departure, 1 = arrival.
        _elapsed += Time.deltaTime;
        float t = Mathf.Clamp01(_elapsed / _moveDuration);

        // Reshape time, then lerp honestly: from + (to - from) * fraction.
        float shaped = Shape(t);
        float x = _fromX + (_toX - _fromX) * shaped;

        Vector3 p = transform.position;
        transform.position = new Vector3(x, p.y, p.z);
    }

    private void StartMove(int direction)
    {
        int target = Mathf.Clamp(_lane + direction, -1, 1);
        if (target == _lane) return;        // already in the outside lane

        _lane = target;
        _fromX = transform.position.x;      // depart from wherever we are
        _toX = _lane * _laneWidth;
        _elapsed = 0f;
    }

    private float Shape(float t)
    {
        switch (_mode)
        {
            case EaseMode.SmoothStep:   return t * t * (3f - 2f * t);              // 3t^2 - 2t^3
            case EaseMode.EaseOutCubic: return 1f - (1f - t) * (1f - t) * (1f - t); // 1 - (1-t)^3
            default:                    return t;                                    // Linear: raw t
        }
    }
}
```

**Run it — and keep it running.** Select the cube, find **Mode** in the
Inspector, and change lanes a few times in each setting:

- **Linear** — the filing cabinet. Competent, dead.
- **SmoothStep** — the same quarter-second, but it *breathes*: gathers itself,
  crosses, settles. Most players would call this one "polished" without being
  able to say why.
- **EaseOutCubic** — off the line instantly, then a long velvet stop. This is
  the classic runner dodge: the game answers your thumb *now*, and spends the
  rest of the move being graceful about it. Responsiveness lives at the start
  of the curve.

Same distance. Same duration. Three personalities — and the only thing that
ever changed was the shape of t.

**You can stop here.** Switching modes in the Inspector mid-play *is* the
lesson: you have felt, in your own hands, that game feel is a choice of curve
rather than a mystery. Everything below is bonus.

## Go deeper (optional)

- **Compose with Lesson 1.** Add `RunnerSpeed` to the same cube. Forward motion
  and lateral easing stack without argument, because each writes its own axis —
  congratulations, that diagonal swerve is the core of an endless runner.
  (The real game composes motion the same way: lane changes are applied as
  sideways offsets on top of forward speed, never as competing teleports.)
- **Slow-motion audit.** Set Move Duration to 1.5 and watch each shape like a
  nature documentary. Where does each one spend its time? Sketch the three
  curves on paper — x-axis t, y-axis t′ — and check your sketch against the
  formulas.
- **Write a fourth shape.** Try `t * t` (ease-in: hesitant departure, brisk
  arrival) and feel why runners avoid it for dodges — the answer arrives late.
- **Question:** is linear ever the *right* choice? (Consider a progress bar, a
  clock hand, anything whose visual honesty matters more than its charm.)
- **Open prompt:** EXTR is a chorus of minds in one small body. Which of the
  three shapes is *her* lane change — and does the answer change when she's
  had nourishment versus when she's distracted?

## Check yourself

1. lerp from 2 to 10 with t = 0.25: where are you?
2. What is smoothstep's slope at t = 0 and t = 1, and why does that guarantee
   the "soft departure, soft landing" feel?
3. A player taps dodge at the last moment. Which of the three modes moves the
   cube furthest in the first 10% of the move — and why is that the one
   runners tend to ship?

## Sources

- **Secondary (free):** Robert Penner's easing chapter
  ([robertpenner.com/easing](http://robertpenner.com/easing)) — the chapter
  that named the shapes; home of the ease-out cubic and the argument that
  motion with acceleration reads as natural.
- **Secondary (free):** OpenStax, *College Physics*
  ([openstax.org](https://openstax.org)) — the "real things accelerate" half of
  this lesson's one-sentence truth is Lesson 1's kinematics wearing different
  clothes.
- **The game's own:** "EXTR, run! design documentation (in development)" —
  lateral movement composed as per-frame offsets alongside forward speed, the
  pattern the Go-deeper section borrows.

---

*Answers, tucked at the very bottom so your eye doesn't trip over them:*

<details>
<summary>Reveal answers</summary>

1. 2 + (10 − 2) × 0.25 = **4**.
2. The slope of 3t² − 2t³ is 6t − 6t², which is **zero at both t = 0 and
   t = 1** — the motion has no pace at the instant it departs or lands, so
   there is no jolt at either end.
3. **EaseOutCubic** — its slope at t = 0 is 3, triple linear's, so most of the
   dodge happens immediately. Runners ship it because the player's input is
   answered at the start of the curve, where it counts.

</details>

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
