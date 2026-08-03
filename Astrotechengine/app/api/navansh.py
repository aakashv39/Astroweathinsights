"""
Navansh API router.
"""
from fastapi import APIRouter
from app.core.navansh_engine import calculate_navansh, navansh_score
from app.models.schemas import NavanshRequest, NavanshResponse

router = APIRouter(prefix="/navansh", tags=["Navansh"])


@router.get("/calculate")
def calc_navansh(longitude: float):
    """Calculate Navansh (D9) rashi for a given longitude."""
    return {"longitude": longitude, "navansh_rashi": calculate_navansh(longitude)}


@router.post("/barguttam", response_model=NavanshResponse)
def check_barguttam(data: NavanshRequest):
    """Check if Barguttam (D1 == D9 rashi) for a planet."""
    return NavanshResponse(
        barguttam=data.d1_rashi == data.d9_rashi,
        score=navansh_score(data.d1_rashi, data.d9_rashi),
    )
