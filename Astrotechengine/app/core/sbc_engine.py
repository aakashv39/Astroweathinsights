"""
SBC Engine — Sarvatobhadra Chakra (27 Nakshatra Vedh System).

From document:
  SBC is the most powerful tool.
  27 Nakshatras arranged on a 9×9 grid.
  Vedh types: Samukh (front), Bam (left), Dakshin (right).
  Sun, Moon, Rahu, Ketu → 3 direction Vedh.
  Other planets → 1 Vedh (Samukh only).
  Retrograde planet → Dakshin Vedh.
  Shubh Vedh on Moon → Mandi.
  Ashubh Vedh on Moon → Teji.
  Vedh > Aspect (higher priority).
"""

# ── 27 Nakshatra names ──
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

# ── Samukh Vedh pairs (front-facing, 14 nakshatras apart) ──
# Chitra (14) is the pivot/center — no Samukh vedh
SAMUKH_VEDH = {
    1: 15,  15: 1,    # Ashwini ↔ Swati
    2: 16,  16: 2,    # Bharani ↔ Vishakha
    3: 17,  17: 3,    # Krittika ↔ Anuradha
    4: 18,  18: 4,    # Rohini ↔ Jyeshtha
    5: 19,  19: 5,    # Mrigashira ↔ Moola
    6: 20,  20: 6,    # Ardra ↔ P.Ashadha
    7: 21,  21: 7,    # Punarvasu ↔ U.Ashadha
    8: 22,  22: 8,    # Pushya ↔ Shravana
    9: 23,  23: 9,    # Ashlesha ↔ Dhanishtha
    10: 24, 24: 10,   # Magha ↔ Shatabhisha
    11: 25, 25: 11,   # P.Phalguni ↔ P.Bhadrapada
    12: 26, 26: 12,   # U.Phalguni ↔ U.Bhadrapada
    13: 27, 27: 13,   # Hasta ↔ Revati
}

# ── Bam Vedh pairs (left diagonal, 13 nakshatras apart) ──
BAM_VEDH = {
    1: 14,  14: 1,    # Ashwini ↔ Chitra
    2: 15,  15: 2,    # Bharani ↔ Swati
    3: 16,  16: 3,    # Krittika ↔ Vishakha
    4: 17,  17: 4,    # Rohini ↔ Anuradha
    5: 18,  18: 5,    # Mrigashira ↔ Jyeshtha
    6: 19,  19: 6,    # Ardra ↔ Moola
    7: 20,  20: 7,    # Punarvasu ↔ P.Ashadha
    8: 21,  21: 8,    # Pushya ↔ U.Ashadha
    9: 22,  22: 9,    # Ashlesha ↔ Shravana
    10: 23, 23: 10,   # Magha ↔ Dhanishtha
    11: 24, 24: 11,   # P.Phalguni ↔ Shatabhisha
    12: 25, 25: 12,   # U.Phalguni ↔ P.Bhadrapada
    13: 26, 26: 13,   # Hasta ↔ U.Bhadrapada
    14: 27, 27: 14,   # Chitra ↔ Revati
}

# ── Dakshin Vedh pairs (right diagonal, 15 nakshatras apart) ──
DAKSHIN_VEDH = {
    1: 16,  16: 1,    # Ashwini ↔ Vishakha
    2: 17,  17: 2,    # Bharani ↔ Anuradha
    3: 18,  18: 3,    # Krittika ↔ Jyeshtha
    4: 19,  19: 4,    # Rohini ↔ Moola
    5: 20,  20: 5,    # Mrigashira ↔ P.Ashadha
    6: 21,  21: 6,    # Ardra ↔ U.Ashadha
    7: 22,  22: 7,    # Punarvasu ↔ Shravana
    8: 23,  23: 8,    # Pushya ↔ Dhanishtha
    9: 24,  24: 9,    # Ashlesha ↔ Shatabhisha
    10: 25, 25: 10,   # Magha ↔ P.Bhadrapada
    11: 26, 26: 11,   # P.Phalguni ↔ U.Bhadrapada
    12: 27, 27: 12,   # U.Phalguni ↔ Revati
    13: 14, 14: 13,   # Hasta ↔ Chitra
}

# ── Planets that give 3-direction vedh ──
THREE_DIR_PLANETS = {"sun", "moon", "rahu", "ketu"}

# ── Classification ──
BENEFIC = {"venus", "jupiter", "neptune"}
MALEFIC = {"saturn", "mars", "rahu", "ketu", "pluto", "uranus"}

# ── SBC Sector mapping ──
SBC_SIDES = {
    "East":  [1, 2, 3, 4, 5, 6],
    "South": [7, 8, 9, 10, 11, 12, 13],
    "West":  [14, 15, 16, 17, 18, 19, 20],
    "North": [21, 22, 23, 24, 25, 26, 27],
}


def get_nakshatra_name(nak: int) -> str:
    return NAKSHATRA_NAMES.get(nak, f"Nak-{nak}")


def get_sbc_side(nak: int) -> str:
    for side, naks in SBC_SIDES.items():
        if nak in naks:
            return side
    return "Unknown"


def get_vedh_targets(source_nak: int, planet: str, retrograde: bool = False) -> list:
    """
    Returns list of vedh targets from a source nakshatra.
    planet: name of planet producing vedh.
    retrograde: if True, planet gives Dakshin vedh.
    
    Sun/Moon/Rahu/Ketu → 3 directions (Samukh + Bam + Dakshin).
    Others → 1 direction (Samukh only).
    Retrograde → gives Dakshin vedh instead of Samukh.
    """
    targets = []

    if planet in THREE_DIR_PLANETS:
        # 3 direction vedh
        if source_nak in SAMUKH_VEDH:
            targets.append({"target": SAMUKH_VEDH[source_nak], "direction": "Samukh"})
        if source_nak in BAM_VEDH:
            targets.append({"target": BAM_VEDH[source_nak], "direction": "Bam"})
        if source_nak in DAKSHIN_VEDH:
            targets.append({"target": DAKSHIN_VEDH[source_nak], "direction": "Dakshin"})
    elif retrograde:
        # Retrograde → Dakshin vedh only
        if source_nak in DAKSHIN_VEDH:
            targets.append({"target": DAKSHIN_VEDH[source_nak], "direction": "Dakshin (Retro)"})
    else:
        # Normal → Samukh vedh only
        if source_nak in SAMUKH_VEDH:
            targets.append({"target": SAMUKH_VEDH[source_nak], "direction": "Samukh"})

    return targets


def classify_vedh(planet: str) -> str:
    """Returns 'Shubh', 'Ashubh', or 'Neutral'."""
    if planet in BENEFIC:
        return "Shubh"
    elif planet in MALEFIC:
        return "Ashubh"
    return "Neutral"


def vedh_effect(vedh_type: str) -> str:
    """
    From document:
      Shubh Vedh on Moon → Mandi
      Ashubh Vedh on Moon → Teji
    """
    if vedh_type == "Shubh":
        return "Mandi"
    elif vedh_type == "Ashubh":
        return "Teji"
    return "Neutral"


def calculate_sbc(planets: dict) -> dict:
    """
    Full SBC Vedh calculation.
    
    planets: dict with planet name -> {
        'degree': float,
        'nakshatra': int,
        'retrograde': bool,
    }
    
    Returns comprehensive SBC analysis:
    - All vedh produced by each planet
    - Vedh hitting Moon's nakshatra
    - Net SBC score
    - All vedh details
    """
    if "moon" not in planets:
        return {"error": "Moon data required for SBC"}

    moon_nak = planets["moon"]["nakshatra"]
    moon_side = get_sbc_side(moon_nak)

    all_vedh = []       # All vedh produced
    moon_vedh = []      # Vedh hitting Moon
    sbc_score = 0

    for planet, data in planets.items():
        if planet == "moon":
            continue
        p_nak = data["nakshatra"]
        retro = data.get("retrograde", False)
        targets = get_vedh_targets(p_nak, planet, retro)

        for t in targets:
            vedh_entry = {
                "source_planet": planet,
                "source_nakshatra": p_nak,
                "source_nakshatra_name": get_nakshatra_name(p_nak),
                "target_nakshatra": t["target"],
                "target_nakshatra_name": get_nakshatra_name(t["target"]),
                "direction": t["direction"],
                "vedh_type": classify_vedh(planet),
                "retrograde": retro,
            }
            all_vedh.append(vedh_entry)

            # Check if this vedh hits Moon's nakshatra
            if t["target"] == moon_nak:
                effect = vedh_effect(classify_vedh(planet))
                vedh_entry["effect_on_moon"] = effect
                moon_vedh.append(vedh_entry)
                # Scoring: Shubh → -3 (Mandi), Ashubh → +3 (Teji)
                if classify_vedh(planet) == "Shubh":
                    sbc_score -= 3
                elif classify_vedh(planet) == "Ashubh":
                    sbc_score += 3

    return {
        "moon_nakshatra": moon_nak,
        "moon_nakshatra_name": get_nakshatra_name(moon_nak),
        "moon_side": moon_side,
        "sbc_score": sbc_score,
        "moon_vedh_count": len(moon_vedh),
        "moon_vedh": moon_vedh,
        "total_vedh_count": len(all_vedh),
        "all_vedh": all_vedh,
    }
