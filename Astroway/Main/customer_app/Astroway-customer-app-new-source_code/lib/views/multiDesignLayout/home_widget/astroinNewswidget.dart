import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/views/astrologerNews.dart';
import 'package:AstrowayCustomer/views/blog_screen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AstroInNewsWidget extends StatelessWidget {
  const AstroInNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      if (homeController.astroNews.isEmpty) {
        return const SizedBox();
      }

      return Container(
        padding: EdgeInsets.all(1.w),
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        height: 31.h,
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)} in News',
                        style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ).tr(),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => AstrologerNewsScreen());
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

                const SizedBox(height: 5),

                // News list
                Expanded(
                  child: ListView.builder(
                    itemCount: homeController.astroNews.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                    itemBuilder: (context, index) {
                      final news = homeController.astroNews[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => BlogScreen(
                                link: news.link,
                                videoTitle: news.description,
                                banner: news.bannerImage,
                                date: news.newsDate.toString(),
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
                              // Banner image
                              Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5),
                                    ),
                                    child: CommonCachedNetworkImage(
                                      height: 110,
                                      width: Get.width,
                                      borderRadius: 0,
                                      imageUrl: '${news.bannerImage}',
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3.w, vertical: 5),
                                    color: Colors.black54,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          news.channel,
                                          style: Get
                                              .theme.textTheme.titleMedium!
                                              .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ).tr(),
                                        Text(
                                          DateFormat("MMM d, yyyy").format(
                                            DateTime.parse(
                                                news.newsDate.toString()),
                                          ),
                                          style: Get
                                              .theme.textTheme.titleMedium!
                                              .copyWith(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Content
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  news.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Get.theme.textTheme.titleMedium!.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ).tr(),
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
