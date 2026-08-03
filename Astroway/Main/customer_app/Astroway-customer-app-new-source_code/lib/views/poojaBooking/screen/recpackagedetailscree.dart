import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../model/RecommendedPujaListModel.dart';
import 'recaddpoojadeliveryaddress.dart';

class RecPackagedetailscreen extends StatefulWidget {
  final RecommendedPujaListModel poojadetail;
  const RecPackagedetailscreen({
    super.key,
    required this.poojadetail,
  });

  @override
  State<RecPackagedetailscreen> createState() => _PackagedetailscreenState();
}

class _PackagedetailscreenState extends State<RecPackagedetailscreen> {
  CarouselSliderController carouselController = CarouselSliderController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 4.h),
          Stack(
            children: [
              CarouselSlider(
                carouselController: carouselController,
                options: CarouselOptions(
                  height: 45.h,
                  autoPlay: false,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.7,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items:
                    widget.poojadetail.packages!.asMap().entries.map((entry) {
                  int index = entry.key;

                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          width: MediaQuery.of(context).size.width,
                          child: _buildPackgeWidget(index));
                    },
                  );
                }).toList(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 4.h,
                child: Container(
                  alignment: Alignment.center,
                  width: 100.w,
                  child: AnimatedSmoothIndicator(
                    activeIndex: _currentIndex,
                    count: widget.poojadetail.packages!.length,
                    effect: WormEffect(
                      dotHeight: 10.0,
                      dotWidth: 10.0,
                      activeDotColor: Colors.blue,
                      dotColor: Colors.grey,
                    ),
                    onDotClicked: (index) {
                      carouselController.animateToPage(index);
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  Widget _buildbooknowwidget(int position) {
    return Container(
      width: 100.w,
      height: 6.h,
      child: ElevatedButton(
        onPressed: () {
          Get.to(
            () => RecAddPoojaDeliveryAddress(
              selectedpackage: widget.poojadetail.packages![position],
              poojadetail: widget.poojadetail,
              index: position,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Get.theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          'Book Now',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ).tr(),
      ),
    );
  }

  Column _buildPackagedetailswidget(int index) {
    return Column(
      children: List.generate(1, (descriptionIndex) {
        return Column(
          children: [
            Container(
                padding: EdgeInsets.all(2.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      FontAwesomeIcons.handPointRight,
                      size: 18.sp,
                      color: Colors.black,
                    ),
                    SizedBox(width: 2.w),
                    Flexible(
                      child: Text(
                        '${widget.poojadetail.packages![index].description![descriptionIndex]}',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                  ],
                )),
            SizedBox(height: 1.w),
          ],
        );
      }),
    );
  }

  Widget _buildPackgeWidget(int index) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(3.w),
        width: 80.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color(0xfffef0e2),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 1.w),
            Text(
              '${widget.poojadetail.packages![index].title}',
              style: TextStyle(
                fontSize: 19.sp,
                fontWeight: FontWeight.w500,
                color: Get.theme.primaryColor,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 1.w),
            Text(
              'Package for ${widget.poojadetail.packages![index].person} Person',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 1.w),
            _buildPackagedetailswidget(index),
            Align(
                alignment: Alignment.topRight,
                child: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              iconPadding: EdgeInsets.only(right: 8),
                              icon: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                    )),
                              ),
                              contentPadding: EdgeInsets.all(8),
                              title: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  '${widget.poojadetail.packages![index].title}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Get.theme.primaryColor,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                    widget
                                        .poojadetail
                                        .packages![index]
                                        .description!
                                        .length, (descriptionIndex) {
                                  return Column(
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(2.w),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.handPointRight,
                                                size: 18.sp,
                                                color: Colors.black,
                                              ),
                                              SizedBox(width: 2.w),
                                              Flexible(
                                                child: Text(
                                                  '${widget.poojadetail.packages![index].description![descriptionIndex]}',
                                                  style: TextStyle(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                      SizedBox(height: 1.w),
                                    ],
                                  );
                                }),
                              ),
                            );
                          });
                    },
                    child: Text(
                      'Read More',
                      style:
                          TextStyle(color: Colors.blue.shade300, fontSize: 12),
                    ).tr())),
            Text(
              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.poojadetail.packages![index].packagePrice}',
              style: TextStyle(
                fontSize: 18.sp,
                color: Get.theme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            SizedBox(height: 3.w),
            _buildbooknowwidget(index)
          ],
        ),
      ),
    );
  }
}
