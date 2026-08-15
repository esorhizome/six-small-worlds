# Lesson 3 · Difficulty as comfort

**Promise:** by the end of this lesson you will have a difficulty system that
never punishes — a dial that rises only when the player has *shown* they are
comfortable, settles back when they are not, follows a curve that saturates
instead of exploding, and narrates every one of its gentle decisions to the
Console in full sentences.

## If this is your first time

Same ritual: empty scene, one cube, one new script named `ComfortRamp` (the
[world README](README.md#setting-up-unity-one-paragraph-honestly) has the
paragraph). This lesson's script listens for two keys, C and H — if pressing
them prints nothing, the computer is asking where the keyboard is pointed:
click the Game view once to give it focus, and the Console will start talking.

## See it first

Picture a swimming teacher with one rule: nobody moves toward the deep end on a
schedule. You move when you float without holding the rail — and if a lesson
goes badly, you drift back a little, no ceremony, no comment. Nobody is ever
thrown in. Nobody is ever stuck, either, because the rule is not "be perfect",
it is "show me you're at ease, and the water deepens a step."

Most games raise difficulty by the clock or the level count: survive two
minutes, the spikes multiply — *whether or not you were coping*. The game we
are shadowing refuses that. From the design documentation of *EXTR, run!* (in
development): the difficulty curves *"advance a step only when a level is
completed without taking a hit, and settle back a step after a rough one.
Difficulty follows demonstrated comfort, not the clock."* In the fiction, the
bosses adjusting EXTR's route are curious, not controlling — observation, not
judgement. In the systems, that sentence is about twelve lines of C#, and you
are about to write all of them.

There is a second, quieter cruelty in most runners: raw randomness. Dice have
no memory — roll a die four times and it is entirely happy to shout the same
number three times running. Dealt cards are different: once the ace of spades
leaves the deck, it *cannot* appear again until the shuffle. Games that feel
generous tend to deal, not roll. We will end with a bag you deal obstacles
from, so "random" stops meaning "occasionally vicious".

## The maths, small

> **New symbols this lesson: 2.**
>
> - **d** — the difficulty dial, from 0 (gentlest) to 1 (the ceiling). Not
>   metres, not seconds: a fraction of the way to as-hard-as-this-game-goes.
> - **r** — the growth rate: how eagerly the dial answers a clean run.
>
> **The logistic step** (P. Verhulst, 1838 — proposed for populations, at home
> anywhere growth should have manners):
>
> step = r × d × (1 − d)
>
> *In plain English: each step is the rate, times how far you've come, times
> how much room is left.* Near d = 0 the step is small (little momentum yet);
> near d = 1 the step is small again (almost no room left); the eager part
> happens in the middle. Follow that rule repeatedly and d traces the famous
> S-curve — quick through the comfortable middle, flattening as it nears the
> ceiling. Difficulty that *saturates* instead of exploding.
>
> One honest footnote: at exactly d = 0 or d = 1 the step is zero — a dial
> parked at either end could never move again. So in code we keep d strictly
> inside, with a small floor and ceiling.

Where does the *when* come from? Not from maths — from the player. A clean run
applies the step upward; a run with a hit applies it downward. That policy has
a research frame: Csikszentmihalyi (1990) described **flow** as the channel
between anxiety (too hard for your skill) and boredom (too gentle), and Jenova
Chen's MFA thesis (2006, free online) mapped that channel onto game difficulty,
arguing games should adapt to the player to keep them inside it. A no-hit run
is evidence of "this is not anxiety"; a hit is evidence of "the channel's upper
wall is near". The comfort ramp is the flow channel, written as an if-statement.

## Build it

Setup: empty scene, one cube, script named `ComfortRamp` attached. The cube is
scenery this time — this lesson's output lives in the Console (Window →
General → Console) and a small on-screen label.

### Step 1 — the rule, blunt first

One idea: the dial moves only when a run is *reported*, and the direction
depends on whether the run was clean. C reports a clean run, H reports a hit.
For now, every step is the same size.

```csharp
using UnityEngine;

public class ComfortRamp : MonoBehaviour
{
    [SerializeField, Tooltip("How far the dial moves per reported run.")]
    private float _stepSize = 0.05f;

    private float _difficulty = 0.1f;   // the dial: 0 = gentlest, 1 = the ceiling

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.C)) ReportRun(tookHit: false);
        if (Input.GetKeyDown(KeyCode.H)) ReportRun(tookHit: true);
    }

    public void ReportRun(bool tookHit)
    {
        _difficulty = Mathf.Clamp01(_difficulty + (tookHit ? -_stepSize : _stepSize));

        Debug.Log(tookHit
            ? $"[ComfortRamp] That one was rough — settling back. dial {_difficulty:F2}"
            : $"[ComfortRamp] Clean run — opening the door wider. dial {_difficulty:F2}");
    }
}
```

**Run it.** Click the Game view once, then tap C a few times and watch the
Console: 0.15, 0.20, 0.25 — and tap H to watch it politely retreat. This
already honours the house rule (no clean run, no climb; a rough run steps
back). If your Console is filling with tidy sentences, the heart of the system
is finished — everything from here is refinement.

### Step 2 — give the steps manners

One idea: swap the fixed step for Verhulst's. Steps now start small, swell
through the middle, and shrink as the ceiling nears — the S-curve, dealt one
run at a time.

```csharp
using UnityEngine;

public class ComfortRamp : MonoBehaviour
{
    // The dial never parks at 0 or 1 — Verhulst's step is zero there,
    // and a parked dial could never move again.
    private const float DIAL_FLOOR = 0.02f;
    private const float DIAL_CEILING = 0.98f;

    [SerializeField, Range(0.05f, 1f), Tooltip("r — how eagerly the dial moves per step. Verhulst: step = r * d * (1 - d).")]
    private float _growthRate = 0.5f;

    private float _difficulty = 0.1f;   // d — the dial: 0 = gentlest, 1 = the ceiling

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.C)) ReportRun(tookHit: false);
        if (Input.GetKeyDown(KeyCode.H)) ReportRun(tookHit: true);
    }

    public void ReportRun(bool tookHit)
    {
        float step = _growthRate * _difficulty * (1f - _difficulty);   // Verhulst 1838
        _difficulty = Mathf.Clamp(_difficulty + (tookHit ? -step : step),
                                  DIAL_FLOOR, DIAL_CEILING);

        Debug.Log(tookHit
            ? $"[ComfortRamp] That one was rough — settling back {step:F3}. dial {_difficulty:F2}"
            : $"[ComfortRamp] Clean run — opening the door {step:F3} wider. dial {_difficulty:F2}");
    }
}
```

**Run it.** Hold a finger over C and read the step sizes as they print:
roughly 0.045, 0.062, 0.082, 0.103, 0.125… then back down 0.116, 0.093, 0.066,
0.041 as the dial closes on the ceiling. That swell-and-settle *is* the
logistic curve, and it is why this ramp can run forever without ever going
vertical. Tap H anywhere along the way: the retreat uses the same step, so the
system is exactly as forgiving as it is ambitious.

### Step 3 — let the dial drive something (and print like it means it)

One idea: a dial is only a difficulty system once it *drives* the game's
numbers. We map d onto two of them with Lesson 2's honest lerp — runner speed
(up from gentle to full) and the gap between obstacles (down from generous to
tight) — and we keep Lesson 1's promise: the gap may never dip below the
warning distance owed at the current speed. This is the finished file
(identical to [`starter/ComfortRamp.cs`](starter/ComfortRamp.cs)):

```csharp
/*  ComfortRamp.cs — World 6 · EXTR, run! · Lesson 3 (Difficulty as comfort)
 *  ---------------------------------------------------------------------------
 *  What it does: keeps a difficulty dial (0..1) that moves the way EXTR, run!
 *  moves it — one gentle step up after a run with no hits, one step back after
 *  a rough run. Steps follow Verhulst's logistic rule (step = r * d * (1 - d)),
 *  so the dial saturates instead of exploding. Press C to report a clean run,
 *  H to report a run that took a hit; the Console prints every decision.
 *  Setup: empty scene -> one cube -> attach this script -> press Play.
 *  One thing to try: lower Growth Rate to 0.1 and feel the ramp turn glacial.
 */

using UnityEngine;

public class ComfortRamp : MonoBehaviour
{
    // Lesson 1's fairness budget: cautious human reaction + device margin.
    private const float REACTION_BUDGET_SECONDS = 0.3f;

    // The dial never parks at 0 or 1 — Verhulst's step is zero there.
    private const float DIAL_FLOOR = 0.02f;
    private const float DIAL_CEILING = 0.98f;

    [Header("The dial")]
    [SerializeField, Range(0.05f, 0.5f), Tooltip("d — where the difficulty dial starts, as a fraction of the way to the ceiling.")]
    private float _startDifficulty = 0.1f;

    [SerializeField, Range(0.05f, 1f), Tooltip("r — how eagerly the dial moves per step. Verhulst: step = r * d * (1 - d).")]
    private float _growthRate = 0.5f;

    [Header("What the dial drives")]
    [SerializeField, Tooltip("Runner speed when the dial reads 0, in metres per second.")]
    private float _gentleSpeed = 6f;
    [SerializeField, Tooltip("Runner speed when the dial reads 1, in metres per second.")]
    private float _fullSpeed = 12f;
    [SerializeField, Tooltip("Metres between obstacles when the dial reads 0.")]
    private float _generousGap = 20f;
    [SerializeField, Tooltip("Metres between obstacles when the dial reads 1. Lesson 1's fairness floor still applies.")]
    private float _tightGap = 6f;

    private float _difficulty;   // d — the dial itself

    private void Start()
    {
        _difficulty = _startDifficulty;
        Debug.Log($"[ComfortRamp] Starting settled. {Describe()}");
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.C)) ReportRun(tookHit: false);
        if (Input.GetKeyDown(KeyCode.H)) ReportRun(tookHit: true);
    }

    /// <summary>The house rule: comfort earns the next step — never the clock.</summary>
    public void ReportRun(bool tookHit)
    {
        float step = _growthRate * _difficulty * (1f - _difficulty);   // Verhulst 1838
        _difficulty = Mathf.Clamp(_difficulty + (tookHit ? -step : step),
                                  DIAL_FLOOR, DIAL_CEILING);

        Debug.Log(tookHit
            ? $"[ComfortRamp] That one was rough — settling back {step:F3}. {Describe()}"
            : $"[ComfortRamp] Clean run — opening the door {step:F3} wider. {Describe()}");
    }

    private string Describe()
    {
        // Mathf.Lerp is Lesson 2's honest lerp: from + (to - from) * fraction.
        float speed = Mathf.Lerp(_gentleSpeed, _fullSpeed, _difficulty);
        float gap = Mathf.Lerp(_generousGap, _tightGap, _difficulty);
        gap = Mathf.Max(gap, speed * REACTION_BUDGET_SECONDS);   // owed sight, always
        return $"dial {_difficulty:F2} -> speed {speed:F1} m/s, gap {gap:F1} m";
    }

    private void OnGUI()
    {
        GUI.Label(new Rect(12, 12, 560, 44),
            $"C = report a clean run    H = report a run that took a hit\n{Describe()}");
    }
}
```

**Run it.** The label shows the whole state of the game's kindness at a glance,
and every C or H prints a full sentence:

```
[ComfortRamp] Clean run — opening the door 0.045 wider. dial 0.15 -> speed 6.9 m/s, gap 18.0 m
[ComfortRamp] That one was rough — settling back 0.062. dial 0.08 -> speed 6.5 m/s, gap 18.9 m
```

Read a few aloud. Notice what never happens: the dial never leaps, never
punishes a rough run with more than one settled step, and the gap never dips
below `speed × 0.3` — the sight the player is owed, inherited from Lesson 1 as
a hard floor no ambition may cross. Three lessons, one contract.

**You can stop here.** A comfort ramp printing its gentle decisions is the
finished system — the same rule, the same shape, and the same vocabulary as
the real game's. Everything below is bonus.

## Go deeper (optional)

### The bag (dealing, not rolling)

The other half of "never punishes" is taming randomness. With four obstacle
types drawn independently, each draw has a 1-in-4 chance of repeating the last,
so the *pair* of draws after any obstacle has a 1-in-16 chance of forming a
triple — over a thousand-obstacle run, dozens of identical walls of the same
demand, purely by dice. No tuning fixes that, because dice have no memory.

The fix is the **shuffle bag**: put one copy of every obstacle type in a bag,
shuffle, deal until empty, refill, repeat. Modern Tetris does exactly this with
its seven pieces — the Guideline's "Random Generator", the community-documented
"7-bag" — which is design lore worth stealing from, not academia. Two
guarantees come free, and you can prove both on your fingers:

- **Streaks stop at two.** Inside a bag there are no repeats; the worst case is
  the last item of one bag matching the first of the next.
- **Nothing droughts.** With four types, any window of eight consecutive draws
  contains a complete bag, so every type appears; two copies of the same
  obstacle are never more than six strangers apart. (For Tetris's seven, the
  same arithmetic gives the famous twelve.)

```csharp
using System.Collections.Generic;
using UnityEngine;

/// A cloth bag of obstacle names: every type goes in, the bag is shuffled,
/// items come out one at a time, and the bag refills only when empty.
/// Weighted version: add extra copies ("hop", "hop", "slide", "spin").
public class ShuffleBag
{
    private readonly List<string> _master = new List<string>();
    private readonly List<string> _bag = new List<string>();

    public ShuffleBag(params string[] items) { _master.AddRange(items); }

    public string Draw()
    {
        if (_bag.Count == 0) Refill();
        string item = _bag[_bag.Count - 1];
        _bag.RemoveAt(_bag.Count - 1);
        return item;
    }

    private void Refill()
    {
        _bag.AddRange(_master);
        // The classic swap shuffle: walk backwards, swap each slot
        // with a randomly chosen slot at or before it.
        for (int i = _bag.Count - 1; i > 0; i--)
        {
            int j = Random.Range(0, i + 1);
            (_bag[i], _bag[j]) = (_bag[j], _bag[i]);
        }
    }
}
```

To feel it, a five-minute tester on the same cube — press Space and read the
Console; try to catch it dealing three of anything:

```csharp
using UnityEngine;

public class BagTester : MonoBehaviour
{
    private ShuffleBag _bag;

    private void Start()
    {
        _bag = new ShuffleBag("hop", "hop", "slide", "spin");
    }

    private void Update()
    {
        if (Input.GetKeyDown(KeyCode.Space))
            Debug.Log($"[Bag] next obstacle: {_bag.Draw()}");
    }
}
```

(That bag is weighted: "hop" appears twice per deal, so hops are common the way
a designer chooses, not the way dice stumble.)

### And further still

- **Question:** why keep `DIAL_FLOOR` above zero? Try setting it to 0, tapping
  H to the bottom, and then tapping C — the Console will show you Verhulst's
  honest weakness.
- **Question:** with an unweighted 4-bag, streaks stop at two. What is the
  longest streak the *weighted* bag above can deal?
- **Open prompt:** speed and gaps are two things a dial can drive — what else
  could "difficulty" mean in a game that refuses to punish? (Weather? Music?
  How talkative the bosses' notes are?) And name one number the dial must
  *never* be allowed to touch.

## Check yourself

1. With r = 0.5, how big is the Verhulst step at d = 0.5 — and is any step
   anywhere bigger?
2. Your player finishes three clean runs, then one rough one. Where is the
   dial relative to where it stood after the second clean run?
3. An unweighted 4-item shuffle bag has been dealing for an hour. What is the
   longest possible streak of identical obstacles it has ever produced?

## Sources

- **Primary (free):** Jenova Chen (2006), "Flow in Games", MFA thesis,
  University of Southern California — free online; maps difficulty-versus-skill
  onto the flow channel and argues for difficulty that adapts to the player.
  Behind it: M. Csikszentmihalyi, *Flow* (1990), which named the channel.
- **Historical (name + date):** P. Verhulst (1838) — the logistic function:
  growth proportional to what's there and to the room left, the reason our
  ramp saturates.
- **Design lore:** the Tetris Guideline's "Random Generator" (7-bag),
  community-documented — the shuffle bag's most famous deployment; lore, not
  academia, and we cite it as such.
- **The game's own:** "EXTR, run! design documentation (in development)" — the
  comfort-ramp rule quoted in this lesson ("advance a step only when a level is
  completed without taking a hit… comfort, not the clock") and the framing that
  the bosses' adjustments are curious observation, never judgement.

---

*Answers, tucked at the very bottom so your eye doesn't trip over them:*

<details>
<summary>Reveal answers</summary>

1. 0.5 × 0.5 × 0.5 = **0.125** — and no, that is the maximum: d × (1 − d) peaks
   at d = 0.5, which is exactly why the ramp is boldest in the middle and
   gentle at both ends.
2. **One Verhulst step below** where the third clean run left it — which is
   *near*, but not exactly, where it stood after the second, because step sizes
   change with d. The retreat is one step, never a punishment multiplier.
3. **Two.** Within a bag every type appears once, so a streak can only form
   across a bag boundary: the last deal of one bag matching the first of the
   next. Three in a row would need a repeat inside a bag, which dealing forbids.

</details>

---

*Lesson text: [CC BY 4.0](../LICENSE-docs) — attribute to "esorhizome OÜ, Six Small Worlds". Code within it: [MIT](../LICENSE).*
