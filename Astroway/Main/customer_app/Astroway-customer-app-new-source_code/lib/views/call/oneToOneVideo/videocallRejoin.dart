import 'dart:developer';
import 'dart:math' hide log;
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/views/call/oneToOneVideo/onetooneVideo.dart';
import 'package:AstrowayCustomer/views/call/oneToOneVideo/videocallSession.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

class Videocallrejoin extends StatelessWidget {
  const Videocallrejoin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CallController>(
      builder: (sessionController) {
        if (sessionController.videoCallactiveSessions.isEmpty ||
            global.isCallOrChat != 3) {
          // No active sessions
          log('no Active session For video call');
          return const SizedBox.shrink();
        }

        // Get the first active session (you can modify this logic if you want to handle multiple)
        final session = sessionController.videoCallactiveSessions.values.first;

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
                const Icon(Icons.video_call_outlined, color: Colors.white),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active Video Call',
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
                        'View Video',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),

                ///close button
                // IconButton(
                //   icon: const Icon(Icons.close, color: Colors.white),
                //   onPressed: () => sessionController
                //       .removeVideoCallSession(session.sessionId),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _rejoinChat(Videocallsession session) {
    int now = DateTime.now().millisecondsSinceEpoch;

    int saveattime = global.VideocallStartedAt!;
    log('rejoing mysaveattime1 $saveattime');
    // log('rejoing saveat ${DateTime.fromMillisecondsSinceEpoch(session.savedAt)}');
    log('session.channelname ${session.channelname}');
    log('session.fcm ${session.fcmToken}');

    int totalTimeElapsed = ((now - saveattime) / 1000).toInt();
    int remainingTime =
        max(0, (int.parse(session.end_time.toString()) - totalTimeElapsed));
    log('rejoing totalTimeElapsed $totalTimeElapsed');
    log('rejoing remaining time $remainingTime');

    Get.to(() => OneToOneLiveScreen(
          channelname: session.channelname,
          callId: session.callId,
          fcmToken: session.fcmToken,
          end_time: remainingTime.toString(),
          rejoin: true,
          // flagId: 1, // Active chat flag
          // customerName: session.customerName,
          // customerId: session.customerId,
          // customerProfile: session.customerProfile,
          // chatduration: remainingTime,
          // fireBasechatId: session.fireBasechatId,
          // astrologerId: session.astrologerId,
          // astrouserID: session.astrouserID,
          // subscriptionId: session.subscriptionId,
        ));

    // Remove from active sessions
    global.VideocallStartedAt = null;
    // Get.find<CallController>().removeVideoCallSession(session.sessionId);
  }
}
