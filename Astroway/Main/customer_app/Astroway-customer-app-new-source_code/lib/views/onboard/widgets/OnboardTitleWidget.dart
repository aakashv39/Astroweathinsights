import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Onboardtitlewidget extends StatelessWidget {
  final String title;
  final String richtitle;
  const Onboardtitlewidget(
      {Key? key, required this.title, required this.richtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
          text: '$title',
          style: Get.textTheme.titleMedium!.copyWith(
              color: blackColor, fontSize: 18.sp, fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: '$richtitle',
              style: Get.textTheme.titleMedium!.copyWith(
                  color: Get.theme.primaryColor,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600),
            )
          ]),
    );
  }
}
