import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../widget/commonAppbar.dart';
import '../../widget/customBottomButton.dart';
import '../../widget/textFieldWidget.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class AddNewAddressScreen extends StatelessWidget {
  final int? id;
  AddNewAddressScreen({Key? key, this.id}) : super(key: key);
  final astromallController = AstromallController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(56),
            child: CommonAppBar(
              title: id != null ? 'Edit Address' : 'Address',
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 70),
            child:
                GetBuilder<AstromallController>(builder: (astromallController) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFieldWidget(
                    controller: astromallController.nameController,
                    labelText: tr('Name'),
                    focusNode: astromallController.namefocus,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Theme(
                        data: ThemeData(
                          dialogTheme: DialogThemeData(
                            contentTextStyle: Get.theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                            backgroundColor: Colors.grey[800],
                            surfaceTintColor: Colors.grey[800],
                          ),
                        ),
                        child: InternationalPhoneNumberInput(
                          maxLength: 10,
                          textFieldController:
                              astromallController.phoneController,
                          inputDecoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 3.w),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade600)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade600)),
                              hintText: 'Phone number',
                              hintStyle:
                                  Get.theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          onInputValidated: (bool value) {
                            // log('$value');
                          },
                          onInputChanged: (PhoneNumber number) {
                            astromallController.countryCode = number.dialCode;
                            print("countrycode");
                            print("${astromallController.countryCode}");
                          },
                          selectorConfig: const SelectorConfig(
                            leadingPadding: 2,
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: Get.theme.textTheme.bodyMedium!
                              .copyWith(color: Colors.black),
                          searchBoxDecoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 3.w),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              hintText: "Search",
                              hintStyle:
                                  Get.theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.black,
                              )),
                          initialValue: PhoneNumber(isoCode: 'IN'),
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: false),
                          inputBorder: InputBorder.none,
                          onSaved: (PhoneNumber number) {},
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          onSubmit: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: Theme(
                        data: ThemeData(
                          dialogTheme: DialogThemeData(
                            contentTextStyle: Get.theme.textTheme.bodyMedium!
                                .copyWith(color: Colors.white),
                            backgroundColor: Colors.grey[800],
                            surfaceTintColor: Colors.grey[800],
                          ),
                        ),
                        child: InternationalPhoneNumberInput(
                          maxLength: 10,
                          textFieldController:
                              astromallController.alternatePhoneController,
                          inputDecoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 3.w),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade600)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.grey.shade600)),
                              hintText: tr('Alternate Phone number'),
                              hintStyle: TextStyle(
                                fontFamily: 'Open San  s',
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          onInputValidated: (bool value) {
                            // log('$value');
                          },
                          onInputChanged: (PhoneNumber number) {
                            astromallController.countryCode2 = number.dialCode;
                            print("countrycode");
                            print("${astromallController.countryCode2}");
                          },
                          selectorConfig: const SelectorConfig(
                            leadingPadding: 2,
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          selectorTextStyle: Get.theme.textTheme.bodyMedium!
                              .copyWith(color: Colors.black),
                          searchBoxDecoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 3.w),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(2.w)),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              hintText: "Search",
                              hintStyle:
                                  Get.theme.textTheme.bodyMedium!.copyWith(
                                color: Colors.black,
                              )),
                          initialValue: PhoneNumber(isoCode: 'IN'),
                          formatInput: false,
                          keyboardType: const TextInputType.numberWithOptions(
                              signed: true, decimal: false),
                          inputBorder: InputBorder.none,
                          onSaved: (PhoneNumber number) {},
                          onFieldSubmitted: (value) {
                            FocusScope.of(context).unfocus();
                          },
                          onSubmit: () {
                            FocusScope.of(context).unfocus();
                          },
                        ),
                      ),
                    ),
                  ),
                  TextFieldWidget(
                    controller: astromallController.flatNoController,
                    labelText: 'Flat number',
                    keyboardType: TextInputType.number,
                  ),
                  TextFieldWidget(
                    controller: astromallController.localityController,
                    labelText: 'Locality',
                  ),
                  TextFieldWidget(
                    controller: astromallController.landmarkController,
                    labelText: 'Landmark',
                  ),
                  TextFieldWidget(
                    controller: astromallController.cityController,
                    labelText: 'City',
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                  ),
                  TextFieldWidget(
                    controller: astromallController.stateController,
                    labelText: 'State/Province',
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                  ),
                  TextFieldWidget(
                    controller: astromallController.countryController,
                    labelText: 'Country',
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                  ),
                  TextFieldWidget(
                    controller: astromallController.pinCodeController,
                    labelText: 'Pincode',
                    keyboardType: TextInputType.number,
                    maxlen: 6,
                  ),
                ],
              );
            }),
          ),
        ),
        bottomSheet:
            GetBuilder<AstromallController>(builder: (astromallController) {
          return CustomBottomButton(
            title: 'Continue',
            onTap: () async {
              bool isvalid = astromallController.isValidData();
              if (!isvalid) {
                global.showToast(
                  message: astromallController.errorText,
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              } else {
                global.showOnlyLoaderDialog(context);
                if (id != null) {
                  await astromallController.updateUserAddress(id!);
                  await astromallController.getUserAddressData(
                      global.sp!.getInt("currentUserId") ?? 0);
                } else {
                  await astromallController
                      .addAddress(global.sp!.getInt("currentUserId") ?? 0);
                  await astromallController.getUserAddressData(
                      global.sp!.getInt("currentUserId") ?? 0);
                }
                global.hideLoader();
                Get.back();
              }
            },
          );
        }),
      ),
    );
  }
}
