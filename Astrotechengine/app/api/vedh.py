"""
Vedh (SBC) API router.
"""
from fastapi import APIRouter
from app.core.swiss_engine import get_planetary_positions
from app.core.vedh_engine import vedh_score

router = APIRouter(prefix="/vedh", tags=["Vedh / SBC"])


@router.get("/calculate")
def calc_vedh():
    """Calculate real-time Vedh score based on current planetary positions."""
    raw = get_planetary_positions()
    # Flatten to { planet: { degree, ... } }
    planets = {}
    for name, data in raw.items():
        planets[name] = {"degree": data["D1"]["longitude"]}
    result = vedh_score(planets)
    return result
