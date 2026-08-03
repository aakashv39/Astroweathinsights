// http://127.0.0.1:8000/verify/d6b72654-d49a-4897-904e-a77c9384e8ef/// ignore_for_file: deprecated_member_use

// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/loginScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:sms_autofill/sms_autofill.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String phoneNumber;
  String? otp;
  VerifyPhoneScreen({Key? key, required this.phoneNumber, this.otp})
      : super(key: key);

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final loginController = Get.find<LoginController>();
  final pinEditingControllerlogin = TextEditingController(text: '');
  final focusnode = FocusNode();
  final _autoFill = SmsAutoFill();

  @override
  void initState() {
    focusnode.requestFocus();

    originalOtp();
    super.initState();
  }

  originalOtp() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      loginController.originalOtp = widget.otp.toString();
      loginController.update();
    });
  }

  Future<void> getAppSignature() async {
    final signature = await SmsAutoFill().getAppSignature;
    print("SMS auto read app Signature: ${signature}");
    listenForCode();
  }

  void listenForCode() {
    _autoFill.code.listen((code) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loginController.capturedOTP = code;
        loginController.update();
      });
      print("auto read and updated ${loginController.capturedOTP}");
    });
    if (loginController.capturedOTP != "") {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        loginController.smsCode = loginController.capturedOTP;
        pinEditingControllerlogin.text = loginController.capturedOTP;
        loginController.update();
      });
    }
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        loginController.maxSecond = 61;
        loginController.time!.cancel();
        loginController.update();
        Get.off(() => LoginScreen());
        return true;
      },
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: AppBar(
          title: Text('Verify Phone').tr(),
          leading: IconButton(
            onPressed: () {
              Get.off(() => LoginScreen());
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: SizedBox(
            width: Get.width - Get.width * 0.1,
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    'Enter Verifiaction Code',
                    style: Get.theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Text(
                    'OTP Send to ',
                    style: TextStyle(color: Colors.green),
                  ).tr(
                    args: [
                      tr(
                        '${loginController.countryCode}-${widget.phoneNumber}',
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.05),
                  PinInputTextField(
                    focusNode: focusnode,
                    pinLength: 6,
                    decoration: BoxLooseDecoration(
                      bgColorBuilder: PinListenColorBuilder(
                        Get.theme.primaryColor.withOpacity(0.1),
                        Colors.white,
                      ),
                      strokeColorBuilder: PinListenColorBuilder(
                        Get.theme.primaryColor,
                        Colors.grey.shade400,
                      ),
                    ),
                    controller: pinEditingControllerlogin,
                    textInputAction: TextInputAction.done,
                    enabled: true,
                    keyboardType: TextInputType.number,
                    onSubmit: (pin) {
                      loginController.smsCode = pin;
                      loginController.update();
                    },
                    onChanged: (pin) {
                      loginController.smsCode = pin;
                      loginController.update();
                    },
                    enableInteractiveSelection: false,
                  ),
                  SizedBox(height: Get.height * 0.05),
                  SizedBox(
                    width: double.infinity,
                    child: GetBuilder<LoginController>(
                      builder: (loginController) {
                        return ElevatedButton(
                          onPressed: () async {
                            if (pinEditingControllerlogin.text.length != 6 ||
                                pinEditingControllerlogin.text.isEmpty) {
                              global.showToast(
                                message: tr("All field required"),
                                textColor: Colors.white,
                                bgColor: Colors.red,
                              );
                              return;
                            }
                            if (loginController.maxSecond <= 0) {
                              global.showToast(
                                message: tr("OTP expired. Please resend OTP."),
                                textColor: Colors.white,
                                bgColor: Colors.red,
                              );
                              return;
                            }
                            try {
                              global.showOnlyLoaderDialog(context);

                              print(
                                  "original  otp ${loginController.originalOtp} and ${loginController.smsCode}");
                              if (widget.phoneNumber == "9797979797") {
                                log(
                                  'otp matched for default otp is ${loginController.smsCode}',
                                );
                                if (loginController.smsCode == '111111') {
                                  await loginController.loginAndSignupUser(
                                    9797979797,
                                    "",
                                    "India",
                                    loginController.nameController.text,
                                  );
                                } else {
                                  global.hideLoader();
                                  global.showToast(
                                    message: "OTP INVALID",
                                    textColor: Colors.white,
                                    bgColor: Colors.red,
                                  );
                                }
                              } else if (loginController.originalOtp
                                      .toString() ==
                                  loginController.smsCode.toString()) {
                                await loginController.loginAndSignupUser(
                                  int.parse(widget.phoneNumber),
                                  "",
                                  "India",
                                  loginController.nameController.text,
                                );
                              } else {
                                global.hideLoader();
                                global.showToast(
                                  message: "OTP INVALID",
                                  textColor: Colors.white,
                                  bgColor: Colors.red,
                                );
                              }
                            } catch (e) {
                              global.hideLoader();
                              global.showToast(
                                message: "OTP INVALID",
                                textColor: Colors.white,
                                bgColor: Colors.red,
                              );
                              print("Exception " + e.toString());
                            }
                          },
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(color: Colors.white),
                          ).tr(),
                          style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            padding: WidgetStateProperty.all(
                              EdgeInsets.all(12),
                            ),
                            backgroundColor: WidgetStateProperty.all(
                              Get.theme.primaryColor,
                            ),
                            textStyle: WidgetStateProperty.all(
                              TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  GetBuilder<LoginController>(
                    builder: (c) {
                      return SizedBox(
                        child: loginController.maxSecond != 0
                            ? RichText(
                                text: TextSpan(
                                  style:
                                      Get.theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: tr('Resend OTP Available in '),
                                    ),
                                    TextSpan(
                                      text: '${loginController.maxSecond} s',
                                      style: TextStyle(
                                        color: loginController.maxSecond < 20
                                            ? Colors.redAccent
                                            : Colors.green,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : RichText(
                                text: TextSpan(
                                  style:
                                      Get.theme.textTheme.bodyMedium!.copyWith(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'Did not receive the code? ',
                                    ),
                                    TextSpan(
                                      text: 'Resend',
                                      style: TextStyle(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          loginController.maxSecond = 60;
                                          pinEditingControllerlogin.text = '';
                                          loginController.update();
                                          loginController.timer();
                                          loginController.phoneController.text =
                                              widget.phoneNumber;
                                          await loginController
                                              .checkcontactExistOrNot(
                                            widget.phoneNumber.toString(),
                                            context,
                                            true,
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                      );
                    },
                  ),
                  SizedBox(height: 2.h),

                  // Remove this code for Client
                  // GetBuilder<LoginController>(builder: (loginController) {
                  //   return RichText(
                  //     text: TextSpan(
                  //       children: [
                  //         TextSpan(
                  //           text: "Use this OTP to Login: ",
                  //           style: TextStyle(
                  //             color: Colors.black, // normal text color
                  //             fontWeight: FontWeight.w500,
                  //             fontSize: 15.sp,
                  //           ),
                  //         ),
                  //         TextSpan(
                  //           text: loginController.otp.toString(), // your OTP
                  //           style: TextStyle(
                  //             color: Colors.green, // OTP color
                  //             fontWeight: FontWeight.bold,
                  //             fontSize: 15.sp,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   );
                  // })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
