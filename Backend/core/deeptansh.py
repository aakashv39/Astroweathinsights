from core.utils import lon_to_sign_degree
import math

def in_deeptansh(p1, p2, threshold=12.0):
    """
    Compare absolute ecliptic longitude difference, return True if <= threshold degrees.
    """
    lon_diff = abs((p1.longitude - p2.longitude + 180) % 360 - 180)
    return lon_diff <= threshold