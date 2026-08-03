# ============================================================
# Astro Quant Engine — Master Configuration
# ============================================================

# --- Location ---
MUMBAI_LAT = 19.0760
MUMBAI_LON = 72.8777
TIMEZONE = "Asia/Kolkata"

# --- Nakshatra ---
NAKSHATRA_SPAN = 13 + 20 / 60  # 13°20' = 13.3333...
TOTAL_NAKSHATRAS = 27

# --- Tithi ---
TITHI_SPAN = 12  # 12° per tithi
TOTAL_TITHIS = 30

# --- Rashi Classification ---
TEJI_RASHI = [3, 4, 6, 8, 9, 12]
MANDI_RASHI = [1, 2, 5, 7, 10, 11]
STRONG_TEJI_RASHI = [12, 4, 8]
STRONG_MANDI_RASHI = [2, 5, 10]
JALTARVA_RASHI = [4, 8, 12]
AGNI_RASHI = [1, 5, 9]

# --- Combust Degrees (max distance from Sun) ---
COMBUST_DEGREES = {
    "moon": 12,
    "mars": 17,
    "mercury": 13,
    "jupiter": 11,
    "venus": 9,
    "saturn": 15,
}

# --- Exaltation Rashi ---
EXALTATION = {
    "sun": 1,
    "moon": 2,
    "mars": 10,
    "mercury": 6,
    "venus": 12,
    "jupiter": 4,
    "saturn": 7,
}

# --- Debilitation Rashi ---
DEBILITATION = {
    "sun": 7,
    "moon": 8,
    "mars": 4,
    "mercury": 12,
    "venus": 6,
    "jupiter": 10,
    "saturn": 1,
}

# --- Aspect Angles and Scores ---
ASPECT_SCORES = {
    0: 4,      # Yukti
    180: 3,    # Prati Yukti
    150: 2,    # Sarasthak
    90: -3,    # Strong Mandi
    135: -2,
    45: -1,
    22.5: -1,
    120: 2,
    60: 1,
    30: 1,
    26: 1,
    72: 1,
}
ASPECT_ORB = 2  # degree tolerance for aspect matching

# --- Planet Classification ---
BENEFIC_PLANETS = ["venus", "jupiter", "neptune"]
MALEFIC_PLANETS = ["saturn", "mars", "rahu", "ketu", "pluto", "uranus"]

# --- Scoring Weights (13 rules, all configurable) ---
WEIGHT_SBC_VEDH       = 1.0   # Rule 1: SBC Vedh
WEIGHT_DRISHTI        = 1.0   # Rule 2: Benefic/Malefic drishti on Sun/Moon
WEIGHT_TARVA_RASHI    = 1.0   # Rule 3: Agni (1,5,9) / Jal (4,8,12) Tarva Rashi
WEIGHT_NAKSHATRA_TEND = 1.0   # Rule 4: Sun & Moon nakshatra teji tendency
WEIGHT_PLANET_POWER   = 1.0   # Rule 5: Own sign / friend sign / exalted = powerful
WEIGHT_SUN_MOON_ZERO  = 1.0   # Rule 6: Moon & Sun at 0° = strong Mandi
WEIGHT_PAP_KHATRI     = 1.0   # Rule 7: Paap Khatri Yog (Moon & Budh)
WEIGHT_BUDH           = 1.0   # Rule 8: Budh ka Yog
WEIGHT_SURYA_NAK      = 1.0   # Rule 9: Surya nakshatra sheet
WEIGHT_DAY_NAK        = 1.0   # Rule 10: Day-of-week nakshatra match (80%)
WEIGHT_PLANET_INFO    = 1.0   # Rule 11: Planet info from notes
WEIGHT_VIPRIT_RAJ     = 1.0   # Rule 12: Combust+Debilitated=Viprit Raj Yog=Teji; retro/combust/debil reverses
WEIGHT_TITHI          = 1.0   # Rule 13: Purnima/Amavasya one-sided; Moon combust big move
WEIGHT_RASHI          = 1.0   # Legacy: Moon rashi type
WEIGHT_NAVANSH        = 1.0   # Legacy: Barguttam D1==D9

# --- Trend Thresholds ---
TREND_VERY_STRONG_TEJI = 12
TREND_TEJI = 4
TREND_VERY_STRONG_MANDI = -12
TREND_MANDI = -4

# --- Planet Friendship Table (for Rule 5) ---
# Each planet: list of rashis where it is "in own sign" or "friend sign" (strong)
PLANET_OWN_SIGN = {
    "sun":     [5],           # Leo
    "moon":    [4],           # Cancer
    "mars":    [1, 8],        # Aries, Scorpio
    "mercury": [3, 6],        # Gemini, Virgo
    "venus":   [2, 7],        # Taurus, Libra
    "jupiter": [9, 12],       # Sagittarius, Pisces
    "saturn":  [10, 11],      # Capricorn, Aquarius
    "rahu":    [11],          # Aquarius (co-ruler)
    "ketu":    [8],           # Scorpio (co-ruler)
}
PLANET_FRIEND_SIGN = {
    "sun":     [1, 4, 9, 12],      # Mars/Moon/Jupiter houses
    "moon":    [2, 3, 5, 6],       # Sun/Mercury houses
    "mars":    [4, 5, 9, 12],      # Sun/Moon/Jupiter houses
    "mercury": [2, 5, 7],          # Venus/Sun houses
    "venus":   [3, 6, 10, 11],     # Mercury/Saturn houses
    "jupiter": [1, 4, 5, 8],       # Sun/Moon/Mars houses
    "saturn":  [2, 3, 6, 7, 12],   # Mercury/Venus houses
    "rahu":    [2, 3, 6, 7],       # Mercury/Venus houses
    "ketu":    [5, 9, 12],         # Sun/Jupiter houses
}

# --- Surya Nakshatra Sheet (Rule 9) ---
# Sun in these nakshatras → Teji tendency (+1), others → Mandi (-1)
SURYA_TEJI_NAKSHATRAS = [1, 3, 7, 10, 12, 16, 19, 21, 25]
# Ashwini, Krittika, Punarvasu, Magha, U.Phalguni, Vishakha, Moola, U.Ashadha, P.Bhadrapada

# --- Day-of-Week Nakshatra Match (Rule 10, 80% probability) ---
# weekday (0=Mon..6=Sun) → ruling planet whose nakshatra match = Teji
DAY_PLANET_MAP = {
    0: "moon",      # Monday → Moon
    1: "mars",      # Tuesday → Mars
    2: "mercury",   # Wednesday → Mercury
    3: "jupiter",   # Thursday → Jupiter
    4: "venus",     # Friday → Venus
    5: "saturn",    # Saturday → Saturn
    6: "sun",       # Sunday → Sun
}

# --- Nakshatra Teji Tendency (Rule 4) ---
# Moon nakshatras with inherent teji tendency
MOON_TEJI_NAKSHATRAS  = [1, 4, 7, 8, 10, 13, 16, 19, 22, 25]
MOON_MANDI_NAKSHATRAS = [2, 5, 6, 9, 11, 14, 17, 18, 20, 23, 26]

# --- Purnima/Amavasya big move points (Rule 13 configurable) ---
PURNIMA_AMAVASYA_SCORE = 3
MOON_COMBUST_BIG_MOVE_SCORE = 5

# --- SBC Sectors (Nakshatra to direction) ---
SBC_SECTORS = {
    "East": range(1, 8),
    "South": range(8, 15),
    "West": range(15, 22),
    "North": range(22, 28),
}
