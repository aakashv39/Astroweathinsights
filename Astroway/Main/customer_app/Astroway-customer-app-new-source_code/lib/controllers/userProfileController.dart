// ignore_for_file: unnecessary_null_comparison, unnecessary_statements

import 'dart:developer';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../model/dailyHoroscope_model.dart';

class UserProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController placeBirthController = TextEditingController();
  TextEditingController currentAddressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pinController = TextEditingController();
  SplashController splashController = Get.find<SplashController>();
  FocusNode fSearch = new FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode currentAddFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  String toastMessage = "";
  String gender = 'Male';
  bool isShowMore = false;
  String profile = "";
  APIHelper apiHelper = APIHelper();
  DateTime? pickedDate;
  Uint8List? tImage;
  XFile? selectedImage;
  File? imageFile;
  File? userFile;
  var zodicData = <Zodic>[];
  bool isImgSelectFromList = false;
  String selectedListImg = "";

  @override
  void onInit() async {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    Future.wait<void>([
      splashController.getCurrentUserData(),
      getValue(),
    ]);
  }

  onOpenCamera() async {
    selectedImage = await openCamera(Get.theme.primaryColor).obs();
    update();
  }

  String? getFormattedTime(String input) {
    if (input.isEmpty) return null;
    try {
      DateTime parsedTime = DateFormat("HH:mm").parse(input);
      return DateFormat("HH:mm:ss").format(parsedTime);
    } catch (e) {
      return null;
    }
  }

  String? formatDateForServer(String input) {
    if (input.isEmpty) return null;
    try {
      DateTime parsedDate = DateFormat("dd/MM/yyyy").parse(input);
      return DateFormat("yyyy-MM-dd").format(parsedDate);
    } catch (e) {
      return null; // fallback if parsing fails
    }
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('assets/$path');

    final file =
        await File('${(await getApplicationDocumentsDirectory()).path}/$path')
            .create(recursive: true);
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  getValue() async {
    if (splashController.currentUser != null) {
      nameController.text = splashController.currentUser!.name ?? "User";
      emailController.text = splashController.currentUser!.email ?? "";
      mobileController.text = splashController.currentUser!.contactNo ?? "";
      profile = splashController.currentUser!.profile ?? "";
      updateGeneder(splashController.currentUser!.gender ?? "Male");
      splashController.currentUser!.birthDate.toString() != "null"
          ? dateController.text = formatDate(
              splashController.currentUser!.birthDate!,
              [dd, '-', mm, '-', yyyy])
          : null;
      timeController.text = splashController.currentUser!.birthTime ?? "";
      placeBirthController.text =
          splashController.currentUser!.birthPlace ?? "";
      currentAddressController.text =
          splashController.currentUser!.addressLine1 ?? "";
      addressController.text = splashController.currentUser!.location ?? "";
      pinController.text =
          splashController.currentUser!.pincode.toString() == "null"
              ? ""
              : splashController.currentUser!.pincode.toString();
      imageFile = null;
      userFile = null;
      update();
      log('${splashController.currentUser!.pincode.toString()}');
    }
  }

  updateGeneder(value) {
    gender = value;
    update();
  }

  Future<File> imageService(ImageSource imageSource) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? selectedImage = await picker.pickImage(source: imageSource);
      imageFile = File(selectedImage!.path);

      if (selectedImage != null) {
        imageFile;
      }
    } catch (e) {
      print("Exception - businessRule.dart - _openGallery() ${e.toString()}");
    }
    return imageFile!;
  }

  showMoreText() {
    isShowMore = !isShowMore;
    update();
  }

  bool isValidData() {
    if (nameController.text == "") {
      toastMessage = "Please enter your first name";
      update();
      return false;
    } else if (profile == "") {
      toastMessage = "Please add your profile picture";
      update();
      return false;
    } else if (gender == "") {
      toastMessage = "Gender is required";
      update();
      return false;
    } else if (timeController.text == "") {
      toastMessage = "Birth time is required";
      update();
      return false;
    } else if (dateController.text == "") {
      toastMessage = "Date of birth is required";
      update();
      return false;
    } else if (placeBirthController.text == "") {
      toastMessage = "Please enter your place of birth";
      update();
      return false;
    } else if (currentAddressController.text == "") {
      toastMessage = "Please add your address";
      update();
      return false;
    } else if (pinController.text == "") {
      toastMessage = "PIN code is required";
      update();
      return false;
    }
    return true;
  }

  Future<XFile?> openCamera(Color color, {bool isProfile = true}) async {
    try {
      final ImagePicker picker = ImagePicker();
      XFile? _selectedImage =
          await picker.pickImage(source: ImageSource.camera);

      if (_selectedImage != null) {
        print("cropped file :- $_selectedImage");
        return _selectedImage;
      }
    } catch (e) {
      // ignore: avoid_print
      print("Exception - user_profile_controller.dart - openCamera():" +
          e.toString());
    }
    return null;
  }

  Future<void> updateCurrentUser(int id) async {
    var basicDetails = {
      "name": nameController.text,
      "contactNo": splashController.currentUser!.contactNo == null
          ? mobileController.text
          : splashController.currentUser!.contactNo,
      "gender": gender,
      "birthTime": timeController.text == ""
          ? null
          : getFormattedTime(timeController.text),
      "birthDate": pickedDate == null
          ? DateFormat('yyyy-MM-dd').format(
              DateFormat('dd-MM-yyyy').parse(dateController.text),
            )
          : pickedDate!.toIso8601String(),
      "birthPlace":
          placeBirthController.text == "" ? null : placeBirthController.text,
      "addressLine1": currentAddressController.text == ""
          ? null
          : currentAddressController.text,
      "addressLine2": null,
      "location": addressController.text == "" ? null : addressController.text,
      "pincode":
          pinController.text == "" ? null : int.parse(pinController.text),
      "profile": profile == "" ? null : profile,
      "email": emailController.text == ""
          ? splashController.currentUser!.email
          : emailController.text
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          log("My data to Update user body $basicDetails");
          await apiHelper
              .updateUserProfile(id, basicDetails)
              .then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your Profile has been updated',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              global.sp!.setBool("isProfileUpdated", true);
              await splashController.getCurrentUserData();
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to update profile please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in updateUserProfile:-" + e.toString());
    }
  }

  updateCurrentUserProfilepic(String profile) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.updetUserProfilePic(profile).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your Profile pic has been updated',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await splashController.getCurrentUserData();
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to update profile please try again later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in updateUserProfile:-" + e.toString());
    }
  }

  getZodicImg() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getZodiacProfileImg().then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              zodicData = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Fail to Get defualt img!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getZodicImg:-" + e.toString());
    }
  }
}
