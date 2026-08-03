"""
KP Intraday Engine — Krishnamurti Paddhati for Market Trading.

Generates 5-minute intraday time slots (9:00 AM – 3:30 PM IST)
and for each slot calculates:
  - Moon Sub Lord → House placement → Market impact
  - 5th House Sign Lord & Star Lord → House placements → Views
  - 11th House Star Lord → House placement → View
  - Final View  (from 5th Sign + 5th Star rules)
  - Outcome     (from Final View + Moon View rules)

All lookup tables (bhava impact, final view rules, extended outcome rules)
are embedded to avoid CSV file dependencies.
"""

import swisseph as swe
from datetime import datetime, timedelta, timezone

# ─── Swiss Ephemeris Config ──────────────────────────────────
swe.set_ephe_path("./ephemeris")
swe.set_sid_mode(swe.SIDM_LAHIRI)

SID_FLAG = swe.FLG_SIDEREAL | swe.FLG_SWIEPH

IST = timezone(timedelta(hours=5, minutes=30))

# Mumbai coordinates
MUMBAI_LAT = 19.0760
MUMBAI_LON = 72.8777

# ─── Planet IDs ──────────────────────────────────────────────
PLANETS = {
    "Sun": swe.SUN,
    "Moon": swe.MOON,
    "Mars": swe.MARS,
    "Mercury": swe.MERCURY,
    "Jupiter": swe.JUPITER,
    "Venus": swe.VENUS,
    "Saturn": swe.SATURN,
    "Rahu": swe.MEAN_NODE,
    "Ketu": swe.MEAN_NODE,
}

# ─── KP Tables ───────────────────────────────────────────────
RASHI_LORDS = {
    0: "Mars", 1: "Venus", 2: "Mercury", 3: "Moon",
    4: "Sun", 5: "Mercury", 6: "Venus", 7: "Mars",
    8: "Jupiter", 9: "Saturn", 10: "Saturn", 11: "Jupiter",
}

NAKSHATRA_LORDS = [
    "Ketu", "Venus", "Sun", "Moon", "Mars", "Rahu",
    "Jupiter", "Saturn", "Mercury",
    "Ketu", "Venus", "Sun", "Moon", "Mars", "Rahu",
    "Jupiter", "Saturn", "Mercury",
    "Ketu", "Venus", "Sun", "Moon", "Mars", "Rahu",
    "Jupiter", "Saturn", "Mercury",
]

DASHA_ORDER = [
    "Ketu", "Venus", "Sun", "Moon", "Mars",
    "Rahu", "Jupiter", "Saturn", "Mercury",
]
DASHA_YEARS = {
    "Ketu": 7, "Venus": 20, "Sun": 6, "Moon": 10, "Mars": 7,
    "Rahu": 18, "Jupiter": 16, "Saturn": 19, "Mercury": 17,
}

NAK_DEG = 13 + 20 / 60          # 13°20'
NAK_ARCMIN = 800.0               # 13°20' in arc-minutes
TOTAL_YEARS = 120.0

# ─── Bhava Impact Map (Planet-House → Impact) ────────────────
BHAVA_IMPACT = {
    "Mars-1": "Trending", "Mars-2": "Positive", "Mars-3": "Positive",
    "Mars-4": "Negative", "Mars-5": "Positive", "Mars-6": "Negative",
    "Mars-7": "Negative", "Mars-8": "Sudden Move", "Mars-9": "Negative",
    "Mars-10": "Negative", "Mars-11": "Trending", "Mars-12": "Negative",
    "Venus-1": "Positive", "Venus-2": "Positive", "Venus-3": "Positive",
    "Venus-4": "Negative", "Venus-5": "Positive", "Venus-6": "Negative",
    "Venus-7": "Trending", "Venus-8": "Strong Negative", "Venus-9": "Strong Positive",
    "Venus-10": "Strong Positive", "Venus-11": "Positive", "Venus-12": "Negative",
    "Mercury-1": "Positive", "Mercury-2": "Positive", "Mercury-3": "Positive",
    "Mercury-4": "Negative", "Mercury-5": "Positive", "Mercury-6": "Negative",
    "Mercury-7": "Trending", "Mercury-8": "Strong Negative", "Mercury-9": "Trending",
    "Mercury-10": "Positive", "Mercury-11": "Positive", "Mercury-12": "Trending",
    "Moon-1": "Positive", "Moon-2": "Positive", "Moon-3": "Strong Positive",
    "Moon-4": "Positive", "Moon-5": "Positive", "Moon-6": "Negative",
    "Moon-7": "Positive", "Moon-8": "Sudden Move", "Moon-9": "Strong Positive",
    "Moon-10": "Positive", "Moon-11": "Positive", "Moon-12": "Negative",
    "Sun-1": "Positive", "Sun-2": "Positive", "Sun-3": "Positive",
    "Sun-4": "Negative", "Sun-5": "Positive", "Sun-6": "Negative",
    "Sun-7": "Negative", "Sun-8": "Negative", "Sun-9": "Positive",
    "Sun-10": "Positive", "Sun-11": "Strong Negative", "Sun-12": "Strong Negative",
    "Jupiter-1": "Positive", "Jupiter-2": "Positive", "Jupiter-3": "Positive",
    "Jupiter-4": "Negative", "Jupiter-5": "Strong Positive", "Jupiter-6": "Negative",
    "Jupiter-7": "Positive", "Jupiter-8": "Sudden Move", "Jupiter-9": "Positive",
    "Jupiter-10": "Positive", "Jupiter-11": "Positive", "Jupiter-12": "Trending",
    "Saturn-1": "Positive", "Saturn-2": "Negative", "Saturn-3": "Positive",
    "Saturn-4": "Negative", "Saturn-5": "Negative", "Saturn-6": "Negative",
    "Saturn-7": "Negative", "Saturn-8": "Negative", "Saturn-9": "Negative",
    "Saturn-10": "Positive", "Saturn-11": "Positive", "Saturn-12": "Strong Negative",
    "Rahu-1": "Trap", "Rahu-2": "Trap", "Rahu-3": "Trap",
    "Rahu-4": "Trap", "Rahu-5": "Trap", "Rahu-6": "Trap",
    "Rahu-7": "Trap", "Rahu-8": "Trap", "Rahu-9": "Trap",
    "Rahu-10": "Trap", "Rahu-11": "Trap", "Rahu-12": "Trap",
    "Ketu-1": "Positive", "Ketu-2": "Negative", "Ketu-3": "Positive",
    "Ketu-4": "Negative", "Ketu-5": "Positive", "Ketu-6": "Negative",
    "Ketu-7": "Negative", "Ketu-8": "Negative", "Ketu-9": "Negative",
    "Ketu-10": "Positive", "Ketu-11": "Positive", "Ketu-12": "Positive",
}

# ─── Final View Rules (5th_Sign_View, 5th_Star_View → Final_View) ─
FINAL_VIEW_RULES = {
    ("Positive", "Positive"): "Positive",
    ("Positive", "Strong Negative"): "Neutral",
    ("Positive", "Negative"): "Neutral",
    ("Positive", "Trap"): "Trap",
    ("Positive", "Trending"): "Trending-Positive",
    ("Strong Positive", "Positive"): "Positive",
    ("Strong Positive", "Strong Negative"): "Neutral",
    ("Strong Positive", "Trending"): "Trending-Positive",
    ("Strong Positive", "Trap"): "Trap",
    ("Negative", "Negative"): "Negative",
    ("Negative", "Positive"): "Neutral",
    ("Negative", "Trending"): "Trending-Negative",
    ("Negative", "Strong Negative"): "Strong Negative",
    ("Strong Negative", "Strong Negative"): "Negative",
    ("Strong Negative", "Positive"): "Neutral",
    ("Strong Negative", "Trending"): "Trending-Negative",
    ("Strong Negative", "Trap"): "Trap",
    ("Trap", "Negative"): "Trap",
    ("Trap", "Strong Negative"): "Trending-Negative",
    ("Trap", "Trending"): "Trending-Negative",
    ("Trap", "Trap"): "Trap",
    ("Trending", "Positive"): "Trending-Positive",
    ("Trending", "Strong Negative"): "Trending-Negative",
    ("Trending", "Negative"): "Trending-Negative",
    ("Trending", "Strong Positive"): "Trending-Positive",
    ("Trending", "Trap"): "Trap",
    ("Trending", "Trending"): "Trending",
}

# ─── Extended Outcome Rules (Final_View, Moon_View → Outcome) ─
EXTENDED_OUTCOME_RULES = {
    ("Trap", "Negative"): "Trap Bears",
    ("Trap", "Strong Negative"): "Trap Bears",
    ("Trap", "Positive"): "Trap Bulls",
    ("Trap", "Strong Positive"): "Trap Bulls",
    ("Trending-Positive", "Positive"): "Buy",
    ("Trending-Positive", "Strong Positive"): "Strong Buy",
    ("Trending-Negative", "Negative"): "Sell",
    ("Trending-Negative", "Strong Negative"): "Strong Sell",
    ("Sudden Move", "Strong Positive"): "Sudden Positive Move",
    ("Sudden Move", "Positive"): "Sudden Positive Move",
    ("Sudden Move", "Neutral"): "Volatile",
    ("Sudden Move", "Strong Negative"): "Sudden Negative Move",
    ("Positive", "Positive"): "Buy",
    ("Positive", "Strong Positive"): "Buy",
    ("Negative", "Negative"): "Sell",
    ("Negative", "Strong Negative"): "Sell",
    ("Volatile", "Strong Positive"): "High Volatility Buy",
    ("Volatile", "Strong Negative"): "High Volatility Sell",
}


# ═══════════════════════════════════════════════════════════════
# UTILITY FUNCTIONS
# ═══════════════════════════════════════════════════════════════

def _norm(x: float) -> float:
    return x % 360.0


def _jd_from_ist(dt: datetime) -> float:
    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=IST)
    utc = dt.astimezone(timezone.utc)
    ut = utc.hour + utc.minute / 60 + utc.second / 3600
    return swe.julday(utc.year, utc.month, utc.day, ut)


def _rashi_lord(deg: float) -> str:
    return RASHI_LORDS[int(_norm(deg) // 30)]


def _star_lord(deg: float) -> str:
    return NAKSHATRA_LORDS[int(_norm(deg) // NAK_DEG)]


def _sub_lord(deg: float) -> str:
    deg = _norm(deg)
    nak = int(deg // NAK_DEG)
    offset = (deg - nak * NAK_DEG) * 60  # in arc-minutes
    start = NAKSHATRA_LORDS[nak]
    idx = DASHA_ORDER.index(start)
    total = 0.0
    lord = start
    for i in range(9):
        lord = DASHA_ORDER[(idx + i) % 9]
        span = NAK_ARCMIN * (DASHA_YEARS[lord] / TOTAL_YEARS)
        total += span
        if offset <= total:
            return lord
    return lord


def _bhava_house(lon: float, ascmc, lat: float, eps: float) -> int:
    """Placidus bhava chalit house placement."""
    armc = ascmc[2]
    return int(swe.house_pos(armc, lat, eps, [lon, 0.0, 1.0], b'P'))


def _get_view(planet: str, house: int) -> str:
    """Map planet-house to market impact."""
    return BHAVA_IMPACT.get(f"{planet}-{house}", "Neutral")


def _get_final_view(sign_view: str, star_view: str) -> str:
    return FINAL_VIEW_RULES.get((sign_view, star_view), "Neutral")


def _get_outcome(final_view: str, moon_view: str) -> str:
    return EXTENDED_OUTCOME_RULES.get((final_view, moon_view), "Neutral")


# ═══════════════════════════════════════════════════════════════
# KP SLOT CALCULATION
# ═══════════════════════════════════════════════════════════════

def calculate_kp_slot(dt: datetime,
                      lat: float = MUMBAI_LAT,
                      lon: float = MUMBAI_LON) -> dict:
    """
    Calculate KP data for a single time slot.

    Returns dict with:
      time, moon_sub, 5th_sign, 5th_star, 11th_star,
      moon_view, 5th_sign_view, 5th_star_view, 11th_view,
      final_view, outcome
    """
    jd = _jd_from_ist(dt)

    # Placidus houses
    houses, ascmc = swe.houses_ex(jd, lat, lon, b'P', SID_FLAG)
    eps = swe.calc_ut(jd, swe.ECL_NUT, 0)[0][0]

    # ── Moon Sub Lord ──
    moon_lon = swe.calc_ut(jd, swe.MOON, SID_FLAG)[0][0]
    moon_sl = _sub_lord(moon_lon)
    if moon_sl == "Ketu":
        rahu_lon = swe.calc_ut(jd, swe.MEAN_NODE, SID_FLAG)[0][0]
        moon_sl_lon = _norm(rahu_lon + 180)
    else:
        moon_sl_lon = swe.calc_ut(jd, PLANETS[moon_sl], SID_FLAG)[0][0]
    moon_sl_house = _bhava_house(moon_sl_lon, ascmc, lat, eps)

    # ── 5th House ──
    h5 = houses[4]
    fifth_rl = _rashi_lord(h5)
    fifth_stl = _star_lord(h5)

    fifth_rl_lon = swe.calc_ut(jd, PLANETS[fifth_rl], SID_FLAG)[0][0]
    fifth_rl_house = _bhava_house(fifth_rl_lon, ascmc, lat, eps)

    fifth_stl_lon = swe.calc_ut(jd, PLANETS[fifth_stl], SID_FLAG)[0][0]
    fifth_stl_house = _bhava_house(fifth_stl_lon, ascmc, lat, eps)

    # ── 11th House ──
    h11 = houses[10]
    eleventh_stl = _star_lord(h11)
    eleventh_stl_lon = swe.calc_ut(jd, PLANETS[eleventh_stl], SID_FLAG)[0][0]
    eleventh_stl_house = _bhava_house(eleventh_stl_lon, ascmc, lat, eps)

    # ── Views ──
    moon_sub_label = f"{moon_sl}-{moon_sl_house}"
    fifth_sign_label = f"{fifth_rl}-{fifth_rl_house}"
    fifth_star_label = f"{fifth_stl}-{fifth_stl_house}"
    eleventh_label = f"{eleventh_stl}-{eleventh_stl_house}"

    moon_view = _get_view(moon_sl, moon_sl_house)
    fifth_sign_view = _get_view(fifth_rl, fifth_rl_house)
    fifth_star_view = _get_view(fifth_stl, fifth_stl_house)
    eleventh_view = _get_view(eleventh_stl, eleventh_stl_house)

    final_view = _get_final_view(fifth_sign_view, fifth_star_view)
    outcome = _get_outcome(final_view, moon_view)

    return {
        "time": dt.strftime("%H:%M"),
        "moon_sub": moon_sub_label,
        "fifth_sign": fifth_sign_label,
        "fifth_star": fifth_star_label,
        "eleventh_star": eleventh_label,
        "moon_view": moon_view,
        "fifth_sign_view": fifth_sign_view,
        "fifth_star_view": fifth_star_view,
        "eleventh_view": eleventh_view,
        "final_view": final_view,
        "outcome": outcome,
    }


# ═══════════════════════════════════════════════════════════════
# FULL DAY KP SCAN
# ═══════════════════════════════════════════════════════════════

def generate_time_slots(date: datetime, step_minutes: int = 5):
    """Yield IST datetimes from 9:00 AM to 3:30 PM in `step_minutes` intervals."""
    t = datetime(date.year, date.month, date.day, 9, 0, tzinfo=IST)
    end = datetime(date.year, date.month, date.day, 15, 30, tzinfo=IST)
    while t <= end:
        yield t
        t += timedelta(minutes=step_minutes)


def calculate_kp_intraday(date: datetime = None,
                          step_minutes: int = 5,
                          lat: float = MUMBAI_LAT,
                          lon: float = MUMBAI_LON) -> list[dict]:
    """
    Generate KP intraday data for every `step_minutes` slot on a given date.

    Args:
        date: Date to scan (defaults to today IST).
        step_minutes: Interval between slots (default 5).
        lat, lon: Location coordinates.

    Returns:
        List of dicts, one per time slot.
    """
    if date is None:
        date = datetime.now(IST)

    slots = []
    for dt in generate_time_slots(date, step_minutes):
        slots.append(calculate_kp_slot(dt, lat, lon))
    return slots
