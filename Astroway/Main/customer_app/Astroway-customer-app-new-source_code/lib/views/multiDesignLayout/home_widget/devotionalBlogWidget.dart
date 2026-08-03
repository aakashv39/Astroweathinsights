import 'package:AstrowayCustomer/controllers/astrologyBlogController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/views/astroBlog/astrologyBlogListScreen.dart';
import 'package:AstrowayCustomer/views/astroBlog/astrologyDetailScreen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class DevotionalBlogWidget extends StatelessWidget {
  const DevotionalBlogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      if (homeController.blogList.isEmpty) {
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
        height: 28.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Devotional Blogs',
                    style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ).tr(),
                  GestureDetector(
                    onTap: () async {
                      final blogController = Get.find<BlogController>();
                      global.showOnlyLoaderDialog(context);
                      blogController.astrologyBlogs = [];
                      blogController.isAllDataLoaded = false;
                      blogController.update();
                      await blogController.getAstrologyBlog("", false);
                      global.hideLoader();
                      Get.to(() => const AstrologyBlogScreen());
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

            const SizedBox(height: 10),

            // Blog list
            Expanded(
              child: ListView.builder(
                itemCount: homeController.blogList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(top: 0, left: 0, bottom: 5),
                itemBuilder: (context, index) {
                  final blog = homeController.blogList[index];

                  return GestureDetector(
                    onTap: () async {
                      global.showOnlyLoaderDialog(context);
                      await homeController.incrementBlogViewer(blog.id);
                      homeController.homeBlogVideo(blog.blogImage);
                      global.hideLoader();

                      Get.to(
                        () => AstrologyBlogDetailScreen(
                          image: blog.blogImage,
                          title: blog.title,
                          description: blog.description ?? "",
                          extension: blog.extension ?? "",
                          controller: homeController.homeVideoPlayerController,
                        ),
                      );
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (blog.extension == 'mp4' || blog.extension == 'gif')
                              ? Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: CommonCachedNetworkImage(
                                        height: 110,
                                        width: Get.width,
                                        borderRadius: 0,
                                        imageUrl: '${blog.previewImage}',
                                      ),
                                    ),
                                    const Icon(
                                      Icons.play_arrow,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                      child: CommonCachedNetworkImage(
                                        borderRadius: 0,
                                        height: 110,
                                        width: Get.width,
                                        imageUrl: '${blog.blogImage}',
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 3.w),
                                      color: Colors.black54,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                blog.author,
                                                style: Get.theme.textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ).tr(),
                                              Text(
                                                DateFormat("MMM d, yyyy")
                                                    .format(
                                                  DateTime.parse(
                                                      blog.createdAt),
                                                ),
                                                style: Get.theme.textTheme
                                                    .titleMedium!
                                                    .copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.visibility,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                "${blog.viewer}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: Text(
                                    blog.title,
                                    textAlign: TextAlign.start,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Get.theme.textTheme.bodyMedium!
                                        .copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ).tr(),
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
    });
  }
}
