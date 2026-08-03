from fastapi import APIRouter
from app.core.rashi_parivartan_engine import calculate_rashi_parivartan

router = APIRouter(prefix="/rashi-parivartan", tags=["Rashi Parivartan"])


@router.get("/calculate")
def get_rashi_parivartan():
    """Get Rashi Parivartan (sign change) data for all planets."""
    return calculate_rashi_parivartan()
