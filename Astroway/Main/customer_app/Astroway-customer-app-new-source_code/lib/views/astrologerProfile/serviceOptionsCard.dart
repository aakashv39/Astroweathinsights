// service_option_card.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class ServiceOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String priceText;
  final String discountedPrice;
  final double? iconsSize;
  final Color iconColor;
  final bool isFree;
  final bool isDiscounted;

  const ServiceOptionCard(
      {super.key,
      required this.icon,
      required this.title,
      required this.discountedPrice,
      required this.priceText,
      required this.isFree,
      required this.isDiscounted,
      this.iconsSize,
      required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 16.h,
        padding: const EdgeInsets.all(4.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: iconsSize ?? 25,
              color: iconColor,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 15.sp,
                color: darkGreen,
                fontWeight: FontWeight.w500,
              ),
            ).tr(),
            SizedBox(height: 10),

            ///for discounted price
            isFree
                ? SizedBox()
                : (global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.walletType) ==
                        "Wallet"
                    ? (isDiscounted
                        ? Text(
                            "${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $priceText /min",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.lineThrough,
                              decorationThickness: 2,
                            ),
                          )
                        : SizedBox())
                    : (isDiscounted
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                priceText,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.lineThrough,
                                  decorationThickness: 2,
                                ),
                              ),
                              SizedBox(
                                width: 0.4.w,
                              ),
                              Image.network(
                                global.getSystemFlagValueForLogin(
                                    global.systemFlagNameList.coinIcon),
                                height: 1.2.h,
                              ),
                              Text(
                                " /min",
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    decorationThickness: 2,
                                    decoration: TextDecoration.lineThrough),
                              )
                            ],
                          )
                        : SizedBox())),

            ///for paid
            isFree
                ? Text(
                    "Free",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: darkGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : (global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.walletType) ==
                        "Wallet"
                    ? (isDiscounted
                        ? Text(
                            "${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $discountedPrice /min",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            "${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $priceText /min",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          isDiscounted
                              ? Text(
                                  discountedPrice,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: darkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  priceText,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    color: darkGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          SizedBox(
                            width: 0.4.w,
                          ),
                          Image.network(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.coinIcon),
                            height: 1.2.h,
                          ),
                          Text(
                            " /min",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: darkGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      )),
          ],
        ),
      ),
    );
  }
}
