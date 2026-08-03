"""
Request / Response models for all API endpoints.
"""
from pydantic import BaseModel
from typing import Optional


# --- Shared ---
class DateInput(BaseModel):
    year: int = 2026
    month: int = 2
    day: int = 25
    hour: int = 9
    minute: int = 15


# --- Aspect ---
class AspectRequest(BaseModel):
    degree1: float
    degree2: float


class AspectResponse(BaseModel):
    angle: float
    score: int
    type: str


# --- Combust ---
class CombustRequest(BaseModel):
    planet: str
    planet_degree: float
    sun_degree: float


class CombustResponse(BaseModel):
    combust: bool
    score: int


# --- Rashi ---
class RashiRequest(BaseModel):
    rashi: int


class RashiResponse(BaseModel):
    rashi: int
    type: str
    score: int
    is_jaltarva: bool
    is_agni: bool


# --- Navansh ---
class NavanshRequest(BaseModel):
    d1_rashi: int
    d9_rashi: int


class NavanshResponse(BaseModel):
    barguttam: bool
    score: int
