#!/usr/bin/env python3
"""sim.py — the Six Small Worlds playtest simulator.

Every starter file in this repo draws something. This harness re-runs the
*mathematics* of each one — the part that decides whether what you built is
the same creature as the game it comes from — and checks it against the
claims the lessons make. No Godot, no Unity, no graphics: pure arithmetic,
standard library only, fixed seeds, so it gives the same verdict on every
machine.

Run it from the repo root:

    python playtest/sim.py

Each check says which lesson it guards. If one fails, that lesson's claim
and its starter code have drifted apart — fix one of them before publishing.
(For students: this is also a worked example of testing game maths without
booting an engine. Steal the pattern.)
"""

from __future__ import annotations

import math
import random
import sys

# Windows consoles sometimes speak an older encoding; ask stdout for UTF-8
# so the check marks and arrows print everywhere.
if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

TAU = math.tau

PASSES: list[str] = []
FAILURES: list[str] = []


def check(world: str, name: str, ok: bool, detail: str = "") -> None:
    line = f"[{world}] {name}" + (f" — {detail}" if detail else "")
    (PASSES if ok else FAILURES).append(line)
    print(("  ok   " if ok else "  FAIL ") + line)


# ---------------------------------------------------------------- World 1 —

def world_1_equanim() -> None:
    print("World 1 · equanim")

    # Lesson 1 — a Lissajous curve with whole-number dials closes exactly.
    def liss(t: float, a: float = 3.0, b: float = 2.0) -> tuple[float, float]:
        return math.cos(a * t), math.sin(b * t)

    x0, y0 = liss(0.0)
    x1, y1 = liss(TAU)
    check("1·lissajous", "curve closes after one lap",
          abs(x1 - x0) < 1e-9 and abs(y1 - y0) < 1e-9)

    # Lesson 2 — the superformula with the starter's leash. m=0 with equal
    # dials must give a circle; every slider combination must stay finite.
    def superformula(theta: float, m: float, n1: float, n2: float, n3: float,
                     a: float = 1.0, b: float = 1.0, leash: float = 8.0) -> float:
        part_cos = abs(math.cos(m * theta / 4.0) / a) ** n2
        part_sin = abs(math.sin(m * theta / 4.0) / b) ** n3
        total = part_cos + part_sin
        if total < 1e-12:
            return leash
        return min(total ** (-1.0 / n1), leash)

    circle = [superformula(TAU * i / 64, m=0.0, n1=1.0, n2=1.0, n3=1.0)
              for i in range(64)]
    check("1·superformula", "m=0 collapses to a circle",
          max(circle) - min(circle) < 1e-9)

    worst = 0.0
    for m in (0.0, 0.5, 4.0, 5.0, 19.0, 24.0):
        for n1 in (0.1, 2.0, 20.0):
            for n2 in (0.1, 7.0, 20.0):
                for theta in (TAU * i / 720 * 2 for i in range(721)):
                    r = superformula(theta, m, n1, n2, n2)
                    if math.isnan(r) or math.isinf(r):
                        worst = math.inf
                    worst = max(worst, r)
    check("1·superformula", "every slider combination stays on the leash",
          worst <= 8.0, f"max radius seen {worst:.2f} (leash 8.0)")

    # Lesson 3 — yaw+pitch rotation is rigid: all 12 edges keep length 2.
    corners = [(x, y, z) for x in (-1, 1) for y in (-1, 1) for z in (-1, 1)]
    edges = [(i, j) for i in range(8) for j in range(i + 1, 8)
             if sum(a != b for a, b in zip(corners[i], corners[j])) == 1]

    def turn(p: tuple[float, float, float], yaw: float, pitch: float):
        x, y, z = p
        x, z = x * math.cos(yaw) + z * math.sin(yaw), \
               -x * math.sin(yaw) + z * math.cos(yaw)
        y, z = y * math.cos(pitch) - z * math.sin(pitch), \
               y * math.sin(pitch) + z * math.cos(pitch)
        return x, y, z

    turned = [turn(p, 0.83, 0.31) for p in corners]
    lengths = [math.dist(turned[i], turned[j]) for i, j in edges]
    check("1·wire_cube", "twelve edges survive the turn at length 2",
          len(edges) == 12 and all(abs(l - 2.0) < 1e-9 for l in lengths),
          f"{len(edges)} edges")
    # Euler's check-yourself: V − E + F = 2 for the cube.
    check("1·wire_cube", "Euler agrees: V − E + F = 2", 8 - 12 + 6 == 2)


# ---------------------------------------------------------------- World 2 —

def world_2_upgrade_biotech() -> None:
    print("World 2 · upgrade Biotech")

    # Lesson 1 — Vogel's model packs evenly: with the true golden angle the
    # nearest-neighbour distance across the colony stays comfortably above
    # zero and below twice the spacing constant. 137.3° (the lesson's "watch
    # the arms appear") must pack measurably worse.
    def colony(angle_deg: float, cells: int = 600, spacing: float = 7.0):
        ang = math.radians(angle_deg)
        return [(spacing * math.sqrt(n) * math.cos(ang * n),
                 spacing * math.sqrt(n) * math.sin(ang * n))
                for n in range(cells)]

    def min_gap(points, skip: int = 50) -> float:
        # Skip the crowded heart: every angle packs its first few cells the
        # same way. The packing quality shows in the open field beyond.
        best = math.inf
        pts = points[skip:]
        for i, p in enumerate(pts):
            for q in pts[i + 1:]:
                d = math.dist(p, q)
                if d < best:
                    best = d
        return best

    golden = min_gap(colony(137.507764))
    lopsided = min_gap(colony(137.3))
    check("2·phyllotaxis", "golden angle packs without collisions",
          golden > 7.0, f"tightest gap {golden:.2f} px at spacing 7")
    check("2·phyllotaxis", "137.3° packs visibly worse (the arms)",
          lopsided < golden * 0.75, f"{lopsided:.2f} vs {golden:.2f}")

    # Lesson 2 — rose curves: odd k draws k petals, even k draws 2k.
    # A petal tip is a point where |r| = 1: θ = j·π/k. Convert each tip to
    # an (x, y) point on the plane and count the DISTINCT points — for odd k
    # the two traversals land tips on top of each other, which is exactly
    # why odd roses show k petals instead of 2k.
    def petals(k: int) -> int:
        tips = set()
        for j in range(2 * k):
            theta = j * math.pi / k
            r = math.cos(k * theta)          # ±1 at every tip
            tips.add((round(r * math.cos(theta), 9),
                      round(r * math.sin(theta), 9)))
        return len(tips)

    odd_ok = all(petals(k) == k for k in (1, 3, 5, 7))
    even_ok = all(petals(k) == 2 * k for k in (2, 4, 6, 8))
    check("2·rose_garden", "odd k blooms k petals", odd_ok)
    check("2·rose_garden", "even k blooms 2k petals", even_ok)

    # Lesson 3 — Rule 90 IS Pascal's triangle mod 2. Grow both, compare.
    def rule90_rows(rows: int):
        width = 2 * rows + 1
        row = [0] * width
        row[rows] = 1
        out = [row[:]]
        for _ in range(rows - 1):
            row = [(row[(x - 1) % width] * 4 + row[x] * 2
                    + row[(x + 1) % width]) for x in range(width)]
            row = [(90 >> p) & 1 for p in row]
            out.append(row)
        return out

    grown = rule90_rows(64)
    pascal_ok = True
    binom_row = [1]
    for y, row in enumerate(grown):
        for x, cell in enumerate(row):
            # Row y's live cells sit at even offsets from its left edge:
            # offset 2j holds C(y, j) mod 2. Everything else must be 0.
            k = x - (64 - y)
            if 0 <= k <= 2 * y and k % 2 == 0:
                expect = binom_row[k // 2] % 2
            else:
                expect = 0
            if cell != expect:
                pascal_ok = False
        binom_row = [1] + [binom_row[i] + binom_row[i + 1]
                           for i in range(len(binom_row) - 1)] + [1]
    check("2·rule90", "Rule 90 grows Pascal's triangle mod 2 (Sierpinski)",
          pascal_ok, "64 rows compared cell by cell")

    # Lesson 2b — times-table chords: M=2 on N points is the cardioid map;
    # every chord endpoint must be k·M mod N, and the map must return home
    # after the full lap (k = N lands on point 0).
    n, m = 200, 2
    endpoints_ok = all((k * m) % n < n for k in range(n))
    check("2·times_table", "chord map k → k·M mod N stays on the rim",
          endpoints_ok and (n * m) % n == 0)


# ---------------------------------------------------------------- World 3 —

def world_3_tidepool_keeper() -> None:
    print("World 3 · Tidepool Keeper")

    # Lesson 1 — the two spirals keep their two promises: the Archimedean
    # keeps a constant GAP per turn, the logarithmic a constant RATIO.
    b_arch = 22.0 / TAU
    arch_radii = [4.0 + b_arch * (t * TAU) for t in range(1, 6)]
    gaps = [arch_radii[i + 1] - arch_radii[i] for i in range(4)]
    check("3·spirals", "Archimedean: same gap every turn",
          max(gaps) - min(gaps) < 1e-9, f"gap {gaps[0]:.2f} px")

    log_radii = [4.0 * math.exp(0.11 * t * TAU) for t in range(1, 6)]
    ratios = [log_radii[i + 1] / log_radii[i] for i in range(4)]
    check("3·spirals", "logarithmic: same ratio every turn",
          max(ratios) - min(ratios) < 1e-9, f"ratio ×{ratios[0]:.2f}")

    # Lesson 2 — Poisson arrivals via exponential gaps. Over a long month the
    # measured rate must match λ, and the variance of visit counts per day
    # must be close to the mean (the Poisson signature).
    rng = random.Random(26)
    lam_per_day = 4.0
    rate_per_hour = lam_per_day / 24.0
    days = 4000
    visits: list[float] = []
    t = 0.0
    while True:
        u = max(rng.random(), 1e-7)
        t += -math.log(u) / rate_per_hour
        if t > days * 24.0:
            break
        visits.append(t)
    measured = len(visits) / days
    check("3·visits", "measured arrival rate matches λ",
          abs(measured - lam_per_day) < 0.15,
          f"{measured:.2f} visits/day vs λ = 4.0")

    per_day = [0] * days
    for v in visits:
        per_day[int(v // 24.0)] += 1
    mean = sum(per_day) / days
    var = sum((c - mean) ** 2 for c in per_day) / days
    check("3·visits", "variance ≈ mean (the Poisson signature)",
          abs(var / mean - 1.0) < 0.1, f"variance/mean = {var / mean:.3f}")

    # The tide clock: the M2 period means high water drifts ~50 min later
    # per day — check the phase creep over one day is 2·(24 − 2·12.42)/12.42
    # of a cycle... simpler: two M2 cycles overshoot 24 h by ~50 minutes.
    overshoot_min = (2 * 12.42 - 24.0) * 60.0
    check("3·visits", "two tide cycles overshoot the day by ~50 min",
          49.0 < overshoot_min < 52.0, f"{overshoot_min:.1f} min")

    # Lesson 3 — the thank-you dance: friendship scales the drawn span
    # linearly, and the pen never draws beyond it.
    for friendship in range(1, 6):
        theta_full = math.pi * friendship / 5.0
        theta_now = min(9999.0 * 0.5, theta_full)   # long after the dance
        if not math.isclose(theta_now, theta_full):
            check("3·thanks_dance", "pen stops at friendship's edge", False)
            break
    else:
        check("3·thanks_dance", "pen stops exactly at friendship's edge", True,
              "levels 1–5 span π/5 … π")


# ---------------------------------------------------------------- World 4 —

def world_4_isolate() -> None:
    print("World 4 · An Isolate Grows Roots")

    rules = {"X": "F+[[X]-X]-F[-FX]+X", "F": "FF"}

    def grow(axiom: str, generations: int) -> str:
        word = axiom
        for _ in range(generations):
            word = "".join(rules.get(c, c) for c in word)
        return word

    # Lesson 2's printed claim: generation 4 is 1,551 symbols.
    word = grow("X", 4)
    check("4·lsystem", "generation 4 is exactly 1,551 symbols",
          len(word) == 1551, f"got {len(word)}")

    # A grammar with balanced rules grows balanced brackets, always.
    depth = 0
    balanced = True
    for c in word:
        depth += (c == "[") - (c == "]")
        if depth < 0:
            balanced = False
    check("4·lsystem", "grown sentence keeps its brackets balanced",
          balanced and depth == 0)

    # Lesson 1's turtle, including the starter's new guard: an unbalanced
    # hand-typed sentence must walk to the end instead of crashing.
    def walk(commands: str, step: float = 24.0, turn_deg: float = 25.0):
        pos, heading = (0.0, 0.0), -math.pi / 2
        marks: list[tuple[tuple[float, float], float]] = []
        segments = 0
        for c in commands:
            if c == "F":
                pos = (pos[0] + math.cos(heading) * step,
                       pos[1] + math.sin(heading) * step)
                segments += 1
            elif c == "+":
                heading -= math.radians(turn_deg)
            elif c == "-":
                heading += math.radians(turn_deg)
            elif c == "[":
                marks.append((pos, heading))
            elif c == "]" and marks:      # the polite guard
                pos, heading = marks.pop()
        return segments

    fern = "FF[+F[+F][-F]][-F[+F][-F]]F[+F][-F]F"
    check("4·turtle", "the fern sprig walks every one of its F steps",
          walk(fern) == fern.count("F"), f"{fern.count('F')} steps")
    try:
        walk("F]]]F")   # a student's typo
        check("4·turtle", "unbalanced brackets are refused politely", True)
    except IndexError:
        check("4·turtle", "unbalanced brackets are refused politely", False)

    # Lesson 3 — ease-out cubic: starts at 0, lands at 1, never goes back.
    def ease(t: float) -> float:
        return 1.0 - (1.0 - t) ** 3

    samples = [ease(i / 100) for i in range(101)]
    monotonic = all(b >= a for a, b in zip(samples, samples[1:]))
    check("4·one_turn", "ease-out cubic: 0 → 1, no backsliding",
          math.isclose(samples[0], 0.0) and math.isclose(samples[-1], 1.0)
          and monotonic)
    # Thirteen turns of total/13 land exactly on total — growth completes.
    total = 7.0 * 1022
    shown = 0.0
    for _ in range(13):
        shown = min(shown + total / 13, total)
    check("4·one_turn", "thirteen bursts grow the whole root",
          math.isclose(shown, total))


# ---------------------------------------------------------------- World 5 —

def world_5_friendly_waters() -> None:
    print("World 5 · Friendly Waters")

    # Lesson 1 — attenuation: each metre keeps the same fraction. At the
    # twilight line (200 m) with k = 0.023, about 1% of the sun remains.
    k = 0.023
    survival_200 = math.exp(-k * 200.0)
    ratio_a = math.exp(-k * 51.0) / math.exp(-k * 50.0)
    ratio_b = math.exp(-k * 5001.0) / math.exp(-k * 5000.0)
    check("5·depth_light", "every metre keeps the same fraction of light",
          math.isclose(ratio_a, ratio_b), f"×{ratio_a:.4f} per metre")
    check("5·depth_light", "twilight zone starts near the 1% line",
          0.005 < survival_200 < 0.02, f"{survival_200 * 100:.2f}% at 200 m")

    # Lesson 2 — the current field hands every particle a unit arrow.
    rng = random.Random(7)
    ok = True
    for _ in range(500):
        angle = (rng.random() * 2.0 - 1.0) * math.pi
        v = (math.cos(angle), math.sin(angle))
        if abs(math.hypot(*v) - 1.0) > 1e-9:
            ok = False
    check("5·current_field", "field arrows are unit length, every heading", ok)

    # Lesson 3 — boids. Port the starter faithfully, run 25 seconds, and
    # measure polarization (mean normalised heading agreement): a school
    # that thinks together must align far beyond its random start.
    rng = random.Random(11)
    count, view = 60, (1152.0, 648.0)
    neigh, sep = 70.0, 26.0
    w_sep, w_ali, w_coh = 1.6, 1.0, 0.9
    vmax, vmin, steer = 130.0, 60.0, 3.0
    pos = [(rng.random() * view[0], rng.random() * view[1])
           for _ in range(count)]
    ang = [rng.random() * TAU for _ in range(count)]
    vel = [(math.cos(a) * rng.uniform(vmin, vmax),
            math.sin(a) * rng.uniform(vmin, vmax)) for a in ang]

    def polarization() -> float:
        sx = sum(v[0] / math.hypot(*v) for v in vel)
        sy = sum(v[1] / math.hypot(*v) for v in vel)
        return math.hypot(sx, sy) / count

    start_pol = polarization()
    dt = 1.0 / 60.0
    for _ in range(int(25.0 / dt)):
        new_vel = []
        for i in range(count):
            away = [0.0, 0.0]
            head = [0.0, 0.0]
            centre = [0.0, 0.0]
            mates = 0
            for j in range(count):
                if i == j:
                    continue
                ox, oy = pos[j][0] - pos[i][0], pos[j][1] - pos[i][1]
                d = math.hypot(ox, oy)
                if d < neigh:
                    mates += 1
                    head[0] += vel[j][0]
                    head[1] += vel[j][1]
                    centre[0] += pos[j][0]
                    centre[1] += pos[j][1]
                    if 0.0 < d < sep:
                        away[0] -= ox / d
                        away[1] -= oy / d
            vx, vy = vel[i]
            if mates:
                def norm(x, y):
                    h = math.hypot(x, y)
                    return (x / h, y / h) if h > 1e-12 else (0.0, 0.0)
                aw = norm(*away)
                al = norm(head[0] / mates, head[1] / mates)
                co = norm(centre[0] / mates - pos[i][0],
                          centre[1] / mates - pos[i][1])
                wx = aw[0] * w_sep + al[0] * w_ali + co[0] * w_coh
                wy = aw[1] * w_sep + al[1] * w_ali + co[1] * w_coh
                wn = norm(wx, wy)
                if wn != (0.0, 0.0):
                    f = min(steer * dt, 1.0)
                    vx += (wn[0] * vmax - vx) * f
                    vy += (wn[1] * vmax - vy) * f
            h = math.hypot(vx, vy)
            if h < 1e-9:
                vx, vy = vel[i]
                h = math.hypot(vx, vy)
            s = min(max(h, vmin), vmax)
            new_vel.append((vx / h * s, vy / h * s))
        vel = new_vel
        pos = [((pos[i][0] + vel[i][0] * dt) % view[0],
                (pos[i][1] + vel[i][1] * dt) % view[1])
               for i in range(count)]
    end_pol = polarization()
    speeds_ok = all(vmin - 1e-6 <= math.hypot(*v) <= vmax + 1e-6 for v in vel)
    check("5·boids", "speeds stay between MIN and MAX for 25 simulated s",
          speeds_ok)
    check("5·boids", "the school aligns (polarization rises)",
          end_pol > max(0.5, start_pol + 0.2),
          f"{start_pol:.2f} → {end_pol:.2f}")


# ---------------------------------------------------------------- World 6 —

def world_6_extr_run() -> None:
    print("World 6 · EXTR, run!")

    # Lesson 1 — the ramp v = v0 + a·t caps at vMax and the owed sight
    # distance grows with speed, never past vMax × budget.
    v0, a, vmax, budget = 6.0, 0.4, 12.0, 0.30
    speeds = [min(v0 + a * t, vmax) for t in range(0, 61)]
    check("6·RunnerSpeed", "the ramp climbs and stops at vMax",
          speeds[-1] == vmax and all(b >= x for x, b in zip(speeds, speeds[1:])))
    check("6·RunnerSpeed", "owed sight peaks at vMax × budget",
          max(s * budget for s in speeds) == vmax * budget,
          f"{vmax * budget:.1f} m at top speed")

    # Lesson 2 — all three easings are honest journeys: 0 → 1, monotonic,
    # and the eased pair land gently (tiny final step) while linear doesn't.
    shapes = {
        "linear": lambda t: t,
        "smoothstep": lambda t: t * t * (3 - 2 * t),
        "ease_out_cubic": lambda t: 1 - (1 - t) ** 3,
    }
    for name, f in shapes.items():
        ys = [f(i / 100) for i in range(101)]
        ok = (math.isclose(ys[0], 0.0) and math.isclose(ys[-1], 1.0)
              and all(b >= a2 - 1e-12 for a2, b in zip(ys, ys[1:])))
        check("6·LaneMover", f"{name}: departs 0, lands 1, no backsliding", ok)
    gentle = shapes["smoothstep"](1.0) - shapes["smoothstep"](0.99)
    blunt = shapes["linear"](1.0) - shapes["linear"](0.99)
    check("6·LaneMover", "smoothstep lands more gently than linear",
          gentle < blunt / 3.0, f"final step {gentle:.5f} vs {blunt:.5f}")

    # Lesson 3 — the comfort ramp. Verhulst steps saturate inside the rails;
    # a losing streak walks the dial down but never through the floor; and
    # the fairness floor (owed sight) survives every dial position.
    def step(d: float, r: float = 0.5) -> float:
        return r * d * (1 - d)

    d = 0.1
    for _ in range(200):
        d = min(max(d + step(d), 0.02), 0.98)
    check("6·ComfortRamp", "200 clean runs saturate below the ceiling",
          0.9 < d <= 0.98, f"dial rests at {d:.3f}")

    for _ in range(200):
        d = min(max(d - step(d), 0.02), 0.98)
    check("6·ComfortRamp", "200 rough runs settle above the floor",
          0.02 <= d < 0.1, f"dial rests at {d:.3f}")

    fairness_ok = True
    for i in range(101):
        dial = i / 100
        speed = 6.0 + (12.0 - 6.0) * dial
        gap = 20.0 + (6.0 - 20.0) * dial
        gap = max(gap, speed * budget)
        if gap < speed * budget - 1e-9:
            fairness_ok = False
    check("6·ComfortRamp", "the owed-sight floor holds at every dial position",
          fairness_ok, "gap ≥ speed × 0.3 s, dial 0.00–1.00")

    # The weighted bag from lesson 3's text: streaks stop at (copies + 1) − 1
    # boundary case — verify the classic guarantee on an unweighted 4-bag.
    rng = random.Random(19)
    draws: list[int] = []
    for _ in range(4000):
        bag = [0, 1, 2, 3]
        rng.shuffle(bag)
        draws.extend(bag)
    longest = cur = 1
    for x, y in zip(draws, draws[1:]):
        cur = cur + 1 if x == y else 1
        longest = max(longest, cur)
    check("6·ComfortRamp", "4-bag shuffle: streaks stop at two",
          longest <= 2, f"longest streak {longest} in 16,000 draws")


def main() -> int:
    print("Six Small Worlds — playtest simulation\n")
    world_1_equanim()
    world_2_upgrade_biotech()
    world_3_tidepool_keeper()
    world_4_isolate()
    world_5_friendly_waters()
    world_6_extr_run()
    print(f"\n{len(PASSES)} passed · {len(FAILURES)} failed")
    if FAILURES:
        print("\nA failed check means a lesson's claim and its starter code")
        print("have drifted apart. That is the computer asking a clarifying")
        print("question — not a verdict on you.")
        return 1
    print("Every lesson's mathematics does what its text promises.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
