"""
Nakshatra API router.
"""
from fastapi import APIRouter
from app.core.nakshatra_engine import calculate_nakshatra

router = APIRouter(prefix="/nakshatra", tags=["Nakshatra"])


@router.get("/calculate")
def get_nakshatra(longitude: float):
    """Returns Nakshatra number (1–27) for a given longitude."""
    nak = calculate_nakshatra(longitude)
    return {"longitude": longitude, "nakshatra": nak}
