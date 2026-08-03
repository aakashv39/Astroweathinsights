import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CongratsScreen extends StatelessWidget {
  final OnBoardController onBoardController;
  final VoidCallback onPressed;
  CongratsScreen(
      {Key? key, required this.onPressed, required this.onBoardController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Stack(
                children: [
                  Positioned(
                      top: 40,
                      left: 40,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        radius: 5,
                      )),
                  Positioned(
                      right: 60,
                      bottom: 30,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        radius: 5,
                      )),
                  Positioned(
                      bottom: 0,
                      left: 40,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        radius: 5,
                      )),
                  Positioned(
                      top: 0,
                      right: 50,
                      child: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        radius: 5,
                      )),
                  Container(
                    width: 80.w,
                    height: 20.h,
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    child: Container(
                      height: 130,
                      width: 130,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF8E36),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        height: 80,
                        width: 80,
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset(
                          Images.congressIcons, // Replace with your image asset
                          height: 60,
                          width: 60,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                "Wooh!",
                style: Get.textTheme.titleMedium!.copyWith(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: 'You got a ',
                  style: Get.textTheme.titleMedium!.copyWith(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'free chat',
                      style: Get.textTheme.titleMedium!.copyWith(
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              SizedBox(
                width: 55.w,
                height: 50,
                child: TextButton(
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.all(0)),
                    backgroundColor:
                        WidgetStateProperty.all(Get.theme.primaryColor),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100.w),
                          side: BorderSide.none),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    'Start Free Chat',
                    textAlign: TextAlign.center,
                    style: Get.theme.primaryTextTheme.titleMedium!
                        .copyWith(color: Colors.white),
                  ).tr(),
                ),
              ),
            ],
          ),
        ),
        // Positioned(
        //     top: 0,
        //     left: 0,
        //     child: Lottie.asset('assets/freeChat.json', repeat: true)),
      ],
    );
  }
}
