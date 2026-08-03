// ignore_for_file: deprecated_member_use

import 'dart:math';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RippleAnimation extends StatefulWidget {
  const RippleAnimation({super.key});
  @override
  State<RippleAnimation> createState() => _RippleAnimationState();
}

class _RippleAnimationState extends State<RippleAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              for (int i = 3; i >= 1; i--) _buildRipple(i.toDouble()),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: whiteColor,
                  image: const DecorationImage(
                      image: AssetImage(
                    'assets/images/cosmic-ai.png',
                  )),
                  border:
                      Border.all(color: Colors.deepOrangeAccent, width: 0.5),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRipple(double delay) {
    final size = Tween<double>(begin: 50, end: 250).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    final opacity = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.0,
          1.0,
          curve: Curves.easeOut,
        ),
      ),
    );

    return FadeTransition(
      opacity: opacity,
      child: Container(
        width: size.value * delay,
        height: size.value * delay,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepOrangeAccent.withOpacity(0.3),
        ),
      ),
    );
  }
}

class RandomStringPicker {
  final List<String> items;
  final Random _random = Random();
  RandomStringPicker(this.items);
  String getRandomString() {
    if (items.isEmpty) {
      throw Exception("The list is empty!");
    }
    return items[_random.nextInt(items.length)];
  }
}

List<String> myStrings = [
  'How can I overcome planetary stress',
  'Please tell me about my birth chart',
  'Hey! I am your personalized AI guide'
];

class AnimatedHintTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  const AnimatedHintTextField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(30.w)),
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: AnimatedTextKit(
                repeatForever: true,
                isRepeatingAnimation: true,
                animatedTexts: myStrings.map((text) {
                  return TyperAnimatedText(
                    text,
                    textStyle: Get.theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                    speed: const Duration(milliseconds: 200),
                  );
                }).toList(),
              ),
            ),
            const Icon(CupertinoIcons.location_fill),
          ],
        ),
      ),
    );
  }
}
