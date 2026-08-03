import 'package:easy_localization/easy_localization.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (splashController) {
        final user = splashController.currentUser;
        // log("user info data ${user!.toJson()}");
        // log("user info bith data  ${user.birthTime}");
        if (user == null) return const SizedBox.shrink();

        return Container(
          margin: EdgeInsets.only(left: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 18),
              Row(
                children: [
                  Image.asset(Images.namasteImage,
                      color: darkGreen, height: 25),
                  SizedBox(width: 1),
                  RichText(
                    text: TextSpan(
                      text: tr("Namaste "),
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                        color: darkGreen,
                        fontSize: 19.sp,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w700,
                      ),
                      children: [
                        TextSpan(
                          text: user.name ?? "User",
                          style: Get.theme.textTheme.bodyMedium?.copyWith(
                            color: const Color(0xFF0000FF),
                            fontSize: 19.sp,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3),
              Row(
                children: [
                  user.birthDate != null
                      ? Icon(CupertinoIcons.calendar, size: 20)
                      : SizedBox.shrink(),
                  SizedBox(width: 5),
                  Text(
                    user.birthDate != null
                        ? DateFormat("MMM d, yyyy")
                            .format(DateTime.parse(user.birthDate.toString()))
                        : "",
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 20),
                  if (user.birthTime != null && user.birthTime!.isNotEmpty)
                    Icon(CupertinoIcons.time, size: 20),
                  SizedBox(width: 5),
                  Text(
                    (user.birthTime != null && user.birthTime!.isNotEmpty)
                        ? _formatBirthTime(user.birthTime!)
                        : '',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

String _formatBirthTime(String birthTime) {
  try {
    final parsedTime = DateFormat("HH:mm:ss").parse(birthTime);
    return DateFormat("hh:mm a").format(parsedTime);
  } catch (e) {
    // If parsing fails, return an empty string (safe fallback)
    return '';
  }
}
