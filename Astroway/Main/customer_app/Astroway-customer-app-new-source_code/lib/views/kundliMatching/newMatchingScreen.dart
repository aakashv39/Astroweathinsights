// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/placeOfBrithSearchScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/kundliMatchingController.dart';
import '../../widget/commonSmallTextFieldWidget.dart';

class NewMatchingScreen extends StatelessWidget {
  NewMatchingScreen({Key? key}) : super(key: key);
  final kundliMatchingController = Get.find<KundliMatchingController>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GetBuilder<KundliMatchingController>(
          init: kundliMatchingController,
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
//-------------------------------------------Boys Details -----------------------------------------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.male_rounded,
                                color: const Color(0xFF1500FF),
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Boy's Details",
                                style: Get.theme.primaryTextTheme.titleMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                  fontSize: 20,
                                ),
                              ).tr(),
                            ],
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cBoysName,
                            titleText: "Name",
                            hintText: "Enter Name",
                            keyboardType: TextInputType.text,
                            preFixIcon: CupertinoIcons.person_alt_circle,
                            maxLines: 1,
                            onFieldSubmitted: (p0) {},
                            onTap: () {},
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]")),
                            ],
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cBoysBirthDate,
                            titleText: "Birth Date",
                            hintText: "Select Your Birth Date",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: CupertinoIcons.calendar,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _boySelectDate(context);
                            },
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cBoysBirthTime,
                            titleText: "Birth Time",
                            hintText: "Select Your Birth Time",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: CupertinoIcons.time,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _boySelectBirthDateTime(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CommonSmallTextFieldWidget(
                              controller:
                                  kundliMatchingController.cBoysBirthPlace,
                              titleText: "Birth Place",
                              hintText: "Select Your Birth Place",
                              readOnly: true,
                              maxLines: 1,
                              preFixIcon: CupertinoIcons.location_circle,
                              onFieldSubmitted: (p0) {},
                              onTap: () {
                                Get.to(() => PlaceOfBirthSearchScreen(
                                      flagId: 1,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  //----------Girls Details---------
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.female_rounded,
                                color: const Color(0xFFFF0000),
                                size: 30,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                "Girl's Details",
                                style: Get.theme.primaryTextTheme.titleMedium!
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: darkGreen,
                                  fontSize: 20,
                                ),
                              ).tr(),
                            ],
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cGirlName,
                            titleText: "Name",
                            hintText: "Enter Name",
                            keyboardType: TextInputType.text,
                            preFixIcon: CupertinoIcons.person_alt_circle,
                            maxLines: 1,
                            onFieldSubmitted: (p0) {},
                            onTap: () {},
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]")),
                            ],
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cGirlBirthDate,
                            titleText: "Birth Date",
                            hintText: "Select Your Birth Date",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: CupertinoIcons.calendar,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _girlSelectDate(context);
                            },
                          ),
                          CommonSmallTextFieldWidget(
                            controller: kundliMatchingController.cGirlBirthTime,
                            titleText: "Birth Time",
                            hintText: "Select Your Birth Time",
                            readOnly: true,
                            maxLines: 1,
                            preFixIcon: CupertinoIcons.time,
                            onFieldSubmitted: (p0) {},
                            onTap: () {
                              _girlSelectBirthDateTime(context);
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: CommonSmallTextFieldWidget(
                              controller:
                                  kundliMatchingController.cGirlBirthPlace,
                              titleText: "Birth Place",
                              hintText: "Select Your Birth Place",
                              readOnly: true,
                              maxLines: 1,
                              preFixIcon: CupertinoIcons.location_circle,
                              onFieldSubmitted: (p0) {},
                              onTap: () {
                                Get.to(() => PlaceOfBirthSearchScreen(
                                      flagId: 2,
                                    ));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }

  Future _boySelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      kundliMatchingController.onBoyDateSelected(picked);
    }
  }

  void updateBirthTime(
      TimeOfDay pickedTime, BuildContext context, kundliMatchingController) {
    // Manually format the time in 24-hour format (HH:mm)
    String formattedTime = pickedTime.hour.toString().padLeft(2, '0') +
        ':' +
        pickedTime.minute.toString().padLeft(2, '0');

    // Parse the manually formatted time string
    DateTime parsedTime = DateFormat.Hm().parse(formattedTime);

    print("formatted time is $parsedTime"); // Output: 1970-01-01 06:35:00.000
    print(formattedTime); // Output: 06:35

    kundliMatchingController.cBoysBirthTime.text =
        formattedTime; // Set the value of text field
    kundliMatchingController.update();
  }

//Boy Select Birthdate Time
  Future _boySelectBirthDateTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      updateBirthTime(pickedTime, context, kundliMatchingController);
    }
  }

  //Girl Date of Birth
  Future _girlSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      kundliMatchingController.onGirlDateSelected(picked);
    }
  }

  void updateBirthTimeGirls(
      TimeOfDay pickedTime, BuildContext context, kundliMatchingController) {
    // Manually format the time in 24-hour format (HH:mm)
    String formattedTime = pickedTime.hour.toString().padLeft(2, '0') +
        ':' +
        pickedTime.minute.toString().padLeft(2, '0');

    // Parse the manually formatted time string
    DateTime parsedTime = DateFormat.Hm().parse(formattedTime);

    print("formatted time is $parsedTime"); // Output: 1970-01-01 06:35:00.000
    print(formattedTime); // Output: 06:35

    kundliMatchingController.cGirlBirthTime.text =
        formattedTime; //set the value of text field.
    kundliMatchingController.update();
  }

//Girl Select Birthdate Time
  Future _girlSelectBirthDateTime(BuildContext context) async {
    TimeOfDay? pickedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            textButtonTheme: TextButtonThemeData(
              style:
                  TextButton.styleFrom(foregroundColor: Get.theme.primaryColor),
            ),
            colorScheme: ColorScheme.light(
              primary: Get.theme.primaryColor,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedTime != null) {
      updateBirthTimeGirls(pickedTime, context, kundliMatchingController);
    } else {
      print("Time is not selected");
    }
  }
}
