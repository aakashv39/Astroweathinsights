"""
Rashi Engine — Teji / Mandi / Jaltarva / Agni classification.
From document: Rashi type determines base market direction.
"""
from .config import (
    TEJI_RASHI, MANDI_RASHI, STRONG_TEJI_RASHI, STRONG_MANDI_RASHI,
    JALTARVA_RASHI, AGNI_RASHI,
)


def get_rashi_type(rashi: int) -> str:
    """Returns rashi classification string."""
    if rashi in STRONG_TEJI_RASHI:
        return "Strong Teji"
    if rashi in STRONG_MANDI_RASHI:
        return "Strong Mandi"
    if rashi in TEJI_RASHI:
        return "Teji"
    if rashi in MANDI_RASHI:
        return "Mandi"
    return "Neutral"


def rashi_score(rashi: int) -> int:
    """Returns +1 for Teji rashi, -1 for Mandi rashi, 0 otherwise."""
    if rashi in TEJI_RASHI:
        return 1
    if rashi in MANDI_RASHI:
        return -1
    return 0


def is_jaltarva(rashi: int) -> bool:
    return rashi in JALTARVA_RASHI


def is_agni(rashi: int) -> bool:
    return rashi in AGNI_RASHI
