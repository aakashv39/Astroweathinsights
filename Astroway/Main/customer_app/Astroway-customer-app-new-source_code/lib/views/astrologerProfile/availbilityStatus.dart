import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AvailbilityStatus extends StatelessWidget {
  final String status;
  const AvailbilityStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: status == "Online"
                  ? const Color(0xFF066E0A)
                  : status == "Offline"
                      ? const Color(0xFFFF1100)
                      : const Color(0xFFFF9900),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              color: status == "Online"
                  ? const Color(0xFF066E0A)
                  : status == "Offline"
                      ? const Color(0xFFFF1100)
                      : const Color(0xFFFF9900),
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}
