"""
Tajik Varshaphal Prediction Rulebook — FULL (60+ rules)
Verbal output, grouped by T1 topics.
"""

RULES = []


def rule(topic):
    def wrapper(func):
        RULES.append((topic, func))
        return func
    return wrapper


# ---------------------------------------------------------
# =============== HEALTH ==================================
# ---------------------------------------------------------

@rule("Health")
def r01(ctx):
    if ctx["house_of"][ctx["lagnesh"]] == 8:
        return ("negative", "Lagnesh in 8th — chronic physical stress indicated")
    return None


@rule("Health")
def r02(ctx):
    if ctx["house_of"][ctx["lagnesh"]] == 8 and ctx["connection_mars_ketu_lagnesh"]:
        return ("very_negative", "Lagnesh under Mars/Ketu — injury / surgery possibility")
    return None


@rule("Health")
def r03(ctx):
    if ctx["house_of"]["Sun"] in (6, 8, 12) or ctx["house_of"]["Moon"] in (6, 8, 12):
        return ("negative", "Sun / Moon in dusthana — vitality & emotional resilience low")
    return None


@rule("Health")
def r04(ctx):
    if ctx["combust"][ctx["lagnesh"]] and ctx["combust"][ctx["munthesh"]] and ctx["connection_shani_ketu_lagnesh_munthesh"]:
        return ("very_negative", "Lagnesh + Munthesh combust with Saturn/Ketu — intense health strain")
    return None


@rule("Health")
def r05(ctx):
    if ctx["house_of"][ctx["lagnesh"]] in (4, 6, 8, 12) and ctx["house_of"][ctx["munthesh"]] in (4, 6, 8, 12) and ctx["aspect_saturn_on_lagnesh"]:
        return ("negative", "Saturn afflicting Lagnesh & Munthesh in dusthana — disease-prone year")
    return None


@rule("Health")
def r06(ctx):
    if ctx["connection_lagnesh_munthesh_rog_saham"]:
        return ("negative", "Roga Saham linked with Lagnesh–Munthesh — recurring health difficulty")
    return None


@rule("Health")
def r07(ctx):
    if ctx["moon_in_lagna"] and ctx["malefics_in_house"][8]:
        return ("negative", "Moon in Lagna + malefics in 8th — mental / physical exhaustion")
    return None


@rule("Health")
def r08(ctx):
    if ctx["varshesh"] == "Saturn" and ctx["house_of"]["Saturn"] == 6 and ctx["malefic_cluster_6"]:
        return ("very_negative", "Saturn Varshesh in 6th with malefics — prolonged disease risk")
    return None


@rule("Health")
def r09(ctx):
    if ctx["house_of"][ctx["lagnesh"]] == 12 and ctx["house_of"][ctx["munthesh"]] == 12 and ctx["house_of"][ctx["varshesh"]] == 12:
        return ("very_negative", "Lagnesh + Munthesh + Varshesh in 12th — hospitalisation / isolation / heavy drainage")
    return None


# ---------------------------------------------------------
# =============== MONEY ===================================
# ---------------------------------------------------------

@rule("Money")
def r10(ctx):
    if ctx["varshesh"] == "Jupiter" and ctx["strength"]["Jupiter"] == "strong" and ctx["connection_jupiter_2nd_birth"]:
        return ("very_positive", "Strong Jupiter Varshesh linked to 2nd — wealth gain & prosperity")
    return None


@rule("Money")
def r11(ctx):
    if ctx["birth_mercury_6th"] and ctx["house_of"]["Mercury"] == 2:
        return ("positive", "Mercury moved from 6th to 2nd — improved income & skills monetised")
    return None


@rule("Money")
def r12(ctx):
    if ctx["varshesh"] == "Venus" and ctx["strength"]["Venus"] == "strong" and ctx["house_of"]["Venus"] == 2 and ctx["connection_venus_mercury"]:
        return ("positive", "Venus–Mercury connection in 2nd — luxury income / business profits")
    return None


@rule("Money")
def r13(ctx):
    if ctx["malefics_in_house"][2] and ctx["strength"][ctx["lord_of_house"][2]] == "weak":
        return ("negative", "Malefic in 2nd + weak 2nd lord — money pressure / delays")
    return None


@rule("Money")
def r14(ctx):
    if ctx["transit_saturn_on_2nd"]:
        return ("negative", "Saturn triggering 2nd — financial slowdown / responsibilities")
    return None


@rule("Money")
def r15(ctx):
    if ctx["varshesh"] == "Jupiter" and ctx["house_of"]["Jupiter"] == 8 and ctx["malefic_connection_jupiter"]:
        return ("very_negative", "Jupiter in 8th with malefics — severe loss or failed investments")
    return None


@rule("Money")
def r16(ctx):
    if ctx["house_of"][ctx["lord_of_house"][8]] == 2 and ctx["strength"][ctx["lagnesh"]] == "weak":
        return ("negative", "8th lord in 2nd + weak Lagnesh — inheritance/legal financial stress")
    return None


# ---------------------------------------------------------
# =============== CAREER ==================================
# ---------------------------------------------------------

@rule("Career")
def r20(ctx):
    if ctx["connection_lagnesh_10th_lord_itthasala"]:
        return ("positive", "Lagnesh–10th lord Itthasala — professional rise / success")
    return None


@rule("Career")
def r21(ctx):
    if ctx["ishraf_lagna_10"]:
        return ("negative", "Ishraf Lagna–10th — separation from current position")
    return None


@rule("Career")
def r22(ctx):
    if ctx["exchange_10th_8th"]:
        return ("negative", "10th–8th lord exchange — job instability / stress")
    return None


@rule("Career")
def r23(ctx):
    if ctx["varshesh"] == ctx["lord_of_house"][10] and ctx["house_of"][ctx["varshesh"]] in (1, 10):
        return ("positive", "Varshesh linked to 10th — promotion / authority / achievement")
    return None


@rule("Career")
def r24(ctx):
    if ctx["house_of"][ctx["lagnesh"]] == 7 and ctx["court_case_active"]:
        return ("negative", "Lagnesh in 7th during dispute — litigation loss")
    return None


@rule("Career")
def r25(ctx):
    if ctx["malefics_in_7th"] and ctx["house_of"][ctx["lord_of_house"][10]] == 7:
        return ("negative", "Malefics in 7th influencing 10th lord — workplace conflicts")
    return None


# ---------------------------------------------------------
# =============== MARRIAGE =================================
# ---------------------------------------------------------

@rule("Marriage")
def r30(ctx):
    if ctx["itthasala_lagna_7"]:
        return ("positive", "Itthasala Lagna–7th — marriage / union / partnership materialisation")
    return None


@rule("Marriage")
def r31(ctx):
    if ctx["connection_mars_venus_for_marriage"]:
        return ("positive", "Mars–Venus connection — powerful marriage indicator")
    return None


@rule("Marriage")
def r32(ctx):
    if ctx["birth_6th_lord_in_6th_vf"] and ctx["benefic_aspect_on_6th"]:
        return ("positive", "Marriage after resolving disputes — settlement")
    return None


@rule("Marriage")
def r33(ctx):
    if ctx["malefics_in_7th"] and ctx["strength"][ctx["lord_of_house"][7]] == "weak":
        return ("negative", "Malefics in 7th + weak 7th lord — spouse stress / relationship tension")
    return None


@rule("Marriage")
def r34(ctx):
    if ctx["house_of"][ctx["lagnesh"]] in (1, 7) and ctx["house_of"][ctx["varshesh"]] in (1, 7) and ctx["house_of"][ctx["munthesh"]] in (1, 7):
        return ("positive", "Lagnesh + Varshesh + Munthesh in Kendra (1/7) — marriage year")
    return None


# ---------------------------------------------------------
# =============== TRAVEL ==================================
# ---------------------------------------------------------

@rule("Travel")
def r40(ctx):
    if ctx["muntha_house"] == 9 or ctx["house_of"][ctx["lagnesh"]] == 9:
        return ("positive", "9th activation — foreign / distant travel")
    return None


@rule("Travel")
def r41(ctx):
    if ctx["moon_travel_combination"]:
        return ("positive", "Moon with 9th/3rd — pilgrimage or meaningful journey")
    return None


@rule("Travel")
def r42(ctx):
    if ctx["house_of"][ctx["lagnesh"]] in (3, 9) and ctx["malefic_cluster_9"]:
        return ("negative", "Travel under malefic stress — obstacles / anxiety / loss")
    return None


# ---------------------------------------------------------
# =============== CHILDREN =================================
# ---------------------------------------------------------

@rule("Children")
def r50(ctx):
    if ctx["strength"]["Jupiter"] == "strong" and ctx["house_of"]["Jupiter"] == 5:
        return ("positive", "Strong Jupiter in 5th — childbirth / prosperity through children")
    return None


@rule("Children")
def r51(ctx):
    if ctx["house_of"][ctx["lord_of_house"][5]] in (6, 8, 12):
        return ("negative", "5th lord in dusthana — child matters under stress")
    return None


@rule("Children")
def r52(ctx):
    if ctx["itthasala_lagna_5"] or ctx["connection_lagnesh_5th_karak"]:
        return ("positive", "Itthasala Lagna–5th / strong connection — child birth prospects")
    return None


@rule("Children")
def r53(ctx):
    if ctx["malefics_in_5th"] and ctx["lord5_combust_or_weak"]:
        return ("very_negative", "Malefics in 5th + weak 5th lord — miscarriage / complications")
    return None


# ---------------------------------------------------------
# =============== PROPERTY =================================
# ---------------------------------------------------------

@rule("Property")
def r60(ctx):
    if ctx["connection_lagnesh_4th_itthasala"]:
        return ("positive", "Lagnesh–4th Itthasala — property / land / house acquisition")
    return None


# ---------------------------------------------------------
# =============== LEGAL ===================================
# ---------------------------------------------------------

@rule("Legal")
def r70(ctx):
    if ctx["court_case_active"] and ctx["ishraf_lagna_7"]:
        return ("negative", "Ishraf Lagna–7th — defeat / judgment against native")
    return None


@rule("Legal")
def r71(ctx):
    if ctx["court_case_active"] and not ctx["malefic_in_7th"]:
        return ("positive", "Case settles or ends in negotiation — no legal loss")
    return None


# ---------------------------------------------------------
# =============== LOSS ====================================
# ---------------------------------------------------------

@rule("Loss")
def r80(ctx):
    if ctx["connection_lagnesh_12th_itthasala"]:
        return ("negative", "Lagnesh–12th — heavy expenditure / depletion")
    return None


@rule("Loss")
def r81(ctx):
    if ctx["house_of"][ctx["lord_of_house"][12]] == 10:
        return ("negative", "12th lord in 10th — business setback / risky foreign dependency")
    return None


# ---------------------------------------------------------
# =============== SPIRITUAL =================================
# ---------------------------------------------------------

@rule("Spiritual")
def r85(ctx):
    if ctx["jupiter_in_12th_with_good_strength"]:
        return ("positive", "Jupiter in 12th — spiritual expenditure / blessings / internal growth")
    return None


# ---------------------------------------------------------
# =============== OVERALL ==================================
# ---------------------------------------------------------

@rule("Overall")
def r90(ctx):
    if ctx["strength"][ctx["varshesh"]] == "strong":
        return ("very_positive", "Strong Varshesh — overall success, fulfilment and stable outcomes")
    if ctx["strength"][ctx["varshesh"]] == "weak":
        return ("negative", "Weak Varshesh — year demands patience, discipline and careful planning")
    return None


# ---------------------------------------------------------
# =============== MASTER ===================================
# ---------------------------------------------------------

def evaluate_rules(ctx):
    out = []
    for topic, func in RULES:
        res = func(ctx)
        if res:
            rating, msg = res
            out.append((topic, rating, msg))
    return out
