"""
Muntha calculation for Tajik Varshphal.

Rule:
    • Muntha moves 1 sign per completed year from the Natal Lagna.
    • Muntha sign = (natal_lagna_sign + years_elapsed) mod 12
    • Lord of that sign = Munthesh
"""

def calculate_muntha(natal_chart, varsh_year: int, birth_year: int):
    # Natal Lagna (1..12)
    lagna_sign = natal_chart.lagna_sign

    # Years elapsed
    years_elapsed = varsh_year - birth_year

    # Muntha sign (convert safe: 1..12)
    muntha_sign = ((lagna_sign - 1 + years_elapsed) % 12) + 1

    # Lords of signs
    sign_lords = {
        1: "Mars", 2: "Venus", 3: "Mercury", 4: "Moon",
        5: "Sun", 6: "Mercury", 7: "Venus", 8: "Mars",
        9: "Jupiter", 10: "Saturn", 11: "Saturn", 12: "Jupiter"
    }
    munthesh_name = sign_lords[muntha_sign]
    munthesh_planet = natal_chart.planets.get(munthesh_name)

    return muntha_sign, munthesh_planet
