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

    [SerializeField, Min(0f), Tooltip("a — how much speed grows every second (metres per second, per second).")]
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
