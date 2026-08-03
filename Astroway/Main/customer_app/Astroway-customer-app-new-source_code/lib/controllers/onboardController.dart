import 'package:AstrowayCustomer/controllers/IntakeController.dart';
import 'package:AstrowayCustomer/model/intake_model.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;
import 'package:AstrowayCustomer/utils/global.dart' as global;

class OnBoardController extends GetxController {
  APIHelper apiHelper = APIHelper();
  int initialIndex = -1;
  bool isDisable = true;
  bool isValidPhone = false;
  String? selectedGender;
  DateTime? selectedDate;
  String? selectedTime;
  bool isTimeOfBirthKnow = false;
  final nameController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final phoneController = TextEditingController();
  final intakeController = Get.find<IntakeController>();

  late AnimationController controller;
  late Animation<double> animation;
  double currentAngle = 0;
  double targetAngle = 0;
  double angle = 0;
  // int? astrologerId;
  // String? freedefaultTime;
  double? lat;
  double? long;
  dynamic tzone;

  Map<String, dynamic> StepWiseData = {};

  void rotateImage() {
    currentAngle = targetAngle;
    targetAngle += 30 * math.pi / 180; // Add 30 degrees in radians
    animation = Tween<double>(begin: currentAngle, end: targetAngle)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    controller.forward(from: 0);
  }

  String? countryCode;
  updateCountryCode(value) {
    countryCode = value.toString();
    update();
  }

  addOnboardIntakeFormData() async {
    IntakeModel onBoardIntakeModel = IntakeModel(
      name: nameController.text,
      birthDate: selectedDate == null
          ? DateTime(1994)
          : DateTime.parse(selectedDate.toString()),
      birthPlace: birthPlaceController.text,
      birthTime: selectedTime.toString(),
      countryCode: "+91",
      gender: selectedGender ?? "Male",
      maritalStatus: "Single",
      occupation: "",
      phoneNumber: phoneController.text != "" ? phoneController.text : "",
      topicOfConcern: 'Study',
      latitude: lat,
      longitude: long,
      timezone: tzone,
    );
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .addIntakeDetail(onBoardIntakeModel)
              .then((result) async {
            if (result.status == "200") {
              await intakeController.getFormIntakeData();
              intakeController.update();
              debugPrint("OnBorad Data Added Successfully");
            } else {
              global.showToast(
                message: 'Failed to add form data!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addCallIntakeFormData:-" + e.toString());
    }
  }

  List onBoardTitle = [
    'Hey there! \nWhat is Your name ?',
    'What is your gender?',
    'Enter your birth date',
    'Enter your birth time',
    'Where were you born?'
  ];
  List<OnBoardGender> gender = [
    OnBoardGender(title: 'Male', isSelected: false, image: Images.onBoardMale),
    OnBoardGender(
        title: 'Female', isSelected: false, image: Images.onBoardFemale),
  ];

  updateInitialIndex() {
    if (initialIndex < 6) {
      initialIndex = initialIndex + 1;
    } else {
      initialIndex = 0;
    }
    update();
  }

  updateIsDisable() {
    debugPrint("boot $isValidPhone");
    if (nameController.text != "") {
      isDisable = false;
      update();
    } else {
      isDisable = true;
      update();
    }
    if (phoneController.text != "" && phoneController.text.length == 10) {
      isValidPhone = true;
      update();
      debugPrint("boot $isValidPhone");
    } else {
      isValidPhone = false;
      update();
    }
  }

  updateBg(int index) {
    selectedGender = gender[index].title;
    for (int i = 0; i < gender.length; i++) {
      if (i == index) {
        continue;
      } else {
        gender[i].isSelected = false;
      }
    }
    gender[index].isSelected = true;
    update();
  }

  updateCheck(value) {
    isTimeOfBirthKnow = value;
    update();
  }

  String? userName;
  getName(String text) {
    userName = text;
    update();
  }

  String? phoneNumber;
  getPhone(String text) {
    phoneNumber = text;
    update();
  }

  getselectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  getSelectedTime(DateTime date) {
    selectedTime = DateFormat.Hm().format(date);
    update();
  }

  updateIcon(index) {
    listIcon[index].isSelected = true;
    for (int i = 0; i < listIcon.length; i++) {
      if (i == index) {
        listIcon[index].isSelected = true;
        continue;
      } else {
        listIcon[i].isSelected = false;
        update();
      }
    }
    update();
  }

  backStepForCreateKundli(int index) {
    initialIndex = index;
  }

  List<OnBoard> listIcon = [
    OnBoard(icon: Icons.person, isSelected: true),
    OnBoard(icon: Icons.phone, isSelected: false),
    OnBoard(icon: Icons.search, isSelected: false),
    OnBoard(icon: Icons.calendar_month, isSelected: false),
    OnBoard(icon: Icons.punch_clock_outlined, isSelected: false),
    OnBoard(icon: Icons.location_city, isSelected: false),
  ];
}

class OnBoard {
  IconData icon;
  bool isSelected;
  OnBoard({required this.icon, required this.isSelected});
}

class OnBoardGender {
  String title;
  bool isSelected;
  String image;
  OnBoardGender(
      {required this.title, required this.isSelected, required this.image});
}
