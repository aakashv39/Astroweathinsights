# Astro Quant Engine v2 — Full Document Implementation

A production-grade, modular FastAPI backend for astrology-based market prediction.  
Designed for React frontend and GenAI integration with 12+ independent API modules.

## Features
- Real-time planetary data (D1 + D9) via Swiss Ephemeris (Mumbai)
- 12 modular engines, each with its own API endpoint
- Score-based daily prediction with configurable weights
- All rules from the astrology trading document encoded
- OpenAPI docs auto-generated at `/docs`

## Modules

| # | Module | Engine File | API Endpoint |
|---|--------|------------|--------------|
| 1 | Planetary Positions | swiss_engine.py | GET /astro/d1d9 |
| 2 | Nakshatra | nakshatra_engine.py | GET /nakshatra/calculate |
| 3 | Tithi | tithi_engine.py | GET /tithi/calculate |
| 4 | Rashi Classification | rashi_engine.py | POST /rashi/classify |
| 5 | Aspect (Degree) | aspect_engine.py | POST /aspect/calculate |
| 6 | Combust (Asth) | combust_engine.py | POST /combust/check |
| 7 | Vedh / SBC | vedh_engine.py | GET /vedh/calculate |
| 8 | Pap Khatri Yog | yog_engine.py | GET /yog/pap-khatri |
| 9 | Budh Special | budh_engine.py | GET /budh/evaluate |
| 10 | Navansh (D9) | navansh_engine.py | GET /navansh/calculate, POST /navansh/barguttam |
| 11 | Reversal | reversal_engine.py | (used internally) |
| 12 | Scoring (Master) | scoring_engine.py | GET /predict/daily |

## Configuration
All constants and weights are in `app/core/config.py`.  
Adjust rashi lists, combust degrees, aspect scores, scoring weights, and trend thresholds as needed.

## Project Structure
```
app/
  main.py
  core/
    config.py
    swiss_engine.py
    nakshatra_engine.py
    tithi_engine.py
    rashi_engine.py
    combust_engine.py
    aspect_engine.py
    yog_engine.py
    budh_engine.py
    vedh_engine.py
    navansh_engine.py
    reversal_engine.py
    scoring_engine.py
  api/
    astro.py
    nakshatra.py
    tithi.py
    rashi.py
    aspect.py
    combust.py
    vedh.py
    yog.py
    budh.py
    navansh.py
    predict.py
  models/
    schemas.py
tests/
  test_astro_data.py
  test_all_engines.py
```

## Requirements
- Python 3.8+
- fastapi, uvicorn, pyswisseph, pytz
- Swiss Ephemeris data files (place in `./ephemeris` directory)

## Usage
1. Install dependencies:
   ```sh
   pip install fastapi uvicorn pyswisseph pytz
   ```
2. Run the API:
   ```sh
   uvicorn app.main:app --reload
   ```
3. Open docs: [http://localhost:8000/docs](http://localhost:8000/docs)
4. Run tests:
   ```sh
   python -m tests.test_astro_data
   python -m tests.test_all_engines
   ```

## Priority Order (from document)
1. Sar (North/South) — future
2. SBC / Vedh
3. Aspect (0, 90, 150, 180 strongest)
4. Planet State (Retro, Combust, Neech)
5. Pap Khatri Yog
6. Budh Special (BankNifty)
7. Rashi Type
8. Tithi
9. Hora — future
10. Sector logic — future
