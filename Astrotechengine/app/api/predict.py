"""
Daily Prediction API router — Master endpoint.
Aggregates all scoring modules.
"""
from fastapi import APIRouter
from app.core.swiss_engine import get_planetary_positions
from app.core.scoring_engine import final_score

router = APIRouter(prefix="/predict", tags=["Prediction"])


@router.get("/daily")
def daily_prediction():
    """
    Real-time daily market prediction using all astro rule modules.
    Returns score, trend, confidence, and breakdown.
    """
    raw = get_planetary_positions()
    # Build flat planet dict for scoring
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
    result = final_score(planets)
    result["planets"] = raw
    return result
