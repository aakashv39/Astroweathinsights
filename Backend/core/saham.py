"""
Saham formulas (common ones). Each saham returns (sign, degree_in_sign).
Simple formula:
    Day:  A - B + L
    Night: B - A + L
Inputs A, B, L are absolute ecliptic longitudes in degrees (0..360).
"""
from typing import Tuple

def saham(daytime: bool, A_deg: float, B_deg: float, L_deg: float) -> Tuple[int,float]:
    if daytime:
        val = (A_deg - B_deg + L_deg) % 360
    else:
        val = (B_deg - A_deg + L_deg) % 360
    sign = int(val // 30) + 1
    degree = val % 30
    return sign, degree
