"""
Rashi API router.
"""
from fastapi import APIRouter
from app.core.rashi_engine import get_rashi_type, rashi_score, is_jaltarva, is_agni
from app.models.schemas import RashiRequest, RashiResponse

router = APIRouter(prefix="/rashi", tags=["Rashi"])


@router.post("/classify", response_model=RashiResponse)
def classify_rashi(data: RashiRequest):
    """Classifies a rashi as Teji / Mandi / Jaltarva / Agni."""
    return RashiResponse(
        rashi=data.rashi,
        type=get_rashi_type(data.rashi),
        score=rashi_score(data.rashi),
        is_jaltarva=is_jaltarva(data.rashi),
        is_agni=is_agni(data.rashi),
    )
