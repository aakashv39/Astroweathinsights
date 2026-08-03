import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/CornerBanner.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/CustomText.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/astrologerProfile.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TopRatedAstrologersWidget extends StatelessWidget {
  final BottomNavigationController bottomNavigationController;
  const TopRatedAstrologersWidget(
      {super.key, required this.bottomNavigationController});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavigationController>(
        builder: (bottomNavigationController) {
      if (bottomNavigationController.astrologerList.isEmpty) {
        return const SizedBox.shrink();
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top rated astrologer',
                  style: Get.theme.primaryTextTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.w500),
                ).tr(),
                GestureDetector(
                  onTap: () {
                    bottomNavigationController.persistentTabController!
                        .jumpToTab(1);
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
          ),
          SizedBox(height: 1.h),
          Container(
            width: 100.w,
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(
                  bottomNavigationController.astrologerList.length,
                  (index) => InkWell(
                    onTap: () async {
                      Get.find<ReviewController>().getReviewData(
                          bottomNavigationController.astrologerList[index].id!);
                      global.showOnlyLoaderDialog(context);
                      await bottomNavigationController.getAstrologerbyId(
                          bottomNavigationController.astrologerList[index].id!);
                      global.hideLoader();
                      await Get.to(() => AstrologerProfile(
                            index: index,
                          ));
                    },
                    child: Stack(
                      children: [
                        Card(
                          surfaceTintColor: bottomNavigationController
                                      .astrologerList[index].isBoosted ==
                                  Images.ISBOOSTED
                              ? Colors.limeAccent
                              : Color(0xfffdf8f2),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 1.w, vertical: 2.w),
                            width: 42.w,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Container(
                                        width: 25.w,
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(top: 2.w),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        decoration: BoxDecoration(
                                          color: Colors.limeAccent,
                                          border: Border.all(
                                              color: blackColor, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(1.w),
                                        ),
                                        child: Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          '${bottomNavigationController.astrologerList[index].astrologerCategory}',
                                          style: Get.theme.textTheme.bodyMedium!
                                              .copyWith(
                                                  color: blackColor,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500),
                                        )),
                                    bottomNavigationController
                                                        .astrologerList[index]
                                                        .callStatus ==
                                                    "Offline" &&
                                                bottomNavigationController
                                                        .astrologerList[index]
                                                        .chatStatus ==
                                                    "Offline" ||
                                            bottomNavigationController
                                                    .astrologerList[index]
                                                    .callStatus ==
                                                "Busy"
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                left: 1.w, top: 1.w),
                                            child: CircleAvatar(
                                              radius: 1.h,
                                              backgroundColor: bottomNavigationController
                                                              .astrologerList[
                                                                  index]
                                                              .callStatus ==
                                                          "Offline" &&
                                                      bottomNavigationController
                                                              .astrologerList[
                                                                  index]
                                                              .chatStatus ==
                                                          "Offline"
                                                  ? Colors.red
                                                  : bottomNavigationController
                                                              .astrologerList[
                                                                  index]
                                                              .callStatus ==
                                                          "Busy"
                                                      ? Colors.orange
                                                      : Colors.green,
                                            ),
                                          )
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Image.asset(
                                              "assets/images/online.gif",
                                              height: 2.0.h,
                                              color: Colors.lime,
                                            ),
                                          ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                                Stack(
                                  alignment: Alignment.center,
                                  clipBehavior: Clip.none,
                                  children: [
                                    CommonCachedNetworkImage(
                                      height: 100,
                                      width: 100,
                                      borderRadius: 100.w,
                                      imageUrl:
                                      global.buildImageUrl('${bottomNavigationController.astrologerList[index].profileImage}') ,
                                    ),
                                    Positioned(
                                        right: 4.w,
                                        bottom: -2.w,
                                        left: 4.w,
                                        child: Container(
                                          width: 29.w,
                                          height: 2.h,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(2.w)),
                                            border: Border.all(
                                                color: Get.theme.primaryColor,
                                                width: 1),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                color: Get.theme.primaryColor,
                                                size: 15.sp,
                                              ),
                                              Center(
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  bottomNavigationController
                                                              .astrologerList[
                                                                  index]
                                                              .rating ==
                                                          0.0
                                                      ? "4.5"
                                                      : "${bottomNavigationController.astrologerList[index].rating!.toStringAsFixed(1)}",
                                                  style: Get.theme.textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 1),
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                                SizedBox(height: 2.h),
                                CustomText(
                                  text:
                                      "${bottomNavigationController.astrologerList[index].name!.length > 13 ? "${bottomNavigationController.astrologerList[index].name!.substring(0, 13)}.." : bottomNavigationController.astrologerList[index].name}",
                                  textAlign: TextAlign.center,
                                  maxLine: 2,
                                  fontWeight: FontWeight.w800,
                                  fontsize: 16.sp,
                                ),
                                CustomText(
                                  text:
                                      "Exp. ${bottomNavigationController.astrologerList[index].experienceInYears} Years",
                                  textAlign: TextAlign.center,
                                  maxLine: 2,
                                  fontWeight: FontWeight.w500,
                                  fontsize: 16.sp,
                                ),
                                SizedBox(
                                  height: 3.h,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.language,
                                        color: Colors.grey,
                                        size: 17.sp,
                                      ),
                                      SizedBox(width: 2),
                                      CustomText(
                                        text:
                                            "${bottomNavigationController.astrologerList[index].languageKnown!.length > 14 ? "${bottomNavigationController.astrologerList[index].languageKnown!.substring(0, 14)}.." : bottomNavigationController.astrologerList[index].languageKnown}",
                                        textAlign: TextAlign.center,
                                        maxLine: 2,
                                        fontWeight: FontWeight.w500,
                                        fontsize: 16.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                bottomNavigationController.astrologerList[index]
                                            .isFreeAvailable ==
                                        true
                                    ? Container(
                                        width: 35.w,
                                        height: 3.h,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          border: Border.all(
                                              color: blackColor, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(1.w),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            global.getSystemFlagValueForLogin(
                                                        global
                                                            .systemFlagNameList
                                                            .walletType) ==
                                                    "Wallet"
                                                ? CustomText(
                                                    text:
                                                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].charge}/min',
                                                    fontWeight: FontWeight.w500,
                                                    color: blackColor,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationColor: blackColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontsize: 16.sp,
                                                    maxLine: 1,
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CustomText(
                                                        text:
                                                            '${bottomNavigationController.astrologerList[index].charge}',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: blackColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            blackColor,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontsize: 16.sp,
                                                        maxLine: 1,
                                                      ),
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
                                                      CustomText(
                                                        text: '/min',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: blackColor,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        decorationColor:
                                                            blackColor,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        fontsize: 16.sp,
                                                        maxLine: 1,
                                                      )
                                                    ],
                                                  ),
                                            SizedBox(width: 2.w),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.w,
                                                  vertical: 1.w),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1.w),
                                                  color: Colors.limeAccent),
                                              child: CustomText(
                                                text: 'FREE',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                                overflow: TextOverflow.ellipsis,
                                                fontsize: 14.sp,
                                                maxLine: 1,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(
                                        width: 35.w,
                                        height: 3.h,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 1.w),
                                        decoration: BoxDecoration(
                                          color: Get.theme.primaryColor,
                                          border: Border.all(
                                              color: blackColor, width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(1.w),
                                        ),
                                        child: global
                                                    .getSystemFlagValueForLogin(
                                                        global
                                                            .systemFlagNameList
                                                            .walletType) ==
                                                "Wallet"
                                            ? CustomText(
                                                text:
                                                    'Chat @${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${bottomNavigationController.astrologerList[index].charge}/min',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                                overflow: TextOverflow.ellipsis,
                                                fontsize: 16.sp,
                                                maxLine: 1,
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CustomText(
                                                    text:
                                                        'Chat @${bottomNavigationController.astrologerList[index].charge}',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontsize: 16.sp,
                                                    maxLine: 1,
                                                  ),
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
                                                  CustomText(
                                                    text: '/min',
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    fontsize: 16.sp,
                                                    maxLine: 1,
                                                  ),
                                                ],
                                              ),
                                      ),
                                SizedBox(height: 2.w),
                              ],
                            ),
                          ),
                        ),
                        bottomNavigationController
                                    .astrologerList[index].isBoosted ==
                                Images.ISBOOSTED
                            ? Positioned(
                                left: 0,
                                top: 0,
                                child: CornerBanner(
                                  bannerPosition: CornerBannerPosition.topLeft,
                                  bannerColor: Colors.red,
                                  child: Text(
                                    "Boosted",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 1.h),
        ],
      );
    });
  }
}
