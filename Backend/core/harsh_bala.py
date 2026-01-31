from config.settings import MALE_PLANETS, FEMALE_PLANETS

def harsh_bala(planet, varsh_pravesh_daytime: bool):
    """
    Simplified Harsh Bala:
        - Daytime: male planets get +5
        - Nighttime: female planets get +5
    """
    score = 0
    if varsh_pravesh_daytime and planet.name in MALE_PLANETS:
        score += 5
    if (not varsh_pravesh_daytime) and planet.name in FEMALE_PLANETS:
        score += 5
    return score
