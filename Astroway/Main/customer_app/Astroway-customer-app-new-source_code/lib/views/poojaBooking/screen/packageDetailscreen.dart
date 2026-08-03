// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/poojaBooking/model/poojalistmodel.dart';
import 'package:AstrowayCustomer/views/poojaBooking/screen/addpoojadeveryaddress.dart';
import 'package:AstrowayCustomer/widget/horoscopeRotateWidget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Packagedetailscreen extends StatefulWidget {
  final PoojaList poojadetail;
  const Packagedetailscreen({
    super.key,
    required this.poojadetail,
  });

  @override
  State<Packagedetailscreen> createState() => _PackagedetailscreenState();
}

class _PackagedetailscreenState extends State<Packagedetailscreen> {
  CarouselSliderController carouselController = CarouselSliderController();
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffbgcolor,
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
                    items: widget.poojadetail.packages!
                        .asMap()
                        .entries
                        .map((entry) {
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
                          activeDotColor: Get.theme.primaryColor,
                          dotColor: const Color(0xFF969DFF),
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
            () => AddPoojaDeliveryAddress(
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
            border: Border.all(color: Colors.orange.shade100),
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFE4C9),
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
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => PoojaDialog(
                      title: widget.poojadetail.packages![index].title ?? '',
                      descriptions:
                          widget.poojadetail.packages![index].description ?? [],
                    ),
                  );
                },
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Read More',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 8, 0, 255),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ).tr(),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_downward_outlined,
                        color: const Color.fromARGB(255, 255, 17, 0),
                        size: 12,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            global.getSystemFlagValueForLogin(
                        global.systemFlagNameList.walletType) ==
                    "Wallet"
                ? Text(
                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.poojadetail.packages![index].packagePrice}',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Get.theme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.poojadetail.packages![index].packagePrice.toString().split(".").first}',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Get.theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      SizedBox(
                        width: 1.w,
                      ),
                      Image.network(
                        global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.coinIcon),
                        height: 2.2.h,
                      ),
                    ],
                  ),
            SizedBox(height: 3.w),
            _buildbooknowwidget(index)
          ],
        ),
      ),
    );
  }
}

class PoojaDialog extends StatelessWidget {
  final String title;
  final List<dynamic> descriptions;

  const PoojaDialog({
    Key? key,
    required this.title,
    required this.descriptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Container(
          color: Colors.transparent,
          child: GestureDetector(
            child: DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.5,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Container(
                    color: Get.theme.primaryColor.withOpacity(0.1),
                    child: Stack(
                      children: [
                        Positioned(
                            top: -80,
                            right: -90,
                            child: const HoroscopeRotateAnimation(size: 250)),
                        Column(
                          children: [
                            // Drag Handle
                            Container(
                              margin: EdgeInsets.only(top: 12),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            SizedBox(height: 15),
                            // Header Section
                            Container(
                              padding: EdgeInsets.fromLTRB(20, 16, 12, 16),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Get.theme.primaryColor,
                                          Get.theme.primaryColor
                                              .withOpacity(0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Get.theme.primaryColor
                                              .withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      title,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Get.theme.primaryColor,
                                        letterSpacing: 0.3,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: Icon(
                                        Icons.close_rounded,
                                        color: Colors.grey.shade700,
                                      ),
                                      splashRadius: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Content Section
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                padding: EdgeInsets.all(20),
                                itemCount: descriptions.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 16),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Get.theme.primaryColor
                                            .withOpacity(0.1),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 10,
                                          offset: Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 2),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Get.theme.primaryColor
                                                    .withOpacity(0.2),
                                                Get.theme.primaryColor
                                                    .withOpacity(0.1),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.circleCheck,
                                            size: 16,
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            '${descriptions[index]}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey.shade800,
                                              height: 1.5,
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
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
