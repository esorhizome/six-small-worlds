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

    // Min(0.01): at duration zero the maths divides by it — and a "move" of
    // 0.01 s is already indistinguishable from teleporting.
    [SerializeField, Min(0.01f), Tooltip("Seconds one lane change takes, whatever its shape.")]
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
        // (Max guards the maths even if a saved scene carries an old zero.)
        _elapsed += Time.deltaTime;
        float t = Mathf.Clamp01(_elapsed / Mathf.Max(_moveDuration, 0.01f));

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
