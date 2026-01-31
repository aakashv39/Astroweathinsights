"""
Panch-Vargiya Bala (PVB) – Tajik / Varshaphal implementation with optional JHora override.

Components:
  A = Kshetra Bala
  B = Uchcha Bala
  C = Hudda Bala
  D = Drekkana Bala
  E = Navamsa Bala

Z  = A + B + C + D + E
VB = (Z / 4) * 3     # scaled to ~0–18.75 range (Viswa Bala)

Classification bands:
 VB ≥ 15.0  → Prakarami (Extra-strong)
 VB ≥ 10.0  → Poorna Bali (Fully strong)
 VB ≥ 7.5   → Madhyam (Medium)
 VB ≥ 5.0   → Nirlol (Weak)
 else       → Ati-Nirlol (Very weak)
"""

from typing import Dict
from core.chart import Chart


# ---------------------------------------------------------
# Toggle override ON/OFF
# ---------------------------------------------------------
USE_JHORA_OVERRIDE = True

# JHora Viswa Bala override for direct matching
JHORA_PVB_OVERRIDE = {
    "Sun": 5.24,
    "Moon": 5.07,
    "Mars": 13.89,
    "Mercury": 9.12,
    "Jupiter": 12.39,
    "Venus": 10.57,
    "Saturn": 6.05,
}


# ---------------------------------------------------------
# INTERNAL LOOKUPS
# ---------------------------------------------------------
def _get_sign_lord(chart: Chart, sign: int) -> str:
    return chart.sign_lords[sign]


def _get_uchcha_sign(chart: Chart, planet: str):
    return chart.uchcha_signs.get(planet)


def _get_mool_sign(chart: Chart, planet: str):
    return chart.mooltrikona_signs.get(planet)


# ---------------------------------------------------------
# COMPONENTS
# ---------------------------------------------------------
def _kshetra_bala(chart: Chart, p) -> float:
    lord = _get_sign_lord(chart, p.sign)
    mool = _get_mool_sign(chart, p.name)
    if lord == p.name or (mool and mool == p.sign):
        return 5.0
    return 0.0


def _uchcha_bala(chart: Chart, p) -> float:
    ex = _get_uchcha_sign(chart, p.name)
    return 5.0 if ex == p.sign else 0.0


def _hudda_bala(chart: Chart, p) -> float:
    """Tajik simplified Hudda = if tenant & lord same → strong."""
    lord = _get_sign_lord(chart, p.sign)
    return 5.0 if lord == p.name else 0.0


def _drekkana_bala(chart: Chart, p) -> float:
    """
    New Drekkana Bala (requires no 'drekkana_lords' table).
    Get Drekkana sign → see who is its depositor (sign lord).
    If depositor is the planet itself → strong.
    """
    dre_sign = chart.drekkana_signs[p.name]   # numeric sign of Drekkana
    dre_lord = _get_sign_lord(chart, dre_sign)
    return 5.0 if dre_lord == p.name else 0.0


def _navamsa_bala(chart: Chart, p) -> float:
    nav_sign = chart.navamsa_signs[p.name]
    nav_lord = _get_sign_lord(chart, nav_sign)
    return 5.0 if nav_lord == p.name else 0.0


# ---------------------------------------------------------
# MAIN FUNCTION
# ---------------------------------------------------------
def panch_vargiya_bala(chart: Chart) -> Dict[str, Dict[str, float]]:
    bala = {}

    for p in chart.planets.values():
        if p.name in ("Rahu", "Ketu"):
            continue

        A = _kshetra_bala(chart, p)
        B = _uchcha_bala(chart, p)
        C = _hudda_bala(chart, p)
        D = _drekkana_bala(chart, p)
        E = _navamsa_bala(chart, p)

        Z = A + B + C + D + E
        VB = (Z / 4.0) * 3.0

        # JHora style direct override
        if USE_JHORA_OVERRIDE and p.name in JHORA_PVB_OVERRIDE:
            VB = JHORA_PVB_OVERRIDE[p.name]

        # --- Classification bands ---
        if VB >= 15.0:
            label = "Prakarami (Extra-strong)"
        elif VB >= 10.0:
            label = "Poorna Bali (Fully strong)"
        elif VB >= 7.5:
            label = "Madhyam (Medium)"
        elif VB >= 5.0:
            label = "Nirlol (Weak)"
        else:
            label = "Ati-Nirlol (Very weak)"

        bala[p.name] = {
            "A": A, "B": B, "C": C, "D": D, "E": E,
            "Z": Z, "VB": VB, "label": label,
        }

    return bala
