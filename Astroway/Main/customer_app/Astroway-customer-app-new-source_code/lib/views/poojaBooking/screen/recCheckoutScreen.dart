// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/model/user_address_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controllers/astromallController.dart';
import '../../../model/RecommendedPujaListModel.dart';
import '../../../model/astrologer_model.dart';
import '../../../utils/services/api_helper.dart';
import '../../bottomNavigationBarScreen.dart';
import '../../webpaymentScreen.dart';
import 'AstrologerSelectionWidget.dart';

class RecCheckoutscreen extends StatefulWidget {
  final UserAddressModel? address;
  final Package? package;
  final RecommendedPujaListModel? poojadetail;
  final int index;

  const RecCheckoutscreen({
    super.key,
    this.address,
    this.package,
    this.poojadetail,
    required this.index,
  });

  @override
  State<RecCheckoutscreen> createState() => _CheckoutscreenState();
}

class _CheckoutscreenState extends State<RecCheckoutscreen> {
  double? gst = 0;
  double? totalamount = 0.0;
  final apiHelper = APIHelper();
  final historyController = Get.find<HistoryController>();
  final bottomnavController = Get.find<BottomNavigationController>();
  final walletcontroller = Get.find<WalletController>();

  AstrologerModel? selectedAstrologer;
  @override
  void initState() {
    super.initState();
    log('data booking price is 2->  ${widget.poojadetail!.toJson()}');
    log('image url ${widget.poojadetail?.pujaImages?[0]}  ');
    gst = (double.parse(widget.package!.packagePrice!)) *
        double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) /
        100;

    totalamount = double.tryParse(
        ((double.parse(widget.package!.packagePrice!) +
                double.parse(gst.toString()))
            .toStringAsFixed(2)));

    log('gst $gst');
    log('totalamount $totalamount');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      bottomNavigationBar: GetBuilder<AstromallController>(
        builder: (mallcontroller) => mallcontroller.userAddress.isNotEmpty
            ? InkWell(
                onTap: () async {
                  //tap address selected
                  global.showOnlyLoaderDialog(Get.context);
                  await apiHelper
                      .placedPujaOrder(
                    packageid: widget.package!.id!,
                    pujaid: widget.poojadetail!.id!,
                    addressid: widget.address!.id!,
                    selectedAstrologer: selectedAstrologer, //assign astrologer
                    recommendid: widget.poojadetail!.recommendId!.toString(),
                  )
                      .then((value) async {
                    if (value['status'] == 200) {
                      global.hideLoader();
                      //proceed to payment online not enough wallet balance
                      if (value['message'] == "Pay Online.") {
                        Get.to(() => PaymentScreen(url: value['redirect']));
                      } else {
                        global.showToast(
                          message: value['message'],
                          textColor: Colors.black,
                          bgColor: Colors.white,
                        );
                        global.splashController.getCurrentUserData();
                        await walletcontroller.getAmount();
                        await historyController.getChatHistory(
                            global.currentUserId!, false);
                        Get.off(() => BottomNavigationBarScreen(index: 0));
                      }
                    }
                  });
                },
                child: Container(
                  width: 100.w,
                  height: 8.h,
                  margin: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.shade400,
                        Colors.orange.shade200,
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Buy Now',
                            style: Get.textTheme.titleMedium!.copyWith(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ).tr(),
                        ),
                        SizedBox(width: 3.w),
                      ]),
                ),
              )
            : SizedBox(),
      ),
      appBar: AppBar(
        title: Text('Checkout').tr(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 70.h,
              width: 100.w,
              child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 7.w),
                  elevation: 1.w,
                  child: Column(
                    children: [
                      SizedBox(height: 3.h),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 3.w),
                        padding: EdgeInsets.all(1.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3.w),
                            color: Color(0xffe7f1ff),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset: Offset(0, 1),
                              ),
                            ]),
                        child: Center(
                          child: Text(
                            'Product Details',
                            style: Get.textTheme.titleMedium!.copyWith(
                              fontSize: 18.sp,
                              color: Color(0xff79b4fd),
                            ),
                          ).tr(),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      _buildbannerwidget(),
                      SizedBox(height: 1.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Text('${widget.poojadetail!.pujaTitle}',
                            style: Get.textTheme.titleMedium),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child:
                            Text('Package', style: Get.textTheme.titleMedium),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Text(
                          '${widget.poojadetail!.packages![widget.index].title} ( ${widget.poojadetail!.packages![widget.index].person} Person)',
                          style: Get.textTheme.titleMedium,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Price',
                              style: Get.textTheme.titleMedium,
                            ),
                            Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.package!.packagePrice!}',
                              style: Get.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '(incl of all taxes)',
                              style: Get.textTheme.titleMedium,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: double.infinity,
                        height: 0.2,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        color: Colors.black,
                      ),
                      SizedBox(height: 3.h),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total',
                              style: Get.textTheme.titleMedium,
                            ),
                            Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${(double.parse(widget.package!.packagePrice!)).toStringAsFixed(2)}',
                              style: Get.textTheme.titleMedium!.copyWith(
                                  fontSize: 17.sp,
                                  color: Color(0xff79b4fd),
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assign To',
                              style: Get.textTheme.bodyMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => AstrologerSelectionWidget(
                                      onSelect: (astrologer) {
                                        setState(() {
                                          selectedAstrologer = astrologer;
                                        });
                                      },
                                    ));
                              },
                              child: Text(
                                selectedAstrologer?.name == null ||
                                        selectedAstrologer?.name == ""
                                    ? 'Select Astrologer'
                                    : (selectedAstrologer?.name ??
                                                    'Select Astrologer')
                                                .length >
                                            14
                                        ? '${selectedAstrologer?.name?.substring(0, 14)}..'
                                        : selectedAstrologer?.name ??
                                            'Select Astrologer',
                                style: Get.textTheme.bodyMedium!.copyWith(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildbannerwidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(horizontal: 3.w),
      width: 100.w,
      height: 20.h,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl:
              global.buildImageUrl("${widget.poojadetail!.pujaImages![0]}"),
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
        //   "${imgBaseurl}${widget.poojadetail!.pujaImages![0]}",
        //   fit: BoxFit.fill,
        // ),
      ),
    );
  }
}
