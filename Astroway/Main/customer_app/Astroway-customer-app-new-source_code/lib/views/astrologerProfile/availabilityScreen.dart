// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widget/commonAppbar.dart';

class AvailabilityScreen extends StatelessWidget {
  final String astrologerName;
  final String astrologerProfile;

  const AvailabilityScreen({
    Key? key,
    required this.astrologerName,
    required this.astrologerProfile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CommonAppBar(
          title: astrologerName,
          isProfilePic: true,
          profileImg: astrologerProfile,
        ),
      ),
      body: GetBuilder<BottomNavigationController>(
        builder: (bottombarController) {
          if (bottombarController.astrologerAvailavility.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '$astrologerName ${tr("Not Set Available Time")}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bottombarController.astrologerAvailavility.length,
            itemBuilder: (context, index) {
              final availability =
                  bottombarController.astrologerAvailavility[index];
              final hasTimeSlots =
                  availability.time != null && availability.time!.isNotEmpty;
              final dayName = availability.day ?? "day";
              final isLastItem = index ==
                  bottombarController.astrologerAvailavility.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Timeline column
                    SizedBox(
                      width: 60,
                      child: Column(
                        children: [
                          // Day indicator circle
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: _getDayColor(dayName),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _getDayColor(dayName),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getDayColor(dayName).withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                dayName.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          // Vertical connector line
                          if (!isLastItem)
                            Expanded(
                              child: Container(
                                width: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      _getDayColor(dayName),
                                      _getDayColor(bottombarController
                                              .astrologerAvailavility[index + 1]
                                              .day ??
                                          "day"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Content column
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 24, left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Colors.grey.shade300, width: 0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Day header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _getDayColor(dayName).withOpacity(0.05),
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                ),
                                border: Border(
                                  bottom: BorderSide(
                                    color:
                                        _getDayColor(dayName).withOpacity(0.2),
                                  ),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      dayName.capitalizeFirst ?? dayName,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: _getDayColor(dayName),
                                      ),
                                    ).tr(),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: hasTimeSlots
                                          ? _getDayColor(dayName)
                                              .withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      hasTimeSlots
                                          ? tr("Available")
                                          : tr("Not Available"),
                                      style: TextStyle(
                                        color: hasTimeSlots
                                            ? _getDayColor(dayName)
                                            : Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Time slots or empty state
                            if (!hasTimeSlots)
                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.event_busy_outlined,
                                        size: 40,
                                        color: Colors.grey[400],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        tr("No time slots available"),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 8),
                                    ...List.generate(availability.time!.length,
                                        (timeIndex) {
                                      final timeSlot =
                                          availability.time![timeIndex];
                                      final isLastTime = timeIndex ==
                                          availability.time!.length - 1;

                                      if (timeSlot.fromTime == null ||
                                          timeSlot.toTime == null) {
                                        return const SizedBox.shrink();
                                      }

                                      return IntrinsicHeight(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 8, left: 8),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                decoration: BoxDecoration(
                                                  color: _getDayColor(dayName)
                                                      .withOpacity(0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: _getDayColor(dayName)
                                                        .withOpacity(0.2),
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      size: 18,
                                                      color:
                                                          _getDayColor(dayName),
                                                    ),
                                                    const SizedBox(width: 12),
                                                    Expanded(
                                                      child: Text(
                                                        '${timeSlot.fromTime} - ${timeSlot.toTime}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Colors.grey[800],
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getDayColor(String day) {
    switch (day.toLowerCase()) {
      case 'monday':
        return const Color(0xFF4A6FA5);
      case 'tuesday':
        return const Color(0xFFE07A5F);
      case 'wednesday':
        return const Color(0xFF9B59B6);
      case 'thursday':
        return const Color(0xFF2E86AB);
      case 'friday':
        return const Color(0xFF58A4B0);
      case 'saturday':
        return const Color(0xFFD88C9A);
      case 'sunday':
        return const Color(0xFFC44536);
      default:
        return Colors.grey;
    }
  }
}
