import 'dart:developer';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../../controllers/kundliController.dart';
import '../../../model/basicDetailmodel.dart';
import '../FullSizeSvgPainter.dart';

class KundliChartScreen extends StatefulWidget {
  final int? userid;
  final PlanetDetails? planetDetails;
  const KundliChartScreen({
    super.key,
    required this.userid,
    required this.planetDetails,
  });

  @override
  State<KundliChartScreen> createState() => _KundliChartScreenState();
}

class _KundliChartScreenState extends State<KundliChartScreen>
    with SingleTickerProviderStateMixin {
  final kundlicontroller = Get.find<KundliController>();
  late TabController _tabController;
  var tabIndex = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: kundlicontroller.astrologicalMap.length,
      vsync: this,
    );
    _tabController.addListener(handleswipe);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.userid != null) {
        _fetchDataForTab('D1');
      }
    });
  }

  @override
  void dispose() {
    log('dispose');
    _tabController.removeListener(handleswipe);
    _tabController.dispose();
    super.dispose();
  }

  void handleswipe() {
    log('handleswipe');
    log('tab index is ${_tabController.index} and init index is $tabIndex');
    if (tabIndex != _tabController.index) {
      tabIndex = _tabController.index;
      log('tab swiped to ${tabIndex}');
      setState(() {});
      String selectedKey =
          kundlicontroller.astrologicalMap.keys.elementAt(tabIndex);
      kundlicontroller.chartDeatilmodel?.chartDetails = '';
      kundlicontroller.svgImage = null;
      kundlicontroller.update();
      log('_fetchDataForTab key is ${selectedKey}');

      _fetchDataForTab(selectedKey);
    } else {
      log('tab swiped to else block${tabIndex}');
    }
  }

  void _fetchDataForTab(String tabKey, {bool firstloding = false}) async {
    if (widget.userid == null) return;

    print('Fetching data for $tabKey with userId ${widget.userid}');
    firstloding ? global.showOnlyLoaderDialog(Get.context) : null;
    await kundlicontroller.getChartDetails(
      widget.userid!,
      tabKey,
      kundlicontroller.selectedDirection,
      firstloding: firstloding,
    );
    await createSvgImage(kundlicontroller.chartDeatilmodel?.chartDetails ?? '');
  }

  Future createSvgImage(String svg) async {
    if (svg.isEmpty) return;

    try {
      final pictureInfo = await vg.loadPicture(SvgStringLoader(svg), null);
      final img = await pictureInfo.picture.toImage(500, 500);

      kundlicontroller.svgImage = img;
      pictureInfo.picture.dispose();

      // Ensure the state update is handled correctly
      kundlicontroller.isDataLoaded = true;
      kundlicontroller.update();
    } catch (e) {
      print('Error creating SVG image: $e');
      kundlicontroller.isDataLoaded = false;
      kundlicontroller.update();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<KundliController>(
      builder: (kundlicontroller) => Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: kundlicontroller.astrologicalMap.entries
                    .map((entry) => Tab(
                          text: tr('${entry.value}'),
                        ))
                    .toList(),
              ),
              SizedBox(
                height: 10.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            kundlicontroller.selectedDirection = 'north';
                            kundlicontroller.svgImage = null;

                            kundlicontroller.update();

                            _fetchDataForTab(
                              kundlicontroller.astrologicalMap.keys
                                  .elementAt(_tabController.index),
                              firstloding: false,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(2.w),
                                  topLeft: Radius.circular(2.w)),
                              color:
                                  kundlicontroller.selectedDirection == 'north'
                                      ? Get.theme.primaryColor
                                      : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                'North',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            kundlicontroller.selectedDirection = 'south';
                            kundlicontroller.svgImage = null;
                            kundlicontroller.update();
                            _fetchDataForTab(
                              kundlicontroller.astrologicalMap.keys
                                  .elementAt(_tabController.index),
                              firstloding: false,
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 4.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(2.w),
                                  topRight: Radius.circular(2.w)),
                              color:
                                  kundlicontroller.selectedDirection == 'south'
                                      ? Get.theme.primaryColor
                                      : Colors.grey,
                            ),
                            child: Center(
                              child: Text(
                                'South',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                              ).tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 54.h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    TabBarView(
                      controller: _tabController,
                      children:
                          kundlicontroller.astrologicalMap.keys.map((key) {
                        return Column(
                          children: [
                            SizedBox(height: 1.h),
                            Container(
                              width: 95.w,
                              height: 95.w,
                              child: kundlicontroller.isDataLoaded
                                  ? (kundlicontroller.svgImage != null
                                      ? CustomPaint(
                                          painter: FullSizeSvgPainter(
                                              kundlicontroller.svgImage),
                                        )
                                      : Center(
                                          child: CircularProgressIndicator()))
                                  : Center(child: CircularProgressIndicator()),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                alignment: Alignment.centerLeft,
                child: Text('Planet',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    )).tr(),
              ),
              Column(
                children: [
                  GetBuilder<KundliController>(
                    builder: (kundlicontroller) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      height: 10.h,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              //signin
                              kundlicontroller.isNakshatraTapped = false;
                              kundlicontroller.update();
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2.w),
                                  ),
                                  border: kundlicontroller.isNakshatraTapped ==
                                          false
                                      ? Border.all(color: Colors.pink, width: 1)
                                      : Border.all(
                                          color: Colors.grey, width: 0.5),
                                  color: kundlicontroller.isNakshatraTapped ==
                                          false
                                      ? Colors.pink.shade50
                                      : Colors.grey.shade50),
                              child: Text(
                                'Sign',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ).tr(),
                            ),
                          ),
                          SizedBox(width: 2.w),
                          GestureDetector(
                            onTap: () {
                              //Nakshatra
                              kundlicontroller.isNakshatraTapped = true;
                              kundlicontroller.update();
                            },
                            child: Container(
                              padding: EdgeInsets.all(2.w),
                              child: Text(
                                'Nakshatra',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ).tr(),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(2.w),
                                  ),
                                  border: kundlicontroller.isNakshatraTapped
                                      ? Border.all(color: Colors.pink, width: 1)
                                      : Border.all(
                                          color: Colors.grey, width: 0.5),
                                  color: kundlicontroller.isNakshatraTapped
                                      ? Colors.pink.shade50
                                      : Colors.grey.shade50),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4.w),
                    height: 60.h,
                    child: kundlicontroller.isNakshatraTapped == false
                        ? customSignInTableWidget(widget.planetDetails)
                        : customNakshatraInTableWidget(widget.planetDetails),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  customNakshatraInTableWidget(PlanetDetails? planetDetails) {
    var astrolist = widget.planetDetails?.response;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              buildTableHeaderCell("Planet"),
              buildVerticalDivider(),
              buildTableHeaderCell("Nakshatra"),
              buildVerticalDivider(),
              buildTableHeaderCell("Naksh lord"),
              buildVerticalDivider(),
              buildTableHeaderCell("House"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              Map<int, The0?> astroMap = {
                0: astrolist?.the0,
                1: astrolist?.the1,
                2: astrolist?.the2,
                3: astrolist?.the3,
                4: astrolist?.the4,
                5: astrolist?.the5,
                6: astrolist?.the6,
                7: astrolist?.the7,
                8: astrolist?.the8,
                9: astrolist?.the9,
              };
              return Column(
                children: [
                  Row(
                    children: [
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.fullName ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.nakshatra ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.nakshatraLord ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]?.house.toString() ?? ""),
                      buildVerticalDivider(),
                    ],
                  ),
                  Container(
                    height: 0.4,
                    width: 100.w,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  customSignInTableWidget(PlanetDetails? planetDetails) {
    var astrolist = widget.planetDetails?.response;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            border: Border.all(color: Colors.black, width: 0.5),
          ),
          child: Row(
            children: [
              buildTableHeaderCell("Planet"),
              buildVerticalDivider(),
              buildTableHeaderCell("Sign"),
              buildVerticalDivider(),
              buildTableHeaderCell("Signlord"),
              buildVerticalDivider(),
              buildTableHeaderCell("Degree"),
              buildVerticalDivider(),
              buildTableHeaderCell("House"),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              Map<int, The0?> astroMap = {
                0: astrolist?.the0,
                1: astrolist?.the1,
                2: astrolist?.the2,
                3: astrolist?.the3,
                4: astrolist?.the4,
                5: astrolist?.the5,
                6: astrolist?.the6,
                7: astrolist?.the7,
                8: astrolist?.the8,
                9: astrolist?.the9,
              };

              return Column(
                children: [
                  Row(
                    children: [
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.fullName ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.zodiac ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]!.zodiacLord ?? ""),
                      buildVerticalDivider(),
                      buildTableCell(
                          astroMap[index]?.localDegree!.toStringAsFixed(2) ??
                              ""),
                      buildVerticalDivider(),
                      buildTableCell(astroMap[index]?.house.toString() ?? ""),
                      buildVerticalDivider(),
                    ],
                  ),
                  Container(
                    height: 0.4,
                    width: 100.w,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

Widget buildTableHeaderCell(String text) {
  return Expanded(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      alignment: Alignment.center,
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13.sp,
        ),
      ),
    ),
  );
}

Widget buildVerticalDivider() {
  return Container(
    width: 0.4,
    height: 4.h,
    color: Colors.black,
  );
}

Widget buildTableCell(String? text) {
  return Expanded(
    child: Container(
      height: 4.h,
      alignment: Alignment.center,
      child: Text(
        text!,
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.black,
        ),
      ),
    ),
  );
}
