import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/cupertino.dart';

class Videocallsession {
  final String sessionId;
  final int callId;
  final String channelname;
  final String fcmToken;
  final String end_time;
  final dynamic savedAt;
  ValueNotifier<int?> remoteUid;
  RtcEngine agoraEngine;
  ValueNotifier<bool> isMuted;
  ValueNotifier<bool> isSpeaker;

  Videocallsession({
    required this.sessionId,
    required this.callId,
    required this.channelname,
    required this.fcmToken,
    required this.end_time,
    required this.savedAt,
    required this.remoteUid,
    required this.agoraEngine,
    required this.isMuted,
    required this.isSpeaker,
  });
}
