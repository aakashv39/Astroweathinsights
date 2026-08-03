import 'dart:developer';

import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

// ignore: must_be_immutable
class OnBoardPhoneWidget extends StatelessWidget {
  final OnBoardController onBoardController;
  final VoidCallback onPressed;
  List<TextInputFormatter>? inputFormatters;
  OnBoardPhoneWidget(
      {Key? key,
      required this.onBoardController,
      required this.onPressed,
      this.inputFormatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Container(
            padding: EdgeInsets.only(left: 3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30.w)),
            ),
            child: InternationalPhoneNumberInput(
              maxLength: 10,
              textFieldController: onBoardController.phoneController,
              inputDecoration:
                  phoneNumberInputDecoration(hitText: 'Phone Number'),
              onInputValidated: (bool value) {
                // log('$value');
              },
              selectorConfig: const SelectorConfig(
                leadingPadding: 2,
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
              ),
              ignoreBlank: false,
              autoValidateMode: AutovalidateMode.disabled,
              selectorTextStyle: const TextStyle(color: Colors.black),
              searchBoxDecoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2.w)),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                  hintText: "Search",
                  hintStyle: const TextStyle(
                    color: Colors.black,
                  )),
              initialValue: PhoneNumber(isoCode: 'IN'),
              formatInput: false,
              keyboardType: const TextInputType.numberWithOptions(
                  signed: true, decimal: false),
              inputBorder: InputBorder.none,
              onSaved: (PhoneNumber number) {
                onBoardController.updateCountryCode(number.dialCode);
              },
              onFieldSubmitted: (value) {
                log('On onFieldSubmitted: $value');
                FocusScope.of(context).unfocus();
              },
              onInputChanged: (PhoneNumber number) {
                onBoardController.updateIsDisable();
                onBoardController.getPhone(number.toString());
                debugPrint("nknaff");
              },
              onSubmit: () {
                log('On onSubmit:');
                FocusScope.of(context).unfocus();
              },
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
              backgroundColor: WidgetStateProperty.all(
                  onBoardController.isValidPhone
                      ? Get.theme.primaryColor
                      : Color.fromARGB(255, 209, 204, 204)),
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
              style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
                  color: onBoardController.isValidPhone
                      ? Colors.white
                      : Color.fromARGB(255, 100, 98, 98)),
            ).tr(),
          ),
        ),
      ],
    );
  }
}
