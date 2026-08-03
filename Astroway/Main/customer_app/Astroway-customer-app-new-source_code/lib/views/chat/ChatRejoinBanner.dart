import 'dart:developer';
import 'dart:math' hide log;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controllers/bottomNavigationController.dart';
import '../../controllers/chatController.dart';
import '../../controllers/splashController.dart';
import '../../controllers/timer_controller.dart';
import '../../utils/global.dart' as global;
import 'AcceptChatScreen.dart';
import 'ChatSession.dart';

class ChatRejoinBanner extends StatelessWidget {
  ChatRejoinBanner({super.key});
  final timerContoller = Get.find<TimerController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final chatController = Get.find<ChatController>();
  final timerController = Get.find<TimerController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (sessionController) {
        if (sessionController.activeSessions.isEmpty) {
          // No active sessions
          log('no Active session For chat');
          return const SizedBox.shrink();
        }

        // Get the first active session (you can modify this logic if you want to handle multiple)
        final session = sessionController.activeSessions.values.first;

        return InkWell(
          onTap: () {
            _rejoinChat(session);
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 8.h,
            width: 80.w,
            child: Row(
              children: [
                const Icon(Icons.chat, color: Colors.white),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Active chat with ${session.customerName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.w,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.green, width: 1),
                      ),
                      child: Text(
                        'View Chat',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
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

  final box = GetStorage();
  void _rejoinChat(ChatSession session) async {
    // int chatStartedAt = global.chatStartedAt ?? 0;
    int? savedStartTime = box.read('saveStartChatTimeoneTime');
    final dt = DateTime.fromMillisecondsSinceEpoch(savedStartTime!);
    final now = DateTime.now().millisecondsSinceEpoch;
    final totalTimeElapsed = ((now - savedStartTime) / 1000).toInt();
    final remainingTime = max(
      0,
      int.parse(session.chatduration.toString()) - totalTimeElapsed,
    );
    final readableTime = formatDurationHMS(remainingTime);

    print('''
        🔵 Saved start time from storage: $savedStartTime new method
        🔵 "Saved started readable is : ${DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(savedStartTime)).inSeconds}"
        🔵 dt: $dt and now is $now
        🔵 Total time elapsed: $totalTimeElapsed second
        🔵 Remaining time: $remainingTime seconds 
        🔵 readabletime ($readableTime)
      ''');

    if (remainingTime <= 0) {
      print('⚠️ Chat time expired, not rejoining');
      Get.find<ChatController>().removeSession(session.sessionId);
      _backpress(session);

      global.showToast(
        message: 'chat time expired',
        textColor: Colors.white,
        bgColor: Colors.black,
      );
      return;
    }
    Get.find<ChatController>().isTimerEnded = false;

    Get.to(
      () => AcceptChatScreen(
        flagId: 1,
        profileImage: session.customerProfile,
        astrologerName: session.customerName,
        fireBasechatId: session.fireBasechatId,
        astrologerId: session.astrologerId,
        chatId: int.parse(session.sessionId.toString()),
        duration: remainingTime.toString(),
        isFromRejoin: true,
        chatStartedAt: savedStartTime,
      ),
    );

    // Remove from active sessions
    Get.find<ChatController>().removeSession(session.sessionId);
  }

  String formatDurationHMS(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$hours:$minutes:$secs";
  }

  Map<String, dynamic>? getSavedChatSession() {
    final box = GetStorage();
    final session = box.read("activeChatSession");
    if (session != null) {
      return Map<String, dynamic>.from(session);
    }
    return null;
  }

  void _backpress(ChatSession session) async {
    chatController.sendMessage(
      '${global.user.name == '' ? 'user' : global.user.name} -> ended chat',
      session.fireBasechatId,
      session.astrologerId,
      true,
    );
    chatController.setOnlineStatus(
      false,
      session.fireBasechatId,
      '${global.currentUserId}',
      from: "form chat rejoin backpress",
    );
    chatController.showBottomAcceptChat = false;
    Future.wait<void>([
      chatController.endChatTime(
        int.parse(session.chatduration),
        int.parse(session.sessionId.toString()),
        'chat_rejoin_expired',
      ),
      bottomNavigationController.getAstrologerList(isLazyLoading: false),
    ]);
    await Get.find<SplashController>().getCurrentUserData();
  }
}
