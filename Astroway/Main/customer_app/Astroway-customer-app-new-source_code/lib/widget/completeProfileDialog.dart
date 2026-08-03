// -------------Complete Profile Dialog---------------------
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/profile/editUserProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showCompleteProfileDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                child: Image.asset(
                  Images.updateProfile,
                  height: 10.h,
                  color: Color(0xff3527F5),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Update Your Profile",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFA7A3B),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please update your profile to explore more services on Astroway.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      global.showOnlyLoaderDialog(context);
                      await global.splashController.getCurrentUserData();
                      global.hideLoader();
                      Get.to(() => EditUserProfile());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    backgroundColor: Get.theme.primaryColor,
                  ),
                  child: Text("Update Profile",
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    side: const BorderSide(
                      color: Color(0xff3527F5),
                    ),
                  ),
                  child: Text("Later",
                      style: Get.theme.textTheme.bodyMedium?.copyWith(
                          color: Color(0xff3527F5),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500)),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
