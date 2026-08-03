import 'dart:developer';

import 'package:AstrowayCustomer/controllers/astrologerCategoryController.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/callScreen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

class AstrologyCategoriesWidget extends StatelessWidget {
  final BottomNavigationController bottomNavigationController;
  final ChatController chatController;

  const AstrologyCategoriesWidget({
    Key? key,
    required this.bottomNavigationController,
    required this.chatController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AstrologerCategoryController>(
      builder: (astrologyCat) {
        if (astrologyCat.categoryList.isEmpty) {
          return const SizedBox();
        }

        return Container(
          margin: EdgeInsets.only(top: 10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 13, vertical: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Categories',
                      style: Get.theme.primaryTextTheme.titleMedium!
                          .copyWith(fontWeight: FontWeight.w500),
                    ).tr(),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 15.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: astrologyCat.categoryList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final category = astrologyCat.categoryList[index];
                      log('cat image ${category.image}');

                      return InkWell(
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);
                          bottomNavigationController.astrologerList.clear();
                          bottomNavigationController.isAllDataLoaded = false;
                          bottomNavigationController.update();
                          chatController.isSelected = index;
                          chatController.update();
                          await bottomNavigationController.astroCat(
                            id: category.id!,
                            isLazyLoading: false,
                          );
                          global.hideLoader();
                          chatController.isSelected = index + 1;
                          chatController.update();
                          Get.to(() => CallScreen(flag: 1));
                        },
                        child: Container(
                          width: 22.w,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                  width: 21.w,
                                  height: 21.w,
                                  padding: EdgeInsets.all(4.w),
                                  margin: const EdgeInsets.only(
                                      top: 4, bottom: 1, right: 5),
                                  decoration: BoxDecoration(
                                      color:
                                          astrologyCat.categoryList.length <= 5
                                              ? categoriesColors[index]
                                              : getCategoryColor(),
                                      border: Border.all(
                                          width: 1,
                                          color: astrologyCat
                                                      .categoryList.length <=
                                                  5
                                              ? catBorderColors[index]
                                              : getCategoryColor()),
                                      shape: BoxShape.circle),
                                  child: CommonCachedNetworkImage(
                                      height: 35,
                                      width: 35,
                                      borderRadius: 100.w,
                                      imageUrl: global
                                          .buildImageUrl("${category.image}"))),

                              // Category Name
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 3),
                                child: Center(
                                  child: Text(
                                    category.name,
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      fontSize: 11,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
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
        );
      },
    );
  }
}
