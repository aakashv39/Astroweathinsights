"""
Budh (Mercury) Special Engine — Most important for BankNifty.
From document:
  1. Budh retrograde + combust → Teji
  2. Budh direct (margi) → Mandi
  3. Budh with Guru/Shukra/Neptune → Teji
  4. Budh neech → reversal
  5. Budh 0° with Sun → big move
  6. Asth effect starts 2 days before
"""
from .combust_engine import is_combust


def evaluate_budh(planets: dict) -> dict:
    """
    Evaluates Mercury special logic.
    planets: dict with at least 'mercury', 'sun', 'jupiter', 'venus' entries.
    Each entry must have 'degree', 'retrograde'.
    Returns dict with 'score', 'details'.
    """
    mercury = planets["mercury"]
    sun = planets["sun"]
    score = 0
    details = []

    combust = is_combust("mercury", mercury["degree"], sun["degree"])

    # Rule 1: Retro + Combust → Teji
    if mercury["retrograde"] and combust:
        score += 4
        details.append("Budh Bakri+Asth → Strong Teji")

    # Rule 2: Margi → Mandi
    if not mercury["retrograde"]:
        score -= 2
        details.append("Budh Margi → Mandi")

    # Rule 3: Conjunction with Jupiter or Venus → Teji
    for p in ["jupiter", "venus"]:
        if p not in planets:
            continue
        diff = abs(planets[p]["degree"] - mercury["degree"])
        diff = min(diff, 360 - diff)
        if diff < 5:
            score += 2
            details.append(f"Budh conjunct {p.title()} → Teji")

    # Rule 5: 0° with Sun → big move
    sun_diff = abs(mercury["degree"] - sun["degree"])
    sun_diff = min(sun_diff, 360 - sun_diff)
    if sun_diff < 1:
        score += 3
        details.append("Budh 0° with Sun → Big Move")

    return {"score": score, "details": details, "combust": combust}
