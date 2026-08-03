// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:AstrowayCustomer/views/astromall/addNewAddressScreen.dart';

import 'package:AstrowayCustomer/widget/textFieldWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/astromallController.dart';
import '../../../model/RecommendedPujaListModel.dart';
import '../../../widget/commonAppbar.dart';
import 'recCheckoutScreen.dart';

class RecAddPoojaDeliveryAddress extends StatefulWidget {
  final Package? selectedpackage;
  final RecommendedPujaListModel? poojadetail;
  final int index;
  RecAddPoojaDeliveryAddress({
    super.key,
    required this.selectedpackage,
    required this.poojadetail,
    required this.index,
  });

  @override
  State<RecAddPoojaDeliveryAddress> createState() =>
      _AddPoojaDeliveryAddressState();
}

class _AddPoojaDeliveryAddressState extends State<RecAddPoojaDeliveryAddress> {
  final astromallController = Get.put(AstromallController());

  @override
  void initState() {
    super.initState();
    log('data booking price is ${widget.selectedpackage?.packagePrice}');
    getUpdateAddress();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: CommonAppBar(
                title: 'Address',
              )),
          bottomNavigationBar: //proceed saved address
              GetBuilder<AstromallController>(
            builder: (mallcontroller) => mallcontroller.userAddress.isNotEmpty
                ? InkWell(
                    onTap: () {
                      //tap address selected
                      log('${mallcontroller.userAddress[astromallController.selectedIndex!].toString()}');
                      log('data is:- ${widget.poojadetail?.pujaImages?[0]}');
                      Get.to(() => RecCheckoutscreen(
                            address: mallcontroller.userAddress[
                                astromallController.selectedIndex!],
                            package: widget.selectedpackage,
                            poojadetail: widget.poojadetail,
                            index: widget.index,
                          ));
                    },
                    child: Container(
                      width: 100.w,
                      height: 8.h,
                      margin: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade500,
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
                                'Proceed',
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
          body: GetBuilder<AstromallController>(builder: (mallcontroller) {
            // log('address saved is:- ${mallcontroller.userAddress}');
            return mallcontroller.userAddress.isNotEmpty
                ? Column(
                    children: [
                      _buildaddnewaddressWidget(),
                      Column(
                        children: List.generate(
                          mallcontroller.userAddress.length,
                          (index) {
                            final address = mallcontroller.userAddress[index];

                            return Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(3.w),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: GetBuilder<AstromallController>(
                                    builder: (astromallController) => Row(
                                      children: [
                                        Radio(
                                          value: index,
                                          groupValue:
                                              astromallController.selectedIndex,
                                          onChanged: (int? value) {
                                            astromallController.selectedIndex =
                                                value;
                                            astromallController.update();
                                          },
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Name: ${address.name}',
                                                style:
                                                    Get.textTheme.titleMedium),
                                            Text(
                                                'Phone No: ${address.phoneNumber}',
                                                style:
                                                    Get.textTheme.titleMedium),
                                            Container(
                                              constraints: BoxConstraints(
                                                  maxWidth: 80.w),
                                              child: Text(
                                                  'Address: ${address.flatNo} ${address.landmark} ${address.locality} ${address.city} ${address.state}',
                                                  overflow:
                                                      TextOverflow.visible,
                                                  style: Get
                                                      .textTheme.titleMedium),
                                            ),
                                            Text('Pincode: ${address.pincode}',
                                                style:
                                                    Get.textTheme.titleMedium),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 5.w,
                                  top: 2.w,
                                  child: InkWell(
                                    onTap: () async {
                                      //tap on edit address
                                      log('edit positioned is called $index');
                                      global.showOnlyLoaderDialog(context);
                                      await astromallController
                                          .getEditAddress(index);
                                      astromallController.update();
                                      global.hideLoader();
                                      Get.to(() =>
                                          AddNewAddressScreen(id: address.id));
                                    },
                                    child: Container(
                                      height: 4.h,
                                      width: 4.h,
                                      child: Icon(
                                        Icons.edit,
                                        size: 18.sp,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: 100.w,
                    height: 100.h,
                    padding: EdgeInsets.all(3.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildaddnewaddressWidget(),
                      ],
                    ),
                  );
          })),
    );
  }

  InkWell _buildaddnewaddressWidget() {
    return InkWell(
      onTap: () async {
        //tap on add address
        Get.to(() => AddNewAddressScreen());
      },
      child: Container(
        width: 100.w,
        height: 8.h,
        margin: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade500,
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
            SizedBox(width: 3.w),
            Icon(Icons.add, color: Colors.white, size: 24.sp),
            SizedBox(width: 3),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Add Address',
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
  }

  void openAddressDialog(BuildContext context, astromallController) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      isScrollControlled: true, // Allows the bottom sheet to scroll
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 16.0),
                buildTextFieldWidget(
                    controller: astromallController.nameController,
                    labelText: 'Name',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ]),
                buildPhoneNumberInput(
                    astromallController.phoneController, 'Phone number'),
                buildPhoneNumberInput(
                    astromallController.alternatePhoneController,
                    'Alternate Phone'),
                buildTextFieldWidget(
                    controller: astromallController.flatNoController,
                    labelText: 'Flat number',
                    keyboardType: TextInputType.number),
                buildTextFieldWidget(
                    controller: astromallController.localityController,
                    labelText: 'Locality'),
                buildTextFieldWidget(
                    controller: astromallController.landmarkController,
                    labelText: 'Landmark'),
                buildTextFieldWidget(
                    controller: astromallController.cityController,
                    labelText: 'City',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ]),
                buildTextFieldWidget(
                    controller: astromallController.stateController,
                    labelText: 'State/Province',
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ]),
                buildTextFieldWidget(
                  controller: astromallController.countryController,
                  labelText: 'Country',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                  ],
                ),
                buildTextFieldWidget(
                  controller: astromallController.pinCodeController,
                  labelText: 'Pincode',
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Save address logic
                  },
                  child: Text('Save Address'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildPhoneNumberInput(
      TextEditingController controller, String hintText) {
    return SizedBox(
      child: Theme(
        data: ThemeData(
          dialogTheme: DialogThemeData(
            contentTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.grey[800],
            surfaceTintColor: Colors.grey[800],
          ),
        ),
        child: InternationalPhoneNumberInput(
          textFieldController: controller,
          inputDecoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
              fontSize: 16,
              fontFamily: "verdana_regular",
              fontWeight: FontWeight.w400,
            ),
          ),
          onInputValidated: (bool value) {},
          selectorConfig: const SelectorConfig(
            leadingPadding: 2,
            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          ),
          ignoreBlank: false,
          autoValidateMode: AutovalidateMode.disabled,
          selectorTextStyle: const TextStyle(color: Colors.black),
          searchBoxDecoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(2)),
              borderSide: const BorderSide(color: Colors.white),
            ),
            hintText: "Search",
            hintStyle: const TextStyle(color: Colors.black),
          ),
          initialValue: PhoneNumber(isoCode: 'IN'),
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: false),
          inputBorder: InputBorder.none,
          onSaved: (PhoneNumber number) {},
          onFieldSubmitted: (value) {
            FocusScope.of(context).unfocus();
          },
          onInputChanged: (PhoneNumber number) {},
          onSubmit: () {
            FocusScope.of(context).unfocus();
          },
        ),
      ),
    );
  }

  Widget buildTextFieldWidget({
    required TextEditingController controller,
    required String labelText,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFieldWidget(
      controller: controller,
      labelText: labelText,
      focusNode: FocusNode(),
      inputFormatter: inputFormatters ?? [],
      keyboardType: keyboardType,
      maxlen: maxLength,
    );
  }

  void getUpdateAddress() async {
    await astromallController
        .getUserAddressData(global.sp!.getInt("currentUserId") ?? 0);
  }
}
