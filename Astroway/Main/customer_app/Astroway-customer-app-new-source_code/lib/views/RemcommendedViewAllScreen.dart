import 'dart:developer';
import 'package:AstrowayCustomer/model/rec_model.dart';
import 'package:AstrowayCustomer/utils/CornerBanner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../utils/images.dart';
import 'astromall/productDetailScreen.dart';

class RemcommendedViewAllScreen extends StatefulWidget {
  final List<RecModel>? recommendedlist;
  const RemcommendedViewAllScreen({super.key, required this.recommendedlist});

  @override
  State<RemcommendedViewAllScreen> createState() =>
      _RemcommendedViewAllScreenState();
}

class _RemcommendedViewAllScreenState extends State<RemcommendedViewAllScreen> {
  @override
  void initState() {
    super.initState();
    log('recommendlist length is ${widget.recommendedlist!.length}');
    log('imge product is ${"$webBaseUrl/${widget.recommendedlist![0].productImage}"}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Recommended Products').tr()),
      body: widget.recommendedlist != null || widget.recommendedlist!.isNotEmpty
          ? Column(
              children: [
                SizedBox(height: 2.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.9,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: widget.recommendedlist!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => ProductDetailScreen(
                                      index: 0,
                                      productID: widget
                                          .recommendedlist![index].productId!,
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    onError: (exception, stackTrace) =>
                                        Image.asset(
                                      Images.deafultUser,
                                    ),
                                    image: NetworkImage(
                                      global.buildImageUrl('${widget.recommendedlist![index].productImage}'),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 1,
                              top: 1,
                              child: SizedBox(
                                width: 10.w,
                                height: 2.h,
                                child: CornerBanner(
                                  bannerPosition: CornerBannerPosition.topLeft,
                                  bannerColor: Colors.red,
                                  child: Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.recommendedlist![index].amount}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 5.h,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  color: Colors.black26,
                                ),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        '${widget.recommendedlist![index].productName!.length > 14 ? widget.recommendedlist![index].productName!.substring(0, 14) + '..' : widget.recommendedlist![index].productName}',
                                        style: Get.theme.textTheme.bodySmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        'by [${widget.recommendedlist![index].astrologerName!.length > 14 ? widget.recommendedlist![index].astrologerName!.substring(0, 14) + '..' : widget.recommendedlist![index].astrologerName}]',
                                        style: Get.theme.textTheme.bodySmall!
                                            .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : SizedBox(
              child: Text('No Recommended Product Found').tr(),
            ),
    );
  }
}
