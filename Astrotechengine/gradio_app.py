"""
Gradio UI for Astro Quant Engine.
Each button fetches and displays data from a separate engine module.
"""
import gradio as gr
import json
import datetime
from app.core.swiss_engine import get_planetary_positions
from app.core.nakshatra_engine import calculate_nakshatra
from app.core.tithi_engine import calculate_tithi, is_purnima, is_amavasya
from app.core.rashi_engine import get_rashi_type, rashi_score, is_jaltarva, is_agni
from app.core.combust_engine import is_combust, combust_score
from app.core.aspect_engine import calculate_aspect
from app.core.yog_engine import pap_khatri_yog
from app.core.budh_engine import evaluate_budh
from app.core.vedh_engine import vedh_score
from app.core.navansh_engine import calculate_navansh, navansh_score
from app.core.reversal_engine import should_reverse
from app.core.scoring_engine import final_score
from app.core.sbc_engine import calculate_sbc, get_nakshatra_name
from app.core.nakshatra_engine import calculate_nakshatra
from app.core.rashi_parivartan_engine import calculate_rashi_parivartan
from app.core.shar_parivartan_engine import calculate_shar_parivartan
from app.core.kp_engine import calculate_kp_intraday
from app.core.aspect_advanced_engine import calculate_daily_aspects


def _get_raw():
    return get_planetary_positions()


def _flat(raw):
    planets = {}
    for name, data in raw.items():
        planets[name] = {
            "degree": data["D1"]["longitude"],
            "rashi": data["D1"]["rashi"],
            "retrograde": data["D1"]["retrograde"],
            "speed": data["D1"]["speed"],
            "nakshatra": data["D1"]["nakshatra"],
            "d9_rashi": data["D9"]["navansh_rashi"],
        }
    return planets


# ── 1. Planetary Positions (D1 + D9) ──
def btn_planets():
    raw = _get_raw()
    lines = ["🪐 PLANETARY POSITIONS (D1 + D9) — Mumbai Real-Time\n"]
    for name, data in raw.items():
        d1 = data["D1"]
        d9 = data["D9"]
        rname = d1.get('rashi_name', '')
        ddms = d1.get('degree_dms', f"{d1['degree_in_rashi']:.2f}")
        lines.append(f"  {name.upper()}")
        lines.append(f"    D1: {rname} (Rashi {d1['rashi']}), "
                      f"Deg {ddms}, "
                      f"Long {d1['longitude']:.2f}°, Retro {d1['retrograde']}, Speed {d1['speed']:.4f}")
        lines.append(f"    D9: {d9.get('navansh_rashi_name', '')} (Navansh Rashi {d9['navansh_rashi']})")
        lines.append("")
    return "\n".join(lines)


# ── 2. Nakshatra ──
def btn_nakshatra():
    raw = _get_raw()
    from app.core.nakshatra_engine import get_nakshatra_name, get_nakshatra_lord, get_nakshatra_pada
    lines = ["🌟 NAKSHATRA DATA\n"]
    for name, data in raw.items():
        nak = data["D1"]["nakshatra"]
        lon = data["D1"]["longitude"]
        nak_name = get_nakshatra_name(nak)
        nak_lord = get_nakshatra_lord(nak)
        pada = get_nakshatra_pada(lon)
        lines.append(f"  {name.upper():10s} → Nak {nak:2d} | {nak_name:15s} | Pada {pada} | Lord: {nak_lord}")
    return "\n".join(lines)


# ── 3. Tithi ──
def btn_tithi():
    raw = _get_raw()
    sun_deg = raw["sun"]["D1"]["longitude"]
    moon_deg = raw["moon"]["D1"]["longitude"]
    tithi = calculate_tithi(sun_deg, moon_deg)
    lines = [
        "🌗 TITHI DATA\n",
        f"  Sun Longitude:  {sun_deg:.2f}°",
        f"  Moon Longitude: {moon_deg:.2f}°",
        f"  Tithi:          {tithi}",
        f"  Purnima:        {is_purnima(tithi)}",
        f"  Amavasya:       {is_amavasya(tithi)}",
    ]
    return "\n".join(lines)


# ── 4. Rashi Classification ──
def btn_rashi():
    raw = _get_raw()
    lines = ["♈ RASHI CLASSIFICATION\n"]
    for name, data in raw.items():
        r = data["D1"]["rashi"]
        lines.append(f"  {name.upper():10s} → Rashi {r:2d} | {get_rashi_type(r):14s} | "
                      f"Score {rashi_score(r):+d} | Jaltarva {is_jaltarva(r)} | Agni {is_agni(r)}")
    return "\n".join(lines)


# ── 5. Combust (Asth) ──
def btn_combust():
    raw = _get_raw()
    sun_deg = raw["sun"]["D1"]["longitude"]
    lines = ["🔥 COMBUST (ASTH) CHECK\n"]
    for name, data in raw.items():
        if name == "sun":
            continue
        deg = data["D1"]["longitude"]
        comb = is_combust(name, deg, sun_deg)
        sc = combust_score(name, deg, sun_deg)
        diff = abs(deg - sun_deg)
        diff = min(diff, 360 - diff)
        lines.append(f"  {name.upper():10s} → Combust: {str(comb):5s} | Dist from Sun: {diff:.2f}° | Score {sc:+d}")
    return "\n".join(lines)


# ── 6. Aspects ──
def btn_aspects():
    raw = _get_raw()
    planets_list = list(raw.keys())
    lines = ["🔭 ASPECT ENGINE (Degree-Based)\n"]
    for i in range(len(planets_list)):
        for j in range(i + 1, len(planets_list)):
            p1 = planets_list[i]
            p2 = planets_list[j]
            d1 = raw[p1]["D1"]["longitude"]
            d2 = raw[p2]["D1"]["longitude"]
            asp = calculate_aspect(d1, d2)
            if asp["score"] != 0:
                lines.append(f"  {p1.upper():8s} ↔ {p2.upper():8s} → {asp['type']:25s} | "
                              f"Angle {asp['angle']:6.1f}° | Score {asp['score']:+d}")
    if len(lines) == 1:
        lines.append("  No significant aspects found.")
    return "\n".join(lines)


# ── 7. Vedh / SBC ──
def btn_vedh():
    raw = _get_raw()
    planets = _flat(raw)
    result = vedh_score(planets)
    lines = [
        "🧿 VEDH / SBC ENGINE\n",
        f"  Moon Nakshatra: {result['moon_nakshatra']}",
        f"  Moon Sector:    {result['moon_sector']}",
        f"  Vedh Score:     {result['score']:+d}",
        f"  Vedh List:",
    ]
    if result["vedh_list"]:
        for v in result["vedh_list"]:
            lines.append(f"    {v['planet'].upper()} → {v['type']} Vedh → {v['effect']}")
    else:
        lines.append("    No Vedh active.")
    return "\n".join(lines)


# ── 8. Pap Khatri Yog ──
def btn_yog():
    raw = _get_raw()
    planets = _flat(raw)
    result = pap_khatri_yog(planets)
    lines = [
        "🌀 PAP KHATRI YOG\n",
        f"  Active:          {result['active']}",
        f"  Score:           {result['score']:+d}",
        f"  Malefics near Moon: {', '.join(m.upper() for m in result['malefics_near_moon']) or 'None'}",
        f"  Budh Involved:   {result['budh_involved']}",
    ]
    return "\n".join(lines)


# ── 9. Budh Special ──
def btn_budh():
    raw = _get_raw()
    planets = _flat(raw)
    result = evaluate_budh(planets)
    lines = [
        "☿ BUDH SPECIAL ENGINE (BankNifty)\n",
        f"  Combust: {result['combust']}",
        f"  Score:   {result['score']:+d}",
        f"  Details:",
    ]
    for d in result["details"]:
        lines.append(f"    • {d}")
    return "\n".join(lines)


# ── 10. Navansh / Barguttam ──
def btn_navansh():
    raw = _get_raw()
    lines = ["🔮 NAVANSH (D9) / BARGUTTAM\n"]
    for name, data in raw.items():
        d1_rashi = data["D1"]["rashi"]
        d9_rashi = data["D9"]["navansh_rashi"]
        barg = d1_rashi == d9_rashi
        sc = navansh_score(d1_rashi, d9_rashi)
        lines.append(f"  {name.upper():10s} → D1 Rashi {d1_rashi:2d} | D9 Rashi {d9_rashi:2d} | "
                      f"Barguttam {str(barg):5s} | Score {sc:+d}")
    return "\n".join(lines)


# ── 11. Reversal ──
def btn_reversal():
    raw = _get_raw()
    sun_deg = raw["sun"]["D1"]["longitude"]
    lines = ["🔁 REVERSAL ENGINE\n"]
    for name, data in raw.items():
        if name == "sun":
            continue
        pdata = {
            "degree": data["D1"]["longitude"],
            "retrograde": data["D1"]["retrograde"],
            "rashi": data["D1"]["rashi"],
        }
        rev = should_reverse(name, pdata, sun_deg)
        lines.append(f"  {name.upper():10s} → Reverse: {str(rev):5s} | "
                      f"Retro {data['D1']['retrograde']} | Rashi {data['D1']['rashi']}")
    return "\n".join(lines)


# ── 14. Rashi Parivartan (Sign Change) ──
def btn_rashi_parivartan():
    result = calculate_rashi_parivartan()
    lines = ["RASHI PARIVARTAN (Sign Change) ENGINE\n"]
    lines.append(f"  {'PLANET':10s} {'CURRENT RASHI':18s} {'TYPE':8s} {'DEG':8s} {'SPEED':10s} {'DEG LEFT':10s} {'DAYS':8s} {'NEXT RASHI':18s} {'TYPE':8s} {'CHANGE DATE':18s} {'SANDHI':7s} {'TREND':20s}")
    lines.append("  " + "-" * 150)
    for name, d in result.items():
        retro = " (R)" if d['retrograde'] else ""
        sandhi = "YES" if d['in_sandhi'] else "-"
        lines.append(
            f"  {name.upper():10s} "
            f"{d['current_rashi_name']:18s} "
            f"{d['current_rashi_type']:8s} "
            f"{d['degree_in_rashi']:7.2f}  "
            f"{d['speed']:+9.4f}  "
            f"{d['degrees_to_change']:8.2f}   "
            f"{d['days_to_change']:7.1f}  "
            f"{d['next_rashi_name']:18s} "
            f"{d['next_rashi_type']:8s} "
            f"{d['estimated_change_date']:18s} "
            f"{sandhi:7s} "
            f"{d['trend_change']}{retro}"
        )
    lines.append("")
    lines.append("  SANDHI = Planet within 1 deg of rashi boundary (weakened)")
    lines.append("  Trend Change = Direction of rashi type shift at sign change")
    return "\n".join(lines)


# ── 15. Shar Parivartan (Declination Change) ──
def btn_shar_parivartan():
    result = calculate_shar_parivartan()
    lines = ["🌐 SHAR PARIVARTAN (Declination Change) ENGINE\n"]
    lines.append(
        f"  {'PLANET':10s} {'DECL°':>8s} {'SIDE':6s} {'MARKET':7s} "
        f"{'SPEED':>10s} {'NEXT CROSSING':18s} {'DAYS':>6s} {'DIRECTION':20s} {'TREND CHANGE':20s}"
    )
    lines.append("  " + "-" * 120)
    for name, d in result.items():
        cross = d['next_crossing']
        if cross:
            cross_date = cross['cross_date']
            days_away = f"{cross['days_away']:.1f}"
            direction = cross['direction']
            trend = cross['trend']
        else:
            cross_date = "N/A"
            days_away = "N/A"
            direction = "—"
            trend = "—"
        lines.append(
            f"  {name.upper():10s} "
            f"{d['declination']:+8.4f} "
            f"{d['side']:6s} "
            f"{d['market']:7s} "
            f"{d['decl_speed']:+10.6f} "
            f"{cross_date:18s} "
            f"{days_away:>6s} "
            f"{direction:20s} "
            f"{trend:20s}"
        )
    lines.append("")
    lines.append("  North Declination = Mandi (Bearish)")
    lines.append("  South Declination = Teji  (Bullish)")
    lines.append("  Moon crosses ~2 times per month")
    return "\n".join(lines)


# ── 13. SBC (Sarvatobhadra Chakra) ──
def btn_sbc():
    raw = _get_raw()
    planets = {}
    for name, data in raw.items():
        planets[name] = {
            "degree": data["D1"]["longitude"],
            "nakshatra": data["D1"]["nakshatra"],
            "retrograde": data["D1"]["retrograde"],
        }
    # Add Ketu (180° from Rahu)
    if "rahu" in raw:
        rahu_lon = raw["rahu"]["D1"]["longitude"]
        ketu_lon = (rahu_lon + 180.0) % 360.0
        ketu_nak = calculate_nakshatra(ketu_lon)
        planets["ketu"] = {
            "degree": ketu_lon,
            "nakshatra": ketu_nak,
            "retrograde": True,
        }
    result = calculate_sbc(planets)
    lines = [
        "SARVATOBHADRA CHAKRA (SBC) ENGINE\n",
        f"  Moon Nakshatra: {result['moon_nakshatra']} — {result['moon_nakshatra_name']}",
        f"  Moon Side:      {result['moon_side']}",
        f"  SBC Score:      {result['sbc_score']:+d}",
        f"  Vedh on Moon:   {result['moon_vedh_count']}",
        f"  Total Vedh:     {result['total_vedh_count']}",
        "",
        "  ── VEDH HITTING MOON ──",
    ]
    if result["moon_vedh"]:
        for v in result["moon_vedh"]:
            src = v["source_planet"].upper()
            src_nak = v["source_nakshatra_name"]
            direction = v["direction"]
            vtype = v["vedh_type"]
            effect = v.get("effect_on_moon", "")
            retro_flag = " (R)" if v["retrograde"] else ""
            lines.append(
                f"    {src}{retro_flag} [{src_nak}] → {direction} Vedh → "
                f"{vtype} → Effect: {effect}"
            )
    else:
        lines.append("    No vedh hitting Moon currently.")
    lines.append("")
    lines.append("  ── ALL VEDH ACTIVE ──")
    for v in result["all_vedh"]:
        src = v["source_planet"].upper()
        src_nak = v["source_nakshatra_name"]
        tgt_nak = v["target_nakshatra_name"]
        direction = v["direction"]
        vtype = v["vedh_type"]
        retro_flag = " (R)" if v["retrograde"] else ""
        lines.append(
            f"    {src}{retro_flag} [{src_nak}] → {direction} → {tgt_nak} ({vtype})"
        )
    return "\n".join(lines)


# ── 12. Final Prediction (13-Rule System) ──
def btn_predict():
    raw = _get_raw()
    planets = {}
    for name, data in raw.items():
        planets[name] = {
            "degree": data["D1"]["longitude"],
            "rashi": data["D1"]["rashi"],
            "retrograde": data["D1"]["retrograde"],
            "speed": data["D1"]["speed"],
            "nakshatra": data["D1"]["nakshatra"],
            "d9_rashi": data["D9"]["navansh_rashi"],
        }
    result = final_score(planets)

    # Build rich HTML output
    sc = result["score"]
    trend = result["trend"]
    conf = result["confidence"]
    teji_r = result["teji_rules"]
    mandi_r = result["mandi_rules"]
    neutral_r = result["neutral_rules"]
    alerts = result.get("alerts", [])

    # Trend color
    if sc >= 4:
        trend_color, trend_bg = "#155724", "#d4edda"
    elif sc <= -4:
        trend_color, trend_bg = "#721c24", "#f8d7da"
    else:
        trend_color, trend_bg = "#856404", "#fff3cd"

    html = []
    html.append("<div style='font-family:Segoe UI,sans-serif;max-width:900px;margin:auto'>")

    # ── Header ──
    html.append(f"""
    <div style='background:{trend_bg};border:2px solid {trend_color};border-radius:10px;
                padding:20px;margin-bottom:15px;text-align:center'>
      <h2 style='color:{trend_color};margin:0'>DAILY PREDICTION — 13 Rule System</h2>
      <h1 style='color:{trend_color};margin:8px 0;font-size:2.2em'>{trend}</h1>
      <div style='font-size:1.3em;color:{trend_color}'>
        Score: <b>{sc:+.2f}</b> &nbsp;|&nbsp; Confidence: <b>{conf}%</b>
      </div>
      <div style='margin-top:8px;font-size:1em;color:#555'>
        Teji Rules: <b style='color:green'>{teji_r}</b> &nbsp;|&nbsp;
        Mandi Rules: <b style='color:red'>{mandi_r}</b> &nbsp;|&nbsp;
        Neutral: <b>{neutral_r}</b>
      </div>
    </div>""")

    # ── Alerts ──
    if alerts:
        html.append("<div style='background:#fff3cd;border:2px solid #ffc107;border-radius:8px;padding:12px;margin-bottom:12px'>")
        for a in alerts:
            html.append(f"<div style='font-size:1.2em;font-weight:bold;color:#856404'>{a}</div>")
        html.append("</div>")

    # ── Rule-by-rule breakdown table ──
    html.append("""
    <table style='width:100%;border-collapse:collapse;font-size:0.95em'>
      <thead>
        <tr style='background:#2c3e50;color:white'>
          <th style='padding:8px;text-align:left;width:5%'>#</th>
          <th style='padding:8px;text-align:left;width:25%'>Rule</th>
          <th style='padding:8px;text-align:center;width:10%'>Score</th>
          <th style='padding:8px;text-align:left;width:60%'>Details</th>
        </tr>
      </thead><tbody>""")

    for i, (rule_name, rule_data) in enumerate(result["breakdown"].items(), 1):
        r_sc = rule_data["score"]
        desc = rule_data.get("description", rule_name)
        detail = rule_data.get("detail", "")

        # Format detail
        if isinstance(detail, list):
            detail_str = "<br>".join(str(d) for d in detail[:6])
            if len(detail) > 6:
                detail_str += f"<br><i>...+{len(detail)-6} more</i>"
        elif isinstance(detail, dict):
            detail_str = "<br>".join(f"{k}: {v}" for k, v in detail.items() if k != "score")
        else:
            detail_str = str(detail)

        # Color the score cell
        if r_sc > 0:
            sc_bg, sc_color = "#d4edda", "#155724"
            indicator = "▲"
        elif r_sc < 0:
            sc_bg, sc_color = "#f8d7da", "#721c24"
            indicator = "▼"
        else:
            sc_bg, sc_color = "#e2e3e5", "#383d41"
            indicator = "—"

        row_bg = "#f8f9fa" if i % 2 == 0 else "#ffffff"
        html.append(f"""
        <tr style='background:{row_bg};border-bottom:1px solid #dee2e6'>
          <td style='padding:6px 8px;font-weight:bold;color:#666'>{i}</td>
          <td style='padding:6px 8px'><b>{desc}</b></td>
          <td style='padding:6px 8px;text-align:center;background:{sc_bg};color:{sc_color};
              font-weight:bold;font-size:1.1em;border-radius:4px'>
            {indicator} {r_sc:+.1f}
          </td>
          <td style='padding:6px 8px;font-size:0.88em;color:#444'>{detail_str}</td>
        </tr>""")

    html.append("</tbody></table>")
    html.append("</div>")
    return "\n".join(html)


# ── 16. KP Intraday ──
_KP_COLORS = {
    # Greens
    "Buy": "#27ae60", "Strong Buy": "#1e8449",
    "Positive": "#a9dfbf", "Strong Positive": "#27ae60",
    "Trending-Positive": "#58d68d",
    "Sudden Positive Move": "#2ecc71",
    "High Volatility Buy": "#82e0aa",
    # Reds
    "Sell": "#e74c3c", "Strong Sell": "#c0392b",
    "Negative": "#f5b7b1", "Strong Negative": "#e74c3c",
    "Trending-Negative": "#ec7063",
    "Sudden Negative Move": "#cb4335",
    "High Volatility Sell": "#f1948a",
    # Yellows / Oranges
    "Trap": "#f39c12", "Trap Bears": "#e67e22", "Trap Bulls": "#d35400",
    "Volatile": "#f5b041", "Sudden Move": "#f0b27a",
    "Trending": "#fdebd0",
    # Neutral
    "Neutral": "#d5d8dc",
}

def _kp_cell(val, is_outcome=False):
    """Wrap a value in a colored <td>."""
    bg = _KP_COLORS.get(val, "#f8f9fa")
    # Use white text on dark backgrounds
    dark = {"#27ae60", "#1e8449", "#e74c3c", "#c0392b", "#cb4335",
            "#f39c12", "#e67e22", "#d35400"}
    color = "#fff" if bg in dark else "#222"
    weight = "font-weight:700;" if is_outcome else ""
    size = "font-size:13px;" if is_outcome else "font-size:12px;"
    return f'<td style="background:{bg};color:{color};padding:4px 8px;{weight}{size}text-align:center;">{val}</td>'

def _kp_plain_cell(val):
    return f'<td style="padding:4px 8px;text-align:center;font-size:12px;background:#f8f9fa;">{val}</td>'

def btn_kp_intraday():
    slots = calculate_kp_intraday()
    html = []
    html.append('<div style="font-family:Segoe UI,system-ui,sans-serif;">')
    html.append('<h3 style="margin:0 0 8px 0;">🔯 KP Intraday Engine — 5-min Slots (Mumbai)</h3>')
    html.append('<div style="overflow-x:auto;max-height:600px;overflow-y:auto;">')
    html.append('<table style="border-collapse:collapse;width:100%;">')
    # Header
    hdr_style = 'style="background:#2c3e50;color:#fff;padding:6px 8px;text-align:center;font-size:12px;position:sticky;top:0;z-index:1;"'
    html.append('<thead><tr>')
    for h in ["Time", "Moon SL", "5th Sign", "5th Star", "11th Star",
              "Moon View", "5th Sign V", "5th Star V", "11th View",
              "Final View", "Outcome"]:
        html.append(f'<th {hdr_style}>{h}</th>')
    html.append('</tr></thead><tbody>')
    # Rows
    for i, s in enumerate(slots):
        stripe = "#ffffff" if i % 2 == 0 else "#f7f9fc"
        html.append(f'<tr style="background:{stripe};">')
        # Time cell (bold)
        html.append(f'<td style="padding:4px 8px;text-align:center;font-weight:600;font-size:12px;">{s["time"]}</td>')
        # Lord cells (plain)
        for key in ["moon_sub", "fifth_sign", "fifth_star", "eleventh_star"]:
            html.append(_kp_plain_cell(s[key]))
        # View cells (colored)
        for key in ["moon_view", "fifth_sign_view", "fifth_star_view", "eleventh_view"]:
            html.append(_kp_cell(s[key]))
        # Final View (colored)
        html.append(_kp_cell(s["final_view"]))
        # Outcome (colored, bold)
        html.append(_kp_cell(s["outcome"], is_outcome=True))
        html.append('</tr>')
    html.append('</tbody></table></div>')
    # Legend
    html.append('<div style="margin-top:8px;font-size:11px;color:#666;">')
    html.append('SL = Sub Lord &nbsp;|&nbsp; RL = Rashi Lord &nbsp;|&nbsp; STL = Star Lord &nbsp;|&nbsp; '
                '<span style="background:#27ae60;color:#fff;padding:1px 6px;border-radius:3px;">Buy</span> '
                '<span style="background:#e74c3c;color:#fff;padding:1px 6px;border-radius:3px;">Sell</span> '
                '<span style="background:#f39c12;color:#fff;padding:1px 6px;border-radius:3px;">Trap</span> '
                '<span style="background:#d5d8dc;padding:1px 6px;border-radius:3px;">Neutral</span>')
    html.append('</div></div>')
    return "\n".join(html)


# ── 17. Advanced Aspects (date-filtered) ──
_ASP_SIGNAL_COLORS = {
    "Strong Buy": ("#1e8449", "#fff"), "Buy": ("#27ae60", "#fff"),
    "Strong Sell": ("#c0392b", "#fff"), "Sell": ("#e74c3c", "#fff"),
    "Hold": ("#f39c12", "#fff"),
}
_ASP_NATURE_COLORS = {
    "+": ("#27ae60", "#fff"), "-": ("#e74c3c", "#fff"),
    "Check Jay Rule": ("#f39c12", "#222"),
}

def _asp_cell(val, color_map=None, bold=False):
    bg, fg = "#f8f9fa", "#222"
    if color_map and val in color_map:
        bg, fg = color_map[val]
    w = "font-weight:700;" if bold else ""
    return f'<td style="background:{bg};color:{fg};padding:4px 6px;text-align:center;font-size:11px;{w}white-space:nowrap;">{val}</td>'

def btn_aspects_advanced(date_str: str = None):
    """Generate aspect HTML table for a given date."""
    import datetime as _dt
    if date_str:
        try:
            d = _dt.datetime.strptime(str(date_str), "%Y-%m-%d")
        except ValueError:
            d = _dt.datetime.now()
    else:
        d = _dt.datetime.now()

    aspects = calculate_daily_aspects(date=d)

    html = []
    html.append('<div style="font-family:Segoe UI,system-ui,sans-serif;">')
    html.append(f'<h3 style="margin:0 0 4px 0;">🔭 Advanced Aspect Engine — {d.strftime("%d %b %Y")}</h3>')
    html.append(f'<p style="margin:0 0 8px 0;font-size:12px;color:#666;">{len(aspects)} aspects found (orb ≤1°, 10-min scan)</p>')

    if not aspects:
        html.append('<p style="color:#888;font-size:14px;">No aspects found for this date.</p></div>')
        return "\n".join(html)

    html.append('<div style="overflow-x:auto;max-height:600px;overflow-y:auto;">')
    html.append('<table style="border-collapse:collapse;width:100%;">')
    hdr = 'style="background:#2c3e50;color:#fff;padding:5px 6px;text-align:center;font-size:11px;position:sticky;top:0;z-index:1;white-space:nowrap;"'
    html.append('<thead><tr>')
    for h in ["Start", "End", "Dur(m)", "Planet 1", "Planet 2",
              "Angle", "Aspect", "Orb", "Sign1", "Sign2",
              "Nak 1", "Nak 2", "Special", "Nature", "Victory", "Signal"]:
        html.append(f'<th {hdr}>{h}</th>')
    html.append('</tr></thead><tbody>')

    rashi_names = {
        1:"Ari",2:"Tau",3:"Gem",4:"Can",5:"Leo",6:"Vir",
        7:"Lib",8:"Sco",9:"Sag",10:"Cap",11:"Aqu",12:"Pis"
    }

    for i, a in enumerate(aspects):
        stripe = "#ffffff" if i % 2 == 0 else "#f7f9fc"
        ongoing = a.get("ongoing", False)
        row_border = 'border-left:3px solid #3498db;' if ongoing else ''
        html.append(f'<tr style="background:{stripe};{row_border}">')
        # Time cells
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;font-weight:600;">{a["start_str"]}</td>')
        end_label = a["end_str"] + (' ●' if ongoing else '')
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;">{end_label}</td>')
        # Duration
        dur = a.get("Duration (mins)", "")
        dur_str = f"{dur}" if dur else "—"
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;">{dur_str}</td>')
        # Planets
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;font-weight:600;">{a["Planet 1"]}</td>')
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;font-weight:600;">{a["Planet 2"]}</td>')
        # Angle
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;">{a["Target Angle"]}°</td>')
        # Aspect Name
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:10px;">{a.get("Aspect Name","")}</td>')
        # Orb
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;">{a["Orb"]}°</td>')
        # Signs
        s1 = rashi_names.get(a["Sign 1"], str(a["Sign 1"]))
        s2 = rashi_names.get(a["Sign 2"], str(a["Sign 2"]))
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;">{s1}</td>')
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:11px;">{s2}</td>')
        # Nakshatras
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:10px;">{a["Nakshatra 1"]}</td>')
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:10px;">{a["Nakshatra 2"]}</td>')
        # Special
        sp = a.get("Special Aspect", "")
        sp_bg = "#fef9e7" if sp else "#f8f9fa"
        html.append(f'<td style="background:{sp_bg};padding:4px 6px;text-align:center;font-size:10px;">{sp or "—"}</td>')
        # Nature
        html.append(_asp_cell(a["Nature"], _ASP_NATURE_COLORS, bold=True))
        # Victory
        vic = a.get("Victory", "")
        html.append(f'<td style="padding:4px 6px;text-align:center;font-size:10px;">{vic or "—"}</td>')
        # Signal
        html.append(_asp_cell(a["Signal"], _ASP_SIGNAL_COLORS, bold=True))
        html.append('</tr>')

    html.append('</tbody></table></div>')
    # Legend
    html.append('<div style="margin-top:8px;font-size:11px;color:#666;">')
    html.append(
        '<span style="background:#27ae60;color:#fff;padding:1px 6px;border-radius:3px;">+ Bullish</span> '
        '<span style="background:#e74c3c;color:#fff;padding:1px 6px;border-radius:3px;">– Bearish</span> '
        '<span style="background:#f39c12;color:#fff;padding:1px 6px;border-radius:3px;">Jay Rule</span> &nbsp;|&nbsp; '
        '● = ongoing at end of day &nbsp;|&nbsp; Special = Mars/Jupiter/Saturn special drishti'
    )
    html.append('</div></div>')
    return "\n".join(html)


# ── Gradio App ──
with gr.Blocks(title="ASTROTechwealth", theme=gr.themes.Soft()) as demo:
    gr.Markdown("# ASTROTechwealth")
    gr.Markdown("Click any button to fetch real-time astrology data from that engine module.")

    output = gr.Textbox(label="Engine Output", lines=25, interactive=False)
    kp_output = gr.HTML(label="KP Intraday", visible=False)
    aspect_output = gr.HTML(label="Advanced Aspects", visible=False)
    predict_output = gr.HTML(label="Daily Prediction", visible=False)

    with gr.Row():
        b1 = gr.Button("🪐 Planets (D1+D9)", variant="primary")
        b2 = gr.Button("🌟 Nakshatra")
        b3 = gr.Button("🌗 Tithi")
        b4 = gr.Button("♈ Rashi")

    with gr.Row():
        b5 = gr.Button("🔥 Combust")
        b6 = gr.Button("🔭 Aspects", variant="primary")
        b7 = gr.Button("🧿 Vedh (Simple)")
        b8 = gr.Button("🌀 Pap Khatri Yog")

    with gr.Row():
        b9 = gr.Button("☿ Budh Special")
        b10 = gr.Button("🔮 Navansh")
        b11 = gr.Button("🔁 Reversal")
        b13 = gr.Button("🔲 SBC Chakra", variant="primary")

    with gr.Row():
        b14 = gr.Button("Rashi Parivartan")
        b15 = gr.Button("🌐 Shar Parivartan")
        b16 = gr.Button("🔯 KP Intraday", variant="primary")
        b12 = gr.Button("Daily Prediction", variant="primary")

    gr.Markdown("---")
    gr.Markdown("### 🔭 Advanced Aspects (with Date Filter)")
    with gr.Row():
        aspect_date = gr.Textbox(label="Date (YYYY-MM-DD)", value=datetime.date.today().isoformat(), max_lines=1)
        b17 = gr.Button("🔭 Fetch Aspects", variant="primary")

    # --- Output routing helpers ---
    all_html_outputs = [output, kp_output, aspect_output, predict_output]

    def _show_kp():
        html = btn_kp_intraday()
        return gr.update(value=""), gr.update(value=html, visible=True), gr.update(value="", visible=False), gr.update(value="", visible=False)

    def _show_aspects(date_str):
        html = btn_aspects_advanced(date_str)
        return gr.update(value=""), gr.update(value="", visible=False), gr.update(value=html, visible=True), gr.update(value="", visible=False)

    def _show_prediction():
        html = btn_predict()
        return gr.update(value=""), gr.update(value="", visible=False), gr.update(value="", visible=False), gr.update(value=html, visible=True)

    def _show_text(fn):
        def wrapper():
            return fn(), gr.update(value="", visible=False), gr.update(value="", visible=False), gr.update(value="", visible=False)
        return wrapper

    b16.click(_show_kp, outputs=all_html_outputs)
    b17.click(_show_aspects, inputs=[aspect_date], outputs=all_html_outputs)

    # b6 (Aspects) also shows advanced aspects for today
    def _show_aspects_today():
        return _show_aspects(datetime.date.today().isoformat())
    b6.click(_show_aspects_today, outputs=all_html_outputs)

    # Daily Prediction → HTML panel
    b12.click(_show_prediction, outputs=all_html_outputs)

    # All other buttons: text output, hide HTML panels
    for b, fn in [(b1, btn_planets), (b2, btn_nakshatra), (b3, btn_tithi),
                  (b4, btn_rashi), (b5, btn_combust),
                  (b7, btn_vedh), (b8, btn_yog), (b9, btn_budh),
                  (b10, btn_navansh), (b11, btn_reversal), (b13, btn_sbc),
                  (b14, btn_rashi_parivartan), (b15, btn_shar_parivartan)]:
        b.click(_show_text(fn), outputs=all_html_outputs)

if __name__ == "__main__":
    demo.launch()
