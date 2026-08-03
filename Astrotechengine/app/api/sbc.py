"""
SBC (Sarvatobhadra Chakra) API router.
"""
from fastapi import APIRouter
from app.core.swiss_engine import get_planetary_positions
from app.core.sbc_engine import calculate_sbc
from app.core.nakshatra_engine import calculate_nakshatra

router = APIRouter(prefix="/sbc", tags=["SBC / Sarvatobhadra Chakra"])


@router.get("/calculate")
def calc_sbc():
    """
    Full SBC Vedh analysis from real-time planetary positions.
    Returns all vedh, vedh hitting Moon, and SBC score.
    """
    raw = get_planetary_positions()
    planets = {}
    for name, data in raw.items():
        planets[name] = {
            "degree": data["D1"]["longitude"],
            "nakshatra": data["D1"]["nakshatra"],
            "retrograde": data["D1"]["retrograde"],
        }
    # Add Ketu (180° from Rahu)
    if "rahu" in raw:
        rahu_deg = raw["rahu"]["D1"]["longitude"]
        ketu_deg = (rahu_deg + 180) % 360
        planets["ketu"] = {
            "degree": ketu_deg,
            "nakshatra": calculate_nakshatra(ketu_deg),
            "retrograde": True,
        }
    result = calculate_sbc(planets)
    return result
