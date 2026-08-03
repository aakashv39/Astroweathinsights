"""
Tithi Engine — Purnima / Amavasya / general tithi calculation.
From document:
  Purnima / Amavasya → one sided market.
  Moon combust → 200–300 point move.
  Two tithis in one day → one directional market.
"""
from .config import TITHI_SPAN


def calculate_tithi(sun_deg: float, moon_deg: float) -> int:
    """Returns Tithi number (1-30) for given Sun and Moon longitude."""
    diff = (moon_deg - sun_deg) % 360
    return int(diff / TITHI_SPAN) + 1


def is_purnima(tithi: int) -> bool:
    """Full Moon — Tithi 15."""
    return tithi == 15


def is_amavasya(tithi: int) -> bool:
    """New Moon — Tithi 30."""
    return tithi == 30
