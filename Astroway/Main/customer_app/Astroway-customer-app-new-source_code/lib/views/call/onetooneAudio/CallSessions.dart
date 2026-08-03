import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class Callsessions {
  final String sessionId;
  final int astrologerId;
  final String astrologerName;
  final String astrologerProfile;
  final String token;
  final String callChannel;
  final String callId;
  final bool isfromnotification;
  final String duration;
  final dynamic savedAt;
  int? remoteID;
  bool isJoined;
  bool isMuted;
  bool isSpeaker;
  RtcEngine? agoraEngine;
  Timer? callTimer;
  double? price;
  double? balance;

  Callsessions({
    required this.sessionId,
    required this.astrologerId,
    required this.astrologerName,
    required this.astrologerProfile,
    required this.token,
    required this.callChannel,
    required this.callId,
    required this.isfromnotification,
    required this.duration,
    required this.savedAt,
    required this.remoteID,
    required this.isJoined,
    required this.isMuted,
    required this.isSpeaker,
    required this.agoraEngine,
    this.callTimer,
    this.price,
    this.balance,
  });
}
