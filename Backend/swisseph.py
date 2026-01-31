"""
Mock swisseph module for testing when the real pyswisseph/swisseph cannot be installed.
Provides basic planetary positions for demo/testing purposes only.
"""

import math
from datetime import datetime

# Constants
SUN = 0
MOON = 1
MERCURY = 2
VENUS = 3
MARS = 4
JUPITER = 5
SATURN = 6
URANUS = 7
NEPTUNE = 8
PLUTO = 9
TRUE_NODE = 11  # Rahu (North Node)
MEAN_NODE = 10  # Mean Node
RAHU = 11
KETU = 12  

ECL_NUT = -1

FLG_SWIEPH = 0
FLG_TRUEPOS = 256

def julday(year, month, day, hour=0.0):
    """Convert calendar date to Julian Day."""
    if month <= 2:
        year -= 1
        month += 12
    A = int(year / 100)
    B = 2 - A + int(A / 4)
    JD = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + hour/24.0 + B - 1524.5
    return JD

def calc_ut(jd, planet, flags=0):
    """
    Mock planetary position calculator.
    Returns simplified positions based on mean motions.
    Format: ([lon, lat, dist, lon_speed, lat_speed, dist_speed], retcode)
    """
    # Base epoch: J2000.0 (Jan 1, 2000 12:00 TT)
    J2000 = 2451545.0
    days = jd - J2000
    
    # Mean daily motions (degrees per day, approximate)
    motions = {
        SUN: 0.9856,
        MOON: 13.176,
        MERCURY: 1.38,
        VENUS: 1.20,
        MARS: 0.524,
        JUPITER: 0.0831,
        SATURN: 0.0335,
        RAHU: -0.053,  # Mean node moves backwards
    }
    
    # Base positions at J2000 (approximate tropical longitudes)
    base_positions = {
        SUN: 280.46,
        MOON: 218.32,
        MERCURY: 252.25,
        VENUS: 181.98,
        MARS: 355.43,
        JUPITER: 34.35,
        SATURN: 49.94,
        RAHU: 125.04,
    }
    
    if planet == ECL_NUT:
        # Return obliquity of ecliptic
        return ([23.44, 0.0, 0.0, 0.0, 0.0, 0.0], 0)
    
    motion = motions.get(planet, 0.9856)
    base = base_positions.get(planet, 0.0)
    
    # Calculate longitude
    lon = (base + motion * days) % 360
    
    # Retrograde check (simplified - Mercury/Venus when near Sun)
    speed = motion
    
    # Return format: ([lon, lat, dist, lon_speed, lat_speed, dist_speed], retcode)
    return ([lon, 0.0, 1.0, speed, 0.0, 0.0], 0)

def houses(jd, lat, lon, hsys='P'):
    """
    Calculate house cusps (Placidus).
    Returns (cusps, ascmc) where:
    - cusps: tuple of 12 house cusps
    - ascmc: tuple where ascmc[0] is Ascendant, ascmc[1] is MC
    """
    # Simplified calculation
    # Calculate Local Sidereal Time
    T = (jd - 2451545.0) / 36525.0
    GMST = 280.46061837 + 360.98564736629 * (jd - 2451545.0) + T**2 * (0.000387933 - T / 38710000)
    GMST = GMST % 360
    
    # Local Sidereal Time
    LST = (GMST + lon) % 360
    
    # Obliquity
    eps = 23.4393 - 0.0130 * T
    
    # Ascendant calculation (simplified)
    sin_lst = math.sin(math.radians(LST))
    cos_lst = math.cos(math.radians(LST))
    tan_lat = math.tan(math.radians(lat))
    cos_eps = math.cos(math.radians(eps))
    sin_eps = math.sin(math.radians(eps))
    
    y = -cos_lst
    x = sin_eps * tan_lat + cos_eps * sin_lst
    
    asc = math.degrees(math.atan2(y, x)) % 360
    
    # MC = LST (simplified)
    mc = LST
    
    # Generate house cusps (equal house for simplicity)
    cusps = tuple((asc + i * 30) % 360 for i in range(12))
    
    ascmc = (asc, mc, 0, 0, 0, 0, 0, 0)
    
    return cusps, ascmc

def get_ayanamsa_ut(jd, ayanamsa_type=1):
    """Get Lahiri ayanamsa."""
    T = (jd - 2415020.0) / 36525.0
    return (22.460148 + 1.396042 * T + 3.08e-4 * T * T) % 360

# Additional constants that may be needed
SIDM_LAHIRI = 1
