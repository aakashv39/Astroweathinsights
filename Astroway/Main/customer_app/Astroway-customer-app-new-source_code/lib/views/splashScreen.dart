// ignore_for_file: must_be_immutable

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final splashController = Get.put(SplashController());
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat(); // Infinite rotation
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      alignment: Alignment.bottomLeft,
                      child: Center(
                        child: RotationTransition(
                          turns: _rotationController,
                          child: Image.asset(Images.callBackImage,
                              width: MediaQuery.of(context).size.width * 1.2,
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Image.asset(
                'assets/images/splash.png',
                height: 20.h,
              ),
              SizedBox(height: 10),
              GetBuilder<SplashController>(builder: (splashController) {
                return splashController.appName == ''
                    ? showInapploader
                    : Text(splashController.appName,
                        style: Get.textTheme.headlineSmall);
              }),
              Spacer(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: RotationTransition(
                          turns: _rotationController,
                          child: Image.asset(Images.callBackImage,
                              width: MediaQuery.of(context).size.width * 1.2,
                              fit: BoxFit.contain),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
