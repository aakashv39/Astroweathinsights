"""
Shar Parivartan Engine — Planetary Declination Change Detection.

Tracks when each planet (graha) crosses the celestial equator,
i.e. its declination changes from North to South or vice versa.

In Vedic market astrology:
  - North declination  → Mandi (bearish)
  - South declination  → Teji  (bullish)

Moon crosses the equator ~2 times per month.
All grahas exhibit this behaviour at their own frequency.
This is considered one of the highest-priority signals.
"""

import swisseph as swe
import datetime
import pytz
from .config import MUMBAI_LAT, MUMBAI_LON, TIMEZONE

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

# Max days to search forward for next declination crossing
_MAX_SEARCH_DAYS = {
    "moon": 16,       # crosses ~every 13-14 days
    "sun": 200,       # crosses ~every 6 months
    "mercury": 60,
    "venus": 120,
    "mars": 365,
    "jupiter": 400,
    "saturn": 400,
    "rahu": 400,
}


def _get_declination(jd: float, planet_id: int) -> tuple:
    """
    Return (declination_degrees, declination_speed) for a planet
    using tropical equatorial coordinates.
    """
    flags = swe.FLG_EQUATORIAL | swe.FLG_SPEED
    data = swe.calc_ut(jd, planet_id, flags)
    # data[0] = (RA, Decl, Dist, RA_speed, Decl_speed, Dist_speed)
    decl = data[0][1]
    decl_speed = data[0][4]
    return decl, decl_speed


def _find_next_crossing(jd_start: float, planet_id: int, current_decl: float,
                        max_days: int) -> dict | None:
    """
    Step forward in time to find the next moment declination crosses 0°.
    Uses coarse search (step_days) then bisection to refine.
    Returns dict with crossing info or None if not found.
    """
    # Coarse step: Moon needs finer steps
    step = 0.25 if planet_id == swe.MOON else 1.0
    prev_decl = current_decl
    prev_jd = jd_start

    jd = jd_start + step
    limit_jd = jd_start + max_days

    while jd <= limit_jd:
        decl, _ = _get_declination(jd, planet_id)
        # Check if sign changed (crossed 0°)
        if (prev_decl > 0 and decl <= 0) or (prev_decl < 0 and decl >= 0):
            # Bisection to narrow down
            lo, hi = prev_jd, jd
            for _ in range(30):  # ~30 iterations → sub-second accuracy
                mid = (lo + hi) / 2
                mid_decl, _ = _get_declination(mid, planet_id)
                if (prev_decl > 0 and mid_decl > 0) or (prev_decl < 0 and mid_decl < 0):
                    lo = mid
                else:
                    hi = mid
            cross_jd = (lo + hi) / 2
            cross_decl, _ = _get_declination(cross_jd, planet_id)
            # Direction: N→S or S→N
            if prev_decl > 0:
                direction = "North → South"
                trend = "Mandi → Teji"
            else:
                direction = "South → North"
                trend = "Teji → Mandi"
            # Convert JD back to datetime
            y, m, d, h = swe.revjul(cross_jd)
            hours = int(h)
            minutes = int((h - hours) * 60)
            cross_dt = datetime.datetime(y, m, d, hours, minutes)
            days_away = cross_jd - jd_start
            return {
                "cross_jd": cross_jd,
                "cross_date": cross_dt.strftime("%Y-%m-%d %H:%M"),
                "days_away": round(days_away, 2),
                "direction": direction,
                "trend": trend,
            }
        prev_decl = decl
        prev_jd = jd
        jd += step

    return None


def calculate_shar_parivartan(dt=None) -> dict:
    """
    For each planet, calculate:
      - Current declination (degrees)
      - Side: North or South
      - Declination speed (deg/day)
      - Market implication: North=Mandi, South=Teji
      - Next crossing date & direction
      - Days until next crossing
    """
    if dt is None:
        tz = pytz.timezone(TIMEZONE)
        dt = datetime.datetime.now(tz)

    jd = swe.julday(dt.year, dt.month, dt.day, dt.hour + dt.minute / 60)
    results = {}

    for name, pid in PLANETS.items():
        decl, decl_speed = _get_declination(jd, pid)

        side = "North" if decl >= 0 else "South"
        market = "Mandi" if decl >= 0 else "Teji"

        max_days = _MAX_SEARCH_DAYS.get(name, 200)
        crossing = _find_next_crossing(jd, pid, decl, max_days)

        results[name] = {
            "declination": round(decl, 4),
            "side": side,
            "market": market,
            "decl_speed": round(decl_speed, 6),
            "next_crossing": crossing,
        }

    return results
