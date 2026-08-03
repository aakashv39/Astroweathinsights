// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../../controllers/bottomNavigationController.dart';
import '../../../controllers/chatController.dart';
import '../../../controllers/reviewController.dart';
import '../../../controllers/walletController.dart';
import '../../../utils/CornerBanner.dart';
import '../../../utils/images.dart';
import '../../astrologerProfile/astrologerProfile.dart';
import '../../callIntakeFormScreen.dart';

class Astrologerchatscreenlisting extends StatefulWidget {
  Astrologerchatscreenlisting({
    Key? key,
  }) : super(key: key);

  @override
  State<Astrologerchatscreenlisting> createState() =>
      _Astrologerchatscreenlisting();
}

class _Astrologerchatscreenlisting extends State<Astrologerchatscreenlisting> {
  final chatController = ChatController();
  final walletController = Get.find<WalletController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final chatScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    log('design 4 chatscreen');
    paginateTask();
  }

  void paginateTask() {
    chatScrollController.addListener(() async {
      if (chatScrollController.position.pixels ==
              chatScrollController.position.maxScrollExtent &&
          !bottomNavigationController.isAllDataLoaded) {
        bottomNavigationController.isMoreDataAvailable = true;
        bottomNavigationController.update();
        if (bottomNavigationController.selectedCatId == null ||
            bottomNavigationController.selectedCatId! == 0) {
          if (bottomNavigationController.isChatAstroDataLoadedOnce == false) {
            bottomNavigationController.isChatAstroDataLoadedOnce = true;
            bottomNavigationController.update();
            await bottomNavigationController.getAstrologerList(
                skills: bottomNavigationController.skillFilterList,
                gender: bottomNavigationController.genderFilterList,
                language: bottomNavigationController.languageFilter,
                sortBy: bottomNavigationController.sortingFilter,
                isLazyLoading: true);
            bottomNavigationController.isChatAstroDataLoadedOnce = false;
            bottomNavigationController.update();
          }
        } else {
          bottomNavigationController.astrologerList = [];
          bottomNavigationController.astrologerList.clear();
          bottomNavigationController.isAllDataLoaded = false;
          bottomNavigationController.update();
          await bottomNavigationController.astroCat(
              id: bottomNavigationController.selectedCatId!,
              isLazyLoading: true);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: scaffbgcolor,
      child: GetBuilder<ChatController>(
        builder: (chatController) => RefreshIndicator(
          onRefresh: () async {
            log('refresh');
            bottomNavigationController.astrologerList = [];
            bottomNavigationController.astrologerList.clear();
            bottomNavigationController.isAllDataLoaded = false;
            if (bottomNavigationController.genderFilterList != null) {
              bottomNavigationController.genderFilterList!.clear();
            }
            if (bottomNavigationController.languageFilter != null) {
              bottomNavigationController.languageFilter!.clear();
            }
            if (bottomNavigationController.skillFilterList != null) {
              bottomNavigationController.skillFilterList!.clear();
            }
            bottomNavigationController.applyFilter = false;
            log('tick on ${chatController.isSelected}');
            if (chatController.isSelected == 0) {
              await bottomNavigationController.getAstrologerList(
                  isLazyLoading: false);
            } else {
              for (var i = 0; i < chatController.categoryList.length; i++) {
                if (chatController.isSelected == i) {
                  bottomNavigationController.astrologerList = [];
                  bottomNavigationController.astrologerList.clear();
                  bottomNavigationController.isAllDataLoaded = false;
                  bottomNavigationController.update();

                  await bottomNavigationController.astroCat(
                    id: chatController.categoryList[i].id!,
                    isLazyLoading: false,
                  );
                }
              }
            }
            bottomNavigationController.update();
          },
          child: GetBuilder<BottomNavigationController>(
            builder: (bottomNavigationController) => ListView.builder(
              itemCount: bottomNavigationController.astrologerList.length,
              controller: chatScrollController,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    await Future.wait<void>([
                      Get.find<ReviewController>().getReviewData(
                          bottomNavigationController.astrologerList[index].id),
                      bottomNavigationController.getAstrologerbyId(
                          bottomNavigationController.astrologerList[index].id)
                    ]);
                    Get.to(() => AstrologerProfile(index: index));
                  },
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.grey.shade300, width: 1),
                        ),
                        margin: EdgeInsets.symmetric(
                            vertical: 0.5.h, horizontal: 3.w),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Stack(
                                    children: [
                                      // Profile Image
                                      Container(
                                        height: 15.h,
                                        width: 13.h,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(2.w),
                                          child: CommonCachedNetworkImage(
                                            height: 15.h,
                                            width: 13.h,
                                            imageUrl:
                                                '${bottomNavigationController.astrologerList[index].profileImage}',
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 0,
                                        top: 0,
                                        child: GetBuilder<
                                            BottomNavigationController>(
                                          builder: (controller) => controller
                                                      .astrologerList[index]
                                                      .isBoosted ==
                                                  Images.ISBOOSTED
                                              ? CornerBanner(
                                                  bannerPosition:
                                                      CornerBannerPosition
                                                          .topLeft,
                                                  bannerColor: Colors.red
                                                      .withOpacity(0.6),
                                                  child: Text(
                                                    "Boosted",
                                                    style: TextStyle(
                                                      fontSize: 13.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                )
                                              : SizedBox(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  InkWell(
                                    onTap: () {
                                      // your action here
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  bottomNavigationController
                                                      .astrologerList[index]
                                                      .rating
                                                      .toString()),
                                              minRating: 1,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 15.sp,
                                              ignoreGestures:
                                                  true, // to disable user interaction
                                              unratedColor:
                                                  Colors.grey.shade300,
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              onRatingUpdate: (rating) {
                                                // Do nothing as it's read-only
                                              },
                                            ),
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  WidgetSpan(
                                                    child: Icon(
                                                        CupertinoIcons
                                                            .star_circle,
                                                        color: Get
                                                            .theme.primaryColor,
                                                        size: 15.sp),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        " ${bottomNavigationController.astrologerList[index].rating.toString()} ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.black54,
                                                        fontSize: 14.sp),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 1.w,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                bottomNavigationController
                                                            .astrologerList[
                                                                index]
                                                            .name!
                                                            .length >
                                                        16
                                                    ? '${bottomNavigationController.astrologerList[index].name!.substring(0, 16)}..'
                                                    : bottomNavigationController
                                                        .astrologerList[index]
                                                        .name!,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17.sp,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ).tr(),
                                              SizedBox(
                                                width: 2.w,
                                              ),
                                              Icon(
                                                CupertinoIcons
                                                    .checkmark_seal_fill,
                                                color: const Color(0xFF49AA4C),
                                                size: 18.sp,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              bottomNavigationController
                                                      .astrologerList[index]
                                                      .courseBadges!
                                                      .isEmpty
                                                  ? SizedBox()
                                                  : Image.asset(
                                                      "assets/images/rewards.png",
                                                      fit: BoxFit.contain,
                                                      height: 2.5.h,
                                                      width: 8.w,
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                      bottomNavigationController
                                                  .astrologerList[index]
                                                  .allSkill ==
                                              ""
                                          ? const SizedBox()
                                          : Row(
                                              children: [
                                                Icon(
                                                  Icons.pix_rounded,
                                                  size: 17.sp,
                                                  color: Colors.black54,
                                                ),
                                                SizedBox(
                                                  width: 1.w,
                                                ),
                                                Container(
                                                  width: 47.w,
                                                  child: Text(
                                                    bottomNavigationController
                                                        .astrologerList[index]
                                                        .allSkill
                                                        .toString()
                                                        .replaceAll(",", " • "),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black54,
                                                        fontSize: 15.sp),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ).tr(),
                                                ),
                                              ],
                                            ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      bottomNavigationController
                                                  .astrologerList[index]
                                                  .languageKnown ==
                                              ""
                                          ? const SizedBox()
                                          : Container(
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "assets/images/translation.png",
                                                    height: 2.5.h,
                                                    width: 4.w,
                                                    color: Colors.black54,
                                                  ),
                                                  SizedBox(
                                                    width: 1.w,
                                                  ),
                                                  Container(
                                                    width: 47.w,
                                                    child: Text(
                                                      bottomNavigationController
                                                          .astrologerList[index]
                                                          .languageKnown
                                                          .toString()
                                                          .replaceAll(
                                                              ",", " • "),
                                                      style: Get
                                                          .theme
                                                          .primaryTextTheme
                                                          .bodySmall!
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 15.sp),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ).tr(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      SizedBox(height: 5),
                                      Container(
                                        width: 47.w,
                                        child: Row(
                                          children: [
                                            Icon(
                                              CupertinoIcons.layers_alt_fill,
                                              size: 17.sp,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(width: 1.w),
                                            global.buildTranslatedText(
                                              'Experience: ${bottomNavigationController.astrologerList[index].experienceInYears} Years',
                                              Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54,
                                                      fontSize: 15.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          // ⭐ Rating with Cupertino Icon
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                      CupertinoIcons
                                                          .star_circle,
                                                      color: Colors.black54,
                                                      size: 15.sp),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${bottomNavigationController.astrologerList[index].rating}  ",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54,
                                                      fontSize: 15.sp),
                                                ),
                                              ],
                                            ),
                                          ),

                                          const SizedBox(width: 6),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                WidgetSpan(
                                                  child: Icon(
                                                    CupertinoIcons
                                                        .cube_box_fill,
                                                    color: Colors.blueGrey,
                                                    size: 14,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " ${bottomNavigationController.astrologerList[index].totalOrder} ${tr('Orders')}",
                                                  style: Get
                                                      .theme
                                                      .primaryTextTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: Colors.black54,
                                                          fontSize: 15.sp),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 0.5.h,
                                      ),
                                      Container(
                                        width: 47.w,
                                        child: Row(
                                          children: [
                                            bottomNavigationController
                                                        .astrologerList[index]
                                                        .isFreeAvailable ==
                                                    true
                                                ? Text(
                                                    'FREE',
                                                    style: Get.theme.textTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      letterSpacing: 0,
                                                      color: Colors.black,
                                                    ),
                                                  ).tr()
                                                : bottomNavigationController
                                                            .astrologerList[
                                                                index]
                                                            .isDiscountedPrice !=
                                                        0
                                                    ? (global.getSystemFlagValueForLogin(global
                                                                .systemFlagNameList
                                                                .walletType) ==
                                                            "Wallet"
                                                        ? Text(
                                                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].charge}/min',
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color:
                                                                  Colors.grey,
                                                              decorationColor:
                                                                  Colors.red,
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                            ),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${bottomNavigationController.astrologerList[index].charge}',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey,
                                                                  decorationColor:
                                                                      Colors
                                                                          .red,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 0.4.w,
                                                              ),
                                                              Image.network(
                                                                global.getSystemFlagValueForLogin(global
                                                                    .systemFlagNameList
                                                                    .coinIcon),
                                                                height: 1.2.h,
                                                              ),
                                                              Text(
                                                                "/min",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Colors
                                                                      .grey,
                                                                  decorationColor:
                                                                      Colors
                                                                          .red,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                              )
                                                            ],
                                                          ))
                                                    : SizedBox.shrink(),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 1.h),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                              onTap: () async {
                                                bool isLogin =
                                                    await global.isLogin();
                                                if (!isLogin) return;

                                                if (bottomNavigationController
                                                        .astrologerList[index]
                                                        .chat_sections
                                                        .toString() ==
                                                    "0") {
                                                  Get.snackbar(
                                                    "Note",
                                                    "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Chat",
                                                    backgroundColor:
                                                        Colors.orange,
                                                    colorText: Colors.white,
                                                  );
                                                } else {
                                                  await showChatBottomSheet(
                                                    context: context,
                                                    onInstantChat: () async {
                                                      await bottomNavigationController
                                                          .getAstrologerbyId(
                                                        bottomNavigationController
                                                            .astrologerList[
                                                                index]
                                                            .id,
                                                      );
                                                      if (double.parse(bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .charge
                                                                      .toString()) *
                                                                  5.0 <=
                                                              double.parse(global
                                                                  .splashController
                                                                  .currentUser!
                                                                  .walletAmount
                                                                  .toString()) ||
                                                          bottomNavigationController
                                                                  .astrologerList[
                                                                      index]
                                                                  .isFreeAvailable ==
                                                              true) {
                                                        await bottomNavigationController
                                                            .checkAlreadyInReq(
                                                                bottomNavigationController
                                                                    .astrologerList[
                                                                        index]
                                                                    .id);
                                                        if (bottomNavigationController
                                                                .isUserAlreadyInChatReq ==
                                                            false) {
                                                          if (bottomNavigationController
                                                                  .astrologerList[
                                                                      index]
                                                                  .chatStatus ==
                                                              "Online") {
                                                            global
                                                                .showOnlyLoaderDialog(
                                                                    context);

                                                            await Get.to(() =>
                                                                CallIntakeFormScreen(
                                                                  type: "Chat",
                                                                  bookingType:
                                                                      'schedule',
                                                                  astrologerId:
                                                                      bottomNavigationController
                                                                          .astrologerList[
                                                                              index]
                                                                          .id,
                                                                  astrologerName:
                                                                      bottomNavigationController
                                                                              .astrologerList[index]
                                                                              .name ??
                                                                          "",
                                                                  astrologerProfile:
                                                                      bottomNavigationController
                                                                              .astrologerList[index]
                                                                              .profileImage ??
                                                                          "",
                                                                  isFreeAvailable: bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .isFreeAvailable,
                                                                  rate: bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .charge,
                                                                ));
                                                            global.hideLoader();
                                                          } else if (bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .chatStatus ==
                                                                  "Offline" ||
                                                              bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .chatStatus ==
                                                                  "Busy" ||
                                                              bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .chatStatus ==
                                                                  "Wait Time") {
                                                            bottomNavigationController.dialogForJoinInWaitList(
                                                                context,
                                                                bottomNavigationController
                                                                        .astrologerList[
                                                                            index]
                                                                        .name ??
                                                                    "",
                                                                true,
                                                                bottomNavigationController
                                                                    .astrologerbyId[
                                                                        0]
                                                                    .chatStatus
                                                                    .toString(),
                                                                bottomNavigationController
                                                                        .astrologerList[
                                                                            index]
                                                                        .profileImage ??
                                                                    "");
                                                          }
                                                        } else {
                                                          bottomNavigationController
                                                              .dialogForNotCreatingSession(
                                                                  context);
                                                        }
                                                      } else {
                                                        global
                                                            .showOnlyLoaderDialog(
                                                                context);
                                                        await walletController
                                                            .getAmount();
                                                        global.hideLoader();
                                                        global.showMinimumBalancePopup(
                                                            context,
                                                            (bottomNavigationController
                                                                        .astrologerList[
                                                                            index]
                                                                        .charge *
                                                                    5)
                                                                .toString(),
                                                            bottomNavigationController
                                                                    .astrologerList[
                                                                        index]
                                                                    .name ??
                                                                "",
                                                            walletController
                                                                .payment,
                                                            "Chat");
                                                      }
                                                    },
                                                    onSchedule:
                                                        (DateTime date) async {
                                                      print(
                                                          "User scheduled appointment on $date");
                                                    },
                                                  );
                                                }
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 1.h),
                                                decoration: BoxDecoration(
                                                    color:
                                                        const Color(0xffFFF1CA),
                                                    border: Border.all(
                                                        color: Get
                                                            .theme.primaryColor,
                                                        width: 1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.sp)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Icon(
                                                      CupertinoIcons
                                                          .chat_bubble_2_fill,
                                                      size: 16.sp,
                                                      color: bottomNavigationController
                                                                  .astrologerList[
                                                                      index]
                                                                  .chatStatus ==
                                                              "Online"
                                                          ? Colors
                                                              .green.shade700
                                                          : bottomNavigationController
                                                                      .astrologerList[
                                                                          index]
                                                                      .chatStatus ==
                                                                  "Busy"
                                                              ? Colors
                                                                  .orangeAccent
                                                              : Colors
                                                                  .redAccent,
                                                    ),
                                                    SizedBox(width: 5),
                                                    Center(
                                                      child: Text(
                                                        bottomNavigationController
                                                                    .astrologerList[
                                                                        index]
                                                                    .chatStatus ==
                                                                "Online"
                                                            ? "Online"
                                                            : bottomNavigationController
                                                                        .astrologerList[
                                                                            index]
                                                                        .chatStatus ==
                                                                    "Busy"
                                                                ? "Busy"
                                                                : "Offline",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            color: bottomNavigationController
                                                                        .astrologerList[
                                                                            index]
                                                                        .chatStatus ==
                                                                    "Online"
                                                                ? Colors.green
                                                                    .shade700
                                                                : bottomNavigationController
                                                                            .astrologerList[
                                                                                index]
                                                                            .chatStatus ==
                                                                        "Busy"
                                                                    ? Colors
                                                                        .orangeAccent
                                                                    : Colors
                                                                        .redAccent,
                                                            fontSize: 13.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 4),
                                                        height: 15,
                                                        width: 1,
                                                        color: Colors.black54),
                                                    Text(
                                                      'Connect at',
                                                      style: Get.theme.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                        fontSize: 13.sp,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        letterSpacing: 0,
                                                        decoration: bottomNavigationController
                                                                    .astrologerList[
                                                                        index]
                                                                    .isFreeAvailable ==
                                                                true
                                                            ? TextDecoration
                                                                .lineThrough
                                                            : null,
                                                        color: Colors.black54,
                                                      ),
                                                    ).tr(),
                                                    SizedBox(width: 5),
                                                    global.getSystemFlagValueForLogin(global
                                                                .systemFlagNameList
                                                                .walletType) ==
                                                            "Wallet"
                                                        ? global
                                                            .buildTranslatedText(
                                                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerList[index].isDiscountedPrice == 0 ? bottomNavigationController.astrologerList[index].charge : bottomNavigationController.astrologerList[index].chat_discounted_rate}/min',
                                                            Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .green[700],
                                                                fontSize: 14.sp,
                                                                decorationColor:
                                                                    Colors.red,
                                                                decoration: bottomNavigationController
                                                                            .astrologerList[
                                                                                index]
                                                                            .isFreeAvailable ==
                                                                        true
                                                                    ? TextDecoration
                                                                        .lineThrough
                                                                    : null),
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              global
                                                                  .buildTranslatedText(
                                                                '${bottomNavigationController.astrologerList[index].isDiscountedPrice == 0 ? bottomNavigationController.astrologerList[index].charge : bottomNavigationController.astrologerList[index].chat_discounted_rate}',
                                                                Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                            .green[
                                                                        700],
                                                                    fontSize:
                                                                        13.sp,
                                                                    decorationColor:
                                                                        Colors
                                                                            .red,
                                                                    decoration: bottomNavigationController.astrologerList[index].isFreeAvailable ==
                                                                            true
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null),
                                                              ),
                                                              SizedBox(
                                                                width: 0.4.w,
                                                              ),
                                                              Image.network(
                                                                global.getSystemFlagValueForLogin(global
                                                                    .systemFlagNameList
                                                                    .coinIcon),
                                                                height: 1.2.h,
                                                              ),
                                                              global
                                                                  .buildTranslatedText(
                                                                '/min',
                                                                Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                            .green[
                                                                        700],
                                                                    fontSize:
                                                                        13.sp,
                                                                    decorationColor:
                                                                        Colors
                                                                            .red,
                                                                    decoration: bottomNavigationController.astrologerList[index].isFreeAvailable ==
                                                                            true
                                                                        ? TextDecoration
                                                                            .lineThrough
                                                                        : null),
                                                              ),
                                                            ],
                                                          ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      bottomNavigationController.isMoreDataAvailable == true &&
                              !bottomNavigationController.isAllDataLoaded &&
                              bottomNavigationController.astrologerList.length -
                                      1 ==
                                  index
                          ? Column(
                              children: [
                                // const CircularProgressIndicator(),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            )
                          : const SizedBox(),
                      if (index ==
                          bottomNavigationController.astrologerList.length - 1)
                        const SizedBox(
                          height: 30,
                        )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ///instant chat and schedule design
  Future<void> showChatBottomSheet({
    required BuildContext context,
    required Function onInstantChat,
    required Function(DateTime date) onSchedule,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 50,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  "Choose an option",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 20),

                // ✅ Instant Chat button (old design)
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.lightBlue,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () async {
                      Navigator.pop(context);
                      await onInstantChat();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.flash_on,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              "Instant Chat",
                              style: Get.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.green,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () async {
                      Navigator.pop(context);
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        await onSchedule(picked);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.white, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              "Schedule Appointment",
                              style: Get.textTheme.titleMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
