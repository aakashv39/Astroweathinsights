// ignore_for_file: file_names, prefer_const_declarations
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../controllers/astrologer_assistant_controller.dart';
import '../main.dart';
import '../views/astrologerProfile/chat_with_assistant_screen.dart';
import '../views/customer_support/chatWithAstrologerAssistant.dart';

final localNotifications = FlutterLocalNotificationsPlugin();

class NotificationHandler {
  Future<void> onSelectNotification(String payload) async {
    Map<dynamic, dynamic> messageData;
    messageData = json.decode(payload);
    Map<dynamic, dynamic> body;
    print("onSelectNotification:- ${messageData}");
    print("onSelectNotification:- ${messageData['title']}");
    if (messageData['title'].toString() == "Assistant Chat") {
      final AstrologerAssistantController astrologerAssistantController =
          Get.find<AstrologerAssistantController>();
      await customerSupportController.getCustomerTickets();
      await astrologerAssistantController.getChatWithAstrologerAssisteant();
      Get.to(() => ChatWithAstrologerAssistant(
            appbar: true,
          ));
      // Get.to();
    }
    // body = jsonDecode(messageData['body']);
    // log('in onSelectNotification');
    // log('notification body $body');
    // log('selected notificationType is ${body["notificationType"]} and calltype is ${body['call_type']}');
  }

  Future<void> foregroundNotificatioCustomAuddio(RemoteMessage payload) async {
    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: false,
    );
    log('payload is ${payload.data['title']}');
    log('payload description 1 ${payload.data['description']}');
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initialSetting = InitializationSettings(
        android: android, iOS: initializationSettingsDarwin);
    localNotifications.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      log('foregroundNotificatioCustomAuddio tap');
      onSelectNotification(json.encode(payload.data));
    });
    final customSound = 'app_sound.wav';
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'channel_id_17',
      'channel.name',
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound('app_sound'),
    );
    final iOSDetails = DarwinNotificationDetails(
      sound: customSound,
    );
    final platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    global.sp = await SharedPreferences.getInstance();
    await localNotifications.show(
      10,
      payload.data['title'], //message.data["title"]
      payload.data['description'] ?? '',
      platformChannelSpecifics,
      payload: json.encode(payload.data.toString()),
    );
  }

  Future<void> foregroundNotification(RemoteMessage payload) async {
    log('--------------------------------------------------');
    log('started foreground notification');
    log('--------------------------------------------------');
    final initializationSettingsDarwin = DarwinInitializationSettings(
      defaultPresentBadge: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
      defaultPresentSound: false,
    );
    final android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    final initialSetting = InitializationSettings(
        android: android, iOS: initializationSettingsDarwin);
    localNotifications.initialize(initialSetting,
        onDidReceiveNotificationResponse: (_) {
      log('foregroundNotification tap');
      onSelectNotification(json.encode(payload.data));
    });
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'channel_id-111',
      'channel.name',
      importance: Importance.max,
      icon: "@mipmap/ic_launcher",
      playSound: true,
      enableVibration: true,
    );
    final iOSDetails = const DarwinNotificationDetails();
    final platformChannelSpecifics =
        NotificationDetails(android: androidDetails, iOS: iOSDetails);
    global.sp = await SharedPreferences.getInstance();
    try {
      await localNotifications.show(
        10,
        payload.data['title'],
        payload.data['description'],
        platformChannelSpecifics,
        payload: json.encode(payload.data.toString()),
      );
    } on Exception catch (e) {
      log('error in showing notification: $e');
    }
  }
}
