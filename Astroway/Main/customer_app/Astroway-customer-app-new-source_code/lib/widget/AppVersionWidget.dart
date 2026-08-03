import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text(
            "Loading version...",
            style: Get.textTheme.bodyLarge!.copyWith(
              color: Colors.orangeAccent,
              fontWeight: FontWeight.w300,
              fontSize: 12,
            ),
          ).tr();
        } else if (snapshot.hasError) {
          return Text(
            "Error finding version",
            style: Get.textTheme.bodyLarge!.copyWith(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
          ).tr();
        } else {
          final version = snapshot.data?.version ?? "Unknown";
          return Text(
            "App Version ",
            style: Get.textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w500,
              color: Get.theme.primaryColor,
              fontSize: 16.sp,
            ),
          ).tr(args: [version]);
        }
      },
    );
  }
}
