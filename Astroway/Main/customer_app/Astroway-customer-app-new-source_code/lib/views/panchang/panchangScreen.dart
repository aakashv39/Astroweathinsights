// ignore_for_file: deprecated_member_use
import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/panchang/widgets/mooncard_widget.dart';
import 'package:AstrowayCustomer/views/panchang/widgets/suncard_widget.dart';
import 'package:AstrowayCustomer/views/panchang/widgets/titleCardwidget.dart';
import 'package:AstrowayCustomer/widget/horoscopeRotateWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controllers/advancedPanchangController.dart';
import '../../utils/images.dart';

// ignore: must_be_immutable
class PanchangScreen extends StatefulWidget {
  PanchangScreen({Key? key}) : super(key: key);

  @override
  State<PanchangScreen> createState() => _PanchangScreenState();
}

class _PanchangScreenState extends State<PanchangScreen> {
  final reviewController = Get.find<ReviewController>();
  final panchangController = Get.find<PanchangController>();
  final kundliController = Get.find<KundliController>();
  final splashController = Get.find<SplashController>();

  @override
  void initState() {
    super.initState();
    resetpanchnagdatae();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      panchangController.vedicPanchangModel = null;
      kundliController.update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: AppBar(
              backgroundColor: scaffbgcolor,
              title: const Text('Panchang'),
              flexibleSpace: Stack(
                children: [
                  Container(color: scaffbgcolor),
                  Positioned(
                    top: -25,
                    right: -15,
                    child: Image.asset(
                      Images.planetImage, // replace with your image
                      height: 100,
                      width: 100,
                    ),
                  ),
                ],
              )),
        ),
        body: GetBuilder<PanchangController>(builder: (panchangController) {
          return panchangController.vedicPanchangModel != null &&
                  panchangController.vedicPanchangModel != ""
              ? Container(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(1.w),
                            margin: EdgeInsets.all(2.w),
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Color(0xff06402B), width: 0.5),
                            ),
                            width: 100.w,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 1.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        await panchangController
                                            .nextDate(false);
                                      },
                                      child: Icon(
                                        Icons.keyboard_double_arrow_left,
                                        color: Color(0xff06402B),
                                        size: 24.sp,
                                      ),
                                    ),
                                    Text(
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.date}",
                                      style: Get.theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xff06402B),
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await panchangController.nextDate(true);
                                      },
                                      child: Icon(
                                          Icons.keyboard_double_arrow_right,
                                          color: Color(0xff06402B),
                                          size: 24.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 1.h),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.all(1.w),
                          margin: EdgeInsets.all(2.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SunCardWidget(
                                title: tr("Sun Rise"),
                                time:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.sunRise}",
                                icon: CupertinoIcons
                                    .sunrise, // requires lucide_flutter
                                gradientColors: [Colors.orange, Colors.yellow],
                              ),
                              SunCardWidget(
                                title: tr("Sun Set"),
                                time:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.sunSet}",
                                icon: CupertinoIcons.sunset,
                                gradientColors: [
                                  Colors.redAccent,
                                  Colors.orange
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 2.w),
                          child: Column(
                            children: [
                              // tithi
                              TitleCardWidget(
                                label: "${tr("Tithi")}",
                                name:
                                    " ${panchangController.vedicPanchangModel?.recordList?.response?.tithi?.name}",
                                value:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.tithi?.special}",
                                startTime:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.tithi?.start}",
                                endTime:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.tithi?.end}",
                                color: Colors.deepPurpleAccent,
                              ),

                              //nakshatra
                              TitleCardWidget(
                                label: "${tr("Nakshatra")}",
                                name:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.nakshatra?.name}",
                                value:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.nakshatra?.special}",
                                startTime:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.nakshatra?.start}",
                                endTime:
                                    "${panchangController.vedicPanchangModel?.recordList?.response?.nakshatra?.end}",
                                color: Colors.redAccent,
                              ),
                              //karana
                              TitleCardWidget(
                                  label: "${tr("Karana")}",
                                  name:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.karana?.name}",
                                  value:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.karana?.special}",
                                  startTime:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.karana?.start}",
                                  endTime:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.karana?.end}",
                                  color: Colors.purpleAccent),

                              ///Yoga
                              TitleCardWidget(
                                  label: "${tr("Yoga")}",
                                  name:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.yoga?.name}",
                                  value:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.yoga?.special}",
                                  startTime:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.yoga?.start}",
                                  endTime:
                                      "${panchangController.vedicPanchangModel?.recordList?.response?.yoga?.end}",
                                  color: Colors.blueAccent),

                              // Rasi
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(1.w),
                                margin: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                        top: -35,
                                        right: -30,
                                        child: const HoroscopeRotateAnimation(
                                            size: 120)),
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${tr("Rasi")}",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontSize: 20.sp),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            panchangController
                                                    .vedicPanchangModel
                                                    ?.recordList
                                                    ?.response
                                                    ?.rasi
                                                    ?.name ??
                                                "-",
                                            style: Get.textTheme.bodyLarge
                                                ?.copyWith(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        //additional Information
                        Container(
                          padding: EdgeInsets.all(1.w),
                          margin: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 8),
                              Padding(
                                padding: EdgeInsets.only(left: 3.w),
                                child: Text("Additional Info",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 18.sp,
                                    )).tr(),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MoonCardWidget(
                                    title: tr("Moon Rise"),
                                    time:
                                        "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.moonRise}",
                                    icon: CupertinoIcons
                                        .moon_stars, // requires lucide_flutter
                                    colors: const Color(0xFF010AFF),
                                  ),
                                  MoonCardWidget(
                                    title: tr("Moon Set"),
                                    time:
                                        "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.moonSet}",
                                    icon: CupertinoIcons.moon_zzz_fill,
                                    colors: Colors.black,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  MoonCardWidget(
                                    title: tr("Next Full Moon"),
                                    time:
                                        "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.nextFullMoon}",
                                    icon: CupertinoIcons
                                        .moon_circle, // requires lucide_flutter
                                    colors: Colors.pinkAccent,
                                  ),
                                  MoonCardWidget(
                                      title: tr("Next Moon"),
                                      time:
                                          "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.nextNewMoon}",
                                      icon: CupertinoIcons.cloud_moon_bolt,
                                      colors: Color(0xFFFC0606)),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.all(1.w),
                                margin: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            child: Text(
                                              "Amanta Month",
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                color: blackColor,
                                                fontSize: 16.sp,
                                              ),
                                            ).tr(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            child: Text(
                                              "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.masa?.amantaName}",
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                                color: blackColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    ///Paksha
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            child: Text(
                                              "Paksha",
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                color: blackColor,
                                                fontSize: 16.sp,
                                              ),
                                            ).tr(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            child: Text(
                                              "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.masa?.paksha}",
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w400,
                                                color: blackColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    ///Purnimanta
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            child: Text(
                                              "Purnimanta",
                                              style: TextStyle(
                                                fontFamily: 'Open Sans',
                                                fontWeight: FontWeight.w600,
                                                color: blackColor,
                                                fontSize: 16.sp,
                                              ),
                                            ).tr(),
                                          ),
                                        ),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 1.h, horizontal: 2.w),
                                            child: Text(
                                              "${panchangController.vedicPanchangModel?.recordList?.response?.advancedDetails?.masa?.purnimantaName}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                color: blackColor,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 2.h,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(
                        height: 5,
                      ),
                      Text('Loading...')
                    ],
                  ),
                );
        }),
      ),
    );
  }

  void resetpanchnagdatae() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      panchangController.commondate = 0;
      panchangController.update();
    });
  }
}
