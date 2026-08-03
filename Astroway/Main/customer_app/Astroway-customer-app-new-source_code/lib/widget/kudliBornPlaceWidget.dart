// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/views/placeOfBrithSearchScreen.dart';
import 'package:AstrowayCustomer/widget/drodownWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';

class KundliBornPlaceWidget extends StatefulWidget {
  final KundliController kundliController;
  const KundliBornPlaceWidget({
    Key? key,
    required this.kundliController,
  }) : super(key: key);

  @override
  State<KundliBornPlaceWidget> createState() => _KundliBornPlaceWidgetState();
}

class _KundliBornPlaceWidgetState extends State<KundliBornPlaceWidget> {
  String type = "medium";

  WalletController walletController = Get.find<WalletController>();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              Get.to(() => PlaceOfBirthSearchScreen());
            },
            child: IgnorePointer(
              child: TextField(
                controller: widget.kundliController.birthKundliPlaceController,
                onChanged: (_) {},
                decoration: InputDecoration(
                    suffixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    hintText: 'Birth Place',
                    hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500)),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const SizedBox(
          height: 25,
        ),
        Flexible(
          flex: 1,
          child: RadioListTile(
            title: Text("Basic").tr(),
            value: "basic",
            groupValue: type,
            dense: true,
            activeColor: Get.theme.primaryColor,
            contentPadding: EdgeInsets.all(0.0),
            onChanged: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
        ),
        Flexible(
          flex: 1,
          child: RadioListTile(
            title: widget.kundliController.pdfPriceData!.isFreeSession == true
                ? Text("Free Kundali").tr()
                : (global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.walletType) ==
                        "Wallet"
                    ? Text("Small Kundali (₹${widget.kundliController.pdfPriceData!.recordList![0].price})")
                        .tr()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Small Kundali (${widget.kundliController.pdfPriceData!.recordList![0].price}")
                              .tr(),
                          SizedBox(
                            width: 0.4.w,
                          ),
                          Image.network(
                            global.getSystemFlagValueForLogin(
                                global.systemFlagNameList.coinIcon),
                            height: 1.4.h,
                          ),
                          Text(")")
                        ],
                      )),
            value: "small",
            groupValue: type,
            dense: true,
            activeColor: Get.theme.primaryColor,
            contentPadding: EdgeInsets.all(0.0),
            onChanged: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
        ),
        Flexible(
          flex: 1,
          child: RadioListTile(
            title: global.getSystemFlagValueForLogin(
                        global.systemFlagNameList.walletType) ==
                    "Wallet"
                ? Text(
                    "Detailed Kundali (₹${widget.kundliController.pdfPriceData!.recordList![1].price})")
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Detailed Kundali (${widget.kundliController.pdfPriceData!.recordList![1].price}")
                          .tr(),
                      SizedBox(
                        width: 0.4.w,
                      ),
                      Image.network(
                        global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.coinIcon),
                        height: 1.4.h,
                      ),
                      Text(")")
                    ],
                  ),
            value: "medium",
            groupValue: type,
            dense: true,
            activeColor: Get.theme.primaryColor,
            contentPadding: EdgeInsets.all(0.0),
            onChanged: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
        ),
        Flexible(
          flex: 1,
          child: RadioListTile(
            title: global.getSystemFlagValueForLogin(
                        global.systemFlagNameList.walletType) ==
                    "Wallet"
                ? Text("Full-fledged Kundali (₹${widget.kundliController.pdfPriceData!.recordList![2].price})")
                    .tr()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Full-fledged Kundali (${widget.kundliController.pdfPriceData!.recordList![2].price}")
                          .tr(),
                      SizedBox(
                        width: 0.4.w,
                      ),
                      Image.network(
                        global.getSystemFlagValueForLogin(
                            global.systemFlagNameList.coinIcon),
                        height: 1.4.h,
                      ),
                      Text(")")
                    ],
                  ),
            value: "large",
            groupValue: type,
            dense: true,
            activeColor: Get.theme.primaryColor,
            contentPadding: EdgeInsets.all(0.0),
            onChanged: (value) {
              setState(() {
                type = value!;
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Select Your Kundali Language",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 18.sp),
        ),
        SizedBox(
          height: 10,
        ),
        DropDownWidget(
          item: [
            'English',
            'Tamil',
            'Kannada',
            'Telugu',
            'Hindi',
            'Malayalam',
            'Spanish',
            'French',
          ],
          hint: tr(
            'Select Your Language',
          ),
          callId: 4,
        ),
        SizedBox(
          height: 15,
        ),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            style: ButtonStyle(
              padding: WidgetStateProperty.all(EdgeInsets.all(0)),
              backgroundColor: WidgetStateProperty.all(Get.theme.primaryColor),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.grey)),
              ),
            ),
            onPressed: () async {
              if (type == "small"
                  ? (widget.kundliController.pdfPriceData!.isFreeSession == true
                      ? false
                      : global.splashController.currentUser!.walletAmount! <
                          int.parse(widget.kundliController.pdfPriceData!
                              .recordList![0].price
                              .toString()))
                  : type == "medium"
                      ? (global.splashController.currentUser!.walletAmount! <
                          int.parse(widget.kundliController.pdfPriceData!
                              .recordList![1].price
                              .toString()))
                      : type == "large"
                          ? (global
                                  .splashController.currentUser!.walletAmount! <
                              int.parse(widget.kundliController.pdfPriceData!
                                  .recordList![2].price
                                  .toString()))
                          : false) {
                global.showMinimumBalancePopup(
                    context,
                    type == "small"
                        ? widget
                            .kundliController.pdfPriceData!.recordList![0].price
                            .toString()
                        : (type == "medium"
                            ? "${widget.kundliController.pdfPriceData!.recordList![1].price.toString()}"
                            : widget.kundliController.pdfPriceData!
                                .recordList![2].price
                                .toString()),
                    "",
                    walletController.payment,
                    "Chat",
                    isForGift: true);
              } else {
                if (widget.kundliController.birthKundliPlaceController.text ==
                    "") {
                  global.showToast(
                    message: 'Please select birth place',
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                } else {
                  widget.kundliController
                      .updateIcon(widget.kundliController.initialIndex);
                  global.showOnlyLoaderDialog(context);
                  await widget.kundliController.addKundliData(
                      type,
                      type.toString() == "large"
                          ? int.parse(widget.kundliController.pdfPriceData!
                              .recordList![0].price
                              .toString())
                          : (type.toString() == "medium"
                              ? int.parse(widget.kundliController.pdfPriceData!
                                  .recordList![1].price
                                  .toString())
                              : (type.toString() == "small"
                                  ? (widget.kundliController.pdfPriceData!
                                              .isFreeSession ==
                                          true
                                      ? 0
                                      : int.parse(widget.kundliController
                                          .pdfPriceData!.recordList![2].price
                                          .toString()))
                                  : 0)));
                  await widget.kundliController.getKundliList();
                  widget.kundliController.initialIndex = 0;
                  global.hideLoader();
                  Get.back();
                }
              }
            },
            child: Text(
              'Submit',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ).tr(),
          ),
        ),
      ],
    );
  }
}
