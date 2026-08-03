// achievement_badge_button.dart

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AchievementBadgeButton extends StatelessWidget {
  final dynamic bottomNavigationController;
  final Decoration badgeDecoration;
  final Decoration innerDecoration;
  final Widget Function() buildBadgesList;

  const AchievementBadgeButton({
    super.key,
    required this.bottomNavigationController,
    required this.badgeDecoration,
    required this.innerDecoration,
    required this.buildBadgesList,
  });

  @override
  Widget build(BuildContext context) {
    double scaleW(double value) =>
        MediaQuery.of(context).size.width * value / 100;
    double scaleH(double value) =>
        MediaQuery.of(context).size.height * value / 100;
    double scaleSp(double value) =>
        value * (MediaQuery.of(context).textScaler.scale(1.0));
    final int badgeCount =
        bottomNavigationController.astrologerbyId[0].courseBadges?.length ?? 0;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext dialogContext) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(dialogContext).size.height * 0.7,
                ),
                decoration: badgeDecoration,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          SizedBox(width: scaleW(4.0)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Achievements',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  '$badgeCount badges earned',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () => Navigator.of(dialogContext).pop(),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: const Icon(
                                  Icons.close_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.all(scaleW(5)),
                        padding: const EdgeInsets.all(20),
                        decoration: innerDecoration,
                        child: buildBadgesList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Stack(
        children: [
          // Main Badge Icon
          Container(
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).primaryColor),
            ),
            child: Image.asset(
              'assets/images/rewards.png',
              height: scaleH(3),
              width: scaleW(4),
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            right: 0,
            top: scaleW(1),
            child: CircleAvatar(
              radius: scaleW(2.5),
              backgroundColor: const Color(0xff343128),
              child: Text(
                '$badgeCount',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: scaleSp(11),
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
