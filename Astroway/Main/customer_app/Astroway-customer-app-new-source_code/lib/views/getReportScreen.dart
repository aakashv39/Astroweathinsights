// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/languageController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/reportTabFiltter.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/skillController.dart';
import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/reportTypeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/walletController.dart';
import '../utils/images.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'astrologerProfile/astrologerProfile.dart';

class GetReportScreen extends StatefulWidget {
  GetReportScreen({Key? key}) : super(key: key);

  @override
  State<GetReportScreen> createState() => _GetReportScreenState();
}

class _GetReportScreenState extends State<GetReportScreen> {
  final reportController = Get.find<ReportController>();
  final reportFilter = Get.find<ReportFilterTabController>();
  final skillController = Get.find<SkillController>();
  final languageController = Get.find<LanguageController>();
  final bottomController = Get.find<BottomNavigationController>();
  final walletController = Get.find<WalletController>();
  @override
  void initState() {
    super.initState();
    paginateTask();
  }

  void paginateTask() {
    bottomController.getReportscrollController.addListener(() async {
      log('start pagination ${bottomController.isAllDataLoaded}');
      if (bottomController.getReportscrollController.position.pixels ==
              bottomController
                  .getReportscrollController.position.maxScrollExtent &&
          !bottomController.isAllDataLoaded) {
        bottomController.isMoreDataAvailable = true;
        bottomController.update();
        if (bottomController.selectedCatId == null ||
            bottomController.selectedCatId! == 0) {
          if (bottomController.isChatAstroDataLoadedOnce == false) {
            bottomController.isChatAstroDataLoadedOnce = true;
            bottomController.update();
            bottomController.getAstrologerList(
                skills: bottomController.skillFilterList,
                gender: bottomController.genderFilterList,
                language: bottomController.languageFilter,
                sortBy: bottomController.sortingFilter,
                isLazyLoading: true);
            bottomController.isChatAstroDataLoadedOnce = false;
            bottomController.update();
          }
        } else {
          bottomController.astrologerList = [];
          bottomController.astrologerList.clear();
          bottomController.isAllDataLoaded = false;
          bottomController.update();
          bottomController.astroCat(
              id: bottomController.selectedCatId!, isLazyLoading: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        title:
            Text('Get Detailed Report', style: TextStyle(color: Colors.white))
                .tr(),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          global.currentUserId == null
              ? const SizedBox()
              : InkWell(
                  onTap: () async {
                    global.showOnlyLoaderDialog(context);
                    await walletController.getAmount();
                    global.hideLoader();
                    Get.to(() => AddmoneyToWallet());
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Get.theme.primaryColor),
                    ),
                    margin:
                        EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                    alignment: Alignment.center,
                    child: global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.walletType) ==
                            "Wallet"
                        ? Text(
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString()}',
                            style: Get.theme.primaryTextTheme.bodySmall!
                                .copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${global.splashController.currentUser?.walletAmount.toString().split(".").first}',
                                style: Get.theme.primaryTextTheme.bodySmall!
                                    .copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16.sp),
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Image.network(
                                global.getSystemFlagValueForLogin(
                                    global.systemFlagNameList.coinIcon),
                                height: 2.h,
                              )
                            ],
                          ),
                  )),
          // IconButton(
          //     onPressed: () {
          //       Get.to(() => SeachAstrologerReportScreen());
          //     },
          //     icon: Icon(Icons.search, color: Colors.black)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          bottomController.astrologerList = [];
          bottomController.astrologerList.clear();
          bottomController.isAllDataLoaded = false;
          bottomController.update();
          await bottomController.getAstrologerList(isLazyLoading: false);
        },
        child:
            GetBuilder<BottomNavigationController>(builder: (bottomController) {
          return bottomController.astrologerList.isEmpty
              ? Center(
                  child: Text('Astrologer not Available').tr(),
                )
              : ListView.builder(
                  itemCount: bottomController.astrologerList.length,
                  shrinkWrap: true,
                  controller: bottomController.getReportscrollController,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () async {
                        Get.find<ReviewController>().getReviewData(
                            bottomController.astrologerList[index].id!);
                        global.showOnlyLoaderDialog(context);
                        await bottomController.getAstrologerbyId(
                            bottomController.astrologerList[index].id!);
                        global.hideLoader();
                        Get.to(() => AstrologerProfile(index: index));
                      },
                      child: Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      Stack(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  border: Border.all(
                                                      color: Get
                                                          .theme.primaryColor)),
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                child: CachedNetworkImage(
                                                  height: 55,
                                                  width: 55,
                                                  imageUrl: global.buildImageUrl(
                                                      '${bottomController.astrologerList[index].profileImage}'),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Image.asset(
                                                          Images.deafultUser,
                                                          fit: BoxFit.fill,
                                                          height: 50,
                                                        ));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 0,
                                              child: Image.asset(
                                                Images.right,
                                                height: 18,
                                              ))
                                        ],
                                      ),
                                      RatingBar.builder(
                                        initialRating: 0,
                                        itemCount: 5,
                                        allowHalfRating: false,
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Get.theme.primaryColor,
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            Images.userProfile,
                                            height: 10,
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            '${bottomController.astrologerList[index].totalOrder} orders',
                                            style: Get.theme.primaryTextTheme
                                                .bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 9,
                                            ),
                                          ).tr(),
                                        ],
                                      )
                                    ],
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bottomController
                                                .astrologerList[index].name!,
                                          ).tr(),
                                          Text(
                                            bottomController
                                                .astrologerList[index]
                                                .allSkill!,
                                            style: Get.theme.primaryTextTheme
                                                .bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[600],
                                            ),
                                          ).tr(),
                                          Text(
                                            bottomController
                                                .astrologerList[index]
                                                .languageKnown!,
                                            style: Get.theme.primaryTextTheme
                                                .bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[600],
                                            ),
                                          ).tr(),
                                          Text(
                                            '${tr("Experience")}: ${bottomController.astrologerList[index].experienceInYears} ${tr("Years")}',
                                            style: Get.theme.primaryTextTheme
                                                .bodySmall!
                                                .copyWith(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[600],
                                            ),
                                          ).tr(),
                                          Row(
                                            children: [
                                              global.getSystemFlagValueForLogin(
                                                          global
                                                              .systemFlagNameList
                                                              .walletType) ==
                                                      "Wallet"
                                                  ? Text(
                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomController.astrologerList[index].reportRate}/report',
                                                      style: Get.theme.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                        color: Colors.black54,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0,
                                                      ),
                                                    ).tr()
                                                  : Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          '${bottomController.astrologerList[index].reportRate}',
                                                          style: Get
                                                              .theme
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0,
                                                          ),
                                                        ).tr(),
                                                        SizedBox(
                                                          width: 0.6.w,
                                                        ),
                                                        Image.network(
                                                          global.getSystemFlagValueForLogin(
                                                              global
                                                                  .systemFlagNameList
                                                                  .coinIcon),
                                                          height: 1.6.h,
                                                        ),
                                                        Text(
                                                          '/report',
                                                          style: Get
                                                              .theme
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0,
                                                          ),
                                                        ).tr(),
                                                      ],
                                                    ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                          padding: WidgetStateProperty.all(
                                              EdgeInsets.all(0)),
                                          fixedSize: WidgetStateProperty.all(
                                              Size.fromWidth(90)),
                                          backgroundColor:
                                              WidgetStateProperty.all(
                                                  Colors.green),
                                          shape: WidgetStateProperty.all(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        onPressed: () async {
                                          bool isLogin = await global.isLogin();
                                          if (isLogin) {
                                            double charge = double.parse(
                                                bottomController
                                                    .astrologerList[index]
                                                    .reportRate
                                                    .toString());
                                            if (charge <=
                                                global
                                                    .splashController
                                                    .currentUser!
                                                    .walletAmount!) {
                                              global.showOnlyLoaderDialog(
                                                  context);
                                              reportController.searchString =
                                                  null;
                                              reportController.reportTypeList =
                                                  [];
                                              reportController.reportTypeList
                                                  .clear();
                                              reportController.isAllDataLoaded =
                                                  false;
                                              reportController.update();
                                              await reportController
                                                  .getReportTypes(null, false);
                                              global.hideLoader();
                                              Get.to(() => ReportTypeScreen(
                                                    astrologerId:
                                                        bottomController
                                                            .astrologerList[
                                                                index]
                                                            .id!,
                                                    astrologerName:
                                                        bottomController
                                                            .astrologerList[
                                                                index]
                                                            .name!,
                                                  ));
                                            } else {
                                              global.showOnlyLoaderDialog(
                                                  context);
                                              await walletController
                                                  .getAmount();
                                              global.hideLoader();

                                              global.showMinimumBalancePopup(
                                                  context,
                                                  (charge * 5).toString(),
                                                  '${bottomController.astrologerList[index].name!}',
                                                  walletController.payment,
                                                  "Report",
                                                  isForGift: true);

                                              // openBottomSheetRechrage(
                                              //     context,
                                              //     charge.toString(),
                                              //     '${bottomController.astrologerList[index].name!}');
                                            }
                                          }
                                        },
                                        child: Text(
                                          'Get report',
                                          style: Get
                                              .theme.primaryTextTheme.bodySmall!
                                              .copyWith(color: Colors.white),
                                        ).tr(),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          bottomController.isMoreDataAvailable == true &&
                                  !bottomController.isAllDataLoaded &&
                                  bottomController.astrologerList.length - 1 ==
                                      index
                              ? const CircularProgressIndicator()
                              : const SizedBox(),
                          index == bottomController.astrologerList.length - 1
                              ? const SizedBox(
                                  height: 50,
                                )
                              : const SizedBox()
                        ],
                      ),
                    );
                  },
                );
        }),
      ),
      bottomSheet: Container(
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 1),
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SingleChildScrollView(
                          child:
                              GetBuilder<ReportController>(builder: (report) {
                            return SizedBox(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, right: 8, top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Sort by').tr(),
                                          IconButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              icon: Icon(Icons.close))
                                        ],
                                      ),
                                    ),
                                    ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: reportController
                                            .reportSorting.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () async {
                                                  for (var i = 0;
                                                      i <
                                                          reportController
                                                              .reportSorting
                                                              .length;
                                                      i++) {
                                                    if (reportController
                                                            .reportSorting[i]
                                                            .isSeledted ==
                                                        false) {
                                                      if (i == index) {
                                                        reportController
                                                            .reportSorting[
                                                                index]
                                                            .isSeledted = true;
                                                        reportController
                                                            .update();
                                                        print(
                                                            'aif ${reportController.reportSorting[index].name} ${reportController.reportSorting[index].isSeledted}');
                                                      } else {
                                                        reportController
                                                            .reportSorting[i]
                                                            .isSeledted = false;
                                                        print(
                                                            'else ${reportController.reportSorting[i].name} ${reportController.reportSorting[i].isSeledted}');
                                                      }
                                                    } else {
                                                      reportController
                                                          .reportSorting[i]
                                                          .isSeledted = false;
                                                      print(
                                                          'else ${reportController.reportSorting[i].name} ${reportController.reportSorting[i].isSeledted}');
                                                    }
                                                  }
                                                  print(
                                                      'if ${reportController.reportSorting[index].isSeledted} ${reportController.reportSorting[index].name}');
                                                  if (reportController
                                                          .reportSorting[index]
                                                          .isSeledted ==
                                                      true) {
                                                    global.showOnlyLoaderDialog(
                                                        context);
                                                    await reportController
                                                        .getAstrologerSorting(
                                                            reportController
                                                                .reportSorting[
                                                                    index]
                                                                .value!);
                                                    global.hideLoader();
                                                  }
                                                  Get.back();
                                                  reportController.update();
                                                },
                                                child: Container(
                                                  color: reportController
                                                              .reportSorting[
                                                                  index]
                                                              .isSeledted ==
                                                          true
                                                      ? Colors.grey.shade200
                                                      : Colors.transparent,
                                                  child: Align(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 15,
                                                                top: 8,
                                                                bottom: 8),
                                                        child: Text(
                                                                reportController
                                                                    .reportSorting[
                                                                        index]
                                                                    .name!)
                                                            .tr(),
                                                      )),
                                                ),
                                              ),
                                              Divider(height: 0)
                                            ],
                                          );
                                        })
                                  ]),
                            );
                          }),
                        );
                      });
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.sort,
                      size: 18,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('SORT').tr()
                  ],
                ),
              ),
              VerticalDivider(
                thickness: 2,
              ),
              GestureDetector(
                onTap: () {
                  for (var i = 0; i < reportFilter.gender.length; i++) {
                    reportFilter.gender[i].isCheck = false;
                    reportFilter.update();
                  }
                  openBottomSheetFilter(context);
                  skillController.getSkills();
                  languageController.getLanguages();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.sort,
                      size: 18,
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Filter').tr()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                        controller: reportFilter.reportFilterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          reportFilter.selectedFilterIndex.value = index;
                          reportFilter.update();
                        },
                        tabs: List.generate(
                          reportFilter.reportFilter.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: reportFilter.selectedFilterIndex.value ==
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
                                        color: reportFilter.selectedFilterIndex
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        reportFilter.reportFilter[ind],
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
                      controller: reportFilter.reportFilterTab,
                      children: [
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<SkillController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
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
                                          title: Text(skillController
                                                  .skillList[index].name)
                                              .tr(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<LanguageController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
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
                                          title: Text(languageController
                                                  .languageList[index]
                                                  .languageName)
                                              .tr(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                          child: RotatedBox(
                              quarterTurns: -1,
                              child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: reportFilter.gender.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return GetBuilder<
                                                ReportFilterTabController>(
                                            builder: (filterController) {
                                          return CheckboxListTile(
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                            contentPadding: EdgeInsets.zero,
                                            activeColor: Colors.black,
                                            value: reportFilter
                                                .gender[index].isCheck,
                                            onChanged: (value) {
                                              reportFilter.gender[index]
                                                  .isCheck = value!;
                                              reportFilter.update();
                                            },
                                            title: Text(reportFilter
                                                    .gender[index].name)
                                                .tr(),
                                          );
                                        });
                                      }))),
                        ),
                        SizedBox()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                              languageController.languageFilterList = [];
                              reportController.sortingFilter = null;
                              reportFilter.genderFilterList = [];
                              bottomController.astrologerList.clear();
                              for (var i = 0;
                                  i < skillController.skillList.length;
                                  i++) {
                                skillController.skillList[i].isSelected = false;

                                skillController.update();
                              }
                              for (var i = 0;
                                  i < languageController.languageList.length;
                                  i++) {
                                languageController.languageList[i].isSelected =
                                    false;

                                languageController.update();
                              }
                              for (var i = 0;
                                  i < reportFilter.gender.length;
                                  i++) {
                                reportFilter.gender[i].isCheck = false;

                                reportFilter.update();
                              }

                              await bottomController.getAstrologerList(
                                skills: skillController.skillFilterList,
                                gender: reportFilter.genderFilterList,
                                language: languageController.languageFilterList,
                              );

                              Get.back();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black54),
                            ).tr(),
                          ),
                        )),
                        Expanded(child: GetBuilder<SkillController>(
                          builder: (controller) {
                            return SizedBox(
                              width: 80,
                              height: 55,
                              child: TextButton(
                                onPressed: () async {
                                  global.showOnlyLoaderDialog(context);
                                  skillController.skillFilterList = [];
                                  languageController.languageFilterList = [];
                                  reportController.sortingFilter = null;
                                  reportFilter.genderFilterList = [];

                                  for (var i = 0;
                                      i < skillController.skillList.length;
                                      i++) {
                                    if (skillController
                                            .skillList[i].isSelected ==
                                        true) {
                                      skillController.skillFilterList.add(
                                          skillController.skillList[i].id!);
                                      skillController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i < reportFilter.gender.length;
                                      i++) {
                                    if (reportFilter.gender[i].isCheck ==
                                        true) {
                                      reportFilter.genderFilterList
                                          .add(reportFilter.gender[i].name);
                                      reportFilter.update();
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
                                      languageController.languageFilterList.add(
                                          languageController
                                              .languageList[i].id!);
                                      languageController.update();
                                    }
                                  }
                                  bottomController.astrologerList = [];
                                  bottomController.getAstrologerList(
                                      skills: skillController.skillFilterList,
                                      language:
                                          languageController.languageFilterList,
                                      gender: reportFilter.genderFilterList);

                                  global.hideLoader();
                                  global.hideLoader();
                                },
                                child: Text(
                                  'Apply',
                                  style: TextStyle(color: Colors.white),
                                ).tr(),
                                style: ButtonStyle(
                                  padding: WidgetStateProperty.all(
                                      EdgeInsets.all(8)),
                                  backgroundColor: WidgetStateProperty.all(
                                      Get.theme.primaryColor),
                                  foregroundColor:
                                      WidgetStateProperty.all(Colors.black),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
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
}
