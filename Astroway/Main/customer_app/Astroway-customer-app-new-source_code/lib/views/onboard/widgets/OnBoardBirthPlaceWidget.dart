// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/main.dart';
import 'package:AstrowayCustomer/views/placeOfBrithSearchScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/splashController.dart';

class OnBordBirthPlaceWidget extends StatefulWidget {
  final OnBoardController onBoardController;
  const OnBordBirthPlaceWidget({
    Key? key,
    required this.onBoardController,
  }) : super(key: key);

  @override
  State<OnBordBirthPlaceWidget> createState() => _OnBordBirthPlaceWidgetState();
}

class _OnBordBirthPlaceWidgetState extends State<OnBordBirthPlaceWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.w),
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => PlaceOfBirthSearchScreen(
                    flagId: 9,
                  ));
            },
            child: IgnorePointer(
              child: TextField(
                controller: widget.onBoardController.birthPlaceController,
                onChanged: (_) {},
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.w),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(100.w)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(100.w)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(100.w)),
                    ),
                    hintText: 'Birth Place',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 18.h,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.all(0)),
              backgroundColor: WidgetStateProperty.all(Get.theme.primaryColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.w),
                    side: BorderSide.none),
              ),
            ),
            onPressed: () async {
              global.showOnlyLoaderDialog(context);
              await onboardController.addOnboardIntakeFormData();

              await Future.delayed(Duration(milliseconds: 100));
              await Get.find<ChatController>().getAstrologerCategorys();
              global.hideLoader();
              log('start free chat');
              bool? isFreeChat = global.sp!.getBool("is_freechat");
              int? defaultTime = global.sp!.getInt("defaultTime");
              log('isFreeChat $isFreeChat defaultTime $defaultTime');
              // Get.find<SplashController>()
              //     .apistartRandomChat(duration: defaultTime ?? 300);

              onboardController.StepWiseData['Step'] = 5;
              onboardController.StepWiseData['BirthPlace'] =
                  onboardController.birthPlaceController.text;
              debugPrint('My StepWise Data ${onboardController.StepWiseData}');
            },
            child: Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ).tr(),
          ),
        ),
      ],
    );
  }
}
