import 'dart:io';
import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  static final InAppReview _inAppReview = InAppReview.instance;
  static Future<void> requestForReview() async {
    try {
      if (await _inAppReview.isAvailable() && Platform.isAndroid) {
        await _inAppReview.requestReview();
      } else if (await _inAppReview.isAvailable() && Platform.isIOS) {
        //  Hanlde For Ios In app Review
      }
    } catch (e) {
      print("Error showing review: $e");
    }
  }
}
