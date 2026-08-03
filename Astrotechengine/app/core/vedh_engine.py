"""
Vedh Engine — SBC (Sarvatobhadra Chakra) Vedh calculation.
From document:
  27 Nakshatra circular chakra.
  Vedh types: Bam (Left), Samukh, Dakshin (Right).
  Sun, Moon, Rahu, Ketu → 3 direction Vedh.
  Other planets → 1 Vedh.
  Retrograde → Dakshin Vedh.
  Shubh Vedh on Moon → Mandi.
  Ashubh Vedh on Moon → Teji.
  Vedh > Aspect (higher priority).
"""
from .config import BENEFIC_PLANETS, MALEFIC_PLANETS, SBC_SECTORS
from .nakshatra_engine import calculate_nakshatra


def get_sbc_sector(nakshatra: int) -> str:
    """Returns SBC direction sector for a given nakshatra."""
    for sector, nak_range in SBC_SECTORS.items():
        if nakshatra in nak_range:
            return sector
    return "Unknown"


def vedh_score(planets: dict) -> dict:
    """
    Calculates Vedh score based on nakshatra overlap with Moon.
    planets: dict with each planet having 'degree'.
    Returns dict with 'score', 'vedh_list'.
    """
    moon_nak = calculate_nakshatra(planets["moon"]["degree"])
    score = 0
    vedh_list = []

    for p, data in planets.items():
        if p == "moon":
            continue
        p_nak = calculate_nakshatra(data["degree"])
        if p_nak == moon_nak:
            if p in BENEFIC_PLANETS:
                score -= 3  # Shubh Vedh → Mandi
                vedh_list.append({"planet": p, "type": "Shubh", "effect": "Mandi"})
            elif p in MALEFIC_PLANETS:
                score += 3  # Ashubh Vedh → Teji
                vedh_list.append({"planet": p, "type": "Ashubh", "effect": "Teji"})
            else:
                vedh_list.append({"planet": p, "type": "Neutral", "effect": "Neutral"})

    return {
        "score": score,
        "moon_nakshatra": moon_nak,
        "moon_sector": get_sbc_sector(moon_nak),
        "vedh_list": vedh_list,
    }
