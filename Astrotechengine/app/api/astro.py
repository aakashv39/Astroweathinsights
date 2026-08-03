from fastapi import APIRouter
from datetime import datetime
from app.core.swiss_engine import get_planetary_positions

router = APIRouter()

@router.get("/astro/d1d9")
def get_d1_d9():
    """
    Returns real-time D1 (Rashi) and D9 (Navansh) planetary positions for Mumbai.
    """
    positions = get_planetary_positions()
    return positions
