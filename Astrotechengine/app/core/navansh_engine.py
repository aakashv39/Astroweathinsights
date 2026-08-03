"""
Navansh Engine — D9 Barguttam rule.
From document:
  Navansh more effective than lagan (50-50 weight).
  Barguttam: If planet same rashi in D1 and D9 → strong Teji probability (+3).
"""


def calculate_navansh(longitude: float) -> int:
    """
    Proper Vedic D9 Navansh rashi (1–12).
    Starting rashi depends on D1 rashi element:
      Fire  (1,5,9)  → Aries (1)
      Earth (2,6,10) → Capricorn (10)
      Air   (3,7,11) → Libra (7)
      Water (4,8,12) → Cancer (4)
    """
    d1_rashi = int(longitude // 30) + 1
    pada_index = int((longitude % 30) / (30 / 9))  # 0–8
    return (((d1_rashi - 1) * 9 + pada_index) % 12) + 1


def is_barguttam(d1_rashi: int, d9_rashi: int) -> bool:
    """True if planet is in same rashi in D1 and D9 (Barguttam)."""
    return d1_rashi == d9_rashi


def navansh_score(d1_rashi: int, d9_rashi: int) -> int:
    """Returns +3 if Barguttam, 0 otherwise."""
    return 3 if is_barguttam(d1_rashi, d9_rashi) else 0
