import 'package:AstrowayCustomer/utils/AppColors.dart' as AppColor;
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SkeletionLoading extends StatefulWidget {
  final int length;
  final Color skeletonColor;
  const SkeletionLoading(
      {super.key, this.length = 6, this.skeletonColor = AppColor.scaffbgcolor});

  @override
  State<SkeletionLoading> createState() => _SkeletionLoadingState();
}

class _SkeletionLoadingState extends State<SkeletionLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      itemCount: widget.length,
      itemBuilder: (context, index) => _buildCardSkeleton(),
    );
  }

  Widget _buildCardSkeleton() {
    return Container(
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
          color: widget.skeletonColor, borderRadius: BorderRadius.circular(0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmer(width: 58, height: 22, radius: 6),
              _shimmer(width: 72, height: 22, radius: 20),
            ],
          ),
          SizedBox(height: 1.5.h),
          _shimmer(width: double.infinity, height: 11),
          SizedBox(height: 0.7.h),
          _shimmer(width: 65.w, height: 11),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              _shimmer(width: 72, height: 26, radius: 6),
              SizedBox(width: 2.w),
              _shimmer(width: 88, height: 26, radius: 6),
              SizedBox(width: 2.w),
              _shimmer(width: 62, height: 26, radius: 6),
            ],
          ),
        ],
      ),
    );
  }

  Widget _shimmer({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          width: width == double.infinity ? null : width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEAEAEA),
                Color(0xFFF5F5F5),
                Color(0xFFEAEAEA),
              ],
              stops: const [0.0, 0.5, 1.0],
              transform: _ShimmerTransform(_animation.value),
            ),
          ),
        );
      },
    );
  }
}

class _ShimmerTransform extends GradientTransform {
  final double slide;
  const _ShimmerTransform(this.slide);

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slide, 0, 0);
}
