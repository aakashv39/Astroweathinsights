import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RotatingTagline extends StatefulWidget {
  final Duration displayDuration;
  final Duration animationDuration;

  const RotatingTagline({
    super.key,
    this.displayDuration = const Duration(seconds: 2),
    this.animationDuration = const Duration(milliseconds: 900),
  });

  @override
  State<RotatingTagline> createState() => _RotatingTaglineState();
}

class _RotatingTaglineState extends State<RotatingTagline>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  int currentIndex = 0;
  final List<String> taglines = [
    'वास्तु के दोष दूर करें, घर में सुख-शांति पाएं।',
    'प्रेम में तकलीफ़? जानें अपने प्रेम योग।',
    'शादी में रुकावट? जानें कुंडली का राज़!',
    'धन की कमी? ग्रह दोष से पाएं मुक्ति।',
    'ग्रहों के प्रभाव को समझिए, ज़िंदगी सुधारिए।'
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _startLoop();
  }

  void _startLoop() async {
    while (mounted) {
      await _controller.forward(); // fade in + slide in
      await Future.delayed(widget.displayDuration); // stay visible
      await _controller.reverse(); // fade out + slide down

      setState(() {
        currentIndex = (currentIndex + 1) % taglines.length;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Text(
          taglines[currentIndex],
          textAlign: TextAlign.center,
          style: Get.theme.textTheme.bodyMedium!.copyWith(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
