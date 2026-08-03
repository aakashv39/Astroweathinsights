from .config import NAKSHATRA_SPAN

# ── 27 Nakshatra Names ──
NAKSHATRA_NAMES = {
    1: "Ashwini",       2: "Bharani",       3: "Krittika",
    4: "Rohini",        5: "Mrigashira",    6: "Ardra",
    7: "Punarvasu",     8: "Pushya",        9: "Ashlesha",
    10: "Magha",        11: "P.Phalguni",   12: "U.Phalguni",
    13: "Hasta",        14: "Chitra",       15: "Swati",
    16: "Vishakha",     17: "Anuradha",     18: "Jyeshtha",
    19: "Moola",        20: "P.Ashadha",    21: "U.Ashadha",
    22: "Shravana",     23: "Dhanishtha",   24: "Shatabhisha",
    25: "P.Bhadrapada", 26: "U.Bhadrapada", 27: "Revati",
}

# ── Nakshatra Lords (Vimshottari Dasha sequence) ──
# Ketu, Venus, Sun, Moon, Mars, Rahu, Jupiter, Saturn, Mercury (repeats 3x)
NAKSHATRA_LORDS = {
    1: "Ketu",      2: "Venus",     3: "Sun",
    4: "Moon",      5: "Mars",      6: "Rahu",
    7: "Jupiter",   8: "Saturn",    9: "Mercury",
    10: "Ketu",     11: "Venus",    12: "Sun",
    13: "Moon",     14: "Mars",     15: "Rahu",
    16: "Jupiter",  17: "Saturn",   18: "Mercury",
    19: "Ketu",     20: "Venus",    21: "Sun",
    22: "Moon",     23: "Mars",     24: "Rahu",
    25: "Jupiter",  26: "Saturn",   27: "Mercury",
}


def calculate_nakshatra(longitude):
    """
    Returns Nakshatra number (1-27) for given longitude.
    """
    return int(longitude / NAKSHATRA_SPAN) + 1


def get_nakshatra_pada(longitude) -> int:
    """
    Returns Pada (1-4) within the nakshatra.
    Each nakshatra = 13°20', each pada = 3°20'.
    """
    pos_in_nak = longitude % NAKSHATRA_SPAN
    pada = int(pos_in_nak / (NAKSHATRA_SPAN / 4)) + 1
    return min(pada, 4)


def get_nakshatra_name(nak: int) -> str:
    """Returns the name of nakshatra given its number (1-27)."""
    return NAKSHATRA_NAMES.get(nak, f"Nak-{nak}")


def get_nakshatra_lord(nak: int) -> str:
    """Returns the ruling planet (lord) of nakshatra given its number (1-27)."""
    return NAKSHATRA_LORDS.get(nak, "Unknown")
