"""
Reversal Engine — Reverses result under specific conditions.
From document:
  If planet is Retrograde OR Combust OR Debilitated (Neech) → result reverses.
  Example: Neech Guru → strong Teji.
"""
from .config import DEBILITATION
from .combust_engine import is_combust


def should_reverse(planet: str, planet_data: dict, sun_deg: float) -> bool:
    """
    Returns True if the planet's effect should be reversed.
    planet_data: dict with 'degree', 'retrograde', 'rashi'.
    """
    retrograde = planet_data.get("retrograde", False)
    combust = is_combust(planet, planet_data["degree"], sun_deg)
    debilitated = planet_data.get("rashi") == DEBILITATION.get(planet)
    return retrograde or combust or debilitated


def apply_reversal(score: int, planet: str, planet_data: dict, sun_deg: float) -> int:
    """Reverses score if conditions are met."""
    if should_reverse(planet, planet_data, sun_deg):
        return -score
    return score
