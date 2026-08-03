// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:AstrowayCustomer/controllers/dropDownController.dart';

class DropDownWidgetWithCheckbox extends StatelessWidget {
  final List<String> item;
  final String? hint;
  final callId;
  DropDownWidgetWithCheckbox(
      {Key? key, required this.item, this.hint, this.callId})
      : super(key: key);

  final dropDownController = Get.find<DropDownController>();
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DropDownController>(builder: (dropDownController) {
      final currentValue = dropDownController.innitialValue(callId, item);
      final isValidValue = item.contains(currentValue);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dropdown
          dropDownController.isTextFieldVisible
              ? Container(
                  constraints: BoxConstraints(
                    minHeight: 6.5.h,
                  ),
                  child: TextFormField(
                    maxLength: 50,
                    maxLines: 3,
                    controller: textController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade600, width: 1.0),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      fillColor: Colors.grey,
                      hintText: tr('Enter Your Concern'),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),
                      //make hint text
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onChanged: (value) {
                      log('concern enter is   $value');
                      dropDownController.topic = value;
                    },
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(bottom: 0),
                  child: DropdownButton<String>(
                    dropdownColor: Colors.white,
                    isExpanded: true,
                    underline: Container(
                      height: 1,
                      color: Get.theme.primaryColor,
                    ),
                    value: isValidValue ? currentValue : null,
                    //value: dropDownController.innitialValue(callId, item),
                    // value: dropDownController.topic,
                    hint: Text(hint ?? 'Select a value'),
                    items: item.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Center(
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              value,
                              style: Get.theme.primaryTextTheme.bodyLarge,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      dropDownController.topicChoose(value);
                    },
                  ),
                ),

          Row(
            children: [
              Checkbox(
                value: dropDownController.isTextFieldVisible,
                onChanged: (value) {
                  dropDownController.isTextFieldVisible = value!;
                  if (dropDownController.isTextFieldVisible) {
                    dropDownController.topic = '';
                  }
                  dropDownController.update();
                },
              ),
            ],
          ),
        ],
      );
    });
  }
}
