"""
Test: All core engines — Aspect, Combust, Vedh, Yog, Budh, Navansh, Rashi, Scoring.
"""
from app.core.swiss_engine import get_planetary_positions
from app.core.aspect_engine import calculate_aspect
from app.core.combust_engine import is_combust
from app.core.vedh_engine import vedh_score
from app.core.yog_engine import pap_khatri_yog
from app.core.budh_engine import evaluate_budh
from app.core.navansh_engine import navansh_score
from app.core.rashi_engine import get_rashi_type, rashi_score
from app.core.tithi_engine import calculate_tithi, is_purnima, is_amavasya
from app.core.scoring_engine import final_score
import datetime


def build_planet_dict(raw):
    """Flatten swiss_engine output into scoring-ready dict."""
    planets = {}
    for name, data in raw.items():
        planets[name] = {
            "degree": data["D1"]["longitude"],
            "rashi": data["D1"]["rashi"],
            "retrograde": data["D1"]["retrograde"],
            "speed": data["D1"]["speed"],
            "nakshatra": data["D1"]["nakshatra"],
            "d9_rashi": data["D9"]["navansh_rashi"],
        }
    return planets


if __name__ == "__main__":
    dt = datetime.datetime(2026, 2, 25, 9, 15)
    raw = get_planetary_positions(dt)
    planets = build_planet_dict(raw)

    print("=" * 60)
    print("ASPECT TEST: Sun ↔ Moon")
    asp = calculate_aspect(planets["sun"]["degree"], planets["moon"]["degree"])
    print(f"  {asp}")

    print("\nCOMBUST TEST: Mercury near Sun?")
    comb = is_combust("mercury", planets["mercury"]["degree"], planets["sun"]["degree"])
    print(f"  Mercury combust: {comb}")

    print("\nRASHI TEST: Moon Rashi")
    r = planets["moon"]["rashi"]
    print(f"  Moon Rashi {r} → {get_rashi_type(r)} (score {rashi_score(r)})")

    print("\nTITHI TEST:")
    tithi = calculate_tithi(planets["sun"]["degree"], planets["moon"]["degree"])
    print(f"  Tithi: {tithi}, Purnima: {is_purnima(tithi)}, Amavasya: {is_amavasya(tithi)}")

    print("\nNAVANSH TEST: Moon Barguttam?")
    nav = navansh_score(planets["moon"]["rashi"], planets["moon"]["d9_rashi"])
    print(f"  D1={planets['moon']['rashi']}, D9={planets['moon']['d9_rashi']}, Score={nav}")

    print("\nVEDH / SBC TEST:")
    vedh = vedh_score(planets)
    print(f"  {vedh}")

    print("\nPAP KHATRI YOG TEST:")
    pky = pap_khatri_yog(planets)
    print(f"  {pky}")

    print("\nBUDH SPECIAL TEST:")
    budh = evaluate_budh(planets)
    print(f"  {budh}")

    print("\n" + "=" * 60)
    print("FINAL DAILY PREDICTION:")
    result = final_score(planets)
    print(f"  Score: {result['score']}")
    print(f"  Trend: {result['trend']}")
    print(f"  Confidence: {result['confidence']}%")
    print(f"  Breakdown:")
    for k, v in result["breakdown"].items():
        print(f"    {k}: {v}")
