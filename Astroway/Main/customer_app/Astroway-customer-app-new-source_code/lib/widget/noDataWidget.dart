import 'package:AstrowayCustomer/utils/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NoDataWidget extends StatelessWidget {
  final String? title;
  final double imageHeight;

  const NoDataWidget({
    super.key,
    this.title,
    this.imageHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          Images.noDataFound,
          height: imageHeight,
        ),
        SizedBox(height: 10),
        Text(
          title ?? 'No Data Found',
          style: Get.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 15.sp,
            color: Colors.black45,
          ),
        ).tr(),
      ],
    );
  }
}
