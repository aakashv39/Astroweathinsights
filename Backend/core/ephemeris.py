"""
Ephemeris + Lagna + Solar Return (Varsh) aligned with Jagannatha Hora.
• Sidereal = Tropical − Lahiri Ayanamsa (Chitrapaksha)
• Solar return when SIDEREAL Sun ≈ Natal SIDEREAL Sun with RA match
• Compatible with Windows + Python + pyswisseph
"""

from typing import Optional, Dict
import datetime
from math import sin, cos, atan2, radians, degrees

from core.chart import Chart
from core.planets import Planet
from core.utils import lon_to_sign_degree
from config.settings import SPEED_RANK, RAHU_TYPE


# ---------------------------------------------------------
# Timezone → minutes
# ---------------------------------------------------------
def _tz_offset_minutes(tz: str) -> int:
    sign = 1 if tz.startswith('+') else -1
    h, m = map(int, tz[1:].split(':'))
    return sign * (h * 60 + m)


# ---------------------------------------------------------
# Lahiri Ayanamsa (JHora style)
# ---------------------------------------------------------
def jhora_lahiri_ayanamsa(jd: float) -> float:
    T = (jd - 2415020.0) / 36525.0
    return (22.460148 + 1.396042 * T + 3.08e-4 * T * T) % 360


# ---------------------------------------------------------
# Sidereal Right Ascension
# ---------------------------------------------------------
def _sidereal_ra(swe, jd: float, lon_sid: float) -> float:
    eps = swe.calc_ut(jd, swe.ECL_NUT)[0][0]
    lon_r = radians(lon_sid)
    eps_r = radians(eps)
    ra = atan2(sin(lon_r) * cos(eps_r), cos(lon_r))
    return degrees(ra) % 360


# ---------------------------------------------------------
# Build Chart object
# ---------------------------------------------------------
def _build_chart(longitudes: Dict[str, float],
                 lagna_sign: Optional[int],
                 lagna_degree: Optional[float],
                 retro_flags: Dict[str, bool]) -> Chart:
    planets = {}
    for name, lon in longitudes.items():
        sign, deg = lon_to_sign_degree(lon)
        planets[name] = Planet(
            name=name,
            longitude=lon,
            sign=sign,
            degree=deg,
            retro=retro_flags.get(name, False),
            speed_rank=SPEED_RANK.get(name, 9),
        )
    chart = Chart(planets=planets, lagna_sign=lagna_sign)
    chart.lagna_degree = lagna_degree
    return chart


# ---------------------------------------------------------
# Compute Lagna
# ---------------------------------------------------------
def _compute_lagna(swe, jd: float, lat: float, lon: float, ayan: float):
    cusps, ascmc = swe.houses(jd, lat, lon)
    asc_trop = ascmc[0]
    asc_sid = (asc_trop - ayan) % 360
    return int(asc_sid // 30) + 1, asc_sid


# ---------------------------------------------------------
# Solar Return Search — generic (±3 days around birthday)
# ---------------------------------------------------------
def _find_solar_return_datetime(
    swe,
    natal_sid_lon: float,
    natal_sid_ra: float,
    year: int,
    lat: float,
    lon: float,
    timezone: str,
    birth_month: int,
    birth_day: int,
) -> datetime.datetime:
    """
    Find Solar Return near the native's birthday in the given year:
    - Search ±3 days around (year, birth_month, birth_day) at 1-minute resolution,
      then refine ±3 minutes around the best hit at 1-second resolution.
    """

    flags = swe.FLG_SWIEPH | swe.FLG_TRUEPOS

    # Center of search window = birthday in that year at 00:00 local
    center = datetime.datetime(year, birth_month, birth_day, 0, 0)

    # coarse window ±3 days
    start = center - datetime.timedelta(days=3)
    stop = center + datetime.timedelta(days=3)

    dt = start
    best_dt = dt
    best_diff = 999.0

    # ---- coarse 1-minute scan ----
    while dt <= stop:
        dt_utc = dt - datetime.timedelta(minutes=_tz_offset_minutes(timezone))
        jd = swe.julday(
            dt_utc.year,
            dt_utc.month,
            dt_utc.day,
            dt_utc.hour + dt_utc.minute / 60.0,
        )

        lon_trop = swe.calc_ut(jd, swe.SUN, flags)[0][0] % 360
        lon_sid = (lon_trop - jhora_lahiri_ayanamsa(jd)) % 360
        ra = _sidereal_ra(swe, jd, lon_sid)

        diff = abs(lon_sid - natal_sid_lon) + abs(ra - natal_sid_ra)
        if diff < best_diff:
            best_diff = diff
            best_dt = dt

        dt += datetime.timedelta(minutes=1)

    # ---- fine ±3 minutes window @ 1 second ----
    dt = best_dt - datetime.timedelta(minutes=3)
    end_fine = best_dt + datetime.timedelta(minutes=3)

    while dt <= end_fine:
        dt_utc = dt - datetime.timedelta(minutes=_tz_offset_minutes(timezone))
        jd = swe.julday(
            dt_utc.year,
            dt_utc.month,
            dt_utc.day,
            dt_utc.hour + dt_utc.minute / 60.0 + dt_utc.second / 3600.0,
        )

        lon_trop = swe.calc_ut(jd, swe.SUN, flags)[0][0] % 360
        lon_sid = (lon_trop - jhora_lahiri_ayanamsa(jd)) % 360
        ra = _sidereal_ra(swe, jd, lon_sid)

        diff = abs(lon_sid - natal_sid_lon) + abs(ra - natal_sid_ra)
        if diff < best_diff:
            best_diff = diff
            best_dt = dt
            if diff < 1e-9:
                break

        dt += datetime.timedelta(seconds=1)

    return best_dt


# ---------------------------------------------------------
# Attach varga lords + house lords + depositor
# ---------------------------------------------------------
def _attach_lords_and_vargas(chart: Chart) -> None:

    # Rasi lords
    sign_lords = {
        1: "Mars", 2: "Venus", 3: "Mercury", 4: "Moon",
        5: "Sun", 6: "Mercury", 7: "Venus", 8: "Mars",
        9: "Jupiter", 10: "Saturn", 11: "Saturn", 12: "Jupiter"
    }
    chart.sign_lords = sign_lords

    # Uchcha and Moolatrikona
    chart.uchcha_signs = {
        "Sun": 1, "Moon": 2, "Mars": 10, "Mercury": 6,
        "Jupiter": 4, "Venus": 12, "Saturn": 7
    }
    chart.mooltrikona_signs = {
        "Sun": 5, "Moon": 2, "Mars": 1, "Mercury": 6,
        "Jupiter": 9, "Venus": 6, "Saturn": 11
    }

    # Varga signs placeholders (minimum needed for Panch-Vargiya)
    chart.hora_signs = {}
    chart.drekkana_signs = {}
    chart.navamsa_signs = {}
    chart.saptamsa_signs = {}

    # Compute vargas (simple scheme)
    for p in chart.planets.values():
        sign = p.sign
        deg = p.degree

        # Hora
        chart.hora_signs[p.name] = 1 if deg < 15 else 2

        # Drekkana
        chart.drekkana_signs[p.name] = int(deg // 10) + 1  # 1..3

        # Navamsa (9 parts)
        nav_part = int(deg / (30.0 / 9.0))  # 0..8
        chart.navamsa_signs[p.name] = ((sign - 1) * 9 + nav_part) % 12 + 1

        # Saptamsa (7 parts)
        sap_part = int(deg / (30.0 / 7.0))  # 0..6
        chart.saptamsa_signs[p.name] = ((sign - 1) * 7 + sap_part) % 12 + 1

    # House → Lord table
    house_lord = {}
    for house in range(1, 13):
        sign = ((chart.lagna_sign + house - 2) % 12) + 1
        house_lord[house] = sign_lords[sign]
    chart.house_lord = house_lord

    # Depositor helpers
    def get_ruler_of_sign(sign: int) -> str:
        return sign_lords[sign]

    def get_depositor(planet_name: str) -> str:
        sign = chart.planets[planet_name].sign
        return sign_lords[sign]

    chart.ruler_of_sign = get_ruler_of_sign
    chart.depositor = get_depositor

    # Planet → House mapping
    chart.planet_house = {
        name: ((p.sign - chart.lagna_sign) % 12) + 1
        for name, p in chart.planets.items()
    }


# ---------------------------------------------------------
# MAIN: compute natal or varsh chart
# ---------------------------------------------------------
def compute_chart(
    date: str,
    time: str,
    lat: float,
    lon: float,
    timezone: str,
    solar_return_year: Optional[int] = None,
    planet_longitudes: Optional[Dict[str, float]] = None,
) -> Chart:

    import swisseph as swe

    # -------------- Manual input mode --------------
    if planet_longitudes:
        chart = _build_chart(planet_longitudes, None, None, {})
        chart.solar_return_datetime = None
        _attach_lords_and_vargas(chart)
        return chart

    flags = swe.FLG_SWIEPH | swe.FLG_TRUEPOS

    # -------------- Birth JD --------------
    dt = datetime.datetime.fromisoformat(f"{date}T{time}")
    dt_utc = dt - datetime.timedelta(minutes=_tz_offset_minutes(timezone))
    jd_birth = swe.julday(
        dt_utc.year,
        dt_utc.month,
        dt_utc.day,
        dt_utc.hour + dt_utc.minute / 60.0,
    )

    # parse birth month/day from the same 'date' string
    birth_date = datetime.date.fromisoformat(date)
    birth_month = birth_date.month
    birth_day = birth_date.day

    # Natal Sun sidereal lon + RA
    pos_nat = swe.calc_ut(jd_birth, swe.SUN, flags)[0]
    natal_sid_lon = (pos_nat[0] - jhora_lahiri_ayanamsa(jd_birth)) % 360
    natal_sid_ra = _sidereal_ra(swe, jd_birth, natal_sid_lon)

    # -------------- Solar Return --------------
    if solar_return_year:
        dt_sr_local = _find_solar_return_datetime(
            swe,
            natal_sid_lon,
            natal_sid_ra,
            solar_return_year,
            lat,
            lon,
            timezone,
            birth_month,
            birth_day,
        )
        dt_sr_utc = dt_sr_local - datetime.timedelta(minutes=_tz_offset_minutes(timezone))
        jd = swe.julday(
            dt_sr_utc.year,
            dt_sr_utc.month,
            dt_sr_utc.day,
            dt_sr_utc.hour + dt_sr_utc.minute / 60.0,
        )
    else:
        dt_sr_local = None
        jd = jd_birth

    ayan = jhora_lahiri_ayanamsa(jd)

    # -------------- Planet longitudes --------------
    rahu_code = swe.TRUE_NODE if RAHU_TYPE.upper() == "TRUE" else swe.MEAN_NODE
    codes = {
        "Sun": swe.SUN,
        "Moon": swe.MOON,
        "Mercury": swe.MERCURY,
        "Venus": swe.VENUS,
        "Mars": swe.MARS,
        "Jupiter": swe.JUPITER,
        "Saturn": swe.SATURN,
        "Rahu": rahu_code,
        "Ketu": None,
    }

    sid_lons: Dict[str, float] = {}
    retro: Dict[str, bool] = {}

    for name, code in codes.items():
        if name == "Ketu":
            continue
        pos = swe.calc_ut(jd, code, flags)[0]
        lon_trop = pos[0] % 360
        sid_lons[name] = (lon_trop - ayan) % 360
        retro[name] = pos[3] < 0

    sid_lons["Ketu"] = (sid_lons["Rahu"] + 180) % 360
    retro["Ketu"] = retro["Rahu"]

    lagna_sign, lagna_degree = _compute_lagna(swe, jd, lat, lon, ayan)

    chart = _build_chart(sid_lons, lagna_sign, lagna_degree, retro)
    chart.solar_return_datetime = dt_sr_local
    chart.ayanamsa = ayan  # optional, useful for printing tropical later

    _attach_lords_and_vargas(chart)
    return chart
