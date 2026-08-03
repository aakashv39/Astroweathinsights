// ignore_for_file: must_be_immutable

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/global.dart' as global;
import '../utils/images.dart';

class ShowReviewWidget extends StatelessWidget {
  int index;
  final String astologername;
  String astroImage;
  ShowReviewWidget({
    Key? key,
    required this.astologername,
    required this.index,
    required this.astroImage,
  }) : super(key: key);
  ReviewController reviewController = Get.find<ReviewController>();
  BottomNavigationController bottomController =
      Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReviewController>(
      builder: (reviewController) {
        return reviewController.reviewList.isEmpty
            ? const SizedBox()
            : Container(
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.symmetric(horizontal: 1.8.w),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 15.w,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 24,
                                child: reviewController
                                            .reviewList[index].profile ==
                                        ""
                                    ? CircleAvatar(
                                        backgroundColor: Colors.white,
                                        backgroundImage:
                                            AssetImage(Images.deafultUser),
                                      )
                                    : CachedNetworkImage(
                                        color: Colors.white,
                                        imageUrl: global.buildImageUrl(
                                            '${reviewController.reviewList[index].profile}'),
                                        imageBuilder: (context, imageProvider) {
                                          return CircleAvatar(
                                            backgroundColor: Colors.white,
                                            backgroundImage: imageProvider,
                                          );
                                        },
                                        placeholder: (context, url) =>
                                            const Center(
                                                child:
                                                    CircularProgressIndicator()),
                                        errorWidget: (context, url, error) {
                                          return CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Image.asset(
                                                Images.deafultUser,
                                                fit: BoxFit.cover,
                                                height: 50,
                                              ));
                                        },
                                      ),
                              ),
                            ),
                            SizedBox(width: 2),
                            Container(
                              width: 58.w,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3.w, vertical: 0.5.h),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      reviewController
                                                  .reviewList[index].username !=
                                              ''
                                          ? reviewController
                                              .reviewList[index].username
                                              .replaceAll(' ', '')
                                          : 'Unknown',
                                      style: TextStyle(
                                        fontSize: 17.sp,
                                        fontFamily: 'Poppins-Regular',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                      )).tr(),
                                  SizedBox(
                                    width: 1,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RatingBar(
                                        initialRating: reviewController
                                            .reviewList[index].rating,
                                        itemCount: 5,
                                        allowHalfRating: true,
                                        itemSize: 15,
                                        ignoreGestures: true,
                                        ratingWidget: RatingWidget(
                                          full: const Icon(Icons.grade,
                                              color: Colors.yellow),
                                          half: const Icon(Icons.star_half,
                                              color: Colors.yellow),
                                          empty: const Icon(Icons.grade,
                                              color: Colors.grey),
                                        ),
                                        onRatingUpdate: (rating) {},
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  //erorr here maybe
                                  Container(
                                    width: 60.w,
                                    constraints: BoxConstraints(minHeight: 4.h),
                                    padding:
                                        EdgeInsets.only(left: 0, right: 2.w),
                                    color: Colors.white10,
                                    child: Text(
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        "${reviewController.reviewList[index].review}",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontFamily: 'Poppins-Regular',
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black,
                                        )).tr(),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 2.w,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     Container(
                        //       width: 10.w,
                        //       child: PopupMenuButton(
                        //           icon: Icon(
                        //             Icons.more_vert,
                        //             color: Colors.grey,
                        //           ),
                        //           onSelected: (value) async {
                        //             bool isLogin = await global.isLogin();
                        //             if (isLogin) {
                        //               if (value == 'block') {
                        //                 global.showOnlyLoaderDialog(context);
                        //                 reviewController.blockAstrologerReview(
                        //                     reviewController
                        //                         .reviewList[index].id!,
                        //                     1,
                        //                     null);
                        //                 global.hideLoader();
                        //               } else {
                        //                 global.showOnlyLoaderDialog(context);
                        //                 reviewController.blockAstrologerReview(
                        //                     reviewController
                        //                         .reviewList[index].id!,
                        //                     null,
                        //                     1);
                        //                 global.hideLoader();
                        //               }
                        //             }
                        //           },
                        //           itemBuilder: (context) => [
                        //                 PopupMenuItem(
                        //                   child: Text('Report review').tr(),
                        //                   value: 'report',
                        //                 ),
                        //                 PopupMenuItem(
                        //                     child: Text(
                        //                       'Block review',
                        //                       style: Get.textTheme.titleMedium!
                        //                           .copyWith(
                        //                         color: Colors.red,
                        //                       ),
                        //                     ).tr(),
                        //                     value: 'block'),
                        //               ]),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                    SizedBox(height: 1.w),
                    reviewController.reviewList[index].reply == ""
                        ? const SizedBox()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 10.w),
                            width: 60.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundImage:
                                          NetworkImage("$astroImage"),
                                    ),
                                    SizedBox(width: 1.w),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.grey.shade200,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              astologername.replaceAll(' ', ""),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontFamily: 'Poppins-Regular',
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black87,
                                              )).tr(),
                                          Container(
                                            width: 40.w,
                                            constraints:
                                                BoxConstraints(minHeight: 4.h),
                                            padding: EdgeInsets.only(
                                                left: 0, right: 2.w),
                                            child: Text(
                                                // 'dsfsd sd fs df sdf sd f sd f s df sd f sd fs f sd fs d fs d fsd ',
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                "${reviewController.reviewList[index].reply}",
                                                style: Get
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                  fontSize: 14.sp,
                                                  fontFamily: 'Poppins-Regular',
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black,
                                                )).tr(),
                                          )
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
              );
      },
    );
  }
}
