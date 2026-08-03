// ignore_for_file: unused_local_variable, unrelated_type_equality_checks, deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/search_controller.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/userProfileController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/views/placeOfBrithSearchScreen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:AstrowayCustomer/widget/customElevatedbtn.dart';
import 'package:AstrowayCustomer/widget/textFieldLabelWidget.dart';
import 'package:AstrowayCustomer/widget/textFieldWidget.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../utils/images.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class EditUserProfile extends StatelessWidget {
  EditUserProfile({Key? key}) : super(key: key);
  final userProfileController = Get.find<UserProfileController>();
  final searchController = Get.find<SearchControllerCustom>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          title: Text('Profile', style: TextStyle(color: Colors.white)).tr(),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
            child: Container(
          decoration: scafdecoration,
          padding:
              EdgeInsets.only(top: 3.h, left: 4.w, right: 4.w, bottom: 5.h),
          child: GetBuilder<UserProfileController>(
              builder: (userProfileController) {
            log("User profile image for the update profile ${userProfileController.profile}");
            return Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      userProfileController.userFile != null &&
                              userProfileController.userFile != ''
                          ? Container(
                              height: 15.h,
                              width: 15.h,
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                  color: Get.theme.primaryColor,
                                  image: DecorationImage(
                                    image: FileImage(
                                        userProfileController.userFile!),
                                    fit: BoxFit.cover,
                                  )),
                            )
                          : userProfileController.profile != ""
                              ? Container(
                                  height: 15.h,
                                  width: 15.h,
                                  padding: EdgeInsets.all(1),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                      color: Get.theme.primaryColor,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            "${userProfileController.profile}"),
                                        fit: BoxFit.cover,
                                      )),
                                )
                              : GetBuilder<SplashController>(
                                  builder: (splashController) {
                                  log("from splash User profile ${userProfileController.profile}");
                                  return Container(
                                      width: 15.h,
                                      padding: EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Get.theme.primaryColor),
                                      ),
                                      alignment: Alignment.center,
                                      child: userProfileController
                                                      .splashController
                                                      .currentUser
                                                      ?.profile ==
                                                  "" ||
                                              userProfileController
                                                      .splashController
                                                      .currentUser
                                                      ?.profile ==
                                                  null
                                          ? CircleAvatar(
                                              radius: 7.h,
                                              backgroundColor: whiteColor,
                                              child: Image.asset(
                                                Images.deafultUser,
                                                fit: BoxFit.fill,
                                                height: 10.h,
                                              ))
                                          : Container(
                                              height: 15.h,
                                              width: 15.h,
                                              padding: EdgeInsets.all(1),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Get
                                                          .theme.primaryColor),
                                                  color: Get.theme.primaryColor,
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${userProfileController.splashController.currentUser?.profile}"),
                                                    fit: BoxFit.cover,
                                                  ))));
                                }),
                      Positioned(
                          bottom: 2,
                          right: 3,
                          child: GestureDetector(
                            onTap: () async {
                              await userProfileController.getZodicImg();
                              Get.defaultDialog(
                                  backgroundColor: Colors.white,
                                  titlePadding: EdgeInsets.only(top: 15),
                                  contentPadding: EdgeInsets.all(0),
                                  title: tr("Upload from Phone"),
                                  titleStyle: Get.theme.textTheme.bodyMedium!
                                      .copyWith(fontSize: 17.sp),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: 15),
                                      SizedBox(
                                        width: Get.width,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    userProfileController
                                                            .imageFile =
                                                        await userProfileController
                                                            .imageService(
                                                                ImageSource
                                                                    .camera);
                                                    userProfileController
                                                            .userFile =
                                                        userProfileController
                                                            .imageFile;
                                                    userProfileController
                                                            .profile =
                                                        base64.encode(
                                                            userProfileController
                                                                .imageFile!
                                                                .readAsBytesSync());
                                                    userProfileController
                                                        .update();
                                                    Get.back();
                                                  },
                                                  icon: Icon(
                                                    CupertinoIcons.camera,
                                                    size: 40,
                                                    color: Colors.redAccent,
                                                  ),
                                                ),
                                                Text('Camera',
                                                        style: Get.textTheme
                                                            .bodySmall)
                                                    .tr()
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                IconButton(
                                                  onPressed: () async {
                                                    userProfileController
                                                            .imageFile =
                                                        await userProfileController
                                                            .imageService(
                                                                ImageSource
                                                                    .gallery);
                                                    userProfileController
                                                            .userFile =
                                                        userProfileController
                                                            .imageFile;
                                                    userProfileController
                                                            .profile =
                                                        base64.encode(
                                                            userProfileController
                                                                .imageFile!
                                                                .readAsBytesSync());
                                                    userProfileController
                                                        .update();
                                                    Get.back();
                                                  },
                                                  icon: Icon(
                                                    Icons.picture_in_picture,
                                                    size: 40,
                                                    color:
                                                        Colors.deepPurpleAccent,
                                                  ),
                                                ),
                                                Text(
                                                  ' Gallery',
                                                  style:
                                                      Get.textTheme.bodySmall,
                                                  textAlign: TextAlign.center,
                                                ).tr()
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ));
                            },
                            child: Container(
                                padding: EdgeInsets.all(1.w),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Get.theme.primaryColor),
                                    shape: BoxShape.circle,
                                    color: whiteColor),
                                child: Image.asset(
                                  "assets/images/edit_profile.png",
                                  height: 3.h,
                                  color: Get.theme.primaryColor,
                                )),
                          )),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    userProfileController.splashController.currentUser!.email
                                    .toString() ==
                                "" ||
                            userProfileController
                                    .splashController.currentUser!.email
                                    .toString() ==
                                "null"
                        ? SizedBox()
                        : Center(
                            child: Text(
                                'email:- ${userProfileController.splashController.currentUser!.email}')),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: userProfileController.zodicData.length,
                        itemBuilder: (context, i) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    userProfileController.profile =
                                        userProfileController
                                            .zodicData[i].image;
                                    userProfileController.isImgSelectFromList =
                                        true;
                                    userProfileController.update();
                                  },
                                  child: Container(
                                    height: 50,
                                    width: 50,
                                    padding: EdgeInsets.all(2.w),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Get.theme.primaryColor)),
                                    child: CommonCachedNetworkImage(
                                      borderRadius: 100.w,
                                      imageUrl:
                                          '$websiteUrl${userProfileController.zodicData[i].image}',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  userProfileController.zodicData[i].title,
                                  style: Get.textTheme.bodySmall,
                                ).tr(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 0.5, color: Colors.blueAccent.shade100),
                          borderRadius: BorderRadius.circular(4.w)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Personal Details",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueAccent,
                                ),
                              ).tr(),
                              Container(
                                  height: 30,
                                  width: 30,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      color:
                                          Colors.blueAccent.withOpacity(0.3)),
                                  child: Icon(CupertinoIcons.person,
                                      size: 18, color: Colors.blueAccent))
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFieldWidget(
                            controller: userProfileController.nameController,
                            focusNode: userProfileController.nameFocus,
                            labelText: 'Full Name',
                            keyboardType: TextInputType.name,
                            inputFormatter: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[a-zA-Z ]")),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 3.w),
                                child: TextFieldLabelWidget(
                                  label: 'Gender:',
                                ),
                              ),
                              SizedBox(width: 15),
                              Row(
                                children: [
                                  Radio(
                                    value: "Male",
                                    groupValue: userProfileController.gender,
                                    activeColor: Get.theme.primaryColor,
                                    onChanged: (value) {
                                      userProfileController
                                          .updateGeneder(value);
                                    },
                                  ),
                                  Text(
                                    "Male",
                                    style: TextStyle(fontSize: 12),
                                  ).tr(),
                                ],
                              ),
                              SizedBox(width: 10),
                              Row(
                                children: [
                                  Radio(
                                    value: "Female",
                                    groupValue: userProfileController.gender,
                                    activeColor: Get.theme.primaryColor,
                                    onChanged: (value) {
                                      userProfileController
                                          .updateGeneder(value);
                                    },
                                  ),
                                  Text(
                                    "Female",
                                    style: TextStyle(fontSize: 12),
                                  ).tr(),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          userProfileController
                                          .splashController.currentUser!.email
                                          .toString() ==
                                      "" ||
                                  userProfileController
                                          .splashController.currentUser!.email
                                          .toString() ==
                                      "null"
                              ? SizedBox()
                              : TextFieldWidget(
                                  controller:
                                      userProfileController.emailController,
                                  labelText: 'Email',
                                  focusNode: userProfileController.emailFocus,
                                ),
                          userProfileController.splashController.currentUser!
                                      .contactNo ==
                                  null
                              ? SizedBox()
                              : TextFieldWidget(
                                  readyOnly: true,
                                  controller:
                                      userProfileController.mobileController,
                                  labelText: 'Contact Number',
                                  //focusNode: userProfileController.emailFocus,
                                ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 0.5, color: Colors.green.shade300),
                          borderRadius: BorderRadius.circular(4.w)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Birth Details",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ).tr(),
                              Container(
                                  height: 30,
                                  width: 30,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.green),
                                      color: Colors.green.withOpacity(0.3)),
                                  child: Icon(CupertinoIcons.calendar,
                                      size: 15, color: Colors.green))
                            ],
                          ),
                          SizedBox(height: 15),
                          InkWell(
                            onTap: () async {
                              userProfileController.nameFocus.unfocus();
                              var datePicked =
                                  await DatePicker.showSimpleDatePicker(
                                context,
                                initialDate:
                                    userProfileController.dateController.text ==
                                            "null"
                                        ? DateTime(1995)
                                        : DateTime(
                                            int.parse(userProfileController
                                                .dateController.text
                                                .split("-")
                                                .last),
                                            int.parse(userProfileController
                                                .dateController.text
                                                .split("-")[1]),
                                            int.parse(userProfileController
                                                .dateController.text
                                                .split("-")
                                                .first)),
                                firstDate: DateTime(1920),
                                lastDate: DateTime.now(),
                                dateFormat: "dd-MM-yyyy",
                                itemTextStyle: Get.theme.textTheme.titleMedium!
                                    .copyWith(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0,
                                        color: Colors.black),
                                titleText: 'Select Birth Date',
                                textColor: Get.theme.primaryColor,
                              );
                              if (datePicked != null) {
                                userProfileController.dateController.text =
                                    formatDate(
                                        datePicked, [dd, '-', mm, '-', yyyy]);
                                userProfileController.pickedDate = datePicked;
                                userProfileController.update();
                              } else {
                                print("cancel pressed");
                                print(
                                    '${userProfileController.dateController.text}');
                                if (userProfileController.dateController.text !=
                                    "null") {
                                  userProfileController.dateController.text =
                                      formatDate(
                                          DateTime(
                                              int.parse(userProfileController
                                                  .dateController.text
                                                  .split("-")
                                                  .last),
                                              int.parse(userProfileController
                                                  .dateController.text
                                                  .split("-")[1]),
                                              int.parse(userProfileController
                                                  .dateController.text
                                                  .split("-")
                                                  .first)),
                                          [dd, '-', mm, '-', yyyy]);
                                  userProfileController.pickedDate =
                                      DateTime(1994);
                                  userProfileController.update();
                                } else {
                                  userProfileController.dateController.text =
                                      formatDate(DateTime(1994),
                                          [dd, '-', mm, '-', yyyy]);
                                  userProfileController.pickedDate =
                                      DateTime(1994);
                                  userProfileController.update();
                                }
                              }
                            },
                            child: IgnorePointer(
                              child: TextFieldWidget(
                                controller:
                                    userProfileController.dateController,
                                labelText: 'Date of Birth',
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              userProfileController.nameFocus.unfocus();
                              final format = DateFormat("hh:mm a");
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
                                final now = new DateTime.now();
                                final dt = DateTime(now.year, now.month,
                                    now.day, tod.hour, tod.minute);
                                final format = DateFormat.jm(); //"6:00 AM"
                                return format.format(dt);
                              }

                              if (time != null) {
                                userProfileController.timeController.text =
                                    formatTimeOfDay(time);
                              } else {
                                userProfileController.timeController.text =
                                    formatTimeOfDay(
                                        TimeOfDay(hour: 12, minute: 30));
                              }
                            },
                            child: IgnorePointer(
                              child: TextFieldWidget(
                                controller:
                                    userProfileController.timeController,
                                labelText: 'Time of Birth',
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              userProfileController.nameFocus.unfocus();
                              Get.to(() => PlaceOfBirthSearchScreen(
                                    flagId: 3,
                                  ));
                            },
                            child: IgnorePointer(
                              child: TextFieldWidget(
                                controller:
                                    userProfileController.placeBirthController,
                                labelText: tr('Place of Birth'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              width: 0.5, color: Colors.redAccent.shade100),
                          borderRadius: BorderRadius.circular(4.w)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Address Details",
                                style: Get.textTheme.bodyLarge!.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.redAccent,
                                ),
                              ).tr(),
                              Container(
                                  height: 30,
                                  width: 30,
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border:
                                          Border.all(color: Colors.redAccent),
                                      color: Colors.redAccent.withOpacity(0.3)),
                                  child: Icon(CupertinoIcons.location_north,
                                      size: 15, color: Colors.redAccent))
                            ],
                          ),
                          SizedBox(height: 15),
                          TextFieldWidget(
                            controller:
                                userProfileController.currentAddressController,
                            labelText: 'Current Address',
                            focusNode: userProfileController.currentAddFocus,
                          ),
                          InkWell(
                            onTap: () {
                              userProfileController.nameFocus.unfocus();
                              userProfileController.currentAddFocus.unfocus();
                              Get.to(() => PlaceOfBirthSearchScreen(
                                    flagId: 4,
                                  ));
                            },
                            child: IgnorePointer(
                              child: TextFieldWidget(
                                controller:
                                    userProfileController.addressController,
                                labelText: 'City,State,Country',
                              ),
                            ),
                          ),
                          TextFieldWidget(
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: userProfileController.pinController,
                            labelText: 'Pincode',
                            maxlen: 6,
                            keyboardType: TextInputType.numberWithOptions(
                                decimal: false, signed: true),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 70,
                    )
                  ],
                ),
              ],
            );
          }),
        )),
        bottomSheet: Container(
          color: whiteColor,
          padding: const EdgeInsets.all(10),
          child: GetBuilder<UserProfileController>(
              builder: (userProfileController) {
            return CustomElevatedButton(
              borderRadius: 30.w,
              width: double.infinity,
              text: 'Submit',
              onPressed: () async {
                bool isvalid = userProfileController.isValidData();
                log("isvalidated=> ${isvalid.toString()}");
                if (!isvalid) {
                  global.showToast(
                    message: userProfileController.toastMessage,
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                } else {
                  global.showOnlyLoaderDialog(context);
                  searchController.update();
                  await userProfileController.updateCurrentUser(
                      global.sp!.getInt("currentUserId") ?? 0);
                  global.hideLoader();
                }
              },
            );
          }),
        ),
      ),
    );
  }
}
