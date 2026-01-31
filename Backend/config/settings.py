"""
Global configuration for Tajik Varshaphal engine.
"""

# --------------------
# Zodiac mode
# --------------------
# "sidereal" (recommended for Vedic/Tajik)
# "tropical"
ZODIAC_TYPE = "sidereal"

# --------------------
# Ayanamsa
# --------------------
# Must match Swiss Ephemeris constant name (without SWE.)
# Options:
#   SIDM_LAHIRI
#   SIDM_RAMAN
#   SIDM_FAGAN_BRADLEY
#   SIDM_KRISHNAMURTI
#
AYANAMSA = "SIDM_LAHIRI"

# --------------------
# Rahu calculation
# --------------------
# TRUE = True Node (astronomical)
# MEAN = Mean Node (traditional)
#
RAHU_TYPE = "MEAN"

# --------------------
# Planet speed ranking used for Tajik aspects
# Lower number = faster planet
# --------------------
SPEED_RANK = {
    "Moon": 1,
    "Mercury": 2,
    "Venus": 3,
    "Sun": 4,
    "Mars": 5,
    "Jupiter": 6,
    "Saturn": 7,
    "Rahu": 8,
    "Ketu": 8,
}


MALE_PLANETS = {'Sun', 'Mars', 'Jupiter'}
FEMALE_PLANETS = {'Moon', 'Venus'}

TAJIK_ASPECTS = {
    'open_friend': [5, 9],
    'hidden_friend': [3, 11],
    'open_enemy': [1, 7],
    'hidden_enemy': [4, 10],
    'neutral': [2, 12, 6, 8]
}

DEEPTANSH_TABLE = {
    "Sun": 15,
    "Moon": 12,
    "Mars": 8,
    "Mercury": 7,
    "Jupiter": 9,
    "Venus": 7,
    "Saturn": 9,
    "Rahu": 5,
    "Ketu": 5,
}

PERMANENT_FRIENDSHIP_TABLE = {
    "Sun":     {"friends": [1,5,9], "enemies": [7,11]},
    "Moon":    {"friends": [2,4],   "enemies": [8,12]},
    "Mars":    {"friends": [1,8,9], "enemies": [2,3]},
    "Mercury": {"friends": [3,6],   "enemies": [4,5]},
    "Jupiter": {"friends": [1,5,9], "enemies": [3,7]},
    "Venus":   {"friends": [2,7,12],"enemies": [1,6]},
    "Saturn":  {"friends": [6,7,11],"enemies": [4,5]}
}
