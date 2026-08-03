// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/liveAstrologerController.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/upcoming_controller.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'call/hms/HMSLiveScreen.dart';
import 'call/zegocloud/zegoLiveScreen.dart';
import 'live_astrologer/live_astrologer_screen.dart';

class LiveAstrologerListScreen extends StatelessWidget {
  bool? isFromBottom;
  LiveAstrologerListScreen({super.key, this.isFromBottom = false});

  final liveAstrologerController = Get.find<LiveAstrologerController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final liveController = Get.find<LiveController>();
  final upcomingController = Get.find<UpcomingController>();
  final splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isFromBottom == true) {
          bottomNavigationController.setBottomIndex(0, 0);
          return false;
        }
        return true;
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // 🔹 Custom TabBar below AppBar
              Container(
                color: Colors.grey[100],
                child: TabBar(
                  tabs: [
                    Tab(text: "Live Now"),
                    Tab(text: "Upcoming"),
                  ],
                  indicatorColor: Get.theme.primaryColor,
                  labelColor: Get.theme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  onTap: (int i) {
                    print("${i}");
                    if (i == 1) {}
                  },
                ),
              ),

              // 🔹 TabBarView
              Expanded(
                child: TabBarView(
                  children: [
                    // 🔹 Live Now Tab
                    GetBuilder<BottomNavigationController>(
                      builder: (bottomNavigationController) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await bottomNavigationController
                                .getLiveAstrologerList();
                          },
                          child: bottomNavigationController
                                  .listliveAstrologer!.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: Get.height *
                                          0.7, // fill space so center aligns
                                      child: Center(
                                        child: Text(
                                          'No ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}s live yet!',
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ).tr(),
                                      ),
                                    ),
                                  ],
                                )
                              : GridView.builder(
                                  padding: const EdgeInsets.all(8),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    childAspectRatio: 3.5 / 5,
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 7,
                                  ),
                                  itemCount: bottomNavigationController
                                      .listliveAstrologer!.length,
                                  itemBuilder: (context, index) {
                                    final astrologer =
                                        bottomNavigationController
                                            .listliveAstrologer![index];
                                    return _buildAstrologerCard(
                                      astrologer.name ?? 'User',
                                      astrologer.profileImage ?? '',
                                      badgeText: "LIVE",
                                      badgeColor: Colors.green,
                                      onTap: () async {
                                        bottomNavigationController
                                                .anotherLiveAstrologers =
                                            bottomNavigationController
                                                .listliveAstrologer!
                                                .where((e) =>
                                                    e.astrologerId !=
                                                    astrologer.astrologerId)
                                                .toList();
                                        bottomNavigationController.update();
                                        liveController.getWaitList(
                                            astrologer.channelName!);
                                        liveController.isImInLive = true;
                                        liveController.isJoinAsChat = false;
                                        liveController.isLeaveCalled = false;
                                        liveController.update();
                                        log('toke for calling is ${astrologer.token}');
                                        log('calling method is  ${bottomNavigationController.liveAstrologerModel?.callMethod}');
                                        if (bottomNavigationController
                                                .liveAstrologerModel
                                                ?.callMethod ==
                                            'hms') {
                                          Get.to(() => HMSLiveScreen(
                                                hmsToken: astrologer.token,
                                                channel: astrologer.channelName,
                                                astrologerId:
                                                    astrologer.astrologerId,
                                                videoCallCharge:
                                                    astrologer.videoCallRate,
                                                charge: astrologer.charge,
                                              ));
                                        } else if (bottomNavigationController
                                                .liveAstrologerModel
                                                ?.callMethod ==
                                            'zegocloud') {
                                          Get.to(() => Zegolivescreen(
                                                liveToken: astrologer.token,
                                                liveID: astrologer.channelName
                                                    .toString(),
                                                localUserID:
                                                    global.user.id.toString(),
                                                isHost: false,
                                                astrologerID: astrologer
                                                    .astrologerId
                                                    .toString(),
                                                videoCallCharge:
                                                    astrologer.videoCallRate,
                                                charge: astrologer.charge,
                                              ));
                                        } else if (bottomNavigationController
                                                .liveAstrologerModel
                                                ?.callMethod ==
                                            'agora') {
                                          Get.to(() => LiveAstrologerScreen(
                                                token: astrologer.token,
                                                channel: astrologer.channelName,
                                                astrologerName: astrologer.name,
                                                astrologerId:
                                                    astrologer.astrologerId,
                                                isFromHome: true,
                                                charge: astrologer.charge,
                                                isForLiveCallAcceptDecline:
                                                    false,
                                                videoCallCharge:
                                                    astrologer.videoCallRate,
                                                isFollow: astrologer.isFollow!,
                                              ));
                                        } else {
                                          log('not found this callmethod is ${bottomNavigationController.liveAstrologerModel?.callMethod}');
                                        }
                                        // your existing onTap logic
                                      },
                                    );
                                  },
                                ),
                        );
                      },
                    ),

                    // 🔹 Upcoming Tab
                    GetBuilder<UpcomingController>(
                      builder: (upcomingController) {
                        return RefreshIndicator(
                          onRefresh: () async {
                            await upcomingController.getUpcomming();
                          },
                          child: upcomingController.upComingList.isEmpty
                              ? ListView(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: Get.height *
                                          0.7, // fill space so Center is visible
                                      child: Center(
                                        child: Text(
                                          'No upcoming live sessions',
                                          style: TextStyle(
                                              fontSize: 15, color: Colors.grey),
                                        ).tr(),
                                      ),
                                    ),
                                  ],
                                )
                              : GridView.builder(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.8,
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 7,
                                  ),
                                  itemCount:
                                      upcomingController.upComingList.length,
                                  itemBuilder: (context, index) {
                                    final astrologer =
                                        upcomingController.upComingList[index];
                                    return _buildUpcommmingAstrologerCard(
                                        "${astrologer.astrologerName}",
                                        "${astrologer.profileImage}",
                                        badgeText: "COMING SOON",
                                        badgeColor: Colors.orange,
                                        scheduledate: formatDate(
                                            astrologer.scheduleLiveDate),
                                        scheduletime: convert24to12(astrologer
                                            .scheduleLiveTime
                                            .toString()), onTap: () {
                                      Get.snackbar("Upcoming Live",
                                          "${astrologer.astrologerName} will be live soon!");
                                    }, onRemindMe: () {
                                      print("Reming me");
                                      print(
                                          "${upcomingController.upComingList[index].id.toString()}");
                                      print(
                                          "${upcomingController.upComingList[index]}");
                                      upcomingController.remindMe(
                                          upcomingController
                                              .upComingList[index].astrologerId
                                              .toString());
                                    });
                                  },
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convert24to12(String time24) {
    final time = DateFormat("HH:mm").parse(time24); // 24h input
    return DateFormat("hh:mm a").format(time); // 12h output
  }

  String formatDate(DateTime? date) {
    return DateFormat("d-MMM-yyyy").format(date!);
  }

  Widget _buildAstrologerCard(
    String name,
    String imageUrl, {
    required String badgeText,
    required Color badgeColor,
    VoidCallback? onTap,
    String? scheduledate,
    String? scheduletime,
  }) {
    log('Live image paht is $imageUrl');
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageUrl.isEmpty
                ? AssetImage(Images.deafultUser) as ImageProvider
                : CachedNetworkImageProvider('$imageUrl'),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // 🔹 COMING SOON (Top Right, Smaller Badge)
            if (badgeText.toUpperCase() == "COMING SOON")
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).tr(),
                ),
              ),

            // 🔹 Bottom Content
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // LIVE badge stays at bottom center
                    if (badgeText.toUpperCase() == "LIVE")
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          badgeText,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ).tr(),
                      ),

                    const SizedBox(height: 6),

                    // Name
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        name.capitalize.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ).tr(),
                    ),

                    // 🔹 Date & Time (Separate Widget)
                    if (badgeText.toUpperCase() == "COMING SOON") ...[
                      const SizedBox(height: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          scheduletime == null
                              ? SizedBox()
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.sp),
                                      color: Colors.blue),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.schedule,
                                          size: 14, color: Colors.white70),
                                      const SizedBox(width: 4),
                                      Text(
                                        scheduletime.toString(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          SizedBox(
                            height: 0.5.h,
                          ),
                          scheduledate == null
                              ? SizedBox()
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 2.w),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.sp),
                                      color: Colors.deepPurple),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.date_range,
                                          size: 14, color: Colors.white70),
                                      const SizedBox(width: 4),
                                      Text(
                                        scheduledate.toString(),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcommmingAstrologerCard(
    String name,
    String imageUrl, {
    required String badgeText,
    required Color badgeColor,
    String? scheduledate,
    String? scheduletime,
    VoidCallback? onTap,
    VoidCallback? onRemindMe, // callback for Remind Me
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageUrl.isEmpty
                ? AssetImage(Images.deafultUser) as ImageProvider
                : NetworkImage('$imageUrl'),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        child: Stack(
          children: [
            // 🔹 COMING SOON badge top-right
            if (badgeText.toUpperCase() == "COMING SOON")
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeColor.withOpacity(0.95),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                  ),
                  child: Text(
                    badgeText,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ).tr(),
                ),
              ),

            // 🔹 Bottom Info (Name + Date/Time)
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        name.capitalize.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ).tr(),
                    ),

                    const SizedBox(height: 4),

                    // Date & Time Row
                    if (scheduledate != null && scheduletime != null)
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.schedule, size: 14, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              "$scheduledate, $scheduletime",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // 🔹 Remind Me Button (Top-Left, smaller)
            Positioned(
              top: 8,
              left: 8,
              child: GestureDetector(
                onTap: onRemindMe,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.notifications_none,
                          size: 12, color: Colors.white),
                      SizedBox(width: 3),
                      Text(
                        "Remind",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
