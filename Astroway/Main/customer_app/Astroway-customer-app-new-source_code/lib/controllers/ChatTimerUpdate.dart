import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

class ChatTimerController extends GetxController {
  int countdownTime = 0; // Start timer at 60 seconds
   Timer? ntimer;
  bool isDialogshowing=false;

  // Start the timer
  void startOneMinuteTimer() {
    if (ntimer != null && ntimer!.isActive) {
      log('Timer is already running.');
      return;
    }
    log('time called $countdownTime');

    ntimer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (countdownTime > 0) {
        countdownTime--;
        log('startOneMinute Timer $countdownTime');
        update();
      } else {
        t.cancel();
        isDialogshowing?  Get.back() : log('Dialog is not showing');
        update();
      }
      update();
    });
  }

  void stopcountingTimer() {
    ntimer?.cancel(); // Cancel the timer
    update();
    log('stopcountingTimer stopped.');
  }

  @override
  void onClose() {
    stopcountingTimer();
    super.onClose();
  }
}
