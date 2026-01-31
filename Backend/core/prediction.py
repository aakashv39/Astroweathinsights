"""
High-level prediction assembler (concise output). This module uses
the outputs from other engines and composes a plain-text report.

The interpretation text is intentionally simple and indicative; you
should expand text blocks per classical Tajik rules.
"""
from typing import Dict
def generate_varshphal_report(natal_chart, varsh_chart, muntha_house, varshesh, bala_table: Dict[str,int]) -> str:
    lines = []
    lines.append(f"Muntha house: {muntha_house}")
    lines.append(f"Varshesh (Lord of Year): {varshesh.name}")
    lines.append("\nTop planets by Panch-Vargiya Bala:")
    sorted_bala = sorted(bala_table.items(), key=lambda kv: kv[1], reverse=True)
    for name,score in sorted_bala[:5]:
        lines.append(f"  {name}: {score}")
    # health quick checks: if lagna or muntha in 8/12/6 etc.
    # rudimentary
    lagna = varsh_chart.lagna
    if lagna in (8,12,6):
        lines.append("\nCaution: Varshphal lagna in adverse house (6/8/12) — health/expense cautions.")
    if muntha_house in (9,10,11):
        lines.append("\nMuntha in beneficial house (9/10/11) — favourable year for growth/status.")
    return "\n".join(lines)
