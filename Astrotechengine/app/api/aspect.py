"""
Aspect API router.
"""
from fastapi import APIRouter
from app.core.aspect_engine import calculate_aspect
from app.models.schemas import AspectRequest, AspectResponse

router = APIRouter(prefix="/aspect", tags=["Aspect"])


@router.post("/calculate", response_model=AspectResponse)
def calc_aspect(data: AspectRequest):
    """Calculate the aspect between two planetary degrees."""
    result = calculate_aspect(data.degree1, data.degree2)
    return AspectResponse(**result)
