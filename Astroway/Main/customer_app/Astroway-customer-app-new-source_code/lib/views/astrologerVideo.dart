import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/blog_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

class AstrologerVideoScreen extends StatelessWidget {
  const AstrologerVideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Astrology Video',
          ).tr(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
        ),
        body: GetBuilder<HomeController>(builder: (homeController) {
          return RefreshIndicator(
            onRefresh: () async {
              await homeController.getAstrologyVideos();
            },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  itemCount: homeController.astrologyVideo.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return GestureDetector(
                      onTap: () async {
                        global.showOnlyLoaderDialog(context);
                        await homeController.youtubPlay(
                            homeController.astrologyVideo[index].youtubeLink);
                        global.hideLoader();
                        Get.to(() => BlogScreen(
                              title: 'Video',
                              link: homeController
                                  .astrologyVideo[index].youtubeLink,
                              controller:
                                  homeController.youtubePlayerController,
                              date:
                                  '${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}',
                              videoTitle: homeController
                                  .astrologyVideo[index].videoTitle,
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 3),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    child: homeController.astrologyVideo[index]
                                                .coverImage ==
                                            ''
                                        ? Image.asset(
                                            Images.blog,
                                            height: 180,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            fit: BoxFit.fill,
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: global.buildImageUrl(
                                                '${homeController.astrologyVideo[index].coverImage}'),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Image.network(
                                              "${homeController.astrologyVideo[index].coverImage}",
                                              height: 180,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                            placeholder: (context, url) =>
                                                const Center(
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Image.asset(
                                              Images.blog,
                                              height: 180,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    child: Image.asset(
                                      Images.youtube,
                                      height: 60,
                                      width: 60,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      homeController
                                          .astrologyVideo[index].videoTitle,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                      textAlign: TextAlign.start,
                                    ).tr(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "${DateFormat("MMM d,yyyy").format(DateTime.parse(homeController.astrologyVideo[index].createdAt))}",
                                          style: Theme.of(context)
                                              .primaryTextTheme
                                              .titleSmall!
                                              .copyWith(color: Colors.grey),
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
                    );
                  }),
            ),
          );
        }),
      ),
    );
  }
}
