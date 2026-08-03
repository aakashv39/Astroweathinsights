import 'package:get/get.dart';

class HomeCheckController extends FullLifeCycleController
    with FullLifeCycleMixin {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onDetached() {
    print('HomeController - onDetached called');
  }

  @override
  void onInactive() {
    print('HomeController - onInActive called');
  }

  @override
  void onPaused() {
    print('HomeController - onPaused called');
  }

  @override
  void onResumed() {
    print('HomeController - onResumed called');
  }

  @override
  void onHidden() {
    print('HomeController - onHidden called');
  }
}
