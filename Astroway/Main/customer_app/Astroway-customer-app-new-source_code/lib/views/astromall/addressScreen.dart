// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/views/astromall/addNewAddressScreen.dart';
import 'package:AstrowayCustomer/views/astromall/productPurchaseScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../controllers/astromallController.dart';

import '../../widget/commonAppbar.dart';

class AddressScreen extends StatelessWidget {
  AddressScreen({Key? key}) : super(key: key);
  WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Address',
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GetBuilder<AstromallController>(builder: (astromallController) {
                return InkWell(
                  onTap: () async {
                    await astromallController.removeData();
                    Get.to(() => AddNewAddressScreen());
                  },
                  child: Container(
                    width: 100.w,
                    height: 6.h,
                    margin: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [
                          Get.theme.primaryColor.withOpacity(0.5),
                          Get.theme.primaryColor.withOpacity(0.8),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(width: 3.w),
                        Icon(Icons.add, color: Colors.white, size: 24.sp),
                        SizedBox(width: 3),
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Add New Address',
                            style: Get.textTheme.titleMedium!.copyWith(
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              GetBuilder<AstromallController>(builder: (astromallController) {
                return astromallController.userAddress.isEmpty
                    ? Container(
                        alignment: Alignment.center,
                        height: 80.h,
                        child: Text(
                          'Please add your address',
                          style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                          ),
                        ).tr(),
                      )
                    : ListView.builder(
                        itemCount: astromallController.userAddress.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: 4.w, vertical: 1.h),
                        itemBuilder: (context, index) {
                          final address =
                              astromallController.userAddress[index];

                          return Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 2.h),
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade50,
                                      Colors.purple.shade50
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.shade300,
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Name with gradient accent line
                                    Row(
                                      children: [
                                        Container(
                                          width: 5,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Colors.blue,
                                                Colors.purple
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(3),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            address.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),

                                    // Address details
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on,
                                            color: Colors.redAccent, size: 16),
                                        SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            '${address.flatNo}, ${address.locality}, ${address.city}, ${address.state}, ${address.country}',
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.8.h),
                                    Row(
                                      children: [
                                        Icon(Icons.pin_drop,
                                            color: Colors.orange, size: 16),
                                        SizedBox(width: 6),
                                        Text(
                                          address.pincode.toString(),
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 0.8.h),
                                    Row(
                                      children: [
                                        Icon(Icons.phone,
                                            color: Colors.green, size: 16),
                                        SizedBox(width: 6),
                                        Text(
                                          address.phoneNumber,
                                          style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                    if (address.phoneNumber2 != "")
                                      Row(
                                        children: [
                                          Icon(Icons.phone_android,
                                              color: Colors.blueAccent,
                                              size: 16),
                                          SizedBox(width: 6),
                                          Text(
                                            address.phoneNumber2.toString(),
                                            style: TextStyle(
                                                fontSize: 14.sp,
                                                color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    SizedBox(height: 1.h),

                                    // Select button
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          double charge = double.parse(
                                              astromallController
                                                  .astroProductbyId[0].amount
                                                  .toString());
                                          if (charge <=
                                              global.splashController
                                                  .currentUser!.walletAmount!) {
                                            Get.to(() => OrderPurchaseScreen(
                                                amount: charge));
                                          } else {
                                            global
                                                .showOnlyLoaderDialog(context);
                                            await walletController.getAmount();
                                            global.hideLoader();
                                            global.showMinimumBalancePopup(
                                                context,
                                                charge.toString(),
                                                '',
                                                walletController.payment,
                                                "",
                                                isForGift: true);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 5,
                                          shadowColor: Colors.greenAccent,
                                          backgroundColor:
                                              Colors.green.shade600,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          minimumSize: Size(90, 36),
                                        ),
                                        child: Text(
                                          'Select',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13.sp,
                                              color: Colors.white),
                                        ).tr(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Floating Edit Icon
                              Positioned(
                                top: 10,
                                right: 10,
                                child: InkWell(
                                  onTap: () async {
                                    global.showOnlyLoaderDialog(context);
                                    await astromallController
                                        .getEditAddress(index);
                                    astromallController.update();
                                    global.hideLoader();
                                    Get.to(() =>
                                        AddNewAddressScreen(id: address.id));
                                  },
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue.shade100,
                                    child: Icon(Icons.edit,
                                        color: Colors.blue.shade800, size: 18),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}
