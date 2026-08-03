"""
Yog (Pap Khatri) API router.
"""
from fastapi import APIRouter
from app.core.swiss_engine import get_planetary_positions
from app.core.yog_engine import pap_khatri_yog

router = APIRouter(prefix="/yog", tags=["Yog"])


@router.get("/pap-khatri")
def calc_pap_khatri():
    """Check real-time Pap Khatri Yog from current planetary positions."""
    raw = get_planetary_positions()
    planets = {}
    for name, data in raw.items():
        planets[name] = {"degree": data["D1"]["longitude"]}
    result = pap_khatri_yog(planets)
    return result
