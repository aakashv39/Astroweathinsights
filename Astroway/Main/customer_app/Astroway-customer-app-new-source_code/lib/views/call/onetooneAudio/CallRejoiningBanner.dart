import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/callController.dart';
import '../../../controllers/splashController.dart';
import '../../../controllers/trackingchatController.dart';
import '../../../utils/foregroundTaskHandler.dart';
import '../../../utils/global.dart' as global;
import 'CallSessions.dart';
import 'accept_call_screen.dart';

class Callrejoiningbanner extends StatefulWidget {
  const Callrejoiningbanner({super.key});

  @override
  State<Callrejoiningbanner> createState() => _CallrejoiningbannerState();
}

class _CallrejoiningbannerState extends State<Callrejoiningbanner> {
  final _callController = Get.find<CallController>();
  final trackingcontroller = Get.find<TrackingChatController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      builder: (sessionController) {
        if (sessionController.activeSessions.isEmpty) {
          // No active sessions
          log('no Active session For call');
          return const SizedBox.shrink();
        }

        // Get the first active session (you can modify this logic if you want to handle multiple)
        final session = sessionController.activeSessions.values.first;

        return InkWell(
          onTap: () {
            _rejoinChat(session);
          },
          child: Container(
            height: 8.h,
            width: 80.w,
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.call, color: Colors.white),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Call with ${session.astrologerName}',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.green, width: 1)),
                      child: Text(
                        'View Audio',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _rejoinChat(Callsessions session) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    final int startedAt = global.callStartedAt ?? session.savedAt;
    final int callDurationSeconds =
        int.tryParse(session.duration.toString()) ?? 0;

    final int totalTimeElapsed = ((now - startedAt) / 1000).toInt();
    final int remainingTime = callDurationSeconds - totalTimeElapsed;

    log('⏱️ Started at: ${DateTime.fromMillisecondsSinceEpoch(startedAt)}');
    log('⏱️ Now: ${DateTime.fromMillisecondsSinceEpoch(now)}');
    log('⏱️ Duration (sec): $callDurationSeconds');
    log('⏱️ Elapsed (sec): $totalTimeElapsed');
    log('⏱️ Remaining (sec): $remainingTime');

    // 🟥 If the call duration has expired
    if (remainingTime <= 0) {
      log('⏰ Call duration expired — leaving session.');
      leave(session);
      global.callStartedAt = null;
      Get.snackbar(
        'Call Ended',
        'The call session has expired.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // 🟩 Otherwise, rejoin with remaining time
    Get.to(() => AcceptCallScreen(
          astrologerName: session.astrologerName,
          astrologerId: session.astrologerId,
          astrologerProfile: session.astrologerProfile,
          token: session.token,
          callChannel: session.callChannel,
          callId: int.parse(session.callId.toString()),
          isfromnotification: true,
          duration: remainingTime.toString(),
        ));
  }

  Future<void> leave(Callsessions session) async {
    ForegroundServiceManager.stopForegroundTask();
    _callController.showBottomAcceptCall = false;
    _callController.callBottom = false;
    _callController.isLeaveCall = true;
    global.sp!.remove('callBottom');
    global.sp!.setInt('callBottom', 0);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('callStarttime');
    _callController.callBottom = false;
    _callController.update();
    global.showOnlyLoaderDialog(Get.context);
    Future.wait<void>([
      _callController.endCall(int.parse(session.callId.toString()),
          _callController.totalSeconds, global.agoraSid1, global.agoraSid2),
    ]);

    await Get.find<SplashController>().getCurrentUserData();
    global.isCallOrChat = 0;

    global.hideLoader();
    _callController.removeSession(session.callId.toString());
    session.agoraEngine?.leaveChannel();
    session.agoraEngine?.release(sync: true);
    global.localUid = null;
    _callController.endTime.value = null;
    trackingcontroller.stopTimer();
    _callController.removeSession(session.callId.toString());
    Get.snackbar(
      "Call Ended",
      "The allotted call duration has expired.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
