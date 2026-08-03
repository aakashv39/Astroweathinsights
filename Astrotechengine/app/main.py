from fastapi import FastAPI
from app.api import (
    astro,
    nakshatra,
    tithi,
    rashi,
    aspect,
    combust,
    vedh,
    yog,
    budh,
    navansh,
    predict,
    sbc,
    rashi_parivartan,
)

app = FastAPI(
    title="Astro Quant Engine",
    description="Rule-based astrology trading engine with modular APIs for React/GenAI frontend.",
    version="1.0.0",
)

# --- Register all module routers ---
app.include_router(astro.router)
app.include_router(nakshatra.router)
app.include_router(tithi.router)
app.include_router(rashi.router)
app.include_router(aspect.router)
app.include_router(combust.router)
app.include_router(vedh.router)
app.include_router(yog.router)
app.include_router(budh.router)
app.include_router(navansh.router)
app.include_router(predict.router)
app.include_router(sbc.router)
app.include_router(rashi_parivartan.router)


@app.get("/")
def root():
    return {"status": "Astro Quant Engine running", "docs": "/docs"}
