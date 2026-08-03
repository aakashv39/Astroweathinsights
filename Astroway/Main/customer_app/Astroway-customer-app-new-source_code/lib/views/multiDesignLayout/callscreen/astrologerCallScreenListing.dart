// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../../controllers/bottomNavigationController.dart';
import '../../../controllers/callController.dart';
import '../../../controllers/reviewController.dart';
import '../../../controllers/walletController.dart';
import '../../../utils/CornerBanner.dart';
import '../../../utils/images.dart';
import '../../astrologerProfile/astrologerProfile.dart';
import '../../callIntakeFormScreen.dart';

class Astrologercallscreenlisting extends StatefulWidget {
  final List astrologerList;
  Astrologercallscreenlisting({required this.astrologerList, Key? key})
      : super(key: key);

  @override
  State<Astrologercallscreenlisting> createState() =>
      _Astrologercallscreenlisting();
}

class _Astrologercallscreenlisting extends State<Astrologercallscreenlisting> {
  final walletController = Get.find<WalletController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final callScrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    paginateTask();
  }

  void paginateTask() {
    callScrollController.addListener(() async {
      if (callScrollController.position.pixels ==
              callScrollController.position.maxScrollExtent &&
          !bottomNavigationController.isAllDataLoaded) {
        bottomNavigationController.isMoreDataAvailable = true;
        bottomNavigationController.update();
        if (bottomNavigationController.selectedCatId == null ||
            bottomNavigationController.selectedCatId! == 0) {
          if (bottomNavigationController.isCallAstroDataLoadedOnce == false) {
            bottomNavigationController.isCallAstroDataLoadedOnce = true;
            bottomNavigationController.update();
            bottomNavigationController.getAstrologerList(
              skills: bottomNavigationController.skillFilterList,
              gender: bottomNavigationController.genderFilterList,
              language: bottomNavigationController.languageFilter,
              sortBy: bottomNavigationController.sortingFilter,
              isLazyLoading: true,
            );
            bottomNavigationController.isCallAstroDataLoadedOnce = false;
            bottomNavigationController.update();
          }
        } else {
          bottomNavigationController.astrologerList = [];
          bottomNavigationController.astrologerList.clear();
          bottomNavigationController.isAllDataLoaded = false;
          bottomNavigationController.update();
          bottomNavigationController.astroCat(
            id: bottomNavigationController.selectedCatId!,
            isLazyLoading: true,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: callScrollController,
      itemCount: widget.astrologerList.length,
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () async {
            global.showOnlyLoaderDialog(context);
            await Future.wait<void>([
              Get.find<ReviewController>().getReviewData(
                widget.astrologerList[index].id,
              ),
              bottomNavigationController.getAstrologerbyId(
                widget.astrologerList[index].id,
              ),
            ]);
            global.hideLoader();
            Get.to(() => AstrologerProfile(index: index));
          },
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                ),
                margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 3.w),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 15.h,
                                width: 13.h,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(2.w),
                                  child: CommonCachedNetworkImage(
                                    height: 15.h,
                                    width: 13.h,
                                    imageUrl:
                                        '${widget.astrologerList[index].profileImage}',
                                  ),
                                ),
                              ),
                              GetBuilder<BottomNavigationController>(
                                builder: (bottomNavigationController) => widget
                                            .astrologerList[index].isBoosted ==
                                        Images.ISBOOSTED
                                    ? Positioned(
                                        left: 0,
                                        top: 0,
                                        child: CornerBanner(
                                          bannerPosition:
                                              CornerBannerPosition.topLeft,
                                          bannerColor: Colors.red.withOpacity(
                                            0.6,
                                          ),
                                          child: Text(
                                            "Boosted",
                                            style: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ).tr(),
                                        ),
                                      )
                                    : SizedBox(),
                              ),
                              Positioned(
                                bottom: 1.w,
                                right: 1.w,
                                left: 1.w,
                                child: Container(
                                  width: 12.h,
                                  height: 3.5.h,
                                  decoration: BoxDecoration(
                                    color: widget.astrologerList[index]
                                                .callStatus
                                                .toString() ==
                                            "Online"
                                        ? Colors.black
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(1.w),
                                  ),
                                  child: Center(
                                    child: Text(
                                      widget.astrologerList[index].callStatus,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RatingBar.builder(
                                      initialRating: double.parse(
                                          bottomNavigationController
                                              .astrologerList[index].rating
                                              .toString()),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 15.sp,
                                      ignoreGestures: true,
                                      unratedColor: Colors.grey.shade300,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Get.theme.primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: Icon(
                                                CupertinoIcons.star_circle,
                                                color: Get.theme.primaryColor,
                                                size: 15.sp),
                                          ),
                                          TextSpan(
                                            text:
                                                " ${widget.astrologerList[index].rating} ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
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
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.astrologerList[index].name!
                                                    .length >
                                                16
                                            ? '${widget.astrologerList[index].name!.substring(0, 16)}..'
                                            : widget
                                                .astrologerList[index].name!,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17.sp,
                                            fontWeight: FontWeight.w700),
                                      ).tr(),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                      Icon(
                                        CupertinoIcons.checkmark_seal_fill,
                                        color: const Color(0xFF49AA4C),
                                        size: 18.sp,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      widget.astrologerList[index].courseBadges
                                              .isEmpty
                                          ? SizedBox()
                                          : Image.asset(
                                              "assets/images/rewards.png",
                                              fit: BoxFit.contain,
                                              height: 2.5.h,
                                              width: 8.w,
                                            ),
                                    ],
                                  ),
                                ],
                              ),
                              widget.astrologerList[index].allSkill == ""
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
                                            widget
                                                .astrologerList[index].allSkill
                                                .toString()
                                                .replaceAll(",", " • "),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black54,
                                                fontSize: 15.sp),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ).tr(),
                                        ),
                                      ],
                                    ),
                              SizedBox(height: 5),
                              widget.astrologerList[index].languageKnown == ""
                                  ? const SizedBox()
                                  : Container(
                                      width: 50.w,
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
                                          Flexible(
                                            child: Text(
                                              widget.astrologerList[index]
                                                  .languageKnown
                                                  .toString()
                                                  .replaceAll(",", " • "),
                                              style: Get.theme.primaryTextTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.black54,
                                                      fontSize: 15.sp),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ).tr(),
                                          ),
                                        ],
                                      ),
                                    ),
                              SizedBox(height: 0.5.h),
                              Container(
                                width: 50.w,
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.layers_alt_fill,
                                      size: 17.sp,
                                      color: Colors.grey[600],
                                    ),
                                    SizedBox(width: 1.w),
                                    global.buildTranslatedText(
                                      'Experience : ${widget.astrologerList[index].experienceInYears} Years',
                                      Get.theme.primaryTextTheme.bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black54,
                                              fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  const SizedBox(width: 6),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          child: Icon(
                                            CupertinoIcons.cube_box_fill,
                                            color: Colors.blueGrey,
                                            size: 14,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              " ${widget.astrologerList[index].totalOrder} ${tr('Orders')}",
                                          style: Get
                                              .theme.primaryTextTheme.bodySmall!
                                              .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black54,
                                                  fontSize: 15.sp),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 0.5.h),
                              Container(
                                width: 50.w,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    widget.astrologerList[index]
                                                .isFreeAvailable ==
                                            true
                                        ? Text(
                                            'FREE',
                                            style: Get
                                                .theme.textTheme.titleMedium!
                                                .copyWith(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0,
                                              color: Color(0xFFA70101),
                                            ),
                                          ).tr()
                                        : widget.astrologerList[index]
                                                    .isDiscountedPrice !=
                                                0
                                            ? (global.getSystemFlagValueForLogin(
                                                        global
                                                            .systemFlagNameList
                                                            .walletType) ==
                                                    "Wallet"
                                                ? Text(
                                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.astrologerList[index].charge}/min',
                                                    style: TextStyle(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.grey,
                                                      decorationColor:
                                                          Colors.red,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        ' ${widget.astrologerList[index].charge}',
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          decorationColor:
                                                              Colors.red,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationThickness:
                                                              2,
                                                        ),
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
                                                      Text(
                                                        "/min",
                                                        style: TextStyle(
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Colors.black,
                                                          decorationColor:
                                                              Colors.red,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          decorationThickness:
                                                              2,
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            : SizedBox(),
                                    SizedBox(
                                      width: 2.w,
                                    ),
                                    widget.astrologerList[index]
                                                .isDiscountedPrice ==
                                            1
                                        ? (global.getSystemFlagValueForLogin(
                                                    global.systemFlagNameList
                                                        .walletType) ==
                                                "Wallet"
                                            ? global.buildTranslatedText(
                                                'Connect at ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${widget.astrologerList[index].audio_discounted_rate}/min',
                                                Get.theme.primaryTextTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  global.buildTranslatedText(
                                                    'Connect at  ${widget.astrologerList[index].audio_discounted_rate}',
                                                    Get.theme.primaryTextTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700],
                                                    ),
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
                                                  global.buildTranslatedText(
                                                    '/min',
                                                    Get.theme.primaryTextTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ))
                                        : (global.getSystemFlagValueForLogin(
                                                    global.systemFlagNameList
                                                        .walletType) ==
                                                "Wallet"
                                            ? global.buildTranslatedText(
                                                'Connect at ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}  ${widget.astrologerList[index].charge}/min',
                                                Get.theme.primaryTextTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey[700],
                                                ),
                                              )
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  global.buildTranslatedText(
                                                    'Connect at  ${widget.astrologerList[index].charge}',
                                                    Get.theme.primaryTextTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700],
                                                    ),
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
                                                  global.buildTranslatedText(
                                                    '/min',
                                                    Get.theme.primaryTextTheme
                                                        .bodySmall!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              )),
                                  ],
                                ),
                              ),
                              SizedBox(height: 1.h),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          bool isLogin = await global.isLogin();
                                          _logedIn(
                                            context,
                                            isLogin,
                                            index,
                                            true,
                                            widget.astrologerList[index].charge,
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: widget.astrologerList[index]
                                                        .call_sections
                                                        .toString() ==
                                                    "0"
                                                ? Colors.grey
                                                : const Color(0xffFFF1CA),
                                            border: Border.all(
                                              color: widget
                                                          .astrologerList[index]
                                                          .call_sections
                                                          .toString() ==
                                                      "0"
                                                  ? Colors.grey
                                                  : (widget
                                                              .astrologerList[
                                                                  index]
                                                              .callStatus ==
                                                          "Online"
                                                      ? Get.theme.primaryColor
                                                      : widget
                                                                  .astrologerList[
                                                                      index]
                                                                  .callStatus ==
                                                              "Busy"
                                                          ? Colors.orangeAccent
                                                          : Colors.redAccent),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .phone_fill_arrow_up_right,
                                                color: widget
                                                            .astrologerList[
                                                                index]
                                                            .callStatus ==
                                                        "Online"
                                                    ? Colors.green.shade700
                                                    : widget
                                                                .astrologerList[
                                                                    index]
                                                                .callStatus ==
                                                            "Busy"
                                                        ? Colors.orangeAccent
                                                        : Colors.redAccent,
                                                size: 18,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                widget.astrologerList[index]
                                                            .isFreeAvailable ==
                                                        true
                                                    ? "FREE"
                                                    : "Call",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 2.w),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () async {
                                          bool isLogin = await global.isLogin();

                                          _logedIn(
                                            context,
                                            isLogin,
                                            index,
                                            false,
                                            widget.astrologerList[index]
                                                .videoCallRate,
                                          );
                                        },
                                        child: Container(
                                          height: 35,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30.w),
                                            color: widget.astrologerList[index]
                                                        .call_sections
                                                        .toString() ==
                                                    "0"
                                                ? Colors.grey
                                                : const Color(0xffFFF1CA),
                                            border: Border.all(
                                              color: widget
                                                          .astrologerList[index]
                                                          .call_sections
                                                          .toString() ==
                                                      "0"
                                                  ? Colors.grey
                                                  : (widget
                                                              .astrologerList[
                                                                  index]
                                                              .callStatus ==
                                                          "Online"
                                                      ? Get.theme.primaryColor
                                                      : widget
                                                                  .astrologerList[
                                                                      index]
                                                                  .callStatus ==
                                                              "Busy"
                                                          ? Colors.orangeAccent
                                                          : Colors.redAccent),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                CupertinoIcons
                                                    .video_camera_solid,
                                                color: widget
                                                            .astrologerList[
                                                                index]
                                                            .callStatus ==
                                                        "Online"
                                                    ? Colors.green.shade700
                                                    : widget
                                                                .astrologerList[
                                                                    index]
                                                                .callStatus ==
                                                            "Busy"
                                                        ? Colors.orangeAccent
                                                        : Colors.redAccent,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                widget.astrologerList[index]
                                                            .isFreeAvailable ==
                                                        true
                                                    ? "FREE"
                                                    : "Video",
                                                style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black54),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GetBuilder<CallController>(
                builder: (CallController callController) =>
                    bottomNavigationController.isMoreDataAvailable &&
                            !bottomNavigationController.isAllDataLoaded &&
                            widget.astrologerList.length - 1 == index &&
                            callController.showLoading
                        ? const CircularProgressIndicator()
                        : const SizedBox(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _logedIn(context, isLogin, index, audio, dynamic charge) async {
    if (isLogin) {
      if (widget.astrologerList[index].call_sections.toString() == "0") {
        Get.snackbar(
          "Note",
          "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Call",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        await showCallBottomSheet(
          context: context,
          audio: audio,
          onInstantCall: () async {
            await bottomNavigationController.getAstrologerbyId(
              widget.astrologerList[index].id,
            );
            if (double.parse(charge.toString()) * 5.0 <=
                    double.parse(
                      global.splashController.currentUser!.walletAmount!
                          .toString(),
                    ) ||
                widget.astrologerList[index].isFreeAvailable == true) {
              await bottomNavigationController.checkAlreadyInReqForCall(
                widget.astrologerList[index].id,
              );
              if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                if (widget.astrologerList[index].callStatus == "Online") {
                  global.showOnlyLoaderDialog(context);

                  await Get.to(
                    () => CallIntakeFormScreen(
                      astrologerProfile:
                          widget.astrologerList[index].profileImage,
                      type: audio ? "Call" : "Videocall",
                      astrologerId: widget.astrologerList[index].id,
                      astrologerName: widget.astrologerList[index].name,
                      isFreeAvailable:
                          widget.astrologerList[index].isFreeAvailable,
                      rate: audio
                          ? widget.astrologerList[index].charge.toString()
                          : widget.astrologerList[index].videoCallRate
                              .toString(),
                    ),
                  );

                  global.hideLoader();
                } else if (widget.astrologerList[index].callStatus ==
                        "Offline" ||
                    widget.astrologerList[index].callStatus == "Busy" ||
                    widget.astrologerList[index].callStatus == "Wait Time") {
                  bottomNavigationController.dialogForJoinInWaitList(
                    context,
                    widget.astrologerList[index].name,
                    true,
                    charge.toString(),
                    widget.astrologerList[index].profileImage,
                  );
                }
              } else {
                bottomNavigationController.dialogForNotCreatingSession(context);
              }
            } else {
              global.showOnlyLoaderDialog(context);
              await walletController.getAmount();
              global.hideLoader();
              global.showMinimumBalancePopup(
                  context,
                  (charge * 5).toString(),
                  '${widget.astrologerList[index].name}',
                  walletController.payment,
                  "Call");
            }
          },
          onSchedule: () async {
            await bottomNavigationController.getAstrologerbyId(
              widget.astrologerList[index].id,
            );
            if (double.parse(charge.toString()) * 5.0 <=
                    double.parse(
                      global.splashController.currentUser!.walletAmount!
                          .toString(),
                    ) ||
                widget.astrologerList[index].isFreeAvailable == true) {
              await bottomNavigationController.checkAlreadyInReqForCall(
                widget.astrologerList[index].id,
              );
              if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                if (widget.astrologerList[index].callStatus == "Online") {
                  global.showOnlyLoaderDialog(context);

                  await Get.to(
                    () => CallIntakeFormScreen(
                      astrologerProfile:
                          widget.astrologerList[index].profileImage,
                      type: audio ? "Call" : "Videocall",
                      bookingType: 'schedule',
                      astrologerId: widget.astrologerList[index].id,
                      astrologerName: widget.astrologerList[index].name,
                      isFreeAvailable:
                          widget.astrologerList[index].isFreeAvailable,
                      rate: audio
                          ? widget.astrologerList[index].charge.toString()
                          : widget.astrologerList[index].videoCallRate
                              .toString(),
                    ),
                  );

                  global.hideLoader();
                } else if (widget.astrologerList[index].callStatus ==
                        "Offline" ||
                    widget.astrologerList[index].callStatus == "Busy" ||
                    widget.astrologerList[index].callStatus == "Wait Time") {
                  bottomNavigationController.dialogForJoinInWaitList(
                    context,
                    widget.astrologerList[index].name,
                    true,
                    charge.toString(),
                    widget.astrologerList[index].profileImage,
                  );
                }
              } else {
                bottomNavigationController.dialogForNotCreatingSession(context);
              }
            } else {
              global.showOnlyLoaderDialog(context);
              await walletController.getAmount();
              global.hideLoader();
              global.showMinimumBalancePopup(
                  context,
                  (charge * 5).toString(),
                  '${widget.astrologerList[index].name}',
                  walletController.payment,
                  "Call");
            }
          },
        );
      }
    }
  }

  Future<void> showCallBottomSheet({
    required BuildContext context,
    required Function onInstantCall,
    required bool audio,
    required Function() onSchedule,
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
                      await onInstantCall();
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
                              audio
                                  ? "Instant Audio Call"
                                  : "Instant Video Call",
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

                // ✅ Schedule Appointment button (old design)
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

                      await onSchedule();
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
