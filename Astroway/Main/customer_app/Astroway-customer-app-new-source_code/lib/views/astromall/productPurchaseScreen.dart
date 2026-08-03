import 'package:AstrowayCustomer/controllers/astromallController.dart';

import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/widget/commonAppbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../../controllers/callController.dart';
import '../../controllers/history_controller.dart';
import '../bottomNavigationBarScreen.dart';

// ignore: must_be_immutable
class OrderPurchaseScreen extends StatefulWidget {
  final double amount;
  final int? flag;
  OrderPurchaseScreen({Key? key, required this.amount, this.flag})
      : super(key: key);
  @override
  State<OrderPurchaseScreen> createState() => _OrderPurchaseScreenState();
}

class _OrderPurchaseScreenState extends State<OrderPurchaseScreen> {
  final walletController = Get.find<WalletController>();
  final splashController = Get.find<SplashController>();
  final astromallController = Get.find<AstromallController>();
  final historyController = Get.find<HistoryController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: CommonAppBar(
            title: 'Payment Information',
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<WalletController>(builder: (c) {
            return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Payment Details',
                                    style: Get.textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15))
                                .tr(),
                            SizedBox(
                              height: 5,
                            ),
                            widget.flag == 1
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          '${astromallController.astroProductbyId[0].name}'),
                                      Text(
                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${double.parse(astromallController.astroProductbyId[0].amount.toString())}'),
                                    ],
                                  )
                                : SizedBox(),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Total Amount').tr(),
                                Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.amount}'),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '( Incl of all taxes )',
                                  style: TextStyle(color: Colors.green),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${tr("Total Payable Amount")}',
                                    style: Get.textTheme.titleMedium!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${widget.amount}',
                                    style: Get.textTheme.titleMedium!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ]);
          }),
        ),
      ),
      bottomSheet: GetBuilder<AstromallController>(
        builder: (astromallController) => SizedBox(
          height: 60,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: astromallController.isProcessing
                  ? null
                  : () async {
                      global.showOnlyLoaderDialog(context);
                      await astromallController.orderRequest(
                          addressID: astromallController.userAddress[0].id,
                          catId: astromallController
                              .astroProductbyId[0].productCategoryId,
                          gstPercent: 0,
                          payAmount: double.parse(astromallController
                              .astroProductbyId[0].amount
                              .toString()),
                          payMethod: 'Wallet',
                          prodId: astromallController.astroProductbyId[0].id,
                          totalPayment: double.parse(astromallController
                              .astroProductbyId[0].amount
                              .toString()));
                      astromallController.update();
                      await global.splashController.getCurrentUserData();
                      await historyController.getPaymentLogs(
                          global.currentUserId!, false);
                      historyController.walletTransactionList = [];
                      historyController.walletTransactionList.clear();
                      historyController.walletAllDataLoaded = false;
                      await historyController.getWalletTransaction(
                          global.currentUserId!, false);
                      global.hideLoader();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final callController = Get.find<CallController>();
                        callController.setTabIndex(0);
                        Get.off(() => BottomNavigationBarScreen(
                              index: 4,
                            ));
                      });
                    },
              child: Text('Proceed to Pay',
                      style: Get.textTheme.titleMedium!
                          .copyWith(fontSize: 12, color: Colors.white))
                  .tr(),
              style: ButtonStyle(
                padding: WidgetStateProperty.all(EdgeInsets.all(0)),
                backgroundColor:
                    WidgetStateProperty.all(Get.theme.primaryColor),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
