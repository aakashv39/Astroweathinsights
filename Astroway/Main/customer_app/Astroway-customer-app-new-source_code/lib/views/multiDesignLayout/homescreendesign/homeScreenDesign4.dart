// ignore_for_file: must_be_immutable, deprecated_member_use, invalid_use_of_protected_member, unused_element

import 'dart:async';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/astrologerCategoryController.dart';
import 'package:AstrowayCustomer/controllers/astrologyBlogController.dart';
import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/dailyHoroscopeController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/model/kundli_model.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/utils/fonts.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/RemcommendedPujaViewAllScreen.dart';
import 'package:AstrowayCustomer/views/astroBlog/astrologyBlogListScreen.dart';
import 'package:AstrowayCustomer/views/astromall/astromallScreen.dart';
import 'package:AstrowayCustomer/views/astromall/productDetailScreen.dart';
import 'package:AstrowayCustomer/views/chatwithAI/controllers/aiChatController.dart';
import 'package:AstrowayCustomer/views/kudali/kundliScreen.dart';
import 'package:AstrowayCustomer/views/kundliMatching/kundliMatchingScreen.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/astroShopwidget.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/astroinNewswidget.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/astrologyCategoriesWidget.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/behindtheScene.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/bottomInfoCard.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/devotionalBlogWidget.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/panchangOverviewWidget.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/topRatedAstroWidget.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/userInfoCard.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/watchAstrologyVideoWidget.dart';
import 'package:AstrowayCustomer/views/panchang/panchangScreen.dart';
import 'package:AstrowayCustomer/views/paymentInformationScreen.dart';
import 'package:AstrowayCustomer/views/recommendedpujadetailscreen.dart';
import 'package:AstrowayCustomer/views/stories/viewStories.dart';
import 'package:AstrowayCustomer/widget/commonDialogWidget%20copy.dart';
import 'package:AstrowayCustomer/widget/completeProfileDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controllers/advancedPanchangController.dart';
import '../../../controllers/chatController.dart';
import '../../../controllers/splashController.dart';
import '../../../utils/CornerBanner.dart';
import '../../../utils/services/api_helper.dart';
import '../../RemcommendedViewAllScreen.dart';
import '../../callIntakeFormScreen.dart';
import '../../daily_horoscope/dailyHoroscopeScreen.dart';
import '../../poojaBooking/controller/poojaController.dart';
import '../../poojaBooking/screen/PujaCategoryScreen.dart';
import '../../poojaBooking/screen/addpoojadeveryaddress.dart';
import '../home_widget/cosmicAIIntelligence.dart';

class HomeScreenDesign4 extends StatefulWidget {
  final KundliModel? userDetails;
  HomeScreenDesign4({a, o, this.userDetails}) : super();

  @override
  State<HomeScreenDesign4> createState() => _HomeScreenDesign4State();
}

class _HomeScreenDesign4State extends State<HomeScreenDesign4> {
  final homeController = Get.find<HomeController>();
  final astrologerCategoryController = Get.find<AstrologerCategoryController>();
  final bottomControllerMain = Get.find<BottomNavigationController>();
  final liveController = Get.find<LiveController>();
  final kundliController = Get.find<KundliController>();
  final panchangController = Get.find<PanchangController>();
  final splashController = Get.find<SplashController>();
  final walletController = Get.find<WalletController>();
  final astromallController = Get.find<AstromallController>();
  final callController = Get.find<CallController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final chatController = Get.find<ChatController>();
  final aicontroller = Get.put(AiChatController());
  final pujaController = Get.find<PoojaController>();
  final dailyHoroscopeController = Get.find<DailyHoroscopeController>();
  final apiHelper = APIHelper();

  List<Color> listcolor = [
    Colors.red.shade50,
    Colors.green.shade50,
    Colors.blue.shade50,
  ];
  final pageController = PageController();
  ValueNotifier<int> viewer = ValueNotifier<int>(0);
  Timer? autoScrollTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAppVersion();
      Future.wait<void>([
        homeController.getAllStories(),
        homeController.gethistorydetails(),
        pujaController.getCustomPujaList(),
        bottomNavigationController.getAstrologerList(
          isLazyLoading: false,
        ),
      ]);
    });
    startAutoScroll();
    _initDialog();
  }

  void _initDialog() async {
    bool? isProfileUpdated = global.sp!.getBool("isProfileUpdated") ?? false;
    bool isLogin = await global.checkLogin();
    if (!isProfileUpdated && isLogin) {
      showCompleteProfileDialog(context);
    }
    String? ipadddress = await apiHelper.getPublicIPAddress();
    panchangController.getPanchangVedic(DateTime.now(), ipadddress);
  }

  @override
  void dispose() {
    autoScrollTimer?.cancel();
    pageController.dispose();
    viewer.dispose();
    super.dispose();
  }

  void startAutoScroll() {
    autoScrollTimer = Timer.periodic(Duration(seconds: 4), (_) {
      if (!pageController.hasClients) return;
      int nextPage = (viewer.value + 1) % homeController.bannerList.length;
      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future fetchAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String myappLocalversion =
        global.getSystemFlagValueForLogin(global.systemFlagNameList.appVersion);
    print('appversion from web is $myappLocalversion');
    print('appversion from device local is ${packageInfo.version}');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime lastCheckedTime = DateTime.fromMillisecondsSinceEpoch(
        prefs.getInt('lastUpdateCheck') ?? 0);
    // Check if 24 hours have passed since the last check
    if (DateTime.now().difference(lastCheckedTime).inHours >= 24) {
      if (_isUpdateAvailable(myappLocalversion, packageInfo.version)) {
        showCommonDialog(
          title: "Update Available",
          subtitle:
              "A new version (${global.getSystemFlagValueForLogin(global.systemFlagNameList.appVersion)}) is available. Please update.",
          primaryButtonText: "Update",
          secondaryButtonText: "Later",
          onPrimaryPressed: () async {
            final appUrl = Platform.isAndroid
                ? "https://play.google.com/store/apps/details?id=${global.getSystemFlagValueForLogin(global.systemFlagNameList.androidpackage)}"
                : "https://apps.apple.com/app/${global.getSystemFlagValueForLogin(global.systemFlagNameList.iOSpackage)}";
            if (await canLaunch(appUrl)) {
              await launch(appUrl);
              Get.back();
            } else {
              throw "Could not launch $appUrl";
            }
          },
          onSecondaryPressed: () {
            Get.back();
          },
        );
        prefs.setInt('lastUpdateCheck', DateTime.now().millisecondsSinceEpoch);
      }
    }
  }

  bool _isUpdateAvailable(String webVersion, String localVersion) {
    List<int> webVer = webVersion.split('.').map(int.parse).toList();
    List<int> localVer = localVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < webVer.length; i++) {
      if (webVer[i] > localVer[i]) return true;
      if (webVer[i] < localVer[i]) return false;
    }
    return false;
  }

  void _logedIn(context, isLogin, index, audio, dynamic charge) async {
    if (isLogin) {
      if (bottomNavigationController.astrologerList[index].call_sections
              .toString() ==
          "0") {
        Get.snackbar("Note",
            "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Call",
            backgroundColor: Colors.orange, colorText: Colors.white);
      } else {
        //_checkAstrologerAvailability(index);
        await bottomNavigationController.getAstrologerbyId(
            bottomNavigationController.astrologerList[index].id);
        print(
            'charge${global.splashController.currentUser!.walletAmount! * 5}');
        if (double.parse(charge.toString()) * 5.0 <=
                double.parse(global.splashController.currentUser!.walletAmount!
                    .toString()) ||
            bottomNavigationController.astrologerList[index].isFreeAvailable ==
                true) {
          await bottomNavigationController.checkAlreadyInReqForCall(
              bottomNavigationController.astrologerList[index].id);
          if (bottomNavigationController.isUserAlreadyInCallReq == false) {
            if (bottomNavigationController.astrologerList[index].callStatus ==
                "Online") {
              global.showOnlyLoaderDialog(context);

              await Get.to(() => CallIntakeFormScreen(
                    astrologerProfile: bottomNavigationController
                        .astrologerList[index].profileImage
                        .toString(),
                    type: audio ? "Call" : "Videocall",
                    astrologerId:
                        bottomNavigationController.astrologerList[index].id,
                    astrologerName: bottomNavigationController
                        .astrologerList[index].name
                        .toString(),
                    isFreeAvailable: bottomNavigationController
                        .astrologerList[index].isFreeAvailable,
                    rate: audio
                        ? bottomNavigationController
                            .astrologerList[index].charge
                            .toString()
                        : bottomNavigationController
                            .astrologerList[index].videoCallRate
                            .toString(),
                  ));

              global.hideLoader();
            } else if (bottomNavigationController
                        .astrologerList[index].callStatus ==
                    "Offline" ||
                bottomNavigationController.astrologerList[index].callStatus ==
                    "Busy" ||
                bottomNavigationController.astrologerList[index].callStatus ==
                    "Wait Time") {
              bottomNavigationController.dialogForJoinInWaitList(
                  context,
                  bottomNavigationController.astrologerList[index].name
                      .toString(),
                  true,
                  charge.toString(),
                  bottomNavigationController.astrologerList[index].profileImage
                      .toString());
            }
          } else {
            bottomNavigationController.dialogForNotCreatingSession(context);
          }
        } else {
          global.showOnlyLoaderDialog(context);
          await walletController.getAmount();
          global.hideLoader();
          openBottomSheetRechrage(context, (charge * 5).toString(),
              '${bottomNavigationController.astrologerList[index].name}');
        }
      }
    }
  }

  void openBottomSheetRechrage(
      BuildContext context, String minBalance, String astrologer) {
    Get.bottomSheet(
      Container(
        height: 40.h,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.85,
                                    child: minBalance != ''
                                        ? (global.getSystemFlagValueForLogin(
                                                    global.systemFlagNameList
                                                        .walletType) ==
                                                "Wallet"
                                            ? Text('Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start call with $astrologer ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily:
                                                            'Poppins-Regular',
                                                        color: Colors.red))
                                                .tr()
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      'Minimum balance of 5 minutes($minBalance)',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          color: Colors.red)),
                                                  SizedBox(
                                                    width: 0.4.w,
                                                  ),
                                                  Image.network(
                                                    global.getSystemFlagValueForLogin(
                                                        global
                                                            .systemFlagNameList
                                                            .coinIcon),
                                                    height: 1.2.h,
                                                  ),
                                                  Text(
                                                      " is required to start call with $astrologer ",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily:
                                                              'Poppins-Regular',
                                                          color: Colors.red))
                                                ],
                                              ))
                                        : const SizedBox(),
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: minBalance == ''
                                          ? const EdgeInsets.only(top: 8)
                                          : const EdgeInsets.only(top: 0),
                                      child: Icon(Icons.close, size: 18),
                                    ),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 5),
                                child: Text('Recharge Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                    .tr(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.lightbulb_rounded,
                                        color: Get.theme.primaryColor,
                                        size: 13),
                                  ),
                                  Expanded(
                                      child: (global.getSystemFlagValueForLogin(
                                                  global.systemFlagNameList
                                                      .walletType) ==
                                              "Wallet"
                                          ? Text(
                                              'Minimum balance required ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontFamily: 'Poppins-Regular',
                                              )).tr()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    'Minimum balance required $minBalance',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontFamily:
                                                          'Poppins-Regular',
                                                    )),
                                                SizedBox(
                                                  width: 0.4.w,
                                                ),
                                                Image.network(
                                                  global
                                                      .getSystemFlagValueForLogin(
                                                          global
                                                              .systemFlagNameList
                                                              .coinIcon),
                                                  height: 1.2.h,
                                                ),
                                              ],
                                            ))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3.8 / 2.3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: walletController.rechrage.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => PaymentInformationScreen(
                              flag: 0,
                              amount: double.parse(
                                  walletController.payment[index])));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: global.getSystemFlagValueForLogin(global
                                            .systemFlagNameList.walletType) ==
                                        "Wallet"
                                    ? Text(
                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.rechrage[index]}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${walletController.rechrage[index]}',
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Poppins-Regular',
                                            ),
                                          ),
                                          SizedBox(
                                            width: 0.4.w,
                                          ),
                                          Image.network(
                                            global.getSystemFlagValueForLogin(
                                                global.systemFlagNameList
                                                    .coinIcon),
                                            height: 1.2.h,
                                          ),
                                        ],
                                      )),
                          ),
                        ),
                      );
                    }))
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
        bool isExit = await homeController.onBackPressed();
        if (isExit) {
          exit(0);
        }
        return isExit;
      },
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        body: RefreshIndicator(
          onRefresh: () async {
            String? ipadddress = await apiHelper.getPublicIPAddress();
            await Future.wait<void>([
              global.refreshUserFCM(),
              homeController.getBanner(),
              homeController.getBlog(),
              homeController.getAstroNews(),
              homeController.getMyOrder(),
              panchangController.getPanchangVedic(DateTime.now(), ipadddress),
              homeController.getAstrologyVideos(),
              homeController.getClientsTestimonals(),
              homeController.getAllStories(),
              homeController.getrecomendedProductList(),
              homeController.getrecomendedPujaList(),
              bottomControllerMain.getLiveAstrologerList(),
              astromallController.getAstromallCategory(false),
              global.splashController.getCurrentUserData(),
              walletController.getAmount(),
              bottomNavigationController.getAstrologerList(isLazyLoading: true),
              pujaController.getCustomPujaList(),
            ]);
          },
          child: GetBuilder<BottomNavigationController>(
              builder: (bottomController) {
            return Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      UserInfoCard(),
                      //------------FreeService-----------------------
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 6, horizontal: 2.w),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GetBuilder<KundliController>(
                                      builder: (kundliController) {
                                        return GestureDetector(
                                          onTap: () async {
                                            bool isLogin =
                                                await global.isLogin();
                                            if (isLogin) {
                                              Get.to(
                                                  () => PujaCategoryScreen());
                                            }
                                          },
                                          child: Container(
                                            height: 10.h,
                                            width: 10.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFffe8e5),
                                              borderRadius:
                                                  BorderRadius.circular(2.w),
                                              border: Border.all(
                                                width: 0.3,
                                                color: Get.theme.primaryColor,
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                /// Image with Shimmer effect
                                                CachedNetworkImage(
                                                  height: 5.h,
                                                  width: 5.h,
                                                  imageUrl: global.buildImageUrl(
                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.puja)}'),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Icon(
                                                              Icons.no_accounts,
                                                              size: 20),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      height: 5.h,
                                                      width: 5.h,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                                ),

                                                SizedBox(height: 1.w),

                                                /// Text with Shimmer effect
                                                Text(
                                                  'Puja\nBooking',
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                    height: 1,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0,
                                                    color: Colors
                                                        .black, // Needed for shimmer effect
                                                  ),
                                                ).tr(),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        Get.to(() => DailyHoroscopeScreen());
                                      },
                                      child: Container(
                                          height: 10.h,
                                          width: 10.h,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.3,
                                                  color:
                                                      Get.theme.primaryColor),
                                              color: Color(0xFFfff7df),
                                              borderRadius:
                                                  BorderRadius.circular(2.w)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: SizedBox(
                                                  height: 5.h,
                                                  width: 5.h,
                                                  child: ClipRRect(
                                                    clipBehavior: Clip.none,
                                                    child: CachedNetworkImage(
                                                      imageUrl:
                                                          global.buildImageUrl(
                                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.dailyHoroscope)}'),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(
                                                              Icons.no_accounts,
                                                              size: 20),
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  Skeletonizer(
                                                        enabled: true,
                                                        child: Container(
                                                          height: 5.h,
                                                          width: 5.h,
                                                          color: Colors.white,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 1.w),
                                              Text(
                                                'Daily\nHoroscope',
                                                textAlign: TextAlign.center,
                                                style: Get
                                                    .theme.textTheme.titleSmall!
                                                    .copyWith(
                                                  height: 1,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 0,
                                                ),
                                              ).tr(),
                                            ],
                                          )),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GetBuilder<KundliController>(
                                        builder: (kundliController) {
                                      return GestureDetector(
                                          onTap: () async {
                                            bool isLogin =
                                                await global.isLogin();
                                            if (isLogin) {
                                              global.showOnlyLoaderDialog(
                                                  Get.context);
                                              await kundliController
                                                  .getKundliList();
                                              global.hideLoader();
                                              Get.to(() => KundaliScreen());
                                            }
                                          },
                                          child: Container(
                                            height: 10.h,
                                            width: 10.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.3,
                                                    color:
                                                        Get.theme.primaryColor),
                                                color: Color(0xFFffe8e5),
                                                borderRadius:
                                                    BorderRadius.circular(2.w)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 5.h,
                                                  width: 5.h,
                                                  imageUrl: global.buildImageUrl(
                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.freeKundli)}'),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Icon(Icons.no_accounts,
                                                          size: 20),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      height: 5.h,
                                                      width: 5.h,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                                ),
                                                SizedBox(height: 1.w),
                                                Text(
                                                  'Free\nKundali',
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                    height: 1,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0,
                                                  ),
                                                ).tr(),
                                              ],
                                            ),
                                          ));
                                    }),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    GetBuilder<KundliController>(
                                        builder: (kundliController) {
                                      return GestureDetector(
                                          onTap: () async {
                                            final blogController =
                                                Get.find<BlogController>();
                                            blogController.astrologyBlogs = [];
                                            blogController.astrologyBlogs
                                                .clear();
                                            blogController.isAllDataLoaded =
                                                false;
                                            blogController.update();
                                            await blogController
                                                .getAstrologyBlog("", false);
                                            Get.to(() => AstrologyBlogScreen());
                                          },
                                          child: Container(
                                            height: 10.h,
                                            width: 10.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.3,
                                                    color:
                                                        Get.theme.primaryColor),
                                                color: Color(0xFFFFF2DF),
                                                borderRadius:
                                                    BorderRadius.circular(2.w)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 5.h,
                                                  width: 5.h,
                                                  imageUrl: global.buildImageUrl(
                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.bloc)}'),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Icon(Icons.no_accounts,
                                                          size: 20),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      height: 5.h,
                                                      width: 5.h,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                                ),
                                                SizedBox(height: 1.w),
                                                Text(
                                                  'Astrology\nBlogs',
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                    height: 1,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0,
                                                  ),
                                                ).tr(),
                                              ],
                                            ),
                                          ));
                                    }),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GetBuilder<KundliController>(
                                        builder: (kundliController) {
                                      return GestureDetector(
                                          onTap: () async {
                                            global.showOnlyLoaderDialog(
                                                Get.context);
                                            await kundliController
                                                .getKundliList();
                                            global.hideLoader();
                                            Get.to(
                                                () => KundliMatchingScreen());
                                          },
                                          child: Container(
                                            height: 10.h,
                                            width: 10.h,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.3,
                                                    color:
                                                        Get.theme.primaryColor),
                                                color: Color(0xFFe7ffdf),
                                                borderRadius:
                                                    BorderRadius.circular(2.w)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                CachedNetworkImage(
                                                  height: 5.h,
                                                  width: 5.h,
                                                  imageUrl: global.buildImageUrl(
                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.kundliMatching)}'),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Icon(Icons.no_accounts,
                                                          size: 20),
                                                  placeholder: (context, url) =>
                                                      Center(
                                                          child: Skeletonizer(
                                                    enabled: true,
                                                    child: Container(
                                                      height: 5.h,
                                                      width: 5.h,
                                                      color: Colors.white,
                                                    ),
                                                  )),
                                                ),
                                                SizedBox(height: 1.w),
                                                Text(
                                                  'Kundali\nMatching',
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                    height: 1,
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w400,
                                                    letterSpacing: 0,
                                                  ),
                                                ).tr(),
                                              ],
                                            ),
                                          ));
                                    }),
                                  ],
                                ),
                                Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        DateTime dateBasic = DateTime.now();
                                        int formattedYear = int.parse(
                                            DateFormat('yyyy')
                                                .format(dateBasic));
                                        int formattedDay = int.parse(
                                            DateFormat('dd').format(dateBasic));
                                        int formattedMonth = int.parse(
                                            DateFormat('MM').format(dateBasic));
                                        int formattedHour = int.parse(
                                            DateFormat('HH').format(dateBasic));
                                        int formattedMint = int.parse(
                                            DateFormat('mm').format(dateBasic));

                                        global.showOnlyLoaderDialog(context);
                                        String? ipadddress = await apiHelper
                                            .getPublicIPAddress();
                                        // await kundliController
                                        //     .getBasicPanchangDetail(
                                        //         day: formattedDay,
                                        //         hour: formattedHour,
                                        //         min: formattedMint,
                                        //         month: formattedMonth,
                                        //         year: formattedYear,
                                        //         lat: 21.1255,
                                        //         lon: 73.1122,
                                        //         tzone: 5);
                                        panchangController.getPanchangVedic(
                                            DateTime.now(), ipadddress);
                                        global.hideLoader();
                                        Get.to(() => PanchangScreen());
                                      },
                                      child: Container(
                                        height: 10.h,
                                        width: 10.h,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0.3,
                                                color: Get.theme.primaryColor),
                                            color: Color(0xFFfff7df),
                                            borderRadius:
                                                BorderRadius.circular(2.w)),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            CachedNetworkImage(
                                              height: 5.h,
                                              width: 5.h,
                                              imageUrl: global.buildImageUrl(
                                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.todayPanchang)}'),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                      Icons.no_accounts,
                                                      size: 20),
                                              placeholder: (context, url) =>
                                                  Center(
                                                      child: Skeletonizer(
                                                enabled: true,
                                                child: Container(
                                                  height: 5.h,
                                                  width: 5.h,
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ),
                                            SizedBox(height: 1.w),
                                            Text(
                                              'Today\nPanchang',
                                              textAlign: TextAlign.center,
                                              style: Get
                                                  .theme.textTheme.titleSmall!
                                                  .copyWith(
                                                height: 1,
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                letterSpacing: 0,
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      ///Stories

                      SizedBox(height: 1.h),
                      GetBuilder<HomeController>(builder: (homeController) {
                        return Column(
                          children: [
                            homeController.allStories.length == 0
                                ? SizedBox()
                                : Container(
                                    margin: EdgeInsets.only(left: 10),
                                    height: 12.h,
                                    child: ListView.builder(
                                        shrinkWrap: false,
                                        itemCount:
                                            homeController.allStories.length,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: EdgeInsets.only(left: 4),
                                            alignment: Alignment.center,
                                            child: InkWell(
                                                onTap: () {
                                                  homeController
                                                      .getAstroStory(
                                                          homeController
                                                              .allStories[index]
                                                              .astrologerId
                                                              .toString())
                                                      .then((value) {
                                                    Get.to(() =>
                                                        ViewStoriesScreen(
                                                          profile:
                                                              "${homeController.allStories[index].profileImage}",
                                                          name: homeController
                                                              .allStories[index]
                                                              .name
                                                              .toString(),
                                                          isprofile: false,
                                                          astroId: int.parse(
                                                              homeController
                                                                  .allStories[
                                                                      index]
                                                                  .astrologerId
                                                                  .toString()),
                                                        ));
                                                  });
                                                },
                                                child: Column(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor: homeController
                                                                  .allStories[
                                                                      index]
                                                                  .allStoriesViewed
                                                                  .toString() ==
                                                              "1"
                                                          ? Colors.grey
                                                          : Colors.green,
                                                      child: homeController
                                                                      .allStories[
                                                                          index]
                                                                      .profileImage !=
                                                                  null &&
                                                              homeController
                                                                  .allStories[
                                                                      index]
                                                                  .profileImage!
                                                                  .isNotEmpty
                                                          ? CircleAvatar(
                                                              radius: 27,
                                                              backgroundColor: Get
                                                                  .theme
                                                                  .primaryColor,
                                                              backgroundImage:
                                                                  CachedNetworkImageProvider(
                                                                      global.buildImageUrl(
                                                                          "${homeController.allStories[index].profileImage}")),
                                                            )
                                                          : CircleAvatar(
                                                              radius: 27,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              backgroundImage:
                                                                  AssetImage(
                                                                Images
                                                                    .deafultUser,
                                                              ),
                                                            ),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 16.w,
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.center,
                                                        homeController
                                                            .allStories[index]
                                                            .name
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontSize: 15.sp),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          );
                                        }),
                                  ),
                          ],
                        );
                      }),
                      SizedBox(
                        height: 1.h,
                      ),
                      // Custom puja modeule
                      GetBuilder<PoojaController>(
                        builder: (pujaController) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              pujaController.custompoojalist == null ||
                                      pujaController.custompoojalist!.isEmpty
                                  ? SizedBox()
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        pujaController.custompoojalist ==
                                                    null ||
                                                pujaController
                                                    .custompoojalist!.isEmpty
                                            ? SizedBox()
                                            : Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 5.w,
                                                    vertical: 1.w),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Suggested Puja',
                                                      style: Get
                                                          .theme
                                                          .primaryTextTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ).tr(),
                                                  ],
                                                ),
                                              ),
                                        SizedBox(height: 1.h),
                                        Container(
                                          height: 20.h,
                                          margin: EdgeInsets.only(left: 2.w),
                                          padding: EdgeInsets.all(2.w),
                                          child: ListView.builder(
                                            itemCount: pujaController
                                                .custompoojalist?.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              final puja = pujaController
                                                  .custompoojalist![index];
                                              return Container(
                                                width: 60.w,
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                      color:
                                                          Colors.grey.shade300),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Top Row: Title + Icons
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            puja.pujaTitle ??
                                                                'No Title',
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                            ),
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            // Accept Icon
                                                            InkWell(
                                                              onTap: () async {
                                                                // Handle purchase here
                                                                Get.to(
                                                                  () =>
                                                                      AddPoojaDeliveryAddress(
                                                                    selectedpackage:
                                                                        null,
                                                                    poojadetail:
                                                                        pujaController
                                                                            .custompoojalist![index],
                                                                    index:
                                                                        index,
                                                                    isfrommycustomproduct:
                                                                        true,
                                                                  ),
                                                                );
                                                              },
                                                              child: Icon(
                                                                  Icons
                                                                      .check_circle,
                                                                  color: Colors
                                                                      .green),
                                                            ),
                                                            SizedBox(width: 6),
                                                            // Delete Icon
                                                            InkWell(
                                                              onTap: () {
                                                                showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          AlertDialog(
                                                                    title: Text(
                                                                        "Confirm Deletion"),
                                                                    content: Text(
                                                                        "Are you sure you want to delete this pooja?"),
                                                                    actions: [
                                                                      TextButton(
                                                                        onPressed:
                                                                            () =>
                                                                                Navigator.pop(context),
                                                                        child: Text(
                                                                            "Cancel"),
                                                                      ),
                                                                      TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          pujaController.deletePooja(pujaController
                                                                              .custompoojalist![index]
                                                                              .pujaSuggestedId);
                                                                          Get.back();
                                                                        },
                                                                        child: Text(
                                                                            "Delete",
                                                                            style:
                                                                                TextStyle(color: Colors.red)),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                );
                                                              },
                                                              child: Icon(
                                                                  Icons.cancel,
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),

                                                    SizedBox(height: 8),

                                                    // Price
                                                    Text(
                                                      'Price: ₹${puja.pujaPrice ?? 'N/A'}',
                                                      style: TextStyle(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),

                                                    SizedBox(height: 6),
                                                    Text(
                                                      'Start Date: ${DateFormat("dd-MMM-yyyy h:mma").format(puja.pujaStartDatetime ?? DateTime.now())}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color:
                                                              Colors.black45),
                                                    ),

                                                    // Astrologer name
                                                    Text(
                                                      'By ${puja.astrologername ?? 'Astrologer'}',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          );
                        },
                      ),

                      //--------------------------------------TOP BANNER-----------------------------------------------------------------------------

                      GetBuilder<HomeController>(
                        builder: (homeController) {
                          return homeController.bannerList.isEmpty
                              ? const SizedBox()
                              : Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 25.h,
                                  child: Stack(
                                    children: [
                                      PageView.builder(
                                        controller: pageController,
                                        itemCount:
                                            homeController.bannerList.length,
                                        onPageChanged: (index) {
                                          viewer.value = index;
                                        },
                                        itemBuilder: (context, index) {
                                          final banner =
                                              homeController.bannerList[index];
                                          return GestureDetector(
                                            onTap: () async {
                                              if (banner.bannerType ==
                                                  'Astrologer') {
                                                global.showOnlyLoaderDialog(
                                                    context);
                                                bottomController.astrologerList
                                                    .clear();
                                                bottomController
                                                    .isAllDataLoaded = false;
                                                bottomController.update();
                                                await bottomController
                                                    .getAstrologerList(
                                                        isLazyLoading: false);
                                                global.hideLoader();
                                                bottomController
                                                    .persistentTabController!
                                                    .jumpToTab(1);
                                              } else if (banner.bannerType ==
                                                  'Astroshop') {
                                                final AstromallController
                                                    astromallController =
                                                    Get.find<
                                                        AstromallController>();
                                                astromallController
                                                    .astroCategory
                                                    .clear();
                                                astromallController
                                                    .isAllDataLoaded = false;
                                                astromallController.update();
                                                global.showOnlyLoaderDialog(
                                                    context);
                                                await astromallController
                                                    .getAstromallCategory(
                                                        false);
                                                global.hideLoader();
                                                Get.to(() => AstromallScreen());
                                              }
                                            },
                                            child: CachedNetworkImage(
                                              imageUrl: global.buildImageUrl(
                                                  '${banner.bannerImage}'),
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return homeController
                                                        .checkBannerValid(
                                                  startDate: banner.fromDate,
                                                  endDate: banner.toDate,
                                                )
                                                    ? Card(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  imageProvider,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        color: Colors.green);
                                              },
                                              placeholder: (context, url) =>
                                                  Skeletonizer(
                                                enabled: true,
                                                child: Container(
                                                  height: 25.h,
                                                  width: double.infinity,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) => Card(
                                                child: Container(
                                                  color: Colors.grey.shade400,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(Icons.error,
                                                            color: Colors.red,
                                                            size: 30.sp),
                                                        Text(
                                                          'banner Loading error',
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                      // Optional: Dot Indicator
                                      Positioned(
                                        bottom: 8,
                                        left: 0,
                                        right: 0,
                                        child: ValueListenableBuilder<int>(
                                          valueListenable: viewer,
                                          builder: (context, value, _) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(
                                                homeController
                                                    .bannerList.length,
                                                (index) => Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(horizontal: 2),
                                                  width:
                                                      value == index ? 10 : 6,
                                                  height:
                                                      value == index ? 10 : 6,
                                                  decoration: BoxDecoration(
                                                    color: value == index
                                                        ? Colors.white
                                                        : Colors.grey,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                        },
                      ),

                      SizedBox(height: 5),
                      GetBuilder<HomeController>(
                        builder: (homecontroller) =>
                            homecontroller.recomendedList != null &&
                                    homecontroller.recomendedList != '' &&
                                    homecontroller.recomendedList!.length > 0
                                ? getRecommendedView(homecontroller)
                                : SizedBox(),
                      ),
                      SizedBox(height: 5),
                      GetBuilder<HomeController>(
                        builder: (homecontroller) =>
                            homecontroller.pujarecomendedList != null &&
                                    homecontroller.pujarecomendedList != '' &&
                                    homecontroller.pujarecomendedList!.length >
                                        0
                                ? getRecommendedPujaView(homecontroller)
                                : SizedBox(),
                      ),
                      //---------- TOP RATED ASTROLOGERS-----------------------
                      TopRatedAstrologersWidget(
                          bottomNavigationController:
                              bottomNavigationController),
                      //----------Todays Panchang-----------------------
                      GetBuilder<PanchangController>(
                          builder: (panchangController) {
                        return PanchangOverviewWidget(
                          panchangController: panchangController,
                        );
                      }),

                      CosmicAIIntelligence(),
                      //------------Astrologers Categories--------------
                      AstrologyCategoriesWidget(
                          bottomNavigationController:
                              bottomNavigationController,
                          chatController: chatController),

                      // --------------------Shop Now------------------------------
                      SizedBox(height: 5),
                      AstroShopWidget(),
                      //---------- Devotional Blog-------------------
                      DevotionalBlogWidget(),
                      //-------------BEHIND THE SCHENE-------------------
                      global.getSystemFlagValueForLogin(
                                  global.systemFlagNameList.behindScenes) ==
                              ""
                          ? SizedBox.shrink()
                          : BehindTheSceneWidget(),

                      //------------Astro in news--------------------
                      AstroInNewsWidget(),
                      //------------WATCH ASTROLOGY VIDEO--------------------
                      AstrologerVideosWidget(),
                      SizedBox(height: 10),
                      BottomInfoCard()
                    ],
                  ),
                ),
                // //chat with astrologer
                // Container(
                //   margin: EdgeInsets.only(top: 6, bottom: 30),
                //   width: 100.w,
                //   height: 20.h,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       InkWell(
                //         onTap: () async {
                //           global.showOnlyLoaderDialog(context);
                //           bottomController.astrologerList = [];
                //           bottomController.astrologerList.clear();
                //           bottomController.isAllDataLoaded = false;
                //           bottomController.update();
                //           await bottomController.getAstrologerList(
                //               isLazyLoading: false);
                //           global.hideLoader();
                //           bottomNavigationController.persistentTabController!
                //               .jumpToTab(1);
                //         },
                //         child: Container(
                //             width: Adaptive.w(43),
                //             decoration: BoxDecoration(
                //               color: Get.theme.primaryColor,
                //               borderRadius: BorderRadius.all(
                //                 Radius.circular(4.w),
                //               ),
                //             ),
                //             child: Container(
                //               padding: EdgeInsets.only(left: 1.5.w),
                //               height: 6.h,
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(
                //                     FontAwesomeIcons.solidCommentDots,
                //                     size: 14.sp,
                //                     color: Colors.white,
                //                   ),
                //                   Padding(
                //                     padding: EdgeInsets.only(left: 2.w),
                //                     child: FittedBox(
                //                       fit: BoxFit.contain,
                //                       alignment: Alignment.center,
                //                       child: Text(
                //                               'Chat with ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}',
                //                               style: TextStyle(
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.white,
                //                                   fontSize: 14.sp))
                //                           .tr(),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             )),
                //       ),
                //       SizedBox(
                //         width: 2.w,
                //       ),
                //       InkWell(
                //         onTap: () async {
                //           global.showOnlyLoaderDialog(context);
                //           bottomController.astrologerList = [];
                //           bottomController.astrologerList.clear();
                //           bottomController.isAllDataLoaded = false;
                //           bottomController.update();
                //           await bottomController.getAstrologerList(
                //               isLazyLoading: false);
                //           global.hideLoader();
                //           bottomNavigationController.persistentTabController!
                //               .jumpToTab(3);
                //         },
                //         child: Container(
                //             width: Adaptive.w(43),
                //             decoration: BoxDecoration(
                //               color: Get.theme.primaryColor,
                //               borderRadius: BorderRadius.all(
                //                 Radius.circular(4.w),
                //               ),
                //             ),
                //             child: Container(
                //               padding: EdgeInsets.only(left: 1.5.w),
                //               height: 6.h,
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   Icon(
                //                     Icons.phone,
                //                     size: 14.sp,
                //                     color: Colors.white,
                //                   ),
                //                   Padding(
                //                     padding: EdgeInsets.only(left: 2.w),
                //                     child: FittedBox(
                //                       child: Text(
                //                               'Talk to ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}',
                //                               style: TextStyle(
                //                                   fontWeight: FontWeight.w500,
                //                                   color: Colors.white,
                //                                   fontSize: 14.sp))
                //                           .tr(),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             )),
                //       ),
                //     ],
                //   ),
                // )
              ],
            );
          }),
        ),
      ),
    );
  }

  void refreshIt() async {
    splashController.currentLanguageCode =
        homeController.lan[homeController.selectedIndex].lanCode;
    splashController.update();
    global.spLanguage = await SharedPreferences.getInstance();
    global.spLanguage!
        .setString('currentLanguage', splashController.currentLanguageCode);
    homeController.refresh();

    Get.back();
  }

//getRecommendedPujaView
  Widget getRecommendedPujaView(HomeController homecontroller) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended Puja',
                    style: Get.theme.primaryTextTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ).tr(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RemcommendedPoojaViewAllScreen(
                          recommendedlist: homecontroller.pujarecomendedList));
                    },
                    child: Text(
                      'View All',
                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[500],
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 25.h,
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: FontSizes(context).width4()),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(homecontroller.pujarecomendedList!.length,
                  (index) {
                return Row(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => RecommendedPoojadetailscreen(
                                  poojaItem:
                                      homecontroller.pujarecomendedList![index],
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(2),
                            height: 22.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  onError: (exception, stackTrace) =>
                                      Image.asset(
                                    Images.deafultUser,
                                  ),
                                  image: CachedNetworkImageProvider(
                                      global.buildImageUrl(homecontroller
                                          .pujarecomendedList![index]
                                          .pujaImages![0])),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: CornerBanner(
                            bannerPosition: CornerBannerPosition.topLeft,
                            bannerColor: Colors.red,
                            child: global.getSystemFlagValueForLogin(
                                        global.systemFlagNameList.walletType) ==
                                    "Wallet"
                                ? Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} '
                                    '${homecontroller.pujarecomendedList![index].packages![0].packagePrice}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${homecontroller.pujarecomendedList![index].packages![0].packagePrice}',
                                        style: TextStyle(
                                          fontSize: 13.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins-Regular',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 0.4.w,
                                      ),
                                      Image.network(
                                        global.getSystemFlagValueForLogin(
                                            global.systemFlagNameList.coinIcon),
                                        height: 1.2.h,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 5.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: Colors.black26),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '${homecontroller.pujarecomendedList![index].pujaTitle!.length > 14 ? homecontroller.pujarecomendedList![index].pujaTitle!.substring(0, 14) + '..' : homecontroller.pujarecomendedList?[index].pujaTitle}',
                                      style: Get.theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(width: 2.w)
                  ],
                );
              }),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  Widget getRecommendedView(HomeController homecontroller) {
    print(
        'user id 4 ${'$websiteUrl${homeController.recomendedList?[0].productImage}'}');

    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recommended Products',
                    style: Get.theme.primaryTextTheme.titleMedium!
                        .copyWith(fontWeight: FontWeight.w500),
                  ).tr(),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => RemcommendedViewAllScreen(
                          recommendedlist: homecontroller.recomendedList));
                    },
                    child: Text(
                      'View All',
                      style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.blue[500],
                      ),
                    ).tr(),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 25.h,
          width: 100.w,
          margin: EdgeInsets.symmetric(horizontal: FontSizes(context).width3()),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children:
                  List.generate(homecontroller.recomendedList!.length, (index) {
                return Row(
                  children: [
                    Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            //
                            Get.to(() => ProductDetailScreen(
                                  index: 0,
                                  productID: homecontroller
                                      .recomendedList![index].productId!,
                                ));
                          },
                          child: Container(
                            padding: EdgeInsets.all(2),
                            height: 22.h,
                            width: 40.w,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  onError: (exception, stackTrace) =>
                                      Image.asset(
                                    Images.deafultUser,
                                  ),
                                  image: CachedNetworkImageProvider(
                                    '$websiteUrl${homecontroller.recomendedList![index].productImage}',
                                  ),
                                  fit: BoxFit.cover,
                                )),
                          ),
                        ),
                        Positioned(
                          left: 0,
                          top: 0,
                          child: CornerBanner(
                            bannerPosition: CornerBannerPosition.topLeft,
                            bannerColor: Colors.red,
                            child: global.getSystemFlagValueForLogin(
                                        global.systemFlagNameList.walletType) ==
                                    "Wallet"
                                ? Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} '
                                    '${homecontroller.recomendedList![index].amount}',
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Poppins-Regular',
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${homecontroller.recomendedList![index].amount}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins-Regular',
                                          )),
                                      SizedBox(
                                        width: 0.4.w,
                                      ),
                                      Image.network(
                                        global.getSystemFlagValueForLogin(
                                            global.systemFlagNameList.coinIcon),
                                        height: 1.2.h,
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                        Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Container(
                              height: 5.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: Colors.black26),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '${homecontroller.recomendedList![index].productName!.length > 14 ? homecontroller.recomendedList![index].productName!.substring(0, 14) + '..' : homecontroller.recomendedList![index].productName}',
                                      style: Get.theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                    ),
                                    Text(
                                      'by [${homecontroller.recomendedList![index].astrologerName!.length > 14 ? homecontroller.recomendedList![index].astrologerName!.substring(0, 14) + '..' : homecontroller.recomendedList![index].astrologerName} ]',
                                      style: Get.theme.textTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(width: 2.w)
                  ],
                );
              }),
            ),
          ),
        ),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }
}
