"""
Prediction ENGINE – Builds context used by prediction_rules.py
Safe – no KeyErrors, all flags initialized, auto-flag detection enabled.
"""

from core.yogas import evaluate_yogs
from core.sahama_analysis import classify_saham_strength
from core.rule_utils import build_combust_flags, build_malefic_flags, has_aspect
from core.prediction_rules import evaluate_rules


def build_context(chart, bala_table, varshesh, muntha_house, munthesh, birth_chart=None):
    ctx = {}

    # ---------------- BASIC ENTITIES ----------------
    ctx["chart"] = chart
    ctx["bala"] = bala_table
    ctx["varshesh"] = varshesh
    ctx["munthesh"] = munthesh
    ctx["muntha_house"] = muntha_house

    # Lagnesh (lord of 1st house in VF)
    ctx["lagnesh"] = chart.house_lord[1]

    # House of each planet (in Varsh chart)
    house_of = {p.name: ((p.sign - chart.lagna_sign) % 12) + 1
                for p in chart.planets.values()}
    ctx["house_of"] = house_of

    # House lords (using Varsh lagna)
    lord_of_house = {}
    for h in range(1, 13):
        sign = ((chart.lagna_sign + h - 2) % 12) + 1
        lord_of_house[h] = chart.sign_lords[sign]
    ctx["lord_of_house"] = lord_of_house

    # Strength from Panch-Vargiya Bala
    strength = {}
    for planet, data in bala_table.items():
        vb = data["VB"]
        if vb >= 12:
            strength[planet] = "strong"
        elif vb >= 6:
            strength[planet] = "medium"
        else:
            strength[planet] = "weak"
    ctx["strength"] = strength

    # Combust / Malefic flags
    ctx["combust"] = build_combust_flags(chart)
    ctx["is_malefic"] = build_malefic_flags(chart)

    # ---------------- YOGAS + ASPECTS ----------------
    yogas = evaluate_yogs(chart)
    ctx["yogas"] = yogas
    ctx["itthasala_list"] = [y for y in yogas if "Itthasala" in y]
    ctx["ishraf_list"]    = [y for y in yogas if "Ishraf" in y]

    from core.aspects import analyze_chart_aspects
    active_aspects, _ = analyze_chart_aspects(chart)
    ctx["has_aspect"] = lambda p1, p2: has_aspect(active_aspects, p1, p2)

    # ---------------- BIRTH CHART ----------------
    ctx["birth_chart_available"] = birth_chart is not None
    if birth_chart:
        birth_house_of = {
            p.name: ((p.sign - birth_chart.lagna_sign) % 12) + 1
            for p in birth_chart.planets.values()
        }
        ctx["birth_house_of"] = birth_house_of
        ctx["birth_lagna_sign"] = birth_chart.lagna_sign

    # ---------------- SAHAM ANALYSIS ----------------
    from core.sahama import compute_all_sahamas
    sahamas = compute_all_sahamas(chart)
    ctx["saham_analysis"] = classify_saham_strength(
        chart,
        bala_table,
        sahamas,
        varshesh=varshesh,
        itthasala_yogs=ctx["itthasala_list"]
    )

    # =====================================================
    #  PRE-INITIALISE *ALL* FLAGS USED IN prediction_rules
    # =====================================================
    BOOL_FLAGS = [
        # Health / basic
        "connection_mars_ketu_lagnesh",
        "connection_shani_ketu_lagnesh_munthesh",
        "connection_lagnesh_munthesh_rog_saham",
        "moon_in_lagna",
        "aspect_saturn_on_lagnesh",
        "malefic_cluster_6",
        "malefic_cluster_9",

        # Money / finance
        "transit_saturn_on_2nd",
        "connection_jupiter_2nd_birth",
        "birth_mercury_6th",
        "connection_venus_mercury",
        "malefic_connection_jupiter",

        # Career / profession / legal
        "exchange_10th_8th",
        "court_case_active",
        "malefics_in_7th",
        "malefic_connection_7th",
        "connection_lagnesh_10th_lord_itthasala",
        "ishraf_lagna_10",
        "ishraf_lagna_7",

        # Marriage
        "connection_mars_venus_for_marriage",
        "birth_6th_lord_in_6th_vf",
        "benefic_aspect_on_6th",

        # Children
        "malefics_in_5th",
        "lord5_combust_or_weak",
        "itthasala_lagna_5",
        "connection_lagnesh_5th_karak",

        # Marriage / 7th bhava
        "itthasala_lagna_7",

        # Property
        "connection_lagnesh_4th_itthasala",

        # Loss / 12th
        "connection_lagnesh_12th_itthasala",

        # Spiritual
        "jupiter_in_12th_with_good_strength",

        # Travel
        "moon_travel_combination",
    ]
    for flag in BOOL_FLAGS:
        ctx[flag] = False

    # dict-type flag for "malefics_in_house"
    ctx["malefics_in_house"] = {h: False for h in range(1, 13)}

    # =====================================================
    #        AUTO FLAG DETECTION (no KeyErrors)
    # =====================================================
    from core.auto_flags import detect_flags
    auto = detect_flags(ctx)
    for k, v in auto.items():
        ctx[k] = v

    return ctx


def run_prediction(chart, bala_table, varshesh, muntha_house, munthesh, birth_chart=None):
    ctx = build_context(chart, bala_table, varshesh, muntha_house, munthesh, birth_chart)
    results = evaluate_rules(ctx)
    return results, ctx
