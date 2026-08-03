import swisseph as swe
import datetime
import pytz
from .config import MUMBAI_LAT, MUMBAI_LON, TIMEZONE
from .nakshatra_engine import calculate_nakshatra
from .tithi_engine import calculate_tithi

# Set ephemeris path (ensure you have the Swiss Ephemeris files in ./ephemeris)
swe.set_ephe_path("./ephemeris")

# Use Lahiri Ayanamsha for sidereal (Vedic) calculations
swe.set_sid_mode(swe.SIDM_LAHIRI)

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

def get_mumbai_datetime():
    tz = pytz.timezone(TIMEZONE)
    return datetime.datetime.now(tz)

def calculate_navansh(longitude):
    """
    Proper Vedic D9 Navansh calculation.
    Navansh starting rashi depends on D1 rashi element:
      Fire  (1,5,9)  → starts from Aries (1)
      Earth (2,6,10) → starts from Capricorn (10)
      Air   (3,7,11) → starts from Libra (7)
      Water (4,8,12) → starts from Cancer (4)
    """
    d1_rashi = int(longitude // 30) + 1
    pada_index = int((longitude % 30) / (30 / 9))  # 0–8
    navansh_rashi = (((d1_rashi - 1) * 9 + pada_index) % 12) + 1
    return navansh_rashi

def get_planetary_positions(dt=None):
    if dt is None:
        dt = get_mumbai_datetime()
    jd = swe.julday(dt.year, dt.month, dt.day, dt.hour + dt.minute/60)
    positions = {}
    sun_long = None
    moon_long = None
    # Sidereal flag for Lahiri ayanamsha
    flags = swe.FLG_SIDEREAL | swe.FLG_SPEED
    # First pass: get Sun and Moon longitude for Tithi (use tropical for tithi)
    for name, pid in PLANETS.items():
        data = swe.calc_ut(jd, pid, flags)
        longitude = data[0][0]
        if longitude < 0:
            longitude += 360
        if name == "sun":
            sun_long = longitude
        if name == "moon":
            moon_long = longitude
    # Second pass: build positions with nakshatra and tithi
    for name, pid in PLANETS.items():
        data = swe.calc_ut(jd, pid, flags)
        longitude = data[0][0]
        if longitude < 0:
            longitude += 360
        speed = data[0][3]
        rashi = int(longitude // 30) + 1
        degree_in_rashi = longitude % 30
        retrograde = speed < 0
        navansh_rashi = calculate_navansh(longitude)
        nakshatra = calculate_nakshatra(longitude)
        tithi = None
        if sun_long is not None and moon_long is not None and name in ("sun", "moon"):
            tithi = calculate_tithi(sun_long, moon_long)
        # Format degree as DD:MM:SS
        deg_int = int(degree_in_rashi)
        min_part = (degree_in_rashi - deg_int) * 60
        min_int = int(min_part)
        sec_int = int((min_part - min_int) * 60)
        deg_dms = f"{deg_int:02d}:{min_int:02d}:{sec_int:02d}"
        positions[name] = {
            "D1": {
                "longitude": round(longitude, 4),
                "rashi": rashi,
                "rashi_name": RASHI_NAMES.get(rashi, ""),
                "degree_in_rashi": round(degree_in_rashi, 4),
                "degree_dms": deg_dms,
                "retrograde": retrograde,
                "speed": round(speed, 6),
                "nakshatra": nakshatra,
                "tithi": tithi if tithi is not None else "-"
            },
            "D9": {
                "navansh_rashi": navansh_rashi,
                "navansh_rashi_name": RASHI_NAMES.get(navansh_rashi, "")
            }
        }
    return positions
