"""
Advanced Aspect Engine — Full Planetary Aspect Analysis with Trading Signals.

Calculates all planetary aspects for a given day (10-min intervals),
tracking aspect start/end times, durations, nature (+/-), Jay/Prajay rule,
special aspects (Mars/Jupiter/Saturn), and Buy/Sell signals.

Based on Mukesh Sir's aspect rules.
"""

import swisseph as swe
from datetime import datetime, timedelta, timezone
from .config import MUMBAI_LAT, MUMBAI_LON, TIMEZONE

# ─── Swiss Ephemeris Config ──────────────────────────────────
swe.set_ephe_path("./ephemeris")

IST = timezone(timedelta(hours=5, minutes=30))

# ─── Planets ─────────────────────────────────────────────────
PLANETS = {
    "Sun": swe.SUN,
    "Moon": swe.MOON,
    "Mars": swe.MARS,
    "Mercury": swe.MERCURY,
    "Jupiter": swe.JUPITER,
    "Venus": swe.VENUS,
    "Saturn": swe.SATURN,
    "Uranus": swe.URANUS,
    "Neptune": swe.NEPTUNE,
    "Pluto": swe.PLUTO,
    "Rahu": swe.TRUE_NODE,
    "Ketu": "KETU",
}

BENEFICS = {"Jupiter", "Venus", "Mercury", "Moon", "Neptune"}
MALEFICS = {"Mars", "Saturn", "Sun", "Uranus", "Pluto", "Rahu", "Ketu"}

# ─── Rashi Lords ─────────────────────────────────────────────
RASHI_LORDS = {
    1: "Mars", 2: "Venus", 3: "Mercury", 4: "Moon", 5: "Sun", 6: "Mercury",
    7: "Venus", 8: "Mars", 9: "Jupiter", 10: "Saturn", 11: "Saturn", 12: "Jupiter",
}

# ─── Rashi Groups ────────────────────────────────────────────
SAME_GROUP = [(1, 8), (3, 10), (5, 12), (7, 2), (9, 4), (11, 6)]
OPPOSITE_GROUP = [(1, 6), (2, 9), (3, 8), (4, 11), (5, 10), (7, 12)]

# ─── Planetary Dignities ─────────────────────────────────────
EXALTATION = {"Sun": 1, "Moon": 2, "Mars": 10, "Mercury": 6, "Jupiter": 4, "Venus": 12, "Saturn": 7}
DEBILITATION = {"Sun": 7, "Moon": 8, "Mars": 4, "Mercury": 12, "Jupiter": 10, "Venus": 6, "Saturn": 1}
OWN_SIGN = {
    "Sun": [5], "Moon": [4], "Mars": [1, 8], "Mercury": [3, 6],
    "Jupiter": [9, 12], "Venus": [2, 7], "Saturn": [10, 11],
}

# ─── Target Aspect Degrees ───────────────────────────────────
TARGET_DEGREES = [0, 22.5, 26, 30, 45, 60, 72, 90, 120, 135, 150, 180, 240, 270, 300, 315, 330]

ASPECT_NAMES = {
    0: "Conjunction (Yukti)", 22.5: "Semi-Octile", 26: "Custom-26°",
    30: "Semi-Sextile", 45: "Semi-Square", 60: "Sextile",
    72: "Quintile", 90: "Square", 120: "Trine",
    135: "Sesquiquadrate", 150: "Quincunx", 180: "Opposition",
    240: "Trine (240°)", 270: "Square (270°)", 300: "Sextile (300°)",
    315: "Semi-Square (315°)", 330: "Semi-Sextile (330°)",
}

# ─── Special Aspects ─────────────────────────────────────────
SPECIAL_ASPECTS = {"Mars": [4, 7, 8], "Jupiter": [5, 7, 9], "Saturn": [3, 7, 10]}

# ─── Orbital Priority (Lower = Slower) ──────────────────────
ORBITAL_PRIORITY = {
    "Saturn": 1, "Jupiter": 2, "Mars": 3, "Sun": 4, "Venus": 5,
    "Mercury": 6, "Moon": 7, "Uranus": 8, "Neptune": 9, "Pluto": 10,
    "Rahu": 11, "Ketu": 12,
}

# ─── Nakshatra Names ─────────────────────────────────────────
NAKSHATRAS = [
    "Ashwini", "Bharani", "Krittika", "Rohini", "Mrigashira", "Ardra",
    "Punarvasu", "Pushya", "Ashlesha", "Magha", "Purva Phalguni",
    "Uttara Phalguni", "Hasta", "Chitra", "Swati", "Vishakha", "Anuradha",
    "Jyeshtha", "Mula", "Purva Ashadha", "Uttara Ashadha", "Shravana",
    "Dhanishta", "Shatabhisha", "Purva Bhadrapada", "Uttara Bhadrapada", "Revati",
]


# ═══════════════════════════════════════════════════════════════
# HELPER FUNCTIONS
# ═══════════════════════════════════════════════════════════════

def _get_nakshatra(lon_deg: float) -> str:
    idx = int(lon_deg // 13.3333)
    return NAKSHATRAS[min(idx, 26)]


def _get_planet_strength(planet: str, sign: int) -> str:
    if planet in EXALTATION and sign == EXALTATION[planet]:
        return "exalted"
    if planet in DEBILITATION and sign == DEBILITATION[planet]:
        return "debilitated"
    if planet in OWN_SIGN and sign in OWN_SIGN[planet]:
        return "own_sign"
    return "normal"


def _house_diff(r1: int, r2: int) -> int:
    return (r2 - r1) % 12


def _check_rashi_group(r1: int, r2: int) -> str:
    if (r1, r2) in SAME_GROUP or (r2, r1) in SAME_GROUP:
        return "+"
    if (r1, r2) in OPPOSITE_GROUP or (r2, r1) in OPPOSITE_GROUP:
        return "-"
    return "-"


def _apply_3_11_rule(p1: str, p2: str, angle: float) -> str:
    if "Saturn" in (p1, p2):
        if angle == 60:
            return "-"
        elif angle == 300:
            return "+"
    return "+"


def _jay_prajay_rule(p1: str, p2: str, pos1: dict, pos2: dict) -> str:
    if p1 in BENEFICS and p2 in BENEFICS:
        return "Benefic — No Jay"
    if p1 in MALEFICS and p2 in MALEFICS:
        return "Malefic — No Jay"

    lat1, lat2 = pos1["lat"], pos2["lat"]
    if lat1 >= 0 and lat2 >= 0:
        return f"{p1 if lat1 > lat2 else p2} Jay"
    elif lat1 < 0 and lat2 < 0:
        return f"{p1 if abs(lat1) < abs(lat2) else p2} Jay"
    elif lat1 >= 0:
        return f"{p1} Jay"
    else:
        return f"{p2} Jay"


def _apply_aspect_logic(p1, p2, r1, r2, pos1, pos2, angle):
    diff = _house_diff(r1, r2)
    if angle == 0:
        return "Check Jay Rule"

    house_diff_val = diff + 1
    special_aspect_type = ""
    if p1 in SPECIAL_ASPECTS and house_diff_val in SPECIAL_ASPECTS[p1]:
        special_aspect_type = f"{p1} to {house_diff_val}"
    elif p2 in SPECIAL_ASPECTS and (12 - house_diff_val + 1) in SPECIAL_ASPECTS[p2]:
        special_aspect_type = f"{p2} to {12 - house_diff_val + 1}"

    retrograde_p1 = pos1["retrograde"]
    retrograde_p2 = pos2["retrograde"]
    strength_p1 = _get_planet_strength(p1, r1)
    strength_p2 = _get_planet_strength(p2, r2)

    if angle in (60, 300):
        result = _apply_3_11_rule(p1, p2, angle)
        if strength_p1 == "exalted" and strength_p2 == "debilitated":
            return "+" if p1 in BENEFICS else "-"
        if strength_p2 == "exalted" and strength_p1 == "debilitated":
            return "+" if p2 in BENEFICS else "-"
        if "Saturn" in (p1, p2) and (retrograde_p1 or retrograde_p2):
            return "-" if result == "+" else "+"
        return result
    elif angle in (90, 270):
        if {p1, p2} == {"Sun", "Jupiter"}:
            return "+"
        if p1 == "Mars" and p2 == "Saturn" and angle == 90:
            return "+"
        if p1 == "Saturn" and p2 == "Mars" and angle == 90:
            return "-"
        if special_aspect_type:
            if "Saturn to 3" in special_aspect_type or "Saturn to 10" in special_aspect_type:
                return "-"
            if "Jupiter to 5" in special_aspect_type or "Jupiter to 9" in special_aspect_type:
                return "+"
        return "-"
    elif angle == 180:
        if r1 <= 6 and r2 >= 7:
            decisive = p2
        elif r2 <= 6 and r1 >= 7:
            decisive = p1
        else:
            return "-"
        return "+" if decisive in BENEFICS else "-"
    elif angle in (120, 240):
        return "+"
    elif angle == 22.5:
        return "-"
    elif angle in (26, 72):
        return "+"
    elif angle in (30, 330):
        return _check_rashi_group(r1, r2)
    elif angle in (45, 315):
        n1 = _check_rashi_group(r1, r2)
        n2 = _apply_3_11_rule(p1, p2, angle)
        return "+" if n1 == "+" and n2 == "+" else "-"
    elif angle in (135, 150, 225):
        if diff == 5:
            return "+"
        elif diff == 7:
            return "-" if angle == 150 else _check_rashi_group(r1, r2)
    return "-"


# ═══════════════════════════════════════════════════════════════
# PLANETARY POSITIONS
# ═══════════════════════════════════════════════════════════════

def _get_positions(dt: datetime, lat: float = MUMBAI_LAT, lon: float = MUMBAI_LON) -> dict:
    """Get all planetary positions (sidereal) for a given datetime."""
    swe.set_topo(lon, lat, 0)
    swe.set_sid_mode(swe.SIDM_LAHIRI)

    if dt.tzinfo is None:
        dt = dt.replace(tzinfo=IST)
    utc = dt.astimezone(timezone.utc)
    jd = swe.julday(utc.year, utc.month, utc.day,
                    utc.hour + utc.minute / 60.0 + utc.second / 3600.0)

    positions = {}
    rahu_data = None

    for name, pid in PLANETS.items():
        if name == "Ketu":
            if rahu_data:
                lon_deg = (rahu_data["lon"] + 180) % 360
                positions["Ketu"] = {
                    "lon": lon_deg,
                    "lat": -rahu_data["lat"],
                    "decl": -rahu_data["decl"],
                    "sign": int(lon_deg // 30) + 1,
                    "retrograde": False,
                    "nakshatra": _get_nakshatra(lon_deg),
                }
            continue

        flags = swe.FLG_SWIEPH | swe.FLG_SIDEREAL
        data = swe.calc_ut(jd, pid, flags)
        lon_deg = data[0][0]
        lat_deg = data[0][1]
        speed = data[0][3]

        eq_flags = swe.FLG_SWIEPH | swe.FLG_EQUATORIAL | swe.FLG_SIDEREAL
        eq_data = swe.calc(jd, pid, eq_flags)
        decl = eq_data[0][1]

        sign = int(lon_deg // 30) + 1
        pos = {
            "lon": lon_deg,
            "lat": lat_deg,
            "decl": decl,
            "sign": sign,
            "retrograde": speed < 0,
            "nakshatra": _get_nakshatra(lon_deg),
        }
        positions[name] = pos
        if name == "Rahu":
            rahu_data = pos

    return positions


# ═══════════════════════════════════════════════════════════════
# ASPECT DETECTION (ONE DAY)
# ═══════════════════════════════════════════════════════════════

def calculate_daily_aspects(date: datetime = None,
                            lat: float = MUMBAI_LAT,
                            lon: float = MUMBAI_LON,
                            interval_minutes: int = 10,
                            orb: float = 1.0) -> list[dict]:
    """
    Calculate all planetary aspects for a single day.

    Scans the day at `interval_minutes` resolution, tracks aspect
    start/end, duration, nature, jay/prajay, special aspects, and signal.

    Args:
        date: The date to scan (defaults to today IST).
        lat, lon: Location.
        interval_minutes: Scan resolution in minutes.
        orb: Orb tolerance in degrees.

    Returns:
        List of aspect dicts sorted by start time.
    """
    if date is None:
        date = datetime.now(IST)

    # Day boundaries: 00:00 to 23:59 IST
    day_start = datetime(date.year, date.month, date.day, 0, 0, tzinfo=IST)
    day_end = datetime(date.year, date.month, date.day, 23, 59, tzinfo=IST)

    aspect_state = {}
    results = []

    t = day_start
    while t <= day_end:
        positions = _get_positions(t, lat, lon)
        if positions:
            _check_aspects(positions, t, aspect_state, results, orb)
        t += timedelta(minutes=interval_minutes)

    # Finalize any still-active aspects at end of day
    for key, entry in list(aspect_state.items()):
        entry["End Time"] = day_end
        dur = (day_end - entry["Start Time"]).total_seconds() / 60
        entry["Duration (mins)"] = round(dur, 1)
        entry["ongoing"] = True
        results.append(entry)

    # Sort by start time
    results.sort(key=lambda x: x["Start Time"])

    # Format times as strings
    for r in results:
        r["start_str"] = r["Start Time"].astimezone(IST).strftime("%H:%M")
        r["end_str"] = r["End Time"].astimezone(IST).strftime("%H:%M")
        r["start_full"] = r["Start Time"].astimezone(IST).strftime("%Y-%m-%d %H:%M")
        r["end_full"] = r["End Time"].astimezone(IST).strftime("%Y-%m-%d %H:%M")

    return results


def _check_aspects(positions, timestamp, aspect_state, results, orb=1.0):
    """Check all planet pairs for aspects at a given time."""
    planet_names = sorted(positions.keys())

    for i in range(len(planet_names)):
        for j in range(i + 1, len(planet_names)):
            p1 = planet_names[i]
            p2 = planet_names[j]

            lon1 = positions[p1]["lon"]
            lon2 = positions[p2]["lon"]
            angle = abs(lon1 - lon2)
            angle = angle if angle <= 180 else 360 - angle

            r1 = positions[p1]["sign"]
            r2 = positions[p2]["sign"]
            house_diff_val = _house_diff(r1, r2) + 1

            # Check special aspects
            special_aspect_applies = False
            special_aspect_type = ""
            if p1 in SPECIAL_ASPECTS and house_diff_val in SPECIAL_ASPECTS[p1]:
                special_aspect_applies = True
                special_aspect_type = f"{p1} {house_diff_val}th house aspect"
            elif p2 in SPECIAL_ASPECTS and (12 - house_diff_val + 1) in SPECIAL_ASPECTS[p2]:
                special_aspect_applies = True
                special_aspect_type = f"{p2} {(12 - house_diff_val + 1)}th house aspect"

            # Consistent key: slower planet first
            slow, fast = (p1, p2) if ORBITAL_PRIORITY.get(p1, 99) <= ORBITAL_PRIORITY.get(p2, 99) else (p2, p1)

            for target in TARGET_DEGREES:
                key = f"{slow}-{fast}-{target}"
                if abs(angle - target) <= orb:
                    if key not in aspect_state:
                        nature = _apply_aspect_logic(p1, p2, r1, r2,
                                                     positions[p1], positions[p2], target)
                        victory = ""
                        if target == 0:
                            victory = _jay_prajay_rule(p1, p2, positions[p1], positions[p2])

                        # Signal
                        signal = "Buy" if nature == "+" else ("Sell" if nature == "-" else "Hold")
                        if special_aspect_applies:
                            if "Jupiter" in special_aspect_type and nature == "+":
                                signal = "Strong Buy"
                            elif "Saturn" in special_aspect_type and nature == "-":
                                signal = "Strong Sell"

                        aspect_state[key] = {
                            "Start Time": timestamp,
                            "End Time": None,
                            "Duration (mins)": None,
                            "Planet 1": p1,
                            "Planet 2": p2,
                            "Longitude 1": round(lon1, 2),
                            "Longitude 2": round(lon2, 2),
                            "Angle": round(angle, 2),
                            "Target Angle": target,
                            "Aspect Name": ASPECT_NAMES.get(target, f"{target}°"),
                            "Orb": round(abs(angle - target), 2),
                            "Sign 1": r1,
                            "Sign 2": r2,
                            "Nakshatra 1": positions[p1]["nakshatra"],
                            "Nakshatra 2": positions[p2]["nakshatra"],
                            "Special Aspect": special_aspect_type if special_aspect_applies else "",
                            "Nature": nature,
                            "Victory": victory,
                            "Signal": signal,
                            "ongoing": False,
                        }
                else:
                    if key in aspect_state:
                        entry = aspect_state.pop(key)
                        entry["End Time"] = timestamp
                        dur = (timestamp - entry["Start Time"]).total_seconds() / 60
                        entry["Duration (mins)"] = round(dur, 1)
                        if "Victory" not in entry:
                            entry["Victory"] = ""
                        results.append(entry)
