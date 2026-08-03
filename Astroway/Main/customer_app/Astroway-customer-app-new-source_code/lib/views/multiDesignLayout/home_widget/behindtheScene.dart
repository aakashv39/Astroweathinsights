import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/widget/videoPlayerWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BehindTheSceneWidget extends StatelessWidget {
  const BehindTheSceneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (homeController) {
      return Container(
        padding: EdgeInsets.all(1.w),
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),

              // Header
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Behind the scene',
                  style: Get.theme.primaryTextTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ).tr(),
              ),

              const SizedBox(height: 10),

              // Video Player
              Container(
                height: 22.h,
                width: Get.width,
                padding: EdgeInsets.all(2.w),
                child: homeController.videoPlayerController != null &&
                        homeController
                            .videoPlayerController!.value.isInitialized
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AspectRatio(
                          aspectRatio: homeController
                              .videoPlayerController!.value.aspectRatio,
                          child: VideoPlayerWidget(
                            controller: homeController.videoPlayerController!,
                          ),
                        ),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
