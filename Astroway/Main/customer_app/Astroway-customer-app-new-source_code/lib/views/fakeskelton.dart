import 'package:AstrowayCustomer/utils/images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';

class fakeSkeltonWidget extends StatelessWidget {
  const fakeSkeltonWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 6,
        itemBuilder: (context, index) => SizedBox(
          child: Card(
            elevation: 0.1.w,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50.w,
                            child: Text('fake data'),
                          ),
                          Container(
                            width: 30.w,
                            child: Text(
                              'fake data',
                              style: Get.theme.textTheme.bodyMedium!.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ).tr(),
                          ),
                          Container(
                            width: 30.w,
                            child: Text(
                              'fake data',
                              style: Get.textTheme.bodyLarge!.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ).tr(),
                          ),
                          Container(
                            width: 30.w,
                            child: Text(
                              'fake data',
                              style: Get.textTheme.bodyLarge!.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ).tr(),
                          ),
                          Container(
                            width: 30.w,
                            child: Text(
                              'fake data',
                              style: Get.textTheme.bodyLarge!.copyWith(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ).tr(),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              margin: const EdgeInsets.only(top: 6),
                              padding: EdgeInsets.symmetric(horizontal: 2.w),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: [
                                  Image.asset(
                                    Images.whatsapp,
                                    height: 30,
                                    width: 30,
                                  ),
                                  Text(
                                    "Share with your friends",
                                    style: Get.textTheme.bodyMedium!.copyWith(
                                      fontSize: 16.sp,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ).tr()
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(children: [
                        Text(
                          'fake data',
                          style: Get.textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ).tr(),
                        SizedBox(height: 12),
                        Container(
                          height: 65,
                          width: 65,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border:
                                  Border.all(color: Get.theme.primaryColor)),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: CachedNetworkImage(
                              imageUrl: 'fake data',
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 65,
                                width: 65,
                                decoration: BoxDecoration(
                                    image:
                                        DecorationImage(image: imageProvider)),
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image.asset(
                                Images.deafultUser,
                                fit: BoxFit.cover,
                                height: 50,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                      ])
                    ],
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
