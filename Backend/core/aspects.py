"""
Tajik Aspect Engine with Deeptansh (ORB) logic.
Rahu and Ketu are excluded from aspect calculation.
"""

from math import fabs
from config.settings import TAJIK_ASPECTS, DEEPTANSH_TABLE


def rashi_distance(sign1: int, sign2: int) -> int:
    """
    Inclusive counting:
    sign1 → 1
    next sign → 2
    ...
    up to 12
    """
    d = (sign2 - sign1) % 12
    return d + 1


def tajik_aspect_category(sign1: int, sign2: int) -> str:
    """
    Category of Tajik Dhrishti based on inclusive sign distance.
    """
    d = rashi_distance(sign1, sign2)
    for category, values in TAJIK_ASPECTS.items():
        if d in values:
            return category
    return "none"


def degree_difference(deg1: float, deg2: float) -> float:
    """
    Smallest angular degree gap between two planetary degrees.
    """
    d = fabs(deg1 - deg2)
    return min(d, 360 - d)


def deeptansh_limit(p1: str, p2: str) -> float:
    """
    ORB = (planet1_orb + planet2_orb) / 2
    """
    return (DEEPTANSH_TABLE.get(p1, 7) + DEEPTANSH_TABLE.get(p2, 7)) / 2.0


def get_tajik_aspect(p1, p2) -> dict:
    """
    Full evaluation between two planets.
    """
    category = tajik_aspect_category(p1.sign, p2.sign)
    gap = degree_difference(p1.degree, p2.degree)
    limit = deeptansh_limit(p1.name, p2.name)
    active = gap <= limit

    return {
        "p1": p1.name,
        "p2": p2.name,
        "category": category,
        "degree_diff": gap,
        "deeptansh_limit": limit,
        "active": active
    }


def analyze_chart_aspects(chart):
    """
    Returns:
      active_aspects   → Deeptansh satisfied
      excluded_aspects → Deeptansh NOT satisfied (aspect exists, but weak)
    Rahu and Ketu are excluded from calculations.
    """
    active = []
    excluded = []

    planets = [p for p in chart.planets.values() if p.name not in ("Rahu", "Ketu")]

    for i in range(len(planets)):
        for j in range(i + 1, len(planets)):
            asp = get_tajik_aspect(planets[i], planets[j])

            # Ignore if no aspect rule
            if asp["category"] == "none":
                continue

            if asp["active"]:
                active.append(asp)
            else:
                excluded.append(asp)

    return active, excluded

def aspects_planet_to_house(chart, planet, target_house: int) -> bool:
    """
    Returns True if the planet aspects the given HOUSE in Tajik system
    using the standard sign–distance rule.

    Rule:
      A planet aspects houses:
        1, 3, 5, 7, 9, 11 (odd sign distance)
    counted from its own house.

    Example:
        If Mars is in 4th house:
          distance 7 → aspects 10th house
    """
    ph = planet.house                     # house number of the planet (1–12)
    d = (target_house - ph) % 12

    # odd distances represent Tajik Dhrishti
    return d in (1, 3, 5, 7, 9, 11)

