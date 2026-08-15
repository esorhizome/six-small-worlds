# Lesson 1 · Speed, ramps, fairness

**Promise:** by the end of this lesson a cube will be running on its own,
getting faster on a ramp you control, with a live speed readout — and a line
drawn in front of it showing, at every moment, the minimum warning distance the
player is owed. A runner speed system that is provably fair.

## If this is your first time

Welcome — you need no Unity experience and no physics beyond "faster means you
cover more ground". The setup is the same for every lesson in this world: new
3D project, empty scene, one cube, one script (the world
[README](README.md#setting-up-unity-one-paragraph-honestly) walks through it in
one paragraph). If anything red appears in the Console, that is the computer
asking a clarifying question, and the most common question is "do the file name
and class name match?"

## See it first

Stand at a quiet street and let a friend call your name. There is a slice of
time — brief, human, unavoidable — between the sound and your head turning.
Nothing you buy and nothing you practise removes it entirely. Every person who
has ever played a game carries that slice with them into every level.

Now picture an endless runner. The screen rushes toward the player, and
somewhere ahead an obstacle is about to matter. The only gift the game can give
is **distance**: enough road between "I can see it" and "it has arrived" for
that human slice of time to fit inside. A slow corridor feels fine even when
you can't see far; a fast corridor is only fine when you can. Fairness, in a
runner, is not a mood. It is a length, in metres, and it grows with speed.

In *EXTR, run!*, obstacles are distractions — a spark, never a threat — and the
game's own design documentation insists the route gives EXTR structure so she
never feels unsupported. The system version of that sentence is what we build
today: the game may run as fast as it likes, **provided it always shows you the
next thing in time to answer it**.

## The maths, small

> **New symbols this lesson: 3.**
>
> - **v** — speed, in metres per second. (v₀ is not a fourth symbol: it is the
>   same v with a timestamp, read "v at time zero" — the speed when the run
>   began.)
> - **a** — acceleration: how much speed grows every second.
> - **t** — time since the run began, in seconds.
>
> **The ramp** (motion with constant acceleration — OpenStax, *College
> Physics*):
>
> v = v₀ + a·t
>
> *In plain English: today's speed is the starting speed, plus the per-second
> gain multiplied by how many seconds have passed.* We add one studio manner to
> the physics: a ceiling, v_max (v wearing a "maximum" label), which the ramp
> climbs to and then respects.
>
> **The debt** — the rule this whole world stands on:
>
> warning distance = v × t_react
>
> *In plain English: the distance the player is owed equals current speed
> multiplied by their reaction time.* We leave "warning distance" written as
> words on purpose — the words are the point — and t_react is our t wearing its
> purpose as a label. Reviews of measured reaction times put a simple visual
> reaction roughly in the 180–250 ms band (Kosinski 2008), so we budget the
> cautious end: **0.25 seconds**. At 12 m/s that is 12 × 0.25 = **3 metres** of
> clear sight, owed, minimum. Phones and screens spend a little time of their
> own between finger and pixel, so in code we will add a small device margin on
> top — a tunable allowance, not a measurement.

That is all the maths. Two multiplications and a promise.

## Build it

Setup, as always: empty scene, one cube at the origin, and a new script on it —
Add Component → New Script → name it exactly `RunnerSpeed`.

### Step 1 — a cube that runs

One idea: move forward a little every frame, scaled by time, so the speed means
the same thing on every computer.

```csharp
using UnityEngine;

public class RunnerSpeed : MonoBehaviour
{
    [SerializeField, Tooltip("Speed, in metres per second.")]
    private float _startSpeed = 6f;

    private void Update()
    {
        transform.position += transform.forward * (_startSpeed * Time.deltaTime);
    }
}
```

**Run it.** The cube slides away from the camera at a steady 6 metres per
second and keeps going forever. If it sails off into the void and out of view —
that is 90% of the lesson working; sailing means it runs. (Select the cube in
the Hierarchy and watch its Z position climb in the Inspector, or drag the
Scene camera to chase it.)

### Step 2 — the ramp

One idea: the formula from the maths box, typed almost verbatim. We track t
ourselves and compute v fresh every frame.

```csharp
using UnityEngine;

public class RunnerSpeed : MonoBehaviour
{
    [SerializeField, Tooltip("v0 — speed at the moment Play starts, in metres per second.")]
    private float _startSpeed = 6f;

    [SerializeField, Tooltip("a — how much speed grows every second (metres per second, per second).")]
    private float _acceleration = 0.4f;

    private float _runTime;   // t — seconds since Play began
    private float _speed;     // v — where the ramp has climbed to right now

    private void Update()
    {
        _runTime += Time.deltaTime;

        // The maths box, line one: v = v0 + a*t
        _speed = _startSpeed + _acceleration * _runTime;

        transform.position += transform.forward * (_speed * Time.deltaTime);
    }
}
```

**Run it.** Same cube, but now it pulls away with growing urgency — 6 m/s at
the start, roughly 12 m/s after fifteen seconds, and still climbing. Which is
the problem.

### Step 3 — the ceiling

One idea: an uncapped ramp is a broken promise waiting to happen, because speed
would eventually outgrow any warning distance a screen can show. `Mathf.Min`
picks whichever is smaller: the ramp, or the ceiling.

```csharp
using UnityEngine;

public class RunnerSpeed : MonoBehaviour
{
    [SerializeField, Tooltip("v0 — speed at the moment Play starts, in metres per second.")]
    private float _startSpeed = 6f;

    [SerializeField, Tooltip("a — how much speed grows every second (metres per second, per second).")]
    private float _acceleration = 0.4f;

    [SerializeField, Tooltip("vMax — the ceiling. The ramp climbs to this and stops, no matter how long the run.")]
    private float _maxSpeed = 12f;

    private float _runTime;   // t — seconds since Play began
    private float _speed;     // v — where the ramp has climbed to right now

    private void Update()
    {
        _runTime += Time.deltaTime;

        // v = v0 + a*t, then the cap: whichever is smaller wins.
        _speed = Mathf.Min(_startSpeed + _acceleration * _runTime, _maxSpeed);

        transform.position += transform.forward * (_speed * Time.deltaTime);
    }
}
```

**Run it.** For the first fifteen seconds, nothing looks different — then the
ramp meets the ceiling and settles there. With the defaults, the cube spends
the rest of forever at a civilised 12 m/s. You now have the exact speed
architecture of a real endless runner: a start, a slope, a cap.

### Step 4 — say the number out loud

One idea: a system you can read is a system you can trust. `OnGUI` draws plain
text over the Game view with no setup at all.

```csharp
using UnityEngine;

public class RunnerSpeed : MonoBehaviour
{
    [SerializeField, Tooltip("v0 — speed at the moment Play starts, in metres per second.")]
    private float _startSpeed = 6f;

    [SerializeField, Tooltip("a — how much speed grows every second (metres per second, per second).")]
    private float _acceleration = 0.4f;

    [SerializeField, Tooltip("vMax — the ceiling. The ramp climbs to this and stops, no matter how long the run.")]
    private float _maxSpeed = 12f;

    private float _runTime;   // t — seconds since Play began
    private float _speed;     // v — where the ramp has climbed to right now

    private void Update()
    {
        _runTime += Time.deltaTime;
        _speed = Mathf.Min(_startSpeed + _acceleration * _runTime, _maxSpeed);
        transform.position += transform.forward * (_speed * Time.deltaTime);
    }

    private void OnGUI()
    {
        GUI.Label(new Rect(12, 12, 420, 24), $"speed {_speed:F1} m/s");
    }
}
```

**Run it.** A small line of text in the top-left corner counts up — 6.0, 6.4,
7.1… — and parks at 12.0. You are watching v = v₀ + a·t happen, one frame at a
time.

### Step 5 — draw the debt

One idea: the maths box's second line, made visible. Every frame we compute the
warning distance the player is owed — speed times the reaction budget — and
draw it as a line in front of the runner. Green for the human share (the
0.25 s), yellow for the device margin stacked on top. Gizmos appear in the
Scene view, and in the Game view when its **Gizmos** button is on.

```csharp
/*  RunnerSpeed.cs — World 6 · EXTR, run! · Lesson 1 (Speed, ramps, fairness)
 *  ---------------------------------------------------------------------------
 *  What it does: moves this object forward at a speed that ramps up over time
 *  (v = v0 + a*t, capped at vMax), shows a live speed readout, and draws a
 *  gizmo line ahead of the runner: the minimum warning distance the player is
 *  owed at the current speed (warning distance = v * reaction budget).
 *  Setup: empty scene -> one cube -> attach this script -> press Play.
 *  Turn on the Game view's Gizmos button (or watch the Scene view) for the line.
 *  One thing to try: raise Acceleration and watch the line grow with the speed.
 */

using UnityEngine;

public class RunnerSpeed : MonoBehaviour
{
    // The cautious end of measured simple visual reaction time.
    // (Kosinski 2008 reviews lab results roughly in the 0.18-0.25 s band.)
    private const float HUMAN_REACTION_SECONDS = 0.25f;

    [Header("The ramp  (v = v0 + a*t)")]
    [SerializeField, Tooltip("v0 — speed at the moment Play starts, in metres per second.")]
    private float _startSpeed = 6f;

    [SerializeField, Tooltip("a — how much speed grows every second (metres per second, per second).")]
    private float _acceleration = 0.4f;

    [SerializeField, Tooltip("vMax — the ceiling. The ramp climbs to this and stops, no matter how long the run.")]
    private float _maxSpeed = 12f;

    [Header("The fairness budget")]
    [SerializeField, Tooltip("Extra seconds added on top of human reaction time to cover the device — touch screens and displays spend time of their own. Raise it for slower hardware.")]
    private float _deviceMargin = 0.05f;

    private float _runTime;   // t — seconds since Play began
    private float _speed;     // v — where the ramp has climbed to right now

    /// <summary>Current speed in metres per second. Other scripts may read this.</summary>
    public float Speed => _speed;

    /// <summary>Metres of clear sight the player is owed at the current speed.</summary>
    public float OwedSightDistance => _speed * (HUMAN_REACTION_SECONDS + _deviceMargin);

    private void Update()
    {
        _runTime += Time.deltaTime;

        // The whole kinematics lesson in one line: v = v0 + a*t, then the cap.
        _speed = Mathf.Min(_startSpeed + _acceleration * _runTime, _maxSpeed);

        transform.position += transform.forward * (_speed * Time.deltaTime);
    }

    private void OnGUI()
    {
        GUI.Label(new Rect(12, 12, 460, 24),
            $"speed {_speed:F1} m/s   |   owed sight {OwedSightDistance:F1} m");
    }

    private void OnDrawGizmos()
    {
        // Before Play, preview the debt at the starting speed.
        float speedNow = Application.isPlaying ? _speed : _startSpeed;

        // Green: the human share of the debt. Yellow: the device margin on top.
        Vector3 humanEnd = transform.position
                         + transform.forward * (speedNow * HUMAN_REACTION_SECONDS);
        Gizmos.color = Color.green;
        Gizmos.DrawLine(transform.position, humanEnd);

        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(humanEnd,
            humanEnd + transform.forward * (speedNow * _deviceMargin));
    }
}
```

**Run it.** The readout now shows two numbers, and the line in front of the
cube stretches as the ramp climbs. Watch the moment the speed parks at
12.0 m/s: the green segment parks too — at exactly **3.0 metres**, which is
12 × 0.25, the maths box made flesh. The yellow sliver past it is the device
margin (0.6 m more with the default 0.05 s). That line is a contract: any
obstacle spawner you ever write for this runner must place things beyond it,
or the game has stopped being fair — not as an opinion, but as an inequality
you can point at.

**You can stop here.** The ramp with the honest gizmo is the lesson: speed that
grows, a ceiling that holds, and the player's reaction time drawn in the air as
a distance the game must respect. Everything below is bonus.

## Go deeper (optional)

- **Move the world instead.** Many production runners keep the player still and
  scroll the track toward them (friendlier for cameras and floating-point
  precision). Nothing in the maths changes: the owed distance is about
  *relative* speed. Try applying the same `_speed` to a floor object's
  `-transform.forward` instead.
- **A ramp that breathes.** Constant a is honest but a touch relentless. Try
  `_acceleration * (1f - _speed / _maxSpeed)` as the per-second gain — the ramp
  now eases off as it nears the ceiling. (Keep this thought warm; it returns
  wearing a top hat in Lesson 3.)
- **Question:** mid-jump, a player cannot dodge sideways. Should the owed
  distance grow while airborne? By how much — the jump's full duration, or the
  time remaining in it?
- **Open prompt:** design a *kind speedometer* — a readout that tells the
  player how fast they're going in a way that feels like encouragement rather
  than surveillance. What would it show? What would it refuse to show?

## Check yourself

1. The run settles at 8 m/s and you budget 0.25 s of reaction. How many metres
   of sight does the game owe the player?
2. Why does the ramp need a ceiling at all — what exactly breaks if v grows
   forever?
3. As the ramp climbs, which grows faster: the speed or the owed warning
   distance?

## Sources

- **Secondary (free):** OpenStax, *College Physics*
  ([openstax.org](https://openstax.org)) — motion with constant acceleration;
  v = v₀ + a·t is its kinematic workhorse.
- **Secondary (free):** R. J. Kosinski (2008), "A Literature Review on Reaction
  Time", Clemson University — long-standing free web review; simple visual
  reaction times measured roughly in the 180–250 ms band, which is why we
  design at 250 ms and then add margin.
- **The game's own:** "EXTR, run! design documentation (in development)" — the
  framing this lesson builds toward: a distraction is a spark, never a threat,
  and the route is structure that supports rather than cages.

---

*Answers, tucked at the very bottom so your eye doesn't trip over them:*

<details>
<summary>Reveal answers</summary>

1. 8 × 0.25 = **2 metres** (plus whatever device margin you budget on top).
2. The owed warning distance is v × t_react, so it grows with v forever —
   eventually it is longer than the visible track, and no spawner can honour
   it. The cap is where fairness stops being possible *by construction*, so we
   refuse to pass it.
3. Neither — they grow **together**. Owed distance is speed multiplied by a
   constant, so it is the same ramp scaled down (a quarter of it, at 0.25 s):
   same shape, same moment of arrival at the cap.

</details>

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
