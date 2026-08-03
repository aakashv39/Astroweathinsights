// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/model/businessLayer/baseRoute.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/global.dart';
import 'package:AstrowayCustomer/views/paymentInformationScreen.dart';
import 'package:AstrowayCustomer/widget/CanvasStyle/topWaveCliper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

class AddmoneyToWallet extends BaseRoute {
  AddmoneyToWallet({a, o}) : super(a: a, o: o, r: 'AddMoneyToWallet');
  final WalletController walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: AppBar(title: Text('Add money to wallet').tr()),
        body: Container(
          decoration: scafdecoration,
          child: GetBuilder<SplashController>(builder: (splash) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Get.theme.primaryColor,
                          Get.theme.primaryColor.withOpacity(0.7),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.account_balance_wallet_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Available Balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ).tr(),
                          ],
                        ),
                        SizedBox(height: 8),
                        global.getSystemFlagValueForLogin(
                                    global.systemFlagNameList.walletType) ==
                                "Wallet"
                            ? Text(
                                '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${splashController.currentUser!.walletAmount.toString()}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              )
                            : Row(
                                children: [
                                  Text(
                                    '${splashController.currentUser!.walletAmount.toString().split('.').first}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 1.w,
                                  ),
                                  Image.network(
                                    global.getSystemFlagValueForLogin(
                                        global.systemFlagNameList.coinIcon),
                                    height: 3.h,
                                  )
                                ],
                              ),
                        SizedBox(height: 8),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Recharge Your Wallet Now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),

                  // Recharge Options Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Recharge',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ).tr(),
                        SizedBox(height: 16),
                        GetBuilder<WalletController>(builder: (c) {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: walletController.paymentAmount.length,
                            itemBuilder: (context, index) {
                              final hasCashback = walletController
                                      .paymentAmount[index].cashback !=
                                  0;
                              return GestureDetector(
                                onTap: () {
                                  if (global
                                          .getSystemFlagValueForLogin(global
                                              .systemFlagNameList.walletType)
                                          .toString() ==
                                      "Wallet") {
                                    Get.to(() => PaymentInformationScreen(
                                          amount: double.parse(walletController
                                              .paymentAmount[index].amount
                                              .toString()),
                                          cashback: walletController
                                              .paymentAmount[index].cashback,
                                        ));
                                  } else {
                                    print(
                                        "country:- ${global.user.countryCode}");
                                    Get.to(() => PaymentInformationScreen(
                                          amount: global.user.countryCode.toString() == "+91"
                                              ? double.parse(walletController.paymentAmount[index].amount.toString()) /
                                                  double.parse(global
                                                      .getSystemFlagValueForLogin(global
                                                          .systemFlagNameList
                                                          .InrToCoin)
                                                      .toString())
                                              : double.parse(walletController
                                                      .paymentAmount[index]
                                                      .amount
                                                      .toString()) /
                                                  double.parse(global
                                                      .getSystemFlagValueForLogin(
                                                          global.systemFlagNameList.UsdToCoin)
                                                      .toString()),
                                          cashback: walletController
                                              .paymentAmount[index].cashback,
                                        ));
                                  }
                                },
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: hasCashback
                                          ? Get.theme.primaryColor
                                              .withOpacity(0.3)
                                          : Colors.grey.withOpacity(0.2),
                                      width: hasCashback ? 2 : 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: hasCashback
                                            ? Get.theme.primaryColor
                                                .withOpacity(0.1)
                                            : Colors.black.withOpacity(0.03),
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      // Cashback Badge
                                      if (hasCashback)
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [
                                                  Colors.orange.shade400,
                                                  Colors.deepOrange.shade500,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.orange
                                                      .withOpacity(0.3),
                                                  blurRadius: 4,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  Icons.star_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                                SizedBox(width: 2),
                                                Text(
                                                  'EXTRA',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10.sp,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                      Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10),
                                            global.getSystemFlagValueForLogin(
                                                        global
                                                            .systemFlagNameList
                                                            .walletType) ==
                                                    "Wallet"
                                                ? Text(
                                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.paymentAmount[index].amount}',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.black87,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        '${walletController.paymentAmount[index].amount}',
                                                        style: TextStyle(
                                                          fontSize: 24,
                                                          color: Colors.black87,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 1.w,
                                                      ),
                                                      Image.network(
                                                        global.getSystemFlagValueForLogin(
                                                            global
                                                                .systemFlagNameList
                                                                .coinIcon),
                                                        height: 3.h,
                                                      )
                                                    ],
                                                  ),
                                            if (hasCashback) ...[
                                              SizedBox(height: 8),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Get.theme.primaryColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  '+${walletController.paymentAmount[index].cashback}% Extra',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),

                  ClipPath(
                    clipper: WaveClipper(top: true, bottom: false),
                    child: Container(
                      margin: EdgeInsets.all(0),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.black12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Get.theme.primaryColor,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Why Add Money?',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ).tr(),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildBenefitItem(
                                Icons.flash_on_rounded,
                                'Instant\nconsultations',
                                const Color.fromARGB(255, 13, 0, 255),
                              ),
                              _buildBenefitItem(
                                Icons.security_rounded,
                                'Secure &\nsafe payments',
                                const Color.fromARGB(255, 8, 91, 11),
                              ),
                              _buildBenefitItem(
                                Icons.local_offer_rounded,
                                'Exclusive\ncashback offers',
                                const Color.fromARGB(255, 255, 0, 0),
                              ),
                            ],
                          ),
                          SizedBox(height: 20)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBenefitItem(IconData icon, String text, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
                border: Border.all(color: color, width: 0.5),
                color: color.withOpacity(0.1),
                shape: BoxShape.circle),
            child: Icon(
              icon,
              size: 16,
              color: color,
            ),
          ),
          SizedBox(height: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
