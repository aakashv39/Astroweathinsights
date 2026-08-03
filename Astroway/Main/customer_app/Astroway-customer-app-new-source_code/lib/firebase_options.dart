import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        return android;
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "",
    projectId: "astroway-",
    storageBucket: "astroway-.appspot.com",
    messagingSenderId: "",
    appId: "1::android:",
    // ✅ for com.astrowaydiploy.user
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyDsrsuJ2tx83rRPdTrAUKQRNhmmCTbEzxA",
    appId: "1:381086206621:ios:",
    messagingSenderId: "",
    projectId: "astroway-",
    storageBucket: "-diploy.appspot.com",
    iosBundleId: 'com..user',
    measurementId: "G-",
  );
}
