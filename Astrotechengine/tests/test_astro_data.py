# test_astro_data.py
"""
Test script for validating D1/D9 planetary data fetch from swiss_engine.py
"""
from app.core.swiss_engine import get_planetary_positions
import datetime

if __name__ == "__main__":
    # Example: Mumbai, 25 Feb 2026, 9:15 AM IST
    dt = datetime.datetime(2026, 2, 25, 9, 15)
    positions = get_planetary_positions(dt)
    for planet, data in positions.items():
        print(f"{planet.title()}:")
        print(f"  D1: Rashi {data['D1']['rashi']}, Degree in Rashi {data['D1']['degree_in_rashi']:.2f}, Retrograde {data['D1']['retrograde']}")
        print(f"    Nakshatra: {data['D1']['nakshatra']}")
        if planet in ("sun", "moon"):
            print(f"    Tithi: {data['D1']['tithi']}")
        print(f"  D9: Navansh Rashi {data['D9']['navansh_rashi']}")
        print()