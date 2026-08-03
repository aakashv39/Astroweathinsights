import 'package:AstrowayCustomer/controllers/onboardController.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class OnBoardNameWidget extends StatelessWidget {
  final OnBoardController onBoardController;
  final VoidCallback onPressed;
  List<TextInputFormatter>? inputFormatters;
  OnBoardNameWidget(
      {Key? key,
      required this.onBoardController,
      required this.onPressed,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100.w),
          ),
          child: TextField(
            inputFormatters: inputFormatters,
            controller: onBoardController.nameController,
            onChanged: (text) {
              onBoardController.updateIsDisable();
              onBoardController.getName(text);
            },
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.w),
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
                hintText: 'Your Name',
                hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
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
              backgroundColor: WidgetStateProperty.all(
                  onBoardController.isDisable
                      ? Color.fromARGB(255, 209, 204, 204)
                      : Get.theme.primaryColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.w),
                    side: BorderSide.none),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              'Continue',
              textAlign: TextAlign.center,
              style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
                  color: onBoardController.isDisable
                      ? Color.fromARGB(255, 100, 98, 98)
                      : Colors.white),
            ).tr(),
          ),
        ),
      ],
    );
  }
}
