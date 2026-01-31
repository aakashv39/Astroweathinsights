"""
Report Service - Orchestrates the full Tajik Varshphal report generation process.
"""

import os
from datetime import datetime
from typing import Optional, Dict, Any

try:
    import swisseph as swe
except ImportError:
    swe = None

try:
    from reportlab.lib.pagesizes import A4
except ImportError:
    A4 = None

from core.ephemeris import compute_chart
from core.panch_vargiya import panch_vargiya_bala
from core.muntha import calculate_muntha
from core.prediction_engine import run_prediction
from core.prediction_formatter import format_predictions
from core.sahama import compute_all_sahamas
from core.aspects import analyze_chart_aspects
from core.report.pdf_generator import export_pdf

def run_report_pipeline(
    birth_date: str,        # "YYYY-MM-DD"
    birth_time: str,        # "HH:MM"
    lat: float,
    lon: float,
    timezone: str,          # "+05:30"
    target_year: int,
    client_name: str = "Client",
    output_path: Optional[str] = None
) -> str:
    """
    Runs the full calculation pipeline and generates a PDF report.
    Returns the path to the generated PDF.
    """
    if not A4:
        raise ImportError("The 'reportlab' library is required for PDF generation. Please install it using 'pip install reportlab'.")
    
    # 1. Compute Charts
    # Natal Chart
    natal_chart = compute_chart(
        date=birth_date,
        time=birth_time,
        lat=lat,
        lon=lon,
        timezone=timezone
    )
    
    # Varsh (Solar Return) Chart
    varsh_chart = compute_chart(
        date=birth_date,
        time=birth_time,
        lat=lat,
        lon=lon,
        timezone=timezone,
        solar_return_year=target_year
    )
    
    # 2. Compute Annual Factors
    # Determine if day/night
    sun_house = ((varsh_chart.planets["Sun"].sign - varsh_chart.lagna_sign) % 12) + 1
    is_day = 7 <= sun_house <= 12
    
    # Panch-Vargiya Bala
    bala_table = panch_vargiya_bala(varsh_chart)
    
    # Harsha Bala
    from core.harsh_bala import harsh_bala
    harsh_table = {}
    for p_name, p_obj in varsh_chart.planets.items():
        if p_name in ("Rahu", "Ketu"): 
            continue
        harsh_table[p_name] = harsh_bala(p_obj, is_day)
    
    # Muntha - Calculate FIRST (needed for Varshesh)
    birth_year_int = int(birth_date.split('-')[0])
    muntha_sign, munthesh_planet = calculate_muntha(
        natal_chart=natal_chart, 
        varsh_year=target_year, 
        birth_year=birth_year_int
    )
    
    # Get munthesh name from the sign lord
    sign_lords = {
        1: "Mars", 2: "Venus", 3: "Mercury", 4: "Moon",
        5: "Sun", 6: "Mercury", 7: "Venus", 8: "Mars",
        9: "Jupiter", 10: "Saturn", 11: "Saturn", 12: "Jupiter"
    }
    munthesh_name = sign_lords.get(muntha_sign, "Unknown")
    
    # Varshesh (Lord of the Year) - Simplified version
    # Using VF Lagnesh as a simplified Varshesh for now
    vf_lagnesh = varsh_chart.sign_lords[varsh_chart.lagna_sign]
    
    # Choose varshesh based on highest VB among key planets
    varshesh_candidates = [vf_lagnesh, munthesh_name]
    varshesh = vf_lagnesh  # default
    max_vb = 0
    for candidate in varshesh_candidates:
        if candidate in bala_table:
            vb = bala_table[candidate].get("VB", 0)
            if vb > max_vb:
                max_vb = vb
                varshesh = candidate
    
    # 3. Yogas & Aspects
    active_aspects, _ = analyze_chart_aspects(varsh_chart)
    
    # 4. Sahamas
    sahamas = compute_all_sahamas(varsh_chart)
    
    # 5. Prediction Engine
    results, ctx = run_prediction(
        chart=varsh_chart,
        bala_table=bala_table,
        varshesh=varshesh,
        muntha_house=muntha_sign,
        munthesh=munthesh_name,
        birth_chart=natal_chart
    )
    
    # Add bala to ctx for PDF
    ctx["bala"] = bala_table
    
    # 6. Formatting
    final_prediction_text = format_predictions(results)
    
    # 7. PDF Export
    if not output_path:
        # Default filename
        safe_name = client_name.replace(" ", "_")
        filename = f"Varshphal_Report_{target_year}_{safe_name}.pdf"
        output_path = os.path.join(os.getcwd(), filename)
    
    # Saham info (strength & timing) - extracted from ctx
    saham_info = ctx.get("saham_analysis", {})
    
    # Detected Yogas
    yogas = ctx.get("yogas", [])
    
    birth_dict = {
        "date": birth_date,
        "time": birth_time,
        "lat": lat,
        "lon": lon,
        "timezone": timezone
    }

    export_pdf(
        filename=output_path,
        ctx=ctx,
        yogas=yogas,
        sahamas=sahamas,
        saham_info=saham_info,
        final_prediction_text=final_prediction_text,
        birth=birth_dict,
        natal_chart=natal_chart,
        varsh_chart=varsh_chart,
        varshesh_name=varshesh,
        munthesh_name=munthesh_name,
        harsh_table=harsh_table,
        aspects=active_aspects,
        client_name=client_name,
        report_title=f"Varshaphal {target_year} – Annual Prediction Report"
    )
    
    return output_path

if __name__ == "__main__":
    # Test run
    test_data = {
        "birth_date": "1995-05-15",
        "birth_time": "14:30",
        "lat": 28.6139,
        "lon": 77.2090,
        "timezone": "+05:30",
        "target_year": 2025,
        "client_name": "Test User"
    }
    path = run_report_pipeline(**test_data)
    print(f"Report generated at: {path}")
