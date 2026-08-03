// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:developer';
import 'package:AstrowayCustomer/utils/notificationUtils.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/customer_support_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/themeController.dart';
import 'package:AstrowayCustomer/firebase_options.dart';
import 'package:AstrowayCustomer/theme/nativeTheme.dart';
import 'package:AstrowayCustomer/utils/CallUtils.dart';
import 'package:AstrowayCustomer/utils/FallbackLocalizationDelegate.dart';
import 'package:AstrowayCustomer/utils/binding/networkBinding.dart';
import 'package:AstrowayCustomer/utils/foregroundTaskHandler.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/views/call/hms/HmsOneToOneVideoCallScreen.dart';
import 'package:AstrowayCustomer/views/call/hms/hmsAcceptCallscreen.dart';
import 'package:AstrowayCustomer/views/call/oneToOneVideo/onetooneVideo.dart';
import 'package:AstrowayCustomer/views/call/zegocloud/zego_onetoone_audiocall.dart';
import 'package:AstrowayCustomer/views/call/zegocloud/zego_onetoone_videocall.dart';
import 'package:AstrowayCustomer/views/chat/AcceptChatScreen.dart';
import 'package:AstrowayCustomer/views/poojaBooking/controller/poojaController.dart';
import 'package:AstrowayCustomer/views/splashScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';
import 'controllers/astrologer_assistant_controller.dart';
import 'controllers/dailyHoroscopeController.dart';
import 'controllers/life_cycle_controller.dart';
import 'controllers/settings_controller.dart';
import 'controllers/timer_controller.dart';
import 'utils/config.dart';
import 'utils/images.dart';
import 'views/bottomNavigationBarScreen.dart';
import 'views/call/hms/HMSLiveScreen.dart';
import 'views/call/onetooneAudio/accept_call_screen.dart';
import 'views/call/onetooneAudio/incoming_call_request.dart';
import 'views/chat/incoming_chat_request.dart';
import 'views/customer_support/customerSupportChatScreen.dart';
import 'views/live_astrologer/live_astrologer_screen.dart';
import 'views/settings/notificationScreen.dart';
import 'views/astrotechwealth_prototype_screen.dart';

final _localNotifications = FlutterLocalNotificationsPlugin();
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log("_firebaseMessagingBackgroundHandler a background message: ${message.data}");
  await GetStorage.init();

  global.sp = await SharedPreferences.getInstance();
  if (global.sp!.getString("currentUser") != null) {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    global.generalPayload = json.encode(message.data['body']);
    var messageData;
    if (message.data['body'] != null) {
      messageData = json.decode((message.data['body']));
    }
    if (messageData['notificationType'] == 1) {
      log('notificationType background :- ${messageData["notificationType"]}');
      CallUtils.showIncomingCall(messageData);
      initforbackground();
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  EasyLocalization.logger.enableLevels = []; // 👈 Turn off all logs
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.black54,
        statusBarIconBrightness: Brightness.light),
  );
  await GetStorage.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('gu', 'IN'),
        Locale('hi', 'IN'),
        Locale('mr', 'IN'), //marathi
        Locale('bn', 'IN'),
        Locale('kn', 'IN'),
        Locale('ml', 'IN'),
        Locale('ta', 'IN'),
        Locale('te', 'IN'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      startLocale: const Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

final bottomController = Get.put(BottomNavigationController());
final liveController = Get.put(LiveController());
final customerSupportController = Get.put(CustomerSupportController());
final chatController = Get.put(ChatController());
final homeCheckController = Get.put(HomeCheckController());
final callController = Get.put(CallController());
final onboardController = Get.put(OnBoardController());
final homeController = Get.put(HomeController());
AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'Astroway local notifications',
  'High Importance Notifications for Atroguru',
  importance: Importance.defaultImportance,
);

class _MyAppState extends State<MyApp> {
  static const bool useAstrotechwealthPrototype = true;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void dispose() {
    log('main dispose');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //---- ONE SIGNAL INITIALIZATIOIN ----//
    initonesignal();

    //---- FIREBASE MESSAGING FOREGROUND CALL AUDIO/VIDEO ----//
    firebaseforegroundCall();

    //---- CALLKIT INITIALIZATIOIN ----//
    initializeCallKitEventHandlers();
  }

  void initonesignal() async {
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.consentRequired(false);
    ForegroundServiceManager.initialize();
    OneSignal.initialize(OnesignalID);

    OneSignal.Notifications.addPermissionObserver((state) {
      log("onesignal permission $state");
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      event.preventDefault();
      event.notification.display();
      log('onesignal capture ${event.notification.additionalData} ');
      showForegroundNotification(event.notification.additionalData);
    });
  }

  void showForegroundNotification(Map<String, dynamic>? additionalData) async {
    if (additionalData == null) {
      log('No additional data available in handleNotificationData');
      return;
    }
    log('onesignal Additional Data: $additionalData');
    log('inside showForegroundNotificaiton ${additionalData['title']}');
    if (additionalData['title'] != null || additionalData['body'] != null) {
      final body = additionalData['body'] ?? '';
      final title = additionalData['title'] ?? '';
      if (body is String) {
        try {
          final bodyData = json.decode(body);
          log('onesignal bodyData $bodyData');
          if (bodyData['notificationType'] == 8) {
            await Get.find<BottomNavigationController>().getAstrologerList(
              isLazyLoading: false,
            );
          }

          if (bodyData["title"] == "For Live accept/reject") {
            if (liveController.isImInLive == true) {
              String astroName = bodyData["astroName"];
              int astroId = bodyData['astroId'] != null
                  ? int.parse(bodyData['astroId'].toString())
                  : 0;
              String channel = bodyData['channel'];
              String token = bodyData['token'];
              String astrologerProfile = bodyData['astroProfile'] ?? "";
              String requestType = bodyData['requestType'];
              int id = bodyData['id'] != null
                  ? int.parse(bodyData['id'].toString())
                  : 0;
              double charge = bodyData['charge'] != null
                  ? double.parse(bodyData['charge'].toString())
                  : 0;
              double videoCallCharge = bodyData['videoCallCharge'] != null
                  ? double.parse(bodyData['videoCallCharge'].toString())
                  : 0;
              String astrologerFcmToken =
                  bodyData['fcmToken'] != null ? bodyData['fcmToken'] : "";
              await bottomController.getAstrologerbyId(astroId);
              bool isFollow = bottomController.astrologerbyId[0].isFollow!;
              liveController.accpetDeclineContfirmationDialogForLiveStreaming(
                  astroId: astroId,
                  astroName: astroName,
                  channel: channel,
                  token: token,
                  requestType: requestType,
                  id: id,
                  charge: charge,
                  astrologerFcmToken2: astrologerFcmToken,
                  astrologerProfile: astrologerProfile,
                  videoCallCharge: videoCallCharge,
                  isFollow: isFollow,
                  callMethod: bodyData['call_method']);
            }
          } else if (title == "Product Recommendation") {
            homeController.getrecomendedProductList();
          } else if (title == "Puja Recommendation") {
            homeController.getrecomendedPujaList();
          } else if (bodyData["title"] ==
              "For starting the timer in other audions for video and audio") {
            if (liveController.isImInLive == true) {
              // int waitListId = int.parse(bodyData["waitListId"].toString());
              String channelName = bodyData['channelName'];
              liveController.joinUserName = bodyData['name'] ?? "User";
              liveController.joinUserProfile = bodyData['profile'] ?? "";
              await liveController.getWaitList(channelName);

              // int index5 = liveController.waitList.indexWhere(
              //   (element) => element.id == waitListId,
              // );
              // if (index5 != -1) {
              //   liveController.endTime = DateTime.now().millisecondsSinceEpoch +
              //       1000 * int.parse(liveController.waitList[index5].time);
              //   liveController.update();
              // }
            }
          } else if (bodyData["title"] ==
              "For accepting time while user already splitted") {
            int timeInInt = int.parse(bodyData["timeInInt"].toString());
            liveController.endTime = DateTime.now().millisecondsSinceEpoch +
                1000 * int.parse(timeInInt.toString());
            liveController.joinUserName = bodyData["joinUserName"] ?? "";
            liveController.joinUserProfile = bodyData["joinUserProfile"] ?? "";
            liveController.update();
          } else if (bodyData["title"] ==
              "Notification for customer support status update") {
            var message1 = jsonDecode(bodyData['body']);
            if (customerSupportController.isIn) {
              customerSupportController.status =
                  message1["status"] ?? "WAITING";
              customerSupportController.update();
            }
          } else if (bodyData["description"] == "Receive Message") {
            var message1 = jsonDecode(bodyData['body']);
            print("inside of support notification");
            if (customerSupportController.isIn) {
              customerSupportController.status =
                  message1["status"] ?? "WAITING";
              customerSupportController.update();
            }
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            );
          } else if (bodyData["title"] == "End chat from astrologer") {
            chatController.showBottomAcceptChat = false;
            global.sp = await SharedPreferences.getInstance();
            global.sp!.remove('chatBottom');
            global.sp!.setInt('chatBottom', 0);
            chatController.chatBottom = false;
            chatController.isAstrologerEndedChat = true;
            chatController.update();
          } else if (bodyData["title"] == "Astrologer Leave call") {
            callController.showBottomAcceptCall = false;
            global.sp!.remove('callBottom');
            global.sp!.setInt('callBottom', 0);
            callController.callBottom = false;
            callController.update();
          } else {
            try {
              if (bodyData.isNotEmpty) {
                var messageData = bodyData;
                if (messageData['notificationType'] != null) {
                  print(
                    "notification type:- ${messageData['notificationType']}",
                  );
                  if (messageData['notificationType'] == 3) {
                    print("call popup");
                    showDialog(
                      context: Get.context!,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return WillPopScope(
                          onWillPop: () async {
                            return false;
                          },
                          child: AlertDialog(
                            backgroundColor: Colors.white,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            content: Container(
                              height: 180,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.back();
                                        },
                                        child: Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 30,
                                    child: messageData["profile"] == ""
                                        ? Image.asset(
                                            Images.deafultUser,
                                            fit: BoxFit.fill,
                                            height: 50,
                                            width: 40,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: global.buildImageUrl(
                                                '${messageData["profile"]}'),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    CircleAvatar(
                                              radius: 48,
                                              backgroundImage: imageProvider,
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              Images.deafultUser,
                                              fit: BoxFit.fill,
                                              height: 50,
                                              width: 40,
                                            ),
                                          ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text(
                                      "${additionalData['title']}",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            await _localNotifications
                                                .cancelAll();
                                            global.showOnlyLoaderDialog(
                                              context,
                                            );
                                            await chatController.rejectedChat(
                                              messageData["chatId"].toString(),
                                            );
                                            global.hideLoader();
                                            global
                                                .callOnFcmApiSendPushNotifications(
                                              fcmTokem: [
                                                messageData["fcmToken"],
                                              ],
                                              title: 'End chat from customer',
                                            );
                                            BottomNavigationController
                                                bottomNavigationController =
                                                Get.find<
                                                    BottomNavigationController>();
                                            bottomNavigationController.setIndex(
                                              0,
                                              0,
                                            );
                                            Get.back();
                                            Get.to(
                                              () => BottomNavigationBarScreen(
                                                  index: 0),
                                            );
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Reject",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ).tr(),
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () async {
                                            // Get.back();
                                            await _localNotifications
                                                .cancelAll();
                                            global.showOnlyLoaderDialog(
                                              context,
                                            );
                                            await chatController.acceptedChat(
                                              int.parse(
                                                messageData["chatId"]
                                                    .toString(),
                                              ),
                                            );
                                            global
                                                .callOnFcmApiSendPushNotifications(
                                              fcmTokem: [
                                                messageData["fcmToken"],
                                              ],
                                              title: 'Start simple chat timer',
                                            );
                                            global.hideLoader();
                                            chatController.isInchat = true;
                                            chatController.isEndChat = false;
                                            final timerController =
                                                Get.find<TimerController>();
                                            timerController.startTimer();
                                            chatController.update();
                                            Get.to(
                                              () => AcceptChatScreen(
                                                flagId: 1,
                                                oneSignalSubscriptionID:
                                                    messageData[
                                                        "subscription_id"],
                                                astrologerName: messageData[
                                                            "astrologerName"] ==
                                                        null
                                                    ? "Astrologer"
                                                    : messageData[
                                                        "astrologerName"],
                                                profileImage:
                                                    messageData["profile"] ==
                                                            null
                                                        ? ""
                                                        : messageData["profile"]
                                                            .toString(),
                                                fireBasechatId: messageData[
                                                        "firebaseChatId"]
                                                    .toString(),
                                                astrologerId:
                                                    messageData["astrologerId"],
                                                chatId: int.parse(
                                                  messageData["chatId"]
                                                      .toString(),
                                                ),
                                                fcmToken:
                                                    messageData["fcmToken"],
                                                duration:
                                                    messageData['chat_duration']
                                                        .toString(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: Center(
                                              child: Text(
                                                "Accept",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ).tr(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            actionsAlignment: MainAxisAlignment.spaceBetween,
                            actionsPadding: const EdgeInsets.only(
                              bottom: 15,
                              left: 15,
                              right: 15,
                            ),
                          ),
                        );
                      },
                    );
                    await FirebaseMessaging.instance
                        .setForegroundNotificationPresentationOptions(
                      alert: true,
                      badge: true,
                      sound: true,
                    );
                    log("check4");
                  } else if (messageData['notificationType'] == 1) {
                    log("exotelcheck ${messageData}");
                    CallUtils.showIncomingCall(messageData);
                  } else if (messageData['notificationType'] == 4) {
                    await bottomController.getLiveAstrologerList();
                    if (messageData['isFollow'] == 1) {
                      //1 means user follow that astrologer
                      await FirebaseMessaging.instance
                          .setForegroundNotificationPresentationOptions(
                        alert: true,
                        badge: true,
                        sound: true,
                      );
                    }
                  } else if (messageData['notificationType'] == 14) {
                    await bottomController.getLiveAstrologerList();
                  } else {
                    await FirebaseMessaging.instance
                        .setForegroundNotificationPresentationOptions(
                      alert: true,
                      badge: true,
                      sound: true,
                    );
                  }
                } else {
                  await FirebaseMessaging.instance
                      .setForegroundNotificationPresentationOptions(
                    alert: true,
                    badge: true,
                    sound: true,
                  );
                }
              } else {
                log('admin else is ${bodyData}');
              }
            } catch (e) {
              print(e);
            }
          }
        } catch (e) {
          print('Failed to onesignal body: $e');
        }
      }
    } else {
      {
        log('Silent notification received');
        print('onesignal Additional Data: $additionalData');
      }
    }
  }

  void onSelectNotification(Map<String, dynamic>? additionalData) async {
    global.sp = await SharedPreferences.getInstance();
    if (global.sp!.getString("currentUser") != null) {
      if (additionalData == null) {
        log('No additional data available in handleNotificationData');
        return;
      }
      final body = additionalData['body'] ?? '';
      if (body is String) {
        try {
          final bodyData = json.decode(body);
          if (bodyData["notificationType"] == 25) {
            await Future.delayed(Duration(milliseconds: 100));
            //---Handle Notification Route for Recommond Products------
            HomeController homeController = Get.find<HomeController>();
            Get.find<HomeController>().getrecomendedProductList();
            log("My Reconnd List ${homeController.recomendedList}");
          } else if (bodyData["notificationType"] == 1) {
            log('call method getting is ${bodyData['call_method'].toString()}');
            if (bodyData['call_type'].toString() == "11") {
              if (bodyData['call_method'].toString() == "hms") {
                Get.to(() => HmsOneToOneVideoCallScreen(
                    callId: bodyData["callId"],
                    userName: bodyData["astrologerName"] == null
                        ? "Astrologer"
                        : bodyData["astrologerName"],
                    profile:
                        bodyData["profile"] == null ? "" : bodyData["profile"],
                    id: bodyData["astrologerId"],
                    token: bodyData["token"],
                    callduration: bodyData['call_duration'].toString()));
              } else if (bodyData['call_method'].toString() == "zegocloud") {
                Get.to(() => ZegoOnetoOneVideoCallscreen(
                    callID: bodyData["callId"],
                    userName: bodyData["astrologerName"] == null
                        ? "Astrologer"
                        : bodyData["astrologerName"],
                    profile:
                        bodyData["profile"] == null ? "" : bodyData["profile"],
                    callduration: bodyData['call_duration'].toString()));
              } else if (bodyData['call_method'].toString() == "agora") {
                Get.to(
                  () => OneToOneLiveScreen(
                    channelname: bodyData["channelName"],
                    callId: bodyData["callId"],
                    fcmToken: bodyData["token"],
                    end_time: bodyData['call_duration'].toString(),
                  ),
                );
              } else {
                log('cant find callmethod ');
              }
            } else {
              Get.to(
                () => IncomingCallRequest(
                  astrologerId: bodyData["astrologerId"],
                  astrologerName: bodyData["astrologerName"] == null
                      ? "Astrologer"
                      : bodyData["astrologerName"],
                  astrologerProfile:
                      bodyData["profile"] == null ? "" : bodyData["profile"],
                  token: bodyData["token"],
                  channel: bodyData["channelName"],
                  callId: bodyData["callId"],
                  fcmToken: bodyData["fcmToken"] ?? "",
                  duration: bodyData['call_duration'].toString(),
                  callMethod: bodyData['call_method'].toString(),
                ),
              );
            }
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
            double callmethod = bodyData["call_method"];
            log('callmetohd is $callmethod and token is $token');

            double videoCallCharge = double.parse(
              bodyData["videoCallRate"].toString(),
            );
            bottomController.anotherLiveAstrologers = bottomController
                .listliveAstrologer!
                .where((element) => element.astrologerId != astrologerId)
                .toList();
            bottomController.update();
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
            if (callmethod == 'hms') {
              Get.to(() => HMSLiveScreen(
                    hmsToken: token,
                    astrologerId: astrologerId,
                    channel: channelName,
                    videoCallCharge: videoCallCharge,
                    charge: charge,
                  ));
            } else if (callmethod == 'zegocloud') {
              // Get.to(() => Zegolivescreen(
              //
              //   liveID:  bottomController.astrologerbyId[0].,
              //   localUserID: global.user.id.toString(),
              // ));
            } else if (callmethod == 'agora') {
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
            } else {
              log('no call method found in main.dart line 773');
            }
          } else if (bodyData['description'] == "Receive Message") {
            print('Support message');
            CustomerSupportController customerSupportController =
                Get.find<CustomerSupportController>();
            final astrologerAssistantController =
                Get.find<AstrologerAssistantController>();

            Future.wait<void>([
              customerSupportController.getCustomerTickets(),
              astrologerAssistantController.getChatWithAstrologerAssisteant(),
            ]);

            Get.to(() => CustomerSupportChat());
          } else {
            print('other notification');
            final settingsController = Get.find<SettingsController>();
            await settingsController.getNotification();
            Get.to(() => NotificationScreen());
          }
        } catch (e) {
          print('Failed to onesignal body: $e');
        }
      }
    } else {
      log('No additional data available in handleNotificationData');
    }
  }

  final themeController = Get.put(ThemeController());
  final Dailyhoroscope = Get.put(DailyHoroscopeController());
  final splashController = Get.put(SplashController());
  final poojacontroller = Get.put(PoojaController());

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetBuilder<ThemeController>(
        builder: (themeController) {
          return ResponsiveSizer(
            builder: (context, orientation, deviceType) {
              return GetMaterialApp(
                navigatorKey: Get.key,
                debugShowCheckedModeBanner: false,
                enableLog: true,
                defaultTransition: Transition.rightToLeftWithFade,
                theme: nativeTheme(darkModeEnabled: false),
                initialBinding: NetworkBinding(),
                locale: context.locale,
                localizationsDelegates: [
                  ...context.localizationDelegates,
                  FallbackLocalizationDelegate(),
                ],
                supportedLocales: context.supportedLocales,
                title: 'AstroTechWealth',
                initialRoute: useAstrotechwealthPrototype ? null : "SplashScreen",
                home: useAstrotechwealthPrototype
                    ? const AstrotechwealthPrototypeScreen()
                    : SplashScreen(),
              );
            },
          );
        },
      ),
    );
  }

  static final AudioPlayer _player = AudioPlayer();
  void firebaseforegroundCall() {
    // -------------------FCM Token Refresh Listener-----------------
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      log("New FCM token: $newToken");
      await global.refreshUserFCM();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("call request accepted:- ${message.data}");
      print("call_method:- ${message.data['call_method']}");
      if (message.data["title"] == "For Live accept/reject") {
        if (liveController.isImInLive == true) {
          String astroName = message.data["astroName"];
          int astroId = message.data['astroId'] != null
              ? int.parse(message.data['astroId'].toString())
              : 0;
          String channel = message.data['channel'];
          String token = message.data['token'];
          String astrologerProfile = message.data['astroProfile'] ?? "";
          String requestType = message.data['requestType'];
          int id = message.data['id'] != null
              ? int.parse(message.data['id'].toString())
              : 0;
          double charge = message.data['charge'] != null
              ? double.parse(message.data['charge'].toString())
              : 0;
          double videoCallCharge = message.data['videoCallCharge'] != null
              ? double.parse(message.data['videoCallCharge'].toString())
              : 0;
          String astrologerFcmToken =
              message.data['fcmToken'] != null ? message.data['fcmToken'] : "";
          await bottomController.getAstrologerbyId(astroId);
          bool isFollow = bottomController.astrologerbyId[0].isFollow!;
          // not show notification just show dialog for accept/reject for live stream
          liveController.accpetDeclineContfirmationDialogForLiveStreaming(
              astroId: astroId,
              astroName: astroName,
              channel: channel,
              token: token,
              requestType: requestType,
              id: id,
              charge: charge,
              astrologerFcmToken2: astrologerFcmToken,
              astrologerProfile: astrologerProfile,
              videoCallCharge: videoCallCharge,
              isFollow: isFollow,
              callMethod: message.data['call_method']);
        }
      }
      // final bodyData = json.decode((message.data['body']));
      if (message.data['body'] != null) {
        var messageData = json.decode((message.data['body']));
        if (messageData['notificationType'] == 1) {
          log('notificationType :- ${messageData["notificationType"]}');
          log('notificationType :- ${messageData}');
          CallUtils.showIncomingCall(messageData);
        } else {
          if (messageData['notificationType'] == 3) {
            print("chat popup");
            await _player.play(AssetSource('ringtone.mp3'), volume: 1.0);
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return WillPopScope(
                  onWillPop: () async {
                    return false;
                  },
                  child: AlertDialog(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    content: Container(
                      height: 22.h,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  await _player.stop();
                                  Get.back();
                                },
                                child: Icon(Icons.close),
                              ),
                            ],
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 30,
                            child: messageData["profile"] == ""
                                ? Image.asset(
                                    Images.deafultUser,
                                    fit: BoxFit.fill,
                                    height: 50,
                                    width: 40,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: global.buildImageUrl(
                                        '${messageData["profile"]}'),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                      radius: 48,
                                      backgroundImage: imageProvider,
                                    ),
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      Images.deafultUser,
                                      fit: BoxFit.fill,
                                      height: 50,
                                      width: 40,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "${message.data["title"]}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await _player.stop();
                                    await _localNotifications.cancelAll();
                                    global.showOnlyLoaderDialog(
                                      context,
                                    );
                                    await chatController.rejectedChat(
                                      messageData["chatId"].toString(),
                                    );
                                    global.hideLoader();
                                    global.callOnFcmApiSendPushNotifications(
                                      fcmTokem: [
                                        messageData["fcmToken"],
                                      ],
                                      title: 'End chat from customer',
                                    );
                                    BottomNavigationController
                                        bottomNavigationController =
                                        Get.find<BottomNavigationController>();
                                    bottomNavigationController.setIndex(
                                      0,
                                      0,
                                    );
                                    Get.back();
                                    Get.to(
                                      () => BottomNavigationBarScreen(index: 0),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    // Get.back();
                                    await _player.stop();
                                    await _localNotifications.cancelAll();
                                    global.showOnlyLoaderDialog(
                                      context,
                                    );
                                    await chatController.acceptedChat(
                                      int.parse(
                                        messageData["chatId"].toString(),
                                      ),
                                    );
                                    print("Start simple chat timer");
                                    print("${messageData['fcmToken']}");
                                    global.callOnFcmApiSendPushNotifications(
                                      fcmTokem: [
                                        messageData["fcmToken"],
                                      ],
                                      title: 'Start simple chat timer',
                                    );
                                    global.hideLoader();
                                    chatController.isInchat = true;
                                    chatController.isEndChat = false;
                                    final timerController =
                                        Get.find<TimerController>();
                                    timerController.startTimer();
                                    chatController.update();
                                    Get.to(
                                      () => AcceptChatScreen(
                                        flagId: 1,
                                        oneSignalSubscriptionID:
                                            messageData["subscription_id"],
                                        astrologerName:
                                            messageData["astrologerName"] ==
                                                    null
                                                ? "Astrologer"
                                                : messageData["astrologerName"],
                                        profileImage: messageData["profile"] ==
                                                null
                                            ? ""
                                            : messageData["profile"].toString(),
                                        fireBasechatId:
                                            messageData["firebaseChatId"]
                                                .toString(),
                                        astrologerId:
                                            messageData["astrologerId"],
                                        chatId: int.parse(
                                          messageData["chatId"].toString(),
                                        ),
                                        fcmToken: messageData["fcmToken"],
                                        duration: messageData['chat_duration']
                                            .toString(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Accept",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actionsPadding: const EdgeInsets.only(
                      bottom: 15,
                      left: 15,
                      right: 15,
                    ),
                  ),
                );
              },
            );
            await FirebaseMessaging.instance
                .setForegroundNotificationPresentationOptions(
              alert: true,
              badge: true,
              sound: true,
            );
            log("check4");
          }
        }
      }
      if (message.data['title'] == "Assistant Chat") {
        global.isInAssistantScreen
            ? null
            : NotificationHandler().foregroundNotification(message);
      }
    });
  }
}

@pragma('vm:entry-point')
void initializeCallKitEventHandlers() {
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
    if (event == null) return;
    switch (event.event) {
      case Event.actionCallStart:
        print('actionCallStart call incoming');
        break;
      case Event.actionCallAccept:
        if (event.body['extra']["call_method"].toString() == "exotel") {
          Fluttertoast.showToast(msg: "You will get a call");
        } else {
          final prefs = await SharedPreferences.getInstance();

          debugPrint('actionCallAccept call incoming');
          await prefs.setBool('is_accepted', false);
          await prefs.setString('is_accepted_data', '');

          callAccept(event);
        }

        break;
      case Event.actionCallDecline:
        // Handle call end action

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_accepted', false);
        await prefs.setString('is_accepted_data', '');

        global.callOnFcmApiSendPushNotifications(
          fcmTokem: [event.body['extra']["fcmToken"]],
          title: 'End call from customer',
        );

        print('call rejected and callid is ${event.body['extra']["callId"]}');

        await callController.rejectedCall(event.body['extra']["callId"]);
        callController.update();

        break;
      case Event.actionCallCallback:
        debugPrint('actionCallCallback call incoming click');
        callAccept(event);
        break;
      case Event.actionCallIncoming:
        print('actionCallIncoming call incoming click');

      case Event.actionCallCustom:
        print('actionCallIncoming call incoming click');

        break;
      default:
        break;
    }
  });
}

@pragma('vm:entry-point')
void initforbackground() async {
  final prefs = await SharedPreferences.getInstance();

  debugPrint('inside initforbackground');
  FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
    debugPrint('inside initforbackground $event');

    if (event == null) {
      await prefs.setBool('is_accepted', false);
      await prefs.setBool('is_rejected', false);

      return;
    }

    switch (event.event) {
      case Event.actionCallStart:
        // Handle call accept action
        print('actionCallStart call incoming');
        break;
      case Event.actionCallAccept:
        // Handle call decline action
        print('actionCallAccept call incoming');
        await prefs.setBool('is_accepted', true);
        String extraDataJson = jsonEncode(event.body['extra']);
        print('actionCallAccept extraDataJson $extraDataJson');
        await prefs.setString('is_accepted_data', extraDataJson);

        break;
      case Event.actionCallDecline:
        print('call rejected & callid is ${event.body['extra']["callId"]}');

        // Handle call end action
        await callController.rejectedCall(event.body['extra']['callId']);
        global.callOnFcmApiSendPushNotifications(
          fcmTokem: [event.body['extra']["fcmToken"]],
          title: 'End call from customer',
        );

        await prefs.setBool('is_rejected', true);
        await prefs.setBool('is_accepted', false);
        await prefs.setBool('is_rejected', false);
        await prefs.setString('is_accepted_data', '');

        break;
      case Event.actionCallCallback:
        print('actionCallCallback initforbackground call incoming click');

        break;

      case Event.actionCallTimeout:
        print('actionCallTimeout initforbackground call incoming click');
        //clear background data when missed call so whenever app open agian then this data
        //not open direactly callscreens
        await prefs.setBool('is_accepted', false);
        await prefs.setBool('is_rejected', false);
        await prefs.setString('is_accepted_data', '');
        break;

      default:
        break;
    }
  });
}

@pragma('vm:entry-point')
void callAccept(CallEvent event) async {
  debugPrint(
      "call Method form notificaion ${event.body['extra']["call_method"].toString()}");
  if (event.body['extra']['call_type'] == 10) {
    await callController.acceptedCall(event.body['extra']["callId"]);
    if (event.body['extra']["call_method"].toString() == "hms") {
      print("event.body:- ${event.body}");
      Get.to(() => HmsOneToOneAudioCallScreen(
            callId: event.body['extra']["callId"],
            callduration: event.body['extra']['call_duration'].toString(),
            token: event.body['extra']["token"],
            userName: event.body['extra']["astrologerName"] == null
                ? "Astrologer"
                : event.body['extra']["astrologerName"],
            profile: event.body['extra']['profile'],
          ));
    } else if (event.body['extra']["call_method"].toString() == "zegocloud") {
      print("main  file:- ${event.body['extra']["callId"]}");
      Get.to(() => ZegoOnetoOneAudioCallscreen(
            callID: event.body['extra']["callId"].toString(),
            callduration: event.body['extra']['call_duration'].toString(),
            userName: event.body['extra']["astrologerName"] == null
                ? "Astrologer"
                : event.body['extra']["astrologerName"],
            profile: event.body['extra']['profile'],
          ));
    } else if (event.body['extra']["call_method"].toString() == "agora") {
      debugPrint(
          "channel name from notification ${event.body['extra']["channelName"]}");
      Get.to(
        () => AcceptCallScreen(
          astrologerId: event.body['extra']["astrologerId"],
          astrologerName: event.body['extra']["astrologerName"] == null
              ? "Astrologer"
              : event.body['extra']["astrologerName"],
          astrologerProfile: event.body['extra']["profile"] == null
              ? ""
              : event.body['extra']["profile"],
          token: event.body['extra']["token"],
          callChannel: event.body['extra']["channelName"],
          callId: event.body['extra']["callId"],
          duration: event.body['extra']['call_duration'].toString(),
        ),
      );
    } else {
      log('cant find callmethod implemnt it first main.dart');
    }
  } else if (event.body['extra']['call_type'] == 11) {
    await callController.acceptedCall(event.body['extra']["callId"]);
    if (event.body['extra']["call_method"].toString() == "hms") {
      Get.to(() => HmsOneToOneVideoCallScreen(
          callId: event.body['extra']["callId"],
          userName: event.body['extra']["astrologerName"] == null
              ? "Astrologer"
              : event.body['extra']["astrologerName"],
          profile: event.body['extra']["profile"] == null
              ? ""
              : event.body['extra']["profile"],
          id: event.body['extra']["astrologerId"],
          token: event.body['extra']["token"],
          callduration: event.body['extra']['call_duration'].toString()));
    } else if (event.body['extra']["call_method"].toString() == "zegocloud") {
      Get.to(() => ZegoOnetoOneVideoCallscreen(
          callID: event.body['extra']["callId"].toString(),
          userName: event.body['extra']["astrologerName"] == null
              ? "Astrologer"
              : event.body['extra']["astrologerName"],
          profile: event.body['extra']["profile"] == null
              ? ""
              : event.body['extra']["profile"],
          callduration: event.body['extra']['call_duration'].toString()));
    } else if (event.body['extra']["call_method"].toString() == "agora") {
      debugPrint(
          "call video form snfosf  ${event.body['extra']["channelName"].toString()}");
      Get.to(
        () => OneToOneLiveScreen(
          channelname: event.body['extra']["channelName"],
          callId: event.body['extra']["callId"],
          fcmToken: event.body['extra']["token"].toString(),
          end_time: event.body['extra']['call_duration'].toString(),
        ),
      );
    } else {
      log('cant find videocallmethd implemnt it first main.dart');
    }
  } else if (event.body['extra']['notificationType'] == 3) {
    print("inside chat accept");
    final chatController = Get.find<ChatController>();
    debugPrint("FcmToken ${event.body['extra']['fcmToken']}");
    debugPrint('oneSignalId ${event.body['extra']["subscription_id"]}');
    debugPrint('Astrloger Name ${event.body['extra']["astrologerName"]}'); //
    debugPrint('FirebaseChat Id ${event.body['extra']["firebaseChatId"]}'); //
    debugPrint('AstrologerId ${event.body['extra']["astrologerId"]}');
    debugPrint('Chatduration ${event.body['extra']['chat_duration']}');
    await chatController.acceptedChat(
      int.parse(event.body['extra']["chatId"].toString()),
    );
    debugPrint("Start simple chat timer");
    // global.callOnFcmApiSendPushNotifications(
    //   fcmTokem: [event.body['extra']["fcmToken"]],
    //   title: 'Start simple chat timer',
    // );
    global.hideLoader();
    chatController.isInchat = true;
    chatController.isEndChat = false;
    final timerController = Get.find<TimerController>();
    timerController.startTimer();
    chatController.update();
    Get.to(
      () => AcceptChatScreen(
        flagId: 1,
        oneSignalSubscriptionID: event.body['extra']["subscription_id"],
        astrologerName: event.body['extra']["astrologerName"] == null
            ? "Astrologer"
            : event.body['extra']["astrologerName"],
        profileImage: event.body['extra']["profile"] == null
            ? ""
            : event.body['extra']["profile"].toString(),
        fireBasechatId: event.body['extra']["firebaseChatId"].toString(),
        astrologerId: event.body['extra']["astrologerId"],
        chatId: int.parse(event.body['extra']["chatId"].toString()),
        fcmToken: event.body['extra']["fcmToken"],
        duration: event.body['extra']['chat_duration'].toString(),
      ),
    );
  }
}
