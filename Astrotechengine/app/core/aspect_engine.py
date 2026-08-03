"""
Aspect Engine — Degree-based aspect calculation.
From document:
  0° (Yukti), 180° (Prati Yukti), 150° (Sarasthak), 90° (Strong Mandi)
  Teji aspects: 30, 60, 120, 26, 72
  Mandi aspects: 22.5, 45, 90, 135
  Priority: 0, 90, 150, 180 strongest.
"""
from .config import ASPECT_SCORES, ASPECT_ORB


def calculate_aspect(deg1: float, deg2: float) -> dict:
    """
    Returns aspect info between two planetary degrees.
    Returns dict with 'angle', 'score', 'type'.
    """
    diff = abs(deg1 - deg2)
    diff = min(diff, 360 - diff)
    for angle, score in ASPECT_SCORES.items():
        if abs(diff - angle) <= ASPECT_ORB:
            return {"angle": angle, "score": score, "type": _aspect_name(angle)}
    return {"angle": round(diff, 2), "score": 0, "type": "None"}


def aspect_score(deg1: float, deg2: float) -> int:
    """Returns numeric score for the aspect between two degrees."""
    result = calculate_aspect(deg1, deg2)
    return result["score"]


def _aspect_name(angle: float) -> str:
    names = {
        0: "Yukti",
        180: "Prati Yukti",
        150: "Sarasthak Yog",
        90: "Chaturthamsh (Strong Mandi)",
        120: "Trikona",
        60: "Sextile",
        30: "Semi-Sextile",
        135: "Sesquiquadrate",
        45: "Semi-Square",
        22.5: "Semi-Octile",
        26: "Custom-26",
        72: "Quintile",
    }
    return names.get(angle, f"Aspect-{angle}")
