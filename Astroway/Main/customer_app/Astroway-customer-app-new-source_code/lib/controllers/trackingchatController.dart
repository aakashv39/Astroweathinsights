import 'dart:async';
import 'package:get/get.dart';

class TrackingChatController extends GetxController {
  int totalSeconds = 0; // Total time in seconds
  String secText = "-1";
  String minText = "-1";
  Timer? secTimer;
  int? updatedTime;
  int selectTime = 0;
  bool isRechargeDialogShowing = false;
  bool paymentDialogShowing = false;
  int? timeTracker; ///this is for time tracking in video call

  /// Starts the countdown timer from the given duration in seconds.
  void startCountdown(int initialSeconds) {
    print("updated time:- ${initialSeconds}");
    totalSeconds = initialSeconds; // Initialize with the passed time

    // Initialize the minute and second text
    minText = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    secText = (totalSeconds % 60).toString().padLeft(2, '0');
    update();

    // Start the timer
    secTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (totalSeconds > 0) {
        totalSeconds--;
        // log('time runnning $totalSeconds');
        // Update the minute and second text
        minText = (totalSeconds ~/ 60).toString().padLeft(2, '0');
        secText = (totalSeconds % 60).toString().padLeft(2, '0');
        update();
      } else {
        // Timer ends here
        timer.cancel();
        secTimer?.cancel();
        onTimerEnd();
      }
    });
  }

  void stopTimer() {
    secTimer?.cancel();
    secTimer = null;
    update();
  }

  void resetTimer() {
    stopTimer();
    // totalSeconds = 0;
    secText = "00";
    minText = "00";
    update();
  }

  void onTimerEnd() {
    // Handle actions when the timer ends
    print('Countdown has ended');
    // Example: End call or show a dialog
  }

}
