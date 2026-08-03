// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/views/call/onetooneAudio/player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/bottomNavigationController.dart';
import '../../../controllers/reviewController.dart';
import '../../../utils/images.dart';
import '../../astrologerProfile/astrologerProfile.dart';

class CallHistoryDetailScreen extends StatefulWidget {
  final int astrologerId;
  final String astrologerProfile;
  final int index;
  final int callType;
  CallHistoryDetailScreen(
      {a,
      o,
      required this.astrologerId,
      required this.astrologerProfile,
      required this.index,
      required this.callType})
      : super();

  @override
  State<CallHistoryDetailScreen> createState() =>
      _CallHistoryDetailScreenState();
}

class _CallHistoryDetailScreenState extends State<CallHistoryDetailScreen> {
  final HistoryController historyController = Get.find<HistoryController>();

  final BottomNavigationController bottomNavigationController =
      Get.find<BottomNavigationController>();

  @override
  void initState() {
    historyController.inIt();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await historyController.disposeAudioPlayer();
        await historyController.disposeAudioPlayer2();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () async {
              Get.find<ReviewController>().getReviewData(widget.astrologerId);
              global.showOnlyLoaderDialog(context);
              await bottomNavigationController
                  .getAstrologerbyId(widget.astrologerId);
              global.hideLoader();
              Get.to(() => AstrologerProfile(
                    index: 0,
                  ));
            },
            child: Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: widget.astrologerProfile == "" ||
                          historyController.callHistoryListById.isEmpty
                      ? Image.asset(
                          Images.deafultUser,
                          height: 40,
                          width: 40,
                          fit: BoxFit.cover,
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(100.w),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: global
                                .buildImageUrl('${widget.astrologerProfile}'),
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              Images.deafultUser,
                              height: 40,
                              width: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  historyController.callHistoryListById.isEmpty
                      ? ""
                      : historyController
                          .callHistoryListById[0].astrologerName!,
                ),
              ],
            ),
          ),
          leading: IconButton(
            onPressed: () async {
              await historyController.disposeAudioPlayer();
              await historyController.disposeAudioPlayer2();
              Get.back();
            },
            icon: Icon(
                kIsWeb
                    ? Icons.arrow_back
                    : Platform.isIOS
                        ? Icons.arrow_back_ios
                        : Icons.arrow_back,
                color: Colors.black //Get.theme.iconTheme.color,
                ),
          ),
        ),
        body: historyController.callHistoryListById.isEmpty
            ? Center(
                child: Text('No Details Found').tr(),
              )
            : Container(
                width: Get.width,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Colors.white),
                child: ListView(
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Appoinment Schedule:',
                              style: Get.textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ).tr(),
                            Text(
                                '${tr("Expert Name:")} ${historyController.callHistoryListById[0].astrologerName}'),
                            Text(
                              "${DateFormat("dd MMM yy, hh:mm a").format(DateTime.parse(historyController.callHistoryListById[0].createdAt.toString()))}",
                            ),
                            Text(
                                '${tr("Duration:")} ${historyController.callHistoryListById[0].totalMin ?? 0} ${tr("Minutes")}'),
                            Text(
                                '${tr("Price")}: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.callHistoryListById[0].callRate}'),
                            Text(
                                '${tr("Deduction")}: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${historyController.callHistoryListById[0].deduction}')
                          ],
                        ),
                      ),
                    ),
                    widget.callType == 10
                        ? GestureDetector(
                            onTap: () {
                              log("ssid ${historyController.callHistoryListById[0].sId}");
                              log("ssid1  ${historyController.callHistoryListById[0].sId1}");

                              Get.to(() => Player(
                                  sid: historyController
                                      .callHistoryListById[0].sId
                                      .toString()));
                            },
                            child: Container(
                              height: 6.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.h),
                                border:
                                    Border.all(color: Colors.pink, width: 1),
                              ),
                              child: Center(
                                child: Text(
                                  'Play',
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .titleSmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Get.dialog(AlertDialog(
                            backgroundColor: Colors.white,
                            scrollable: true,
                            title: Container(
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, right: 15),
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: Icon(Icons.close),
                                    ),
                                  )),
                            ),
                            titlePadding: const EdgeInsets.all(0),
                            content: addReviewWidget(
                                historyController.callHistoryListById.isEmpty
                                    ? ""
                                    : historyController
                                        .callHistoryListById[0].astrologerName!,
                                "astrologerProfile",
                                context)));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Text("Add your Review"),
                        )),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget addReviewWidget(
      String astrologerName, String astrologerProfile, BuildContext context) {
    return GetBuilder<ChatController>(builder: (chatController) {
      return SizedBox(
        height: Get.height * 0.4,
        child: Column(
          children: [
            Center(child: Text(astrologerName).tr()),
            SizedBox(
              height: 1.h,
            ),
            widget.astrologerProfile == ""
                ? Center(
                    child: CircleAvatar(
                      radius: 33,
                      child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            Images.deafultUser,
                            fit: BoxFit.fill,
                            height: 40,
                          )),
                    ),
                  )
                : Center(
                    child: CachedNetworkImage(
                      imageUrl:
                          global.buildImageUrl("${widget.astrologerProfile}"),
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              Images.deafultUser,
                              fit: BoxFit.fill,
                              height: 40,
                            ));
                      },
                    ),
                  ),
            Center(
              child: RatingBar(
                initialRating: chatController.rating ?? 0,
                itemCount: 5,
                allowHalfRating: true,
                ratingWidget: RatingWidget(
                  full: const Icon(Icons.grade, color: Colors.yellow),
                  half: const Icon(Icons.star_half, color: Colors.yellow),
                  empty: const Icon(Icons.grade, color: Colors.grey),
                ),
                onRatingUpdate: (rating) {
                  chatController.rating = rating;
                  chatController.update();
                },
              ),
            ),
            TextField(
              controller: chatController.reviewController,
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 2,
              decoration: InputDecoration(
                isDense: true,
                hintStyle: TextStyle(fontSize: 12),
                hintText: "Describe your experience",
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            SizedBox(
              height: 60,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                    backgroundColor:
                        MaterialStateProperty.all(Get.theme.primaryColor),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    print('submit');
                    if (chatController.rating == 0) {
                      global.showToast(
                        message: 'Rate Astrologer',
                        textColor: global.textColor,
                        bgColor: global.toastBackGoundColor,
                      );
                    } else if (chatController.reviewController.text == "") {
                      global.showToast(
                        message: 'Enter Review',
                        textColor: global.textColor,
                        bgColor: global.toastBackGoundColor,
                      );
                    } else {
                      if (chatController.reviewData.isNotEmpty) {
                        global.showOnlyLoaderDialog(context);
                        await chatController.updateReview(
                            chatController.reviewData[0].id!,
                            widget.astrologerId);
                        global.hideLoader();
                      } else {
                        global.showOnlyLoaderDialog(context);
                        await chatController.addReview(
                          widget.astrologerId,
                          chatController.reviewController.text,
                        );
                        global.hideLoader();
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    textAlign: TextAlign.center,
                    style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white),
                  ).tr(),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
