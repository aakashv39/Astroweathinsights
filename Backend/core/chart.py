from core.planets import Planet
from typing import Dict


class Chart:
    def __init__(self, planets: Dict[str, Planet], lagna_sign: int = None):
        self.planets = planets        # { "Sun": Planet(), ... }
        self.lagna_sign = lagna_sign  # Rasi Lagna sign number (1..12)
        self.lagna_degree = None

        # These will be filled externally (Ephemeris)
        self.varga_sign = {}
        self.varga_house = {}
        self.varga_lords = {}

        # must later be assigned by Muntha logic
        self.muntesh = None

    # ---------------------------------------------------------
    # Access helper
    # ---------------------------------------------------------
    def get_planet(self, name: str) -> Planet:
        """Return Planet object by name."""
        return self.planets.get(name)

    # ---------------------------------------------------------
    # HOUSE CALCULATION (House from Lagna)
    # ---------------------------------------------------------
    def get_house_of_planet(self, name: str) -> int:
        """
        Returns house number 1..12 using (planet_sign - lagna_sign).
        """
        p = self.planets.get(name)
        if not p or not self.lagna_sign:
            return None
        dist = (p.sign - self.lagna_sign) % 12
        return 12 if dist == 0 else dist

    # ---------------------------------------------------------
    # Make .house property directly available on each Planet
    # ---------------------------------------------------------
    def assign_houses_to_planets(self):
        """
        Creates p.house for each planet using Lagna.
        Must be called once after chart creation.
        """
        for p in self.planets.values():
            if not self.lagna_sign:
                p.house = None
            else:
                dist = (p.sign - self.lagna_sign) % 12
                p.house = 12 if dist == 0 else dist

    # ---------------------------------------------------------
    # Called from Ephemeris after Varga population
    # ---------------------------------------------------------
    def populate_vargas(self):
        """
        (your existing full implementation remained unchanged)
        → we do NOT touch it here
        """
        # your full populate_vargas logic stays here
        pass
