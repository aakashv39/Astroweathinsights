// ignore_for_file: deprecated_member_use

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:AstrowayCustomer/widget/horoscopeRotateWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/gift_controller.dart';
import '../../utils/global.dart' as global;
import '../addMoneyToWallet.dart';

Future<void> showGiftBottomSheet({
  required BuildContext context,
  required GiftController giftController,
  required WalletController walletController,
  required BottomNavigationController bottomNavigationController,
}) async {
  global.showOnlyLoaderDialog(context);
  await giftController.getGiftData();
  global.hideLoader();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.purple.shade50,
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                  top: -80,
                  right: -90,
                  child: const HoroscopeRotateAnimation(size: 250)),
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Header with Decorative Elements
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Get.theme.primaryColor.withOpacity(0.1),
                          Get.theme.primaryColor.withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Get.theme.primaryColor.withOpacity(0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Get.theme.primaryColor,
                                Get.theme.primaryColor.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Get.theme.primaryColor.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            CupertinoIcons.gift,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Send a Gift',
                                style: Get.textTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              global.buildTranslatedText(
                                'to ${bottomNavigationController.astrologerbyId[0].name}',
                                Get.textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey.shade600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(Icons.close, color: Colors.grey.shade700),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Gift Grid with Enhanced Design
                  Expanded(
                    child: GetBuilder<GiftController>(
                      builder: (giftController) {
                        return GridView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.85,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                          ),
                          itemCount: giftController.giftList.length,
                          itemBuilder: (context, index) {
                            final gift = giftController.giftList[index];
                            final isSelected = gift.isSelected ?? false;

                            return GestureDetector(
                              onTap: () {
                                giftController.updateOntap(index);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? Get.theme.primaryColor
                                        : Colors.grey.shade300,
                                    width: isSelected ? 1 : 0.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: isSelected
                                          ? Get.theme.primaryColor
                                              .withOpacity(0.3)
                                          : Colors.black.withOpacity(0.05),
                                      blurRadius: isSelected ? 12 : 8,
                                      offset: Offset(0, isSelected ? 6 : 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Gift Image with Badge
                                    Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        CommonCachedNetworkImage(
                                          height: 45,
                                          width: 45,
                                          imageUrl: '${gift.image}',
                                        ),
                                        if (isSelected)
                                          Positioned(
                                            right: -26,
                                            top: -10,
                                            child: Container(
                                              padding: const EdgeInsets.all(4),
                                              decoration: BoxDecoration(
                                                color: Get.theme.primaryColor,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Get
                                                        .theme.primaryColor
                                                        .withOpacity(0.5),
                                                    blurRadius: 6,
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Gift Name
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        gift.name,
                                        style:
                                            Get.textTheme.bodyMedium!.copyWith(
                                          fontSize: 12,
                                          fontWeight: isSelected
                                              ? FontWeight.w600
                                              : FontWeight.normal,
                                          color: isSelected
                                              ? Colors.black
                                              : Colors.black87,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    // Gift Price
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Get.theme.primaryColor
                                                .withOpacity(0.1)
                                            : Colors.amber.shade50,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: (global.getSystemFlagValueForLogin(
                                                  global.systemFlagNameList
                                                      .walletType) ==
                                              "Wallet"
                                          ? Text(
                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${gift.amount}',
                                              style: Get.textTheme.bodySmall!
                                                  .copyWith(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: isSelected
                                                    ? Get.theme.primaryColor
                                                    : Colors.amber.shade800,
                                              ),
                                            )
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  ' ${gift.amount}',
                                                  style: Get
                                                      .textTheme.bodySmall!
                                                      .copyWith(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w600,
                                                    color: isSelected
                                                        ? Get.theme.primaryColor
                                                        : Colors.amber.shade800,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 2,
                                                ),
                                                Image.network(
                                                  global
                                                      .getSystemFlagValueForLogin(
                                                          global
                                                              .systemFlagNameList
                                                              .coinIcon),
                                                  height: 12,
                                                ),
                                              ],
                                            )),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(16),
                    margin: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.amber.shade100,
                          Colors.amber.shade50,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade200,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.account_balance_wallet_rounded,
                            color: Colors.amber,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Wallet Balance',
                              style: Get.textTheme.bodySmall!.copyWith(
                                color: Colors.grey.shade700,
                                fontSize: 11,
                              ),
                            ).tr(),
                            const SizedBox(height: 2),
                            global.getSystemFlagValueForLogin(
                                        global.systemFlagNameList.walletType) ==
                                    "Wallet"
                                ? Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.splashController.currentUser?.walletAmount.toString() ?? '0'}',
                                    style: Get.textTheme.titleMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${global.splashController.currentUser?.walletAmount.toString().split(".").first ?? '0'}',
                                        style:
                                            Get.textTheme.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 2,
                                      ),
                                      Image.network(
                                        global.getSystemFlagValueForLogin(
                                            global.systemFlagNameList.coinIcon),
                                        height: 12,
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Bottom Action Panel
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  Get.to(() => AddmoneyToWallet());
                                },
                                icon: const Icon(Icons.add_circle_outline,
                                    size: 20),
                                label: Text(
                                  'Recharge',
                                  style: Get.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.sp),
                                ).tr(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Get.theme.primaryColor,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 14, horizontal: 10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: Get.theme.primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Send Gift Button
                            Expanded(
                              flex: 3,
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  if (giftController.giftSelectIndex != null) {
                                    double wallet = global.splashController
                                            .currentUser?.walletAmount ??
                                        0.0;
                                    if (wallet <
                                        giftController
                                            .giftList[
                                                giftController.giftSelectIndex!]
                                            .amount) {
                                      global.showToast(
                                        message: 'Insufficient balance',
                                        textColor: global.textColor,
                                        bgColor: global.toastBackGoundColor,
                                      );
                                    } else {
                                      global.showOnlyLoaderDialog(context);
                                      await giftController.sendGift(
                                        giftController
                                            .giftList[
                                                giftController.giftSelectIndex!]
                                            .id,
                                        bottomNavigationController
                                            .astrologerbyId[0].id!,
                                        double.parse(giftController
                                            .giftList[
                                                giftController.giftSelectIndex!]
                                            .amount
                                            .toString()),
                                      );
                                      global.hideLoader();
                                    }
                                  } else {
                                    global.showToast(
                                      message: 'Please select a gift',
                                      textColor: global.textColor,
                                      bgColor: global.toastBackGoundColor,
                                    );
                                  }
                                },
                                icon: const Icon(Icons.card_giftcard, size: 20),
                                label: Text(
                                  'Send Gift',
                                  style: Get.textTheme.bodyMedium!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ).tr(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Get.theme.primaryColor,
                                  foregroundColor: Colors.white,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  elevation: 4,
                                  shadowColor:
                                      Get.theme.primaryColor.withOpacity(0.5),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
