"""
TAJIK YOGAS ENGINE — Silent by default
--------------------------------------
Implements 8 Tajik Yogas:

 1) Iqbaal Yog
 2) InduVaar Yog
 3) Itthasala Yog
 4) Ishraf Yog
 5) Nakta Yog
 6) Yamaya Yog
 7) Manahoo Yog
 8) Kamboola Yog

Debug logging = OFF by default. Enable via DEBUG_YOGAS = True.
"""

from core.aspects import analyze_chart_aspects
from math import fabs
from core.panch_vargiya import panch_vargiya_bala

# -----------------------------------------------------------
# Toggle Debug Logging
# -----------------------------------------------------------
DEBUG_YOGAS = False
def log(*args):
    if DEBUG_YOGAS:
        print(*args)

# Natural speed order
PLANET_SPEED = ["Moon", "Mercury", "Venus", "Sun", "Mars", "Jupiter", "Saturn"]


def faster(p1, p2):
    return (p1, p2) if PLANET_SPEED.index(p1.name) < PLANET_SPEED.index(p2.name) else (p2, p1)


def relation_allowed_for_itthasala(aspect):
    return aspect["category"] != "neutral"


# -----------------------------------------------------------
# YOG #1 — IQBAAL
# -----------------------------------------------------------
def iqbaal_yog(chart):
    allowed = {1, 2, 4, 5, 7, 10, 11}
    for p in chart.planets.values():
        if p.name in ("Rahu", "Ketu"):
            continue
        house = ((p.sign - chart.lagna_sign) % 12) + 1
        if house not in allowed:
            return False
    return True


# -----------------------------------------------------------
# YOG #2 — INDUVAAR
# -----------------------------------------------------------
def induvaar_yog(chart):
    allowed = {3, 6, 9, 12}
    for p in chart.planets.values():
        if p.name in ("Rahu", "Ketu"):
            continue
        house = ((p.sign - chart.lagna_sign) % 12) + 1
        if house not in allowed:
            return False
    return True


# -----------------------------------------------------------
# YOG #3 — ITTHASALA
# -----------------------------------------------------------
def detect_itthasala(chart):
    active, _ = analyze_chart_aspects(chart)
    result = []

    for asp in active:
        if not relation_allowed_for_itthasala(asp):
            continue

        p1 = chart.planets[asp["p1"]]
        p2 = chart.planets[asp["p2"]]
        fast, slow = faster(p1, p2)
        gap = asp["degree_diff"]

        if fast.retro:
            continue
        if fast.degree >= slow.degree:
            continue

        yog_type = "Poorna Itthasala" if gap < 1 else "Vartaman Itthasala"
        msg = f"{yog_type}: {fast.name} → {slow.name} (gap={gap:.2f})"
        if slow.retro:
            msg += " — Strong (slow retro)"
        result.append((fast.name, slow.name, gap, msg))

    return result


# -----------------------------------------------------------
# YOG #4 — ISHRAF
# -----------------------------------------------------------
def detect_ishraf(chart):
    active, _ = analyze_chart_aspects(chart)
    result = []

    for asp in active:
        if not relation_allowed_for_itthasala(asp):
            continue

        p1 = chart.planets[asp["p1"]]
        p2 = chart.planets[asp["p2"]]
        fast, slow = faster(p1, p2)
        gap = fabs(fast.degree - slow.degree)

        if fast.retro:
            continue
        if fast.degree <= slow.degree + 1:
            continue

        strength = "Weak (slow retro)" if slow.retro else "Normal"
        msg = f"Ishraf Yog: {fast.name} → {slow.name} (gap={gap:.2f}, {strength})"
        result.append(msg)

    return result


# -----------------------------------------------------------
# YOG #5 — NAKTA
# -----------------------------------------------------------
def detect_nakta(chart):
    active, _ = analyze_chart_aspects(chart)
    itth_list = detect_itthasala(chart)
    itth_pairs = {(f, s) for (f, s, _, _) in itth_list} | {(s, f) for (f, s, _, _) in itth_list}

    nakta = []
    planets = [p for p in chart.planets.values() if p.name not in ("Rahu", "Ketu")]

    for A in planets:
        for B in planets:
            if A.name >= B.name:
                continue

            # A & B should NOT aspect
            if any(
                asp["p1"] == A.name and asp["p2"] == B.name or
                asp["p1"] == B.name and asp["p2"] == A.name
                for asp in active
            ):
                continue

            # Moon cannot be A/B
            if A.name == "Moon" or B.name == "Moon":
                continue

            # Search mediator C
            for C in planets:
                if C.name in (A.name, B.name):
                    continue

                if (C.name, A.name) in itth_pairs and (C.name, B.name) in itth_pairs:
                    # C must be fastest
                    f_CA = faster(C, A)[0] == C
                    f_CB = faster(C, B)[0] == C
                    if not (f_CA and f_CB):
                        continue

                    nakta.append(f"Nakta Yog: {A.name} — {C.name} — {B.name}")

    return nakta


# -----------------------------------------------------------
# YOG #6 — YAMAYA
# -----------------------------------------------------------
def detect_yamaya(chart):
    itth_list = detect_itthasala(chart)
    itth_pairs = {(f, s) for (f, s, _, _) in itth_list} | {(s, f) for (f, s, _, _) in itth_list}

    planets = [p for p in chart.planets.values() if p.name not in ("Rahu", "Ketu")]
    yamaya = []

    for A in planets:
        for B in planets:
            if A.name >= B.name:
                continue

            for C in planets:
                if C.name in (A.name, B.name):
                    continue

                if (C.name, A.name) in itth_pairs and (C.name, B.name) in itth_pairs:
                    slow_CA = faster(A, C)[1] == C
                    slow_CB = faster(B, C)[1] == C
                    if slow_CA and slow_CB:
                        yamaya.append(f"Yamaya Yog: {A.name} — {C.name} — {B.name}")

    return yamaya


# -----------------------------------------------------------
# YOG #7 — MANAHOO
# -----------------------------------------------------------
def detect_manahoo(chart, itth_list):
    active, _ = analyze_chart_aspects(chart)
    destroyed = []

    for fast, slow, gap, label in itth_list:
        for asp in active:
            if asp["category"] not in ("open_enemy", "hidden_enemy"):
                continue

            p1, p2 = asp["p1"], asp["p2"]

            if "Saturn" not in (p1, p2) and "Mars" not in (p1, p2):
                continue
            if fast not in (p1, p2) and slow not in (p1, p2):
                continue

            killer = p1 if p1 in ("Saturn", "Mars") else p2
            destroyed.append(f"Manahoo Yog: {label} destroyed by {killer}")

    return destroyed


# -----------------------------------------------------------
# YOG #8 — KAMBOOLA
# -----------------------------------------------------------
def detect_kamboola(chart, itth_list):
    active, _ = analyze_chart_aspects(chart)
    moon = chart.planets["Moon"]
    kamb = []

    for fast_name, slow_name, _, _ in itth_list:
        for asp in active:
            if "Moon" not in (asp["p1"], asp["p2"]):
                continue

            other = asp["p1"] if asp["p2"] == "Moon" else asp["p2"]
            if other not in (fast_name, slow_name):
                continue

            other_p = chart.planets[other]
            fast_m, slow_m = faster(moon, other_p)

            if fast_m.name != "Moon":  # Moon must chase
                continue
            if moon.retro:
                continue
            if moon.degree >= other_p.degree:
                continue

            strength = "Strong (other retro)" if other_p.retro else "Normal"
            kamb.append(
                f"Kamboola Yog: Moon strengthens Itthasala {fast_name} → {slow_name} ({strength})"
            )

    return kamb

# -----------------------------------------------------------
# YOG 9 — GAIRIKAMBOOLA (Rare, powerful)
# -----------------------------------------------------------
def detect_gairikamboola(chart, itth_list):
    yogs = []
    moon = chart.planets["Moon"]

    # 2) Moon restrictions
    if moon.degree < 29:
        return yogs

    sign_lord = chart.sign_lords[moon.sign]
    if sign_lord == "Moon":
        return yogs  # own sign not allowed

    if chart.uchcha_signs.get("Moon") == moon.sign:
        return yogs
    if chart.mooltrikona_signs.get("Moon") == moon.sign:
        return yogs

    # Moon must have NO aspects
    active, _ = analyze_chart_aspects(chart)
    for asp in active:
        if "Moon" in (asp["p1"], asp["p2"]):
            return yogs

    # 1) At least one Itthasala exists already
    if not itth_list:
        return yogs

    # 4) Next sign logic
    next_sign = moon.sign % 12 + 1

    for p in chart.planets.values():
        if p.sign != next_sign:
            continue

        # planet must be powerful
        if not (
            chart.uchcha_signs.get(p.name) == next_sign or
            chart.mooltrikona_signs.get(p.name) == next_sign or
            chart.sign_lords[next_sign] == p.name
        ):
            continue

        # Itthasala must form with Moon
        for asp in active:
            if set((asp["p1"], asp["p2"])) == {"Moon", p.name}:
                if asp["category"] == "neutral":
                    continue

                # 5) Planet must be Lagnesh or Karesh
                lagnesh = chart.house_lord[1]
                karesh = chart.house_lord[((p.sign - chart.lagna_sign) % 12) + 1]

                if p.name in (lagnesh, karesh):
                    yogs.append(
                        f"Gairikamboola Yog: Moon → {p.name} (next sign activation)"
                    )
    return yogs

# -----------------------------------------------------------
# YOG 10 — KHALLASR (Negative, cancels Itthasala)
# -----------------------------------------------------------
def detect_khallasr(chart, itth_list):
    yogs = []
    moon = chart.planets["Moon"]

    if moon.degree >= 29:
        return yogs

    next_sign = moon.sign % 12 + 1
    next_planets = [p for p in chart.planets.values() if p.sign == next_sign]

    # 1) Empty or weak
    if next_planets:
        weak = True
        for p in next_planets:
            if chart.sign_lords[next_sign] == p.name:
                weak = False
        if not weak:
            return yogs

    # 3) Lagnesh / Karesh must NOT form Itthasala
    active, _ = analyze_chart_aspects(chart)
    lagnesh = chart.house_lord[1]

    for asp in active:
        if "Moon" in (asp["p1"], asp["p2"]) and lagnesh in (asp["p1"], asp["p2"]):
            return yogs

    # 4) Moon in 2/12 or 6/8 cancels Itthasala
    moon_house = ((moon.sign - chart.lagna_sign) % 12) + 1
    if moon_house in (2, 12, 6, 8) and itth_list:
        yogs.append("Khallasr Yog: Itthasala cancelled by Moon placement")

    return yogs

# -----------------------------------------------------------
# YOG 11 — RADDA (Destroys Itthasala)
# -----------------------------------------------------------
def detect_radda(chart, itth_list):
    yogs = []

    lagnesh = chart.house_lord[1]

    for p in (lagnesh,):
        planet = chart.planets[p]
        house = ((planet.sign - chart.lagna_sign) % 12) + 1

        if house in (6, 8, 12) and planet.retro:
            if itth_list:
                yogs.append(
                    f"Radda Yog: {p} weak/combust in dusthana — Itthasala destroyed"
                )
    return yogs

# -----------------------------------------------------------
# YOG 12 — DUPALLAI KUTHA
# -----------------------------------------------------------
def detect_dupallai_kutha(chart, itth_list):
    yogs = []

    lagnesh = chart.house_lord[1]

    for fast, slow, _, label in itth_list:
        # Lagnesh must be involved
        if lagnesh not in (fast, slow):
            continue

        fast_p = chart.planets[fast]
        slow_p = chart.planets[slow]

        # Slow planet must be very strong
        slow_sign = slow_p.sign
        strong_slow = (
            chart.uchcha_signs.get(slow) == slow_sign or
            chart.mooltrikona_signs.get(slow) == slow_sign or
            chart.sign_lords[slow_sign] == slow
        )
        if not strong_slow:
            continue

        # Fast planet must be weak but clean
        fast_house = ((fast_p.sign - chart.lagna_sign) % 12) + 1
        if fast_p.retro:
            continue
        if fast_house in (6, 8, 12):
            continue

        yogs.append(
            f"Dupallai Kutha Yog: {fast} (weak) → {slow} (strong) — success with imbalance"
        )

    return yogs

# -----------------------------------------------------------
# YOG 13 — DUTTAKUTIR
# -----------------------------------------------------------
def detect_duttakutir(chart, itth_list):
    yogs = []

    lagnesh = chart.house_lord[1]
    karesh_map = chart.house_lord

    # Identify weak Lagnesh
    lag_p = chart.planets[lagnesh]
    lag_house = ((lag_p.sign - chart.lagna_sign) % 12) + 1
    if lag_house not in (6, 8, 12):
        return yogs

    # Find Itthasala involving Lagnesh
    for fast, slow, _, label in itth_list:
        if lagnesh not in (fast, slow):
            continue

        other = slow if fast == lagnesh else fast
        other_p = chart.planets[other]

        # Other planet also weak
        other_house = ((other_p.sign - chart.lagna_sign) % 12) + 1
        if other_house not in (6, 8, 12):
            continue

        # Look for strong third planet
        for p in chart.planets.values():
            if p.name in (lagnesh, other):
                continue

            sign = p.sign
            strong = (
                chart.uchcha_signs.get(p.name) == sign or
                chart.mooltrikona_signs.get(p.name) == sign or
                chart.sign_lords[sign] == p.name
            )
            if not strong:
                continue

            yogs.append(
                f"DuttaKutir Yog: {lagnesh} & {other} weak — help from {p.name}"
            )

    return yogs

# -----------------------------------------------------------
# YOG 14 — SHUBH TAMBIR
# -----------------------------------------------------------
def detect_shubh_tambir(chart, itth_list):
    yogs = []

    lagnesh = chart.house_lord[1]
    karesh_map = chart.house_lord

    # helper: check strong planet
    def is_strong(p):
        sign = p.sign
        return (
            chart.uchcha_signs.get(p.name) == sign or
            chart.mooltrikona_signs.get(p.name) == sign or
            chart.sign_lords[sign] == p.name
        )

    # Step 1: Lagnesh & Karesh must NOT have Itthasala now
    current_pairs = {(f, s) for f, s, _, _ in itth_list} | {(s, f) for f, s, _, _ in itth_list}

    for house, karesh in karesh_map.items():
        if karesh == lagnesh:
            continue

        if (lagnesh, karesh) in current_pairs:
            continue  # ❌ already Itthasala → skip

        kp = chart.planets[karesh]

        # Step 2: Karesh must be above 29°
        if kp.degree < 29:
            continue

        # Step 3: simulate next sign entry
        next_sign = (kp.sign % 12) + 1

        # find strong planet in next sign
        strong_planets = [
            p.name for p in chart.planets.values()
            if p.sign == next_sign and is_strong(p)
        ]
        if not strong_planets:
            continue

        yogs.append(
            f"Shubh Tambir Yog: {karesh} at {kp.degree:.2f}° — delayed but auspicious success"
        )

    return yogs

# -----------------------------------------------------------
# YOG #15 — KUTTHA YOG
# -----------------------------------------------------------
def detect_kuttha(chart, bala_table):
    """
    Kuttha Yog (Tajik):
    Lagnesh and Karesh both in Kendra/Panphar (excluding 8th)
    and both must be strong by Panch-Vargiya Bala.
    """

    yogs = []

    lagnesh = chart.house_lord[1]
    kendra_panphar = {1, 2, 4, 5, 7, 10, 11}  # 8th strictly excluded

    lag_house = chart.planet_house[lagnesh]
    lag_vb = bala_table.get(lagnesh, {}).get("VB", 0.0)

    # Lagnesh must itself qualify
    if lag_house not in kendra_panphar or lag_vb < 10.0:
        return yogs

    for house, karesh in chart.house_lord.items():
        if karesh == lagnesh:
            continue

        kar_house = chart.planet_house[karesh]
        kar_vb = bala_table.get(karesh, {}).get("VB", 0.0)

        if (
            kar_house in kendra_panphar and
            kar_vb >= 10.0
        ):
            yogs.append(
                f"Kuttha Yog: Lagnesh {lagnesh} (VB={lag_vb:.2f}) and "
                f"Karesh {karesh} (VB={kar_vb:.2f}) strong in Kendra/Panphar — "
                f"assured success through capability and stability"
            )

    return yogs



# -----------------------------------------------------------
# YOG #16 — DURUF YOG
# -----------------------------------------------------------
def detect_duruf(chart, itth_list):
    yogs = []

    def is_afflicted(p):
        house = chart.planet_house[p.name]
        sign = p.sign

        debilitated = chart.mooltrikona_signs.get(p.name) != sign and chart.uchcha_signs.get(p.name) != sign
        enemy = chart.sign_lords[sign] != p.name
        dusthana = house in (6, 8, 12)

        return (
            dusthana or
            debilitated or
            enemy or
            p.retro or
            p.combust
        )

    for fast, slow, gap, label in itth_list:
        p1 = chart.planets[fast]
        p2 = chart.planets[slow]

        if is_afflicted(p1) and is_afflicted(p2):
            yogs.append(
                f"Duruf Yog: {label} — both planets afflicted, result blocked / failure"
            )

    return yogs



# -----------------------------------------------------------
# MASTER ENTRY
# -----------------------------------------------------------
def evaluate_yogs(chart):
    yogs = []

    bala_table = panch_vargiya_bala(chart)

    if iqbaal_yog(chart):
        yogs.append("Iqbaal Yog — Prosperity, growth")

    if induvaar_yog(chart):
        yogs.append("InduVaar Yog — Loss / separation / distance")

    itth = detect_itthasala(chart)
    yogs.extend([x[3] for x in itth])

    yogs.extend(detect_ishraf(chart))
    yogs.extend(detect_nakta(chart))
    yogs.extend(detect_yamaya(chart))
    yogs.extend(detect_manahoo(chart, itth))
    yogs.extend(detect_kamboola(chart, itth))
    yogs.extend(detect_gairikamboola(chart, itth))
    yogs.extend(detect_khallasr(chart, itth))
    yogs.extend(detect_radda(chart, itth))
    yogs.extend(detect_dupallai_kutha(chart, itth))
    yogs.extend(detect_duttakutir(chart, itth))
    yogs.extend(detect_shubh_tambir(chart, itth))
    yogs.extend(detect_kuttha(chart, bala_table))
    yogs.extend(detect_duruf(chart, itth))


    return yogs
