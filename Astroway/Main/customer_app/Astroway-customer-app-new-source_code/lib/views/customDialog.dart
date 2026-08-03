// ignore_for_file: must_be_immutable
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../controllers/chatController.dart';
import '../utils/images.dart';

class CustomDialog extends StatefulWidget {
  String? astrologerName;
  String? astrologerProfile;
  int? astrologerId;
  CustomDialog(
      {this.astrologerName, this.astrologerProfile, this.astrologerId});
  @override
  State<CustomDialog> createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  void initState() {
    log('init ${widget.astrologerName}');
    log('init 1${widget.astrologerId}');
    log('init2 ${widget.astrologerProfile}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return contentBox(widget.astrologerName, widget.astrologerProfile,
        widget.astrologerId, context);
  }

  contentBox(astroname, astroProfile, astrologerID, context) {
    return Material(
      color: Colors.transparent,
      child: GetBuilder<ChatController>(
        builder: (chatController) => Center(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 95.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(3.w),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: 6.h),
                        Text(
                          astroname,
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        SizedBox(
                            height: 0.2,
                            width: 95.w,
                            child: Container(
                              color: Colors.red.shade300,
                            )),
                        Container(
                          margin: EdgeInsets.all(2.w),
                          padding: EdgeInsets.symmetric(horizontal: 4.w),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'How was Your session?',
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ),
                        // Summary
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'Please take a moment to give us your feedback so we can ensure you get the best experience',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w300,
                                color: Colors.black),
                          ),
                        ),
                        // Rating
                        RatingBar.builder(
                          initialRating: chatController.reviewData.isNotEmpty
                              ? chatController.reviewData[0].rating
                              : 0.0,
                          itemCount: 5,
                          itemSize: 30.sp,
                          allowHalfRating: true,
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) async {
                            chatController.rating = rating;
                            chatController.update();
                          },
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          child: TextField(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextButton(
                              style: ButtonStyle(
                                padding:
                                    WidgetStateProperty.all(EdgeInsets.all(10)),
                                backgroundColor: WidgetStateProperty.all(
                                    Get.theme.primaryColor),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                print('submit');
                                if (chatController.rating == 0) {
                                  global.showToast(
                                    message: 'Rate Expert',
                                    textColor: global.textColor,
                                    bgColor: global.toastBackGoundColor,
                                  );
                                } else if (chatController
                                        .reviewController.text ==
                                    "") {
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
                                        astrologerID);
                                    global.hideLoader();
                                  } else {
                                    global.showOnlyLoaderDialog(context);
                                    await chatController.addReview(
                                      astrologerID,
                                      chatController.reviewController.text,
                                    );
                                    global.hideLoader();
                                  }
                                }
                              },
                              child: Text(
                                'Submit',
                                textAlign: TextAlign.center,
                                style: Get.theme.primaryTextTheme.titleMedium!
                                    .copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                              ).tr(),
                            ),
                          ),
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: RawMaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      elevation: 1.0,
                      fillColor: Colors.white,
                      child: Icon(
                        Icons.close,
                        size: 18.sp,
                      ),
                      padding: EdgeInsets.zero,
                      shape: CircleBorder(side: BorderSide(color: Colors.grey)),
                    ),
                  ),
                  Positioned(
                    top: -3.h,
                    child: CachedNetworkImage(
                      height: 10.h,
                      fit: BoxFit.contain,
                      imageUrl: global.buildImageUrl("$astroProfile"),
                      imageBuilder: (context, imageProvider) {
                        return CircleAvatar(
                          radius: 4.h,
                          backgroundColor: Colors.white,
                          backgroundImage: imageProvider,
                        );
                      },
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return CircleAvatar(
                            radius: 4.h,
                            backgroundColor: Colors.white,
                            child: Image.asset(
                              fit: BoxFit.cover,
                              Images.deafultUser,
                            ));
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
