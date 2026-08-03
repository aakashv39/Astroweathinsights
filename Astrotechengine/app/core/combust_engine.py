"""
Combust Engine — Planet combust (Asth) detection.
From document: When planet is combust → power reduced.
If combust + retrograde + neech → result reverses.
Sun, Rahu, Ketu are never combust.
"""
from .config import COMBUST_DEGREES


def is_combust(planet: str, planet_deg: float, sun_deg: float) -> bool:
    """Returns True if the planet is combust (too close to Sun)."""
    if planet in ("sun", "rahu", "ketu"):
        return False
    if planet not in COMBUST_DEGREES:
        return False
    diff = abs(planet_deg - sun_deg)
    diff = min(diff, 360 - diff)
    return diff <= COMBUST_DEGREES[planet]


def combust_score(planet: str, planet_deg: float, sun_deg: float) -> int:
    """Returns -1 if combust (weakened), 0 otherwise."""
    if is_combust(planet, planet_deg, sun_deg):
        return -1
    return 0
