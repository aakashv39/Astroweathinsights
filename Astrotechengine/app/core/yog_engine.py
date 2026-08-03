"""
Yog Engine — Pap Khatri Yog detection.
From document:
  When Moon is between two malefics → Teji.
  If Budh (Mercury) involved → reverse effect.
  Occurs 15–20 day cycle.
  Two types: Bhav-based and Degree-based.
"""
from .config import MALEFIC_PLANETS


def pap_khatri_yog(planets: dict) -> dict:
    """
    Checks Pap Khatri Yog (degree-based).
    planets: dict of planet data, each having 'degree' and 'retrograde'.
    Returns dict with 'active', 'score', 'budh_involved'.
    """
    moon_deg = planets["moon"]["degree"]
    malefic_near = []
    budh_involved = False

    for p in MALEFIC_PLANETS:
        if p not in planets:
            continue
        diff = abs(planets[p]["degree"] - moon_deg)
        diff = min(diff, 360 - diff)
        if diff < 10:
            malefic_near.append(p)

    # Check if Mercury is near Moon
    if "mercury" in planets:
        diff = abs(planets["mercury"]["degree"] - moon_deg)
        diff = min(diff, 360 - diff)
        if diff < 10:
            budh_involved = True

    active = len(malefic_near) >= 2
    score = 3 if active else 0
    if active and budh_involved:
        score = -score  # Reverse if Budh involved

    return {
        "active": active,
        "score": score,
        "malefics_near_moon": malefic_near,
        "budh_involved": budh_involved,
    }
