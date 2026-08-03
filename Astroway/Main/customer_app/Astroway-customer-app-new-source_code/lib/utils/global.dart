// ignore_for_file: unused_local_variable, unnecessary_null_comparison, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/model/current_user_model.dart';
import 'package:AstrowayCustomer/model/device_info_login_model.dart';
import 'package:AstrowayCustomer/model/hororscopeSignModel.dart';
import 'package:AstrowayCustomer/model/systemFlagNameListModel.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/utils/translationcache.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../controllers/networkController.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../views/loginScreen.dart';
import 'package:translator/translator.dart';
import '../views/paymentInformationScreen.dart';

int? chatStartedAt;
int? callStartedAt;
int? VideocallStartedAt;
int? isCallOrChat = 0;
String currentLocation = '';
SharedPreferences? sp;
String? currencyISOCode3;
dynamic generalPayload;
SharedPreferences? spLanguage;
String timeFormat = '24';
String? appDeviceId;
String languageCode = 'en';
String? mapBoxAPIKey;
APIHelper apiHelper = APIHelper();
bool isRTL = false;
String status = "WAITING";
CurrentUserModel? currentUserPayment;
CurrentUserModel user = CurrentUserModel();
Color toastBackGoundColor = Colors.green;
Color textColor = Colors.black;
final networkController = Get.put((NetworkController()));
final splashController = Get.find<SplashController>();
final formatter = DateFormat("dd MMM yy, hh:mm a");
int iscomingFrom = 0;
int? originalChatStartedAt = 0;
String myAudioRecordingUid = '2299887766';
String myVideoRecordingUid = '2299887798';
bool ischatended = false;
String agoraChannelName = ""; //valid 24hr
String agoraToken = "";
String channelName = "Astropro";
String agoraLiveToken = "";
String liveChannelName = "astrowayLive";
String agoraChatUserId = "astrowayLive";
String chatChannelName = "astrowayLive";
String agoraChatToken = "";
String encodedString = "&&";
Color coursorColor = Color(0xFF757575);
int? currentUserId;
String agoraResourceId = "";
String agoraResourceId2 = "";
String agoraSid1 = "";
String agoraSid2 = "";
String? googleAPIKey;
String lat = "21.124857";
String lng = "73.112610";
var nativeAndroidPlatform = const MethodChannel('nativeAndroid');
int? localUid;
int? localLiveUid;
int? localLiveUid2;
bool isHost = false;
int totallistCount = 0;
bool? isEndCallApiCalled = false;
String playstoreurl = '';
bool readMessage = true;
dynamic couponmycode;
bool freeRequestMinimum = false;
int amountisfreechat = 0;
int amountisfreecall = 0;
bool isInAssistantScreen = false;

Future<String> playstoreUrl() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String packageName = packageInfo.packageName;
  String playstoreUrl =
      "https://play.google.com/store/apps/details?id=$packageName";
  return "$playstoreUrl";
}

Future<void> refreshUserFCM() async {
  print('refreshUserFCM -> ${currentUserId.toString()}');
  await getDeviceData();
  if (global.fcmToken!.isNotEmpty) {
    DeviceInfoLoginModel deviceInfo = DeviceInfoLoginModel();
    deviceInfo.userId = currentUserId.toString();
    deviceInfo.appId = global.appId;
    deviceInfo.appVersion = global.appVersion;
    deviceInfo.deviceId = global.deviceId;
    deviceInfo.deviceLocation = global.deviceLocation ?? "";
    deviceInfo.deviceManufacturer = global.deviceManufacturer;
    deviceInfo.deviceModel = global.deviceManufacturer;
    deviceInfo.fcmToken = global.fcmToken;
    deviceInfo.appVersion = global.appVersion;
    deviceInfo.onesignalSubscriptionID = OneSignal.User.pushSubscription.id;
    await apiHelper.refreshUserFCM(deviceInfo.toJson());
  } else {
    log("FCM data Already Up to Date");
    return;
  }
}

// ADD THIS METHOD TO CHECK PERMISSIONS
Future<bool> checkPermissions() async {
  try {
    final cameraStatus = await Permission.camera.status;
    final micStatus = await Permission.microphone.status;

    if (!cameraStatus.isGranted) {
      final requested = await Permission.camera.request();
      if (!requested.isGranted) {
        return false;
      }
    }

    if (!micStatus.isGranted) {
      final requested = await Permission.microphone.request();
      if (!requested.isGranted) {
        return false;
      }
    }

    return true;
  } catch (e) {
    log('Permission check error: $e');
    return false;
  }
}

void debugRoleState() {
  final controller = ZegoUIKitPrebuiltLiveStreamingController();
  // Check current role state
  final isCoHost = controller.coHost.audienceLocalConnectStateNotifier.value ==
      ZegoLiveStreamingAudienceConnectState.connected;

  log('🔍 DEBUG ROLE STATE:');
  log('   - Is Co-host: $isCoHost');
  log('   - Current UI: ${isCoHost ? "Co-host UI" : "Audience UI"}');
  log('   - Config Role: audience');

  // Check what buttons should be showing
  if (isCoHost) {
    log('⚠️  PROBLEM: Internal state says co-host, but showing audience UI!');
  } else {
    log('✅ Correct: Internal state matches UI (audience)');
  }
}

Widget buildTranslatedText(
  String text,
  TextStyle? style, {
  bool showloading = true,
  TextAlign? textAlignment,
}) {
  final googleTranslator = GoogleTranslator();
  final cache = TranslationCache();
  String cacheKey(String text, String langCode) => '$text|$langCode';
  return FutureBuilder<String>(
    future: (() async {
      final langCode = Get.locale!.languageCode;
      final key = cacheKey(text, langCode);
      final cachedTranslation = await cache.getTranslation(key);
      if (cachedTranslation != null) {
        return cachedTranslation;
      }
      final translation = await googleTranslator.translate(text, to: langCode);
      await cache.saveTranslation(key, translation.text);
      return translation.text;
    })(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting && showloading) {
        return Center(
          child: SizedBox(
            height: 16.0,
            width: 16.0,
            child: const CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text(
          text,
          style: style ??
              Get.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
          textAlign: textAlignment,
        );
      } else {
        return Text(
          snapshot.data ?? "No translation available",
          style: style ??
              Get.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
          textAlign: textAlignment,
        );
      }
    },
  );
}

Future<bool> getPermissions() async {
  if (Platform.isIOS) return true;
  await Permission.camera.request();
  await Permission.microphone.request();

  while ((await Permission.camera.isDenied)) {
    await Permission.camera.request();
  }
  while ((await Permission.microphone.isDenied)) {
    await Permission.microphone.request();
  }

  while ((await Permission.bluetoothConnect.isDenied)) {
    await Permission.bluetoothConnect.request();
  }
  return true;
}

String formatRating(int rating) {
  if (rating >= 1000) {
    return '${(rating / 1000).toStringAsFixed(0)}K';
  } else {
    return rating.toString();
  }
}

Future<void> callOnFcmApiSendPushNotifications({
  List<String?>? fcmTokem,
  String? subTitle,
  String? title,
  String? name,
  String? channelname,
  String? profile,
  String? waitListId,
  String? liveChatSUserName,
  String? sessionType,
  String? chatId,
  String? timeInInt,
  String? joinUserName,
  String? joinUserProfile,
}) async {
  var accountCredentials = await loadCredentials();
  var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  var client = http.Client();
  try {
    var credentials = await obtainAccessCredentialsViaServiceAccount(
        ServiceAccountCredentials.fromJson(accountCredentials), scopes, client);
    if (credentials == null) {
      log('Failed to obtain credentials');
      return;
    }
    final headers = {
      'content-type': 'application/json',
      'Authorization': 'Bearer ${credentials.accessToken.data}'
    };
    log("GENERATED TOKEN IS-> ${credentials.accessToken.data}");
    final data = {
      "message": {
        "token": fcmTokem![0].toString(),
        "notification": {"body": subTitle, "title": title},
        "data": {
          "name": name,
          "channelName": channelname,
          "profile": profile,
          "waitListId": waitListId,
          "liveChatSUserName": liveChatSUserName,
          "sessionType": sessionType,
          "chatId": chatId,
          "timeInInt": timeInInt,
          "joinUserName": joinUserName,
          "joinUserProfile": joinUserProfile
        },
        "android": {
          "notification": {"click_action": "android.intent.action.MAIN"}
        }
      }
    };
    final url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/${global.getSystemFlagValue(global.systemFlagNameList.firebasePrjectID)}/messages:send');
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(data),
    );
    log('noti response ${response.body}');
    if (response.statusCode == 200) {
      log('Notification sent successfully');
    } else {
      log('Failed to send notification: ${response.body}');
    }
  } catch (e) {
    print('Error sending notification: $e');
  } finally {
    client.close();
  }
}

Future<void> sendOneSignalNotification({
  required String playerId,
  required String title,
  bool isSilent = false,
}) async {
  const String onesignalApiUrl = "https://onesignal.com/api/v1/notifications";
  String onesignalAppId = OnesignalID;
  String onesignalApiKey = global.getSystemFlagValueForLogin(
      global.systemFlagNameList.oneSignalRestApiKey);
  final headers = {
    "Content-Type": "application/json; charset=utf-8",
    "Authorization": "Basic $onesignalApiKey",
  };
  try {
    final response = await http.post(
      Uri.parse(onesignalApiUrl),
      headers: headers,
      body: json.encode({
        "app_id": onesignalAppId,
        "include_player_ids": [playerId],
        // "content_available": false, //for silent
        if (!isSilent) ...{
          "headings": {"en": title}, // Notification title
          "contents": {"en": title}, // Notification message
        },
        "data": {
          "title": title,
          // "notificationId":122
        },
        "ttl": 30,
      }),
    );
    log('onesignal status is-> ${response.statusCode}');
    print('onesignal repsone is-> ${response.body}');
    if (response.statusCode == 200) {
      log("Notification sent successfully: ${response.body}");
    } else {
      log("Failed to send onesignal notification: ${response.body}");
    }
  } catch (e) {
    log("Error sending OneSignal notification: $e");
  }
}

Future<Map<String, dynamic>> loadCredentials() async {
  String credentialsPath = 'lib/utils/noti_service.json';
  String content = await rootBundle.loadString(credentialsPath);
  return json.decode(content);
}

Future<void> createAndShareLinkForHistoryChatCall() async {
  try {
    await global.commonShareMethod(
      title:
          "${global.getSystemFlagValue(global.systemFlagNameList.appName)}. You should also try and see your future, and accurate pridictions at ${global.getSystemFlagValue(global.systemFlagNameList.appName)} First call is free Hurry up!\n\n${splashController.appShareLinkForLiveSreaming}",
    );
  } catch (e) {
    print("Exception - global.dart - referAndEarn():" + e.toString());
  }
}

Future<void> commonShareMethod({
  required String title,
  String? subject,
}) async {
  try {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final packageName = packageInfo.packageName;
    final playstoreLink =
        "https://play.google.com/store/apps/details?id=$packageName";

    await Share.share(
      "Download our app:\n$playstoreLink\n",
      subject: "$title",
    );
  } catch (e) {
    print("Exception - global.dart - commonShareMethod(): $e");
  }
}

String buildImageUrl(String? path) {
  const defaultImage = "https://www.w3schools.com/howto/img_avatar.png";
  // String defaultImage = "${websiteUrl}/build/assets/images/person.png";

//https://astro.diploy.in/build/assets/images/person.png

  if (path == null) {
    return defaultImage;
  }
  final cleanedPath = path.trim();
  if (cleanedPath.isEmpty || cleanedPath.length < 10) {
    return defaultImage;
  }
  if (cleanedPath == websiteUrl ||
      cleanedPath == "$websiteUrl/" ||
      cleanedPath == "$websiteUrl/api/" ||
      cleanedPath.endsWith("/api")) {
    return defaultImage;
  }
  if (cleanedPath.startsWith("http://") || cleanedPath.startsWith("https://")) {
    return cleanedPath;
  }
  return "$websiteUrl/$cleanedPath";
}

abstract class DateFormatter {
  static String? formatDate(DateTime timestamp) {
    if (timestamp == null) {
      return null;
    }
    String date =
        "${timestamp.day} ${DateFormat('MMMM').format(timestamp)} ${timestamp.year}";
    return date;
  }

  static dynamic fromDateTimeToJson(DateTime date) {
    if (date == null) return null;

    return date.toUtc();
  }

  static DateTime? toDateTime(Timestamp value) {
    if (value == null) return null;

    return value.toDate();
  }
}

final showInapploader = SpinKitCircle(
  size: 70,
  itemBuilder: (BuildContext context, int index) {
    return DecoratedBox(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color:
              index.isEven ? const Color(0xFF1E00FF) : const Color(0xFFFF1100)),
    );
  },
);

void showOnlyLoaderDialog(context) {
  showDialog(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: EdgeInsets.zero,
        child: Center(child: showInapploader),
      );
    },
  );
}

void showMinimumBalancePopup(
  BuildContext context,
  String minBalance,
  String astrologer,
  List amounts,
  String screenType, {
  bool isForGift = false,
  String minimumMin = "5",
}) {
  Get.bottomSheet(
    Container(
      height: 43.h,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        children: [
          // Top drag handle
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Container(
              height: 0.5.h,
              width: 10.w,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Header & Close Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Low Balance",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.redAccent,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.grey.shade200,
                    child: Icon(Icons.close, size: 18, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Message Section
          if (!isForGift && minBalance != '')
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(10),
                child: global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.walletType) ==
                        "Wallet"
                    ? Text(
                        'Minimum balance of $minimumMin minutes (${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start chat with $astrologer.',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade700,
                          fontSize: 14.sp,
                        ),
                      ).tr()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Minimum Coins of $minimumMin minutes (${minBalance.toString().split(".").first}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red.shade700,
                                  fontSize: 14.sp,
                                ),
                              ).tr(),
                              SizedBox(width: 0.4.w),
                              Image.network(
                                global.getSystemFlagValueForLogin(
                                    global.systemFlagNameList.coinIcon),
                                height: 1.5.h,
                              ),
                              Text(") is required",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red.shade700,
                                    fontSize: 14.sp,
                                  )),
                            ],
                          ),
                          Text(
                            "to $screenType with $astrologer",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade700,
                              fontSize: 14.sp,
                            ),
                          ).tr(),
                        ],
                      ),
              ),
            ),

          SizedBox(height: 1.5.h),

          // Recharge Header
          Text(
            "Recharge Now",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
              color: Colors.black87,
            ),
          ).tr(),

          if (!isForGift)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_rounded,
                      color: Colors.orangeAccent, size: 16),
                  SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      "Tip: 90% users recharge for 10 mins or more.",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.black54,
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ),

          SizedBox(height: 1.h),

          // Amount Grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 3.8 / 2.3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 6,
                ),
                physics: NeverScrollableScrollPhysics(),
                itemCount: amounts.length,
                itemBuilder: (context, index) {
                  final walletType = global.getSystemFlagValueForLogin(
                      global.systemFlagNameList.walletType);

                  return GestureDetector(
                    onTap: () {
                      if (walletType == "Wallet") {
                        Get.to(() => PaymentInformationScreen(
                              flag: 0,
                              amount: double.parse(amounts[index]),
                            ));
                      } else {
                        Get.to(() => PaymentInformationScreen(
                              amount: global.user.countryCode == "+91"
                                  ? double.parse(amounts[index].toString()) /
                                      double.parse(global
                                          .getSystemFlagValueForLogin(global
                                              .systemFlagNameList.InrToCoin)
                                          .toString())
                                  : double.parse(amounts[index].toString()) /
                                      double.parse(global
                                          .getSystemFlagValueForLogin(global
                                              .systemFlagNameList.UsdToCoin)
                                          .toString()),
                            ));
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blueAccent.withOpacity(0.15),
                            Colors.purpleAccent.withOpacity(0.15)
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade200,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: Center(
                        child: walletType == "Wallet"
                            ? Text(
                                '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${amounts[index]}',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueAccent,
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${amounts[index]}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                  ),
                                  SizedBox(width: 0.4.w),
                                  Image.network(
                                    global.getSystemFlagValueForLogin(
                                        global.systemFlagNameList.coinIcon),
                                    height: 1.3.h,
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
    barrierColor: Colors.black.withOpacity(0.7),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    elevation: 0,
  );
}

String maskMobileNumber(String number) {
  if (number.length < 4) return number;
  String start = number.substring(0, 2);
  String end = number.substring(number.length - 2);
  String stars = '*' * (number.length - 4);
  return '$start$stars$end';
}

showSnackBar(String title, String text, {Duration? duration}) {
  return Get.snackbar(title, text,
      dismissDirection: DismissDirection.horizontal,
      showProgressIndicator: true,
      isDismissible: true,
      duration: duration != null ? duration : Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM);
}

void hideLoader() {
  Get.back();
}

Future<bool> checkBody() async {
  bool result;
  try {
    await networkController.initConnectivity();
    if (networkController.connectionStatus.value != 0) {
      result = true;
    } else {
      print(networkController.connectionStatus.value);
      Get.snackbar(
        'Warning',
        'No internet connection',
        snackPosition: SnackPosition.BOTTOM,
        messageText: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.signal_wifi_off,
              color: Colors.white,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                ),
                child: Text(
                  'No internet available',
                  textAlign: TextAlign.start,
                ).tr(),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (networkController.connectionStatus.value != 0) {
                  Get.back();
                }
              },
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(color: Colors.white),
                height: 30,
                width: 55,
                child: Center(
                  child: Text(
                    'Retry',
                    style: TextStyle(color: Get.theme.primaryColor),
                  ).tr(),
                ),
              ),
            )
          ],
        ),
        duration: Duration(days: 1),
        backgroundColor: Get.theme.primaryColor,
        colorText: Colors.white,
      );

      result = false;
    }

    return result;
  } catch (e) {
    print("Exception - checkBodyController - checkBody():" + e.toString());
    return false;
  }
}

//check login
Future<bool> isLogin() async {
  sp = await SharedPreferences.getInstance();
  print("isLogin token --> ${sp!.getString("token")}");
  print("isLogin currentUserId --> ${sp!.getInt("currentUserId")}");
  if (sp!.getString("token") == null &&
      sp!.getInt("currentUserId") == null &&
      currentUserId == null) {
    Get.to(() => LoginScreen());
    return false;
  } else {
    return true;
  }
}

Future<bool> checkLogin() async {
  sp = await SharedPreferences.getInstance();
  print("${sp!.getString("token")}");
  print("${sp!.getInt("currentUserId")}");
  print("${currentUserId}");
  if (sp!.getString("token") == null &&
      sp!.getInt("currentUserId") == null &&
      currentUserId == null) {
    return false;
  } else {
    return true;
  }
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1);
}

logoutUser() async {
  await apiHelper.logout();
  sp = await SharedPreferences.getInstance();
  sp!.remove("currentUser");
  sp!.remove("currentUserId");
  sp!.remove("token");
  sp!.remove("tokenType");
  Get.find<BottomNavigationController>().astrologerList.clear();
  Get.find<BottomNavigationController>().update(); // Clear previous list
  user = CurrentUserModel();
  sp!.clear();

  log("current user logout:- ${sp!.getString('currentUserId')}");
  currentUserId = null;
  splashController.currentUser = null;
  Get.off(() => LoginScreen());
}

saveCurrentUser(int id, String token, String tokenType) async {
  try {
    sp = await SharedPreferences.getInstance();
    await sp!.setInt('currentUserId', id);
    await sp!.setString('token', token);
    await sp!.setString('tokenType', tokenType);
  } catch (e) {
    print("Exception - saveCurrentUser():" + e.toString());
  }
}

getCurrentUser() async {
  try {
    sp = await SharedPreferences.getInstance();
    currentUserId = sp!.getInt('currentUserId');
    log('user ID is :- $currentUserId');
  } catch (e) {
    print("Exception - gloabl.dart - getCurrentUser():" + e.toString());
  }
}

String appId = kIsWeb
    ? '1'
    : Platform.isAndroid
        ? "1"
        : "1";
AndroidDeviceInfo? androidInfo;
IosDeviceInfo? iosInfo;
WebBrowserInfo? webBrowserInfo;
DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
var appVersion = "1.0.0";
String? deviceId;
String? fcmToken;
String? deviceLocation;
String? deviceManufacturer;
String? deviceModel;
SystemFlagNameList systemFlagNameList = SystemFlagNameList();
List<HororscopeSignModel> hororscopeSignList = [];

String getAppVersion() {
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  return appVersion;
}

String getSystemFlagValue(String flag) {
  String? value = splashController.currentUser!.systemFlagList!
      .firstWhere((e) => e.name == flag)
      .value;
  return splashController.currentUser!.systemFlagList!
      .firstWhere((e) => e.name == flag)
      .value!;
}

String getSystemFlagValueForLogin(String flag) {
  String? value =
      splashController.syatemFlag.firstWhere((e) => e.name == flag).value;
  return splashController.syatemFlag.firstWhere((e) => e.name == flag).value!;
}

showToast({required String message, Color? textColor, Color? bgColor}) async {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: bgColor,
    textColor: textColor,
    fontSize: 14.0,
  );
}

Future<Widget> showHtml({
  required String html,
  Map<String, Style>? style,
}) async {
  try {
    return Html(
      data: html,
      style: style ?? {},
    );
  } catch (e) {
    return Html(
      data: html,
      style: style ?? {},
    );
  }
}

Future<BottomNavigationBarItem> showBottom(
    {required String text, required Widget widget}) async {
  return BottomNavigationBarItem(
    icon: widget,
    label: text,
  );
}

Future<InputDecoration> showDecorationHint(
    {required String hint, InputBorder? inputBorder}) async {
  return InputDecoration(hintText: hint, border: inputBorder);
}

Future getDeviceData() async {
  log('in getDeviceData');

  await PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    appVersion = packageInfo.version;
  });
  if (kIsWeb) {
    if (webBrowserInfo == null) {
      webBrowserInfo = await deviceInfo.webBrowserInfo;
    }
    String browserNameString = 'Unknow browser';
    switch (webBrowserInfo!.browserName) {
      case BrowserName.firefox:
        browserNameString = 'Firefox';
        break;
      case BrowserName.samsungInternet:
        browserNameString = 'Samsung Internet Browser';
        break;
      case BrowserName.opera:
        browserNameString = 'opera';
        break;
      case BrowserName.msie:
        browserNameString = 'msie';
        break;
      case BrowserName.edge:
        browserNameString = 'edge';
        break;
      case BrowserName.chrome:
        browserNameString = 'chrome';
        break;
      case BrowserName.safari:
        browserNameString = 'safari';
        break;
      default:
        browserNameString = 'Unknown browser';
    }
    deviceModel = browserNameString;
    deviceManufacturer = webBrowserInfo!.vendor;
    deviceId = webBrowserInfo!.productSub;
    fcmToken = await FirebaseMessaging.instance.getToken();
    log('fcm token:- $fcmToken');
    log('deviceManufacturer:- $browserNameString');
    log('vendor:- ${webBrowserInfo!.vendor}');
    log('platorm:- ${webBrowserInfo!.platform}');
    log('product snub:- ${webBrowserInfo!.productSub}');
  } else {
    if (Platform.isAndroid) {
      if (androidInfo == null) {
        androidInfo = await deviceInfo.androidInfo;
      }
      deviceModel = androidInfo!.model;
      deviceManufacturer = androidInfo!.manufacturer;
      deviceId = androidInfo!.id;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
      } on Exception catch (e) {
        log('Exception:- $e');
      }
    } else if (Platform.isIOS) {
      if (iosInfo == null) {
        iosInfo = await deviceInfo.iosInfo;
      }
      deviceModel = iosInfo!.model;
      deviceManufacturer = "Apple";
      deviceId = iosInfo!.identifierForVendor;
      fcmToken = await FirebaseMessaging.instance.getToken();
    }
  }
}

saveUser(CurrentUserModel user) async {
  try {
    sp = await SharedPreferences.getInstance();
    await sp!.setString('currentUser', json.encode(user.toJson()));
  } catch (e) {
    print("Exception - global.dart - saveUser(): ${e.toString()}");
  }
}

String myToken = '';
Future<Map<String, String>> getApiHeaders(bool authorizationRequired) async {
  Map<String, String> apiHeader = new Map<String, String>();
  if (authorizationRequired) {
    String tokenType = global.sp!.getString("tokenType") ?? "Bearer";
    String token = global.sp!.getString("token") ?? global.myToken;
    log('authentication token :- $token');
    apiHeader.addAll({"Authorization": " $tokenType $token"});
  }
  apiHeader.addAll({"Content-Type": "application/json"});
  apiHeader.addAll({"Accept": "application/json"});
  return apiHeader;
}
