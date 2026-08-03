// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/bottomNavigationController.dart';

Widget buildBadgesList() {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                 Get.theme.primaryColor.withAlpha(1),
                Get.theme.primaryColor.withAlpha(4),
              ],
            ),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.blue.shade100,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.trending_up_rounded,
                color: Colors.blue.shade600,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Progress Overview',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Keep learning to unlock more achievements!',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.blue.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        GetBuilder<BottomNavigationController>(builder: (bottomNavigationController) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: bottomNavigationController
                .astrologerbyId[0]
                .courseBadges?.length,
            itemBuilder: (context, index) {
              final badge =
              bottomNavigationController
                  .astrologerbyId[0]
                  .courseBadges![index];
              final badgeText =
                  badge.courseBadge?.replaceAll(RegExp(r'[\[\]"]'), '') ?? '';

              return AnimatedContainer(
                duration: Duration(milliseconds: 300 + (index * 100)),
                curve: Curves.easeOutBack,
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _getBadgeGradientColors(index),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.95),
                              Colors.grey.shade100.withOpacity(0.9),
                            ],
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(3, 3),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 6,
                              offset: const Offset(-3, -3),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        child: Icon(
                          _getBadgeIcon(index),
                          size: 26,
                          color: _getBadgeGradientColors(index)[0],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        badgeText,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
        const SizedBox(height: 20),
      ],
    ),
  );
}

List<Color> _getBadgeGradientColors(int index) {
  final gradients = [
    [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
    [const Color(0xFFf093fb), const Color(0xFFf5576c)],
    [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
    [const Color(0xFFfa709a), const Color(0xFFfee140)],
    [const Color(0xFF667eea), const Color(0xFF764ba2)],
    [const Color(0xFFa8edea), const Color(0xFFfed6e3)],
    [const Color(0xFFffecd2), const Color(0xFFfcb69f)],
    [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)],
  ];
  return gradients[index % gradients.length];
}

IconData _getBadgeIcon(int index) {
  final icons = [
    Icons.emoji_events_rounded,
    Icons.star_rounded,
    Icons.military_tech_rounded,
    Icons.workspace_premium_rounded,
    Icons.diamond_rounded,
    Icons.psychology_rounded,
    Icons.auto_awesome_rounded,
    Icons.celebration_rounded,
  ];
  return icons[index % icons.length];
}

Decoration badgedecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Colors.deepOrange.shade400,
      Colors.orangeAccent.shade200,
      Colors.orange.shade100,
    ],
  ),
  borderRadius: BorderRadius.circular(30),
  boxShadow: [
    BoxShadow(
      color: Colors.orange.withOpacity(0.4),
      blurRadius: 12,
      offset: const Offset(4, 6),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.6),
      blurRadius: 6,
      offset: const Offset(-3, -3),
    ),
  ],
  border: Border.all(
    color: Colors.white.withOpacity(0.8),
    width: 1.5,
  ),
);


Decoration inerdecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(20),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
