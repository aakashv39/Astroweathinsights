from reportlab.lib.pagesizes import A4
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
    PageBreak,
    Flowable,
)
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from datetime import datetime

# --------------------------------------------------------------
# Constants
# --------------------------------------------------------------

SIGN_ABBR = {
    1: "Ar", 2: "Ta", 3: "Ge", 4: "Cn",
    5: "Le", 6: "Vi", 7: "Li", 8: "Sc",
    9: "Sg", 10: "Cp", 11: "Aq", 12: "Pi"
}

BLUE_DARK = colors.HexColor("#00264D")
BLUE_MED = colors.HexColor("#004C99")
BLUE_LIGHT = colors.HexColor("#E6EEF7")
GOLD = colors.HexColor("#D4AF37")

# --------------------------------------------------------------
# Helper: Flowable for North-Indian style chart
# --------------------------------------------------------------

class NorthIndianChart(Flowable):
    def __init__(self, chart, title, size=250):
        Flowable.__init__(self)
        self.chart = chart
        self.title = title
        self.size = size
        self.width = size
        self.height = size + 20

    def _house_signs(self):
        hs = {}
        for house in range(1, 13):
            sign = ((self.chart.lagna_sign + house - 2) % 12) + 1
            hs[house] = sign
        return hs

    def draw(self):
        canvas = self.canv
        size = self.size
        # Center horizontally in the available width if needed, but Flowables usually 
        # start at (0,0) in their local coordinate system.
        left = 0
        bottom = 0
        right = size
        top = size
        midx = size / 2.0
        midy = size / 2.0

        # Title
        canvas.setFont("Helvetica-Bold", 11)
        canvas.drawCentredString(midx, top + 5, self.title)

        # Outer square
        canvas.setStrokeColor(colors.black)
        canvas.setLineWidth(1.2)
        canvas.rect(left, bottom, size, size)

        # Diagonals
        canvas.line(left, bottom, right, top)
        canvas.line(left, top, right, bottom)

        # Mid-square (diamond)
        canvas.line(midx, bottom, right, midy)
        canvas.line(right, midy, midx, top)
        canvas.line(midx, top, left, midy)
        canvas.line(left, midy, midx, bottom)

        # House → sign mapping
        hs = self._house_signs()

        # text positions for each house (offsets from 0,0)
        positions = {
            1:  (midx,      top - 25),
            2:  (right - 25, top - 25),
            3:  (right - 25, midy + 15),
            4:  (right - 25, midy),
            5:  (right - 25, midy - 15),
            6:  (right - 25, bottom + 25),
            7:  (midx,      bottom + 25),
            8:  (left + 25, bottom + 25),
            9:  (left + 25, midy - 15),
            10: (left + 25, midy),
            11: (left + 25, midy + 15),
            12: (left + 25, top - 25),
        }

        canvas.setFont("Helvetica-Bold", 10)
        for house, (tx, ty) in positions.items():
            sign = hs[house]
            txt = f"{house}/{SIGN_ABBR[sign]}"
            canvas.drawCentredString(tx, ty, txt)

# --------------------------------------------------------------
# MAIN EXPORT FUNCTION
# --------------------------------------------------------------

def export_pdf(
    filename,
    ctx,
    yogas,
    sahamas,
    saham_info,
    final_prediction_text,
    birth=None,
    natal_chart=None,
    varsh_chart=None,
    varshesh_name=None,
    munthesh_name=None,
    harsh_table=None,
    aspects=None,
    client_name="Client",
    astrologer_name="Om Astrology",
    report_title="Annual Varshaphal Report",
):
    """
    Premium PDF generator for Tajik Varshphal.
    """
    doc = SimpleDocTemplate(
        filename,
        pagesize=A4,
        leftMargin=50,
        rightMargin=50,
        topMargin=50,
        bottomMargin=50,
    )

    styles = getSampleStyleSheet()

    # Define custom styles
    title_style = ParagraphStyle(
        "TitleStyle",
        parent=styles["Heading1"],
        fontSize=26,
        textColor=BLUE_DARK,
        alignment=1,
        spaceAfter=30,
        fontName="Helvetica-Bold",
    )

    header_style = ParagraphStyle(
        "HeaderStyle",
        fontSize=12,
        textColor=colors.black,
        alignment=1,
        spaceAfter=20,
    )

    section_style = ParagraphStyle(
        "SectionStyle",
        parent=styles["Heading2"],
        fontSize=16,
        textColor=BLUE_MED,
        spaceAfter=12,
        spaceBefore=20,
        borderPadding=(0, 0, 2, 0),
        borderColor=BLUE_MED,
        borderWidth=0,
        fontName="Helvetica-Bold",
    )

    sub_section_style = ParagraphStyle(
        "SubSectionStyle",
        parent=styles["Heading3"],
        fontSize=13,
        textColor=BLUE_DARK,
        spaceAfter=8,
        spaceBefore=12,
        fontName="Helvetica-Bold",
    )

    normal_text = ParagraphStyle(
        "NormalText",
        parent=styles["BodyText"],
        fontSize=10.5,
        leading=15,
        spaceAfter=6,
    )

    bullet_text = ParagraphStyle(
        "BulletText",
        parent=normal_text,
        leftIndent=20,
        firstLineIndent=0,
    )

    footer_style = ParagraphStyle(
        "FooterStyle",
        fontSize=8,
        textColor=colors.grey,
        alignment=1,
    )

    flow = []

    # ===================== COVER PAGE =====================
    flow.append(Spacer(1, 100))
    flow.append(Paragraph(report_title, title_style))
    flow.append(Spacer(1, 20))
    
    cover_table_data = [
        [Paragraph("Prepared For:", normal_text), Paragraph(f"<b>{client_name}</b>", normal_text)],
        [Paragraph("Date of Generation:", normal_text), Paragraph(f"<b>{datetime.now().strftime('%d %B, %Y')}</b>", normal_text)],
        [Paragraph("Astrology System:", normal_text), Paragraph("<b>Tajik Varshaphal (Annual Solar Return)</b>", normal_text)],
        [Paragraph("Consultant:", normal_text), Paragraph(f"<b>{astrologer_name}</b>", normal_text)],
    ]
    
    cover_table = Table(cover_table_data, colWidths=[150, 200])
    cover_table.setStyle(TableStyle([
        ('ALIGN', (0,0), (-1,-1), 'LEFT'),
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 10),
    ]))
    flow.append(cover_table)
    
    flow.append(Spacer(1, 250))
    flow.append(Paragraph("<i>Confidential Astrological Analysis</i>", footer_style))
    flow.append(PageBreak())

    # ===================== BIRTH DETAILS =====================
    if birth:
        flow.append(Paragraph("Native Birth Details", section_style))
        birth_data = [
            ["Parameter", "Details"],
            ["Name", client_name],
            ["Birth Date", birth.get('date', 'N/A')],
            ["Birth Time", birth.get('time', 'N/A')],
            ["Birth Location", f"{birth.get('lat', 'N/A')}, {birth.get('lon', 'N/A')}"],
            ["Timezone", birth.get('timezone', 'N/A')],
        ]
        
        t = Table(birth_data, colWidths=[150, 300])
        t.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,0), BLUE_MED),
            ('TEXTCOLOR', (0,0), (-1,0), colors.white),
            ('ALIGN', (0,0), (-1,-1), 'LEFT'),
            ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
            ('FONTSIZE', (0,0), (-1,-1), 10),
            ('BOTTOMPADDING', (0,0), (-1,-1), 8),
            ('TOPPADDING', (0,0), (-1,-1), 8),
            ('GRID', (0,0), (-1,-1), 0.5, colors.grey),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, BLUE_LIGHT]),
        ]))
        flow.append(t)
        flow.append(Spacer(1, 20))

    # ===================== ANNUAL SUMARY =====================
    flow.append(Paragraph("Annual Configuration Summary", section_style))
    
    year_val = "N/A"
    if varsh_chart and hasattr(varsh_chart, 'solar_return_datetime'):
        year_val = varsh_chart.solar_return_datetime.year

    summary_data = [
        ["Factor", "Value", "Description"],
        ["Year", str(year_val), "Target year for this report"],
        ["Varshesh", varshesh_name or "N/A", "Lord of the Year - Primary Influence"],
        ["Muntha", ctx.get("muntha_house", "N/A"), "Moving sensitive point (Success area)"],
        ["Munthesh", munthesh_name or "N/A", "Lord of Muntha sign"],
        ["Lagna Sign", str(varsh_chart.lagna_sign if varsh_chart else "N/A"), "Rising sign of the solar return"],
    ]
    
    t_sum = Table(summary_data, colWidths=[100, 100, 250])
    t_sum.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), BLUE_DARK),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.grey),
        ('FONTNAME', (0,0), (-1,0), 'Helvetica-Bold'),
        ('BOTTOMPADDING', (0,0), (-1,-1), 8),
        ('TOPPADDING', (0,0), (-1,-1), 8),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, BLUE_LIGHT]),
    ]))
    flow.append(t_sum)
    flow.append(Spacer(1, 20))

    # ===================== PLANETARY STRENGTHS =====================
    flow.append(Paragraph("Planetary Strength Analysis", section_style))
    
    # 1. Panch-Vargiya Bala
    flow.append(Paragraph("Panch-Vargiya Bala (Viswa Bala)", sub_section_style))
    flow.append(Paragraph("This measures the inherent strength of planets in the annual chart.", normal_text))
    
    pvb_rows = [["Planet", "PVB Score", "Classification"]]
    if ctx.get("bala"):
        for p_name, b_data in ctx["bala"].items():
            pvb_rows.append([p_name, f"{b_data['VB']:.2f}", b_data['label']])
    
    t_pvb = Table(pvb_rows, colWidths=[100, 100, 250])
    t_pvb.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), BLUE_MED),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.grey),
        ('FONTSIZE', (0,0), (-1,-1), 9),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, BLUE_LIGHT]),
    ]))
    flow.append(t_pvb)
    flow.append(Spacer(1, 15))

    # 2. Harsha Bala
    if harsh_table:
        flow.append(Paragraph("Harsha Bala (Four-Fold Strength)", sub_section_style))
        flow.append(Paragraph("Measures how 'happy' or comfortable a planet is in its placement.", normal_text))
        h_rows = [["Planet", "Harsha Score", "State"]]
        for p, score in harsh_table.items():
            state = "Strong" if score >= 10 else "Medium" if score >= 5 else "Weak"
            h_rows.append([p, str(score), state])
            
        t_harsh = Table(h_rows, colWidths=[100, 100, 250])
        t_harsh.setStyle(TableStyle([
            ('BACKGROUND', (0,0), (-1,0), colors.cadetblue),
            ('TEXTCOLOR', (0,0), (-1,0), colors.white),
            ('GRID', (0,0), (-1,-1), 0.5, colors.grey),
            ('FONTSIZE', (0,0), (-1,-1), 9),
            ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, BLUE_LIGHT]),
        ]))
        flow.append(t_harsh)
    
    flow.append(PageBreak())

    # ===================== CHARTS =====================
    flow.append(Paragraph("Annual Chart Visualizations", section_style))
    
    chart_table_data = []
    if natal_chart:
        chart_table_data.append(NorthIndianChart(natal_chart, "Natal Chart (Birth Placement)"))
    if varsh_chart:
        chart_table_data.append(NorthIndianChart(varsh_chart, f"Varsh Chart ({year_val})"))
        
    # Put charts side-by-side if they fit, or just vertically
    for c in chart_table_data:
        # Wrap in a list for Table center alignment trick
        ct = Table([[c]], colWidths=[400])
        ct.setStyle(TableStyle([('ALIGN', (0,0), (-1,-1), 'CENTER')]))
        flow.append(ct)
        flow.append(Spacer(1, 30))

    flow.append(PageBreak())

    # ===================== SAHAMAS =====================
    flow.append(Paragraph("Sahamas (Sensitive Points)", section_style))
    flow.append(Paragraph("Sahamas are specific calculated points that indicate when and where specific events are likely to occur during the year.", normal_text))
    
    s_rows = [["Saham Name", "Sign", "Degree", "Significance"]]
    saham_desc = {
        "Punya Sahama": "General fortune and merit",
        "Raja Sahama": "Status, power and authority",
        "Wealth Sahama": "Financial gains and possessions",
        "Karma Sahama": "Professional activities and deeds",
        "Vivaha Sahama": "Marriage and partnerships",
        "Putra Sahama": "Children and creativity",
        "Roga Sahama": "Health issues or debts",
        "Mrityu Sahama": "Critical transformations or losses",
        "Foreign Sahama": "Travel and foreign associations",
    }
    
    for name, SA in sahamas.items():
        if name not in saham_desc and len(s_rows) > 10: continue # limit for space
        deg_str = f"{SA['deg']}° {SA['min']}'"
        s_rows.append([name, SA["sign_name"], deg_str, saham_desc.get(name, "Annual Point")])
        
    t_sah = Table(s_rows, colWidths=[120, 80, 80, 180])
    t_sah.setStyle(TableStyle([
        ('BACKGROUND', (0,0), (-1,0), BLUE_MED),
        ('TEXTCOLOR', (0,0), (-1,0), colors.white),
        ('GRID', (0,0), (-1,-1), 0.5, colors.grey),
        ('FONTSIZE', (0,0), (-1,-1), 8.5),
        ('ROWBACKGROUNDS', (0,1), (-1,-1), [colors.white, BLUE_LIGHT]),
    ]))
    flow.append(t_sah)
    flow.append(Spacer(1, 20))

    # Saham timing
    if saham_info:
        flow.append(Paragraph("Activation Windows", sub_section_style))
        for name, info in list(saham_info.items())[:6]: # Show top 6
            start, end = info["window_days"]
            txt = f"<b>{name}</b>: Expected activation between day {start} and {end} of the year. Strength: {info['strength']}."
            flow.append(Paragraph(txt, bullet_text))
            
    flow.append(PageBreak())

    # ===================== ANNUAL PREDICTIONS =====================
    flow.append(Paragraph("Detailed Annual Predictions", section_style))
    
    if yogas:
        flow.append(Paragraph("Tajik Yogas (Special Combinations)", sub_section_style))
        for y in yogas:
            flow.append(Paragraph(f"• {y}", bullet_text))
        flow.append(Spacer(1, 15))

    flow.append(Paragraph("Thematic Forecast", sub_section_style))
    
    pred_text = final_prediction_text or "No specific predictive signals were strong enough for categorization."
    
    for line in pred_text.split("\n"):
        line = line.strip()
        if not line:
            flow.append(Spacer(1, 8))
            continue
        if line.startswith("---") or line.startswith("==="):
            continue
        
        # Highlight topic headers if they exist
        if ":" in line and len(line) < 40 and not line.startswith("•"):
            flow.append(Paragraph(f"<b>{line}</b>", normal_text))
        else:
            flow.append(Paragraph(line, normal_text))

    # ===================== FOOTER / DISCLAIMER =====================
    flow.append(Spacer(1, 50))
    flow.append(Paragraph("<hr/>", normal_text))
    flow.append(Paragraph("<b>Disclaimer:</b>", ParagraphStyle("Disc", parent=normal_text, fontSize=8)))
    flow.append(Paragraph(
        "This report is based on mathematical calculations of planetary positions at the time of your solar return. "
        "Astrology is a tool for guidance and self-reflection. Results may vary based on individual karma and environmental factors. "
        "Decisions should be made using your own judgment.",
        ParagraphStyle("DiscText", parent=normal_text, fontSize=8, textColor=colors.grey)
    ))

    # Build PDF
    doc.build(flow)
    print(f"PDF successfully saved to {filename}")
