"""
Combust API router.
"""
from fastapi import APIRouter
from app.core.combust_engine import is_combust, combust_score
from app.models.schemas import CombustRequest, CombustResponse

router = APIRouter(prefix="/combust", tags=["Combust"])


@router.post("/check", response_model=CombustResponse)
def check_combust(data: CombustRequest):
    """Check if a planet is combust (too close to Sun)."""
    return CombustResponse(
        combust=is_combust(data.planet, data.planet_degree, data.sun_degree),
        score=combust_score(data.planet, data.planet_degree, data.sun_degree),
    )
