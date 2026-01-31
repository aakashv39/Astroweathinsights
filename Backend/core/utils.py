from core.planets import Planet
from typing import Dict, Tuple
import math

def lon_to_sign_degree(lon: float) -> Tuple[int, float]:
    lon = lon % 360
    sign = int(lon // 30) + 1
    deg = lon % 30
    return sign, deg

def pretty_print_chart(chart):
    # print lagna
    if hasattr(chart, "lagna_sign"):
        print(f"Lagna(sign): {chart.lagna_sign} | Degree: {chart.lagna_degree:.2f}°")

    # print planets
    for p in chart.planets.values():
        retro_flag = " R" if p.retro else ""
        print(f"  {p.name}: sign={p.sign} deg={p.degree:.2f} lon={p.longitude:.2f}{retro_flag}")
# ---------------------------------------------------------
# House distance (1..12) : forward counting from sign1 → sign2
# Used by Tajik Panch-Vargiya Bala scaling + Varshesh
# ---------------------------------------------------------
def house_distance_12(sign1: int, sign2: int) -> int:
    """
    return 1..12 forward distance
    1 = same sign (1st house)
    2 = next sign (2nd house from sign1)
    ...
    12 = 12th house
    """
    d = (sign2 - sign1) % 12
    return 12 if d == 0 else d


