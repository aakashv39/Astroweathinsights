// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/dailyHoroscopeController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/languageController.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/skillController.dart';
import 'package:AstrowayCustomer/controllers/userProfileController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/callScreen.dart';
import 'package:AstrowayCustomer/views/chat/ChatRejoinBanner.dart';
import 'package:AstrowayCustomer/views/chatScreen.dart';
import 'package:AstrowayCustomer/views/historyScreen.dart';
import 'package:AstrowayCustomer/views/liveAstrologerList.dart';
import 'package:AstrowayCustomer/views/profile/editUserProfileScreen.dart';
import 'package:AstrowayCustomer/views/searchAstrologerScreen.dart';
import 'package:AstrowayCustomer/views/settings/notificationScreen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:AstrowayCustomer/widget/drawerWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/callController.dart';
import '../controllers/filtterTabController.dart';
import '../controllers/settings_controller.dart';
import '../controllers/splashController.dart';
import '../controllers/walletController.dart';
import '../utils/global.dart' as global;
import 'addMoneyToWallet.dart';
import 'call/onetooneAudio/CallRejoiningBanner.dart';
import 'call/oneToOneVideo/videocallRejoin.dart';
import 'multiDesignLayout/homescreendesign/homeScreenDesign4.dart';

class BottomNavigationBarScreen extends StatefulWidget {
  final int index;
  BottomNavigationBarScreen({this.index = 0}) : super();
  @override
  State<BottomNavigationBarScreen> createState() =>
      _BottomNavigationBarScreenState();
}

class _BottomNavigationBarScreenState extends State<BottomNavigationBarScreen> {
  int? currentIndex;

  List<IconData> iconList = [
    CupertinoIcons.home,
    CupertinoIcons.chat_bubble_text,
    Icons.live_tv,
    CupertinoIcons.phone,
    Icons.edit_calendar_sharp,
  ];

  List<String> tabList = ['Home', 'Chat', 'Live', 'Call', 'History'];

  final filtterTabController = Get.find<FiltterTabController>();
  final homeController = Get.find<HomeController>();
  final historyController = Get.find<HistoryController>();
  final liveController = Get.find<LiveController>();
  final chatController = Get.find<ChatController>();
  final splashController = Get.find<SplashController>();
  final reportController = Get.find<ReportController>();
  final skillController = Get.find<SkillController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final walletController = Get.find<WalletController>();
  final languageController = Get.find<LanguageController>();
  final cController = Get.find<ChatController>();
  final settingsController = Get.find<SettingsController>();
  final dailyHoroscopeController = Get.find<DailyHoroscopeController>();
  final userProfileController = Get.find<UserProfileController>();
  late Widget homeScreen;

  @override
  void initState() {
    super.initState();
    bottomNavigationController.persistentTabController =
        PersistentTabController(initialIndex: widget.index);
    _loadData();
    homeScreen = getHomeScreen(); // Store HomeScreen only once
  }

  void _loadData() async {
    await dailyHoroscopeController.selectZodic(0);
    await dailyHoroscopeController.getHoroscopeList(
        horoscopeId: dailyHoroscopeController.signId);
  }

  List<Widget> screens() {
    return [
      homeScreen,
      ChatScreen(flag: 0),
      LiveAstrologerListScreen(isFromBottom: true),
      CallScreen(flag: 0),
      HistoryScreen(currentIndex: bottomNavigationController.historyIndex),
    ];
  }

  Widget getHomeScreen() {
    return HomeScreenDesign4(
      userDetails: bottomNavigationController.userModel,
    );
  }

  void openBottomSheetFilter(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sort & Filter').tr(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Obx(
                    () => RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: filtterTabController.filterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          filtterTabController.selectedFilterIndex.value =
                              index;
                          filtterTabController.update();
                        },
                        tabs: List.generate(
                          filtterTabController.filtterList.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: filtterTabController
                                            .selectedFilterIndex.value ==
                                        ind
                                    ? Colors.white
                                    : Colors.grey[50],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: filtterTabController
                                                    .selectedFilterIndex
                                                    .value ==
                                                ind
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      child: Text(
                                        filtterTabController.filtterList[ind],
                                        style: TextStyle(color: Colors.black54),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: TabBarView(
                        controller: filtterTabController.filterTab,
                        children: [
                          SizedBox(
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: GetBuilder<ReportController>(
                                builder: (reportController) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: ListView.builder(
                                      itemCount:
                                          reportController.sorting.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return RadioListTile(
                                          groupValue:
                                              reportController.groupValue,
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: reportController
                                              .sorting[index].id,
                                          onChanged: (val) {
                                            reportController.groupValue = val!;

                                            reportController.update();
                                          },
                                          title: Text(
                                            reportController
                                                .sorting[index].name!,
                                          ).tr(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: GetBuilder<SkillController>(
                                builder: (skillController) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: ListView.builder(
                                      itemCount:
                                          skillController.skillList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: skillController
                                              .skillList[index].isSelected,
                                          onChanged: (value) {
                                            skillController.skillList[index]
                                                .isSelected = value!;
                                            skillController.update();
                                          },
                                          title: Text(
                                            skillController
                                                .skillList[index].name,
                                          ).tr(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: GetBuilder<LanguageController>(
                                builder: (languageController) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: ListView.builder(
                                      itemCount: languageController
                                          .languageList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: languageController
                                              .languageList[index].isSelected,
                                          onChanged: (value) {
                                            languageController
                                                .languageList[index]
                                                .isSelected = value!;
                                            languageController.update();
                                          },
                                          title: Text(
                                            languageController
                                                .languageList[index]
                                                .languageName,
                                          ).tr(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            child: RotatedBox(
                              quarterTurns: -1,
                              child: GetBuilder<FiltterTabController>(
                                builder: (filtterTabController) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: ListView.builder(
                                      itemCount:
                                          filtterTabController.gender.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: filtterTabController
                                              .gender[index].isCheck,
                                          onChanged: (value) {
                                            filtterTabController
                                                .gender[index].isCheck = value!;
                                            filtterTabController.update();
                                          },
                                          title: Text(
                                            filtterTabController
                                                .gender[index].name,
                                          ).tr(),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 5,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 0,
                            child: TextButton(
                              onPressed: () async {
                                skillController.skillFilterList = [];
                                filtterTabController.genderFilterList = [];
                                languageController.languageFilterList = [];
                                reportController.sortingFilter = null;
                                for (var i = 0;
                                    i < skillController.skillList.length;
                                    i++) {
                                  skillController.skillList[i].isSelected =
                                      false;

                                  skillController.update();
                                }
                                for (var i = 0;
                                    i < languageController.languageList.length;
                                    i++) {
                                  languageController
                                      .languageList[i].isSelected = false;

                                  languageController.update();
                                }
                                for (var i = 0;
                                    i < filtterTabController.gender.length;
                                    i++) {
                                  filtterTabController.gender[i].isCheck =
                                      false;

                                  filtterTabController.update();
                                }
                                bottomNavigationController.astrologerList = [];
                                bottomNavigationController.astrologerList
                                    .clear();
                                bottomNavigationController.isAllDataLoaded =
                                    false;
                                bottomNavigationController.skillFilterList =
                                    skillController.skillFilterList;
                                bottomNavigationController.genderFilterList =
                                    filtterTabController.genderFilterList;
                                bottomNavigationController.languageFilter =
                                    languageController.languageFilterList;
                                bottomNavigationController.applyFilter = false;
                                bottomNavigationController.update();
                                Get.back();
                                global.showOnlyLoaderDialog(context);
                                await bottomNavigationController
                                    .getAstrologerList(
                                  skills: skillController.skillFilterList,
                                  gender: filtterTabController.genderFilterList,
                                  language:
                                      languageController.languageFilterList,
                                  isLazyLoading: false,
                                );
                                global.hideLoader();

                                reportController.groupValue = 0;
                                print('done');
                                reportController.update();
                              },
                              child: Text(
                                'Reset',
                                style: TextStyle(color: Colors.black54),
                              ).tr(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GetBuilder<SkillController>(
                            builder: (skillController) {
                              return SizedBox(
                                width: 80,
                                height: 55,
                                child: TextButton(
                                  onPressed: () async {
                                    skillController.skillFilterList = [];
                                    filtterTabController.genderFilterList = [];
                                    languageController.languageFilterList = [];
                                    reportController.sortingFilter = null;
                                    for (var i = 0;
                                        i < skillController.skillList.length;
                                        i++) {
                                      if (skillController
                                              .skillList[i].isSelected ==
                                          true) {
                                        skillController.skillFilterList.add(
                                          skillController.skillList[i].id!,
                                        );
                                        skillController.update();
                                      }
                                    }
                                    for (var i = 0;
                                        i < filtterTabController.gender.length;
                                        i++) {
                                      if (filtterTabController
                                              .gender[i].isCheck ==
                                          true) {
                                        filtterTabController.genderFilterList
                                            .add(
                                          filtterTabController.gender[i].name,
                                        );
                                        filtterTabController.update();
                                      }
                                    }
                                    for (var i = 0;
                                        i <
                                            languageController
                                                .languageList.length;
                                        i++) {
                                      if (languageController
                                              .languageList[i].isSelected ==
                                          true) {
                                        languageController.languageFilterList
                                            .add(
                                          languageController
                                              .languageList[i].id!,
                                        );
                                        languageController.update();
                                      }
                                    }
                                    for (var i = 0;
                                        i < reportController.sorting.length;
                                        i++) {
                                      if (reportController.groupValue ==
                                          reportController.sorting[i].id) {
                                        reportController.sortingFilter =
                                            reportController.sorting[i].value;
                                        reportController.update();
                                      }
                                    }
                                    Get.back();
                                    bottomNavigationController.astrologerList =
                                        [];
                                    bottomNavigationController.astrologerList
                                        .clear();
                                    bottomNavigationController.isAllDataLoaded =
                                        false;
                                    bottomNavigationController.applyFilter =
                                        true;
                                    bottomNavigationController.skillFilterList =
                                        skillController.skillFilterList;
                                    bottomNavigationController
                                            .genderFilterList =
                                        filtterTabController.genderFilterList;
                                    bottomNavigationController.languageFilter =
                                        languageController.languageFilterList;
                                    bottomNavigationController.sortingFilter =
                                        reportController.sortingFilter;
                                    bottomNavigationController.update();
                                    global.showOnlyLoaderDialog(context);
                                    await bottomNavigationController
                                        .getAstrologerList(
                                      skills: skillController.skillFilterList,
                                      gender:
                                          filtterTabController.genderFilterList,
                                      language:
                                          languageController.languageFilterList,
                                      sortBy: reportController.sortingFilter,
                                      isLazyLoading: true,
                                    );
                                    global.hideLoader();

                                    skillController.addFilter(
                                      catId: cController
                                          .categoryList[cController.isSelected]
                                          .id,
                                      skills: skillController.skillFilterList,
                                      language:
                                          languageController.languageFilterList,
                                      gender:
                                          filtterTabController.genderFilterList,
                                      sortBy: reportController.sortingFilter,
                                    );
                                  },
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(color: Colors.white),
                                  ).tr(),
                                  style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                      EdgeInsets.all(8),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                      Get.theme.primaryColor,
                                    ),
                                    foregroundColor: MaterialStateProperty.all(
                                      Colors.white,
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: scaffbgcolor,
          backgroundColor: scaffbgcolor,
          iconTheme: IconThemeData(color: Colors.black),
          title: GetBuilder<BottomNavigationController>(
            builder: (bottomNavigationController) {
              return Text(bottomNavigationController.bottomNavIndex == 0
                      ? '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}'
                      : bottomNavigationController.bottomNavIndex == 1
                          ? "Chat With ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}"
                          : (bottomNavigationController.bottomNavIndex == 3
                              ? "Talk To ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}"
                              : bottomNavigationController.bottomNavIndex == 2
                                  ? "Live ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}"
                                  : "History"))
                  .tr();
            },
          ),
          actions: [
            GetBuilder<BottomNavigationController>(
              builder: (botbottomNavigationControllertom) {
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    botbottomNavigationControllertom.bottomNavIndex == 0
                        ? InkWell(
                            onTap: () async {
                              global.showOnlyLoaderDialog(context);
                              await settingsController.getNotification();
                              global.hideLoader();
                              Get.to(() => const NotificationScreen());
                            },
                            child: Icon(CupertinoIcons.bell, size: 25),
                          )
                        : SizedBox(),
                    botbottomNavigationControllertom.bottomNavIndex == 0
                        ? GetBuilder<SettingsController>(
                            builder: (settingsController) => Positioned(
                              right: 5,
                              top: -5,
                              child: settingsController.notification.isNotEmpty
                                  ? InkWell(
                                      onTap: () {
                                        settingsController.notification.clear();
                                        settingsController.getNotification();
                                        Get.to(
                                          () => const NotificationScreen(),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 15,
                                          minHeight: 15,
                                        ),
                                        child: Text(
                                          '${settingsController.notification.length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    )
                                  : const SizedBox(),
                            ),
                          )
                        : SizedBox(),
                  ],
                );
              },
            ),
            const SizedBox(width: 15),
            GetBuilder<BottomNavigationController>(
              builder: (botbottomNavigationControllertom) {
                return botbottomNavigationControllertom.bottomNavIndex == 0
                    ? InkWell(
                        onTap: () async {
                          bool isLogin = await global.isLogin();
                          global.showOnlyLoaderDialog(context);
                          await walletController.getAmount();
                          Future.wait<void>([
                            global.splashController.getCurrentUserData(),
                            walletController.getAmount(),
                          ]);
                          walletController.update();
                          splashController.update();
                          global.hideLoader();
                          if (isLogin) {
                            Get.to(() => AddmoneyToWallet());
                          }
                        },
                        child: Icon(
                          FontAwesomeIcons.wallet,
                          size: 25,
                          color: Get.theme.primaryColor,
                        ),
                      )
                    : SizedBox();
              },
            ),
            const SizedBox(width: 15),
            GetBuilder<BottomNavigationController>(
                builder: (botbottomNavigationControllertom) {
              return botbottomNavigationControllertom.bottomNavIndex == 0
                  ? GetBuilder<SplashController>(builder: (splashController) {
                      // log("My User profile image ${splashController.currentUser!.profile}");
                      return InkWell(
                          borderRadius: BorderRadius.circular(100.w),
                          onTap: () async {
                            bool isLogin = await global.isLogin();
                            if (isLogin) {
                              print(
                                  "prfile:- ${splashController.currentUser!.profile}");
                              global.showOnlyLoaderDialog(context);
                              await splashController.getCurrentUserData();
                              await userProfileController.getZodicImg();
                              global.hideLoader();
                              Get.to(() => EditUserProfile());
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CommonCachedNetworkImage(
                              height: 30,
                              width: 30,
                              borderRadius: 100.w,
                              imageUrl: (splashController
                                              .currentUser?.profile !=
                                          null &&
                                      splashController
                                          .currentUser!.profile!.isNotEmpty)
                                  ? "${splashController.currentUser!.profile}"
                                  : "https://avatar.iran.liara.run/public/9",
                            ),
                          ));
                    })
                  : SizedBox.shrink();
            }),
            const SizedBox(width: 1),
            GetBuilder<BottomNavigationController>(
              builder: (botbottomNavigationControllertom) {
                return botbottomNavigationControllertom.bottomNavIndex == 1 ||
                        botbottomNavigationControllertom.bottomNavIndex == 2 ||
                        botbottomNavigationControllertom.bottomNavIndex == 3
                    ? GestureDetector(
                        onTap: () {
                          Get.to(() => SearchAstrologerScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10, right: 15),
                          child: Icon(
                            FontAwesomeIcons.magnifyingGlass,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      )
                    : SizedBox();
              },
            ),
            GetBuilder<BottomNavigationController>(
              builder: (botbottomNavigationControllertom) {
                return botbottomNavigationControllertom.bottomNavIndex == 1 ||
                        botbottomNavigationControllertom.bottomNavIndex == 3
                    ? GestureDetector(
                        onTap: () {
                          openBottomSheetFilter(context);
                          Future.wait<void>([
                            skillController.getSkills(),
                            languageController.getLanguages(),
                          ]);
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Icon(
                                FontAwesomeIcons.filter,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                            bottomNavigationController.applyFilter
                                ? Positioned(
                                    right: 4,
                                    top: 15,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.blue,
                                      radius: 4,
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      )
                    : SizedBox();
              },
            ),
            const SizedBox(width: 10),
          ],
        ),
        drawer: DrawerWidget(),
        body: GetBuilder<BottomNavigationController>(
          builder: (bottomNavigationController) {
            return SizedBox(
              height: double.infinity,
              child: PersistentTabView(
                controller: bottomNavigationController.persistentTabController,
                onTabChanged: (index) async {
                  log('seelected index tab is ${index}');
                  await bottomNavigationController.setBottomIndex(
                    index,
                    bottomNavigationController.historyIndex,
                  );
                  if (index == 0) {
                  } else if (index == 1 || index == 3) {
                    log('list had data -> ${chatController.isSelected}');
                    if (bottomNavigationController.astrologerList.isEmpty ||
                        chatController.isSelected != 0) {
                      chatController.isSelected = 0;
                      chatController.update();
                      // Clear the list immediately so shimmer effect shows
                      bottomNavigationController.astrologerList.clear();
                      bottomNavigationController.isAllDataLoaded = false;
                      bottomNavigationController.update();

                      // Fetch data in the background without blocking UI
                      Future.microtask(() {
                        global.splashController.getCurrentUserData();
                        walletController.getAmount();
                        bottomNavigationController.getAstrologerList(
                          isLazyLoading: false,
                        );
                      });
                      walletController.update();

                      log('Selected index: ${chatController.isSelected}');
                    } else {
                      log('list has data dont reload tab ');
                    }
                  } else if (index == 2) {
                    bool isLogin = await global.isLogin();
                    log('clickeddd index: ${index}');

                    if (isLogin) {
                      Future.microtask(() {
                        bottomNavigationController.getLiveAstrologerList();
                      });
                    }
                  } else if (index == 4) {
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      //futre wait
                      global.showOnlyLoaderDialog(context);
                      historyController.walletTransactionList = [];
                      historyController.walletTransactionList.clear();
                      historyController.walletAllDataLoaded = false;
                      Future.wait<void>([
                        global.splashController.getCurrentUserData(),
                        historyController.getPaymentLogs(
                          global.currentUserId!,
                          false,
                        ),
                        historyController.getAiChatHistory(
                          global.currentUserId!,
                          false,
                        ),
                        historyController.getWalletTransaction(
                          global.currentUserId!,
                          false,
                        ),
                      ]);
                      historyController.update();
                      global.hideLoader();
                    }
                  }
                },
                tabs: List.generate(iconList.length, (index) {
                  if (index == 0) {
                    if (bottomNavigationController.isValueShow == false) {
                      bottomNavigationController.isValueShow = true;
                    }

                    return PersistentTabConfig(
                      screen: screens().elementAt(index),
                      item: ItemConfig(
                        activeForegroundColor: Colors.indigo,
                        inactiveForegroundColor: Colors.black,
                        iconSize: 23,
                        icon: Icon(iconList[index]),
                        title: tr(tabList[index]),
                      ),
                    );
                  } else if (index == 1) {
                    if (bottomNavigationController.isValueShowChat == false) {
                      bottomNavigationController.isValueShowChat = true;
                    }
                    return PersistentTabConfig(
                      screen: screens().elementAt(index),
                      item: ItemConfig(
                        activeForegroundColor: Colors.purple,
                        inactiveForegroundColor: Colors.black,
                        icon: Icon(iconList[index]),
                        title: tr(tabList[index]),
                      ),
                    );
                  } else if (index == 2) {
                    if (bottomNavigationController.isValueShowLive == false) {
                      bottomNavigationController.isValueShowLive = true;
                    }
                    return PersistentTabConfig(
                      screen: screens().elementAt(index),
                      item: ItemConfig(
                        activeForegroundColor: Colors.red,
                        inactiveForegroundColor: Colors.black,
                        title: tr(tabList[index]),
                        icon: Icon(iconList[index]),
                      ),
                    );
                  } else if (index == 3) {
                    if (bottomNavigationController.isValueShowCall == false) {
                      bottomNavigationController.isValueShowCall = true;
                    }
                    return PersistentTabConfig(
                      screen: screens().elementAt(index),
                      item: ItemConfig(
                        activeForegroundColor: Colors.pink,
                        inactiveForegroundColor: Colors.black,
                        icon: Icon(iconList[index]),
                        title: tr(tabList[index]),
                      ),
                    );
                  } else {
                    if (bottomNavigationController.isValueShowHist == false) {
                      bottomNavigationController.isValueShowHist = true;
                    }
                    return PersistentTabConfig(
                      screen: screens().elementAt(index),
                      item: ItemConfig(
                        activeForegroundColor: Colors.cyan,
                        inactiveForegroundColor: Colors.black,
                        icon: Icon(iconList[index]),
                        title: tr(tabList[index]),
                      ),
                    );
                  }
                }),
                navBarBuilder: (navBarConfig) => Style6BottomNavBar(
                  navBarDecoration: NavBarDecoration(
                      border:
                          Border(top: BorderSide(color: Colors.grey.shade200))),
                  navBarConfig: navBarConfig,
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        floatingActionButton: Container(
          width: 80.w,
          margin: EdgeInsets.symmetric(vertical: 5.h),
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: global.isCallOrChat == 1
              ? GetBuilder<ChatController>(
                  builder: (chatcontroller) => ChatRejoinBanner())
              : global.isCallOrChat == 2
                  ? GetBuilder<CallController>(
                      builder: (chatcontroller) => const Callrejoiningbanner())
                  : global.isCallOrChat == 3
                      ? GetBuilder<CallController>(
                          builder: (chatcontroller) => const Videocallrejoin())
                      : null,
        ),
      ),
    );
  }
}
