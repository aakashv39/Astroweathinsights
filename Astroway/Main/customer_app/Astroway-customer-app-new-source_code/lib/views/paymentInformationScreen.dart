// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/webpaymentScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/walletController.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../utils/services/api_helper.dart';

class PaymentInformationScreen extends StatefulWidget {
  final double amount;
  final int? flag;
  final int? cashback;
  PaymentInformationScreen(
      {Key? key, required this.amount, this.flag, this.cashback = 0})
      : super(key: key);

  @override
  State<PaymentInformationScreen> createState() =>
      _PaymentInformationScreenState();
}

class _PaymentInformationScreenState extends State<PaymentInformationScreen> {
  final walletController = Get.find<WalletController>();
  final splashController = Get.find<SplashController>();
  final astromallController = Get.find<AstromallController>();
  final apiHelper = APIHelper();
  int? paymentMode;

  double get gstAmount =>
      widget.amount *
      double.parse(global.getSystemFlagValue(global.systemFlagNameList.gst)) /
      100;

  double get totalPayable => widget.amount + gstAmount;

  double get cashbackAmount => widget.cashback == 0
      ? 0
      : widget.amount * int.parse(widget.cashback.toString()) / 100;

  double get finalAmount => widget.amount + cashbackAmount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Get.theme.primaryColor,
            title: Text('Payment Information',
                    style: TextStyle(color: Colors.white))
                .tr()),
        body: Container(
          decoration: scafdecoration,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GetBuilder<WalletController>(builder: (c) {
                return Column(
                  children: [
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Get.theme.primaryColor,
                            Get.theme.primaryColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.3),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Amount to Pay',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ).tr(),
                          SizedBox(height: 8),
                          global.getSystemFlagValueForLogin(
                                      global.systemFlagNameList.walletType) ==
                                  "Wallet"
                              ? Text(
                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${totalPayable.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                )
                              : Text(
                                  '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${double.parse(totalPayable.toString())}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                          global.getSystemFlagValueForLogin(
                                      global.systemFlagNameList.walletType) ==
                                  "Wallet"
                              ? SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "( ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} 1 ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                    global.user.countryCode.toString() == "+91"
                                        ? Text(
                                            "is Equal to  ${global.getSystemFlagValueForLogin(global.systemFlagNameList.InrToCoin)})",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          )
                                        : Text(
                                            " is Equal to ${global.getSystemFlagValueForLogin(global.systemFlagNameList.UsdToCoin)} ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                    Image.network(
                                      global.getSystemFlagValueForLogin(
                                          global.systemFlagNameList.coinIcon),
                                      height: 1.7.h,
                                    ),
                                    Text(
                                      " )",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    )
                                  ],
                                ),
                          if (widget.cashback != 0) ...[
                            SizedBox(height: 12),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.celebration_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  global.getSystemFlagValueForLogin(global
                                              .systemFlagNameList.walletType) ==
                                          "Wallet"
                                      ? Row(
                                          children: [
                                            Text(
                                              'You will get',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ).tr(),
                                            Text(
                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${finalAmount.toStringAsFixed(2)} ',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'after cashback!',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ).tr(),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            global.user.countryCode
                                                        .toString() ==
                                                    "+91"
                                                ? Text(
                                                    'You will get ${(double.parse(finalAmount.toStringAsFixed(2)) * double.parse(global.getSystemFlagValueForLogin(global.systemFlagNameList.InrToCoin))).toString().split(".").first}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  )
                                                : Text(
                                                    'You will get ${(double.parse(finalAmount.toStringAsFixed(2)) * double.parse(global.getSystemFlagValueForLogin(global.systemFlagNameList.UsdToCoin))).toString().split('.').first}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: 1.w,
                                            ),
                                            Image.network(
                                              global.getSystemFlagValueForLogin(
                                                  global.systemFlagNameList
                                                      .coinIcon),
                                              height: 1.7.h,
                                            ),
                                            Text(
                                              ' after cashback!',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long_rounded,
                                color: Get.theme.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Payment Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ).tr(),
                            ],
                          ),
                          SizedBox(height: 16),

                          if (widget.flag == 1) ...[
                            _buildDetailRow(
                              '${astromallController.astroProductbyId[0].name}',
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${double.parse(astromallController.astroProductbyId[0].amount.toString())}',
                              isHighlighted: false,
                            ),
                            _buildDivider(),
                          ],

                          // Total Amount
                          _buildDetailRow(
                            'Total Amount',
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.amount}',
                            isHighlighted: false,
                          ),
                          _buildDivider(),

                          // GST
                          _buildDetailRow(
                            'GST (${global.getSystemFlagValue(global.systemFlagNameList.gst)}%)',
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${gstAmount.toStringAsFixed(2)}',
                            isHighlighted: false,
                          ),
                          _buildDivider(),

                          // Total Payable
                          _buildDetailRow(
                            'Total Payable Amount',
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${totalPayable.toStringAsFixed(2)}',
                            isHighlighted: true,
                          ),

                          // Cashback Section
                          if (widget.cashback != 0) ...[
                            _buildDivider(),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade50,
                                    Colors.teal.shade50,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  _buildDetailRow(
                                    'Cashback (${widget.cashback}%)',
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${cashbackAmount.toStringAsFixed(2)}',
                                    isHighlighted: false,
                                    color: Colors.green.shade700,
                                  ),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 1,
                                    color: Colors.green.shade200,
                                  ),
                                  SizedBox(height: 8),
                                  global.getSystemFlagValueForLogin(global
                                              .systemFlagNameList.walletType) ==
                                          "Wallet"
                                      ? _buildDetailRow(
                                          'Final Wallet Balance',
                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${finalAmount.toStringAsFixed(2)}',
                                          isHighlighted: true,
                                          color: Colors.green.shade700,
                                        )
                                      : _buildDetailRow(
                                          'Final  Balance',
                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${finalAmount.toStringAsFixed(2)}',
                                          isHighlighted: true,
                                          color: Colors.green.shade700,
                                        ),
                                  global.getSystemFlagValueForLogin(global
                                              .systemFlagNameList.walletType) ==
                                          "Wallet"
                                      ? SizedBox()
                                      : _buildDetailRow(
                                          'Final Coins in Wallet',
                                          global.user.countryCode.toString() ==
                                                  "+91"
                                              ? '${(double.parse(finalAmount.toStringAsFixed(2)) * double.parse(global.getSystemFlagValueForLogin(global.systemFlagNameList.InrToCoin))).toString().split(".").first}'
                                              : '${(double.parse(finalAmount.toStringAsFixed(2)) * double.parse(global.getSystemFlagValueForLogin(global.systemFlagNameList.UsdToCoin))).toString().split(".").first}',
                                          isHighlighted: true,
                                          color: Colors.green.shade700,
                                          isCoin: true),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    // Security Info
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 25, 0, 255)),
                        color: const Color.fromARGB(255, 187, 191, 251),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.security_rounded,
                            color: const Color.fromARGB(255, 38, 0, 255),
                            size: 20,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your payment is 100% secure and encrypted',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 17, 0, 255),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ).tr(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: kIsWeb ? 24 : 100),
                  ],
                );
              }),
            ),
          ),
        ),
        bottomSheet: Container(
          padding: EdgeInsets.all(2.w),
          color: whiteColor,
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () => _processPayment(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Get.theme.primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.w),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_rounded, size: 20),
                SizedBox(width: 8),
                Row(
                  children: [
                    Text(
                      'Proceed to Pay ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ).tr(),
                    Text(
                      '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${totalPayable.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value,
      {required bool isHighlighted, Color? color, bool isCoin = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isHighlighted ? 15 : 14,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              color: color ??
                  (isHighlighted ? Colors.black87 : Colors.grey.shade700),
            ),
          ).tr(),
          Row(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isHighlighted ? 16 : 14,
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.w600,
                  color: color ??
                      (isHighlighted ? Colors.black87 : Colors.black87),
                ),
              ),
              SizedBox(
                width: 1.w,
              ),
              isCoin
                  ? Image.network(
                      global.getSystemFlagValueForLogin(
                          global.systemFlagNameList.coinIcon),
                      height: 2.h,
                    )
                  : SizedBox()
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(color: Colors.grey.shade200, height: 1),
    );
  }

  Future<void> _processPayment() async {
    global.showOnlyLoaderDialog(Get.context);
    await apiHelper
        .addAmountInWallet(
            amount: double.parse(totalPayable.toStringAsFixed(2)),
            cashback: widget.cashback == 0
                ? 0
                : int.parse(
                    (int.parse(widget.amount.toString().split(".").first) *
                            (int.parse(widget.cashback.toString()) / 100))
                        .toString()
                        .split(".")
                        .first))
        .then((value) {
      if (value['status'] == 200) {
        global.hideLoader();
        print("jkasdjksa");
        log("$value");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PaymentScreen(
                      url: value['url'],
                    )));
      }
    });
  }
}
