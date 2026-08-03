// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/IntakeController.dart';
import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/call/onetooneAudio/call_history_detail_screen.dart';
import 'package:AstrowayCustomer/views/chat/AcceptChatScreen.dart';
import 'package:AstrowayCustomer/views/fakeskelton.dart';
import 'package:AstrowayCustomer/views/view_report.dart';
import 'package:AstrowayCustomer/widget/NoDataWidget.dart';
import 'package:AstrowayCustomer/widget/drawerWidget.dart';
import 'package:AstrowayCustomer/widget/recommendedAstrologerWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/bottomNavigationController.dart';
import '../controllers/walletController.dart';

class HistoryScreen extends StatefulWidget {
  int currentIndex;
  HistoryScreen({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final reviewController = Get.find<ReviewController>();
  final historyController = Get.find<HistoryController>();
  final astromallController = Get.find<AstromallController>();
  final callController = Get.find<CallController>();
  final callScrollController = ScrollController();
  final walletScrollController = ScrollController();
  final paymentScrollController = ScrollController();
  final historyScrollController = ScrollController();
  final reportScrollController = ScrollController();
  final chatScrollController = ScrollController();
  bool isWalletDataLoadedOnce = false;
  final walletcontroller = Get.find<WalletController>();
  final poojaScrollController = ScrollController();
  int poojastartIndex = 0;
  int poojastartfetchRecord = 20;
  bool poojastartisDataLoaded = false;
  bool poojastartisAllDataLoaded = false;
  bool poojastartisMoreDataAvailable = false;
  String totalmin = '';
  int index = 0;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() {
    index = widget.currentIndex;
    if (index != 0) {
      callController.setTabIndex(index);
      index = 0;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paginateTask();
    });
  }

  void paginateTask() {
    callScrollController.addListener(() async {
      if (callScrollController.position.pixels ==
              callScrollController.position.maxScrollExtent &&
          !historyController.callAllDataLoaded) {
        historyController.callMoreDataAvailable = true;
        historyController.update();
      }
      await historyController.getAiChatHistory(global.currentUserId!, false);
      historyController.update();
    });
  }

  String convertSecondsToMinutes(String seconds) {
    int? totalSeconds = int.tryParse(seconds);
    if (totalSeconds == null) {
      return 'Invalid input. Please enter a valid number.';
    }
    int minutes = totalSeconds ~/ 60; // Integer division
    int remainingSeconds = totalSeconds % 60; // Remainder
    return '$minutes min $remainingSeconds sec';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bottomNavigationController.setBottomIndex(0, 1);
        return false;
      },
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        drawer: DrawerWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 2.w),
              GetBuilder<CallController>(builder: (callController) {
                return Container(
                  margin: EdgeInsets.only(bottom: 5),
                  height: 32,
                  child: TabBar(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    controller: callController.tabController,
                    isScrollable: true,
                    indicator: BoxDecoration(
                        color: Get.theme.primaryColor,
                        borderRadius: BorderRadius.circular(30.w)),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey.shade600,
                    labelStyle:
                        Get.theme.primaryTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    unselectedLabelStyle:
                        Get.theme.primaryTextTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                    onTap: (index) async {
                      callController.setTabIndex(index);
                      if (index == 0) {
                        historyController.paymentAllDataLoaded = false;
                        historyController.update();
                        historyController.walletTransactionList = [];
                        historyController.walletAllDataLoaded = false;
                        historyController.update();
                        Future.wait<void>([
                          global.splashController.getCurrentUserData(),
                          historyController.getPaymentLogs(
                              global.currentUserId!, true),
                          historyController.getWalletTransaction(
                              global.currentUserId!, false)
                        ]);
                      } else if (index == 1) {
                        await historyController.getPujaBooking(
                            global.currentUserId!, false);
                        historyController.update();
                      } else if (index == 2) {
                        historyController.callHistoryList = [];
                        historyController.callHistoryList.clear();
                        historyController.scheduleCallHisotry = [];
                        historyController.scheduleCallHisotry.clear();
                        historyController.callAllDataLoaded = false;
                        historyController.update();
                        Future.wait<void>([
                          global.splashController.getCurrentUserData(),
                          historyController.getCallHistory(
                              global.currentUserId!, false)
                        ]);
                      } else if (index == 3) {
                        historyController.chatHistoryList = [];
                        historyController.chatHistoryList.clear();
                        historyController.chatAllDataLoaded = false;
                        historyController.update();
                        await historyController.getChatHistory(
                            global.currentUserId!, false);
                        if (historyController.chatHistoryList.isNotEmpty) {
                        } else {
                          Get.bottomSheet(
                            RecommendedAstrologerWidget(astrologerList: []),
                          );
                        }
                      } else if (index == 4) {
                        historyController.astroMallHistoryList = [];
                        historyController.astroMallHistoryList.clear();
                        historyController.isAllDataLoaded = false;
                        historyController.update();
                        await historyController.getAstroMall(
                            global.currentUserId!, false);
                        historyController.update();
                      } else if (index == 5) {
                        historyController.reportHistoryList = [];
                        historyController.reportHistoryList.clear();
                        historyController.reportAllDataLoaded = false;
                        historyController.update();
                        await historyController.getReportHistory(
                            global.currentUserId!, false);
                        historyController.update();
                      }
                    },
                    tabs: [
                      Tab(text: tr('Wallet')),
                      Tab(text: tr('Puja Booking')),
                      Tab(text: tr('Call')),
                      Tab(text: tr('Chat')),
                      Tab(text: tr('Shopping')),
                      Tab(text: tr('Report')),
                    ],
                  ),
                );
              }),
              Container(
                height: Get.height * 0.9,
                child: SingleChildScrollView(
                  child: GetBuilder<CallController>(builder: (callController) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
                      child: callController.tabController!.index == 0
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(3.w),
                                  margin: EdgeInsets.all(1.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.grey.shade300,
                                        width: 0.8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.w),
                                        child: Text(
                                          global.getSystemFlagValueForLogin(
                                                      global.systemFlagNameList
                                                          .walletType) ==
                                                  "Wallet"
                                              ? 'Available Balance'
                                              : 'Available Coin',
                                          style: Get.theme.primaryTextTheme
                                              .bodyMedium!
                                              .copyWith(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18.sp,
                                            color: Colors.black,
                                          ),
                                        ).tr(),
                                      ),
                                      GetBuilder<SplashController>(
                                          builder: (splashController) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            global.splashController.currentUser
                                                        ?.walletAmount !=
                                                    null
                                                ? (global.getSystemFlagValueForLogin(
                                                            global
                                                                .systemFlagNameList
                                                                .walletType) ==
                                                        "Wallet"
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.w),
                                                        child: Text(
                                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                                                          style: Get
                                                              .theme
                                                              .primaryTextTheme
                                                              .bodyMedium!
                                                              .copyWith(
                                                                  fontSize:
                                                                      20.sp,
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    2.w),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              '${global.splashController.currentUser?.walletAmount.toString().split(".").first}',
                                                              style: Get
                                                                  .theme
                                                                  .primaryTextTheme
                                                                  .bodyMedium!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          20.sp,
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w800),
                                                            ),
                                                            SizedBox(
                                                              width: 1.w,
                                                            ),
                                                            Image.network(
                                                              global.getSystemFlagValueForLogin(
                                                                  global
                                                                      .systemFlagNameList
                                                                      .coinIcon),
                                                              height: 3.h,
                                                            )
                                                          ],
                                                        ),
                                                      ))
                                                : SizedBox(),
                                            GestureDetector(
                                              onTap: () async {
                                                global.showOnlyLoaderDialog(
                                                    context);
                                                await walletcontroller
                                                    .getAmount();
                                                global.hideLoader();
                                                Get.to(
                                                    () => AddmoneyToWallet());
                                              },
                                              child: Container(
                                                width: 100,
                                                height: 38,
                                                decoration: BoxDecoration(
                                                  color: Get.theme.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                alignment: Alignment.center,
                                                child: Text(
                                                  'Recharge',
                                                  style: Get
                                                      .theme
                                                      .primaryTextTheme
                                                      .titleSmall!
                                                      .copyWith(
                                                    fontSize: 16.sp,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ).tr(),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 15),
                                Container(
                                  height: 35,
                                  child: TabBar(
                                    controller:
                                        historyController.tabControllerHistory,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    dividerColor: Colors.transparent,
                                    indicator: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color.fromARGB(255, 0, 4, 255),
                                            Color.fromARGB(255, 255, 5, 5),
                                          ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(30.w)),
                                    labelColor: Colors.white,
                                    unselectedLabelColor: Colors.grey.shade600,
                                    labelStyle: Get
                                        .theme.primaryTextTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                    unselectedLabelStyle: Get
                                        .theme.primaryTextTheme.titleMedium
                                        ?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    labelPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 1),
                                    onTap: (i) async {
                                      global.showOnlyLoaderDialog(context);
                                      historyController.paymentAllDataLoaded =
                                          false;
                                      historyController.update();
                                      historyController.walletTransactionList =
                                          [];
                                      historyController.walletAllDataLoaded =
                                          false;
                                      historyController.update();
                                      Future.wait<void>([
                                        historyController.getPaymentLogs(
                                            global.currentUserId!, false),
                                        historyController.getWalletTransaction(
                                            global.currentUserId!, false)
                                      ]);
                                      global.hideLoader();
                                    },
                                    tabs: [
                                      Tab(
                                        child: Text(
                                          'Wallet Transaction',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ).tr(),
                                      ),
                                      Tab(
                                        child: Text(
                                          'Payment Logs',
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                          ),
                                        ).tr(),
                                      ),
                                    ],
                                  ),
                                ),
                                GetBuilder<HistoryController>(
                                  builder: (historyController) {
                                    return Container(
                                      margin: EdgeInsets.only(top: 15),
                                      height: 80.h,
                                      child: TabBarView(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          controller: historyController
                                              .tabControllerHistory,
                                          children: [
                                            historyController
                                                    .walletTransactionList
                                                    .isNotEmpty
                                                ? RefreshIndicator(
                                                    onRefresh: () async {
                                                      historyController
                                                          .walletTransactionList = [];
                                                      historyController
                                                          .walletTransactionList
                                                          .clear();
                                                      historyController
                                                              .walletAllDataLoaded =
                                                          false;
                                                      historyController
                                                          .update();
                                                      await historyController
                                                          .getWalletTransaction(
                                                              global
                                                                  .currentUserId!,
                                                              false);
                                                    },
                                                    child: ListView.separated(
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    3.w),
                                                        child: Divider(
                                                          color: Colors
                                                              .grey.shade300,
                                                          height: 0.2,
                                                        ),
                                                      ),
                                                      controller:
                                                          walletScrollController,
                                                      shrinkWrap: false,
                                                      itemCount: historyController
                                                          .walletTransactionList
                                                          .length,
                                                      itemBuilder:
                                                          (context, i) {
                                                        return Column(
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2.w),
                                                              margin: EdgeInsets
                                                                  .all(1.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: 0.8),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Container(
                                                                        width: Get.width -
                                                                            120,
                                                                        child: historyController.walletTransactionList.length ==
                                                                                0
                                                                            ? Center(child: SizedBox())
                                                                            : Text(
                                                                                historyController.walletTransactionList[i].transactionType == 'astromallOrder'
                                                                                    ? '${historyController.walletTransactionList[i].transactionType}'
                                                                                    : historyController.walletTransactionList[i].transactionType == 'Gift'
                                                                                        ? 'Send ${historyController.walletTransactionList[i].transactionType} to ${historyController.walletTransactionList[i].name}'
                                                                                        : historyController.walletTransactionList[i].transactionType == 'Report'
                                                                                            ? 'Report Request to ${historyController.walletTransactionList[i].name}'
                                                                                            : historyController.walletTransactionList[i].transactionType == 'KundliView'
                                                                                                ? '${historyController.walletTransactionList[i].transactionType}'
                                                                                                : historyController.walletTransactionList[i].transactionType == "Cashback"
                                                                                                    ? "${historyController.walletTransactionList[i].transactionType}"
                                                                                                    : historyController.walletTransactionList[i].transactionType == "pujaOrder"
                                                                                                        ? 'Puja Ordered'
                                                                                                        : historyController.walletTransactionList[i].transactionType == "Referral"
                                                                                                            ? 'Referral bonus '
                                                                                                            : historyController.walletTransactionList[i].transactionType == "pujaRefund"
                                                                                                                ? 'Puja Refund'
                                                                                                                : historyController.walletTransactionList[i].transactionType == "aiChat"
                                                                                                                    ? historyController.AichatHistoryList.isNotEmpty
                                                                                                                        ? 'AI Chat ${i < historyController.AichatHistoryList.length ? totalmin = convertSecondsToMinutes('${historyController.AichatHistoryList[i].chatDuration}') : ''}'
                                                                                                                        : 'AI Chat'
                                                                                                                    : '${historyController.walletTransactionList[i].transactionType} with ${historyController.walletTransactionList[i].name} for ${historyController.walletTransactionList[i].totalMin} minutes',
                                                                                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black54),
                                                                              ).tr(),
                                                                      ),
                                                                      historyController
                                                                              .walletTransactionList
                                                                              .isEmpty
                                                                          ? Container()
                                                                          : (global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                              ? Expanded(
                                                                                  child: Text(
                                                                                    '${historyController.walletTransactionList[i].isCredit! ? "+" : "-"} ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.walletTransactionList[i].amount}',
                                                                                    style: TextStyle(
                                                                                      fontSize: 13,
                                                                                      color: historyController.walletTransactionList[i].isCredit! ? Colors.redAccent : Colors.green,
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              : Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${historyController.walletTransactionList[i].isCredit! ? "+" : "-"} ${historyController.walletTransactionList[i].amount.toString().split(".").first}',
                                                                                      style: TextStyle(
                                                                                        fontSize: 13,
                                                                                        color: historyController.walletTransactionList[i].isCredit! ? Colors.green : Colors.redAccent,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 1.w,
                                                                                    ),
                                                                                    Image.network(
                                                                                      global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                      height: 1.6.h,
                                                                                    )
                                                                                  ],
                                                                                ))
                                                                    ],
                                                                  ),
                                                                  historyController
                                                                          .walletTransactionList
                                                                          .isEmpty
                                                                      ? Container()
                                                                      : Text(
                                                                          '${global.formatter.format(historyController.walletTransactionList[i].createdAt ?? DateTime.now())}',
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                        ),
                                                                ],
                                                              ),
                                                            ),
                                                            historyController
                                                                            .walletMoreDataAvailable ==
                                                                        true &&
                                                                    !historyController
                                                                        .walletAllDataLoaded &&
                                                                    historyController.walletTransactionList.length -
                                                                            1 ==
                                                                        i
                                                                ? const CircularProgressIndicator()
                                                                : const SizedBox(),
                                                            i ==
                                                                    historyController
                                                                            .walletTransactionList
                                                                            .length -
                                                                        1
                                                                ? const SizedBox(
                                                                    height: 50)
                                                                : const SizedBox()
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  )
                                                : (historyController
                                                        .simmerLoader
                                                    ? fakeSkeltonWidget()
                                                    : Center(
                                                        child: Image.asset(
                                                            Images.noData))),
                                            historyController.paymentLogsList
                                                        .isNotEmpty ||
                                                    historyController
                                                            .paymentLogsList
                                                            .length !=
                                                        0
                                                ? Container(
                                                    child: RefreshIndicator(
                                                    onRefresh: () async {
                                                      historyController
                                                          .paymentLogsList = [];
                                                      historyController
                                                          .paymentLogsList
                                                          .clear();
                                                      historyController
                                                              .paymentAllDataLoaded =
                                                          false;
                                                      historyController
                                                          .update();
                                                      await historyController
                                                          .getPaymentLogs(
                                                              global
                                                                  .currentUserId!,
                                                              false);
                                                    },
                                                    child: ListView.separated(
                                                      separatorBuilder:
                                                          (context, index) =>
                                                              Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    3.w),
                                                        child: Divider(
                                                          color: Colors
                                                              .grey.shade300,
                                                          height: 0.2,
                                                        ),
                                                      ),
                                                      controller:
                                                          paymentScrollController,
                                                      itemCount:
                                                          historyController
                                                              .paymentLogsList
                                                              .length,
                                                      itemBuilder:
                                                          (context, ind) {
                                                        return Column(
                                                          children: [
                                                            Container(
                                                              width: double
                                                                  .infinity,
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(2.w),
                                                              margin: EdgeInsets
                                                                  .all(1.w),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            12),
                                                                border: Border.all(
                                                                    color: Colors
                                                                        .grey
                                                                        .shade300,
                                                                    width: 0.8),
                                                              ),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .end,
                                                                children: [
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        historyController.paymentLogsList[ind].paymentFor ==
                                                                                "puja"
                                                                            ? "Puja Order"
                                                                            : 'Recharge',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ).tr(),
                                                                      global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) ==
                                                                              "Wallet"
                                                                          ? Text(
                                                                              '+${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.paymentLogsList[ind].amount}',
                                                                              style: TextStyle(
                                                                                fontSize: 16.sp,
                                                                                color: Colors.black87,
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            )
                                                                          : Row(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Text(
                                                                                  '${historyController.paymentLogsList[ind].amount.toString().split(".").first}',
                                                                                  style: TextStyle(
                                                                                    fontSize: 16.sp,
                                                                                    color: Colors.black87,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 1.w,
                                                                                ),
                                                                                Image.network(
                                                                                  global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                  height: 1.6.h,
                                                                                )
                                                                              ],
                                                                            )
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        '${DateFormat('dd-MMM-yy').format(historyController.paymentLogsList[ind].createdAt!)}',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      historyController.paymentLogsList[ind].orderId != "null" &&
                                                                              historyController.paymentLogsList[ind].orderId != null
                                                                          ? Text(
                                                                              '# ${historyController.paymentLogsList[ind].orderId}',
                                                                              style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.grey,
                                                                              ),
                                                                            )
                                                                          : SizedBox(),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.end,
                                                                        children: [
                                                                          Icon(
                                                                            historyController.paymentLogsList[ind].paymentStatus == "failed" || historyController.paymentLogsList[ind].paymentStatus == "Failed"
                                                                                ? Icons.error
                                                                                : Icons.check_circle,
                                                                            size:
                                                                                13,
                                                                            color: historyController.paymentLogsList[ind].paymentStatus == "failed" || historyController.paymentLogsList[ind].paymentStatus == "Failed"
                                                                                ? Colors.red
                                                                                : Colors.green,
                                                                          ),
                                                                          Text(
                                                                            "${historyController.paymentLogsList[ind].paymentStatus}",
                                                                            style:
                                                                                TextStyle(fontSize: 12, color: historyController.paymentLogsList[ind].paymentStatus == "failed" || historyController.paymentLogsList[ind].paymentStatus == "Failed" ? Colors.red : Colors.green),
                                                                          ).tr()
                                                                        ],
                                                                      )
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            historyController
                                                                            .paymentMoreDataAvailable ==
                                                                        true &&
                                                                    !historyController
                                                                        .paymentAllDataLoaded &&
                                                                    historyController.paymentLogsList.length -
                                                                            1 ==
                                                                        ind
                                                                ? const CircularProgressIndicator()
                                                                : const SizedBox(),
                                                            ind ==
                                                                    historyController
                                                                            .paymentLogsList
                                                                            .length -
                                                                        1
                                                                ? const SizedBox(
                                                                    height: 50,
                                                                  )
                                                                : const SizedBox()
                                                          ],
                                                        );
                                                      },
                                                    ),
                                                  ))
                                                : (historyController
                                                        .simmerLoader
                                                    ? fakeSkeltonWidget()
                                                    : Center(
                                                        child: Image.asset(
                                                            Images.noData)))
                                          ]),
                                    );
                                  },
                                )
                              ],
                            )
                          // POOJA BOOKING INFO TAB
                          : callController.tabController!.index == 1
                              ? Column(children: [
                                  GetBuilder<HistoryController>(
                                      builder: (historycontroller) {
                                    return historyController
                                            .pujaHistoryList.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            controller: callScrollController,
                                            itemCount: historyController
                                                .pujaHistoryList.length,
                                            itemBuilder: (context, index) {
                                              return Skeletonizer(
                                                enabled:
                                                    historycontroller.isloading,
                                                child: Column(
                                                  children: [
                                                    Card(
                                                      elevation: 0.2.w,
                                                      color: historyController
                                                                  .pujaHistoryList[
                                                                      index]
                                                                  .pujaOrderStatus ==
                                                              "completed"
                                                          ? Colors.green.shade50
                                                          : Colors
                                                              .orange.shade50,
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(3.w),
                                                        child: Column(
                                                          children: [
                                                            SizedBox(
                                                                height: 1.w),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                historyController
                                                                        .pujaHistoryList[
                                                                            index]
                                                                        .pujaOrderStatus!
                                                                        .contains(
                                                                            'completed')
                                                                    ? Text(
                                                                        'Puja Completed',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18.sp,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                      ).tr()
                                                                    : historyController.pujaHistoryList[index].pujaLink!.contains('http') ??
                                                                            false
                                                                        ? Text(
                                                                            "Join Puja",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ).tr()
                                                                        : Text(
                                                                            // 'Join Pooja',
                                                                            "${historyController.pujaHistoryList[index].pujaLink}",

                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 18.sp,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                SizedBox(
                                                                    width: 2),
                                                                InkWell(
                                                                  onTap: historyController.pujaHistoryList[index].pujaLink ==
                                                                              null ||
                                                                          historyController
                                                                              .pujaHistoryList[
                                                                                  index]
                                                                              .pujaLink!
                                                                              .isEmpty ||
                                                                          historyController.pujaHistoryList[index].pujaLink!.contains(
                                                                              'Completed')
                                                                      ? () {
                                                                          Get.showSnackbar(
                                                                            GetSnackBar(
                                                                              backgroundColor: Colors.green,
                                                                              snackPosition: SnackPosition.TOP,
                                                                              title: 'Completed',
                                                                              message: 'Puja Completed Successfully',
                                                                              duration: Duration(seconds: 2),
                                                                            ),
                                                                          );
                                                                        }
                                                                      : historyController
                                                                              .pujaHistoryList[index]
                                                                              .pujaLink!
                                                                              .contains('Link will be available soon')
                                                                          ? () {
                                                                              Get.showSnackbar(
                                                                                GetSnackBar(
                                                                                  backgroundColor: Colors.green,
                                                                                  snackPosition: SnackPosition.TOP,
                                                                                  title: 'Link',
                                                                                  message: 'Link will be available soon',
                                                                                  duration: Duration(seconds: 2),
                                                                                ),
                                                                              );
                                                                            }
                                                                          : () {
                                                                              log('puja link - ${historyController.pujaHistoryList[index].pujaLink}');
                                                                              // Launch the URL only if the link is valid
                                                                              launchUrl(Uri.parse(historyController.pujaHistoryList[index].pujaLink!));
                                                                            },
                                                                  child: historyController.pujaHistoryList[index].pujaOrderStatus!.contains(
                                                                              'placed') &&
                                                                          historyController
                                                                              .pujaHistoryList[index]
                                                                              .pujaEndDatetime!
                                                                              .isBefore(DateTime.now())
                                                                      ? historyController.pujaHistoryList[index].puja_refund_status == 1
                                                                          ? InkWell(
                                                                              onTap: () {
                                                                                //
                                                                                log('onclicked');
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  border: Border.all(
                                                                                    color: Colors.orange.shade300,
                                                                                    width: 1,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.grey.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 4,
                                                                                      offset: Offset(0, 2), // Subtle shadow for depth
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                child: Text(
                                                                                  'Refunded',
                                                                                  style: TextStyle(
                                                                                    fontSize: 14.sp,
                                                                                    fontWeight: FontWeight.w600,
                                                                                    color: Colors.green.shade700,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          : InkWell(
                                                                              onTap: () async {
                                                                                //click for refund
                                                                                global.showOnlyLoaderDialog(context);
                                                                                await historycontroller.applyforRefund(historyController.pujaHistoryList[index].id);
                                                                              },
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: 7.0, vertical: 5.0),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.white,
                                                                                  border: Border.all(
                                                                                    color: Colors.orange.shade300,
                                                                                    width: 1,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(8.0),
                                                                                  boxShadow: [
                                                                                    BoxShadow(
                                                                                      color: Colors.grey.withOpacity(0.2),
                                                                                      spreadRadius: 1,
                                                                                      blurRadius: 4,
                                                                                      offset: Offset(0, 2), // Subtle shadow for depth
                                                                                    )
                                                                                  ],
                                                                                  gradient: LinearGradient(
                                                                                    // Optional subtle gradient
                                                                                    begin: Alignment.topCenter,
                                                                                    end: Alignment.bottomCenter,
                                                                                    colors: [
                                                                                      Colors.green.shade50,
                                                                                      Colors.green.shade200
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.min,
                                                                                  children: [
                                                                                    Icon(
                                                                                      // Added icon for better visual recognition
                                                                                      Icons.assignment_return_outlined,
                                                                                      size: 20,
                                                                                      color: Colors.green.shade700,
                                                                                    ),
                                                                                    SizedBox(width: 8),
                                                                                    Text(
                                                                                      'Get Refund',
                                                                                      style: TextStyle(
                                                                                        fontSize: 14.sp,
                                                                                        fontWeight: FontWeight.w600,
                                                                                        color: Colors.green.shade700,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            )
                                                                      : Icon(
                                                                          historyController.pujaHistoryList[index].pujaLink == null || historyController.pujaHistoryList[index].pujaLink!.isEmpty || historyController.pujaHistoryList[index].pujaOrderStatus!.contains('completed')
                                                                              ? Icons.check_circle_outline_outlined
                                                                              : historyController.pujaHistoryList[index].pujaLink!.contains('Link will be available soon')
                                                                                  ? Icons.link_outlined
                                                                                  : Icons.video_call_outlined,
                                                                          size: 20.sp,
                                                                          color: Colors.green),
                                                                ),
                                                                historyController.pujaHistoryList[index].pujaLink!.contains('Completed') ||
                                                                        historyController
                                                                            .pujaHistoryList[
                                                                                index]
                                                                            .pujaLink!
                                                                            .contains(
                                                                                'Link will be available soon') ||
                                                                        historyController.pujaHistoryList[index].pujaLink ==
                                                                            null ||
                                                                        historyController
                                                                            .pujaHistoryList[index]
                                                                            .pujaLink!
                                                                            .isEmpty
                                                                    ? SizedBox()
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          global.commonShareMethod(
                                                                              title: "\n\nJoin Pooja: ${historyController.pujaHistoryList[index].pujaLink!}");
                                                                        },
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        child:
                                                                            Container(
                                                                          padding: EdgeInsets.symmetric(
                                                                              horizontal: 2,
                                                                              vertical: 2),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                            border:
                                                                                Border.all(color: Colors.white, width: 1.5),
                                                                          ),
                                                                          child: Icon(
                                                                              Icons.share,
                                                                              color: Colors.blueAccent,
                                                                              size: 18.sp),
                                                                        ),
                                                                      ),
                                                              ],
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Flexible(
                                                                  child: Text(
                                                                    '${historyController.pujaHistoryList[index].pujaName}',
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                                height: 2.w),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      '${historyController.pujaHistoryList[index].packageName ?? 'Price'}',
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .bodySmall!
                                                                          .copyWith(
                                                                        fontSize:
                                                                            16.sp,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          2.w),
                                                                  global.getSystemFlagValueForLogin(global
                                                                              .systemFlagNameList
                                                                              .walletType) ==
                                                                          "Wallet"
                                                                      ? Text(
                                                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.pujaHistoryList[index].orderTotalPrice}',
                                                                          style: Get
                                                                              .theme
                                                                              .primaryTextTheme
                                                                              .bodyLarge!
                                                                              .copyWith(),
                                                                        )
                                                                      : Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Text(
                                                                              '${historyController.pujaHistoryList[index].orderTotalPrice.toString().split(".").first}',
                                                                              style: Get.theme.primaryTextTheme.bodyLarge!.copyWith(),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 1.w,
                                                                            ),
                                                                            Image.network(
                                                                              global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                              height: 1.6.h,
                                                                            )
                                                                          ],
                                                                        )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      'Order Status',
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .bodySmall!
                                                                          .copyWith(),
                                                                    ).tr(),
                                                                  ),
                                                                  SizedBox(
                                                                      width: 2),
                                                                  Text(
                                                                    '${global.capitalizeFirstLetter(historyController.pujaHistoryList[index].pujaOrderStatus)}',
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                      color: historyController.pujaHistoryList[index].pujaOrderStatus ==
                                                                              'placed'
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .orange,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      'Puja Start Date',
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .bodySmall!
                                                                          .copyWith(),
                                                                    ).tr(),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          2.w),
                                                                  Text(
                                                                    '${DateFormat('dd-MMM-yy hh:mm').format(historyController.pujaHistoryList[index].pujaStartDatetime!)}',
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Flexible(
                                                                    child: Text(
                                                                      'Duration ',
                                                                      style: Get
                                                                          .theme
                                                                          .primaryTextTheme
                                                                          .bodySmall!
                                                                          .copyWith(),
                                                                    ).tr(),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          2.w),
                                                                  Text(
                                                                    '${historyController.pujaHistoryList[index].puja_duration} min',
                                                                    style: Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    historyController
                                                                    .callMoreDataAvailable ==
                                                                true &&
                                                            !historyController
                                                                .callAllDataLoaded &&
                                                            historyController
                                                                        .callHistoryList
                                                                        .length -
                                                                    1 ==
                                                                index
                                                        ? const CircularProgressIndicator()
                                                        : const SizedBox(),
                                                    index ==
                                                            historyController
                                                                    .callHistoryList
                                                                    .length -
                                                                1
                                                        ? const SizedBox(
                                                            height: 50,
                                                          )
                                                        : const SizedBox()
                                                  ],
                                                ),
                                              );
                                            },
                                          )
                                        : (historyController.simmerLoader
                                            ? fakeSkeltonWidget()
                                            : Container(
                                                alignment: Alignment.center,
                                                height: Get.height - 197,
                                                child: NoDataWidget(
                                                  title:
                                                      "Pooja History Not Found",
                                                )));
                                  }),
                                  SizedBox(height: 8.h),
                                ])
                              : callController.tabController!.index == 2
                                  ? RefreshIndicator(
                                      onRefresh: () async {
                                        historyController.callHistoryList = [];
                                        historyController.callHistoryList
                                            .clear();
                                        historyController.callAllDataLoaded =
                                            false;
                                        historyController.update();
                                        await historyController.getCallHistory(
                                            global.currentUserId!, false);
                                      },
                                      child: SizedBox(
                                        height: 90.h,
                                        child: Column(
                                          children: [
                                            // Schedule appointments - ALWAYS SHOW FIRST
                                            GetBuilder<HistoryController>(
                                              builder: (historyController) {
                                                return historyController
                                                        .scheduleCallHisotry
                                                        .isNotEmpty
                                                    ? Expanded(
                                                        child: ListView.builder(
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          controller:
                                                              callScrollController,
                                                          itemCount:
                                                              historyController
                                                                  .scheduleCallHisotry
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return Skeletonizer(
                                                              enabled:
                                                                  historyController
                                                                      .isloading,
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  // Your onTap code for schedule items
                                                                },
                                                                child: Column(
                                                                  children: [
                                                                    Card(
                                                                      elevation:
                                                                          0.1.w,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [],
                                                                            ),
                                                                            Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                                                  children: [
                                                                                    SizedBox(height: 0.5.h),
                                                                                    Text(
                                                                                      "Scheduled Appointment",
                                                                                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700),
                                                                                    ),
                                                                                    SizedBox(height: 1.h),
                                                                                    Container(
                                                                                      width: 50.w,
                                                                                      child: Text(
                                                                                        '${global.formatter.format(historyController.scheduleCallHisotry[index].scheduleDate)}',
                                                                                      ),
                                                                                    ),
                                                                                    buildCountdown(historyController.scheduleCallHisotry[index].scheduleDate, scheduledTime: "${historyController.scheduleCallHisotry[index].scheduleTime}"),
                                                                                    SizedBox(height: 1.h),
                                                                                    InkWell(
                                                                                      onTap: () {
                                                                                        showDialog(
                                                                                          context: context,
                                                                                          builder: (BuildContext context) {
                                                                                            return AlertDialog(
                                                                                              shape: RoundedRectangleBorder(
                                                                                                borderRadius: BorderRadius.circular(15),
                                                                                              ),
                                                                                              title: Text("Confirm Delete"),
                                                                                              content: Text("Do you want to delete this item?"),
                                                                                              actions: [
                                                                                                TextButton(
                                                                                                  child: Text("No"),
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                  },
                                                                                                ),
                                                                                                ElevatedButton(
                                                                                                  style: ElevatedButton.styleFrom(
                                                                                                    backgroundColor: Colors.red,
                                                                                                  ),
                                                                                                  child: Text("Yes"),
                                                                                                  onPressed: () {
                                                                                                    Navigator.of(context).pop();
                                                                                                    historyController.deleteAppoinment(historyController.scheduleCallHisotry[index].id.toString());
                                                                                                  },
                                                                                                ),
                                                                                              ],
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                      child: Container(
                                                                                        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                                                                                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(10)),
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Delete",
                                                                                              style: TextStyle(color: Colors.white),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.delete_forever_outlined,
                                                                                              color: Colors.white,
                                                                                              size: 17.sp,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                                SizedBox(
                                                                                  width: 30.w,
                                                                                  child: Column(children: [
                                                                                    Text(
                                                                                      historyController.scheduleCallHisotry[index].astrologerName!.capitalize.toString(),
                                                                                      style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 15.sp),
                                                                                    ).tr(),
                                                                                    SizedBox(height: 12),
                                                                                    Container(
                                                                                      height: 65,
                                                                                      width: 65,
                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(7),
                                                                                        child: CachedNetworkImage(
                                                                                          imageUrl: global.buildImageUrl('${historyController.scheduleCallHisotry[index].profileImage}'),
                                                                                          imageBuilder: (context, imageProvider) => Container(
                                                                                            height: 65,
                                                                                            width: 65,
                                                                                            decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                                                                          ),
                                                                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                          errorWidget: (context, url, error) => Image.asset(
                                                                                            Images.deafultUser,
                                                                                            fit: BoxFit.cover,
                                                                                            height: 50,
                                                                                            width: 40,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ]),
                                                                                )
                                                                              ],
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    historyController.callMoreDataAvailable ==
                                                                                true &&
                                                                            !historyController
                                                                                .callAllDataLoaded &&
                                                                            historyController.scheduleCallHisotry.length - 1 ==
                                                                                index
                                                                        ? const CircularProgressIndicator()
                                                                        : const SizedBox(),
                                                                    index ==
                                                                            historyController.scheduleCallHisotry.length -
                                                                                1
                                                                        ? const SizedBox(
                                                                            height:
                                                                                50)
                                                                        : const SizedBox()
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                    : (historyController
                                                            .simmerLoader
                                                        ? Expanded(
                                                            child:
                                                                fakeSkeltonWidget())
                                                        : Container(
                                                            alignment: Alignment
                                                                .center,
                                                            height: 100,
                                                            child: Text(
                                                                'No Scheduled Appointments'),
                                                          ));
                                              },
                                            ),

                                            // Call History - SHOW BELOW SCHEDULE
                                            GetBuilder<HistoryController>(
                                              builder: (historyController) {
                                                return historyController
                                                        .callHistoryList
                                                        .isNotEmpty
                                                    ? Expanded(
                                                        child: RefreshIndicator(
                                                          onRefresh: () async {
                                                            historyController
                                                                .callHistoryList = [];
                                                            historyController
                                                                .callHistoryList
                                                                .clear();
                                                            historyController
                                                                    .callAllDataLoaded =
                                                                false;
                                                            historyController
                                                                .update();
                                                            await historyController
                                                                .getCallHistory(
                                                                    global
                                                                        .currentUserId!,
                                                                    false);
                                                          },
                                                          child:
                                                              ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                                Axis.vertical,
                                                            controller:
                                                                callScrollController,
                                                            itemCount:
                                                                historyController
                                                                    .callHistoryList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return Skeletonizer(
                                                                enabled:
                                                                    historyController
                                                                        .isloading,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap:
                                                                      () async {
                                                                    IntakeController
                                                                        intakeController =
                                                                        Get.find<
                                                                            IntakeController>();
                                                                    global.showOnlyLoaderDialog(
                                                                        context);

                                                                    await Future
                                                                        .wait<
                                                                            void>([
                                                                      intakeController
                                                                          .getFormIntakeData(),
                                                                      historyController.getCallHistoryById(historyController
                                                                          .callHistoryList[
                                                                              index]
                                                                          .id!)
                                                                    ]);
                                                                    global
                                                                        .hideLoader();
                                                                    Get.to(() =>
                                                                        CallHistoryDetailScreen(
                                                                          astrologerId: historyController
                                                                              .callHistoryList[index]
                                                                              .astrologerId!,
                                                                          astrologerProfile:
                                                                              historyController.callHistoryList[index].profileImage ?? "",
                                                                          index:
                                                                              index,
                                                                          callType: historyController
                                                                              .callHistoryList[index]
                                                                              .callType,
                                                                        ));
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Card(
                                                                        elevation:
                                                                            0.1.w,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [],
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Container(
                                                                                        width: 50.w,
                                                                                        child: Text(
                                                                                          '${global.formatter.format(historyController.callHistoryList[index].createdAt!)}',
                                                                                        ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 30.w,
                                                                                        child: Text(
                                                                                          historyController.callHistoryList[index].callStatus!,
                                                                                          style: TextStyle(
                                                                                              fontSize: 14.sp,
                                                                                              fontWeight: FontWeight.w400,
                                                                                              color: historyController.callHistoryList[index].callStatus == "rejected" || historyController.callHistoryList[index].callStatus == "Rejected"
                                                                                                  ? Colors.red
                                                                                                  : historyController.callHistoryList[index].callStatus == "pending" || historyController.callHistoryList[index].callStatus == "Pending"
                                                                                                      ? Colors.yellow
                                                                                                      : Colors.green),
                                                                                        ).tr(),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 30.w,
                                                                                        child: global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                            ? Text(
                                                                                                '${tr('Rate')}: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.callHistoryList[index].callRate == null ? '0' : historyController.callHistoryList[index].callRate == "" ? "0" : historyController.callHistoryList[index].callRate}/min',
                                                                                                style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                  color: Colors.grey,
                                                                                                  fontSize: 12,
                                                                                                ),
                                                                                              ).tr()
                                                                                            : Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    '${tr('Rate')}: ${historyController.callHistoryList[index].callRate == null ? '0' : historyController.callHistoryList[index].callRate == "" ? "0" : historyController.callHistoryList[index].callRate.toString().split(".").first}',
                                                                                                    style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                      color: Colors.grey,
                                                                                                      fontSize: 12,
                                                                                                    ),
                                                                                                  ).tr(),
                                                                                                  SizedBox(
                                                                                                    width: 0.6.w,
                                                                                                  ),
                                                                                                  Image.network(
                                                                                                    global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                                    height: 1.6.h,
                                                                                                  ),
                                                                                                  Text("/min")
                                                                                                ],
                                                                                              ),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 30.w,
                                                                                        child: Text(
                                                                                          '${tr('Duration')}: ${historyController.callHistoryList[index].totalMin == null ? '0' : historyController.callHistoryList[index].totalMin == "" ? "0" : historyController.callHistoryList[index].totalMin}min',
                                                                                          style: Get.textTheme.bodyLarge!.copyWith(
                                                                                            color: Colors.grey,
                                                                                            fontSize: 12,
                                                                                          ),
                                                                                        ).tr(),
                                                                                      ),
                                                                                      Container(
                                                                                        width: 30.w,
                                                                                        child: global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                            ? Text(
                                                                                                '${tr('Deduction')}: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.callHistoryList[index].deduction}',
                                                                                                style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                  color: Colors.grey,
                                                                                                  fontSize: 12,
                                                                                                ),
                                                                                              ).tr()
                                                                                            : Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    '${tr('Deduction')}: ${historyController.callHistoryList[index].deduction.toString().split(".").first}',
                                                                                                    style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                      color: Colors.grey,
                                                                                                      fontSize: 12,
                                                                                                    ),
                                                                                                  ).tr(),
                                                                                                  SizedBox(
                                                                                                    width: 1.w,
                                                                                                  ),
                                                                                                  Image.network(
                                                                                                    global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                                    height: 1.6.h,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 30.w,
                                                                                    child: Column(children: [
                                                                                      Text(
                                                                                        historyController.callHistoryList[index].astrologerName!,
                                                                                        style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 15.sp),
                                                                                      ).tr(),
                                                                                      SizedBox(height: 12),
                                                                                      Container(
                                                                                        height: 65,
                                                                                        width: 65,
                                                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                                                                        child: ClipRRect(
                                                                                          borderRadius: BorderRadius.circular(7),
                                                                                          child: CachedNetworkImage(
                                                                                            imageUrl: global.buildImageUrl('${historyController.callHistoryList[index].profileImage}'),
                                                                                            imageBuilder: (context, imageProvider) => Container(
                                                                                              height: 65,
                                                                                              width: 65,
                                                                                              decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
                                                                                            ),
                                                                                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                            errorWidget: (context, url, error) => Image.asset(
                                                                                              Images.deafultUser,
                                                                                              fit: BoxFit.cover,
                                                                                              height: 50,
                                                                                              width: 40,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ]),
                                                                                  )
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      historyController.callMoreDataAvailable == true &&
                                                                              !historyController.callAllDataLoaded &&
                                                                              historyController.callHistoryList.length - 1 == index
                                                                          ? const CircularProgressIndicator()
                                                                          : const SizedBox(),
                                                                      index == historyController.callHistoryList.length - 1
                                                                          ? const SizedBox(
                                                                              height: 50)
                                                                          : const SizedBox()
                                                                    ],
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : (historyController
                                                            .simmerLoader
                                                        ? Expanded(
                                                            child:
                                                                fakeSkeltonWidget())
                                                        : SizedBox.shrink());
                                              },
                                            )
                                          ],
                                        ),
                                      ))
                                  : callController.tabController!.index == 3
                                      ? GetBuilder<HistoryController>(
                                          builder: (historyController) {
                                          return Column(children: [
                                            historyController
                                                    .chatHistoryList.isNotEmpty
                                                ? Container(
                                                    height: Get.height - 197,
                                                    child: RefreshIndicator(
                                                      onRefresh: () async {
                                                        log('fkskfs');
                                                        historyController
                                                            .chatHistoryList = [];
                                                        historyController
                                                            .chatHistoryList
                                                            .clear();
                                                        historyController
                                                                .chatAllDataLoaded =
                                                            false;
                                                        historyController
                                                            .update();
                                                        await historyController
                                                            .getChatHistory(
                                                                global
                                                                    .currentUserId!,
                                                                false);
                                                      },
                                                      child: ListView.builder(
                                                        controller:
                                                            chatScrollController,
                                                        itemCount:
                                                            historyController
                                                                .chatHistoryList
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          return Skeletonizer(
                                                            enabled:
                                                                historyController
                                                                    .isloading,
                                                            child:
                                                                GestureDetector(
                                                              onTap: () async {
                                                                ChatController
                                                                    chatController =
                                                                    Get.find<
                                                                        ChatController>();
                                                                global
                                                                    .showOnlyLoaderDialog(
                                                                        context);
                                                                await chatController.getuserReview(
                                                                    historyController
                                                                        .chatHistoryList[
                                                                            index]
                                                                        .astrologerId!);
                                                                global
                                                                    .hideLoader();
                                                                Get.to(() =>
                                                                    AcceptChatScreen(
                                                                      flagId: 0,
                                                                      profileImage: historyController
                                                                          .chatHistoryList[
                                                                              index]
                                                                          .profileImage!,
                                                                      astrologerName: historyController
                                                                          .chatHistoryList[
                                                                              index]
                                                                          .astrologerName!,
                                                                      fireBasechatId: historyController
                                                                          .chatHistoryList[
                                                                              index]
                                                                          .chatId!,
                                                                      astrologerId: historyController
                                                                          .chatHistoryList[
                                                                              index]
                                                                          .astrologerId!,
                                                                      chatId: historyController
                                                                          .chatHistoryList[
                                                                              index]
                                                                          .id!,
                                                                      duration: (int.parse(historyController.chatHistoryList[index].totalMin.toString()) *
                                                                              60)
                                                                          .toString(),
                                                                    ));
                                                              },
                                                              child: Column(
                                                                children: [
                                                                  Card(
                                                                    elevation:
                                                                        0.1.w,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(width: 50.w, child: Text('${global.formatter.format(historyController.chatHistoryList[index].createdAt!)}')),
                                                                                  Container(
                                                                                    width: 50.w,
                                                                                    child: Text(
                                                                                      historyController.chatHistoryList[index].chatStatus!,
                                                                                      style: TextStyle(
                                                                                          fontSize: 12,
                                                                                          color: historyController.chatHistoryList[index].chatStatus == "rejected" || historyController.chatHistoryList[index].chatStatus == "Rejected"
                                                                                              ? Colors.red
                                                                                              : historyController.chatHistoryList[index].chatStatus == "pending" || historyController.chatHistoryList[index].chatStatus == "Pending"
                                                                                                  ? Colors.yellow
                                                                                                  : Colors.green),
                                                                                    ).tr(),
                                                                                  ),
                                                                                  Container(
                                                                                    width: 30.w,
                                                                                    child: global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                        ? Text(
                                                                                            '${tr('Rate')}: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.chatHistoryList[index].chatRate == null ? '0' : historyController.chatHistoryList[index].chatRate == "" ? "0" : historyController.chatHistoryList[index].chatRate}/min',
                                                                                            style: Get.textTheme.bodyLarge!.copyWith(
                                                                                              color: Colors.grey,
                                                                                              fontSize: 12,
                                                                                            ),
                                                                                          ).tr()
                                                                                        : Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                '${tr('Rate')}: ${historyController.chatHistoryList[index].chatRate == null ? '0' : historyController.chatHistoryList[index].chatRate == "" ? "0" : historyController.chatHistoryList[index].chatRate}',
                                                                                                style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                  color: Colors.grey,
                                                                                                  fontSize: 12,
                                                                                                ),
                                                                                              ).tr(),
                                                                                              SizedBox(
                                                                                                width: 0.6.w,
                                                                                              ),
                                                                                              Image.network(
                                                                                                global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                                height: 1.6.h,
                                                                                              ),
                                                                                              Text(
                                                                                                "/min",
                                                                                                style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                  color: Colors.grey,
                                                                                                  fontSize: 12,
                                                                                                ),
                                                                                              )
                                                                                            ],
                                                                                          ),
                                                                                  ),
                                                                                  Container(
                                                                                    width: 50.w,
                                                                                    child: Text(
                                                                                      '${tr('Duration')}: ${historyController.chatHistoryList[index].totalMin == null ? '0' : historyController.chatHistoryList[index].totalMin == "" ? "0" : historyController.chatHistoryList[index].totalMin}min',
                                                                                      style: Get.textTheme.bodyLarge!.copyWith(
                                                                                        color: Colors.grey,
                                                                                        fontSize: 12,
                                                                                      ),
                                                                                    ).tr(),
                                                                                  ),
                                                                                  Container(
                                                                                    width: 50.w,
                                                                                    child: global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                        ? Text(
                                                                                            '${tr('Deduction')}: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.chatHistoryList[index].deduction}',
                                                                                            style: Get.textTheme.bodyLarge!.copyWith(
                                                                                              color: Colors.grey,
                                                                                              fontSize: 12,
                                                                                            ),
                                                                                          ).tr()
                                                                                        : Row(
                                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                                            children: [
                                                                                              Text(
                                                                                                '${tr('Deduction')}:${historyController.chatHistoryList[index].deduction.toString().split(".").first}',
                                                                                                style: Get.textTheme.bodyLarge!.copyWith(
                                                                                                  color: Colors.grey,
                                                                                                  fontSize: 12,
                                                                                                ),
                                                                                              ).tr(),
                                                                                              SizedBox(
                                                                                                width: 1.w,
                                                                                              ),
                                                                                              Image.network(
                                                                                                global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                                height: 1.6.h,
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                width: 30.w,
                                                                                child: Column(children: [
                                                                                  Text(
                                                                                    historyController.chatHistoryList[index].astrologerName!,
                                                                                    style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600, fontSize: 15.sp),
                                                                                    textAlign: TextAlign.center,
                                                                                  ).tr(),
                                                                                  SizedBox(height: 12),
                                                                                  Container(
                                                                                    height: 65,
                                                                                    width: 65,
                                                                                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.w), border: Border.all(color: Get.theme.primaryColor)),
                                                                                    child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(2.w),
                                                                                      child: CachedNetworkImage(
                                                                                        fit: BoxFit.cover,
                                                                                        imageUrl: global.buildImageUrl('${historyController.chatHistoryList[index].profileImage}'),
                                                                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                        errorWidget: (context, url, error) => Image.asset(
                                                                                          Images.deafultUser,
                                                                                          fit: BoxFit.cover,
                                                                                          height: 65,
                                                                                          width: 65,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ]),
                                                                              )
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  historyController.chatMoreDataAvailable ==
                                                                              true &&
                                                                          !historyController
                                                                              .chatAllDataLoaded &&
                                                                          historyController.chatHistoryList.length - 1 ==
                                                                              index
                                                                      ? const CircularProgressIndicator()
                                                                      : const SizedBox(),
                                                                  index ==
                                                                          historyController.chatHistoryList.length -
                                                                              1
                                                                      ? const SizedBox(
                                                                          height:
                                                                              50,
                                                                        )
                                                                      : const SizedBox()
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                : (historyController
                                                        .simmerLoader
                                                    ? fakeSkeltonWidget()
                                                    : Container(
                                                        alignment:
                                                            Alignment.center,
                                                        height:
                                                            Get.height - 197,
                                                        child: Text(
                                                            'No Chat History'),
                                                      ))
                                          ]);
                                        })
                                      : callController.tabController!.index == 4
                                          ? GetBuilder<HistoryController>(
                                              builder: (historyController) {
                                              return Column(children: [
                                                historyController
                                                        .astroMallHistoryList
                                                        .isNotEmpty
                                                    ? Container(
                                                        height:
                                                            Get.height - 197,
                                                        child: RefreshIndicator(
                                                          onRefresh: () async {
                                                            historyController
                                                                .astroMallHistoryList = [];
                                                            historyController
                                                                .astroMallHistoryList
                                                                .clear();
                                                            historyController
                                                                    .isAllDataLoaded =
                                                                false;
                                                            historyController
                                                                .update();
                                                            await historyController
                                                                .getAstroMall(
                                                                    global
                                                                        .currentUserId!,
                                                                    false);
                                                          },
                                                          child:
                                                              ListView.builder(
                                                            controller:
                                                                historyScrollController,
                                                            itemCount:
                                                                historyController
                                                                    .astroMallHistoryList
                                                                    .length,
                                                            itemBuilder:
                                                                (context, inx) {
                                                              return Column(
                                                                children: [
                                                                  Card(
                                                                    elevation:
                                                                        0.1.w,
                                                                    child:
                                                                        Padding(
                                                                      padding: const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [],
                                                                          ),
                                                                          Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 40.w,
                                                                                    child: Text(
                                                                                      historyController.astroMallHistoryList[inx].productName!,
                                                                                      style: Get.textTheme.bodyLarge!.copyWith(
                                                                                        fontWeight: FontWeight.w600,
                                                                                      ),
                                                                                    ).tr(),
                                                                                  ),
                                                                                  Text(
                                                                                    '${historyController.astroMallHistoryList[inx].orderAddressName}',
                                                                                    style: TextStyle(),
                                                                                  ).tr(),
                                                                                  Text(
                                                                                    '${global.formatter.format(historyController.astroMallHistoryList[inx].createdAt!)}',
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 12,
                                                                                    ),
                                                                                  ).tr(),
                                                                                  Text(
                                                                                    '${historyController.astroMallHistoryList[inx].flatNo} ${historyController.astroMallHistoryList[inx].city} ${historyController.astroMallHistoryList[inx].state} ${historyController.astroMallHistoryList[inx].country} ${historyController.astroMallHistoryList[inx].pincode}',
                                                                                    overflow: TextOverflow.clip,
                                                                                    style: TextStyle(
                                                                                      fontSize: 12,
                                                                                    ),
                                                                                  ).tr(),
                                                                                  global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                      ? Text(
                                                                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.astroMallHistoryList[inx].totalPayable}',
                                                                                          style: Get.textTheme.bodyMedium!.copyWith(
                                                                                            color: Colors.black,
                                                                                            fontSize: 13,
                                                                                          ),
                                                                                        )
                                                                                      : Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          children: [
                                                                                            Text(
                                                                                              ' ${historyController.astroMallHistoryList[inx].totalPayable.toString().split(".").first}',
                                                                                              style: Get.textTheme.bodyMedium!.copyWith(
                                                                                                color: Colors.black,
                                                                                                fontSize: 13,
                                                                                              ),
                                                                                            ),
                                                                                            SizedBox(
                                                                                              width: 1.w,
                                                                                            ),
                                                                                            Image.network(
                                                                                              global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                              height: 1.6.h,
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        'Order Status: ',
                                                                                        style: Get.textTheme.bodyMedium!.copyWith(fontSize: 13),
                                                                                      ).tr(),
                                                                                      Text(
                                                                                        historyController.astroMallHistoryList[inx].orderStatus!.toUpperCase(),
                                                                                        style: TextStyle(
                                                                                            fontSize: 13,
                                                                                            color: historyController.astroMallHistoryList[inx].orderStatus! == "Cancelled"
                                                                                                ? Colors.orange
                                                                                                : historyController.astroMallHistoryList[inx].orderStatus! == "Pending"
                                                                                                    ? Colors.red
                                                                                                    : Colors.green),
                                                                                      ).tr(),
                                                                                    ],
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      historyController.astroMallHistoryList[inx].orderStatus == 'Pending' || historyController.astroMallHistoryList[inx].orderStatus == "Confirmed"
                                                                                          ? ElevatedButton(
                                                                                              onPressed: () async {
                                                                                                global.showOnlyLoaderDialog(context);
                                                                                                await historyController.cancleOrder(historyController.astroMallHistoryList[inx].id!);
                                                                                                global.hideLoader();
                                                                                              },
                                                                                              child: Text(
                                                                                                "Cancel Order",
                                                                                                style: TextStyle(color: Colors.white),
                                                                                              ).tr())
                                                                                          : const SizedBox(),
                                                                                      InkWell(
                                                                                          onTap: () async {
                                                                                            SharedPreferences sp = await SharedPreferences.getInstance();

                                                                                            print('invoice link is ${historyController.astroMallHistoryList[inx].invoiceLink}');
                                                                                            String token = sp.getString("token") ?? "invalid token";
                                                                                            print('invoice token is $token');
                                                                                            String finalUrl = "${historyController.astroMallHistoryList[inx].invoiceLink}?token=$token";
                                                                                            log('invoice finalUrl is $finalUrl');

                                                                                            if (await canLaunch(finalUrl)) {
                                                                                              await launchUrl(
                                                                                                mode: LaunchMode.externalApplication,
                                                                                                Uri.parse(finalUrl),
                                                                                              );
                                                                                            } else {
                                                                                              print("error in laucnhing url");
                                                                                            }
                                                                                          },
                                                                                          child: Icon(Icons.download))
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                              Column(children: [
                                                                                Container(
                                                                                  height: 65,
                                                                                  width: 65,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                                                                  child: CircleAvatar(
                                                                                    radius: 35,
                                                                                    backgroundColor: Colors.white,
                                                                                    child: CachedNetworkImage(
                                                                                      imageUrl: global.buildImageUrl('${historyController.astroMallHistoryList[inx].productImage}'),
                                                                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                      errorWidget: (context, url, error) => Image.asset(
                                                                                        Images.deafultUser,
                                                                                        fit: BoxFit.cover,
                                                                                        height: 50,
                                                                                        width: 40,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ])
                                                                            ],
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  historyController.isMoreDataAvailable ==
                                                                              true &&
                                                                          !historyController
                                                                              .isAllDataLoaded &&
                                                                          historyController.astroMallHistoryList.length - 1 ==
                                                                              inx
                                                                      ? const CircularProgressIndicator()
                                                                      : const SizedBox(),
                                                                  inx ==
                                                                          historyController.astroMallHistoryList.length -
                                                                              1
                                                                      ? const SizedBox(
                                                                          height:
                                                                              50,
                                                                        )
                                                                      : const SizedBox()
                                                                ],
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      )
                                                    : (historyController
                                                            .simmerLoader
                                                        ? fakeSkeltonWidget()
                                                        : SizedBox(
                                                            height: Get.height -
                                                                197,
                                                            child: NoDataWidget(
                                                              title:
                                                                  "Shopping history not available",
                                                            )))
                                              ]);
                                            })
                                          : callController
                                                      .tabController!.index ==
                                                  5
                                              ? GetBuilder<HistoryController>(
                                                  builder: (historyController) {
                                                  return Column(
                                                    children: [
                                                      historyController
                                                              .reportHistoryList
                                                              .isNotEmpty
                                                          ? Container(
                                                              height:
                                                                  Get.height -
                                                                      197,
                                                              child:
                                                                  RefreshIndicator(
                                                                onRefresh:
                                                                    () async {
                                                                  historyController
                                                                      .reportHistoryList = [];
                                                                  historyController
                                                                      .reportHistoryList
                                                                      .clear();
                                                                  historyController
                                                                          .reportAllDataLoaded =
                                                                      false;
                                                                  historyController
                                                                      .update();
                                                                  await historyController
                                                                      .getReportHistory(
                                                                          global
                                                                              .currentUserId!,
                                                                          false);
                                                                },
                                                                child: ListView
                                                                    .builder(
                                                                  controller:
                                                                      reportScrollController,
                                                                  itemCount:
                                                                      historyController
                                                                          .reportHistoryList
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return Column(
                                                                      children: [
                                                                        Card(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "${DateFormat("dd MMM yy, hh:mm a").format(historyController.reportHistoryList[index].createdAt!)}",
                                                                                          style: Get.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                                                                        ),
                                                                                        Text(
                                                                                          '${historyController.reportHistoryList[index].firstName} ${historyController.reportHistoryList[index].lastName}',
                                                                                          style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                                                                        ).tr(),
                                                                                        Text(
                                                                                          global.maskMobileNumber(historyController.reportHistoryList[index].contactNo.toString()),
                                                                                          style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                                                                        ).tr(),
                                                                                        Text(
                                                                                          '${historyController.reportHistoryList[index].title}',
                                                                                          style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                                                                        ).tr(),
                                                                                        global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                            ? Text(
                                                                                                '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.reportHistoryList[index].reportRate}',
                                                                                                style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                                                                              )
                                                                                            : Row(
                                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                                children: [
                                                                                                  Text(
                                                                                                    '${historyController.reportHistoryList[index].reportRate}',
                                                                                                    style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp),
                                                                                                  ),
                                                                                                  SizedBox(
                                                                                                    width: 1.w,
                                                                                                  ),
                                                                                                  Image.network(
                                                                                                    global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                                    height: 1.6.h,
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                        historyController.reportHistoryList[index].isFileUpload!
                                                                                            ? ElevatedButton(
                                                                                                onPressed: () {
                                                                                                  Get.to(() => ViewReportScreen(index: index));
                                                                                                },
                                                                                                child: Text(
                                                                                                  "View Report",
                                                                                                  style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500, fontSize: 16.sp, color: Colors.white),
                                                                                                ).tr())
                                                                                            : const SizedBox()
                                                                                      ],
                                                                                    ),
                                                                                    Column(children: [
                                                                                      Text(
                                                                                        '${historyController.reportHistoryList[index].astrologerName}',
                                                                                        style: Get.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                                                                                      ).tr(),
                                                                                      const SizedBox(
                                                                                        height: 12,
                                                                                      ),
                                                                                      Center(
                                                                                        child: Container(
                                                                                          height: 65,
                                                                                          width: 65,
                                                                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(7), border: Border.all(color: Get.theme.primaryColor)),
                                                                                          child: CircleAvatar(
                                                                                            radius: 35,
                                                                                            backgroundColor: Colors.white,
                                                                                            child: CachedNetworkImage(
                                                                                              imageUrl: global.buildImageUrl('${historyController.reportHistoryList[index].profileImage}'),
                                                                                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                              errorWidget: (context, url, error) => Image.asset(
                                                                                                Images.deafultUser,
                                                                                                fit: BoxFit.cover,
                                                                                                height: 50,
                                                                                                width: 40,
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ])
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        historyController.reportMoreDataAvailable == true &&
                                                                                !historyController.reportAllDataLoaded &&
                                                                                historyController.reportHistoryList.length - 1 == index
                                                                            ? const CircularProgressIndicator()
                                                                            : const SizedBox(),
                                                                        index ==
                                                                                historyController.reportHistoryList.length - 1
                                                                            ? const SizedBox(
                                                                                height: 50,
                                                                              )
                                                                            : const SizedBox()
                                                                      ],
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox(
                                                              height:
                                                                  Get.height -
                                                                      197,
                                                              child:
                                                                  NoDataWidget(
                                                                title:
                                                                    "Report history not available",
                                                              ),
                                                            )
                                                    ],
                                                  );
                                                })
                                              : (historyController.simmerLoader
                                                  ? fakeSkeltonWidget()
                                                  : Column(
                                                      children: [
                                                        Container(height: 100),
                                                        Image.asset(
                                                            Images.noData,
                                                            height: 150,
                                                            width: 150),
                                                        Text(
                                                          'Uh - oh!',
                                                        ).tr(),
                                                      ],
                                                    )),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// scheduledDate -> DateTime of your appointment
  /// scheduledTime -> String like "15:30" (optional if your DateTime already has time)
  Widget buildCountdown(DateTime scheduledDate, {String? scheduledTime}) {
    DateTime target = scheduledDate;

    // If you have a separate time string like "15:30"
    if (scheduledTime != null && scheduledTime.contains(":")) {
      final parts = scheduledTime.split(":");
      target = target.copyWith(
        hour: int.tryParse(parts[0]) ?? 0,
        minute: int.tryParse(parts[1]) ?? 0,
      );
    }

    int endTime = target.millisecondsSinceEpoch;

    return CountdownTimer(
      endTime: endTime,
      widgetBuilder: (_, time) {
        if (time == null) {
          return Text(
            "Starting now",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          );
        }
        return Text(
          "Starts in: "
          "${time.days != null ? "${time.days}d " : ""}"
          "${time.hours != null ? "${time.hours}h " : ""}"
          "${time.min != null ? "${time.min}m " : ""}"
          "${time.sec != null ? "${time.sec}s" : ""}",
          style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp),
        );
      },
    );
  }
}
