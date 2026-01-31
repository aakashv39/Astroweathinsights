"""
Auto-detection engine for Tajik prediction flags.

It reads from `ctx` prepared by prediction_engine.build_context
and returns a dict of flags to merge into ctx.

Design goals:
  • Never raises KeyError
  • Only uses keys guaranteed by prediction_engine
  • Automatically fills most flags used by prediction_rules
"""

def detect_flags(ctx):
    chart      = ctx["chart"]
    house      = ctx["house_of"]
    lord       = ctx["lord_of_house"]
    combust    = ctx["combust"]
    malefic    = ctx["is_malefic"]
    yogas      = ctx["yogas"]
    has_aspect = ctx["has_aspect"]
    varshesh   = ctx["varshesh"]
    lagnesh    = ctx["lagnesh"]
    munthesh   = ctx["munthesh"]
    strength   = ctx["strength"]

    flags = {}

    # ---------------- HEALTH ----------------
    flags["connection_mars_ketu_lagnesh"] = (
        has_aspect("Mars", lagnesh) or has_aspect("Ketu", lagnesh)
    )

    flags["connection_shani_ketu_lagnesh_munthesh"] = (
        (has_aspect("Saturn", lagnesh) or has_aspect("Ketu", lagnesh)) and
        (has_aspect("Saturn", munthesh) or has_aspect("Ketu", munthesh))
    )

    flags["moon_in_lagna"] = (house.get("Moon") == 1)
    flags["aspect_saturn_on_lagnesh"] = has_aspect("Saturn", lagnesh)

    # Malefic clusters in 6 / 9
    flags["malefic_cluster_6"] = sum(
        1 for p in chart.planets if malefic[p] and house[p] == 6
    ) >= 2

    flags["malefic_cluster_9"] = sum(
        1 for p in chart.planets if malefic[p] and house[p] == 9
    ) >= 2

    # Malefics per house (for malefics_in_house[2], [8], etc.)
    mal_house = {h: False for h in range(1, 13)}
    for p in chart.planets:
        if malefic[p]:
            h = house[p]
            mal_house[h] = True
    flags["malefics_in_house"] = mal_house

    # ---------------- CHILDREN ----------------
    lord5 = lord[5]
    flags["malefics_in_5th"] = any(malefic[p] and house[p] == 5 for p in chart.planets)
    flags["lord5_combust_or_weak"] = combust.get(lord5, False) or strength.get(lord5, "weak") == "weak"
    flags["connection_lagnesh_5th_karak"] = (
        has_aspect(lagnesh, "Jupiter") or has_aspect(lagnesh, lord5)
    )

    # ---------------- MARRIAGE ----------------
    flags["connection_mars_venus_for_marriage"] = has_aspect("Mars", "Venus")
    flags["malefics_in_7th"] = any(malefic[p] and house[p] == 7 for p in chart.planets)

    # Birth-related marriage flag:
    # Birth 6th lord in VF 6th – approximate if birth_chart_available
    flags["birth_6th_lord_in_6th_vf"] = False
    if ctx.get("birth_chart_available") and ctx.get("birth_house_of"):
        birth_house = ctx["birth_house_of"]
        # easiest approximation: if same planet rules 6th in birth and sits in 6th in VF
        # (exact birth sign lord mapping not stored; this is deliberate approx)
        # we just check if any planet that was in 6th in birth is now in 6th again
        for pname, h_b in birth_house.items():
            if h_b == 6 and house.get(pname) == 6:
                flags["birth_6th_lord_in_6th_vf"] = True
                break

    # Benefic aspect on 6th
    benefics = ["Jupiter", "Venus", "Moon", "Mercury"]
    sixth_lord = lord[6]
    flags["benefic_aspect_on_6th"] = any(
        has_aspect(b, sixth_lord) for b in benefics if b in chart.planets
    )

    # ---------------- CAREER ----------------
    lord10 = lord[10]
    flags["connection_lagnesh_10th_lord_itthasala"] = any(
        (lagnesh in y and lord10 in y and "Itthasala" in y)
        for y in yogas
    )

    # 10th–8th exchange (simplified: mutual lord)
    flags["exchange_10th_8th"] = (lord10 == lord[8])

    # Malefic connection to 7th (court cases etc.)
    flags["malefic_connection_7th"] = False
    seventh_lord = lord[7]
    # Check if any malefic aspects 7th house lord
    for p in chart.planets:
        if malefic[p] and has_aspect(p, seventh_lord):
            flags["malefic_connection_7th"] = True
            break

    # Court case flag cannot be derived from chart — keep default False
    # but we leave it so user can manually set in future from UI/logical layer

    # ---------------- FINANCE ----------------
    # Saturn on 2nd house (simplified "transit on 2nd")
    flags["transit_saturn_on_2nd"] = (house.get("Saturn") == 2)

    # Jupiter link to 2nd house in birth
    flags["connection_jupiter_2nd_birth"] = False
    if ctx.get("birth_chart_available") and ctx.get("birth_house_of"):
        birth_house = ctx["birth_house_of"]
        if birth_house.get("Jupiter") == 2:
            flags["connection_jupiter_2nd_birth"] = True

    # Birth Mercury in 6th
    flags["birth_mercury_6th"] = False
    if ctx.get("birth_chart_available") and ctx.get("birth_house_of"):
        birth_house = ctx["birth_house_of"]
        flags["birth_mercury_6th"] = (birth_house.get("Mercury") == 6)

    # Venus–Mercury connection
    flags["connection_venus_mercury"] = has_aspect("Venus", "Mercury")

    # Jupiter hit by malefics
    flags["malefic_connection_jupiter"] = any(
        has_aspect("Jupiter", p) for p in chart.planets if malefic[p]
    )

    # ---------------- PROPERTY ----------------
    flags["connection_lagnesh_4th_itthasala"] = any(
        (lagnesh in y and lord[4] in y and "Itthasala" in y)
        for y in yogas
    )

    # ---------------- TRAVEL ----------------
    flags["moon_travel_combination"] = (
        house.get("Moon") in (3, 9) or has_aspect("Moon", lord[9])
    )

    # ---------------- LOSS / 12TH ----------------
    flags["connection_lagnesh_12th_itthasala"] = any(
        (lagnesh in y and lord[12] in y and "Itthasala" in y)
        for y in yogas
    )

    # ---------------- SPIRITUAL ----------------
    flags["jupiter_in_12th_with_good_strength"] = (
        house.get("Jupiter") == 12 and strength.get("Jupiter") in ("medium", "strong")
    )

    # ---------------- SAHAM HEALTH LINK ----------------
    flags["connection_lagnesh_munthesh_rog_saham"] = False
    saham_info = ctx.get("saham_analysis", {})
    if "Roga Sahama" in saham_info:
        rog_lord = saham_info["Roga Sahama"]["lord"]
        if has_aspect(lagnesh, rog_lord) or has_aspect(munthesh, rog_lord):
            flags["connection_lagnesh_munthesh_rog_saham"] = True

    return flags
