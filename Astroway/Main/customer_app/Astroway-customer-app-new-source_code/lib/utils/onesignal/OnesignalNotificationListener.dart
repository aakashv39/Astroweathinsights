import 'dart:async';
import 'dart:developer';
import 'package:flutter/services.dart';

class OneSignalNotificationListener {
  static const _eventChannel =
      EventChannel('com.astrowaydiploy.user/event_channel');
  static final _instance = OneSignalNotificationListener._internal();
  factory OneSignalNotificationListener() => _instance;
  OneSignalNotificationListener._internal();
  final _notificationStreamController = StreamController<String>.broadcast();
  Stream<String> get notificationStream => _notificationStreamController.stream;
  void initialize() {
    // Listen to EventChannel
    _eventChannel.receiveBroadcastStream().listen((event) {
      log("receiveBroadcastStream FLUTTER: $event");
      _notificationStreamController.add(event);
    }, onError: (error) {
      log("Error receiveBroadcastStream $error");
    });
  }

  void dispose() {
    _notificationStreamController.close();
  }
}
