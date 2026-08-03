// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/IntakeController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/placeOfBrithSearchScreen.dart';
import 'package:AstrowayCustomer/widget/customBottomButton.dart';
import 'package:AstrowayCustomer/widget/textFieldLabelWidget.dart';
import 'package:AstrowayCustomer/widget/textFieldWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/dropDownController.dart';
import '../controllers/walletController.dart';
import '../utils/date_converter.dart';
import '../widget/drodownWidget.dart';
import 'addMoneyToWallet.dart';

class CallIntakeFormScreen extends StatefulWidget {
  String bookingType;
  final reportType;
  final String astrologerName;
  final int astrologerId;
  final String type;
  final String astrologerProfile;
  final bool? isFreeAvailable;
  dynamic rate;

  CallIntakeFormScreen(
      {Key? key,
      this.reportType,
      this.isFreeAvailable = false,
      this.bookingType = "instant",
      required this.astrologerName,
      required this.astrologerId,
      required this.type,
      required this.astrologerProfile,
      required this.rate,
      x})
      : super(key: key);

  @override
  State<CallIntakeFormScreen> createState() => _CallIntakeFormScreenState();
}

class _CallIntakeFormScreenState extends State<CallIntakeFormScreen> {
  final splashController = Get.find<SplashController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final callIntakeController = Get.find<IntakeController>();
  final walletController = Get.find<WalletController>();
  final callController = Get.find<CallController>();
  final chatController = Get.find<ChatController>();
  final dropDownController = Get.find<DropDownController>();
  List time = [5, 10, 15, 20, 25, 30];
  int selectTime = 0;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text('${widget.type} ${tr("Intake Form")}').tr(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: GetBuilder<IntakeController>(builder: (callIntakeController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ///if user has selected schedule appinment
                if (widget.bookingType == "schedule") ...[
                  const SizedBox(height: 15),
                  Text(
                    "Select Appointment Date & Time",
                    style: Get.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Date Picker
                  TextFieldWidget(
                    controller: callIntakeController.appointmentDateController,
                    labelText: "Appointment Date",
                    readyOnly: true, // ✅ correct spelling
                    suffixIcon: const Icon(Icons.calendar_today, size: 18),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );

                      if (pickedDate != null) {
                        // ✅ Show in UI (dd-MM-yyyy)
                        callIntakeController.appointmentDateController.text =
                            DateFormat('dd-MM-yyyy').format(pickedDate);

                        // ✅ Save API format (yyyy-MM-dd)
                        callIntakeController.scheduleDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);

                        print(
                            "UI Date: ${callIntakeController.appointmentDateController.text}");
                        print("API Date: ${callIntakeController.scheduleDate}");
                      }
                    },
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Time Picker
                  TextFieldWidget(
                    controller: callIntakeController.appointmentTimeController,
                    labelText: "Appointment Time",
                    readyOnly: true,
                    suffixIcon: const Icon(Icons.access_time, size: 18),
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        // ✅ Show in 12-hour format for UI
                        callIntakeController.appointmentTimeController.text =
                            pickedTime.format(context);

                        // ✅ Convert to 24-hour format for API
                        final now = DateTime.now();
                        final dateTime = DateTime(
                          now.year,
                          now.month,
                          now.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        // Format to "HH:mm" (24-hour without seconds)
                        final apiTime = DateFormat('HH:mm').format(dateTime);

                        print(
                            "UI Time: ${callIntakeController.appointmentTimeController.text}");
                        print("API Time: $apiTime");

                        callIntakeController.scheduleTime =
                            apiTime; // store API-ready time
                      }
                    },
                  ),
                ],

                // --- Section: Personal Info ---
                Text(
                  tr("Personal Information"),
                  style: Get.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 5),
                _buildCard([
                  TextFieldWidget(
                    controller: callIntakeController.nameController,
                    focusNode: callIntakeController.namefocus,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                    labelText: 'Name',
                  ),
                  buildPhoneField(callIntakeController, context),
                  _buildGenderSelector(callIntakeController),
                ]),

                const SizedBox(height: 10),

                // --- Section: Birth Details ---
                Text(
                  tr("Birth Details"),
                  style: Get.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 10),

                _buildCard([
                  _buildDobField(callIntakeController, context),
                  const SizedBox(height: 12),
                  _buildBirthTimeField(callIntakeController, context),
                  const SizedBox(height: 12),
                  _buildPlaceOfBirthField(callIntakeController),
                ]),

                const SizedBox(height: 20),

                // --- Section: Additional Info ---
                Text(
                  tr("Additional Information"),
                  style: Get.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[800],
                  ),
                ),
                const SizedBox(height: 10),

                _buildCard([
                  TextFieldLabelWidget(label: 'Marital Status (Optional)'),
                  DropDownWidget(
                    item: [
                      'single',
                      'Married',
                      'Divorced',
                      'Separated',
                      'Widowed'
                    ],
                    hint: tr('Select Marital Status'),
                    callId: 1,
                  ),
                  const SizedBox(height: 10),
                  TextFieldWidget(
                    controller: callIntakeController.ocupationController,
                    focusNode: callIntakeController.occupationfocus,
                    labelText: 'Occupation (Optional)',
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]"))
                    ],
                  ),
                ]),

                const SizedBox(height: 20),

                // --- Section: Consultation ---
                if (widget.isFreeAvailable != true) ...[
                  Text(
                    tr("Consultation Details"),
                    style: Get.textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildCard([
                    Text("How Many Minutes you want to talk?").tr(),
                    const SizedBox(height: 8),
                    _buildTimeSelector(),
                  ]),
                ],

                const SizedBox(height: 20),

                // --- Section: Topic ---
                TextFieldLabelWidget(label: 'Topic of Concern'),
                DropDownWidget(
                  item: ['Study', 'Future', 'Past'],
                  hint: tr('Select Topic of Concern'),
                  callId: 3,
                ),

                const SizedBox(height: 20),

                // --- Partner Details ---
                _buildPartnerDetails(callIntakeController),

                const SizedBox(height: 80),
              ],
            );
          }),
        ),
        bottomSheet: GetBuilder<IntakeController>(builder: (intakeController) {
          return GetBuilder<ChatController>(
            builder: (chatcontroller) => CustomBottomButton(
              onTap: () async {
                print("${widget.bookingType}");
                // your existing bottom button logic (unchanged)
                if (widget.bookingType == "schedule") {
                  print(
                      "widget.bookingType:- ${widget.bookingType}${callIntakeController.appointmentDateController.text}");
                  if (callIntakeController
                      .appointmentDateController.text.isNotEmpty) {
                    await _onSubmit(intakeController, chatcontroller, context);
                  } else {
                    Fluttertoast.showToast(msg: "Select Date and Time");
                  }
                } else {
                  await _onSubmit(intakeController, chatcontroller, context);
                }
              },
              title:
                  '${tr("Start")} ${widget.type} ${tr("with")} ${widget.astrologerName}',
            ),
          );
        }),
      ),
    );
  }

  dialogForchat(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          child: WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: AlertDialog(
              surfaceTintColor: Colors.white,
              insetPadding: EdgeInsets.symmetric(horizontal: 1.w),
              backgroundColor: Colors.white,
              contentPadding: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              title: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(1.w),
                    child: Center(
                      child: Text(
                        "You're all set!",
                        style: Get.theme.textTheme.displayLarge!.copyWith(
                          color: Colors.black,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal,
                        ),
                      ).tr(),
                    ),
                  ),
                  SizedBox(height: 4),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                backgroundColor: Get.theme.primaryColor,
                                child: CachedNetworkImage(
                                    imageUrl:
                                        '${splashController.currentUser!.profile}',
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage: imageProvider,
                                        ),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage:
                                              AssetImage(Images.deafultUser),
                                        )),
                              ),
                              SizedBox(height: 2),
                              Text(
                                splashController.currentUser!.name!.isEmpty
                                    ? "User"
                                    : "${splashController.currentUser!.name}",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                          Center(
                            child: Text(
                              "••••",
                              style: TextStyle(
                                color: Colors.pink.shade400,
                                fontSize: 30.sp,
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                backgroundColor: Get.theme.primaryColor,
                                child: CachedNetworkImage(
                                    imageUrl: '${widget.astrologerProfile}',
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage: imageProvider,
                                        ),
                                    placeholder: (context, url) => const Center(
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage:
                                              AssetImage(Images.deafultUser),
                                        )),
                              ),
                              SizedBox(height: 2),
                              Text(
                                "${widget.astrologerName}",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ).tr(),
                            ],
                          ),
                        ],
                      )),
                  // Rest of your content
                  SizedBox(height: 4),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.w),
                      border: Border.all(color: Colors.grey, width: 0.3),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(2.w),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4.w),
                              topRight: Radius.circular(4.w),
                            ),
                            border: Border.all(color: Colors.grey, width: 0.5),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "What's Next! ",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 2),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.symmetric(horizontal: 2.w),
                                child: Text(
                                  'You will connect with ${widget.astrologerName} after the astrologer accepts your request',
                                  style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black),
                                ).tr(),
                              ),
                              SizedBox(height: 2),
                            ])
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.w),
                            side: BorderSide(color: Colors.pink.shade200),
                          ),
                          shadowColor: Colors.transparent,
                        ),
                        child: Text(
                          'OK',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                          ),
                        ).tr(),
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actionsPadding:
                  const EdgeInsets.only(bottom: 15, left: 15, right: 15),
            ),
          ),
        );
      },
    );
  }

  // 🔹 Card wrapper for grouped sections
  Widget _buildCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildPhoneField(
      IntakeController callIntakeController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Theme(
        data: ThemeData(
          dialogTheme: DialogThemeData(
            contentTextStyle: const TextStyle(color: Colors.white),
            backgroundColor: Colors.grey[800],
            surfaceTintColor: Colors.grey[800],
          ),
        ),
        child: InternationalPhoneNumberInput(
          textFieldController: callIntakeController.phoneController,
          inputDecoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Phone number',
            hintStyle: TextStyle(
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
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Colors.white),
            ),
            hintText: "Search",
            hintStyle: const TextStyle(
              color: Colors.black,
            ),
          ),
          initialValue: PhoneNumber(isoCode: 'IN'),
          formatInput: false,
          keyboardType: const TextInputType.numberWithOptions(
              signed: true, decimal: false),
          inputBorder: InputBorder.none,
          onSaved: (PhoneNumber number) {
            callIntakeController.updateCountryCode(number.dialCode);
          },
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

// 🔹 Gender selection
  Widget _buildGenderSelector(IntakeController callIntakeController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Radio<String>(
          value: "Male",
          groupValue: callIntakeController.gender,
          onChanged: (val) => callIntakeController.updateGeneder(val!),
        ),
        Text("Male"),
        SizedBox(width: 25),
        Radio<String>(
          value: "Female",
          groupValue: callIntakeController.gender,
          onChanged: (val) => callIntakeController.updateGeneder(val!),
        ),
        Text("Female"),
      ],
    );
  }

// 🔹 Date of Birth Field
  Widget _buildDobField(
      IntakeController callIntakeController, BuildContext context) {
    return InkWell(
      onTap: () async {
        callIntakeController.namefocus.unfocus();
        callIntakeController.phonefocus.unfocus();
        var datePicked = await DatePicker.showSimpleDatePicker(
          context,
          initialDate: DateTime(1994),
          firstDate: DateTime(1920),
          lastDate: DateTime.now(),
          dateFormat: "dd-MM-yyyy",
          itemTextStyle: Get.theme.textTheme.titleMedium!.copyWith(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w400,
            letterSpacing: 0,
          ),
          titleText: tr('Select Birth Date'),
          textColor: Get.theme.primaryColor,
        );
        if (datePicked != null) {
          callIntakeController.dobController.text =
              DateConverter.isoStringToLocalDateOnly(
                  datePicked.toIso8601String());
          callIntakeController.selctedDate = datePicked;
          callIntakeController.update();
        } else {
          callIntakeController.dobController.text =
              DateConverter.isoStringToLocalDateOnly(
                  DateTime(1994).toIso8601String());
          callIntakeController.selctedDate = DateTime(1994);
          callIntakeController.update();
        }
      },
      child: IgnorePointer(
        child: TextFieldWidget(
          controller: callIntakeController.dobController,
          labelText: 'Date of Birth',
          suffixIcon: const Icon(Icons.calendar_today, size: 18),
        ),
      ),
    );
  }

// 🔹 Birth Time Field
  Widget _buildBirthTimeField(
      IntakeController callIntakeController, BuildContext context) {
    return InkWell(
      onTap: () async {
        callIntakeController.namefocus.unfocus();
        callIntakeController.phonefocus.unfocus();
        final time = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(hour: 12, minute: 30),
            builder: (context, child) {
              return Theme(
                data: ThemeData(
                  colorScheme: ColorScheme.light(
                    primary: Get.theme.primaryColor,
                    onSurface: Colors.black,
                  ),
                ),
                child: child ?? SizedBox(),
              );
            });
        String formatTimeOfDay(TimeOfDay tod) {
          final now = DateTime.now();
          final dt =
              DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
          final format = DateFormat('hh:mm a'); // Explicit 12-hour format
          return format.format(dt);
        }

        if (time != null) {
          callIntakeController.birthTimeController.text = formatTimeOfDay(time);
        }
      },
      child: IgnorePointer(
        child: TextFieldWidget(
          controller: callIntakeController.birthTimeController,
          labelText: 'Birth Time',
          suffixIcon: const Icon(Icons.access_time, size: 18),
        ),
      ),
    );
  }

  Widget _buildPlaceOfBirthField(IntakeController callIntakeController) {
    return TextFieldWidget(
      controller: callIntakeController.placeController,
      labelText: 'Place of Birth',
      readyOnly: true,
      onTap: () {
        callIntakeController.namefocus.unfocus();
        callIntakeController.phonefocus.unfocus();
        Get.to(() => PlaceOfBirthSearchScreen(flagId: 5));
      },
    );
  }

// 🔹 Time Selector (Consultation minutes)
  Widget _buildTimeSelector() {
    return Wrap(
      spacing: 15,
      runSpacing: 10,
      children: time.asMap().entries.map((entry) {
        final index = entry.key;
        final minutes = entry.value;

        return ChoiceChip(
          label: Text("$minutes min"),
          selected: selectTime == index, // ✅ only one selected at a time
          selectedColor: Get.theme.primaryColor,
          backgroundColor: Colors.grey[200],
          labelStyle: TextStyle(
            color: selectTime == index ? Colors.white : Colors.black,
            fontWeight: FontWeight.w500,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: (_) {
            setState(() {
              selectTime = index; // ✅ update your existing state
            });
          },
        );
      }).toList(),
    );
  }

// 🔹 Partner Details Section
  Widget _buildPartnerDetails(IntakeController callIntakeController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.blueGrey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blueGrey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Add Partner's Details",
                style: Get.textTheme.titleMedium!.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueGrey[800],
                ),
              ),
              Switch(
                value: callIntakeController.isEnterPartnerDetails,
                activeThumbColor: Get.theme.primaryColor,
                inactiveTrackColor: Colors.black,
                onChanged: (bool value) {
                  callIntakeController
                      .partnerDetails(value); // ✅ your existing method
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Show only when enabled
        if (callIntakeController.isEnterPartnerDetails)
          _buildCard([
            TextFieldWidget(
              controller: callIntakeController.partnerNameController,
              focusNode: callIntakeController.partnerNamefocus,
              labelText: "Partner Name",
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () async {
                var datePicked = await DatePicker.showSimpleDatePicker(
                  Get.context!,
                  initialDate: DateTime(1994),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                  dateFormat: "dd-MM-yyyy",
                  titleText: tr("Select Partner's Birth Date"),
                  textColor: Get.theme.primaryColor,
                );
                if (datePicked != null) {
                  callIntakeController.partnerDobController.text =
                      DateConverter.isoStringToLocalDateOnly(
                          datePicked.toIso8601String());
                  callIntakeController.selctedPartnerDate = datePicked;
                  callIntakeController.update();
                }
              },
              child: IgnorePointer(
                child: TextFieldWidget(
                  controller: callIntakeController.partnerDobController,
                  labelText: "Partner Date of Birth",
                  suffixIcon: const Icon(Icons.calendar_today, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 10),
            InkWell(
              onTap: () {
                Get.to(() => PlaceOfBirthSearchScreen(flagId: 6));
              },
              child: IgnorePointer(
                child: TextFieldWidget(
                  controller: callIntakeController.partnerPlaceController,
                  labelText: "Partner Place of Birth",
                ),
              ),
            ),
          ]),
      ],
    );
  }

// 🔹 Bottom Button Logic (reusable)
  Future<void> _onSubmit(
    IntakeController intakeController,
    ChatController chatController,
    BuildContext context,
  ) async {
    double charge = double.parse(widget.rate.toString());
    if (charge * time[selectTime] <=
            global.splashController.currentUser!.walletAmount! ||
        bottomNavigationController.astrologerbyId[0].isFreeAvailable == true) {
      bool isvalid = intakeController.isValidData();
      print(isvalid);
      if (!isvalid) {
        global.showToast(
          message: intakeController.errorText,
          textColor: global.textColor,
          bgColor: global.toastBackGoundColor,
        );
      } else {
        if (intakeController.isVarified) {
          global.showOnlyLoaderDialog(context);

          await callIntakeController.addCallIntakeFormData();
          await intakeController.checkFreeSessionAvailable();
          if (widget.isFreeAvailable == true) {
            if (intakeController.isAddNewRequestByFreeuser == true) {
              if (widget.type == "Call" || widget.type == "Videocall") {
                await callController.sendCallRequest(
                    widget.astrologerId,
                    true,
                    widget.type,
                    callIntakeController.freedefaultTime.toString(),
                    widget.bookingType,
                    callIntakeController.scheduleTime.toString(),
                    callIntakeController.scheduleDate.toString());
              } else {
                await chatController.sendMessage(
                    'hi ${widget.astrologerName}  \n\n Below are my details:\n\n'
                        'Name: ${intakeController.nameController.text},\nGender: ${intakeController.gender},\nDOB: ${intakeController.dobController.text},\nTOB: ${intakeController.birthTimeController.text},\nPOB: ${intakeController.placeController.text},\nMarital status: ${dropDownController.maritalStatus ?? "Single"},\nTOPIC: ${dropDownController.topic ?? 'Study'}'
                        '\n\n This is automated message to confirm that chat has started.',
                    '${widget.astrologerId}_${global.currentUserId}',
                    widget.astrologerId,
                    false);

                if (callIntakeController.isEnterPartnerDetails) {
                  await chatController.sendMessage(
                      'Below are my partner details: \n\n'
                          'Name: ${intakeController.partnerNameController.text},\nDOB: ${intakeController.partnerDobController.text},\nTOB: ${intakeController.partnerBirthController.text},\nPOB: ${intakeController.partnerPlaceController.text}'
                          '\n\n This is automated message to confirm that chat has started.'
                          '',
                      '${widget.astrologerId}_${global.currentUserId}',
                      widget.astrologerId,
                      false);
                }
                debugPrint(
                    "on chat req ${global.currentUserId}_${widget.astrologerId}, id ${global.currentUserId}");
                chatController.setOnlineStatus(
                    true,
                    '${global.currentUserId}_${widget.astrologerId}',
                    '${global.currentUserId}');
                await chatController.sendChatRequest(
                    widget.astrologerId,
                    true,
                    callIntakeController.freedefaultTime.toString(),
                    widget.bookingType,
                    callIntakeController.scheduleTime.toString(),
                    callIntakeController.scheduleDate.toString());
              }
            } else {
              global.showToast(
                  message: tr('You can not join multiple offers at same time'),
                  textColor: global.textColor,
                  bgColor: Colors.white);
            }
          } else {
            if (widget.type == "Call" || widget.type == "Videocall") {
              await callController.sendCallRequest(
                  widget.astrologerId,
                  false,
                  widget.type,
                  (int.parse(time[selectTime].toString().split(".").first) * 60)
                      .toString(),
                  widget.bookingType,
                  callIntakeController.scheduleTime.toString(),
                  callIntakeController.scheduleDate.toString());
            } else {
              await chatController.sendMessage(
                  'hi ${widget.astrologerName}  \n\n Below are my details:\n\n'
                      'Name: ${intakeController.nameController.text},\nGender: ${intakeController.gender},\nDOB: ${intakeController.dobController.text},\nTOB: ${intakeController.birthTimeController.text},\nPOB: ${intakeController.placeController.text},\nMarital status: ${dropDownController.maritalStatus ?? "Single"},\nTOPIC: ${dropDownController.topic ?? 'Study'}'
                      '\n\n This is automated message to confirm that chat has started.',
                  '${widget.astrologerId}_${global.currentUserId}',
                  widget.astrologerId,
                  false);

              if (callIntakeController.isEnterPartnerDetails) {
                await chatController.sendMessage(
                    'Below are my partner details: \n\n'
                        'Name: ${intakeController.partnerNameController.text},\nDOB: ${intakeController.partnerDobController.text},\nTOB: ${intakeController.partnerBirthController.text},\nPOB: ${intakeController.partnerPlaceController.text}'
                        '\n\n This is automated message to confirm that chat has started.'
                        '',
                    '${widget.astrologerId}_${global.currentUserId}',
                    widget.astrologerId,
                    false);
              }
              debugPrint(
                  "on chat req ${global.currentUserId}_${widget.astrologerId}, id ${global.currentUserId}");
              chatController.setOnlineStatus(
                  true,
                  '${global.currentUserId}_${widget.astrologerId}',
                  '${global.currentUserId}');
              await chatController.sendChatRequest(
                  widget.astrologerId,
                  false,
                  (int.parse(time[selectTime].toString().split(".").first) * 60)
                      .toString(),
                  widget.bookingType,
                  callIntakeController.scheduleTime.toString(),
                  callIntakeController.scheduleDate.toString());
            }
          }

          print("chat is free:- ${global.freeRequestMinimum}");
          if (global.freeRequestMinimum == true) {
            global.hideLoader();
            Get.showSnackbar(GetSnackBar(
              backgroundColor: Colors.red,
              message:
                  "${chatController.msgisfreechat} min amount required is ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.amountisfreechat}",
              title: tr('Alert!'),
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
              icon: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              mainButton: InkWell(
                onTap: () async {
                  Get.back();

                  await walletController.getAmount();
                  Get.to(() => AddmoneyToWallet());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    tr('Recharge'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              leftBarIndicatorColor: Colors.orange,
            ));
          } else if (global.freeRequestMinimum) {
            global.hideLoader();
            Get.showSnackbar(GetSnackBar(
              backgroundColor: Colors.red,
              message:
                  "${callController.msgisfreechat} min amount required is ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${global.amountisfreecall}",
              title: tr('Alert!'),
              borderRadius: 10,
              margin: EdgeInsets.all(10),
              snackPosition: SnackPosition.TOP,
              icon: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              mainButton: InkWell(
                onTap: () async {
                  Get.back();

                  await walletController.getAmount();
                  Get.to(() => AddmoneyToWallet());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12)),
                  child: Text(
                    tr('Recharge'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              leftBarIndicatorColor: Colors.orange,
            ));
          } else {
            global.hideLoader();

            print("${chatController.requestSuccess}");
            print("mounted:- ${mounted}");
            if (mounted &&
                (chatController.requestSuccess ||
                    callController.requestSuccess)) {
              dialogForchat(context);
            }
          }
        } else {
          global.showToast(
            message: tr('Please verify your phone number'),
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        }
      }
    } else {
      log("ajksndkjnaskjndk");
      await walletController.getAmount();
      global.showMinimumBalancePopup(
          context,
          (charge * time[selectTime]).toString(),
          '${bottomNavigationController.astrologerbyId[0].name}',
          walletController.payment,
          '${widget.type}',
          minimumMin: time[selectTime].toString());
    }
  }
}
