// ignore_for_file: non_constant_identifier_names, must_be_immutable, import_of_legacy_library_into_null_safe

import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoardBirthTimeWidget extends StatelessWidget {
  final OnBoardController onBoardController;
  final VoidCallback? onPressed;
  OnBoardBirthTimeWidget(
      {Key? key, required this.onBoardController, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TimePickerSpinner(
          is24HourMode: true,
          highlightedTextStyle: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: Get.theme.primaryColor),
          normalTextStyle: TextStyle(
              fontSize: 15.sp, fontWeight: FontWeight.bold, color: blackColor),
          onTimeChange: (date) {
            onBoardController.getSelectedTime(date);
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
                value: onBoardController.isTimeOfBirthKnow,
                activeColor: Get.theme.primaryColor,
                checkColor: blackColor,
                onChanged: (bool? value) {
                  onBoardController.updateCheck(value);
                }),
            Text('Dont\'t know my exact time of birth',
                    style: Get.textTheme.titleMedium!.copyWith(fontSize: 12))
                .tr()
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
          child: Text(
                  'Note: Without time of birth, we still can achieve up to 80% accurate predictions',
                  style: Get.textTheme.titleMedium!
                      .copyWith(fontSize: 12, color: Colors.grey))
              .tr(),
        ),
        SizedBox(
          height: 3.h,
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
            onPressed: onPressed,
            child: Text(
              'Next',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.titleMedium!
                  .copyWith(color: Colors.white),
            ).tr(),
          ),
        ),
      ],
    );
  }
}
