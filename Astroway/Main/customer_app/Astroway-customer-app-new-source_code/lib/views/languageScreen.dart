import 'dart:async';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../controllers/splashController.dart';

class Languagescreen extends StatefulWidget {
  Languagescreen({super.key});

  @override
  State<Languagescreen> createState() => _LanguagescreenState();
}

class _LanguagescreenState extends State<Languagescreen> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _loadSelectedLanguage();
    log('Language setup complete!');
  }

  Future<void> _loadSelectedLanguage() async {
    final completer = Completer<void>();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      Get.find<HomeController>().cIndex =
          prefs.getInt('selectedLanguageIndex') ?? 0;
      log('lang new index is -> ${Get.find<HomeController>().lan.length}');
      for (int i = 0; i < Get.find<HomeController>().lan.length; i++) {
        Get.find<HomeController>().lan[i].isSelected =
            i == Get.find<HomeController>().cIndex;
        log('lang new title is -> ${Get.find<HomeController>().lan[i].title}');
      }
      Get.find<HomeController>().update();
      completer.complete(); // Mark it done
    });

    return completer.future; // Await this to wait for the post-frame logic
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Choose Your Language').tr()),
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<HomeController>(
                builder: (homeController) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Wrap(
                                children: List.generate(
                                  homeController.lan.length,
                                      (index) {
                                    log('List lang index is -> $index');
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(10),
                                      onTap: () {
                                        homeController.cIndex = index;
                                        homeController.updateLan(
                                          homeController.cIndex,
                                        );
                                        homeController.update();
                                      },
                                      child: Container(
                                        height: 75,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(4),
                                        width: 42.w,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: homeController
                                              .lan[index].isSelected
                                              ? Color.fromARGB(
                                            255,
                                            228,
                                            217,
                                            185,
                                          )
                                              : Colors.transparent,
                                          border: Border.all(
                                            color: homeController
                                                .lan[index].isSelected
                                                ? Color.fromARGB(
                                              255,
                                              228,
                                              217,
                                              185,
                                            )
                                                : Colors.grey,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  homeController
                                                      .languageImages[index],
                                                  height: 12.w,
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 1.w),
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  homeController
                                                      .lan[index].title,
                                                  style:
                                                  Get.textTheme.bodyMedium,
                                                ),
                                                Text(
                                                  homeController
                                                      .lan[index].subTitle,
                                                  style: Get
                                                      .textTheme.bodyMedium!
                                                      .copyWith(fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            InkWell(
              onTap: () async {
                log('update index is ${Get.find<HomeController>().cIndex}');
                await updateLocale(
                  Get.find<HomeController>().cIndex,
                  Get.find<HomeController>(),
                  context,
                );
              },
              child: Container(
                width: 100.w,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Save',
                  style: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.black,
                    fontSize: 18.sp,
                  ),
                ).tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> updateLocale(
      int index, HomeController homeController, BuildContext context) async {
    if (index < 0 || index >= homeController.lan.length) return;
    final langCode = homeController.lan[index].lanCode;
    final locale = _getLocaleFromCode(langCode);
    await context.setLocale(locale);
    Get.updateLocale(locale);
    await refreshIt(homeController);
  }
  Locale _getLocaleFromCode(String code) {
    switch (code.toLowerCase()) {
      case 'en':
        return const Locale('en', 'US');
      case 'gu':
        return const Locale('gu', 'IN');
      case 'hi':
        return const Locale('hi', 'IN');
      case 'mr':
        return const Locale('mr', 'IN');
      case 'bn':
        return const Locale('bn', 'IN');
      case 'kn':
        return const Locale('kn', 'IN');
      case 'ml':
        return const Locale('ml', 'IN');
      case 'ta':
        return const Locale('ta', 'IN');
      case 'te':
        return const Locale('te', 'IN');
      default:
        return const Locale('en', 'US');
    }
  }

  Future<void> refreshIt(HomeController homeController) async {
    final splashController = Get.find<SplashController>();
    splashController.currentLanguageCode =
        homeController.lan[homeController.selectedIndex].lanCode;
    splashController.update();
    global.spLanguage = await SharedPreferences.getInstance();
    await global.spLanguage!.setString(
      'currentLanguage',
      splashController.currentLanguageCode,
    );
    await global.spLanguage!.setInt(
      'selectedLanguageIndex',
      homeController.selectedIndex,
    );

    log(
      'language code is  :- ${global.spLanguage!.getString('currentLanguage')}',
    );
    homeController.update();
    Get.back();
  }
}
