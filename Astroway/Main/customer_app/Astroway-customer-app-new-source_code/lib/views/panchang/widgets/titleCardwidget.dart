// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TitleCardWidget extends StatelessWidget {
  final String label;
  final String name;
  final String value;
  final String startTime;
  final String endTime;
  final Color color;

  const TitleCardWidget({
    Key? key,
    required this.label,
    required this.name,
    required this.value,
    required this.startTime,
    required this.endTime,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 1.w),
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 0.5), // Light peach background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: color),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween, // evenly spaced
              crossAxisAlignment: CrossAxisAlignment.center, // vertical center
              children: [
                Text(
                  "$startTime",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "to",
                  style: TextStyle(
                    fontSize: 10,
                    color: color,
                  ),
                ),
                Text(
                  "$endTime",
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
