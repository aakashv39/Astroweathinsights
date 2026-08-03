// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/settings_controller.dart';
import 'package:AstrowayCustomer/views/settings/notificationScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/follow_astrologer_controller.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/userProfileController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/getReportScreen.dart';
import 'package:AstrowayCustomer/views/myFollowingScreen.dart';
import 'package:AstrowayCustomer/views/poojaBooking/screen/PujaCategoryScreen.dart';
import 'package:AstrowayCustomer/views/profile/editUserProfileScreen.dart';
import 'package:AstrowayCustomer/views/ReferAndEarnScreen.dart';
import 'package:AstrowayCustomer/views/settings/settingsScreen.dart';
import 'package:AstrowayCustomer/widget/CanvasStyle/wavydivider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/advancedPanchangController.dart';
import '../utils/images.dart';
import '../views/loginScreen.dart';
import 'appversionwidget.dart';

class DrawerWidget extends StatefulWidget {
  DrawerWidget({Key? key}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final splashController = Get.find<SplashController>();
  final callController = Get.put(CallController());
  final panchangController = Get.find<PanchangController>();
  final userProfileController = Get.find<UserProfileController>();
  final historyController = Get.find<HistoryController>();
  final googleTranslator = GoogleTranslator();
  final homeController = Get.find<HomeController>();
  final walletController = Get.find<WalletController>();
  final apiHelper = APIHelper();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        child: SingleChildScrollView(
          child: GetBuilder<SplashController>(builder: (splashController) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                      top: 2.w, bottom: 2.w, left: 5.w, right: 2.w),
                  color: Color(0XFF1c1210),
                  child: Container(
                    margin: EdgeInsets.only(bottom: 3.w),
                    child: splashController.currentUser?.profile == ""
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            spacing: 1.w,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      child: Container(
                                        padding: EdgeInsets.all(1),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white)),
                                        child: CircleAvatar(
                                          backgroundColor:
                                              Colors.orange.shade100,
                                          radius: 30,
                                          child: Image.asset(
                                            Images.defaultUserImage,
                                            fit: BoxFit.cover,
                                            color: Colors.orange,
                                            height: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(0),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white),
                                      child: Image.asset(
                                        Images.right,
                                        height: 20,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  spacing: 1,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 2.w),
                                    Container(
                                      padding: EdgeInsets.only(right: 1.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Flexible(
                                              child: Text(
                                                splashController.currentUser ==
                                                        null
                                                    ? "Login/Register"
                                                    : splashController
                                                                .currentUser!
                                                                .name ==
                                                            ""
                                                        ? "User"
                                                        : "${splashController.currentUser!.name}",
                                                style: Get.textTheme.bodyLarge!
                                                    .copyWith(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ).tr(),
                                            ),
                                          ),
                                          SizedBox(width: 2.w),
                                          InkWell(
                                              onTap: () async {
                                                Navigator.pop(context);
                                                bool isLogin =
                                                    await global.isLogin();
                                                if (isLogin) {
                                                  global.showOnlyLoaderDialog(
                                                      context);
                                                  await splashController
                                                      .getCurrentUserData();
                                                  global.hideLoader();
                                                  Get.to(
                                                      () => EditUserProfile());
                                                }
                                              },
                                              child: SizedBox(
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 20.sp,
                                                  color: Colors.white,
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                    splashController.currentUser == null ||
                                            splashController
                                                    .currentUser!.contactNo
                                                    .toString() ==
                                                "null" ||
                                            splashController
                                                    .currentUser!.contactNo
                                                    .toString() ==
                                                ""
                                        ? const SizedBox()
                                        : Text(
                                            '${splashController.currentUser!.countryCode}-${splashController.currentUser!.contactNo}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 16.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                    splashController.currentUser == null ||
                                            splashController
                                                    .currentUser!.email ==
                                                null ||
                                            splashController
                                                .currentUser!.email!.isEmpty
                                        ? const SizedBox()
                                        : Text(
                                            formatEmail(splashController
                                                .currentUser!.email!),
                                            style: Get.textTheme.bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.sp,
                                                    color: Colors.white),
                                          ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.all(1),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white)),
                                  child: CachedNetworkImage(
                                    imageUrl: global.buildImageUrl(
                                        splashController.currentUser?.profile),
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        radius: 40,
                                        backgroundColor: Colors.white,
                                        backgroundImage: NetworkImage(global
                                            .buildImageUrl(splashController
                                                .currentUser?.profile)),
                                      );
                                    },
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) {
                                      return CircleAvatar(
                                        backgroundColor: Colors.orange.shade100,
                                        radius: 30,
                                        child: Image.asset(
                                          Images.defaultUserImage,
                                          fit: BoxFit.cover,
                                          color: Colors.orange,
                                          height: 40,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  spacing: 1,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 2.w),
                                    Container(
                                      padding: EdgeInsets.only(right: 2.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Flexible(
                                                child: Text(
                                              splashController.currentUser ==
                                                      null
                                                  ? "Login/Register"
                                                  : splashController
                                                              .currentUser!
                                                              .name ==
                                                          ""
                                                      ? "User"
                                                      : "${splashController.currentUser!.name}",
                                              style: Get.textTheme.bodyLarge!
                                                  .copyWith(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ).tr()),
                                          ),
                                          SizedBox(width: 2.w),
                                          global.currentUserId != null
                                              ? InkWell(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    if (await global
                                                        .isLogin()) {
                                                      global
                                                          .showOnlyLoaderDialog(
                                                              context);
                                                      await splashController
                                                          .getCurrentUserData();
                                                      global.hideLoader();
                                                      Get.to(() =>
                                                          EditUserProfile());
                                                    }
                                                  },
                                                  child: SizedBox(
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ))
                                              : SizedBox()
                                        ],
                                      ),
                                    ),
                                    splashController.currentUser == null ||
                                            splashController
                                                    .currentUser!.email ==
                                                null ||
                                            splashController.currentUser!.email
                                                    .toString() ==
                                                ""
                                        ? const SizedBox()
                                        : Text(
                                            '${formatEmail(splashController.currentUser!.email.toString())}',
                                            style: Get.textTheme.bodyLarge!
                                                .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                              fontSize: 16.sp,
                                            ),
                                          ),
                                    splashController.currentUser == null ||
                                            splashController
                                                    .currentUser!.contactNo
                                                    .toString() ==
                                                "null" ||
                                            splashController
                                                    .currentUser!.contactNo
                                                    .toString() ==
                                                ""
                                        ? const SizedBox()
                                        : Text(
                                            '${splashController.currentUser!.countryCode}-${splashController.currentUser!.contactNo}',
                                            style: Get.textTheme.bodyLarge!
                                                .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.sp,
                                                    color: Colors.white),
                                          ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    )),
                              ),
                            ],
                          ),
                  ),
                ),
                SizedBox(height: 30),
                global.currentUserId != null
                    ? SizedBox()
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        padding: EdgeInsets.symmetric(vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade200,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Get.offAll(() => LoginScreen());
                            },
                            child: _drawerItem(
                                icon: CupertinoIcons.square_arrow_right,
                                title: 'Login')),
                      ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    bool isLogin = await global.isLogin();
                    if (isLogin) {
                      global.showOnlyLoaderDialog(context);
                      await splashController.getCurrentUserData();
                      await userProfileController.getZodicImg();
                      global.hideLoader();
                      Get.to(() => EditUserProfile());
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          bool isLogin = await global.isLogin();
                          if (isLogin) {
                            global.showOnlyLoaderDialog(context);
                            await splashController.getCurrentUserData();
                            await userProfileController.getZodicImg();
                            global.hideLoader();
                            Get.to(() => EditUserProfile());
                          }
                        },
                        child: _drawerItem(
                            icon: CupertinoIcons.person_alt_circle,
                            title: tr('My Profile'))),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    bool isLogin = await global.isLogin();
                    global.showOnlyLoaderDialog(context);
                    await global.splashController.getCurrentUserData();
                    await walletController.getAmount();
                    walletController.update();
                    splashController.update();
                    global.hideLoader();
                    if (isLogin) {
                      Get.to(() => AddmoneyToWallet());
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          Get.find<BottomNavigationController>()
                              .persistentTabController
                              ?.jumpToTab(4);
                        },
                        child: _drawerItem(
                            icon: CupertinoIcons.money_dollar_circle,
                            title: tr('My Wallet'))),
                  ),
                ),
                SizedBox(height: 10),
                global.currentUserId == null
                    ? SizedBox()
                    : InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          Get.find<BottomNavigationController>()
                              .persistentTabController
                              ?.jumpToTab(4);
                          Get.find<CallController>().setTabIndex(4);
                          Get.find<CallController>().update();
                          historyController.astroMallHistoryList = [];
                          historyController.astroMallHistoryList.clear();
                          historyController.isAllDataLoaded = false;
                          historyController.update();
                          await historyController.getAstroMall(
                              global.currentUserId!, false);
                          historyController.update();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          padding: EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: _drawerItem(
                              icon: Icons.shopping_bag_outlined,
                              title: tr('Order History')),
                        ),
                      ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    Navigator.pop(context);
                    await openPlayStore();
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    padding: EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade200,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: _drawerItem(
                        icon: CupertinoIcons.star,
                        title: tr(
                            'Rate ${global.getSystemFlagValue(global.systemFlagNameList.appName)}')),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            final bottomNavigationController =
                                Get.find<BottomNavigationController>();
                            bottomNavigationController.astrologerList = [];
                            bottomNavigationController.astrologerList.clear();
                            bottomNavigationController.isAllDataLoaded = false;
                            bottomNavigationController.update();
                            global.showOnlyLoaderDialog(context);
                            await bottomNavigationController.getAstrologerList(
                                isLazyLoading: false);
                            global.hideLoader();
                            Get.to(() => GetReportScreen());
                          },
                          child: _drawerItem(
                              icon: CupertinoIcons.doc_text_viewfinder,
                              title: 'Get Report')),
                      splashController.currentUser == null ||
                              splashController.currentUser == ""
                          ? const SizedBox()
                          : InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                await Get.find<HomeController>()
                                    .gethistorydetails();
                                Get.to(() => ReferAndEarnScreen());
                              },
                              child: _drawerItem(
                                  icon: CupertinoIcons.arrowshape_turn_up_right,
                                  title: tr('Invite a Friend'))),
                      InkWell(
                          onTap: () async {
                            Navigator.pop(context);
                            bool isLogin = await global.isLogin();
                            if (isLogin) {
                              final FollowAstrologerController
                                  followAstrologerController =
                                  Get.find<FollowAstrologerController>();
                              followAstrologerController.followedAstrologer
                                  .clear();
                              followAstrologerController.isAllDataLoaded =
                                  false;
                              global.showOnlyLoaderDialog(context);
                              await followAstrologerController
                                  .getFollowedAstrologerList(false);
                              global.hideLoader();
                              Get.to(() => MyFollowingScreen());
                            }
                          },
                          child: _drawerItem(
                              icon: CupertinoIcons.arrow_turn_down_right,
                              title: 'My Following')),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(children: [
                    InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                          Get.to(() => SettingListScreen());
                        },
                        child: _drawerItem(
                            icon: CupertinoIcons.settings,
                            title: 'Settings',
                            iconColor: Colors.grey[700])),
                  ]),
                ),
                SizedBox(height: 8.w),
                WavyDivider(),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      "Follow Us On",
                      style: Get.theme.textTheme.bodyMedium!.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 17.sp),
                    ).tr(),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        if (!await launchUrl(Uri.parse(
                            "${global.getSystemFlagValueForLogin(global.systemFlagNameList.facebook)}"))) {
                          throw Exception(
                              'Could not launch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.facebook)}');
                        }
                      },
                      child: Image.asset(Images.facebook,
                          fit: BoxFit.cover, height: 24.sp),
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.instra) ==
                            ""
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.instra)}"))) {
                                throw Exception(
                                    'Could not launch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.instra)}');
                              }
                            },
                            child: Image.asset(Images.instagram,
                                fit: BoxFit.cover, height: 24.sp),
                          ),
                    SizedBox(
                      width: 2.w,
                    ),
                    global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.appStore) ==
                            ""
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              log('clicked ${global.getSystemFlagValueForLogin(global.systemFlagNameList.appStore)}');
                              if (!await launchUrl(Uri.parse(
                                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.appStore)}"))) {
                                throw Exception(
                                    'Could not launch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.appStore)}');
                              }
                            },
                            child: Image.asset(Images.appstore,
                                fit: BoxFit.cover, height: 25.sp),
                          ),
                    SizedBox(
                      width: 2.w,
                    ),
                    global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.website) ==
                            ""
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              log('clicked ${global.getSystemFlagValueForLogin(global.systemFlagNameList.website)}');
                              if (!await launchUrl(Uri.parse(
                                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.website)}"))) {
                                throw Exception(
                                    'Could not launch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.website)}');
                              }
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadiusGeometry.circular(100.w),
                              child: Image.network(
                                width: 24.sp,
                                height: 24.sp,
                                global.getSystemFlagValueForLogin(
                                    global.systemFlagNameList.adminLogo),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                    SizedBox(
                      width: 2.w,
                    ),
                    global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.linkedin) ==
                            ""
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              log('clicked ${global.getSystemFlagValueForLogin(global.systemFlagNameList.linkedin)}');
                              if (!await launchUrl(Uri.parse(
                                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.linkedin)}"))) {
                                throw Exception(
                                    'Could not launch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.linkedin)}');
                              }
                            },
                            child: Image.asset(Images.linkedin,
                                fit: BoxFit.cover, height: 24.sp),
                          ),
                    SizedBox(
                      width: 2.w,
                    ),
                    global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.youtube) ==
                            ""
                        ? SizedBox()
                        : InkWell(
                            onTap: () async {
                              if (!await launchUrl(Uri.parse(
                                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.youtube)}"))) {
                                throw Exception(
                                    'Could not launch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.youtube)}');
                              }
                            },
                            child: Image.asset(Images.youTube,
                                fit: BoxFit.cover, height: 24.sp),
                          ),
                    SizedBox(width: 2.w),
                    SizedBox(width: 2.w),
                  ],
                ),
                SizedBox(height: 1.5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        child: AppVersionWidget()),
                  ],
                ),
                SizedBox(height: 8),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _drawerItem(
      {required IconData icon,
      required String title,
      Color? iconColor,
      bool isImage = false,
      String? image}) {
    return Container(
      width: 70.w,
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 8),
      child: Row(children: [
        isImage == true
            ? Image.asset(image ?? '',
                height: 20, width: 20, color: Colors.black87)
            : Icon(icon, size: 20, color: Colors.black87),
        SizedBox(width: 15),
        Text(title,
                style: Get.textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontSize: 15.sp))
            .tr(),
        Spacer(),
        Icon(
          CupertinoIcons.forward,
          size: 18,
          color: Colors.grey,
        ),
      ]),
    );
  }
}

Future<void> openPlayStore() async {
  final packageName =
      await PackageInfo.fromPlatform().then((info) => info.packageName);
  final Uri url = Uri.parse(
    "https://play.google.com/store/apps/details?id=${packageName}",
  );
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception("Could not open Play Store");
  }
}

String formatEmail(String email) {
  if (email.length <= 15) return email;

  List<String> parts = email.split('@');
  if (parts.length != 2) return email;

  String username = parts[0];
  String domain = parts[1];

  if (username.length > 10) {
    return '${username.substring(0, 10)}..@$domain';
  } else {
    return '$username@$domain';
  }
}
