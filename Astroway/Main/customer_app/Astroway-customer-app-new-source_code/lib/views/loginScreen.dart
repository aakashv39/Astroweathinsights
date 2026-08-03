// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/loginController.dart';
import 'package:AstrowayCustomer/controllers/search_controller.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/utils/couponcode.dart';
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/verifyPhoneScreen.dart';
import 'package:AstrowayCustomer/widget/CanvasStyle/rotatingTagline.dart';
import 'package:AstrowayCustomer/widget/socialloginwidget.dart';
import 'package:AstrowayCustomer/widget/textFieldWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final homeController = Get.find<HomeController>();
  final _initialPhone = PhoneNumber(isoCode: "IN");
  final googleTranslator = GoogleTranslator();
  final loginController = Get.find<LoginController>();
  late String? codeVerifier;

  @override
  void initState() {
    super.initState();
    loginController.phonefocus.addListener(() {
      if (loginController.phonefocus.hasFocus) {
        loginController.getNumberFromHintPlugin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.all(2.w),
            height: 100.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.find<SearchControllerCustom>()
                            .serachTextController
                            .clear();
                        Get.find<SearchControllerCustom>().searchText = '';
                        homeController.myOrders.clear();
                        BottomNavigationController bottomNavigationController =
                            Get.find<BottomNavigationController>();
                        bottomNavigationController.setIndex(0, 0);
                        Get.off(() => BottomNavigationBarScreen(index: 0));
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 5.w, top: 2.h),
                        child: Text(
                          "Skip",
                          textAlign: TextAlign.end,
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp),
                        ).tr(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 6.h),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.w),
                  child: Image.asset("assets/images/splash.png",
                      fit: BoxFit.cover, height: Get.height * 0.14),
                ),
                SizedBox(height: 20),
                Text(
                  "Welcome to ${splashController.appName}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp),
                ),
                SizedBox(height: Get.height * 0.02),
                Container(
                    width: Get.width,
                    margin: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GetBuilder<LoginController>(builder: (loginController) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 1.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 2),
                                  child: SizedBox(
                                    child: Theme(
                                      data: ThemeData(
                                        dialogTheme: DialogThemeData(
                                          contentTextStyle: const TextStyle(
                                              color: Colors.white),
                                          backgroundColor: Colors.grey[800],
                                          surfaceTintColor: Colors.grey[800],
                                        ),
                                      ),
                                      //MOBILE
                                      child: SizedBox(
                                        child: InternationalPhoneNumberInput(
                                          maxLength: 10,
                                          textFieldController:
                                              loginController.phoneController,
                                          focusNode: loginController.phonefocus,
                                          inputDecoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 3.w),
                                              border: InputBorder.none,
                                              hintText: tr('Phone number'),
                                              hintStyle: Get
                                                  .theme.textTheme.bodySmall!
                                                  .copyWith(
                                                fontSize: 15.sp,
                                                color: Colors.grey,
                                              )),
                                          selectorConfig: const SelectorConfig(
                                            trailingSpace: false,
                                            leadingPadding: 2,
                                            selectorType: PhoneInputSelectorType
                                                .BOTTOM_SHEET,
                                          ),
                                          ignoreBlank: false,
                                          autoValidateMode:
                                              AutovalidateMode.disabled,
                                          selectorTextStyle: const TextStyle(
                                              color: Colors.black),
                                          searchBoxDecoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(2.w)),
                                                borderSide: const BorderSide(
                                                    color: Colors.black),
                                              ),
                                              hintText: "Search",
                                              hintStyle: const TextStyle(
                                                color: Colors.black,
                                              )),
                                          initialValue: _initialPhone,
                                          formatInput: false,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(
                                              signed: true, decimal: false),
                                          inputBorder: InputBorder.none,
                                          onSaved: (PhoneNumber number) {
                                            print(
                                                'On Saved: ${number.dialCode}');
                                            loginController.updateCountryCode(
                                                number.dialCode);
                                          },
                                          onFieldSubmitted: (value) {
                                            print(
                                                'On onFieldSubmitted: $value');
                                            loginController.phonefocus
                                                .unfocus();
                                          },
                                          onInputChanged: (PhoneNumber number) {
                                            print(
                                                'countryCode ${number.dialCode}');
                                            loginController.updateCountryCode(
                                                number.dialCode);
                                          },
                                          onSubmit: () {
                                            print('On onSubmit:');
                                            loginController.phonefocus
                                                .unfocus();
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              loginController.phoneController.text.length == 10
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10),
                                          TextFieldWidget(
                                            borderRadius: 10,
                                            controller:
                                                loginController.nameController,
                                            labelText: 'Your Name(Optional)',
                                            focusNode:
                                                loginController.namefocus,
                                            inputFormatter: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp("[a-zA-Z ]"))
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  : SizedBox(),
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() => Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Transform.scale(
                                              scale: 1,
                                              child: Checkbox(
                                                visualDensity: VisualDensity
                                                    .compact, // Removes extra spacing

                                                value: loginController
                                                    .isChecked.value,
                                                onChanged: loginController
                                                    .toggleCheckbox,
                                              ),
                                            ),
                                            loginController.isChecked.value
                                                ? SizedBox.shrink()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 1, right: 0),
                                                    child: Text(
                                                      'Have a referral code?',
                                                      style: Get.theme.textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 16.sp),
                                                    ).tr(),
                                                  ),
                                            loginController.isChecked.value
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            6.0),
                                                    child: CouponInputScreen())
                                                : SizedBox.shrink(),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  bool isValid = loginController.validedPhone();
                                  loginController.phonefocus.unfocus();
                                  loginController.namefocus.unfocus();
                                  if (isValid) {
                                    dynamic phoneno =
                                        loginController.phoneController.text;
                                    print('phone no is $phoneno');
                                    if (phoneno.toString() == '9797979797') {
                                      loginController.timer();
                                      Get.to(
                                        () => VerifyPhoneScreen(
                                          phoneNumber: '9797979797',
                                        ),
                                      );
                                    } else {
                                      await loginController
                                          .checkcontactExistOrNot(
                                              phoneno.toString(),
                                              context,
                                              false);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                      msg: "Invalid Mobile Number",
                                    );
                                  }
                                },
                                child: Container(
                                  height: 45,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        'SEND OTP',
                                        style: TextStyle(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ).tr(),
                                      Image.asset(
                                        'assets/images/arrow_left.png',
                                        color: Colors.white,
                                        width: 20,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: Get.height * 0.02),
                              SocialLoginButtons(),
                              SizedBox(height: 5.h),
                              Column(
                                children: [
                                  Text(
                                    "Want to Know? Only on Astroway",
                                    textAlign: TextAlign.center,
                                    style: Get.theme.textTheme.bodyMedium!
                                        .copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  RotatingTagline(),
                                ],
                              ),
                            ],
                          );
                        }),
                      ],
                    )),
                Expanded(child: SizedBox()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      children: [
                        const TextSpan(
                            text: 'By signing up, you agree to our '),
                        TextSpan(
                          text: 'Terms of use',
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: Get.theme.primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(termsconditionUrl));
                            },
                        ),
                        const TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: Get.theme.textTheme.bodyMedium!.copyWith(
                            decoration: TextDecoration.underline,
                            decorationColor: Get.theme.primaryColor,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: Get.theme.primaryColor,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              launchUrl(Uri.parse(privacyUrl));
                            },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.02),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
