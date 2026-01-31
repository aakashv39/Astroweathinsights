"""
Tajik Varshesh (Lord of the Year) engine – using your 5-candidate logic.

Lord of the Year will always be chosen *within the context of*:

  1) Birth-chart Lagnesh (BC Lagnesh)
  2) Varshphal (VF) Lagnesh
  3) Munthesh
  4) Tri-Rashi-Pati (from your Aries…Pisces table)
  5) Din/Ratri Pati (from Sun/Moon sign at VF time)

SELECTION RULES (your Hindi notes):

1)  Panch-Vargiya Bala se sabse strong kaun hai
    → among these 5 candidates, pick highest Viswa Bala (VB).

2)  Vo planet VF Lagna se 2, 6, 8, 12 nahi hona chahiye
    → candidate must NOT be placed in 2, 6, 8, 12 from VF Lagna.

3)  Moon normally will NEVER become Lord of the Year.
    → If Moon is strongest it is skipped, and next qualified planet is Varshesh,
      EXCEPT special Moon-cases (below).

4)  Koi bhi planet jiska VB < 5, vo Lord of the Year ke liye qualified nahi hai.

5)  Moon Lord of the Year 2 tarah se banta hai (from your “When Moon can become
    Lord of the year” board):
      A) VF Lagna = Cancer, Moon in Lagna, Moon has highest VB.
      B) Night chart, Tri-Rashi-Pati = Moon, Moon has highest VB and aspects Lagna.

6)  Agar koi planet bhi qualify nahi karta
    → Munthesh hi banega Lord of the Year.

Additional VF sheet:
  - If no candidate planet is *Tajik aspecting Lagna* → Munthesh.

This file keeps Tri-Rashi-Pati and Din/Ratri-Pati calculations in
separate helpers and prints detailed logs for debugging.
"""

from typing import Tuple, Dict, List
from core.aspects import get_tajik_aspect
from core.utils import house_distance_12


# -------------------------------------------------------
# Tri-Rashi-Pati table  (from your handwritten Aries…Pisces sheet)
# key = VF Lagna sign (1..12), value = (day_pati, night_pati)
# -------------------------------------------------------
TRI_RASHI_PATI_TABLE = {
    1: ("Sun", "Jupiter"),
    2: ("Venus", "Moon"),
    3: ("Saturn", "Mercury"),
    4: ("Venus", "Mars"),
    5: ("Jupiter", "Sun"),
    6: ("Moon", "Venus"),
    7: ("Mercury", "Saturn"),
    8: ("Mars", "Venus"),
    9: ("Saturn", "Saturn"),
    10: ("Mars", "Mars"),
    11: ("Jupiter", "Jupiter"),
    12: ("Moon", "Moon"),
}


# -------------------------------------------------------
# Generic helpers
# -------------------------------------------------------
def _house_from_sign(vf_lagna: int, sign: int) -> int:
    """House number (1..12) of a sign from VF Lagna."""
    return house_distance_12(vf_lagna, sign)


def _is_day_chart(varsh_chart) -> bool:
    """
    Day / Night definition you used before:
    Sun in houses 7–12 from VF Lagna → DAY, else NIGHT.
    """
    vf_lagna = varsh_chart.lagna_sign
    sun = varsh_chart.planets["Sun"]
    house = _house_from_sign(vf_lagna, sun.sign)
    return 7 <= house <= 12


def _tajik_aspects_lagna(varsh_chart, planet, vf_lagna: int) -> bool:
    """True if planet has an active Tajik aspect with Lagna."""
    class _LagnaDummy:
        name = "Lagna"
        sign = vf_lagna
        degree = varsh_chart.lagna_degree

    asp = get_tajik_aspect(planet, _LagnaDummy)
    return asp["category"] != "none" and asp["active"]


# -------------------------------------------------------
# Separate calculators for Tri-Rashi-Pati and Din/Ratri-Pati
# -------------------------------------------------------
def compute_tri_rashi_pati(vf_lagna: int, is_day: bool) -> str:
    """
    Tri-Rashi-Pati from VF Lagna using your table screenshot.
    Only depends on VF Lagna sign and Day/Night.
    """
    day_pati, night_pati = TRI_RASHI_PATI_TABLE[vf_lagna]
    return day_pati if is_day else night_pati


def compute_din_ratri_pati(varsh_chart, is_day: bool) -> str:
    """
    Din/Ratri Pati from your second screenshot:

        Solar Return / Tajik VF Time
        1) Day   → Sun ke sign ka lord
        2) Night → Moon ke sign ka lord
    """
    if is_day:
        sign = varsh_chart.planets["Sun"].sign
    else:
        sign = varsh_chart.planets["Moon"].sign
    return varsh_chart.sign_lords[sign]


# -------------------------------------------------------
# Moon special-case logic (when Moon *can* be Lord of Year)
# -------------------------------------------------------
def _moon_allowed_as_varshesh(
    vf_lagna: int,
    is_day: bool,
    tri_rashi_pati: str,
    moon_vb: float,
    max_vb: float,
    moon_aspects_lagna: bool,
) -> bool:
    """
    Implement your “When Moon can become Lord of the year” board:

      A) VF Lagna = Cancer rising
         Moon in Lagna
         Moon PVB highest

      B) Night time &
         Tajik Rashi Pati = Moon
         Moon should be strongest (highest PVB) & aspecting Lagna
    """
    # Condition A: VF Lagna = Cancer(4), Moon in Lagna handled in caller.
    cond_A = (vf_lagna == 4 and moon_vb >= max_vb)

    # Condition B: night + tri-rashi-pati = Moon + highest VB + aspects Lagna
    cond_B = (
        (not is_day)
        and (tri_rashi_pati == "Moon")
        and (moon_vb >= max_vb)
        and moon_aspects_lagna
    )

    return cond_A or cond_B


# -------------------------------------------------------
# MAIN: Varshesh selection
# -------------------------------------------------------
def find_varshesh(
    varsh_chart,
    natal_chart,
    bala_table: Dict[str, Dict[str, float]],
    vf_lagna: int,
    muntesh: str,
) -> Tuple[str, str]:
    """
    Determine Varshesh (Lord of the Year) USING ONLY:

        BC Lagnesh, VF Lagnesh, Munthesh, Tri-Rashi-Pati, Din/Ratri-Pati

    and the rules you listed.

    Returns:
        (varshesh_name, explanation_text)
    """

    print("\n================ VARSHESH SELECTION ==================")
    print(f"VF Lagna sign : {vf_lagna}")

    # --- Day / Night ---
    is_day = _is_day_chart(varsh_chart)
    print(f"Day/Night     : {'DAY' if is_day else 'NIGHT'}")

    # --- BC Lagnesh (birth chart) ---
    bc_lagna_sign = natal_chart.lagna_sign
    bc_lagnesh = natal_chart.sign_lords[bc_lagna_sign]
    print(f"BC Lagna sign : {bc_lagna_sign}  → BC Lagnesh: {bc_lagnesh}")

    # --- VF Lagnesh (varsh chart) ---
    vf_lagnesh = varsh_chart.sign_lords[vf_lagna]
    print(f"VF Lagnesh    : {vf_lagnesh}")

    # --- Tri-Rashi-Pati & Din/Ratri-Pati ---
    tri_rashi_pati = compute_tri_rashi_pati(vf_lagna, is_day)
    din_ratri_pati = compute_din_ratri_pati(varsh_chart, is_day)

    print(f"Tri-Rashi-Pati: {tri_rashi_pati}  (from VF Lagna table)")
    print(f"Din/Ratri Pati: {din_ratri_pati}  (from Sun/Moon sign rule)")

    # --- Munthesh (given from main) ---
    print(f"Munthesh      : {muntesh}")

    # ---------------------------------------------------
    # 1. Build candidate list (5 contextual planets)
    # ---------------------------------------------------
    candidates: List[str] = []
    for name in (bc_lagnesh, vf_lagnesh, muntesh, tri_rashi_pati, din_ratri_pati):
        if name and name not in candidates:
            candidates.append(name)

    print("\n[Step 1] Candidate planets (context set):")
    print("  " + ", ".join(candidates))

    # ---------------------------------------------------
    # 2. Attach VB, houses, aspects
    # ---------------------------------------------------
    print("\n[Step 2] Panch-Vargiya Bala + house + Tajik aspect to Lagna:")
    info = {}
    any_aspect_to_lagna = False
    max_vb_overall = 0.0

    for name in candidates:
        vb = bala_table.get(name, {}).get("VB", 0.0)
        max_vb_overall = max(max_vb_overall, vb)

        planet = varsh_chart.planets[name]
        house = _house_from_sign(vf_lagna, planet.sign)
        aspects_lagna = _tajik_aspects_lagna(varsh_chart, planet, vf_lagna)

        any_aspect_to_lagna = any_aspect_to_lagna or aspects_lagna

        info[name] = {
            "vb": vb,
            "house": house,
            "aspects_lagna": aspects_lagna,
        }

        print(
            f"  {name:7}  VB={vb:5.2f}  house(from VF Lagna)={house:2d}  "
            f"Tajik aspect Lagna? {aspects_lagna}"
        )

    # If no candidate aspects Lagna at all → direct Munthesh
    if not any_aspect_to_lagna:
        print("\n[Rule] No planet is aspecting Lagna → Varshesh = Munthesh.")
        return muntesh, "No candidate aspects Lagna → Munthesh is Lord of the Year"

    # ---------------------------------------------------
    # 3. Apply qualification filters (VB & 2/6/8/12 rule)
    # ---------------------------------------------------
    print("\n[Step 3] Apply qualification rules (VB >= 5 & not in 2,6,8,12):")
    qualified: List[Tuple[str, float]] = []

    for name in candidates:
        vb = info[name]["vb"]
        h = info[name]["house"]

        if vb < 5.0:
            print(f"  {name:7} REJECT  (VB={vb:.2f} < 5)")
            continue
        if h in (2, 6, 8, 12):
            print(f"  {name:7} REJECT  (placed in {h} from Lagna: 2/6/8/12 blocked)")
            continue

        print(f"  {name:7} ACCEPT  (VB={vb:.2f}, house={h})")
        qualified.append((name, vb))

    if not qualified:
        print("\n[Rule] No planet qualifies by VB and 2/6/8/12 → Varshesh = Munthesh.")
        return muntesh, "No planet qualified (VB/house rules) → Munthesh is Lord of the Year"

    # ---------------------------------------------------
    # 4. Sort qualified by VB (strongest first)
    # ---------------------------------------------------
    qualified.sort(key=lambda x: x[1], reverse=True)
    print("\n[Step 4] Qualified candidates sorted by VB:")
    for name, vb in qualified:
        print(f"  {name:7} VB={vb:.2f}")

    # ---------------------------------------------------
    # 5. Moon rule (generally not Lord of Year)
    # ---------------------------------------------------
    print("\n[Step 5] Moon rule (normally rejected):")
    # check if Moon is among qualified and is top
    top_name, top_vb = qualified[0]

    moon_present = any(n == "Moon" for n, _ in qualified)
    if moon_present:
        moon_vb = info["Moon"]["vb"]
        moon_house = info["Moon"]["house"]
        moon_aspects = info["Moon"]["aspects_lagna"]

        print(
            f"  Moon present: VB={moon_vb:.2f}, house={moon_house}, "
            f"aspects Lagna? {moon_aspects}"
        )

        # can Moon be allowed by special rules?
        if "Moon" in candidates:
            moon_can_be = _moon_allowed_as_varshesh(
                vf_lagna=vf_lagna,
                is_day=is_day,
                tri_rashi_pati=tri_rashi_pati,
                moon_vb=moon_vb,
                max_vb=max_vb_overall,
                moon_aspects_lagna=moon_aspects,
            )
        else:
            moon_can_be = False

        if moon_can_be:
            print("  → Moon satisfies special conditions → Moon CAN be Varshesh.")
            if top_name == "Moon":
                return "Moon", "Moon qualifies by special Tajik rules"
        else:
            print("  → Moon does NOT satisfy special conditions → never Varshesh.")
            # remove Moon from qualified list
            qualified = [(n, vb) for n, vb in qualified if n != "Moon"]

    else:
        print("  → Moon not in qualified list, no special handling needed.")

    if not qualified:
        print("\n[Rule] After removing Moon, no candidate left → Varshesh = Munthesh.")
        return muntesh, "Only Moon was qualifying; Moon disallowed → Munthesh is Lord of the Year"

    # re-identify top (after possible Moon removal)
    top_name, top_vb = qualified[0]
    print(f"\n[Step 6] Final strongest candidate by VB: {top_name} (VB={top_vb:.2f})")

    # tie case with second candidate
    if len(qualified) > 1 and qualified[1][1] == top_vb:
        other_name, other_vb = qualified[1]
        print(f"  Tie with {other_name} (VB={other_vb:.2f}) → check Tajik aspect strength.")

        a1 = info[top_name]["aspects_lagna"]
        a2 = info[other_name]["aspects_lagna"]

        print(f"    {top_name:7} aspects Lagna? {a1}")
        print(f"    {other_name:7} aspects Lagna? {a2}")

        if a1 and not a2:
            print(f"  → {top_name} wins tie (aspects Lagna).")
            return top_name, "VB tie – chosen because it aspects Lagna"

        if a2 and not a1:
            print(f"  → {other_name} wins tie (aspects Lagna).")
            return other_name, "VB tie – chosen because it aspects Lagna"

        # perfect tie → keep first by VB ranking
        print("  → Perfect tie (both/none aspect Lagna) – keeping first by VB order.")

    print(f"\n[Result] Varshesh (Lord of the Year): {top_name}")
    return top_name, "Highest Viswa Bala among 5 contextual planets (VB≥5, not in 2/6/8/12)"
