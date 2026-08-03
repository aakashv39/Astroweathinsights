// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:AstrowayCustomer/views/astromall/addNewAddressScreen.dart';
import 'package:AstrowayCustomer/views/poojaBooking/model/poojalistmodel.dart';
import 'package:AstrowayCustomer/views/poojaBooking/screen/checkoutscreen.dart';
import 'package:AstrowayCustomer/widget/textFieldWidget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/astromallController.dart';
import '../../../widget/commonAppbar.dart';
import 'customcheckoutscree.dart';

class AddPoojaDeliveryAddress extends StatefulWidget {
  final Package? selectedpackage;
  final dynamic poojadetail;
  final int index;
  final bool isfrommycustomproduct;
  AddPoojaDeliveryAddress({
    super.key,
    required this.selectedpackage,
    required this.poojadetail,
    required this.index,
    this.isfrommycustomproduct = false,
  });

  @override
  State<AddPoojaDeliveryAddress> createState() =>
      _AddPoojaDeliveryAddressState();
}

class _AddPoojaDeliveryAddressState extends State<AddPoojaDeliveryAddress> {
  final astromallController = Get.put(AstromallController());

  @override
  void initState() {
    super.initState();
    // log('data booking price is ${widget.selectedpackage?.packagePrice}');
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
                      if (widget.isfrommycustomproduct == true) {
                        print("imagepuja:- ${widget.poojadetail.pujaImages}");
                        Get.to(() => CustomCheckoutscreen(
                              address: mallcontroller.userAddress[
                                  astromallController.selectedIndex!],
                              poojadetail: widget.poojadetail,
                              index: widget.index,
                            ));
                      } else {
                        Get.to(() => Checkoutscreen(
                              address: mallcontroller.userAddress[
                                  astromallController.selectedIndex!],
                              package: widget.selectedpackage ?? null,
                              poojadetail: widget.poojadetail,
                              index: widget.index,
                            ));
                      }
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

                            return mallcontroller.userAddress.isEmpty
                                ? Container(
                                    height: 80.h,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Please Add your Address",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17.sp),
                                    ))
                                : Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(bottom: 1.5.h),
                                        padding: EdgeInsets.all(3.w),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(18),
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
                                              blurRadius: 8,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: GetBuilder<AstromallController>(
                                          builder: (astromallController) => InkWell(
                                            onTap: (){
                                              print("select value -${astromallController.selectedIndex!}");
                                              astromallController.selectedIndex = index;
                                              astromallController.update();
                                            },
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // ✅ Radio Button
                                                Radio(
                                                  value: index,
                                                  groupValue: astromallController
                                                      .selectedIndex,
                                                  onChanged: (int? value) {
                                                    // astromallController
                                                    //     .selectedIndex = value;
                                                    // astromallController.update();
                                                  },
                                                  activeColor:
                                                      Colors.deepPurpleAccent,
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),

                                                // ✅ Address Details
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      // --- Name with Accent ---
                                                      Row(
                                                        children: [
                                                          Container(
                                                            width: 4,
                                                            height: 18,
                                                            decoration:
                                                                BoxDecoration(
                                                              gradient:
                                                                  LinearGradient(
                                                                colors: [
                                                                  Colors.blue,
                                                                  Colors.purple
                                                                ],
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4),
                                                            ),
                                                          ),
                                                          SizedBox(width: 8),
                                                          Flexible(
                                                            child: Text(
                                                              'Name: ${address.name}',
                                                              style: Get.textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 14.sp,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.8.h),

                                                      // --- Phone Number ---
                                                      Row(
                                                        children: [
                                                          Icon(Icons.phone,
                                                              color: Colors.green,
                                                              size: 16.sp),
                                                          SizedBox(width: 6),
                                                          Flexible(
                                                            child: Text(
                                                              'Phone No: ${address.phoneNumber}',
                                                              style: Get.textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                fontSize: 14.sp,
                                                                color: Colors.grey
                                                                    .shade700,
                                                              ),
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.8.h),

                                                      // --- Address ---
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Icon(Icons.location_on,
                                                              color: Colors
                                                                  .redAccent,
                                                              size: 16.sp),
                                                          SizedBox(width: 6),
                                                          Expanded(
                                                            child: Text(
                                                              'Address: ${address.flatNo} ${address.landmark} ${address.locality} ${address.city} ${address.state}',
                                                              overflow:
                                                                  TextOverflow
                                                                      .visible,
                                                              style: Get.textTheme
                                                                  .titleMedium!
                                                                  .copyWith(
                                                                fontSize: 14.sp,
                                                                color: Colors.grey
                                                                    .shade700,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 0.8.h),

                                                      // --- Pincode ---
                                                      Row(
                                                        children: [
                                                          Icon(Icons.pin_drop,
                                                              color:
                                                                  Colors.orange,
                                                              size: 16.sp),
                                                          SizedBox(width: 6),
                                                          Text(
                                                            'Pincode: ${address.pincode}',
                                                            style: Get.textTheme
                                                                .titleMedium!
                                                                .copyWith(
                                                              fontSize: 14.sp,
                                                              color: Colors
                                                                  .grey.shade700,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // ✅ Floating Edit Button
                                      Positioned(
                                        right: 4.w,
                                        top: 2.w,
                                        child: InkWell(
                                          onTap: () async {
                                            log('edit positioned is called $index');
                                            global
                                                .showOnlyLoaderDialog(context);
                                            await astromallController
                                                .getEditAddress(index);
                                            astromallController.update();
                                            global.hideLoader();
                                            Get.to(() => AddNewAddressScreen(
                                                id: address.id));
                                          },
                                          child: Container(
                                            height: 4.5.h,
                                            width: 4.5.h,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.blue.shade100,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.blue
                                                      .withOpacity(0.3),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.edit,
                                              size: 18.sp,
                                              color: Colors.blue.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                          },
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Container(
                        width: 100.w,
                        padding: EdgeInsets.all(3.w),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _buildaddnewaddressWidget(),
                          ],
                        ),
                      ),
                      Container(
                          height: 70.h,
                          alignment: Alignment.center,
                          child: Text(
                            "Please Add your Address",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 17.sp),
                          ))
                    ],
                  );
          })),
    );
  }

  InkWell _buildaddnewaddressWidget() {
    return InkWell(
      onTap: () async {
        //tap on add address
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
