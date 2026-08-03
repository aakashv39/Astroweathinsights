// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class DailyInsightsWidget extends StatefulWidget {
  const DailyInsightsWidget({Key? key}) : super(key: key);

  @override
  State<DailyInsightsWidget> createState() => _DailyInsightsWidgetState();
}

class _DailyInsightsWidgetState extends State<DailyInsightsWidget> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Lucky Colors Section
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.palette_outlined, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Lucky Colours',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 40),
                  const Text(
                    '22,8',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Category Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildTab('🏥', 'Health', 0),
                  _buildTab('💰', 'Career', 1),
                  _buildTab('❤️', 'Relationship', 2),
                  _buildTab('💰', 'Finance', 3),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Good Status Card
            _buildStatusCard(
              emoji: '😊',
              title: 'TODAY YOUR DAY LOOKS - GOOD',
              description:
                  'Morning disturbances subside after a busy morning. As the clock strikes 3 pm, equilibrium is restored, allowing you to experience a harmonious and balanced day.',
              color: Colors.green,
              sliderValue: 0.7,
            ),

            const SizedBox(height: 16),

            // Poor Status Card
            _buildStatusCard(
              emoji: '😰',
              title: 'TODAY YOUR HEALTH LOOKS - POOR',
              description:
                  'Asthma patients should keep inhalers handy, as sudden breathlessness attacks could occur.',
              color: Colors.red,
              sliderValue: 0.3,
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildTab(String emoji, String label, int index) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: isSelected ? Colors.purple : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String emoji,
    required String title,
    required String description,
    required Color color,
    required double sliderValue,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mood Slider
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB33939),
                      Color(0xFFE07B39),
                      Color(0xFFE8C547),
                      Color(0xFF7CB342),
                    ],
                  ),
                ),
              ),
              Positioned(
                left:
                    MediaQuery.of(context).size.width * 0.85 * sliderValue - 20,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Live Webinar Banner
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    image: const DecorationImage(
                      image: NetworkImage('https://via.placeholder.com/50'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Live Webinar',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),

          // Bottom Navigation
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(Icons.home_outlined, 'Home'),
                  _buildNavItem(Icons.calendar_today_outlined, 'Match'),
                  _buildNavItem(Icons.person_outline, ''),
                  _buildNavItem(Icons.phone_outlined, 'Astro Call'),
                  _buildNavItem(Icons.more_horiz, 'More'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.grey.shade600, size: 24),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
          ),
      ],
    );
  }
}
