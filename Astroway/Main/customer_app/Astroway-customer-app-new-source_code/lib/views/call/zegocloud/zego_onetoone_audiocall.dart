// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import '../../../controllers/callController.dart';
import '../../chat/endDialog.dart';

class ZegoOnetoOneAudioCallscreen extends StatefulWidget {
  ZegoOnetoOneAudioCallscreen({
    super.key,
    required this.callID,
    required this.userName,
    required this.callduration,
    required this.profile,
  });
  final String callID;
  final String userName;
  final String callduration;
  final String profile;

  @override
  State<ZegoOnetoOneAudioCallscreen> createState() =>
      _ZegoOnetoOneCallscreenState();
}

class _ZegoOnetoOneCallscreenState extends State<ZegoOnetoOneAudioCallscreen> {
  final callController = Get.find<CallController>();
  final ValueNotifier<bool> isConnected = ValueNotifier(false);
  final ValueNotifier<Duration> remainingTime = ValueNotifier(Duration.zero);
  bool _isTimerStarted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZegoUIKitPrebuiltCall(
          appID: int.parse(global
              .getSystemFlagValueForLogin(global.systemFlagNameList.zegoAppId)
              .toString()),
          appSign: global.getSystemFlagValueForLogin(
              global.systemFlagNameList.zegoAppSign),
          userID: global.user.id.toString(),
          userName: '${widget.userName}',
          callID: widget.callID,
          config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
            ..duration.isVisible = false
            ..topMenuBarConfig.isVisible = false
            ..audioVideoView.containerBuilder =
                (context, allUsers, audioVideoUsers, extraInfo) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    // Background with gradient
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 27, 27, 233),
                            Color.fromARGB(255, 65, 106, 218),
                            Color.fromARGB(255, 15, 52, 96),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ValueListenableBuilder(
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
                                                      ? Colors.red
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
                            SizedBox(
                              height: 3.h,
                            ),
                            // Profile image or first letter
                            widget.profile.isNotEmpty
                                ? Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider(
                                            widget.profile),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withOpacity(0.2),
                                      border: Border.all(
                                          color: Colors.white, width: 3),
                                    ),
                                    child: Center(
                                      child: Text(
                                        widget.userName.isNotEmpty
                                            ? widget.userName[0].toUpperCase()
                                            : 'A',
                                        style: const TextStyle(
                                          fontSize: 48,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                            const SizedBox(height: 20),
                            // User name
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Connection status
                            ValueListenableBuilder<bool>(
                              valueListenable: isConnected,
                              builder: (context, connected, child) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: connected
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        connected ? 'Connected' : 'Waiting...',
                                        style: TextStyle(
                                          color: connected
                                              ? Colors.green
                                              : Colors.orange,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            ..audioVideoView.foregroundBuilder =
                (context, size, user, extraInfo) {
              return Container();
            }
            ..audioVideoView.backgroundBuilder = (
              BuildContext context,
              Size size,
              ZegoUIKitUser? user,
              Map<String, dynamic> extraInfo,
            ) {
              return Container();
            },
          events: ZegoUIKitPrebuiltCallEvents(
            onCallEnd: (event, defaultAction) {
              Navigator.of(context).pop();
              log("Audio call ended");
              defaultAction();
            },
            onError: (onError) {
              log("error: ${onError.code} ${onError.message}");
            },
            user: ZegoCallUserEvents(
              onEnter: (user) {
                remainingTime.value =
                    Duration(seconds: int.parse(widget.callduration));
                isConnected.value = true;
                _startCountdown("onEnter");
                log("user joined: ${user.id} ${user.name}");
              },
              onLeave: (user) {
                leaveMeeting();

                log("user left: ${user.id} ${user.name}");
              },
            ),
            onHangUpConfirmation: (event, defaultAction) {
              log("hangup confimation");
              leaveMeeting();
              remainingTime.value = Duration.zero;
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
            ),
          )),
    );
  }

  Timer? _timer;
  void _startCountdown(String fromWhere) {
    print("fromWhere:- ${fromWhere}");
    if (_isTimerStarted) return;
    _isTimerStarted = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = remainingTime.value - const Duration(seconds: 1);
        callController.totalSeconds = callController.totalSeconds + 1;
        callController.update();
        log('time remaining: ${remainingTime.value}');
      } else {
        leaveMeeting();
        _stopCountdown();
        isConnected.dispose();
        remainingTime.dispose();
        global.showToast(
            message: 'Time is finished',
            textColor: Colors.white,
            bgColor: Colors.red);
      }
    });
  }

  void _stopCountdown() {
    if (_timer != null && _timer!.isActive) {
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
              callController.totalSeconds, '', ''),
          global.splashController.getCurrentUserData(),
          FlutterCallkitIncoming.endAllCalls()
        ]);
        _stopCountdown();
        isConnected.dispose();
        remainingTime.dispose();
        Get.back();
      }
    } catch (e) {
      debugPrint("Error leaving meeting: $e");
    }
  }

  @override
  void dispose() {
    _stopCountdown();
    isConnected.dispose();
    remainingTime.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }
}
