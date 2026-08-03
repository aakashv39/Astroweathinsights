"""
Scoring Engine — 13-Rule Financial Astrology Prediction System.

Rules implemented:
  1.  SBC / Vedh (Sarvatobhadra Chakra)
  2.  Benefic drishti on Sun/Moon → Mandi; Malefic drishti → Teji
  3.  Agni Tarva (1,5,9) / Jal Tarva (4,8,12) rashi classification
  4.  Sun & Moon nakshatra teji/mandi tendency
  5.  Planet powerful when in own sign, friend sign, or exalted
  6.  Moon & Sun at 0° degree → strong Mandi
  7.  Paap Khatri Yog for Moon and Budh
  8.  Budh ka Yog (Mercury special)
  9.  Surya nakshatra sheet — teji when Sun in certain nakshatras
  10. Day-of-week nakshatra match (80% probability)
  11. Planet info — exalted/debilitated/retro status of all planets
  12. Combust+Debilitated = Viprit Raj Yog = Teji; retro/combust/debil reverses
  13. Purnima/Amavasya = one-sided market; Moon combust = 200-300 pt move

Returns:
  { "score": +X, "trend": "Teji/Mandi/Sideways", "confidence": NN%,
    "breakdown": { rule_name: { score, detail, description } } }
"""
import datetime
from .config import (
    WEIGHT_SBC_VEDH, WEIGHT_DRISHTI, WEIGHT_TARVA_RASHI,
    WEIGHT_NAKSHATRA_TEND, WEIGHT_PLANET_POWER, WEIGHT_SUN_MOON_ZERO,
    WEIGHT_PAP_KHATRI, WEIGHT_BUDH, WEIGHT_SURYA_NAK, WEIGHT_DAY_NAK,
    WEIGHT_PLANET_INFO, WEIGHT_VIPRIT_RAJ, WEIGHT_TITHI,
    WEIGHT_RASHI, WEIGHT_NAVANSH,
    TREND_VERY_STRONG_TEJI, TREND_TEJI,
    TREND_VERY_STRONG_MANDI, TREND_MANDI,
    BENEFIC_PLANETS, MALEFIC_PLANETS,
    EXALTATION, DEBILITATION, COMBUST_DEGREES,
    AGNI_RASHI, JALTARVA_RASHI,
    SURYA_TEJI_NAKSHATRAS, DAY_PLANET_MAP,
    MOON_TEJI_NAKSHATRAS, MOON_MANDI_NAKSHATRAS,
    PLANET_OWN_SIGN, PLANET_FRIEND_SIGN,
    PURNIMA_AMAVASYA_SCORE, MOON_COMBUST_BIG_MOVE_SCORE,
    ASPECT_SCORES, ASPECT_ORB,
    TIMEZONE,
)
from .vedh_engine import vedh_score
from .yog_engine import pap_khatri_yog
from .budh_engine import evaluate_budh
from .aspect_engine import aspect_score, calculate_aspect
from .tithi_engine import calculate_tithi, is_purnima, is_amavasya
from .rashi_engine import rashi_score
from .navansh_engine import navansh_score
from .combust_engine import is_combust
from .nakshatra_engine import (
    calculate_nakshatra, get_nakshatra_name, get_nakshatra_lord,
    NAKSHATRA_LORDS,
)
import pytz


# ─────────────────────── helpers ───────────────────────

def _angular_diff(d1: float, d2: float) -> float:
    """Shortest angular distance between two longitudes."""
    diff = abs(d1 - d2) % 360
    return min(diff, 360 - diff)


def _is_debilitated(planet: str, rashi: int) -> bool:
    return DEBILITATION.get(planet) == rashi


def _is_exalted(planet: str, rashi: int) -> bool:
    return EXALTATION.get(planet) == rashi


def _in_own_sign(planet: str, rashi: int) -> bool:
    return rashi in PLANET_OWN_SIGN.get(planet, [])


def _in_friend_sign(planet: str, rashi: int) -> bool:
    return rashi in PLANET_FRIEND_SIGN.get(planet, [])


# ─────────────── individual rule functions ─────────────

def _rule_01_sbc_vedh(planets: dict) -> dict:
    """Rule 1: SBC Vedh — vedh on Moon from benefic=mandi, malefic=teji."""
    v = vedh_score(planets)
    return {
        "score": v["score"] * WEIGHT_SBC_VEDH,
        "description": "SBC Vedh (benefic→mandi, malefic→teji)",
        "detail": v,
    }


def _rule_02_drishti(planets: dict) -> dict:
    """Rule 2: Benefic drishti on Sun/Moon → Mandi; Malefic drishti → Teji."""
    score = 0
    details = []
    targets = {"sun": planets["sun"]["degree"], "moon": planets["moon"]["degree"]}
    for tgt_name, tgt_deg in targets.items():
        for p, data in planets.items():
            if p in ("sun", "moon"):
                continue
            asp = calculate_aspect(data["degree"], tgt_deg)
            if asp["score"] == 0:
                continue
            if p in BENEFIC_PLANETS:
                # Benefic drishti on Sun/Moon → Mandi
                score -= abs(asp["score"])
                details.append(f"{p.title()} {asp['type']} {tgt_name.title()} → Mandi ({asp['score']:+d})")
            elif p in MALEFIC_PLANETS:
                # Malefic drishti on Sun/Moon → Teji
                score += abs(asp["score"])
                details.append(f"{p.title()} {asp['type']} {tgt_name.title()} → Teji ({asp['score']:+d})")
    return {
        "score": score * WEIGHT_DRISHTI,
        "description": "Drishti on Sun/Moon (benefic→mandi, malefic→teji)",
        "detail": details,
    }


def _rule_03_tarva_rashi(planets: dict) -> dict:
    """Rule 3: Agni Tarva (1,5,9) and Jal Tarva (4,8,12) rashi for Moon."""
    moon_rashi = planets["moon"].get("rashi")
    sun_rashi = planets["sun"].get("rashi")
    score = 0
    details = []
    for name, rashi in [("Moon", moon_rashi), ("Sun", sun_rashi)]:
        if rashi is None:
            continue
        if rashi in AGNI_RASHI:
            score += 1
            details.append(f"{name} in Agni Tarva rashi {rashi} → Teji")
        elif rashi in JALTARVA_RASHI:
            score -= 1
            details.append(f"{name} in Jal Tarva rashi {rashi} → Mandi")
    return {
        "score": score * WEIGHT_TARVA_RASHI,
        "description": "Tarva Rashi: Agni(1,5,9)=teji, Jal(4,8,12)=mandi",
        "detail": details,
    }


def _rule_04_nakshatra_tendency(planets: dict) -> dict:
    """Rule 4: Sun & Moon nakshatra teji/mandi tendency."""
    score = 0
    details = []
    moon_nak = planets["moon"].get("nakshatra")
    sun_nak = planets["sun"].get("nakshatra")
    if moon_nak:
        nak_name = get_nakshatra_name(moon_nak)
        if moon_nak in MOON_TEJI_NAKSHATRAS:
            score += 2
            details.append(f"Moon in {nak_name} (Nak {moon_nak}) → Teji tendency")
        elif moon_nak in MOON_MANDI_NAKSHATRAS:
            score -= 2
            details.append(f"Moon in {nak_name} (Nak {moon_nak}) → Mandi tendency")
        else:
            details.append(f"Moon in {nak_name} (Nak {moon_nak}) → Neutral")
    if sun_nak:
        nak_name = get_nakshatra_name(sun_nak)
        if sun_nak in MOON_TEJI_NAKSHATRAS:
            score += 1
            details.append(f"Sun in {nak_name} (Nak {sun_nak}) → Teji tendency")
        elif sun_nak in MOON_MANDI_NAKSHATRAS:
            score -= 1
            details.append(f"Sun in {nak_name} (Nak {sun_nak}) → Mandi tendency")
    return {
        "score": score * WEIGHT_NAKSHATRA_TEND,
        "description": "Sun & Moon nakshatra teji/mandi tendency",
        "detail": details,
    }


def _rule_05_planet_power(planets: dict) -> dict:
    """Rule 5: Planet powerful when in own sign, friend sign, or exalted."""
    score = 0
    details = []
    for p, data in planets.items():
        rashi = data.get("rashi")
        if rashi is None:
            continue
        if _is_exalted(p, rashi):
            # Exalted planet = powerful = market strength
            score += 2
            details.append(f"{p.title()} exalted in rashi {rashi} → Strong (+2)")
        elif _in_own_sign(p, rashi):
            score += 1
            details.append(f"{p.title()} in own sign rashi {rashi} → Strong (+1)")
        elif _in_friend_sign(p, rashi):
            score += 0.5
            details.append(f"{p.title()} in friend sign rashi {rashi} → Moderate (+0.5)")
        elif _is_debilitated(p, rashi):
            score -= 2
            details.append(f"{p.title()} debilitated in rashi {rashi} → Weak (-2)")
    return {
        "score": score * WEIGHT_PLANET_POWER,
        "description": "Planet strength: exalted/own/friend/debilitated",
        "detail": details,
    }


def _rule_06_sun_moon_zero(planets: dict) -> dict:
    """Rule 6: Moon & Sun at 0° = strong Mandi."""
    score = 0
    details = []
    moon_deg_in_rashi = planets["moon"]["degree"] % 30
    sun_deg_in_rashi = planets["sun"]["degree"] % 30
    # Check if Moon is at 0° of its rashi
    if moon_deg_in_rashi < 1.0:
        score -= 3
        details.append(f"Moon at {moon_deg_in_rashi:.2f}° (near 0°) → Strong Mandi")
    # Check if Sun is at 0° of its rashi
    if sun_deg_in_rashi < 1.0:
        score -= 2
        details.append(f"Sun at {sun_deg_in_rashi:.2f}° (near 0°) → Mandi")
    # Also check if both at 0° simultaneously
    if moon_deg_in_rashi < 1.0 and sun_deg_in_rashi < 1.0:
        score -= 2
        details.append("Both Sun & Moon near 0° → Very Strong Mandi")
    if not details:
        details.append(f"Moon at {moon_deg_in_rashi:.1f}°, Sun at {sun_deg_in_rashi:.1f}° — no 0° effect")
    return {
        "score": score * WEIGHT_SUN_MOON_ZERO,
        "description": "Sun/Moon at 0° of rashi = strong Mandi",
        "detail": details,
    }


def _rule_07_pap_khatri(planets: dict) -> dict:
    """Rule 7: Paap Khatri Yog for Moon and Budh."""
    pky = pap_khatri_yog(planets)
    return {
        "score": pky["score"] * WEIGHT_PAP_KHATRI,
        "description": "Paap Khatri Yog (Moon between malefics; Budh reverses)",
        "detail": pky,
    }


def _rule_08_budh(planets: dict) -> dict:
    """Rule 8: Budh ka Yog — Mercury special rules."""
    budh = evaluate_budh(planets)
    return {
        "score": budh["score"] * WEIGHT_BUDH,
        "description": "Budh ka Yog (retro+combust=teji, margi=mandi, conjunctions)",
        "detail": budh,
    }


def _rule_09_surya_nakshatra(planets: dict) -> dict:
    """Rule 9: Surya nakshatra sheet — teji when Sun in certain nakshatras."""
    sun_nak = planets["sun"].get("nakshatra")
    if not sun_nak:
        return {"score": 0, "description": "Surya nakshatra (no data)", "detail": []}
    nak_name = get_nakshatra_name(sun_nak)
    if sun_nak in SURYA_TEJI_NAKSHATRAS:
        score = 2
        detail = f"Sun in {nak_name} (Nak {sun_nak}) → Teji per Surya sheet"
    else:
        score = -1
        detail = f"Sun in {nak_name} (Nak {sun_nak}) → Mandi per Surya sheet"
    return {
        "score": score * WEIGHT_SURYA_NAK,
        "description": "Surya nakshatra sheet teji/mandi",
        "detail": [detail],
    }


def _rule_10_day_nakshatra(planets: dict) -> dict:
    """Rule 10: Day-of-week nakshatra match (80% probability).
    Monday=Moon, Tuesday=Mars, etc. If Moon's nakshatra lord matches
    the day's ruling planet → Teji."""
    tz = pytz.timezone(TIMEZONE)
    today = datetime.datetime.now(tz)
    weekday = today.weekday()  # 0=Monday
    day_planet = DAY_PLANET_MAP.get(weekday, "sun")
    moon_nak = planets["moon"].get("nakshatra")
    if not moon_nak:
        return {"score": 0, "description": "Day-nakshatra match (no data)", "detail": []}
    nak_lord = get_nakshatra_lord(moon_nak).lower()
    day_name = today.strftime("%A")
    if nak_lord == day_planet:
        score = 3
        detail = (f"{day_name}: Moon in {get_nakshatra_name(moon_nak)} "
                  f"(lord={nak_lord.title()}) matches day planet → Teji (80% prob)")
    else:
        score = 0
        detail = (f"{day_name}: Moon nakshatra lord={nak_lord.title()}, "
                  f"day planet={day_planet.title()} → No match")
    return {
        "score": score * WEIGHT_DAY_NAK,
        "description": "Day-of-week nakshatra match (80% probability)",
        "detail": [detail],
    }


def _rule_11_planet_info(planets: dict) -> dict:
    """Rule 11: Planet info — overall status summary of all planets (retro/exalted/debil)."""
    score = 0
    details = []
    for p, data in planets.items():
        rashi = data.get("rashi")
        retro = data.get("retrograde", False)
        flags = []
        if retro:
            flags.append("Retrograde")
        if rashi and _is_exalted(p, rashi):
            flags.append("Exalted")
        if rashi and _is_debilitated(p, rashi):
            flags.append("Debilitated")
        if rashi and _in_own_sign(p, rashi):
            flags.append("Own Sign")
        sun_deg = planets["sun"]["degree"]
        if is_combust(p, data["degree"], sun_deg):
            flags.append("Combust")
        if flags:
            # Exalted benefics strengthen market (Mandi), exalted malefics → Teji
            if "Exalted" in flags:
                if p in BENEFIC_PLANETS:
                    score -= 1
                elif p in MALEFIC_PLANETS:
                    score += 1
            if "Debilitated" in flags:
                if p in BENEFIC_PLANETS:
                    score += 0.5
                elif p in MALEFIC_PLANETS:
                    score -= 0.5
            details.append(f"{p.title()}: {', '.join(flags)}")
        else:
            details.append(f"{p.title()}: Normal")
    return {
        "score": score * WEIGHT_PLANET_INFO,
        "description": "Planet status summary (retro/exalted/debilitated/combust)",
        "detail": details,
    }


def _rule_12_viprit_raj(planets: dict) -> dict:
    """Rule 12: Combust + Debilitated = Viprit Raj Yog = Teji.
    Retrograde/Combust/Debilitated individually → result reverses."""
    score = 0
    details = []
    sun_deg = planets["sun"]["degree"]
    for p, data in planets.items():
        if p in ("sun", "rahu", "ketu"):
            continue
        rashi = data.get("rashi")
        retro = data.get("retrograde", False)
        combust = is_combust(p, data["degree"], sun_deg)
        debilitated = rashi is not None and _is_debilitated(p, rashi)
        # Viprit Raj Yog: combust + debilitated = very strong teji
        if combust and debilitated:
            score += 4
            details.append(f"{p.title()} Combust+Debilitated → Viprit Raj Yog → Strong Teji (+4)")
        elif combust and retro:
            # Retro + Combust = Teji
            score += 2
            details.append(f"{p.title()} Retro+Combust → Teji (+2)")
        elif retro and debilitated:
            # Retro + Debilitated = Reversed (becomes Teji)
            score += 2
            details.append(f"{p.title()} Retro+Debilitated → Reversal → Teji (+2)")
        elif combust:
            score -= 1
            details.append(f"{p.title()} Combust → weakened (-1)")
        elif debilitated:
            score -= 1
            details.append(f"{p.title()} Debilitated → weakened (-1)")
    if not details:
        details.append("No Viprit Raj Yog or special reversal conditions active")
    return {
        "score": score * WEIGHT_VIPRIT_RAJ,
        "description": "Viprit Raj Yog (combust+debil=teji); retro/combust/debil reversals",
        "detail": details,
    }


def _rule_13_tithi(planets: dict) -> dict:
    """Rule 13: Purnima/Amavasya = one-sided market.
    Moon combust = 200-300 point move (big move signal)."""
    sun_deg = planets["sun"]["degree"]
    moon_deg = planets["moon"]["degree"]
    tithi = calculate_tithi(sun_deg, moon_deg)
    score = 0
    details = []
    big_move = False
    one_sided = False

    # Purnima / Amavasya → one-sided market
    if is_purnima(tithi):
        score += PURNIMA_AMAVASYA_SCORE
        details.append(f"Tithi {tithi} = PURNIMA → One-sided market (+{PURNIMA_AMAVASYA_SCORE})")
        one_sided = True
    elif is_amavasya(tithi):
        score += PURNIMA_AMAVASYA_SCORE
        details.append(f"Tithi {tithi} = AMAVASYA → One-sided market (+{PURNIMA_AMAVASYA_SCORE})")
        one_sided = True
    else:
        details.append(f"Tithi {tithi} — normal")

    # Moon combust → 200-300 point move
    moon_combust = is_combust("moon", moon_deg, sun_deg)
    if moon_combust:
        score += MOON_COMBUST_BIG_MOVE_SCORE
        details.append(f"Moon COMBUST → big 200-300 pt move signal (+{MOON_COMBUST_BIG_MOVE_SCORE})")
        big_move = True

    return {
        "score": score * WEIGHT_TITHI,
        "description": "Tithi: Purnima/Amavasya one-sided; Moon combust big move",
        "detail": details,
        "one_sided": one_sided,
        "big_move": big_move,
        "tithi": tithi,
    }


# ─────────────── MASTER AGGREGATION ───────────────

def final_score(planets: dict) -> dict:
    """
    Aggregates all 13 rules with configurable weights.
    planets: dict of planet name -> {degree, rashi, retrograde, speed, nakshatra, d9_rashi}
    Returns dict with score, trend, confidence, breakdown, alerts.
    """
    rules = [
        ("01_SBC_Vedh",           _rule_01_sbc_vedh),
        ("02_Drishti",            _rule_02_drishti),
        ("03_Tarva_Rashi",        _rule_03_tarva_rashi),
        ("04_Nakshatra_Tendency", _rule_04_nakshatra_tendency),
        ("05_Planet_Power",       _rule_05_planet_power),
        ("06_Sun_Moon_Zero",      _rule_06_sun_moon_zero),
        ("07_Paap_Khatri",        _rule_07_pap_khatri),
        ("08_Budh_Yog",           _rule_08_budh),
        ("09_Surya_Nakshatra",    _rule_09_surya_nakshatra),
        ("10_Day_Nakshatra",      _rule_10_day_nakshatra),
        ("11_Planet_Info",        _rule_11_planet_info),
        ("12_Viprit_Raj",         _rule_12_viprit_raj),
        ("13_Tithi_Purnima",      _rule_13_tithi),
    ]

    total_score = 0.0
    breakdown = {}
    alerts = []

    for rule_name, rule_fn in rules:
        result = rule_fn(planets)
        rule_score = result["score"]
        total_score += rule_score
        breakdown[rule_name] = result
        # Collect big-move / one-sided alerts
        if result.get("one_sided"):
            alerts.append("⚠ ONE-SIDED MARKET (Purnima/Amavasya)")
        if result.get("big_move"):
            alerts.append("⚠ BIG MOVE 200-300 pts (Moon Combust)")

    # Also add legacy rashi & navansh scores
    moon_rashi = planets["moon"].get("rashi")
    if moon_rashi:
        r_val = rashi_score(moon_rashi) * WEIGHT_RASHI
        total_score += r_val
        breakdown["Moon_Rashi"] = {
            "score": r_val,
            "description": "Moon rashi teji/mandi classification",
            "detail": [f"Moon rashi {moon_rashi} → score {r_val:+.1f}"],
        }

    d1 = planets["moon"].get("rashi")
    d9 = planets["moon"].get("d9_rashi")
    if d1 and d9:
        nav_val = navansh_score(d1, d9) * WEIGHT_NAVANSH
        total_score += nav_val
        barg = d1 == d9
        breakdown["Navansh_Barguttam"] = {
            "score": nav_val,
            "description": "D9 Barguttam (D1==D9 = strong teji +3)",
            "detail": [f"D1={d1}, D9={d9} → {'BARGUTTAM' if barg else 'No Barguttam'} → {nav_val:+.1f}"],
        }

    # Determine trend
    total_score = round(total_score, 2)
    if total_score >= TREND_VERY_STRONG_TEJI:
        trend = "Very Strong Teji 🟢🟢"
    elif total_score >= TREND_TEJI:
        trend = "Teji 🟢"
    elif total_score <= TREND_VERY_STRONG_MANDI:
        trend = "Very Strong Mandi 🔴🔴"
    elif total_score <= TREND_MANDI:
        trend = "Mandi 🔴"
    else:
        trend = "Sideways ⚪"

    # Confidence: higher absolute score = more confident, cap at 95%
    confidence = min(abs(total_score) * 5, 95)

    # Count how many rules agree
    teji_rules = sum(1 for v in breakdown.values() if v["score"] > 0)
    mandi_rules = sum(1 for v in breakdown.values() if v["score"] < 0)
    neutral_rules = sum(1 for v in breakdown.values() if v["score"] == 0)

    return {
        "score": total_score,
        "trend": trend,
        "confidence": round(confidence, 1),
        "teji_rules": teji_rules,
        "mandi_rules": mandi_rules,
        "neutral_rules": neutral_rules,
        "alerts": alerts,
        "breakdown": breakdown,
    }
