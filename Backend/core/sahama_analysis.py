# core/sahama_analysis.py
"""
Sahama strength + timing analysis for Varshaphal

Adds:
  • DEBUG_SAHAM flag (configurable logging)
  • log() helper — identical concept to Yogas logging

Outputs per Saham:
  • lord
  • strong / medium / weak
  • activation window in days
  • diagnostic notes
"""

from math import fabs
from typing import Dict, Tuple, List

# ------------------------------
# Debug Logging Toggle
# ------------------------------
DEBUG_SAHAM = True         # <==== set True when you want console logs
def log(*args):
    if DEBUG_SAHAM:
        print("[SAHAM]", *args)


def _circular_distance_deg(a: float, b: float) -> float:
    d = fabs(a - b) % 360.0
    return 360.0 - d if d > 180.0 else d


def compute_saham_window_days(saham_lon: float, lord_lon: float) -> Tuple[float, float]:
    A = _circular_distance_deg(saham_lon, lord_lon)
    B = 0.9 * A
    C = 1.1 * A
    return (min(B, C), max(B, C))


def classify_saham_strength(
    chart,
    bala_table: Dict[str, Dict[str, float]],
    sahamas: Dict[str, dict],
    varshesh: str = None,
    itthasala_yogs: List[str] = None,
) -> Dict[str, dict]:

    log("Starting Saham Analysis...")
    log("Varshesh:", varshesh)
    log("Available Sahamas:", list(sahamas.keys()))

    sign_lords = chart.sign_lords
    uchcha = getattr(chart, "uchcha_signs", {})
    mool = getattr(chart, "mooltrikona_signs", {})
    planet_house = getattr(chart, "planet_house", {})

    itthasala_yogs = itthasala_yogs or []
    eighth_lord = chart.house_lord[8]

    log("8th lord =", eighth_lord)

    result: Dict[str, dict] = {}

    for name, SA in sahamas.items():
        log("\n------------------------------------------")
        log("Evaluating Saham:", name)

        sign = SA["sign"]
        saham_lon = SA["longitude"]
        lord = sign_lords[sign]
        lord_obj = chart.planets[lord]
        lord_lon = lord_obj.longitude
        lord_house = planet_house.get(lord)
        vb = bala_table.get(lord, {}).get("VB", 0.0)

        notes = []
        # PVB strength
        if vb >= 12:
            strength = "strong"
            notes.append(f"High PVB (VB={vb:.2f})")
        elif vb >= 6:
            strength = "medium"
            notes.append(f"Medium PVB (VB={vb:.2f})")
        else:
            strength = "weak"
            notes.append(f"Weak PVB (VB={vb:.2f})")
        log("VB =", vb, " → ", strength)

        if uchcha.get(lord) == sign:
            strength = "strong"
            notes.append("Exalted")
            log("Exaltation")

        if mool.get(lord) == sign:
            strength = "strong"
            notes.append("Mooltrikona")
            log("Mooltrikona")

        if sign_lords[sign] == lord:
            if strength == "weak":
                strength = "medium"
            notes.append("Own sign")
            log("Own sign")

        if lord_house in (6, 8, 12):
            notes.append(f"Dusthana placement (House {lord_house})")
            strength = "weak"
            log("❌ Dusthana placement → weaken")

        if varshesh and varshesh == lord:
            if strength == "medium":
                strength = "strong"
            notes.append("Lord is Varshesh")
            log("Boost: Varshesh connection")

        weaken_by_8th = any(
            ("Itthasala" in y) and (lord in y) and (eighth_lord in y)
            for y in itthasala_yogs
        )
        if lord == eighth_lord or weaken_by_8th:
            notes.append("Connected to 8th lord → weak")
            strength = "weak"
            log("❌ Connected with 8th lord → downgrade")

        start, end = compute_saham_window_days(saham_lon, lord_lon)
        log("Activation window =", start, "to", end, "days")

        result[name] = {
            "lord": lord,
            "strength": strength,
            "window_days": (round(start, 1), round(end, 1)),
            "notes": "; ".join(notes),
        }

    log("\nFinished Saham Analysis.")
    return result
