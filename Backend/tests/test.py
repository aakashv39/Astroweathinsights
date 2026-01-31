"""
Simple tests to validate basic flow using sample longitudes.
Run with: python -m pytest tests/test_cases.py
"""
from core.ephemeris import compute_chart
from core.panch_vargiya import panch_vargiya_bala
from core.varshesh import find_varshesh
from core.muntha import calculate_muntha

SAMPLE_POSITIONS = {
    'Sun': 235.50,
    'Moon': 102.25,
    'Mars': 15.0,
    'Mercury': 220.5,
    'Jupiter': 55.2,
    'Venus': 300.0,
    'Saturn': 185.75,
    'Rahu': 320.0,
    'Ketu': 140.0
}

def test_flow():
    natal = compute_chart(date="1986-11-16", time="10:45", lat=32.7266, lon=74.8570, timezone="+05:30", planet_longitudes=SAMPLE_POSITIONS)
    varsh = compute_chart(date="1986-11-16", time="10:45", lat=32.7266, lon=74.8570, timezone="+05:30", planet_longitudes=SAMPLE_POSITIONS)
    bala = panch_vargiya_bala(varsh, varsh_pravesh_daytime=True)
    v = find_varshesh(varsh, bala, vf_lagna=varsh.lagna)
    assert v is not None
