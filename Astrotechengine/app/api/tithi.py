"""
Tithi API router.
"""
from fastapi import APIRouter
from app.core.tithi_engine import calculate_tithi, is_purnima, is_amavasya

router = APIRouter(prefix="/tithi", tags=["Tithi"])


@router.get("/calculate")
def get_tithi(sun_degree: float, moon_degree: float):
    """Returns Tithi number and special status (Purnima/Amavasya)."""
    tithi = calculate_tithi(sun_degree, moon_degree)
    return {
        "tithi": tithi,
        "is_purnima": is_purnima(tithi),
        "is_amavasya": is_amavasya(tithi),
    }
