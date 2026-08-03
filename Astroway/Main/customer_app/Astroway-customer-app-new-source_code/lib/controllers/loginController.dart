import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/model/login_model.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/views/loginScreen.dart';
import 'package:AstrowayCustomer/views/verifyPhoneScreen.dart'
    show VerifyPhoneScreen;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:phone_number_hint/phone_number_hint.dart';
import '../model/device_info_login_model.dart';
import '../views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class LoginController extends GetxController {
  late TextEditingController phoneController;
  late TextEditingController nameController;
  final phoneNumberHintPlugin = PhoneNumberHint();
  final phonefocus = FocusNode();
  final namefocus = FocusNode();
  SplashController splashController = Get.find<SplashController>();
  String validationId = "";
  double second = 0;
  var maxSecond;
  String countryCode = "+91";
  Timer? time;
  Timer? time2;
  String smsCode = "";
  String capturedOTP = "";
  String? errorText;
  APIHelper apiHelper = APIHelper();
  String originalOtp = '';
  var flag = '🇮🇳';
  final couponController = TextEditingController();
  bool? isCouponValid;
  bool isButtonVisible = false;
  dynamic couponcode = '';
  var isChecked = false.obs;

  // Method to toggle the state
  void toggleCheckbox(bool? value) {
    isChecked.value = value ?? false;
  }

  Future<void> getNumberFromHintPlugin() async {
    try {
      print('triger the getNumberFromHintPlugin');
      final result = await phoneNumberHintPlugin.requestHint() ?? '';
      if (result.isNotEmpty) {
        phoneController.text =
            result.replaceFirst(RegExp(r'^\+?\d{1,3}(?=\d{10}$)'), '');
        print('Phone Number form hint: $result');
      }
    } catch (e) {
      debugPrint('Error in getNumberFromHintPlugin(): $e');
    } finally {
      update();
    }
  }

  void applyCoupon() async {
    global.showOnlyLoaderDialog(Get.context);
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper
            .checkReferalcodestatus(couponController.text.trim())
            .then((result) async {
          global.hideLoader();
          print('return referal status ${result}');
          if (result.status == "200") {
            isCouponValid = true; // Valid coupon
            couponcode = result.recordList.referralToken;
            print('added referal code is ${couponcode}');
            update();
          } else {
            isCouponValid = false; // Invalid coupon
            update();
          }
        });
      }
    });
  }

  @override
  void onInit() {
    phoneController = TextEditingController();
    nameController = TextEditingController();
    super.onInit();
  }

  var loaderVisibility = true;
  final TextEditingController urlTextContoller = TextEditingController();
  Map dataResponse = {};
  String phoneOrEmail = '';
  String otp = '';
  bool isInitIos = false;

  timer() {
    maxSecond = 60;
    update();
    print("maxSecond:- ${maxSecond}");
    time = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (maxSecond > 0) {
        maxSecond--;
        update();
      } else {
        time!.cancel();
      }
    });
  }

  updateCountryCode(value) {
    countryCode = value.toString();
    print('countryCode -> $countryCode');
    update();
  }

  bool countryvalidator = false;

  bool validedPhone() {
    String pattern =
        r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$';
    RegExp regExp = new RegExp(pattern);
    if (phoneController.text.length == 0) {
      errorText = 'Please enter mobile number';
      update();
      return false;
    } else if (!regExp.hasMatch(phoneController.text)) {
      errorText = 'Please enter valid mobile number';
      update();
      return false;
    } else {
      return true;
    }
  }

  checkcontactExistOrNot(
    String contactno,
    BuildContext context,
    bool resendOtp,
  ) async {
    try {
      global.showOnlyLoaderDialog(Get.context);
      await apiHelper.checkContact(contactno, countryCode).then((response) {
        dynamic rspnse1 = json.decode(response.body)['status'];
        print('checkcontactExistOrNot response status ${rspnse1}');
        // String msg = jsonDecode(response.body)['message'];
        if (rspnse1 == 200) {
          print('${!resendOtp}');
          if (!resendOtp) {
            timer();
            Get.to(
              () => VerifyPhoneScreen(
                phoneNumber: phoneController.text,
                otp: jsonDecode(response.body)['otp'].toString(),
              ),
            );
          } else {
            global.hideLoader();
            originalOtp = jsonDecode(response.body)['otp'].toString();
            print("${jsonDecode(response.body)['otp'].toString()}");
            update();
            print("${originalOtp}");
            Fluttertoast.showToast(
              msg: "Otp Send to:- ${phoneController.text}",
            );
            update();
          }
        } else if (rspnse1 == 400) {
          var random = Random();
          int sixDigit = 100000 + random.nextInt(900000);
          if (!resendOtp) {
            timer();
            Get.to(
              () => VerifyPhoneScreen(
                phoneNumber: phoneController.text,
                otp: sixDigit.toString(),
              ),
            );
          } else {
            global.hideLoader();
            otp = sixDigit.toString().toString();
          }
        }
      });
    } catch (e) {
      print('Exception in checkcontactExistOrNot : - ${e.toString()}');
    }
  }

  loginAndSignupUser(
    int? phoneNumber,
    String email,
    String country,
    String? name,
  ) async {
    try {
      debugPrint("User name Send to Api $name");
      await global.getDeviceData();
      LoginModel loginModel = LoginModel();
      email.toString() != ""
          ? loginModel.contactNo = null
          : loginModel.contactNo = phoneNumber.toString();
      email.toString() == "" ? null : loginModel.email = email.toString();
      name.toString() != ""
          ? loginModel.username = name
          : loginModel.username = "";
      loginModel.countryCode = countryCode.toString();
      loginModel.country = country.toString();
      loginModel.deviceInfo = DeviceInfoLoginModel();
      loginModel.deviceInfo?.appId = global.appId;
      loginModel.deviceInfo?.appVersion = global.appVersion;
      loginModel.deviceInfo?.deviceId = global.deviceId;
      loginModel.deviceInfo?.deviceLocation = global.deviceLocation ?? "";
      loginModel.deviceInfo?.deviceManufacturer = global.deviceManufacturer;
      loginModel.deviceInfo?.deviceModel = global.deviceManufacturer;
      loginModel.deviceInfo?.fcmToken = global.fcmToken;
      loginModel.deviceInfo?.appVersion = global.appVersion;
      loginModel.deviceInfo?.onesignalSubscriptionID =
          OneSignal.User.pushSubscription.id;
      loginModel.referalCode = couponcode.toString();

      await apiHelper.loginSignUp(loginModel).then((result) async {
        if (result.status == "200") {
          var recordId = result.recordList["recordList"];
          var token = result.recordList["token"];
          global.myToken = token;
          var tokenType = result.recordList["token_type"];
          final isFreeChat = result.recordList['is_freechat'];
          final defaultCallTime = result.recordList['defaultCallTime'];
          await global.saveCurrentUser(recordId["id"], token, tokenType);
          await global.getCurrentUser();
          print('token $token');
          print('tokenType $tokenType');
          Get.find<BottomNavigationController>().astrologerList.clear();
          Get.find<BottomNavigationController>().update();

          // ------Save Locally------------
          print("isfreetime is  $isFreeChat");
          print("isfreeChat is  $defaultCallTime");

          await global.sp!.setBool("is_freechat", isFreeChat);

          await global.sp!.setInt('defaultTime', defaultCallTime);

          await splashController.getCurrentUserData();
          await Get.find<BottomNavigationController>().getAstrologerList(
            isLazyLoading: true,
          );
          await Get.find<HomeController>().gethistorydetails();

          time?.cancel();
          update();
          debugPrint("free chat value $isFreeChat");
          Get.find<BottomNavigationController>().setIndex(0, 0);
          Get.off(() => BottomNavigationBarScreen(index: 0));
          // if (isFreeChat) {
          //   Get.offAll(
          //     () => FreeChatOnBoardscreen(),
          //     transition: Transition.rightToLeft,
          //   );
          // } else {
          //   Get.find<BottomNavigationController>().setIndex(0, 0);
          //   Get.off(() => BottomNavigationBarScreen(index: 0));
          // }
        } else {
          global.hideLoader();
          Get.off(() => LoginScreen());
        }
      });
    } catch (e) {
      global.hideLoader();
      print("Exception in loginAndSignupUser():-" + e.toString());
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    global.showOnlyLoaderDialog(Get.context);
    // Create GoogleSignIn instance
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Force sign out to show the account picker every time
    await googleSignIn.signOut();

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) throw Exception('Sign-in cancelled by user.');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    global.hideLoader();

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
