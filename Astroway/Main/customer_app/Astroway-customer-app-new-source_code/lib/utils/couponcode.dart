// ignore_for_file: library_private_types_in_public_api

import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CouponInputScreen extends StatefulWidget {
  const CouponInputScreen({super.key});

  @override
  _CouponInputScreenState createState() => _CouponInputScreenState();
}

class _CouponInputScreenState extends State<CouponInputScreen> {
  final logincontroller = Get.find<LoginController>();
  @override
  void initState() {
    super.initState();

    logincontroller.couponController.addListener(() {
      String text = logincontroller.couponController.text;
      String upperText = text.toUpperCase();
      if (text != upperText) {
        logincontroller.couponController.value = TextEditingValue(
          text: upperText,
          selection: TextSelection.collapsed(offset: upperText.length),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DottedBorder(
            borderType: BorderType.RRect,
            radius: Radius.circular(10),
            dashPattern: [6, 3],
            strokeWidth: 1.5,
            child: SizedBox(
              width: 50.w,
              height: 4.h,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                controller: logincontroller.couponController,
                onChanged: (value) {
                  value.length >= 4
                      ? logincontroller.isButtonVisible = true
                      : logincontroller.isButtonVisible = false;
                  logincontroller.update();
                },
                decoration: InputDecoration(
                  
                  isDense: true,
                  border: InputBorder.none,
                  fillColor: Colors.blue.shade50,
                  filled: true,
                  labelText: tr('Referal Code'),
                  labelStyle: Get.theme.textTheme.bodySmall!.copyWith(
                    fontSize: 16.sp,
                    fontFamily: "poppins_regular",
                    color: Colors.grey,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  suffixIcon: GetBuilder<LoginController>(
                    builder: (logincontroller) => IconButton(
                      icon: logincontroller.isCouponValid == null
                          ? const Icon(Icons.clear)
                          : Icon(
                              logincontroller.isCouponValid!
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: logincontroller.isCouponValid!
                                  ? Colors.green
                                  : Colors.red,
                            ),
                      onPressed: () {
                        logincontroller.isButtonVisible = false;
                        logincontroller.couponController.clear();
                        logincontroller.isCouponValid = null;
                        logincontroller.update();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          GetBuilder<LoginController>(
            builder: (logincontroller) => logincontroller.isButtonVisible
                ? ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all<Color>(
                          Get.theme.primaryColor),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      padding: WidgetStateProperty.all<EdgeInsets>(
                        const EdgeInsets.symmetric(
                          horizontal: 10.0,
                          vertical: 10.0,
                        ),
                      ),
                    ),
                    onPressed: logincontroller.applyCoupon,
                    child: logincontroller.isCouponValid == null
                        ? Text(
                            'Apply',
                            style: Get.theme.textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                                fontFamily: "poppins_regular"),
                          ).tr()
                        : Text(
                            logincontroller.isCouponValid!
                                ? 'Applied!'
                                : 'Apply',
                            style: Get.theme.textTheme.bodySmall!.copyWith(
                                color: Colors.white,
                                fontFamily: "poppins_regular")),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }
}
