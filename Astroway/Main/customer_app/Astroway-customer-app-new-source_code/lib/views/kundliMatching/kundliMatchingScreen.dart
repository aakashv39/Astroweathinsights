// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/kundliMatching/kudliMatchingResultScreen.dart';
import 'package:AstrowayCustomer/views/kundliMatching/newMatchingScreen.dart';
import 'package:AstrowayCustomer/views/kundliMatching/openKundliScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controllers/kundliMatchingController.dart';

class KundliMatchingScreen extends StatelessWidget {
  KundliMatchingScreen({Key? key}) : super(key: key);
  final KundliMatchingController kundliMatchingController =
      Get.find<KundliMatchingController>();
  final KundliController kundliController = Get.find<KundliController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: GetBuilder<KundliMatchingController>(
          init: kundliMatchingController,
          builder: (controller) {
            return Scaffold(
              backgroundColor: scaffbgcolor,
              appBar: AppBar(
                  iconTheme: IconThemeData(color: Colors.white),
                  backgroundColor: Get.theme.primaryColor,
                  title: Text('Kundli Matching',
                          style: TextStyle(color: Colors.white))
                      .tr()),
              body: Container(
                decoration: scafdecoration,
                child: DefaultTabController(
                    length: 2,
                    initialIndex: kundliMatchingController.currentIndex,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 60,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Get.theme.primaryColor.withOpacity(0.9),
                                    Get.theme.primaryColor.withOpacity(0.4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.w),
                                border: Border.all(color: Colors.white),
                              ),
                              child: TabBar(
                                unselectedLabelColor: Colors.black,
                                labelColor: Colors.black,
                                dividerColor: Colors.transparent,
                                indicatorWeight: 0.1,
                                indicatorColor: Colors.transparent,
                                labelPadding: EdgeInsets.zero,
                                tabs: [
                                  Obx(
                                    () => kundliMatchingController
                                                .homeTabIndex.value ==
                                            0
                                        ? Container(
                                            height: Get.height,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                            child: Center(
                                                child: Text(
                                              'Open Kundli',
                                              style: TextStyle(
                                                  color:
                                                      const Color(0xFFC7FFF6)),
                                            ).tr()),
                                          )
                                        : Center(
                                            child: Text(
                                              'Open Kundli',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ).tr(),
                                          ),
                                  ),
                                  Obx(
                                    () => kundliMatchingController
                                                .homeTabIndex.value ==
                                            1
                                        ? Container(
                                            height: Get.height,
                                            width: Get.width,
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                            child: Center(
                                                child: Text('New Matching',
                                                        style: TextStyle(
                                                            color: const Color(
                                                                0xFFC7FFF6)))
                                                    .tr()),
                                          )
                                        : Center(
                                            child: Text(
                                              'New Matching',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ).tr(),
                                          ),
                                  ),
                                ],
                                onTap: (index) {
                                  global.showOnlyLoaderDialog(Get.context);
                                  kundliMatchingController
                                      .onHomeTabBarIndexChanged(index);
                                  global.hideLoader();
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child:
                              kundliMatchingController.homeTabIndex.value == 1
                                  ? NewMatchingScreen()
                                  : OpenKundliScreen(),
                        )
                      ],
                    )),
              ),
              bottomNavigationBar: kundliMatchingController
                          .homeTabIndex.value ==
                      1
                  ? Container(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Get.theme.primaryColor,
                            maximumSize:
                                Size(MediaQuery.of(context).size.width, 100),
                            minimumSize:
                                Size(MediaQuery.of(context).size.width, 48),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            bool isvalid =
                                kundliMatchingController.isValidData();
                            if (!isvalid) {
                              global.showToast(
                                message:
                                    kundliMatchingController.errorMessage ?? "",
                                textColor: global.textColor,
                                bgColor: global.toastBackGoundColor,
                              );
                            } else {
                              _showMyDialog(context);
                            }
                          },
                          child: const Text(
                            "Match Horoscope",
                            style: TextStyle(color: Colors.white),
                          ).tr(),
                        ),
                      ),
                    )
                  : const SizedBox(),
            );
          }),
    );
  }

  void _showMyDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return const MyDialog();
      },
    );
    if (result != null) {
      debugPrint('Selected Direction: $result');
    }
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog({super.key});
  @override
  _MyDialogState createState() => _MyDialogState();
}

final KundliMatchingController kundliMatchingController =
    Get.find<KundliMatchingController>();

class _MyDialogState extends State<MyDialog> {
  String direction = "South";
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Choose Direction').tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text('South'),
            leading: Radio(
              value: tr('South'),
              groupValue: direction,
              onChanged: (value) {
                setState(() {});
                direction = value as String;
              },
            ),
          ),
          ListTile(
            title: const Text('North'),
            leading: Radio(
              value: tr('North'),
              groupValue: direction,
              onChanged: (value) {
                setState(() {});
                direction = value as String;
              },
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () async {
            Get.back();
            await kundliMatchingController.addKundliMatchData(direction);
            kundliMatchingController.update();
            log('sfsfsjf');
            Get.to(() => KudliMatchingResultScreen(
                  northKundaliMatchingModel:
                      kundliMatchingController.northKundaliMatchingModel,
                  southKundaliMatchingModel:
                      kundliMatchingController.southKundaliMatchingModel,
                ));
            //  await kundliMatchingController.addKundliMatchData();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
