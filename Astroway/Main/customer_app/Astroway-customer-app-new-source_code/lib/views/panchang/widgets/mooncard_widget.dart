// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MoonCardWidget extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color colors;

  const MoonCardWidget({
    Key? key,
    required this.title,
    required this.time,
    required this.icon,
    required this.colors,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: EdgeInsets.all(1.w),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.withOpacity(0.1),
        border: Border.all(width: 0.5, color: colors),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            icon,
            size: 28,
            color: colors,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: colors,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: TextStyle(
                  fontSize: 12,
                  color: colors.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
