"""
Rashi Parivartan Engine — Planet Sign Change Detection.

Detects when each planet is about to change its Rashi (sign).
Rashi Parivartan is a key event in Vedic market astrology:
  - Planet entering a new rashi can trigger trend changes.
  - Planets near rashi boundary (sandhi) are weakened.
  - Direction of change (e.g., from Teji rashi to Mandi rashi) matters.

Uses real-time speed to estimate hours/days to next rashi change.
"""

import swisseph as swe
import datetime
import pytz
from .config import (
    MUMBAI_LAT, MUMBAI_LON, TIMEZONE,
    TEJI_RASHI, MANDI_RASHI,
)

RASHI_NAMES = {
    1: "Aries", 2: "Taurus", 3: "Gemini", 4: "Cancer",
    5: "Leo", 6: "Virgo", 7: "Libra", 8: "Scorpio",
    9: "Sagittarius", 10: "Capricorn", 11: "Aquarius", 12: "Pisces",
}

PLANETS = {
    "sun": swe.SUN,
    "moon": swe.MOON,
    "mercury": swe.MERCURY,
    "venus": swe.VENUS,
    "mars": swe.MARS,
    "jupiter": swe.JUPITER,
    "saturn": swe.SATURN,
    "rahu": swe.MEAN_NODE,
}


def _rashi_type(r: int) -> str:
    if r in TEJI_RASHI:
        return "Teji"
    elif r in MANDI_RASHI:
        return "Mandi"
    return "Neutral"


def calculate_rashi_parivartan(dt=None) -> dict:
    """
    For each planet, calculate:
      - Current rashi and degree within it
      - Degrees remaining to rashi boundary
      - Estimated time to rashi change (using current speed)
      - Next rashi and its type
      - Whether planet is in sandhi zone (last 1 degree or first 1 degree)
      - Trend change direction (Teji->Mandi, Mandi->Teji, etc.)
    """
    if dt is None:
        tz = pytz.timezone(TIMEZONE)
        dt = datetime.datetime.now(tz)

    jd = swe.julday(dt.year, dt.month, dt.day, dt.hour + dt.minute / 60)
    flags = swe.FLG_SIDEREAL | swe.FLG_SPEED

    results = {}

    for name, pid in PLANETS.items():
        data = swe.calc_ut(jd, pid, flags)
        longitude = data[0][0]
        if longitude < 0:
            longitude += 360
        speed = data[0][3]  # degrees per day
        retrograde = speed < 0

        rashi = int(longitude // 30) + 1
        degree_in_rashi = longitude % 30

        # For direct motion: degrees left to cross into next rashi
        # For retrograde: degrees left to cross back into previous rashi
        if not retrograde:
            degrees_to_change = 30.0 - degree_in_rashi
            next_rashi = (rashi % 12) + 1
            direction = "forward"
        else:
            degrees_to_change = degree_in_rashi
            next_rashi = ((rashi - 2) % 12) + 1  # previous rashi
            direction = "backward"

        # Estimate time to change
        abs_speed = abs(speed) if speed != 0 else 0.001
        days_to_change = degrees_to_change / abs_speed
        hours_to_change = days_to_change * 24

        # Approximate date of change
        change_date = dt + datetime.timedelta(days=days_to_change)

        # Sandhi zone: within 1 degree of rashi boundary
        in_sandhi = degree_in_rashi < 1.0 or degree_in_rashi > 29.0

        # Trend change analysis
        current_type = _rashi_type(rashi)
        next_type = _rashi_type(next_rashi)

        if current_type != next_type:
            trend_change = f"{current_type} -> {next_type}"
        else:
            trend_change = f"{current_type} (same)"

        results[name] = {
            "current_rashi": rashi,
            "current_rashi_name": RASHI_NAMES.get(rashi, ""),
            "current_rashi_type": current_type,
            "degree_in_rashi": round(degree_in_rashi, 4),
            "speed": round(speed, 6),
            "retrograde": retrograde,
            "direction": direction,
            "degrees_to_change": round(degrees_to_change, 4),
            "next_rashi": next_rashi,
            "next_rashi_name": RASHI_NAMES.get(next_rashi, ""),
            "next_rashi_type": next_type,
            "days_to_change": round(days_to_change, 2),
            "hours_to_change": round(hours_to_change, 1),
            "estimated_change_date": change_date.strftime("%Y-%m-%d %H:%M"),
            "in_sandhi": in_sandhi,
            "trend_change": trend_change,
        }

    return results
