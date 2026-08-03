// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/services.dart';

class NotificationMethodChannel {
  var notichannel = MethodChannel('com.astrowaydiploy.user/channel_test');

  void createNewChannel() async {
    Map<String, String> channelMap = {
      "id": "channel_id_17",
      "name": "Chats",
      "description": "Chat notifications",
    };
    log('create channel start');
    try {
      final bool finished =
          await notichannel.invokeMethod('mynotichannel', channelMap);
      log('create channel start $finished');

      if (finished) {
        log('create channel finished successfully!');
      }
      log('create channel start finsihed $channelMap and status is $finished ');
    } on PlatformException catch (e) {
      log('create channel exception is $e');
    }
  }

  Future<void> startForegroundService() async {
    log('start foreground service');
    try {
      final bool finished =
          await notichannel.invokeMethod('startForegroundService');
      log('start foreground service $finished');
    } on PlatformException catch (e) {
      print("Failed to start foreground service: ${e.message}");
    }
  }

  // Method to stop the foreground service
  Future<void> stopForegroundService() async {
    print('stopForegroundService started');
    try {
      final bool finished =
          await notichannel.invokeMethod('stopForegroundService');
      print('stopForegroundService $finished');
    } on PlatformException catch (e) {
      print("Exception foreground service: '${e.message}'.");
    }
  }
}
