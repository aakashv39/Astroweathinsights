// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:convert';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/dailyHoroscopeController.dart';
import 'package:AstrowayCustomer/controllers/liveController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/daily_horoscope/widgets/linear_progressCard.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:AstrowayCustomer/widget/horoscopeRotateWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:scroll_screenshot/scroll_screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../../widget/contactAstrologerBottomButton.dart';

class DailyHoroscopeScreen extends StatefulWidget {
  DailyHoroscopeScreen({Key? key}) : super(key: key);

  @override
  State<DailyHoroscopeScreen> createState() => _DailyHoroscopeScreenState();
}

class _DailyHoroscopeScreenState extends State<DailyHoroscopeScreen> {
  final reviewController = Get.find<ReviewController>();
  final dailyHoroscopeController = Get.find<DailyHoroscopeController>();
  final splashController = Get.find<SplashController>();
  final bottomController = Get.find<BottomNavigationController>();
  final liveController = Get.find<LiveController>();

  int selectHoroscope = 1;
  @override
  void initState() {
    super.initState();
  }

  final GlobalKey globalKey = GlobalKey();
  Future<void> _captureAndSaveScreenshot() async {
    String? base64String1 = await ScrollScreenshot.captureAndSaveScreenshot(
      globalKey,
    );
    if (base64String1 == null) return;
    final bytes1 = base64Decode(base64String1);
    final tempDir = await getTemporaryDirectory();
    final filePath1 = '${tempDir.path}/screenshot1.png';
    final file1 = File(filePath1);
    await file1.writeAsBytes(bytes1, flush: true);
    await Share.shareXFiles(
      [XFile(filePath1)],
      text:
          'Hey! I recommend you Astroway App for Astrology / Vastu / Wellness related Queries for better life. Connect with best Astrologer at Astroway https://play.google.com/store/apps/details?id=com.pranaam.user',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: AppBar(
            title: Text('Daily Horoscope').tr(),
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(Icons.arrow_back),
            ),
            actions: [
              global.currentUserId != null
                  ? GestureDetector(
                      onTap: () {
                        _captureAndSaveScreenshot();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 2.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                Images.whatsapp,
                                height: 22,
                                width: 22,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Share',
                                        style: Get.textTheme.titleMedium!
                                            .copyWith(
                                                fontSize: 12,
                                                color: Colors.black))
                                    .tr(),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ]),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GetBuilder<DailyHoroscopeController>(
                builder: (dailyHoroscopeController) {
              return dailyHoroscopeController.dailyhoroscopeData == null
                  ? SizedBox()
                  : SizedBox(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //-------Horizontal List of RasiSymbols---------
                        (global.hororscopeSignList.isNotEmpty)
                            ? SizedBox(
                                height: 100,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: global.hororscopeSignList.length,
                                    itemBuilder: (context, index) {
                                      print(
                                          "horocope image:- ${global.hororscopeSignList[index].image}");
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                global.showOnlyLoaderDialog(
                                                    context);
                                                await dailyHoroscopeController
                                                    .selectZodic(index);
                                                await dailyHoroscopeController
                                                    .getHoroscopeList(
                                                        horoscopeId:
                                                            dailyHoroscopeController
                                                                .signId);
                                                global.hideLoader();
                                              },
                                              child: Container(
                                                width: global
                                                        .hororscopeSignList[
                                                            index]
                                                        .isSelected
                                                    ? 68.0
                                                    : 54.0,
                                                height: global
                                                        .hororscopeSignList[
                                                            index]
                                                        .isSelected
                                                    ? 68.0
                                                    : 54.0,
                                                padding: EdgeInsets.all(0),
                                                decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(7)),
                                                  border: Border.all(
                                                    color: Colors.transparent,
                                                    width: 1.0,
                                                  ),
                                                ),
                                                child: CommonCachedNetworkImage(
                                                  height: 50,
                                                  width: 50,
                                                  borderRadius: 100.w,
                                                  imageUrl:
                                                      '${global.hororscopeSignList[index].image}',
                                                ),
                                              ),
                                            ),
                                            Text(
                                              global.hororscopeSignList[index]
                                                  .name,
                                              style: Get.textTheme.titleMedium!
                                                  .copyWith(fontSize: 10),
                                            ).tr()
                                          ],
                                        ),
                                      );
                                    }),
                              )
                            : const SizedBox(),

                        //---------daily,yearly,monthly--------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  dailyHoroscopeController.getProgressValue(
                                      index: 0, type: 'todayHoroscope');
                                  setState(() {
                                    selectHoroscope = 0;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                                  decoration: BoxDecoration(
                                    color: selectHoroscope == 0
                                        ? Color.fromARGB(255, 247, 243, 214)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: selectHoroscope == 0
                                            ? Get.theme.primaryColor
                                            : Colors.grey),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0),
                                        bottomLeft: Radius.circular(10.0)),
                                  ),
                                  child: Text("Today \n Horoscope",
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(fontSize: 12))
                                      .tr(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  dailyHoroscopeController.getProgressValue(
                                      index: 0, type: 'weeklyHoroScope');
                                  dailyHoroscopeController.update();
                                  setState(() {
                                    selectHoroscope = 1;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                                  decoration: BoxDecoration(
                                    color: selectHoroscope == 1
                                        ? Color.fromARGB(255, 247, 243, 214)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: selectHoroscope == 1
                                            ? Get.theme.primaryColor
                                            : Colors.grey),
                                  ),
                                  child: Text("Weekly \n Horoscope",
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(fontSize: 12))
                                      .tr(),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  dailyHoroscopeController.getProgressValue(
                                      index: 0, type: 'yearlyHoroScope');
                                  setState(() {
                                    selectHoroscope = 2;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
                                  decoration: BoxDecoration(
                                    color: selectHoroscope == 2
                                        ? Color.fromARGB(255, 247, 243, 214)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: selectHoroscope == 2
                                            ? Get.theme.primaryColor
                                            : Colors.grey),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0)),
                                  ),
                                  child: Text("Yearly \n Horoscope",
                                          textAlign: TextAlign.center,
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(fontSize: 12))
                                      .tr(),
                                ),
                              ),
                            )
                          ],
                        ),

                        selectHoroscope == 0
                            ? dailyHoroscopeController
                                        .dailyhoroscopeData!['vedicList']
                                            ['todayHoroscope']
                                        .length ==
                                    0
                                ? Center(
                                    child: Text("NO HOROSCOPE").tr(),
                                  )
                                : RepaintBoundary(
                                    key: globalKey,
                                    child: Container(
                                      color: scaffbgcolor,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFAEAE2),
                                              border: Border.all(
                                                  color:
                                                      Get.theme.primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.centerRight,
                                              children: [
                                                Positioned(
                                                    bottom: -60,
                                                    right: -60,
                                                    child:
                                                        const HoroscopeRotateAnimation(
                                                            size: 160)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${DateFormat('dd-MM-yyyy').format(DateTime.parse(dailyHoroscopeController.dailyhoroscopeData!['vedicList']['todayHoroscope'][0]['date']))}",
                                                        style: Get.textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).tr(),
                                                      SizedBox(height: 4),
                                                      Text(
                                                        "Today Horoscope",
                                                        style: Get.textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                      ).tr(),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Lucky Color",
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                              ).tr(),
                                                              dailyHoroscopeController
                                                                          .dailyhoroscopeData![
                                                                              'vedicList']
                                                                              [
                                                                              'todayHoroscope']
                                                                              [
                                                                              0]
                                                                              [
                                                                              'color_code']
                                                                          .toString() ==
                                                                      ""
                                                                  ? SizedBox()
                                                                  : CircleAvatar(
                                                                      backgroundColor:
                                                                          Color(int.parse(dailyHoroscopeController.dailyhoroscopeData!['vedicList']['todayHoroscope'][0]
                                                                              [
                                                                              'color_code'])),
                                                                      radius: 7,
                                                                    )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: 1,
                                                            height: 20,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Lucky Number",
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                              ).tr(),
                                                              Text(
                                                                "${dailyHoroscopeController.dailyhoroscopeData!['vedicList']['todayHoroscope'][0]['lucky_number'].replaceAll("[", "").replaceAll("]", "")}",
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "Today Horoscrope of",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ).tr(args: [
                                            tr(dailyHoroscopeController
                                                .dailyhoroscopeData![
                                                    'vedicList']
                                                    ['todayHoroscope'][0]
                                                    ['zodiac']
                                                .toString())
                                          ]),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          LinearProgressCard(
                                              dailyHoroscopeController:
                                                  dailyHoroscopeController,
                                              horoscopetype: 'todayHoroscope'),
                                          SizedBox(height: 10),
                                          Text(
                                            "${dailyHoroscopeController.dailyhoroscopeData!['vedicList']['todayHoroscope'][0]['bot_response']}",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ).tr(),
                                          SizedBox(height: 50),
                                        ],
                                      ),
                                    ),
                                  )
                            : SizedBox(),

                        selectHoroscope == 1
                            ? dailyHoroscopeController
                                        .dailyhoroscopeData!['vedicList']
                                            ['weeklyHoroScope']
                                        .length ==
                                    0
                                ? Center(
                                    child: Text("NO HOROSCOPE").tr(),
                                  )
                                : RepaintBoundary(
                                    key: globalKey,
                                    child: Container(
                                      color: scaffbgcolor,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFAEAE2),
                                              border: Border.all(
                                                  color:
                                                      Get.theme.primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.centerRight,
                                              children: [
                                                Positioned(
                                                    bottom: -60,
                                                    right: -60,
                                                    child:
                                                        const HoroscopeRotateAnimation(
                                                            size: 160)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "${DateFormat('dd-MM-yyyy').format(DateTime.parse(dailyHoroscopeController.dailyhoroscopeData!['vedicList']['weeklyHoroScope'][0]['start_date']))}",

                                                            // "${dailyHoroscopeController.dailyhoroscopeData!['vedicList']['weeklyHoroScope'][0]['start_date'].toString().split(" ").first}",
                                                            style: Get.textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ).tr(),
                                                          Text(
                                                            ' - ',
                                                            style: Get.textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                          Text(
                                                            "${DateFormat('dd-MM-yyyy').format(DateTime.parse(dailyHoroscopeController.dailyhoroscopeData!['vedicList']['weeklyHoroScope'][0]['end_date']))}",
                                                            style: Get.textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    color: Colors
                                                                        .black),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ).tr(),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        "Weekly Horoscope",
                                                        style: Get.textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                      ).tr(),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Lucky Color",
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                              ).tr(),
                                                              dailyHoroscopeController
                                                                          .dailyhoroscopeData![
                                                                              'vedicList']
                                                                              [
                                                                              'weeklyHoroScope']
                                                                              [
                                                                              0]
                                                                              [
                                                                              'color_code']
                                                                          .toString() ==
                                                                      ""
                                                                  ? SizedBox()
                                                                  : CircleAvatar(
                                                                      backgroundColor:
                                                                          Color(int.parse(dailyHoroscopeController.dailyhoroscopeData!['vedicList']['weeklyHoroScope'][0]
                                                                              [
                                                                              'color_code'])),
                                                                      radius: 7,
                                                                    )
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Container(
                                                            width: 1,
                                                            height: 20,
                                                            color: Colors.black,
                                                          ),
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "Lucky Number",
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        color: Colors
                                                                            .black),
                                                              ).tr(),
                                                              Text(
                                                                "${dailyHoroscopeController.dailyhoroscopeData!['vedicList']['weeklyHoroScope'][0]['lucky_number'].replaceAll("[", "").replaceAll("]", "")}",
                                                                style: Get
                                                                    .textTheme
                                                                    .titleMedium!
                                                                    .copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "Weekly Horoscope of",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ).tr(args: [
                                            tr(dailyHoroscopeController
                                                .dailyhoroscopeData![
                                                    'vedicList']
                                                    ['weeklyHoroScope'][0]
                                                    ['zodiac']
                                                .toString())
                                          ]),
                                          SizedBox(height: 10),
                                          LinearProgressCard(
                                              dailyHoroscopeController:
                                                  dailyHoroscopeController,
                                              horoscopetype: 'weeklyHoroScope'),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "${dailyHoroscopeController.dailyhoroscopeData!['vedicList']['weeklyHoroScope'][0]['bot_response']}",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ).tr(),
                                          SizedBox(height: 50),
                                        ],
                                      ),
                                    ),
                                  )
                            : SizedBox(),

                        selectHoroscope == 2
                            ? dailyHoroscopeController
                                        .dailyhoroscopeData!['vedicList']
                                            ['yearlyHoroScope']
                                        .length ==
                                    0
                                ? Center(
                                    child: Text("NO HOROSCOPE").tr(),
                                  )
                                : Container(
                                    color: scaffbgcolor,
                                    child: RepaintBoundary(
                                      key: globalKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: Color(0xffFAEAE2),
                                              border: Border.all(
                                                  color:
                                                      Get.theme.primaryColor),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned(
                                                    bottom: -60,
                                                    right: -60,
                                                    child:
                                                        const HoroscopeRotateAnimation(
                                                            size: 160)),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03,
                                                      vertical:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${DateFormat('yyyy').format(DateTime.parse(dailyHoroscopeController.dailyhoroscopeData!['vedicList']['yearlyHoroScope'][0]['date'].toString().split(" ").first))}",
                                                        style: Get.textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color: Colors
                                                                    .black),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ).tr(),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Text(
                                                        "Yearly Horoscope",
                                                        style: Get.textTheme
                                                            .titleMedium!
                                                            .copyWith(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .black),
                                                      ).tr(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          Text(
                                            "Yearly Horoscope of",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            textAlign: TextAlign.center,
                                          ).tr(args: [
                                            tr(dailyHoroscopeController
                                                .dailyhoroscopeData![
                                                    'vedicList']
                                                    ['yearlyHoroScope'][0]
                                                    ['zodiac']
                                                .toString())
                                          ]),
                                          SizedBox(
                                            height: 6,
                                          ),
                                          LinearProgressCard(
                                              dailyHoroscopeController:
                                                  dailyHoroscopeController,
                                              horoscopetype: 'yearlyHoroScope'),
                                          Text(
                                            "${dailyHoroscopeController.dailyhoroscopeData!['vedicList']['yearlyHoroScope'][0]['bot_response']}",
                                            style: Get.textTheme.titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12),
                                            textAlign: TextAlign.center,
                                          ).tr(),
                                          SizedBox(height: 50),
                                        ],
                                      ),
                                    ),
                                  )
                            : SizedBox(),
                      ],
                    ));
            }),
          ),
        ),
        bottomSheet: ContactAstrologerCottomButton());
  }
}
