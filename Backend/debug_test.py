"""Debug test for full report generation"""
import traceback

try:
    from core.report.report_service import run_report_pipeline
    print("Testing full report generation...")
    
    path = run_report_pipeline(
        birth_date="1995-05-15",
        birth_time="14:30",
        lat=28.6139,
        lon=77.2090,
        timezone="+05:30",
        target_year=2025,
        client_name="Test User"
    )
    print(f"SUCCESS! PDF generated at: {path}")
        
except Exception as e:
    print(f"Error: {e}")
    traceback.print_exc()
