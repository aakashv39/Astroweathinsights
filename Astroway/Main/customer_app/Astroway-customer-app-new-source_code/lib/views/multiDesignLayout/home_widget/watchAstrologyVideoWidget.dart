import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/astrologerVideo.dart';
import 'package:AstrowayCustomer/views/blog_screen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AstrologerVideosWidget extends StatelessWidget {
  const AstrologerVideosWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      if (homeController.astrologyVideo.isEmpty) {
        return const SizedBox();
      }

      return Container(
        height: 30.h,
        padding: EdgeInsets.all(1.w),
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Card(
          elevation: 0,
          margin: const EdgeInsets.only(top: 6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Watch ${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}'s Videos",
                        style: Get.theme.primaryTextTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ).tr(),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AstrologerVideoScreen());
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

                // Horizontal video list
                Expanded(
                  child: ListView.builder(
                    itemCount: homeController.astrologyVideo.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      final video = homeController.astrologyVideo[index];

                      return GestureDetector(
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);
                          await homeController.youtubPlay(video.youtubeLink);
                          global.hideLoader();

                          Get.to(() => BlogScreen(
                                link: video.youtubeLink,
                                title: 'Video',
                                controller:
                                    homeController.youtubePlayerController,
                                date: DateFormat("MMM d, yyyy")
                                    .format(DateTime.parse(video.createdAt)),
                                videoTitle: video.videoTitle,
                                longdescription: video.description,
                              ));
                        },
                        child: Container(
                          width: 190,
                          margin: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 0.5)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Thumbnail + YouTube icon
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: CommonCachedNetworkImage(
                                        height: 110,
                                        width: Get.width,
                                        borderRadius: 0,
                                        imageUrl: '${video.coverImage}'),
                                  ),
                                  Positioned(
                                    child: Image.asset(
                                      Images.youtube,
                                      height: 35,
                                      width: 35,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      width: Get.width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3.w, vertical: 5),
                                      color: Colors.black54,
                                      child: Text(
                                        video.videoTitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Get.theme.textTheme.titleMedium!
                                            .copyWith(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ).tr(),
                                    ),
                                  ),
                                ],
                              ),

                              // Video title + date
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Create on",
                                      style: Get.theme.textTheme.titleMedium!
                                          .copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      DateFormat("MMM d, yyyy").format(
                                          DateTime.parse(video.createdAt)),
                                      style: Get.theme.textTheme.titleMedium!
                                          .copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey[700],
                                      ),
                                    ),
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
          ),
        ),
      );
    });
  }
}
