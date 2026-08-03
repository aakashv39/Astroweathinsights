//ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/astrologer_assistant_controller.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/follow_astrologer_controller.dart';
import 'package:AstrowayCustomer/controllers/gift_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/settings_controller.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/userProfileController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/availabilityScreen.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/availbilityStatus.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/badgeAchievement.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/blockAstrologerBanner.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/chat_with_assistant_screen.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/sendGiftBottomSheet.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/serviceOptionsCard.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/widgets/block_unblock_popup.dart';
import 'package:AstrowayCustomer/views/stories/viewStories.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:AstrowayCustomer/widget/commonDialogWidget%20copy.dart';
import 'package:AstrowayCustomer/widget/showReviewWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:video_player/video_player.dart';
import '../../model/astrologer_model.dart';
import '../../model/custompujamodel.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:translator/translator.dart';
import '../../utils/images.dart';
import '../callIntakeFormScreen.dart';
import '../poojaBooking/screen/astrologerPujas.dart';
import 'badgeWidgetUi.dart';

class AstrologerProfile extends StatefulWidget {
  final int index;
  AstrologerProfile({a, o, required this.index}) : super();

  @override
  State<AstrologerProfile> createState() => _AstrologerProfileState();
}

class _AstrologerProfileState extends State<AstrologerProfile> {
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final reviewController = Get.find<ReviewController>();
  final walletController = Get.find<WalletController>();
  final splashController = Get.find<SplashController>();
  final homeController = Get.find<HomeController>();
  final bottomNavigationController2 = Get.find<BottomNavigationController>();
  final googleTranslator = GoogleTranslator();
  final astroAstistantContr = Get.find<AstrologerAssistantController>();
  VideoPlayerController? profilevideocontroller;
  bool isMuted = false;

  Future<void> dialogForJoinInWaitList(
      context, String astrologerName, bool forChat, String status) async {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Get.theme.primaryColor,
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                  imageUrl: global.buildImageUrl(
                      "${bottomNavigationController2.astrologerbyId[0].profileImage}"),
                  imageBuilder: (context, imageProvider) {
                    return CircleAvatar(
                      radius: 35,
                      backgroundColor: Get.theme.primaryColor,
                      backgroundImage: imageProvider,
                    );
                  },
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) {
                    return Container(
                      child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Get.theme.primaryColor,
                          child: Image.asset(
                            Images.deafultUser,
                            fit: BoxFit.fill,
                            height: 50,
                          )),
                    );
                  },
                ),
              ),
              Container(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Text(
                            "$astrologerName",
                            style: Get.theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ).tr(),
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                          Images.right,
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  status.toString() == "Offline"
                      ? 'You can not talk to astrologer because astrologer is Currently Offline'
                      : (status.toString() == "Busy"
                          ? 'You can not talk to astrologer because astrologer is Currently Busy'
                          : "You can not talk to astrologer because astrologer is Currently in Break"),
                  style: Get.theme.textTheme.bodyMedium!.copyWith(
                    color: Colors.red,
                    fontSize: 15.sp,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
              ),
              Container(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.w),
                              side: BorderSide(color: Colors.pink.shade200),
                            ),
                            shadowColor: Colors.transparent,
                          ),
                          child: Text(
                            'OK',
                            style: Get.theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.normal,
                              color: Colors.black,
                            ),
                          ).tr(),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    if (bottomNavigationController.astrologerbyId[0].astro_video != null) {
      _loadVideo();
    }
  }

  @override
  void dispose() {
    profilevideocontroller?.dispose();
    super.dispose();
    debugPrint("profile video Controller has been disposed");
  }

  void _loadVideo() {
    final url = bottomNavigationController.astrologerbyId[0].astro_video;

    if (url == null || url.isEmpty) {
      print("No video available");
      return;
    }

    profilevideocontroller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        profilevideocontroller!.play();
        profilevideocontroller!.setLooping(true);
        toggleSound();
      });

    profilevideocontroller!.addListener(() {
      if (profilevideocontroller!.value.hasError) {
        log("Video player error: ${profilevideocontroller!.value.errorDescription}");
      }
    });
  }

  void toggleSound() {
    if (profilevideocontroller == null) return;
    isMuted = !isMuted;
    profilevideocontroller?.setVolume(isMuted ? 0 : 1);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.back();
        return true;
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: SingleChildScrollView(
              child: GetBuilder<BottomNavigationController>(
                  builder: (bottomNavigationController) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bottomNavigationController.astrologerbyId[0].isBlock!
                        ? GetBuilder<SettingsController>(
                            builder: (settingsController) {
                              return BlockedAstrologerBanner(
                                astrologerId: bottomNavigationController
                                    .astrologerbyId[0].id!,
                                settingsController: settingsController,
                              );
                            },
                          )
                        : const SizedBox.shrink(),
                    Column(
                      children: [
                        // ------Profile Image and Video---------

                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  maxHeight: 45.h, minHeight: 45.h),
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  bottomNavigationController
                                              .astrologerbyId[0].astro_video ==
                                          null
                                      ? CommonCachedNetworkImage(
                                          borderRadius: 0,
                                          imageUrl: global.buildImageUrl(
                                              "${bottomNavigationController.astrologerbyId[0].profileImage}"),
                                          height: 45.h,
                                          width: double.infinity,
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                          child: SizedBox(
                                            width: double.infinity,
                                            height: 45.h,
                                            child: profilevideocontroller!
                                                    .value.isInitialized
                                                ? VideoPlayer(
                                                    profilevideocontroller!)
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                          ),
                                        )
                                ],
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 45.h,
                              alignment: Alignment.bottomCenter,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.black54,
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: Get.theme.textTheme.bodyMedium!
                                          .copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .name!
                                                      .length >
                                                  13
                                              ? "${bottomNavigationController.astrologerbyId[0].name!.substring(0, 13)}.."
                                              : bottomNavigationController
                                                  .astrologerbyId[0].name
                                                  .toString(),
                                        ),
                                        WidgetSpan(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5),
                                            child: Icon(
                                              CupertinoIcons
                                                  .checkmark_seal_fill,
                                              size: 18.sp,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "${bottomNavigationController.astrologerbyId[0].primarySkill!}",
                                    style: Get.theme.textTheme.bodyMedium!
                                        .copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${bottomNavigationController.astrologerbyId[0].languageKnown!}",
                                    style: Get.theme.textTheme.bodyMedium!
                                        .copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${bottomNavigationController.astrologerbyId[0].experienceInYears!}+ Year of Experience",
                                    style: Get.theme.textTheme.bodyMedium!
                                        .copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 60),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.black),
                                    color: Colors.black,
                                    shape: BoxShape.circle),
                                child: IconButton(
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                width: 100,
                                height: 200,
                                child: Stack(
                                  children: [
                                    // AvailbilityStatus should be at the top
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: AvailbilityStatus(
                                        status: bottomNavigationController
                                                    .astrologerbyId[0]
                                                    .chatStatus ==
                                                "Online"
                                            ? 'Online'
                                            : bottomNavigationController
                                                        .astrologerbyId[0]
                                                        .chatStatus ==
                                                    "Offline"
                                                ? "Offline"
                                                : "Busy",
                                      ),
                                    ),

                                    // Sound toggle button - positioned lower
                                    if (bottomNavigationController
                                                .astrologerbyId[0]
                                                .astro_video !=
                                            null &&
                                        profilevideocontroller != null &&
                                        profilevideocontroller!
                                            .value.isInitialized)
                                      Positioned(
                                        right: 0,
                                        top: 50, // Adjusted position
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle),
                                          child: IconButton(
                                            icon: Icon(
                                              isMuted
                                                  ? Icons.volume_off
                                                  : Icons.volume_up,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                            onPressed: toggleSound,
                                          ),
                                        ),
                                      ),

                                    // Achievement badges
                                    if (!bottomNavigationController
                                        .astrologerbyId[0]
                                        .courseBadges!
                                        .isEmpty)
                                      Positioned(
                                        top: 100, // Adjusted position
                                        right: 0,
                                        child: AchievementBadgeButton(
                                          bottomNavigationController:
                                              bottomNavigationController,
                                          badgeDecoration: badgedecoration,
                                          innerDecoration: inerdecoration,
                                          buildBadgesList: buildBadgesList,
                                        ),
                                      ),

                                    // Stories button
                                    if (!homeController.viewSingleStory.isEmpty)
                                      Positioned(
                                        top: 150, // Adjusted position
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ViewStoriesScreen(
                                                          profile:
                                                              "${bottomNavigationController.astrologerbyId[0].profileImage}",
                                                          name: bottomNavigationController
                                                              .astrologerbyId[0]
                                                              .name
                                                              .toString(),
                                                          isprofile: true,
                                                          astroId: int.parse(
                                                              bottomNavigationController
                                                                  .astrologerbyId[
                                                                      0]
                                                                  .id
                                                                  .toString()),
                                                        )));
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(1.w),
                                            decoration: BoxDecoration(
                                                color: Colors.black26,
                                                shape: BoxShape.circle),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  Images.viewStory,
                                                  height: 25,
                                                ),
                                                Icon(
                                                  CupertinoIcons
                                                      .person_alt_circle,
                                                  color: Colors.white,
                                                  size: 20,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ServiceOptionCard(
                              icon: CupertinoIcons.chat_bubble_2,
                              title: 'Chat',
                              isFree: bottomNavigationController
                                      .astrologerbyId[0].isFreeAvailable ??
                                  false,
                              priceText:
                                  '${bottomNavigationController.astrologerbyId[0].charge}',
                              iconsSize: 19.sp,
                              iconColor: darkGreen,
                              isDiscounted: bottomNavigationController
                                      .astrologerbyId[0].isDiscountedPrice ==
                                  1,
                              discountedPrice: bottomNavigationController
                                  .astrologerbyId[0].chat_discounted_rate
                                  .toString(),
                            ),
                            ServiceOptionCard(
                              icon: CupertinoIcons.phone_arrow_up_right,
                              title: 'Audio',
                              isFree: bottomNavigationController
                                      .astrologerbyId[0].isFreeAvailable ??
                                  false,
                              priceText:
                                  '${bottomNavigationController.astrologerbyId[0].charge}',
                              iconsSize: 19.sp,
                              iconColor: darkGreen,
                              isDiscounted: bottomNavigationController
                                      .astrologerbyId[0].isDiscountedPrice ==
                                  1,
                              discountedPrice: bottomNavigationController
                                  .astrologerbyId[0].audio_discounted_rate
                                  .toString(),
                            ),
                            ServiceOptionCard(
                              icon: CupertinoIcons.videocam,
                              title: 'Video',
                              isFree: bottomNavigationController
                                      .astrologerbyId[0].isFreeAvailable ??
                                  false,
                              priceText:
                                  '${bottomNavigationController.astrologerbyId[0].videoCallRate}',
                              iconsSize: 19.sp,
                              iconColor: darkGreen,
                              isDiscounted: bottomNavigationController
                                      .astrologerbyId[0].isDiscountedPrice ==
                                  1,
                              discountedPrice: bottomNavigationController
                                  .astrologerbyId[0].video_discounted_rate
                                  .toString(),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 4.w, vertical: 5),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.6.h),
                                  decoration: BoxDecoration(
                                      color: Get.theme.primaryColor,
                                      borderRadius:
                                          BorderRadius.circular(15.sp)),
                                  child: GestureDetector(
                                    onTap: () async {
                                      await walletController.getAmount();
                                      showGiftBottomSheet(
                                        giftController:
                                            Get.find<GiftController>(),
                                        walletController:
                                            Get.find<WalletController>(),
                                        bottomNavigationController: Get.find<
                                            BottomNavigationController>(),
                                        context: context,
                                      );
                                    },
                                    child: Row(
                                      children: [
                                        Icon(CupertinoIcons.gift,
                                            color: Colors.orange),
                                        SizedBox(width: 10),
                                        Text(
                                          "Send Gift",
                                          style: TextStyle(color: Colors.white),
                                        ).tr()
                                      ],
                                    ),
                                  )),
                              Container(
                                child: Row(
                                  children: [
                                    bottomNavigationController
                                            .astrologerbyId[0].isFollow!
                                        ? Container(
                                            height: 30,
                                            width: 75,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w),
                                            decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(30.w),
                                            ),
                                            child: Text(
                                              'Following',
                                              style: Get.textTheme.bodyMedium!
                                                  .copyWith(
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: whiteColor),
                                              textAlign: TextAlign.center,
                                            ).tr(),
                                          )
                                        : Align(
                                            alignment: Alignment.bottomRight,
                                            child: GetBuilder<
                                                    FollowAstrologerController>(
                                                builder:
                                                    (followAstrologerController) {
                                              return InkWell(
                                                onTap: () async {
                                                  log('message');
                                                  bool isLogin =
                                                      await global.isLogin();
                                                  if (isLogin) {
                                                    global.showOnlyLoaderDialog(
                                                        context);
                                                    await followAstrologerController
                                                        .addFollowers(
                                                            bottomNavigationController
                                                                .astrologerbyId[
                                                                    0]
                                                                .id!);
                                                    global.hideLoader();
                                                  }
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 4.w,
                                                      vertical: 0.6.h),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.sp),
                                                  ),
                                                  child: Text(
                                                    'Follow',
                                                    style: Get
                                                        .textTheme.bodyMedium!
                                                        .copyWith(
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: whiteColor),
                                                    textAlign: TextAlign.center,
                                                  ).tr(),
                                                ),
                                              );
                                            }),
                                          ),
                                    PopupMenuButton(
                                        menuPadding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.grey.shade500,
                                        ),
                                        onSelected: (value) async {
                                          if (value == "block") {
                                            bottomNavigationController
                                                .blockAstrologerController
                                                .clear();
                                            bool isLogin =
                                                await global.isLogin();
                                            if (isLogin) {
                                              BlockUnblockDialog.showBlock(
                                                context,
                                                astrologerId:
                                                    bottomNavigationController
                                                        .astrologerbyId[0].id
                                                        .toString(),
                                                name: bottomNavigationController
                                                    .astrologerbyId[0].name!,
                                                imageUrl: global.buildImageUrl(
                                                    "${bottomNavigationController.astrologerbyId[0].profileImage}"),
                                                onSubmit: (reason, tags) async {
                                                  if (reason.isEmpty) {
                                                    global.showToast(
                                                        message:
                                                            'Reason is required');
                                                    return;
                                                  }
                                                  bottomNavigationController
                                                      .blockAstrologerController
                                                      .text = reason;
                                                  bottomNavigationController
                                                      .update();
                                                  await bottomNavigationController
                                                      .astrologerReportAndBlock(
                                                    bottomNavigationController
                                                        .astrologerbyId[0].id,
                                                  );
                                                },
                                              );
                                            }
                                          }

                                          if (value == "unblock") {
                                            BlockUnblockDialog.showUnblock(
                                              context,
                                              name: bottomNavigationController
                                                  .astrologerbyId[0].name!,
                                              imageUrl: global.buildImageUrl(
                                                  "${bottomNavigationController.astrologerbyId[0].profileImage}"),
                                              onConfirm: () async {
                                                SettingsController
                                                    settingsController =
                                                    Get.find<
                                                        SettingsController>();
                                                await settingsController
                                                    .unblockAstrologer(
                                                  bottomNavigationController
                                                      .astrologerbyId[0].id!,
                                                );
                                              },
                                            );
                                          }
                                        },
                                        itemBuilder: (context) => [
                                              PopupMenuItem(
                                                child:
                                                    bottomNavigationController
                                                            .astrologerbyId[0]
                                                            .isBlock!
                                                        ? Text('Unblock').tr()
                                                        : Text('Report & Block')
                                                            .tr(),
                                                value:
                                                    bottomNavigationController
                                                            .astrologerbyId[0]
                                                            .isBlock!
                                                        ? "unblock"
                                                        : "block",
                                              ),
                                            ]),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Divider(color: Colors.grey.shade100, height: 2),
                          DefaultTabController(
                            length: 3,
                            child: Column(
                              children: [
                                // ---------------- Tab Bar ----------------
                                Container(
                                  margin: EdgeInsets.only(top: 8),
                                  height: 30,
                                  child: TabBar(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 0),
                                    dividerColor: Colors.transparent,
                                    indicator: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFF033F22),
                                            Color(0xFF820909)
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
                                    tabs: [
                                      Tab(text: tr('About')),
                                      Tab(text: tr('Reviews')),
                                      Tab(text: tr('Info')),
                                    ],
                                  ),
                                ),

                                // ---------------- Tab Views ----------------
                                SizedBox(height: 10),
                                SizedBox(
                                  height: 80.h,
                                  child: TabBarView(
                                    physics: NeverScrollableScrollPhysics(),
                                    children: [
                                      GetBuilder<UserProfileController>(
                                          builder: (userProfileController) {
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              bottomNavigationController
                                                  .astrologerbyId[0].loginBio!,
                                              style: Get.textTheme.titleMedium!
                                                  .copyWith(
                                                      fontSize: 15.sp,
                                                      color: Colors.black87,
                                                      letterSpacing: 0,
                                                      fontWeight:
                                                          FontWeight.w400),
                                              textAlign: TextAlign.justify,
                                            ).tr(),
                                          ],
                                        );
                                      }),

                                      // Reviews Tab
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 20),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Rating & Reviews',
                                                      style: Get.theme.textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                        fontSize: 17.sp,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Colors.black87,
                                                      ),
                                                    ).tr(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        reviewController
                                                                .reviewList
                                                                .isNotEmpty
                                                            ? showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            20),
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                isScrollControlled:
                                                                    true,
                                                                builder:
                                                                    (context) {
                                                                  return ratingAndReview();
                                                                })
                                                            : global.showToast(
                                                                message:
                                                                    'There is no user review available for this astrologer!',
                                                                textColor: global
                                                                    .textColor,
                                                                bgColor: global
                                                                    .toastBackGoundColor,
                                                              );
                                                      },
                                                      child: Icon(
                                                        Icons.arrow_forward,
                                                        color: Colors.black87,
                                                        size: 18.sp,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${bottomNavigationController.astrologerbyId[0].rating!.toStringAsFixed(2)}',
                                                          style: Get.textTheme
                                                              .headlineMedium!
                                                              .copyWith(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color:
                                                                Colors.black87,
                                                          ),
                                                        ),
                                                        RatingBar.builder(
                                                          initialRating:
                                                              bottomNavigationController
                                                                  .astrologerbyId[
                                                                      0]
                                                                  .rating!,
                                                          itemCount: 5,
                                                          allowHalfRating: true,
                                                          itemSize: 15,
                                                          ignoreGestures: true,
                                                          itemBuilder:
                                                              (context, _) =>
                                                                  Icon(
                                                            Icons.star,
                                                            color: Get.theme
                                                                .primaryColor,
                                                          ),
                                                          onRatingUpdate:
                                                              (rating) {},
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(Icons.person,
                                                                size: 14,
                                                                color: Colors
                                                                    .grey),
                                                            SizedBox(
                                                              width: 5,
                                                            ),
                                                            global
                                                                .buildTranslatedText(
                                                                    '${bottomNavigationController.astrologerbyId[0].totalOrder!} ${tr('Orders')}',
                                                                    Get
                                                                        .theme
                                                                        .primaryTextTheme
                                                                        .bodySmall!
                                                                        .copyWith(
                                                                      fontSize:
                                                                          13.sp,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      color: Colors
                                                                          .grey,
                                                                    )),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(width: 15),
                                                    Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                '5',
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium,
                                                              ),
                                                              Icon(
                                                                Icons.star,
                                                                size: 17.sp,
                                                                color: Get.theme
                                                                    .primaryColor,
                                                              ),
                                                              LinearPercentIndicator(
                                                                width: 160,
                                                                lineHeight: 16,
                                                                percent: getStarRatingPercentage(
                                                                    starCount:
                                                                        5,
                                                                    ratinglist: bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .astrologerRating),
                                                                progressColor:
                                                                    Colors
                                                                        .green,
                                                                barRadius: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                              Container(
                                                                width: 25,
                                                                child: Text(bottomNavigationController.astrologerbyId[0].astrologerRating!.fiveStarRating !=
                                                                            null &&
                                                                        bottomNavigationController.astrologerbyId[0].astrologerRating!.fiveStarRating!.toInt() !=
                                                                            0
                                                                    ? "${global.formatRating(bottomNavigationController.astrologerbyId[0].astrologerRating!.fiveStarRating!.toInt())}"
                                                                    : " "),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Text('4',
                                                                  style: Get
                                                                      .textTheme
                                                                      .titleMedium),
                                                              Icon(
                                                                Icons.star,
                                                                size: 17.sp,
                                                                color: Get.theme
                                                                    .primaryColor,
                                                              ),
                                                              LinearPercentIndicator(
                                                                width: 160,
                                                                lineHeight: 16,
                                                                percent: getStarRatingPercentage(
                                                                    starCount:
                                                                        4,
                                                                    ratinglist: bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .astrologerRating),
                                                                progressColor:
                                                                    Colors.blue,
                                                                barRadius: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                              Container(
                                                                width: 25,
                                                                child: Text(bottomNavigationController.astrologerbyId[0].astrologerRating!.fourStarRating !=
                                                                            null &&
                                                                        bottomNavigationController.astrologerbyId[0].astrologerRating!.fourStarRating!.toInt() !=
                                                                            0
                                                                    ? "${global.formatRating(bottomNavigationController.astrologerbyId[0].astrologerRating!.fourStarRating!.toInt())}"
                                                                    : " "),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Text('3',
                                                                  style: Get
                                                                      .textTheme
                                                                      .titleMedium),
                                                              Icon(
                                                                Icons.star,
                                                                size: 17.sp,
                                                                color: Get.theme
                                                                    .primaryColor,
                                                              ),
                                                              LinearPercentIndicator(
                                                                width: 160,
                                                                lineHeight: 16,
                                                                percent: getStarRatingPercentage(
                                                                    starCount:
                                                                        3,
                                                                    ratinglist: bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .astrologerRating),
                                                                progressColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        135,
                                                                        172,
                                                                        235),
                                                                barRadius: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                              Container(
                                                                width: 25,
                                                                child: Text(bottomNavigationController.astrologerbyId[0].astrologerRating!.threeStarRating !=
                                                                            null &&
                                                                        bottomNavigationController.astrologerbyId[0].astrologerRating!.threeStarRating!.toInt() !=
                                                                            0
                                                                    ? "${global.formatRating(bottomNavigationController.astrologerbyId[0].astrologerRating!.threeStarRating!.toInt())}"
                                                                    : " "),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Text('2',
                                                                  style: Get
                                                                      .textTheme
                                                                      .titleMedium),
                                                              Icon(
                                                                Icons.star,
                                                                size: 17.sp,
                                                                color: Get.theme
                                                                    .primaryColor,
                                                              ),
                                                              LinearPercentIndicator(
                                                                width: 160,
                                                                lineHeight: 16,
                                                                percent: getStarRatingPercentage(
                                                                    starCount:
                                                                        2,
                                                                    ratinglist: bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .astrologerRating),
                                                                progressColor:
                                                                    Colors
                                                                        .orange,
                                                                barRadius: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                              Container(
                                                                width: 25,
                                                                child: Text(bottomNavigationController.astrologerbyId[0].astrologerRating!.twoStarRating !=
                                                                            null &&
                                                                        bottomNavigationController.astrologerbyId[0].astrologerRating!.twoStarRating!.toInt() !=
                                                                            0
                                                                    ? "${global.formatRating(bottomNavigationController.astrologerbyId[0].astrologerRating!.twoStarRating!.toInt())}"
                                                                    : " "),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(4.0),
                                                          child: Row(
                                                            children: [
                                                              Text(' 1',
                                                                  style: Get
                                                                      .textTheme
                                                                      .titleMedium),
                                                              Icon(
                                                                Icons.star,
                                                                size: 17.sp,
                                                                color: Get.theme
                                                                    .primaryColor,
                                                              ),
                                                              LinearPercentIndicator(
                                                                width: 160,
                                                                lineHeight: 16,
                                                                percent: getStarRatingPercentage(
                                                                    starCount:
                                                                        1,
                                                                    ratinglist: bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .astrologerRating),
                                                                progressColor:
                                                                    Colors.red,
                                                                barRadius: Radius
                                                                    .circular(
                                                                        20),
                                                              ),
                                                              Container(
                                                                width: 25,
                                                                child: Text(bottomNavigationController.astrologerbyId[0].astrologerRating!.oneStarRating !=
                                                                            null &&
                                                                        bottomNavigationController.astrologerbyId[0].astrologerRating!.oneStarRating!.toInt() !=
                                                                            0
                                                                    ? "${global.formatRating(bottomNavigationController.astrologerbyId[0].astrologerRating!.oneStarRating!.toInt())}"
                                                                    : " "),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          reviewController.reviewList.isEmpty
                                              ? SizedBox()
                                              : buildReviewSection(
                                                  context, reviewController),
                                        ],
                                      ),

                                      // Availability Tab
                                      Center(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 3.w),
                                              child: Column(
                                                children: [
                                                  SizedBox(height: 12),
                                                  bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .similiarConsultant!
                                                          .isNotEmpty
                                                      ? Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                                'Check Similar Astrologer',
                                                                style: Get
                                                                    .theme
                                                                    .textTheme
                                                                    .bodyMedium!
                                                                    .copyWith(
                                                                  fontSize:
                                                                      17.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .black87,
                                                                )).tr(),
                                                            InkWell(
                                                              onTap: () {
                                                                showCommonDialog(
                                                                  subtitle:
                                                                      "People who spoke to this Consultant, also spoke to these Consultants. You may try them out!",
                                                                  primaryButtonText:
                                                                      "OK",
                                                                  onPrimaryPressed:
                                                                      () {
                                                                    Get.back();
                                                                  },
                                                                );
                                                              },
                                                              child: Icon(
                                                                  Icons.info),
                                                            )
                                                          ],
                                                        )
                                                      : SizedBox(),
                                                  SizedBox(height: 10),
                                                  bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .similiarConsultant!
                                                          .isNotEmpty
                                                      ? SizedBox(
                                                          height: 15.h,
                                                          child: Center(
                                                            child: ListView
                                                                .builder(
                                                                    itemCount: bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .similiarConsultant!
                                                                        .length,
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    physics:
                                                                        NeverScrollableScrollPhysics(),
                                                                    shrinkWrap:
                                                                        true,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return InkWell(
                                                                        onTap:
                                                                            () async {
                                                                          log('similar consultant id:- ${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].id!}');
                                                                          Get.find<ReviewController>().getReviewData(bottomNavigationController
                                                                              .astrologerbyId[0]
                                                                              .similiarConsultant![index]
                                                                              .id!);
                                                                          global
                                                                              .showOnlyLoaderDialog(context);
                                                                          await bottomNavigationController.getAstrologerbyId(bottomNavigationController
                                                                              .astrologerbyId[0]
                                                                              .similiarConsultant![index]
                                                                              .id!);
                                                                          global
                                                                              .hideLoader();
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          width:
                                                                              100,
                                                                          margin:
                                                                              EdgeInsets.only(left: 3),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.white,
                                                                            border:
                                                                                Border.all(width: 0.5, color: Colors.grey.shade300),
                                                                            borderRadius:
                                                                                BorderRadius.circular(10),
                                                                          ),
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Container(
                                                                                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 1, color: Colors.grey.shade300)),
                                                                                child: CommonCachedNetworkImage(
                                                                                  borderRadius: 100.w,
                                                                                  height: 80,
                                                                                  width: 80,
                                                                                  imageUrl: "${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].profileImage}",
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                bottomNavigationController.astrologerbyId[0].similiarConsultant![index].name!.length > 11 ? bottomNavigationController.astrologerbyId[0].similiarConsultant![index].name!.substring(0, 11) + ".." : '${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].name}',
                                                                                textAlign: TextAlign.center,
                                                                                style: Get.theme.textTheme.titleMedium!.copyWith(
                                                                                  fontSize: 14.sp,
                                                                                  fontWeight: FontWeight.w400,
                                                                                  letterSpacing: 0,
                                                                                ),
                                                                              ).tr(),
                                                                              global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType) == "Wallet"
                                                                                  ? Text(
                                                                                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].charge}/min',
                                                                                      textAlign: TextAlign.center,
                                                                                      style: Get.theme.textTheme.titleMedium!.copyWith(
                                                                                        fontSize: 11,
                                                                                        fontWeight: FontWeight.w300,
                                                                                        letterSpacing: 0,
                                                                                      ),
                                                                                    ).tr()
                                                                                  : Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                                                      children: [
                                                                                        Text(
                                                                                          '${bottomNavigationController.astrologerbyId[0].similiarConsultant![index].charge}',
                                                                                          textAlign: TextAlign.center,
                                                                                          style: Get.theme.textTheme.titleMedium!.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.w300,
                                                                                            letterSpacing: 0,
                                                                                          ),
                                                                                        ).tr(),
                                                                                        SizedBox(
                                                                                          width: 0.4.w,
                                                                                        ),
                                                                                        Image.network(
                                                                                          global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),
                                                                                          height: 1.2.h,
                                                                                        ),
                                                                                        Text(
                                                                                          "/min",
                                                                                          textAlign: TextAlign.center,
                                                                                          style: Get.theme.textTheme.titleMedium!.copyWith(
                                                                                            fontSize: 11,
                                                                                            fontWeight: FontWeight.w300,
                                                                                            letterSpacing: 0,
                                                                                          ),
                                                                                        )
                                                                                      ],
                                                                                    ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        )
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(children: [
                                                  InkWell(
                                                      onTap: () async {
                                                        bool isLogin =
                                                            await global
                                                                .isLogin();
                                                        if (isLogin) {
                                                          await astroAstistantContr
                                                              .checkPaidSession(
                                                                  bottomNavigationController
                                                                      .astrologerbyId[
                                                                          0]
                                                                      .id!);
                                                          global.hideLoader();
                                                          if (astroAstistantContr
                                                              .isPaidSession) {
                                                            global
                                                                .showOnlyLoaderDialog(
                                                                    context);

                                                            await astroAstistantContr
                                                                .storeChatId(
                                                                    bottomNavigationController
                                                                        .astrologerbyId[
                                                                            0]
                                                                        .id!);
                                                            global.hideLoader();

                                                            global.isInAssistantScreen =
                                                                true;
                                                            Get.to(() =>
                                                                ChatWithAstrologerAssistantScreen(
                                                                  flagId: 1,
                                                                  profileImage:
                                                                      "",
                                                                  astrologerName:
                                                                      bottomNavigationController
                                                                          .astrologerbyId[
                                                                              0]
                                                                          .name!,
                                                                  fireBasechatId:
                                                                      astroAstistantContr
                                                                          .firebaseChatId,
                                                                  astrologerId:
                                                                      bottomNavigationController
                                                                          .astrologerbyId[
                                                                              0]
                                                                          .id!,
                                                                  chatId: 1,
                                                                  fcmtoken: bottomNavigationController
                                                                      .astrologerbyId[
                                                                          0]
                                                                      .fcmToken!,
                                                                ));
                                                          } else {
                                                            showCommonDialog(
                                                              subtitle:
                                                                  'You can chat with astrologer\'s assistant only when you have taken a paid session with the atrologer',
                                                              primaryButtonText:
                                                                  "OK",
                                                              onPrimaryPressed:
                                                                  () {
                                                                Get.back();
                                                              },
                                                            );
                                                          }
                                                        }
                                                      },
                                                      child: menuItem(
                                                          CupertinoIcons
                                                              .chat_bubble_text,
                                                          "${tr('Chat With Assistant')}")),
                                                  InkWell(
                                                      onTap: () async {
                                                        global
                                                            .showOnlyLoaderDialog(
                                                                context);
                                                        await bottomNavigationController
                                                            .getAstrologerAvailibility(
                                                                bottomNavigationController
                                                                    .astrologerbyId[
                                                                        0]
                                                                    .id!);
                                                        global.hideLoader();
                                                        Get.to(() =>
                                                            AvailabilityScreen(
                                                              astrologerName:
                                                                  bottomNavigationController
                                                                      .astrologerbyId[
                                                                          0]
                                                                      .name!,
                                                              astrologerProfile:
                                                                  bottomNavigationController
                                                                      .astrologerbyId[
                                                                          0]
                                                                      .profileImage!,
                                                            ));
                                                      },
                                                      child: menuItem(
                                                          CupertinoIcons
                                                              .calendar,
                                                          "${tr('Availability')}")),
                                                  bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .isFollow!
                                                      ? const SizedBox()
                                                      : Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .person_add,
                                                                      color: Colors
                                                                          .grey,
                                                                    ),
                                                                    SizedBox(
                                                                      width: 20,
                                                                    ),
                                                                    global
                                                                        .buildTranslatedText(
                                                                      '${tr('Follow')} ${bottomNavigationController.astrologerbyId[0].name}',
                                                                      Get.textTheme.bodyMedium!.copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey),
                                                                    )
                                                                  ],
                                                                ),
                                                                global
                                                                    .buildTranslatedText(
                                                                  'Follow ${bottomNavigationController.astrologerbyId[0].name} to get notifed when they go live,come online or run an offers!',
                                                                  Get.textTheme
                                                                      .bodyMedium!
                                                                      .copyWith(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.grey),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                ]),
                                              ),
                                            ),
                                            bottomNavigationController
                                                    .astrologerbyId[0]
                                                    .pujas!
                                                    .isEmpty
                                                ? SizedBox()
                                                : buildAstrologerPujaSection(
                                                    context,
                                                    bottomNavigationController
                                                        .astrologerbyId[0]
                                                        .name),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          bottomSheet: GetBuilder<BottomNavigationController>(
              builder: (bottomNavigationController) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child:
                          GetBuilder<ChatController>(builder: (chatController) {
                        return InkWell(
                          onTap: () async {
                            ///new logic for schedule or instant chat
                            bool isLogin = await global.isLogin();
                            if (isLogin) {
                              // 🔥 Your existing "instant chat" logic goes here
                              if (bottomNavigationController
                                      .astrologerbyId[0].chat_sections
                                      .toString() ==
                                  "0") {
                                Get.snackbar("Note",
                                    "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Chat",
                                    backgroundColor: Colors.orange,
                                    colorText: Colors.white);
                              } else {
                                double charge = double.parse(
                                    bottomNavigationController
                                        .astrologerbyId[0].charge!
                                        .toString());
                                if (charge * 5 <=
                                        global.splashController.currentUser!
                                            .walletAmount! ||
                                    bottomNavigationController.astrologerbyId[0]
                                            .isFreeAvailable ==
                                        true) {
                                  if (bottomNavigationController
                                          .astrologerbyId[0].chatStatus ==
                                      "Online") {
                                    await bottomNavigationController
                                        .checkAlreadyInReq(
                                            bottomNavigationController
                                                .astrologerbyId[0].id!);
                                    if (bottomNavigationController
                                            .isUserAlreadyInChatReq ==
                                        false) {
                                      global.showOnlyLoaderDialog(context);

                                      await Get.to(() => CallIntakeFormScreen(
                                            type: "Chat",
                                            astrologerId:
                                                bottomNavigationController
                                                    .astrologerbyId[0].id!,
                                            astrologerName:
                                                bottomNavigationController
                                                    .astrologerbyId[0].name!,
                                            astrologerProfile:
                                                bottomNavigationController
                                                    .astrologerbyId[0]
                                                    .profileImage!,
                                            isFreeAvailable:
                                                bottomNavigationController
                                                    .astrologerbyId[0]
                                                    .isFreeAvailable,
                                            rate: charge.toString(),
                                            //index: index,
                                          ));
                                      global.hideLoader();
                                    } else {
                                      bottomNavigationController
                                          .dialogForNotCreatingSession(context);
                                    }
                                  } else if (bottomNavigationController
                                              .astrologerbyId[0].chatStatus ==
                                          "Offline" ||
                                      bottomNavigationController
                                              .astrologerbyId[0].chatStatus ==
                                          "Wait Time") {
                                    dialogForJoinInWaitList(
                                        context,
                                        bottomNavigationController
                                            .astrologerbyId[0].name!,
                                        true,
                                        bottomNavigationController
                                            .astrologerbyId[0].chatStatus
                                            .toString());
                                  } else if (bottomNavigationController
                                          .astrologerbyId[0].chatStatus ==
                                      "Busy") {
                                    dialogForJoinInWaitList(
                                        context,
                                        bottomNavigationController
                                            .astrologerbyId[0].name!,
                                        true,
                                        bottomNavigationController
                                            .astrologerbyId[0].chatStatus
                                            .toString());
                                  }
                                } else {
                                  global.showOnlyLoaderDialog(context);
                                  await walletController.getAmount();
                                  global.hideLoader();
                                  global.showMinimumBalancePopup(
                                    context,
                                    (charge * 5).toString(),
                                    '${bottomNavigationController.astrologerbyId[0].name}',
                                    walletController.payment,
                                    "Chat",
                                  );
                                }
                              }
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: bottomNavigationController
                                        .astrologerbyId[0].chat_sections
                                        .toString() ==
                                    "0"
                                ? Colors.grey
                                : (bottomNavigationController
                                            .astrologerbyId[0].chatStatus ==
                                        "Online"
                                    ? Colors.lightBlue
                                    : Colors.orangeAccent),
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(CupertinoIcons.chat_bubble_2,
                                    color: Colors.white),
                                Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Chat",
                                            textAlign: TextAlign.center,
                                            style: Get
                                                .theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.white),
                                          ).tr(),
                                          bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .chatStatus ==
                                                      "Offline" ||
                                                  bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .chatStatus ==
                                                      "Busy"
                                              ? Text(
                                                  bottomNavigationController
                                                              .astrologerbyId[0]
                                                              .chatStatus ==
                                                          "Offline"
                                                      ? "Currently Offline"
                                                      : 'Currently Busy',
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ).tr()
                                              : bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .chatStatus ==
                                                      "Online"
                                                  ? SizedBox()
                                                  : Text(
                                                      bottomNavigationController
                                                                  .astrologerbyId[
                                                                      0]
                                                                  .chatWaitTime!
                                                                  .difference(
                                                                      DateTime
                                                                          .now())
                                                                  .inMinutes >
                                                              0
                                                          ? "Wait till - ${bottomNavigationController.astrologerbyId[0].chatWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                          : "Waiting",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Get.theme.textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ).tr(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox()
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      child:
                          GetBuilder<CallController>(builder: (callController) {
                        return InkWell(
                          onTap: () async {
                            bool isLogin = await global.isLogin();

                            ///new logic for schedule or instant chat
                            if (isLogin) {
                              showChatOptions(context, type: "Audio",

                                  ///for instant
                                  () async {
                                // 🔥 Your existing "instant chat" logic goes here
                                if (bottomNavigationController
                                        .astrologerbyId[0].call_sections
                                        .toString() ==
                                    "0") {
                                  Get.snackbar("Note",
                                      "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Audio Call",
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white);
                                } else {
                                  double charge = double.parse(
                                      bottomNavigationController
                                          .astrologerbyId[0].charge!
                                          .toString());
                                  if (charge * 5 <=
                                          global.splashController.currentUser!
                                              .walletAmount! ||
                                      bottomNavigationController
                                              .astrologerbyId[0]
                                              .isFreeAvailable ==
                                          true) {
                                    if (bottomNavigationController
                                            .astrologerbyId[0].callStatus ==
                                        "Online") {
                                      await bottomNavigationController
                                          .checkAlreadyInReqForCall(
                                              bottomNavigationController
                                                  .astrologerbyId[0].id!);
                                      if (bottomNavigationController
                                              .isUserAlreadyInCallReq ==
                                          false) {
                                        global.showOnlyLoaderDialog(context);

                                        await Get.to(() => CallIntakeFormScreen(
                                              astrologerProfile:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .profileImage!,
                                              type: "Call",
                                              astrologerId:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].id!,
                                              astrologerName:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].name!,
                                              isFreeAvailable:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .isFreeAvailable,
                                              rate: charge.toString(),
                                            ));

                                        global.hideLoader();
                                      } else {
                                        bottomNavigationController
                                            .dialogForNotCreatingSession(
                                                context);
                                      }
                                    } else if (bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Offline" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Busy" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Wait Time") {
                                      dialogForJoinInWaitList(
                                          context,
                                          bottomNavigationController
                                              .astrologerbyId[0].name!,
                                          true,
                                          bottomNavigationController
                                              .astrologerbyId[0].chatStatus
                                              .toString());
                                    }
                                  } else {
                                    global.showOnlyLoaderDialog(context);
                                    await walletController.getAmount();
                                    global.hideLoader();
                                    global.showMinimumBalancePopup(
                                        context,
                                        (charge * 5).toString(),
                                        '${bottomNavigationController.astrologerbyId[0].name}',
                                        walletController.payment,
                                        "Call");
                                  }
                                }
                              },

                                  ///for schedule
                                  () async {
                                print("schedul");
                                if (bottomNavigationController
                                        .astrologerbyId[0].call_sections
                                        .toString() ==
                                    "0") {
                                  Get.snackbar("Note",
                                      "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Audio Call",
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white);
                                } else {
                                  double charge = double.parse(
                                      bottomNavigationController
                                          .astrologerbyId[0].charge!
                                          .toString());
                                  if (charge * 5 <=
                                          global.splashController.currentUser!
                                              .walletAmount! ||
                                      bottomNavigationController
                                              .astrologerbyId[0]
                                              .isFreeAvailable ==
                                          true) {
                                    if (bottomNavigationController
                                            .astrologerbyId[0].callStatus ==
                                        "Online") {
                                      await bottomNavigationController
                                          .checkAlreadyInReqForCall(
                                              bottomNavigationController
                                                  .astrologerbyId[0].id!);
                                      if (bottomNavigationController
                                              .isUserAlreadyInCallReq ==
                                          false) {
                                        global.showOnlyLoaderDialog(context);

                                        await Get.to(() => CallIntakeFormScreen(
                                              bookingType: 'schedule',
                                              astrologerProfile:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .profileImage!,
                                              type: "Call",
                                              astrologerId:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].id!,
                                              astrologerName:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].name!,
                                              isFreeAvailable:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .isFreeAvailable,
                                              rate: charge.toString(),
                                            ));

                                        global.hideLoader();
                                      } else {
                                        bottomNavigationController
                                            .dialogForNotCreatingSession(
                                                context);
                                      }
                                    } else if (bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Offline" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Busy" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Wait Time") {
                                      dialogForJoinInWaitList(
                                          context,
                                          bottomNavigationController
                                              .astrologerbyId[0].name!,
                                          true,
                                          bottomNavigationController
                                              .astrologerbyId[0].chatStatus
                                              .toString());
                                    }
                                  } else {
                                    global.showOnlyLoaderDialog(context);
                                    await walletController.getAmount();
                                    global.hideLoader();
                                    global.showMinimumBalancePopup(
                                        context,
                                        (charge * 5).toString(),
                                        '${bottomNavigationController.astrologerbyId[0].name}',
                                        walletController.payment,
                                        "Call");
                                  }
                                }
                              });
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: bottomNavigationController
                                        .astrologerbyId[0].call_sections
                                        .toString() ==
                                    "0"
                                ? Colors.grey
                                : (bottomNavigationController
                                            .astrologerbyId[0].callStatus ==
                                        "Online"
                                    ? Colors.green
                                    : Colors.orangeAccent),
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.call, color: Colors.white),
                                Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Audio",
                                            textAlign: TextAlign.center,
                                            style: Get
                                                .theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.white),
                                          ).tr(),
                                          bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .callStatus ==
                                                      "Offline" ||
                                                  bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .callStatus ==
                                                      "Busy"
                                              ? Text(
                                                  bottomNavigationController
                                                              .astrologerbyId[0]
                                                              .callStatus ==
                                                          "Offline"
                                                      ? "Currently Offline"
                                                      : "Currently Busy",
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ).tr()
                                              : bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .callStatus ==
                                                      "Online"
                                                  ? SizedBox()
                                                  : Text(
                                                      bottomNavigationController
                                                                  .astrologerbyId[
                                                                      0]
                                                                  .callWaitTime!
                                                                  .difference(
                                                                      DateTime
                                                                          .now())
                                                                  .inMinutes >
                                                              0
                                                          ? "Wait till - ${bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                          : "Waiting",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Get.theme.textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ).tr(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox()
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      child:
                          GetBuilder<CallController>(builder: (callController) {
                        return InkWell(
                          onTap: () async {
                            bool isLogin = await global.isLogin();

                            ///new logic for schedule or instant chat
                            if (isLogin) {
                              showChatOptions(context, type: "VideoCall",

                                  ///for instant
                                  () async {
                                // 🔥 Your existing "instant chat" logic goes here
                                if (bottomNavigationController
                                        .astrologerbyId[0].call_sections
                                        .toString() ==
                                    "0") {
                                  Get.snackbar("Note",
                                      "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Video Call",
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white);
                                } else {
                                  double charge = double.parse(
                                      bottomNavigationController
                                          .astrologerbyId[0].videoCallRate!
                                          .toString());
                                  if (charge * 5 <=
                                          global.splashController.currentUser!
                                              .walletAmount! ||
                                      bottomNavigationController
                                              .astrologerbyId[0]
                                              .isFreeAvailable ==
                                          true) {
                                    if (bottomNavigationController
                                            .astrologerbyId[0].callStatus ==
                                        "Online") {
                                      await bottomNavigationController
                                          .checkAlreadyInReqForCall(
                                              bottomNavigationController
                                                  .astrologerbyId[0].id!);
                                      if (bottomNavigationController
                                              .isUserAlreadyInCallReq ==
                                          false) {
                                        global.showOnlyLoaderDialog(context);

                                        await Get.to(() => CallIntakeFormScreen(
                                              astrologerProfile:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .profileImage!,
                                              type: "Videocall",
                                              astrologerId:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].id!,
                                              astrologerName:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].name!,
                                              isFreeAvailable:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .isFreeAvailable,
                                              rate: charge.toString(),
                                            ));

                                        global.hideLoader();
                                      } else {
                                        bottomNavigationController
                                            .dialogForNotCreatingSession(
                                                context);
                                      }
                                    } else if (bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Offline" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Busy" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Wait Time") {
                                      dialogForJoinInWaitList(
                                          context,
                                          bottomNavigationController
                                              .astrologerbyId[0].name!,
                                          true,
                                          bottomNavigationController
                                              .astrologerbyId[0].chatStatus
                                              .toString());
                                    }
                                  } else {
                                    global.showOnlyLoaderDialog(context);
                                    await walletController.getAmount();
                                    global.hideLoader();
                                    global.showMinimumBalancePopup(
                                        context,
                                        (charge * 5).toString(),
                                        '${bottomNavigationController.astrologerbyId[0].name}',
                                        walletController.payment,
                                        "Call");
                                  }
                                }
                              },

                                  ///for schedule
                                  () async {
                                print("schedul");
                                if (bottomNavigationController
                                        .astrologerbyId[0].call_sections
                                        .toString() ==
                                    "0") {
                                  Get.snackbar("Note",
                                      "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Video Call",
                                      backgroundColor: Colors.orange,
                                      colorText: Colors.white);
                                } else {
                                  double charge = double.parse(
                                      bottomNavigationController
                                          .astrologerbyId[0].videoCallRate!
                                          .toString());
                                  if (charge * 5 <=
                                          global.splashController.currentUser!
                                              .walletAmount! ||
                                      bottomNavigationController
                                              .astrologerbyId[0]
                                              .isFreeAvailable ==
                                          true) {
                                    if (bottomNavigationController
                                            .astrologerbyId[0].callStatus ==
                                        "Online") {
                                      await bottomNavigationController
                                          .checkAlreadyInReqForCall(
                                              bottomNavigationController
                                                  .astrologerbyId[0].id!);
                                      if (bottomNavigationController
                                              .isUserAlreadyInCallReq ==
                                          false) {
                                        global.showOnlyLoaderDialog(context);

                                        await Get.to(() => CallIntakeFormScreen(
                                              bookingType: 'schedule',
                                              astrologerProfile:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .profileImage!,
                                              type: "Videocall",
                                              astrologerId:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].id!,
                                              astrologerName:
                                                  bottomNavigationController
                                                      .astrologerbyId[0].name!,
                                              isFreeAvailable:
                                                  bottomNavigationController
                                                      .astrologerbyId[0]
                                                      .isFreeAvailable,
                                              rate: charge.toString(),
                                            ));

                                        global.hideLoader();
                                      } else {
                                        bottomNavigationController
                                            .dialogForNotCreatingSession(
                                                context);
                                      }
                                    } else if (bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Offline" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Busy" ||
                                        bottomNavigationController
                                                .astrologerbyId[0].callStatus ==
                                            "Wait Time") {
                                      dialogForJoinInWaitList(
                                          context,
                                          bottomNavigationController
                                              .astrologerbyId[0].name!,
                                          true,
                                          bottomNavigationController
                                              .astrologerbyId[0].chatStatus
                                              .toString());
                                    }
                                  } else {
                                    global.showOnlyLoaderDialog(context);
                                    await walletController.getAmount();
                                    global.hideLoader();
                                    global.showMinimumBalancePopup(
                                        context,
                                        (charge * 5).toString(),
                                        '${bottomNavigationController.astrologerbyId[0].name}',
                                        walletController.payment,
                                        "Call");
                                  }
                                }
                              });
                            }
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            color: bottomNavigationController
                                        .astrologerbyId[0].call_sections
                                        .toString() ==
                                    "0"
                                ? Colors.grey
                                : (bottomNavigationController
                                            .astrologerbyId[0].callStatus ==
                                        "Online"
                                    ? Colors.redAccent
                                    : Colors.orangeAccent),
                            elevation: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.video_call, color: Colors.white),
                                Center(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          Text(
                                            "Video",
                                            textAlign: TextAlign.center,
                                            style: Get
                                                .theme.textTheme.bodyMedium!
                                                .copyWith(color: Colors.white),
                                          ).tr(),
                                          bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .callStatus ==
                                                      "Offline" ||
                                                  bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .callStatus ==
                                                      "Busy"
                                              ? Text(
                                                  bottomNavigationController
                                                              .astrologerbyId[0]
                                                              .callStatus ==
                                                          "Busy"
                                                      ? 'Currently Busy'
                                                      : "Currently Offline",
                                                  textAlign: TextAlign.center,
                                                  style: Get.theme.textTheme
                                                      .bodyMedium!
                                                      .copyWith(
                                                          color: Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ).tr()
                                              : bottomNavigationController
                                                          .astrologerbyId[0]
                                                          .callStatus ==
                                                      "Online"
                                                  ? SizedBox()
                                                  : Text(
                                                      bottomNavigationController
                                                                  .astrologerbyId[
                                                                      0]
                                                                  .callWaitTime!
                                                                  .difference(
                                                                      DateTime
                                                                          .now())
                                                                  .inMinutes >
                                                              0
                                                          ? "Wait till - ${bottomNavigationController.astrologerbyId[0].callWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                          : "Waiting",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: Get.theme.textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ).tr(),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox()
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  ///astrologer puja design
  Widget buildAstrologerPujaSection(BuildContext context, String? name) {
    print(
        "image profile:- ${bottomNavigationController.astrologerbyId[0].pujas![1].pujaImages![0].toString()}");
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book a Puja with ${name.toString()}",
            style: Get.theme.textTheme.bodyMedium!.copyWith(
              fontSize: 17.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 310, // height for horizontal cards
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  bottomNavigationController.astrologerbyId[0].pujas!.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 200,
                  margin: const EdgeInsets.only(right: 12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 120,
                            autoPlay: bottomNavigationController
                                    .astrologerbyId[0]
                                    .pujas![index]
                                    .pujaImages!
                                    .length >
                                1,
                            enableInfiniteScroll: bottomNavigationController
                                    .astrologerbyId[0]
                                    .pujas![index]
                                    .pujaImages!
                                    .length >
                                1,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            enlargeCenterPage: true,
                            viewportFraction: 1.0,
                          ),
                          items: bottomNavigationController
                              .astrologerbyId[0].pujas![index].pujaImages!
                              .map((imageUrl) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                imageUrl.toString(),
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            );
                          }).toList(),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bottomNavigationController
                                    .astrologerbyId[0].pujas![index].pujaTitle
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                bottomNavigationController.astrologerbyId[0]
                                    .pujas![index].longDescription,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 8),
                              global.getSystemFlagValueForLogin(global
                                          .systemFlagNameList.walletType) ==
                                      "Wallet"
                                  ? Text(
                                      "${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${bottomNavigationController.astrologerbyId[0].pujas![index].pujaPrice.toString()}",
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.deepPurple,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          " ${bottomNavigationController.astrologerbyId[0].pujas![index].pujaPrice.toString()}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.deepPurple,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          width: 0.4.w,
                                        ),
                                        Image.network(
                                          global.getSystemFlagValueForLogin(
                                              global
                                                  .systemFlagNameList.coinIcon),
                                          height: 1.2.h,
                                        ),
                                      ],
                                    ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(PujaDetailScreen(
                                      pujaName: bottomNavigationController
                                          .astrologerbyId[0]
                                          .pujas![index]
                                          .pujaTitle,
                                      description: bottomNavigationController
                                          .astrologerbyId[0]
                                          .pujas![index]
                                          .longDescription,
                                      images: bottomNavigationController
                                          .astrologerbyId[0]
                                          .pujas![index]
                                          .pujaImages,
                                      price: bottomNavigationController
                                          .astrologerbyId[0]
                                          .pujas![index]
                                          .pujaPrice
                                          .toString(),
                                      duration: bottomNavigationController
                                          .astrologerbyId[0]
                                          .pujas![index]
                                          .pujaDuration,
                                      benefits: [],
                                      startTime: bottomNavigationController
                                          .astrologerbyId[0]
                                          .pujas![index]
                                          .pujaStartDatetime
                                          .toString(),
                                      poojadetail: CustomPujaModel(
                                          id: bottomNavigationController
                                              .astrologerbyId[0]
                                              .pujas![index]
                                              .id
                                              .toInt(),
                                          astrologerId:
                                              bottomNavigationController
                                                  .astrologerbyId[0]
                                                  .pujas![index]
                                                  .astrologerId
                                                  .toInt(),
                                          pujaPrice: bottomNavigationController
                                              .astrologerbyId[0]
                                              .pujas![index]
                                              .pujaPrice,
                                          pujaTitle: bottomNavigationController
                                              .astrologerbyId[0]
                                              .pujas![index]
                                              .pujaTitle,
                                          pujaImages: bottomNavigationController
                                              .astrologerbyId[0]
                                              .pujas![index]
                                              .pujaImages),
                                    ));
                                  },
                                  child: const Text("Book Now"),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  ///user review design
  Widget buildReviewSection(
      BuildContext context, ReviewController reviewController) {
    if (reviewController.reviewList.isEmpty) {
      return const SizedBox();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('User Reviews',
                  style: Get.theme.textTheme.bodyMedium!.copyWith(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  )).tr(),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    builder: (context) => ratingAndReview(),
                  );
                },
                child: Text(
                  'See All',
                  style: Get.textTheme.bodyMedium!.copyWith(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue,
                  ),
                ).tr(),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey.shade300,
              height: 2,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: reviewController.reviewList.length,
            itemBuilder: (context, index) {
              final review = reviewController.reviewList[index];
              return Container(
                width: 260,
                margin: EdgeInsets.only(
                    left: 3.w,
                    right: index == reviewController.reviewList.length - 1
                        ? 3.w
                        : 0),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          review.profile.toString() == "" ||
                                  review.profile.toString() == "null"
                              ? CircleAvatar(
                                  backgroundImage: AssetImage(
                                    Images.deafultUser,
                                  ),
                                  radius: 20,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    "${review.profile}",
                                  ),
                                  radius: 20,
                                ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              review.username.toString() == "" ||
                                      review.username.toString() == "null"
                                  ? "User"
                                  : review.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              Row(
                                children: List.generate(5, (index) {
                                  double rating = review.rating.toDouble();
                                  if (index < rating.floor()) {
                                    return const Icon(Icons.star,
                                        size: 18, color: Colors.orange);
                                  } else if (index == rating.floor() &&
                                      rating % 1 >= 0.5) {
                                    return const Icon(Icons.star_half,
                                        size: 18, color: Colors.orange);
                                  } else {
                                    return Icon(Icons.star,
                                        size: 18, color: Colors.grey[300]);
                                  }
                                }),
                              ),
                              Text("(${review.rating})")
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        review.review,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 1.h),
      ],
    );
  }

  ///options for instant chat and schedule appoinment
  void showChatOptions(
      BuildContext context, Function onInstantChat, Function onSchedulChat,
      {String? type = ''}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.lightBlue,
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    onInstantChat();
                  },
                  icon: const Icon(Icons.flash_on, color: Colors.white),
                  label: Text(
                    "Instant $type",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);
                    onSchedulChat();
                  },
                  icon: const Icon(Icons.calendar_today, color: Colors.white),
                  label: const Text(
                    "Schedule Appointment",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget menuItem(IconData icon, String s) {
    return Container(
      margin: EdgeInsets.all(1.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.w),
          border: Border.all(color: Colors.grey.shade300, width: 0.5)),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Get.theme.primaryColor,
              ),
              SizedBox(width: 5),
              Text(
                s,
                style: Get.textTheme.bodyMedium!
                    .copyWith(fontSize: 12, color: Colors.black),
              )
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 18,
            color: Colors.grey,
          )
        ],
      ),
    );
  }

  Widget ratingAndReview() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: Get.height * 0.8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () => Get.back(),
                        child: Icon(kIsWeb
                            ? Icons.arrow_back
                            : Platform.isIOS
                                ? Icons.arrow_back_ios
                                : Icons.arrow_back)),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Rating and Reviews',
                        style: Get.theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        )).tr(),
                  ],
                ),
              ],
            ),
            Expanded(
              child: GetBuilder<ReviewController>(builder: (reviewController) {
                return ListView.builder(
                    itemCount: reviewController.reviewList.length,
                    itemBuilder: (context, index) {
                      return ShowReviewWidget(
                        index: index,
                        astologername:
                            bottomNavigationController.astrologerbyId[0].name ??
                                "AStrologer",
                        astroImage:
                            "${bottomNavigationController.astrologerbyId[0].profileImage}",
                      );
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }
}

double getStarRatingPercentage(
    {required int starCount, required Rating? ratinglist}) {
  final totalRatings = ratinglist!.oneStarRating!.toInt() +
      ratinglist.twoStarRating!.toInt() +
      ratinglist.threeStarRating!.toInt() +
      ratinglist.fourStarRating!.toInt() +
      ratinglist.fiveStarRating!.toInt();

  if (totalRatings == 0) return 0.0;

  switch (starCount) {
    case 1:
      return ratinglist.oneStarRating!.toInt() / totalRatings;
    case 2:
      return ratinglist.twoStarRating!.toInt() / totalRatings;
    case 3:
      return ratinglist.threeStarRating!.toInt() / totalRatings;
    case 4:
      return ratinglist.fourStarRating!.toInt() / totalRatings;
    case 5:
      return ratinglist.fiveStarRating!.toInt() / totalRatings;
    default:
      return 0.0;
  }
}
