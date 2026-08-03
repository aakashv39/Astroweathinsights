import 'package:AstrowayCustomer/views/kudali/kundliDetailsScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controllers/kundliController.dart';
import 'GetKundliscreens/DashaScreen.dart';
import 'GetKundliscreens/DoshaScreen.dart';
import 'GetKundliscreens/KpScreen.dart';
import 'GetKundliscreens/astavargaTablescreen.dart';
import 'GetKundliscreens/kundlichartscreen.dart';
import 'GetKundliscreens/planetReportscreen.dart';
import 'GetKundliscreens/reportScreen.dart';
import 'basicdetailwidget.dart';

class GetKundliDetailScreen extends StatefulWidget {
  final int? userid;
  final String? pdflink;
  const GetKundliDetailScreen(
      {super.key, required this.userid, required this.pdflink});

  @override
  State<GetKundliDetailScreen> createState() => _GetKundliDetailScreenState();
}

class _GetKundliDetailScreenState extends State<GetKundliDetailScreen>
    with AutomaticKeepAliveClientMixin<GetKundliDetailScreen> {
  @override
  bool get wantKeepAlive => true;
  int currentIndex = 0;
  final kundlicontroller = Get.find<KundliController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool hasPdfLink =
        widget.pdflink != null && widget.pdflink!.isNotEmpty;

    print("hasPdfLink $hasPdfLink");

    return DefaultTabController(
      length: 8,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Kundli Details', style: TextStyle(color: Colors.white))
              .tr(),
          actions: [
            hasPdfLink
                ? InkWell(
                    borderRadius: BorderRadius.circular(30.w),
                    onTap: () {
                      Get.to(() => KundliDetailsScreen(
                            pdfLink: widget.pdflink!,
                          ));
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.w),
                          border: Border.all(color: Colors.black)),
                      margin: EdgeInsets.all(1.w),
                      child: Text('PDF',
                          style: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall!
                              .copyWith(
                                color: Colors.black,
                              )),
                    ),
                  )
                : SizedBox(),
            SizedBox(width: 3.w),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(6.h),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    height: 5.h,
                    child: TabBar(
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                      tabAlignment: TabAlignment.start,
                      dividerColor: Colors.transparent,
                      isScrollable: true,
                      indicator: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(255, 0, 4, 255),
                              Color.fromARGB(255, 255, 5, 5),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.w)),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white,
                      labelStyle:
                          Get.theme.primaryTextTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle:
                          Get.theme.primaryTextTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 1),
                      indicatorPadding:
                          EdgeInsets.symmetric(horizontal: 0.w, vertical: 4),
                      tabs: [
                        Tab(text: tr('Basic Details')),
                        Tab(text: tr('Charts')),
                        Tab(text: tr('KP')),
                        Tab(text: tr('Ashtakvarga')),
                        Tab(text: tr('Report')),
                        Tab(text: tr('Planet Report')),
                        Tab(text: tr('Dasha')),
                        Tab(text: tr('Dosha')),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            BasicDetailsWidget(basicDetails: kundlicontroller.basicDeatilmodel),
            KundliChartScreen(
                userid: widget.userid,
                planetDetails:
                    kundlicontroller.basicDeatilmodel?.planetDetails),
            KpScreen(
                userid: widget.userid,
                planetDetails:
                    kundlicontroller.basicDeatilmodel?.planetDetails),
            AshtakvargaTable(userid: widget.userid),
            ReportScreen(userid: widget.userid),
            PlanetReportScreen(userid: widget.userid),
            DashaScreen(userid: widget.userid),
            DoshaScreen(userid: widget.userid),
          ],
        ),
      ),
    );
  }
}
