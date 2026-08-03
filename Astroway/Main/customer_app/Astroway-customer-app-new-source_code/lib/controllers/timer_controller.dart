import 'dart:async';

import 'package:get/get.dart';

import '../utils/services/api_helper.dart';

class TimerController extends GetxController {
  Timer? secTimer;
  int totalSeconds = 0;
  APIHelper apiHelper = APIHelper();
  int chatId = 0;
  bool endChat = false;

  startTimer() {
    totalSeconds = 0;
    secTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      print("total Sec:- $totalSeconds");
      totalSeconds += 1;
      update();
    });
  }

  stopTimer() {
    if (secTimer != null) {
      secTimer!.cancel();
    }
    update();
  }
}
