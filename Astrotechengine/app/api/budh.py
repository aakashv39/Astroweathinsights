"""
Budh (Mercury) Special API router.
"""
from fastapi import APIRouter
from app.core.swiss_engine import get_planetary_positions
from app.core.budh_engine import evaluate_budh

router = APIRouter(prefix="/budh", tags=["Budh Special"])


@router.get("/evaluate")
def calc_budh():
    """Evaluate Mercury special logic for BankNifty from real-time positions."""
    raw = get_planetary_positions()
    planets = {}
    for name, data in raw.items():
        planets[name] = {
            "degree": data["D1"]["longitude"],
            "retrograde": data["D1"]["retrograde"],
        }
    result = evaluate_budh(planets)
    return result
