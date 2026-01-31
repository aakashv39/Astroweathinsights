"""
Full Sahama (Arabic Lots) Engine for Varshaphal / Tajik

• Uses Varsh chart longitudes (NOT natal)
• Day / Night rule: Sun in houses 7–12 from Varsh Lagna = Day chart
• All Sahamas follow A – B + Lagna pattern
• Output dictionary: { sahama_name : {lon, sign, deg, min, sec, mode} }
"""

from typing import Dict, Tuple


# --------------------------------------------------------
# Utility Data
# --------------------------------------------------------
ZODIAC_SIGNS = {
    1: "Aries", 2: "Taurus", 3: "Gemini", 4: "Cancer",
    5: "Leo", 6: "Virgo", 7: "Libra", 8: "Scorpio",
    9: "Sagittarius", 10: "Capricorn", 11: "Aquarius", 12: "Pisces",
}

# Sign Lords for Varshaphal (Rāśi)
SIGN_LORD = {
    1:"Mars", 2:"Venus", 3:"Mercury", 4:"Moon",
    5:"Sun", 6:"Mercury", 7:"Venus", 8:"Mars",
    9:"Jupiter", 10:"Saturn", 11:"Saturn", 12:"Jupiter"
}


# --------------------------------------------------------
# Utility Functions
# --------------------------------------------------------
def normalize_longitude(lon: float) -> float:
    lon %= 360.0
    return lon + 360 if lon < 0 else lon

def lon_to_sign_dms(lon: float) -> Tuple[int, int, int, float]:
    lon = normalize_longitude(lon)
    sign = int(lon // 30) + 1
    rest = lon % 30
    deg = int(rest)
    m_f = (rest - deg) * 60.0
    minute = int(m_f)
    sec = (m_f - minute) * 60.0
    return sign, deg, minute, sec

def is_day_varsh(chart) -> bool:
    """Sun in houses 7–12 from Lagna = day chart."""
    sun = chart.planets["Sun"]
    house = ((sun.sign - chart.lagna_sign) % 12) + 1
    return 7 <= house <= 12

def make_result(name, mode, lon):
    sign, deg, m, s = lon_to_sign_dms(lon)
    return {
        "name": name,
        "mode": mode,
        "longitude": lon,
        "sign": sign,
        "sign_name": ZODIAC_SIGNS[sign],
        "deg": deg,
        "min": m,
        "sec": s,
    }


# --------------------------------------------------------
# Helper: Cusp longitudes — (Lagna degree + X houses)
# --------------------------------------------------------
def cusp(chart, house_from_lagna):
    return normalize_longitude(chart.lagna_degree + (house_from_lagna - 1) * 30)


# --------------------------------------------------------
# Punya Sahama — foundation for Yasas
# --------------------------------------------------------
def compute_punya(chart):
    L = chart.lagna_degree
    Sun = chart.planets["Sun"].longitude
    Moon = chart.planets["Moon"].longitude

    if is_day_varsh(chart):
        raw = L + Moon - Sun
        mode = "DAY: Lagna + Moon - Sun"
    else:
        raw = L + Sun - Moon
        mode = "NIGHT: Lagna + Sun - Moon"

    return make_result("Punya Sahama", mode, normalize_longitude(raw))


# --------------------------------------------------------
# House → Lord helper
# --------------------------------------------------------
def lord_of_house(chart, house_num):
    """Returns planetary lord of a house from Varsh chart."""
    sign = ((chart.lagna_sign + (house_num - 1) - 1) % 12) + 1
    return SIGN_LORD[sign]


# --------------------------------------------------------
# MASTER — compute ALL Sahamas
# --------------------------------------------------------
def compute_all_sahamas(chart) -> Dict[str, dict]:

    L = chart.lagna_degree
    p = {k: v.longitude for k, v in chart.planets.items()}
    day = is_day_varsh(chart)

    sah = {}
    punya = compute_punya(chart)
    sah["Punya Sahama"] = punya

    # ------------------ Raja / Pitru ------------------
    if day:
        raw = L + p["Saturn"] - p["Sun"]
        mode = "DAY: Saturn - Sun + Lagna"
    else:
        raw = L + p["Sun"] - p["Saturn"]
        mode = "NIGHT: Sun - Saturn + Lagna"
    sah["Raja Sahama"] = make_result("Raja Sahama", mode, normalize_longitude(raw))
    sah["Pitru Sahama"] = sah["Raja Sahama"]  # exact same formula

    # ------------------ Yasas ------------------
    if day:
        raw = L + p["Jupiter"] - punya["longitude"]
        mode = "DAY: Jupiter - Punya + Lagna"
    else:
        raw = L + punya["longitude"] - p["Jupiter"]
        mode = "NIGHT: Punya - Jupiter + Lagna"
    sah["Yasas Sahama"] = make_result("Yasas Sahama", mode, normalize_longitude(raw))

    # ------------------ Matru ------------------
    if day:
        raw = L + p["Moon"] - p["Venus"]
        mode = "DAY: Moon - Venus + Lagna"
    else:
        raw = L + p["Venus"] - p["Moon"]
        mode = "NIGHT: Venus - Moon + Lagna"
    sah["Matru Sahama"] = make_result("Matru Sahama", mode, normalize_longitude(raw))

    # ------------------ Putra ------------------
    raw = L + p["Jupiter"] - p["Moon"]
    sah["Putra Sahama"] = make_result("Putra Sahama", "Jupiter - Moon + Lagna", normalize_longitude(raw))

    # ------------------ Karma ------------------
    if day:
        raw = L + p["Mars"] - p["Mercury"]
        mode = "DAY: Mars - Mercury + Lagna"
    else:
        raw = L + p["Mercury"] - p["Mars"]
        mode = "NIGHT: Mercury - Mars + Lagna"
    sah["Karma Sahama"] = make_result("Karma Sahama", mode, normalize_longitude(raw))

    # ------------------ Roga ------------------
    if day:
        raw = L + p["Saturn"] - p["Moon"]
        mode = "DAY: Saturn - Moon + Lagna"
    else:
        raw = L + p["Moon"] - p["Saturn"]
        mode = "NIGHT: Moon - Saturn + Lagna"
    sah["Roga Sahama"] = make_result("Roga Sahama", mode, normalize_longitude(raw))

    # ------------------ Bandhu ------------------
    if day:
        raw = L + p["Mercury"] - p["Moon"]
        mode = "DAY: Mercury - Moon + Lagna"
    else:
        raw = L + p["Moon"] - p["Mercury"]
        mode = "NIGHT: Moon - Mercury + Lagna"
    sah["Bandhu Sahama"] = make_result("Bandhu Sahama", mode, normalize_longitude(raw))

    # ------------------ Mrityu ------------------
    raw = cusp(chart, 8) - p["Moon"] + p["Saturn"]
    sah["Mrityu Sahama"] = make_result("Mrityu Sahama", "Cusp8 - Moon + Saturn", normalize_longitude(raw))

    # ------------------ Foreign ------------------
    lord9 = lord_of_house(chart, 9)
    raw = cusp(chart, 9) - p[lord9] + L
    sah["Foreign Sahama"] = make_result("Foreign Sahama", f"Cusp9 - {lord9} + Lagna", normalize_longitude(raw))

    # ------------------ Wealth ------------------
    lord2 = lord_of_house(chart, 2)
    raw = cusp(chart, 2) - p[lord2] + L
    sah["Wealth Sahama"] = make_result("Wealth Sahama", f"Cusp2 - {lord2} + Lagna", normalize_longitude(raw))

    # ------------------ Vivaha ------------------
    raw = L + p["Venus"] - p["Saturn"]
    sah["Vivaha Sahama"] = make_result("Vivaha Sahama", "Venus - Saturn + Lagna", normalize_longitude(raw))

    # ------------------ Karya Siddhi ------------------
    # Depositor → lord of sign occupied by Sun or Moon
    if day:
        sign_sun = chart.planets["Sun"].sign
        depositor = SIGN_LORD[sign_sun]
        raw = p["Saturn"] - p["Sun"] + p[depositor]
        mode = f"DAY: Saturn - Sun + Depositor({depositor})"
    else:
        sign_moon = chart.planets["Moon"].sign
        depositor = SIGN_LORD[sign_moon]
        raw = p["Saturn"] - p["Moon"] + p[depositor]
        mode = f"NIGHT: Saturn - Moon + Depositor({depositor})"
    sah["Karya Siddhi Sahama"] = make_result("Karya Siddhi Sahama", mode, normalize_longitude(raw))

    # ------------------ Prasav ------------------
    if day:
        raw = L + p["Jupiter"] - p["Mercury"]
        mode = "DAY: Jupiter - Mercury + Lagna"
    else:
        raw = L + p["Mercury"] - p["Jupiter"]
        mode = "NIGHT: Mercury - Jupiter + Lagna"
    sah["Prasav Sahama"] = make_result("Prasav Sahama", mode, normalize_longitude(raw))

    # ------------------ Vyapara ------------------
    raw = L + p["Mars"] - p["Mercury"]
    sah["Vyapara Sahama"] = make_result("Vyapara Sahama", "Mars - Mercury + Lagna", normalize_longitude(raw))

    # ------------------ Shatru ------------------
    if day:
        raw = L + p["Mars"] - p["Saturn"]
        mode = "DAY: Mars - Saturn + Lagna"
    else:
        raw = L + p["Saturn"] - p["Mars"]
        mode = "NIGHT: Saturn - Mars + Lagna"
    sah["Shatru Sahama"] = make_result("Shatru Sahama", mode, normalize_longitude(raw))

    return sah
