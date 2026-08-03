import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkController extends GetxController {
  var connectionStatus = 0.obs;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(updateConnectivity);
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result = [];
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      print(e.toString());
    }
    updateConnectivity(result);
  }

  void updateConnectivity(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.wifi)) {
      connectionStatus.value = 1;
    } else if (results.contains(ConnectivityResult.mobile)) {
      connectionStatus.value = 2;
    } else if (results.contains(ConnectivityResult.none)) {
      connectionStatus.value = 0;
      Get.snackbar(
        'Network Error',
        'No internet connection available',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      connectionStatus.value = 0;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
