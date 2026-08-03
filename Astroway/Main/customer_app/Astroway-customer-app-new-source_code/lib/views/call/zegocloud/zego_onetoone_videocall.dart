import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../../../controllers/callController.dart';
import '../../chat/endDialog.dart';

class ZegoOnetoOneVideoCallscreen extends StatefulWidget {
  const ZegoOnetoOneVideoCallscreen(
      {super.key,
      required this.callID,
      required this.userName,
      required this.callduration,
      required this.profile});

  final String callID;
  final String userName;
  final String callduration;
  final String profile;

  @override
  State<ZegoOnetoOneVideoCallscreen> createState() =>
      _ZegoOnetoOneVideoCallscreenState();
}

class _ZegoOnetoOneVideoCallscreenState
    extends State<ZegoOnetoOneVideoCallscreen> {
  final ValueNotifier<bool> isConnected = ValueNotifier(false);
  final ValueNotifier<Duration> remainingTime = ValueNotifier(Duration.zero);
  bool _isTimerStarted = false;
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        ZegoUIKitPrebuiltCall(
            appID: int.parse(global
                .getSystemFlagValueForLogin(global.systemFlagNameList.zegoAppId)
                .toString()),
            appSign: global.getSystemFlagValueForLogin(
                global.systemFlagNameList.zegoAppSign),
            userID: global.user.id.toString(),
            userName: '${widget.userName}',
            callID: widget.callID,
            // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
            config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
              ..duration.isVisible = false,
            events: ZegoUIKitPrebuiltCallEvents(
                onCallEnd: (event, defaultAction) {
                  _stopCountdown();
                },
                onError: (onError) {
                  log("error: ${onError.code} ${onError.message}");
                },
                user: ZegoCallUserEvents(
                  onEnter: (user) {
                    remainingTime.value =
                        Duration(seconds: int.parse(widget.callduration));
                    isConnected.value = true;
                    _startCountdown();
                    log("user joined: ${user.id} ${user.name}");
                  },
                  onLeave: (user) {
                    log("user left: ${user.id} ${user.name}");
                  },
                ),
                onHangUpConfirmation: (event, defaultAction) {
                  log("hangup confimation");
                  _stopCountdown();

                  return defaultAction();
                },
                room: ZegoCallRoomEvents(
                  onStateChanged: (roomstate) {
                    log("room state: ${roomstate.reason}");
                  },
                  onTokenExpired: (remainSeconds) {
                    String returnThis =
                        "token expired, remain seconds: $remainSeconds";
                    log(returnThis);
                    return null;
                  },
                ))),
        Positioned(
          top: 5.h,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: ValueListenableBuilder(
              valueListenable: isConnected,
              builder: (_, connected, __) {
                return connected
                    ? ValueListenableBuilder(
                        valueListenable: remainingTime,
                        builder: (_, duration, __) {
                          return Column(
                            children: [
                              Text(
                                _formatDuration(duration),
                                style: TextStyle(
                                  color: duration.inMinutes < 1
                                      ? Colors
                                          .red // Red when less than 1 minute left
                                      : Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              if (duration.inMinutes < 1 &&
                                  duration.inSeconds > 0)
                                Text(
                                  "${duration.inSeconds} seconds remaining",
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          );
                        },
                      )
                    : const SizedBox();
              },
            ),
          ),
        )
      ],
    ));
  }

  Timer? _timer;

  final callController = Get.find<CallController>();

  void _startCountdown() {
    if (_isTimerStarted) return;
    _isTimerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
        callController.totalSeconds = callController.totalSeconds + 1;
        callController.update();

        log('time remaining: ${remainingTime.value}');
      } else {
        // leaveMeeting();
        _stopCountdown();
        isConnected.dispose();
        remainingTime.dispose();
        global.showToast(
            message: 'Time is finished',
            textColor: Colors.white,
            bgColor: Colors.red);
        // leaveMeeting();
      }
    });
  }

  void _stopCountdown() {
    if (_timer != null && _timer!.isActive) {
      leaveMeeting();
      _timer!.cancel();
      _isTimerStarted = false;
      log("Countdown stopped manually");
    }
  }

  Future<void> leaveMeeting() async {
    try {
      if (callController.totalSeconds < 60 &&
          callController.endTime.value != null) {
        Get.dialog(
          EndDialog(),
        );
      } else {
        log('time on call: ${callController.totalSeconds}');
        Future.wait<void>([
          callController.endCall(int.parse(widget.callID.toString()),
              callController.totalSeconds, "", ""),
          global.splashController.getCurrentUserData(),
          FlutterCallkitIncoming.endAllCalls()
        ]);
        isConnected.dispose();
        remainingTime.dispose();
        Get.back();
      }
    } catch (e) {
      debugPrint("Error leaving meeting: $e");
    }
  }
}
