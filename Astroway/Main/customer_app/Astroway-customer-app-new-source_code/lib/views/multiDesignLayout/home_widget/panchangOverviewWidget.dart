import 'package:AstrowayCustomer/controllers/advancedPanchangController.dart';
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/views/panchang/panchangScreen.dart';
import 'package:AstrowayCustomer/views/panchang/widgets/titleCardwidget.dart';
import 'package:AstrowayCustomer/widget/horoscopeRotateWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

class PanchangOverviewWidget extends StatelessWidget {
  final PanchangController panchangController;
  PanchangOverviewWidget({super.key, required this.panchangController});

  @override
  Widget build(BuildContext context) {
    return panchangController.vedicPanchangModel != null &&
            panchangController.vedicPanchangModel != ""
        ? Container(
            padding: EdgeInsets.all(2.w),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                // 🔹 Header Row
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Panchang",
                        style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w600,
                            color: Color(0xffFF0000)),
                      ).tr(),
                      SizedBox(height: 2.w),
                      GestureDetector(
                        onTap: () async {
                          String? ipAddress =
                              await apiHelper.getPublicIPAddress();
                          panchangController.getPanchangVedic(
                            DateTime.now(),
                            ipAddress,
                          );
                          // global.hideLoader();
                          Get.to(() => PanchangScreen());
                        },
                        child: Text(
                          '${tr("View Details")} →',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                            letterSpacing: -0.2,
                          ),
                        ).tr(),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                // 🔹 Tithi
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

                // 🔹 Nakshatra
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

                // 🔹 Rasi Section
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(1.w),
                  margin: EdgeInsets.all(1.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                          top: -35,
                          right: -30,
                          child: const HoroscopeRotateAnimation(size: 120)),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${tr("Rasi")}",
                              style: Get.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Get.theme.primaryColor,
                                fontSize: 20.sp,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              panchangController.vedicPanchangModel?.recordList
                                      ?.response?.rasi?.name ??
                                  "-",
                              style: Get.textTheme.bodyLarge?.copyWith(
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
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
