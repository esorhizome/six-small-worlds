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
