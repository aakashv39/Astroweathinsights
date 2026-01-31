from core.aspects import analyze_all_aspects
from core.chart import Chart
from core.planets import Planet

# your given sidereal longitudes
data = {
    "Sun":     208.99,
    "Moon":     25.78,
    "Mercury": 202.11,
    "Venus":   192.35,
    "Mars":    298.84,
    "Jupiter": 318.52,
    "Saturn":  225.48,
    "Rahu":    356.10,
    "Ketu":    176.10
}

# retro flags
retro = {
    "Sun": False,
    "Moon": False,
    "Mercury": True,
    "Venus": True,
    "Mars": False,
    "Jupiter": False,
    "Saturn": False,
    "Rahu": True,
    "Ketu": True
}

planets = {}
for name, lon in data.items():
    sign = int(lon // 30) + 1
    deg = lon % 30
    planets[name] = Planet(name, lon, sign, deg, retro[name])

chart = Chart(planets=planets, lagna_sign=9)

aspects = analyze_all_aspects(chart)
for a in aspects:
    print(a)
        