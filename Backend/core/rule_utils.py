"""
Rule utilities shared across prediction engine.
"""

# Classical combustion orbs (proximity in degrees)
COMBUST_ORBS = {
    "Moon": 12,
    "Mars": 17,
    "Mercury": 14,
    "Jupiter": 11,
    "Venus": 10,
    "Saturn": 15,
    "Sun": 0,   # Sun cannot be combust
}

# As per user setting — Sun treated as malefic
MALEFICS = ["Saturn", "Mars", "Rahu", "Ketu", "Sun"]


def is_combust(sun_lon: float, planet_lon: float, orb: float) -> bool:
    """Check combustion based only on longitudinal proximity."""
    diff = abs(sun_lon - planet_lon) % 360
    diff = min(diff, 360 - diff)
    return diff <= orb


def build_combust_flags(chart):
    """Return dict {planet: True/False}"""
    sun_lon = chart.planets["Sun"].longitude
    out = {}
    for p in chart.planets.values():
        if p.name == "Sun":
            out[p.name] = False
            continue
        orb = COMBUST_ORBS.get(p.name, 10)
        out[p.name] = is_combust(sun_lon, p.longitude, orb)
    return out


def build_malefic_flags(chart):
    """Return dict {planet: bool}"""
    return {p: (p in MALEFICS) for p in chart.planets.keys()}


def has_aspect(active_aspects, p1, p2):
    """Check Tajik aspect between two planets excluding neutral aspect."""
    for a in active_aspects:
        if a["category"] == "neutral":
            continue
        if (a["p1"] == p1 and a["p2"] == p2) or (a["p1"] == p2 and a["p2"] == p1):
            return True
    return False
