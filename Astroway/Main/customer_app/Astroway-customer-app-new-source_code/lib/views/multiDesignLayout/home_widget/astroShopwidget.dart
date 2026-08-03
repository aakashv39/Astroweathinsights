import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/views/astromall/astroProductScreen.dart';
import 'package:AstrowayCustomer/views/astromall/astromallScreen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

class AstroShopWidget extends StatelessWidget {
  const AstroShopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AstromallController>(
      builder: (astromallController) {
        if (astromallController.astroCategory.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          height: 20.h,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Shop Now',
                        style: Get.theme.primaryTextTheme.titleMedium!
                            .copyWith(fontWeight: FontWeight.w500),
                      ).tr(),
                      GestureDetector(
                        onTap: () async {
                          astromallController.astroCategory.clear();
                          astromallController.isAllDataLoaded = false;
                          astromallController.update();
                          global.showOnlyLoaderDialog(context);
                          await astromallController.getAstromallCategory(false);
                          global.hideLoader();
                          Get.to(() => AstromallScreen());
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

                // Horizontal List of Categories
                Expanded(
                  child: ListView.builder(
                    itemCount: astromallController.astroCategory.length,
                    scrollDirection: Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    itemBuilder: (context, index) {
                      final category = astromallController.astroCategory[index];

                      return GestureDetector(
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);
                          astromallController.astroProduct.clear();
                          astromallController.isAllDataLoadedForProduct = false;
                          astromallController.productCatId = category.id;
                          astromallController.update();
                          await astromallController.getAstromallProduct(
                              category.id, false);
                          global.hideLoader();
                          Get.to(() => AstroProductScreen(
                                appbarTitle: category.name,
                                productCategoryId: category.id,
                                sliderImage: "${category.categoryImage}",
                              ));
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CommonCachedNetworkImage(
                                  width: 27.w,
                                  height: 32.w,
                                  imageUrl: "${category.categoryImage}"),
                              Container(
                                height: 20,
                                width: 27.w,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(top: 2),
                                decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(2.w),
                                        bottomRight: Radius.circular(2.w))),
                                child: Get.locale!.languageCode == 'en'
                                    ? Text(
                                        category.name,
                                        style:
                                            Get.textTheme.bodyMedium!.copyWith(
                                          fontSize: 11,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      )
                                    : Center(
                                        child: global.buildTranslatedText(
                                          category.name,
                                          Get.textTheme.bodyMedium!.copyWith(
                                            fontSize: 11,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                              )
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
