import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/dailyHoroscopeController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/timer_controller.dart';
import 'package:AstrowayCustomer/model/current_user_model.dart';
import 'package:AstrowayCustomer/model/systemFlagModel.dart';
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/views/chat/ChatSession.dart';
import 'package:AstrowayCustomer/views/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../views/astrologerProfile/astrologerProfile.dart';
import '../views/bottomNavigationBarScreen.dart';
import '../views/call/oneToOneVideo/onetooneVideo.dart';
import '../views/call/onetooneAudio/accept_call_screen.dart';
import '../views/call/onetooneAudio/incoming_call_request.dart';
import '../views/chat/AcceptChatScreen.dart';
import '../views/chat/incoming_chat_request.dart';
import '../views/customer_support/customerSupportChatScreen.dart';
import '../views/live_astrologer/live_astrologer_screen.dart';
import '../views/settings/notificationScreen.dart';
import 'astrologer_assistant_controller.dart';
import 'customer_support_controller.dart';
import 'liveController.dart';
import 'settings_controller.dart';

class SplashController extends GetxController {
  final apiHelper = APIHelper();
  CurrentUserModel? currentUser;
  CurrentUserModel? currentUserPayment;
  String appShareLinkForLiveSreaming =
      'https://play.google.com/store/apps/details?id=com.astroexpert.user';
  String? version;
  double? totalGst;
  var syatemFlag = <SystemFlag>[];
  String appName = "";
  String currentLanguageCode = 'en';
  final dailyHoroscopeController = Get.find<DailyHoroscopeController>();
  final callController = Get.put(CallController());
  @override
  void onInit() {
    _inIt();
    _endcall();
    super.onInit();
  }

  void _endcall() async {
    final pref = await SharedPreferences.getInstance();
    bool? fromAppkill = pref.getBool("isformKill") ?? false;
    int? callid = pref.getInt("callId");
    int? totaltime = pref.getInt("calltime");
    String? agoraSid1 = pref.getString("agorasid1");
    String? agoraSid2 = pref.getString("agorasid2");

    debugPrint("isformKill from kill $fromAppkill");
    debugPrint("isformKill from callid $callid");
    debugPrint("isformKill from call time $totaltime");
    debugPrint("isformKill from agorasid1 $agoraSid1");
    debugPrint("isformKill from agoraSid2 $agoraSid2");

    if (fromAppkill) {
      await callController.endCall(callid!.toInt(), totaltime!.toInt(),
          agoraSid1.toString(), agoraSid2.toString());
      await Get.find<SplashController>().getCurrentUserData();
      ;
      global.sp?.setBool("isformKill", false);
      pref.remove("isformKill");
      pref.remove("callId");
      pref.remove("calltime");
      pref.remove("agorasid1");
      pref.remove("agorasid2");
    } else {
      debugPrint("No data Found");
    }
  }

  bool isLogin = false;

  _inIt() async {
    global.chatStartedAt = null;
    await getSystemFlag();
    await apiHelper.getPublicIPAddress();

    appName = global.getSystemFlagValueForLogin(
      global.systemFlagNameList.appName,
    );
    global.sp = await SharedPreferences.getInstance();
    currentLanguageCode = global.sp!.getString('currentLanguage') ?? 'en';
    global.sp!.setString('currentLanguage', currentLanguageCode);
    update();
    Timer(const Duration(seconds: 5), () async {
      try {
        bool isLogin = await global.isLogin();
        if (isLogin) {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          await global.checkBody().then((result) async {
            if (result) {
              await apiHelper.validateSession().then((result) async {
                if (result.status == "200") {
                  currentUser = result.recordList;
                  global.saveUser(currentUser!);
                  global.user = currentUser!;
                  await Future.wait<void>([
                    getCurrentUserData(),
                    global.getCurrentUser(),
                  ]);
                  global.refreshUserFCM();
                  OneSignal.Notifications.addClickListener((event) {
                    try {
                      print('onesignal splashcontroller start');
                      onSelectNotification(event.notification.additionalData);
                    } catch (e) {
                      print('Failed to decode handleNotificationData: $e');
                    }
                  });
                  _loadsaveChatData();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _loadSavedData();
                  });
                  await dailyHoroscopeController.selectZodic(0);
                  if (global.generalPayload != null) {
                    Map<String, dynamic> convetedPayLoad = json.decode(
                      global.generalPayload,
                    );
                    Map<String, dynamic> body = jsonDecode(
                      convetedPayLoad['body'],
                    );
                    if (body["notificationType"] == 1) {
                      body['call_type'].toString() == "11"
                          ? Get.to(
                              () => OneToOneLiveScreen(
                                channelname: body["channelName"],
                                callId: body["callId"],
                                fcmToken: body["token"],
                                end_time: body['call_duration'].toString(),
                              ),
                            )
                          : Get.to(
                              () => IncomingCallRequest(
                                astrologerId: body["astrologerId"],
                                astrologerName: body["astrologerName"] == null
                                    ? "Astrologer"
                                    : body["astrologerName"],
                                astrologerProfile: body["profile"] == null
                                    ? ""
                                    : body["profile"],
                                token: body["token"],
                                channel: body["channelName"],
                                callId: body["callId"],
                                fcmToken: body["fcmToken"] ?? "",
                                duration: body['call_duration'].toString(),
                                callMethod: body['call_method'].toString(),
                              ),
                            );
                    } else if (body["notificationType"] == 3) {
                      Get.to(
                        () => IncomingChatRequest(
                          onesignalsubscriptionid: body["subscription_id"],
                          astrologerName: body["astrologerName"] == null
                              ? "Astrologer"
                              : body["astrologerName"],
                          profile:
                              body["profile"] == null ? "" : body["profile"],
                          fireBasechatId: body["firebaseChatId"],
                          chatId: int.parse(body["chatId"].toString()),
                          astrologerId: body["astrologerId"],
                          fcmToken: body["fcmToken"],
                          duration: body['chat_duration'].toString(),
                        ),
                      );
                    } else if (body["notificationType"] == 4) {
                      print('live astrologer');
                      Get.find<ReviewController>().getReviewData(
                        body["astrologerId"],
                      );
                      await Get.find<BottomNavigationController>()
                          .getAstrologerbyId(body["astrologerId"]);
                      Get.to(() => AstrologerProfile(index: 0));
                    } else {
                      print('other notification');
                      Get.find<BottomNavigationController>().setIndex(1, 0);
                      Get.off(() => BottomNavigationBarScreen(index: 1));
                    }
                  } else {
                    Get.find<BottomNavigationController>().setIndex(0, 0);

                    Get.off(() => BottomNavigationBarScreen(index: 0));
                  }
                } else {
                  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
                    version = packageInfo.version;
                    update();
                  });
                  HomeController homeController = Get.find<HomeController>();
                  sp = await SharedPreferences.getInstance();
                  sp!.remove("currentUser");
                  sp!.remove("currentUserId");
                  sp!.remove("token");
                  sp!.remove("tokenType");
                  user = CurrentUserModel();
                  sp!.clear();

                  homeController.myOrders.clear();
                  Get.off(() => LoginScreen());
                }
              });
            }
          });
        } else {
          PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
            version = packageInfo.version;
            update();
          });
          Get.off(() => LoginScreen());
        }
      } catch (e) {
        print('Exception in _inIt():' + e.toString());
      }
    });
  }

  void onSelectNotification(Map<String, dynamic>? additionalData) async {
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      if (additionalData == null) {
        print('No additional data available in handleNotificationData');
        return;
      }
      print('onesignal splashcontroller Data: $additionalData');
      final description = additionalData['description'] ?? '';
      final body = additionalData['body'] ?? '';
      final title = additionalData['title'] ?? '';
      print('onesignal splashcontroller Description: $description');
      print('onesignal splashcontroller Title: $title');
      if (body is String) {
        try {
          final bodyData = json.decode(body);
          final bodydescription = bodyData['description'];
          final astrologerId = bodyData['astrologerId'];
          final astrologerName = bodyData['astrologerName'];
          final notificationType = bodyData['notificationType'];
          final callduration = bodyData['call_duration'];
          final profile = bodyData['profile'];
          final firebaseChatId = bodyData['firebaseChatId'];
          final chatId = bodyData['chatId'];
          final icon = bodyData['icon'];
          print('onesignal Astrologer ID: $astrologerId');
          print('onesignalTitle: $title');
          print('onesignal Astrologer Name: $astrologerName');
          print('onesignal Notification Type: $notificationType');
          print('onesignal Call Duration: $callduration');
          print('onesignal Profile: $profile');
          print('onesignal Firebase Chat ID: $firebaseChatId');
          print('onesignal Chat ID: $chatId');
          print('onesignal Icon: $icon');
          print('onesignal bodydescription: $bodydescription');
          if (bodyData["notificationType"] == 1) {
            bodyData['call_type'].toString() == "11"
                ? Get.to(
                    () => OneToOneLiveScreen(
                      channelname: bodyData["channelName"],
                      callId: bodyData["callId"],
                      fcmToken: bodyData["token"],
                      end_time: bodyData['call_duration'].toString(),
                    ),
                  )
                : Get.to(
                    () => IncomingCallRequest(
                      astrologerId: bodyData["astrologerId"],
                      astrologerName: bodyData["astrologerName"] == null
                          ? "Astrologer"
                          : bodyData["astrologerName"],
                      astrologerProfile: bodyData["profile"] == null
                          ? ""
                          : bodyData["profile"],
                      token: bodyData["token"],
                      channel: bodyData["channelName"],
                      callId: bodyData["callId"],
                      fcmToken: bodyData["fcmToken"] ?? "",
                      duration: bodyData['call_duration'].toString(),
                      callMethod: bodyData['call_method'].toString(),
                    ),
                  );
          } else if (bodyData["notificationType"] == 3) {
            Get.to(
              () => IncomingChatRequest(
                onesignalsubscriptionid: bodyData["subscription_id"],
                astrologerName: bodyData["astrologerName"] == null
                    ? "Astrologer"
                    : bodyData["astrologerName"],
                profile: bodyData["profile"] == null ? "" : bodyData["profile"],
                fireBasechatId: bodyData["firebaseChatId"],
                chatId: int.parse(bodyData["chatId"].toString()),
                astrologerId: bodyData["astrologerId"],
                fcmToken: bodyData["fcmToken"],
                duration: bodyData['chat_duration'].toString(),
              ),
            );
          } else if (bodyData["notificationType"] == 4) {
            String? token = bodyData['token'].toString();
            String channelName = bodyData["channelName"].toString();
            String astrologerName = bodyData["name"].toString();
            int astrologerId = int.parse(bodyData["astrologerId"].toString());
            double charge = double.parse(bodyData["charge"].toString());
            double videoCallCharge = double.parse(
              bodyData["videoCallRate"].toString(),
            );
            BottomNavigationController bottomController =
                Get.find<BottomNavigationController>();
            bottomController.anotherLiveAstrologers = bottomController
                .listliveAstrologer!
                .where((element) => element.astrologerId != astrologerId)
                .toList();
            bottomController.update();
            final liveController = Get.find<LiveController>();
            await liveController.getWaitList(channelName);
            int index2 = liveController.waitList.indexWhere(
              (element) => element.userId == global.currentUserId,
            );
            if (index2 != -1) {
              liveController.isImInWaitList = true;
              liveController.update();
            } else {
              liveController.isImInWaitList = false;
              liveController.update();
            }
            liveController.isImInLive = true;
            liveController.isJoinAsChat = false;
            liveController.isLeaveCalled = false;
            await bottomController.getAstrologerbyId(astrologerId);
            bool isFollow = bottomController.astrologerbyId[0].isFollow!;
            liveController.update();
            Get.to(
              () => LiveAstrologerScreen(
                token: token,
                channel: channelName,
                astrologerName: astrologerName,
                astrologerId: astrologerId,
                isFromHome: true,
                charge: charge,
                isForLiveCallAcceptDecline: false,
                videoCallCharge: videoCallCharge,
                isFollow: isFollow,
              ),
            );
          } else if (bodyData['description'] == "Receive Message") {
            print('Support spalshcontroller message');

            await Future.wait<void>([
              Get.find<CustomerSupportController>().getCustomerTickets(),
              Get.find<AstrologerAssistantController>()
                  .getChatWithAstrologerAssisteant(),
            ]);

            Get.to(() => CustomerSupportChat());
          } else {
            print('other spalshcontroller notification');
            await Get.find<SettingsController>().getNotification();
            Get.to(() => NotificationScreen());
          }
        } catch (e) {
          print('Failed to spalshcontroller onesignal body: $e');
        }
      }
    } else {
      print(
        'No additional data available in spalshcontroller handleNotificationData',
      );
    }
  }

  void _loadsaveChatData() async {
    final prefs = await SharedPreferences.getInstance();

    _checkChatStatus();

    bool? isChatDataAvailable = await prefs.getBool('is_chatdataAvailable');
    bool? notification_navigate = await prefs.getBool('notification_navigate');
    print('notification screen navigate:- ${notification_navigate}');
    print('isChatDataAvailable: $isChatDataAvailable');
    if (isChatDataAvailable == true) {
      await prefs.setBool('is_chatdataAvailable', false);
      String? chatDataJson = await prefs.getString('chatdata');
      if (chatDataJson != null) {
        Map<String, dynamic> chatData = jsonDecode(chatDataJson);
        print('Loaded chat data: $chatData');
        _handleNotificationNavigation(chatData);
      } else {
        print('No chat data found in SharedPreferences.');
      }
    } else {
      print('No chat data available.');
    }
    if (notification_navigate == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('notification_navigate', false);
      await Get.find<SettingsController>().getNotification();
      Get.to(() => NotificationScreen());
    } else {
      print('No notification');
    }
  }

  void _handleNotificationNavigation(Map<String, dynamic> chatData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('chatdata', '');

    if (chatData.containsKey('body')) {
      Map<String, dynamic> body = jsonDecode(chatData['body']);
      if (body["notificationType"] == 3) {
        Get.to(
          () => IncomingChatRequest(
            onesignalsubscriptionid: body["subscription_id"],
            astrologerName: body["astrologerName"] ?? "Astrologer",
            profile: body["profile"] ?? "",
            fireBasechatId: body["firebaseChatId"] ?? "",
            chatId: int.parse(body["chatId"].toString()),
            astrologerId: body["astrologerId"],
            fcmToken: body["fcmToken"],
            duration: body['chat_duration'].toString(),
          ),
        );
      } else {
        print('Notification type is not 3');
      }
    } else {
      print('No body field found in chat data.');
    }
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();

    bool? isacceptedcall = await prefs.getBool('is_accepted');
    print('is accepted or not $isacceptedcall');
    if (isacceptedcall == true) {
      // Handle call end action
      String? dataaccepted = await prefs.getString('is_accepted_data');
      if (dataaccepted!.isNotEmpty) {
        await prefs.setBool('is_accepted', false);
        print('is accepted dataaccepted $dataaccepted}');
        callAccept(jsonDecode(dataaccepted));
        await prefs.setString('is_accepted_data', '');
      }
    }

    bool? isrejectedcall = await prefs.getBool('is_rejected');
    if (isrejectedcall == true) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_accepted', false);
      await prefs.setString('is_accepted_data', '');
    }
  }

  Future<void> createAstrologerShareLink() async {
    try {
      await global.commonShareMethod(
        title:
            "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career. I would recommend you to connect with best Astrologer at ${global.getSystemFlagValue(global.systemFlagNameList.appName)}. Download the App from https://play.google.com/store/apps/details?id=com.astroexpert.user&hl=en_IN",
      );
    } catch (e) {
      print("Exception createAstrologerShareLink():" + e.toString());
    }
  }

  getCurrentUserData() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getCurrentUser().then((result) {
            if (result.status == "200") {
              currentUser = result.recordList;
              global.saveUser(currentUser!);
              global.user = currentUser!;
              print('wallet ammount splash ${global.user.walletAmount}');
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getCurrentUserData():' + e.toString());
    }
  }

  getSystemFlag() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.sp = await SharedPreferences.getInstance();
          await apiHelper.getSystemFlag().then((result) {
            if (result.status == "200") {
              syatemFlag = result.recordList;
              update();
            } else {}
          });
        }
      });
    } catch (e) {
      print('Exception in getSystemFlag():' + e.toString());
    }
  }
}

void _checkChatStatus() {
  Future.delayed(Duration(milliseconds: 300), () {});
  final box = GetStorage();
  final sessionMap = box.read("activeChatSession");
  print("My Session Data ${sessionMap}");
  if (sessionMap != null) {
    ChatSession savedsession = ChatSession.fromJson(sessionMap);
    print("📌 Loaded Session: $savedsession");
    final lastSaved = DateTime.tryParse(savedsession.lastSaved ?? "");
    if (lastSaved != null) {
      global.chatStartedAt = lastSaved.millisecondsSinceEpoch;
      print("Chat started at splash: ${global.chatStartedAt}");
    }
    final chatDuration = int.tryParse(savedsession.chatduration) ?? 0;
    print("lastSaved: $lastSaved, chatDuration: $chatDuration");

    if (lastSaved != null && chatDuration > 0) {
      final elapsed = DateTime.now().difference(lastSaved).inSeconds;
      final remaining = chatDuration - elapsed;

      print("⏳ Elapsed: $elapsed sec, Remaining: $remaining sec");

      if (remaining > 0) {
        print("✅ Chat is still active with $remaining seconds left.");
        global.isCallOrChat = 1;
        Get.find<ChatController>().addSession(savedsession);
      } else {
        print("❌ Chat expired, removing session.");
        global.isCallOrChat = 0;
        box.remove("activeChatSession");
      }
    } else {
      print("⚠️ Invalid lastSaved or chatDuration");
      box.remove("activeChatSession");
    }
  } else {
    print("❌ No session found in storage");
  }
}

@pragma('vm:entry-point')
void callAccept(Map<String, dynamic> extraData) async {
  log('extra call astrologerId ${extraData}');
  final callController = Get.find<CallController>();

  if (extraData['call_type'] == 10) {
    await callController.acceptedCall(extraData["callId"]);
    Get.to(
      () => AcceptCallScreen(
        astrologerId: extraData["astrologerId"],
        astrologerName: extraData["astrologerName"] == null
            ? "Astrologer"
            : extraData["astrologerName"],
        astrologerProfile:
            extraData["profile"] == null ? "" : extraData["profile"],
        token: extraData["token"],
        callChannel: extraData["channelName"],
        callId: extraData["callId"],
        duration: extraData['call_duration'].toString(),
      ),
    );
  } else if (extraData['call_type'] == 11) {
    Get.to(
      () => OneToOneLiveScreen(
        channelname: extraData["channelName"],
        callId: extraData["callId"],
        fcmToken: extraData["token"].toString(),
        end_time: extraData['call_duration'].toString(),
      ),
    );
  } else if (extraData['notificationType'] == 3) {
    final chatController = Get.find<ChatController>();

    await chatController
        .acceptedChat(int.parse(extraData["chatId"].toString()));
    print("Start simple chat timer");
    print("${extraData['fcmToken']}");
    // global.callOnFcmApiSendPushNotifications(
    //     fcmTokem: [extraData["fcmToken"]], title: 'Start simple chat timer');
    global.hideLoader();
    chatController.isInchat = true;
    chatController.isEndChat = false;
    final timerController = Get.find<TimerController>();
    timerController.startTimer();
    chatController.update();
    Get.to(() => AcceptChatScreen(
          flagId: 1,
          oneSignalSubscriptionID: extraData["subscription_id"],
          astrologerName: extraData["astrologerName"] == null
              ? "Astrologer"
              : extraData["astrologerName"],
          profileImage: extraData["profile"] == null
              ? ""
              : extraData["profile"].toString(),
          fireBasechatId: extraData["firebaseChatId"].toString(),
          astrologerId: extraData["astrologerId"],
          chatId: int.parse(extraData["chatId"].toString()),
          fcmToken: extraData["fcmToken"],
          duration: extraData['chat_duration'].toString(),
        ));
  }
}
