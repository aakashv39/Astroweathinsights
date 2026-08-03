// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'dart:developer';
import 'package:AstrowayCustomer/views/poojaBooking/screen/faqscreen.dart';
import 'package:AstrowayCustomer/views/poojaBooking/controller/poojaController.dart';
import 'package:AstrowayCustomer/views/poojaBooking/screen/recommendbenifit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../model/RecommendedPujaListModel.dart';
import '../utils/global.dart' as global;
import 'poojaBooking/screen/processwidget.dart';
import 'poojaBooking/screen/recpackagedetailscree.dart';

class RecommendedPoojadetailscreen extends StatefulWidget {
  final RecommendedPujaListModel poojaItem;

  const RecommendedPoojadetailscreen({super.key, required this.poojaItem});

  @override
  State<RecommendedPoojadetailscreen> createState() =>
      _PoojadetailscreenState();
}

class _PoojadetailscreenState extends State<RecommendedPoojadetailscreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;
  late TabController _tabController;
  PoojaController poojacontroller = Get.put(PoojaController());
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _tabController = TabController(length: 5, vsync: this);
    log('puja image is ${widget.poojaItem.pujaImages![0]}');
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_currentPage < widget.poojaItem.pujaImages!.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _tabController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(title: Text('Participate').tr()),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      SizedBox(height: 1.h),
                      _buildTopbannerwidget(),
                      SizedBox(height: 1.h),
                      _buildBottomWidget(),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                _buildtabbarwidget(),
                SizedBox(height: 1.h),
                _buildTabBarViewWidget(),
              ],
            ),
          )),
    );
  }

  Expanded _buildTabBarViewWidget() {
    return Expanded(
      child: TabBarView(
        controller: _tabController,
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.poojaItem.pujaSubtitle.toString(),
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: Colors.black,
                        fontSize: 16.sp,
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    '${widget.poojaItem.longDescription}.',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //Benifits tab
          RecommendBeniftsScreen(poojadetail: widget.poojaItem),
          //process tab
          processwidget(poojacontroller: poojacontroller),
          //Packagedetail  tab
          RecPackagedetailscreen(poojadetail: widget.poojaItem),
          //FAQ tab
          FAQScreen(),
        ],
      ),
    );
  }

  Container _buildTopbannerwidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: 100.w,
      height: 20.h,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.poojaItem.pujaImages!.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: global
                  .buildImageUrl("${widget.poojaItem.pujaImages![index]}"),
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                  child: Skeletonizer(
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
              errorWidget: (context, url, error) =>
                  Icon(Icons.broken_image, size: 40),
            ),
            // child: Image.network(
            //   "${widget.poojaItem.pujaImages![index]}",
            //   fit: BoxFit.fill,
            // ),
          );
        },
      ),
    );
  }

  _buildBottomWidget() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: 100.w,
      child: Column(
        children: [
          Text(widget.poojaItem.pujaTitle.toString(),
              style: Get.textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold) //Pooja Name
              ),
          const SizedBox(
            height: 5,
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: Get.theme.primaryColor.withOpacity(0.2),
                child: Icon(
                  Icons.location_pin,
                  size: 19.sp,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  widget.poojaItem.pujaPlace.toString(),
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    fontSize: 16.sp,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          InkWell(
            onTap: () {
              //go to package tab
              log('go to package tab');
              _tabController.animateTo(
                3,
                duration: Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
              );
            },
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.theme.primaryColor),
              width: 90.w,
              child: Center(
                child: Text(
                  "Select Package",
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),
                ).tr(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildtabbarwidget() {
    return SizedBox(
      height: 6.h,
      child: TabBar(
        dividerColor: Colors.transparent,
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Get.theme.primaryColor,
        tabAlignment: TabAlignment.start,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 3.0,
        labelPadding: EdgeInsets.symmetric(horizontal: 3.w),
        indicatorPadding: EdgeInsets.zero,
        tabs: [
          Tab(text: tr("About Pooja")),
          Tab(text: tr("Benifits")),
          Tab(text: tr("Process")),
          Tab(text: tr("Package")),
          Tab(text: tr("FAQ's")),
        ],
      ),
    );
  }
}
