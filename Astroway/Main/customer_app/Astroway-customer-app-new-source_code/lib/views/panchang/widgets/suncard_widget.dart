// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class SunCardWidget extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final List<Color> gradientColors;

  const SunCardWidget({
    Key? key,
    required this.title,
    required this.time,
    required this.icon,
    required this.gradientColors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.8, color: gradientColors.first),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Icon
          Icon(
            icon,
            size: 28,
            color: gradientColors.first,
          ),
          const SizedBox(height: 8),
          CustomPaint(
            size: const Size(double.infinity, 40),
            painter: SunCurvePainter(gradientColors: gradientColors),
          ),

          const SizedBox(height: 12),

          // Title + Time
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          // Location
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class SunCurvePainter extends CustomPainter {
  final List<Color> gradientColors;

  SunCurvePainter({required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: gradientColors,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
        size.width * 0.5, size.height * 0.1, size.width, size.height * 0.6);

    canvas.drawPath(path, paint);

    // Dashed horizontal reference line
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.4)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(0, size.height * 0.6),
        Offset(size.width, size.height * 0.6), linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
