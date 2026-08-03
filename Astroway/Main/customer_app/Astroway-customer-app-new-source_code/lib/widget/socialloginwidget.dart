import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SocialLoginButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // OR with Divider Line
        Row(
          children: [
            Expanded(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Divider(color: Colors.grey.shade300, thickness: 1)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                "or Countinue with",
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              child: Divider(color: Colors.grey.shade300, thickness: 1),
            ),
          ],
        ),

        SizedBox(height: 20),

        // Social Login Buttons
        GetBuilder<LoginController>(
            builder: (loginController) => _socialButton(
                  "assets/images/gmail.png",
                  () async {
                    final userCredential =
                        await loginController.signInWithGoogle();
                    // ignore: unnecessary_null_comparison
                    if (userCredential != null) {
                      final user = userCredential.user;
                      final emailid = user?.email;
                      await loginController.loginAndSignupUser(
                          null,
                          emailid.toString(),
                          'India',
                          loginController.nameController.text);

                      print('Logged in as ${user?.displayName}');
                    } else {
                      print('Sign-in failed or was cancelled');
                    }
                  },
                )),
      ],
    );
  }

  // Widget for individual social button
  Widget _socialButton(String iconPath, VoidCallback ontapSocial) {
    return InkWell(
      onTap: ontapSocial,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        margin: EdgeInsets.symmetric(horizontal: 1.w),
        height: 6.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 4.h,
              height: 4.h,
            ),
            SizedBox(
              width: 3.w,
            ),
            Text(
              "Continue with Gmail",
              style: Get.theme.textTheme.bodyMedium!.copyWith(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w300,
              ),
            ).tr(),
          ],
        ),
      ),
    );
  }
}
