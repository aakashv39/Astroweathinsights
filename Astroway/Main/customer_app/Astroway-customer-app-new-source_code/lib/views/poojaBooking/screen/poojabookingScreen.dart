// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/views/poojaBooking/screen/poojadetailScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../utils/global.dart' as global;
import '../controller/poojaController.dart';

class Poojabookingscreen extends StatefulWidget {
  String catId;
  Poojabookingscreen({super.key, required this.catId});

  @override
  State<Poojabookingscreen> createState() => _PoojabookingscreenState();
}

class _PoojabookingscreenState extends State<Poojabookingscreen> {
  final poojaController = Get.find<PoojaController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      poojaController.getPoojaList(widget.catId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffbgcolor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
          backgroundColor: Get.theme.primaryColor,
          title:
              Text("Puja Booking", style: TextStyle(color: Colors.white)).tr()),
      body: GetBuilder<PoojaController>(
        builder: (poojaController) {
          if (poojaController.isLoading) {
            return showInapploader;
          }

          if (poojaController.poojalist?.isEmpty == true) {
            return Center(
              child: Text(
                "No Pooja Available",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ).tr(),
            );
          }

          DateTime now = DateTime.now();
          bool allPoojaOver = poojaController.poojalist!.every((pooja) {
            DateTime endDateTime = pooja.pujaEndDatetime ?? DateTime.now();
            return endDateTime.isBefore(now) ||
                endDateTime.isAtSameMomentAs(now);
          });

          if (allPoojaOver) {
            return SizedBox(
              height: 80.h,
              width: 100.w,
              child: Center(
                child: Text(
                  'All Puja is Over, try again later',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                    color: Colors.red.shade400,
                  ),
                ).tr(),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(3.w),
            itemCount: poojaController.poojalist?.length ?? 0,
            itemBuilder: (context, index) {
              final pooja = poojaController.poojalist![index];
              DateTime startDateTime = pooja.pujaStartDatetime == null
                  ? DateTime.now()
                  : pooja.pujaStartDatetime!;
              bool isPassed = startDateTime.isBefore(now) ||
                  startDateTime.isAtSameMomentAs(now);

              return Card(
                margin: EdgeInsets.only(bottom: 3.w),
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // IMAGE
                    CachedNetworkImage(
                      imageUrl: global.buildImageUrl("${pooja.pujaImages![0]}"),
                      height: 22.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Skeletonizer(
                        enabled: true,
                        child: Container(
                          height: 22.h,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.broken_image, size: 40),
                    ),

                    // CONTENT
                    Padding(
                      padding: EdgeInsets.all(3.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // DATE
                          pooja.pujaStartDatetime == null
                              ? SizedBox()
                              : Text(
                                  "( ${DateFormat('d MMM yyyy • h:mm a').format(pooja.pujaStartDatetime!)} )",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w700,
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                          SizedBox(height: 1.h),

                          // TITLE
                          Text(
                            pooja.pujaTitle ?? "",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 0.5.h),

                          // SUBTITLE
                          Text(
                            pooja.pujaSubtitle ?? "",
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          SizedBox(height: 1.5.h),

                          // LOCATION
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    Get.theme.primaryColor.withOpacity(0.15),
                                child: Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Expanded(
                                child: Text(
                                  pooja.pujaPlace ?? "",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (isPassed) {
                                  Get.snackbar(
                                    tr("Puja"),
                                    tr("This Pooja is already Over"),
                                    colorText: Colors.white,
                                    backgroundColor: Colors.redAccent,
                                  );
                                } else {
                                  Get.to(() =>
                                      Poojadetailscreen(poojaItem: pooja));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isPassed
                                    ? Colors.grey
                                    : Get.theme.primaryColor,
                                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                isPassed ? "FINISHED" : "PARTICIPATE",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ).tr(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
