from dataclasses import dataclass

@dataclass
class Planet:
    name: str
    longitude: float   # 0..360 absolute ecliptic
    sign: int          # 1..12
    degree: float      # 0..30 within sign
    retro: bool        # True if retrograde
    speed_rank: int    # smaller => faster

    def __repr__(self):
        return f"{self.name}: sign={self.sign} deg={self.degree:.2f} lon={self.longitude:.2f}{' R' if self.retro else ''}"
