import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/controllers/search_controller.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/CongressWidget.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/OnBoardBirthDateWidget.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/OnBoardBirthPlaceWidget.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/OnBoardBirthTimeWidget.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/OnBoardGenderWidget.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/OnBoardNameWidget.dart';
import 'package:AstrowayCustomer/views/onboard/widgets/OnBoardPhoneWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FreeChatOnBoardscreen extends StatefulWidget {
  @override
  State<FreeChatOnBoardscreen> createState() => _FreeChatOnBoardscreenState();
}

class _FreeChatOnBoardscreenState extends State<FreeChatOnBoardscreen>
    with SingleTickerProviderStateMixin {
  final onboardController = Get.find<OnBoardController>();

  @override
  void initState() {
    super.initState();
    onboardController.initialIndex = -1;
    onboardController.update();
    onboardController.controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    onboardController.animation =
        Tween<double>(begin: 0, end: 0).animate(onboardController.controller)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    onboardController.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: onboardController.initialIndex == -1
          ? BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.2),
                radius: 1.2,
                colors: [
                  Color(0xFFFFF4EC), // Light peach
                  Color(0xFFF6F1F9), // Very light purple/pink
                ],
                stops: [0.4, 1.0],
              ),
            )
          : null,
      child: Scaffold(
        backgroundColor: onboardController.initialIndex == -1
            ? Colors.transparent
            : Colors.grey.shade200,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          surfaceTintColor: Colors.grey.shade200,
          automaticallyImplyLeading: false,
          backgroundColor: onboardController.initialIndex == -1
              ? Colors.transparent
              : Colors.grey.shade200,
          actions: [
            TextButton(
                onPressed: () {
                  Get.find<SearchControllerCustom>()
                      .serachTextController
                      .clear();
                  Get.find<SearchControllerCustom>().searchText = '';
                  Get.find<HomeController>().myOrders.clear();
                  BottomNavigationController bottomNavigationController =
                      Get.find<BottomNavigationController>();
                  bottomNavigationController.setIndex(0, 0);
                  Get.off(() => BottomNavigationBarScreen(index: 0));
                },
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Not Now ", // add a little space before the icon
                        style: Get.textTheme.titleMedium!.copyWith(
                          color: Colors.black,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_forward_ios, // you can change the icon
                          size: 15,
                          color: Colors.black,
                        ),
                        alignment: PlaceholderAlignment.middle,
                      ),
                    ],
                  ),
                ))
          ],
        ),
        body: Stack(
          children: [
            GetBuilder<OnBoardController>(builder: (onboardController) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: ClipRect(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.22,
                    child: OverflowBox(
                      maxHeight: double.infinity,
                      alignment: Alignment.topCenter,
                      child: Center(
                        child: Transform.rotate(
                          angle: onboardController.animation.value,
                          alignment: Alignment.center,
                          child: Image.asset(
                            Images.callBackImage,
                            width: MediaQuery.of(context).size.width * 1.2,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            SafeArea(
              child: GetBuilder<OnBoardController>(builder: (c) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      onboardController.initialIndex == -1
                          ? SizedBox()
                          : SizedBox(
                              height: 60,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: 6,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: onboardController
                                            .listIcon[index].isSelected
                                        ? CircleAvatar(
                                            radius: 13,
                                            backgroundColor:
                                                Get.theme.primaryColor,
                                            child: Icon(
                                              onboardController
                                                  .listIcon[onboardController
                                                      .initialIndex]
                                                  .icon,
                                              size: 15,
                                              color: Colors.black,
                                            ),
                                          )
                                        : onboardController.initialIndex >=
                                                index
                                            ? GestureDetector(
                                                onTap: () {
                                                  onboardController
                                                      .backStepForCreateKundli(
                                                          index);
                                                  onboardController.updateIcon(
                                                      onboardController
                                                          .initialIndex);
                                                },
                                                child: CircleAvatar(
                                                  radius: 10,
                                                  backgroundColor:
                                                      Get.theme.primaryColor,
                                                ),
                                              )
                                            : const CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.grey,
                                              ),
                                  );
                                },
                              ),
                            ),
                      onboardController.initialIndex == -1
                          ? SizedBox()
                          : onboardController.initialIndex == 0
                              ? RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                      text:
                                          'Hello!\nLet’s unlock your astrological insights. ',
                                      style: Get.textTheme.titleMedium!
                                          .copyWith(
                                              color: blackColor,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w600),
                                      children: [
                                        TextSpan(
                                          text: 'What’s your name?',
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                        )
                                      ]),
                                )
                              : onboardController.initialIndex == 1
                                  ? RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                          text: 'Contact Details\n',
                                          style: Get.textTheme.titleMedium!
                                              .copyWith(
                                                  color: blackColor,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                          children: [
                                            TextSpan(
                                              text: 'What’s your phone?',
                                              style: Get.textTheme.titleMedium!
                                                  .copyWith(
                                                      color: Get
                                                          .theme.primaryColor,
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            )
                                          ]),
                                    )
                                  : onboardController.initialIndex == 2
                                      ? RichText(
                                          textAlign: TextAlign.center,
                                          text: TextSpan(
                                              text: 'Great!\n',
                                              style: Get.textTheme.titleMedium!
                                                  .copyWith(
                                                      color: Get
                                                          .theme.primaryColor,
                                                      fontSize: 19.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                              children: [
                                                TextSpan(
                                                  text:
                                                      'Your birth details help us create your personalized Kundli. ',
                                                  style: Get
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                          color: blackColor,
                                                          fontSize: 19.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                                TextSpan(
                                                  text: 'When were you born?',
                                                  style: Get
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                          color: Get.theme
                                                              .primaryColor,
                                                          fontSize: 19.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                )
                                              ]),
                                        )
                                      : onboardController.initialIndex == 3
                                          ? RichText(
                                              textAlign: TextAlign.center,
                                              text: TextSpan(
                                                  text: 'Awesome!\n',
                                                  style: Get
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                          color: Get.theme
                                                              .primaryColor,
                                                          fontSize: 19.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          'Do you know your birth time?',
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: blackColor,
                                                              fontSize: 19.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    )
                                                  ]),
                                            )
                                          : onboardController.initialIndex == 4
                                              ? RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'Gender!\n',
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: Get.theme
                                                                  .primaryColor,
                                                              fontSize: 19.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'How do you prefer to be addressed?',
                                                          style: Get.textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  color:
                                                                      blackColor,
                                                                  fontSize:
                                                                      19.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        )
                                                      ]),
                                                )
                                              : RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                      text: 'One last step!\n',
                                                      style: Get.textTheme
                                                          .titleMedium!
                                                          .copyWith(
                                                              color: Get.theme
                                                                  .primaryColor,
                                                              fontSize: 19.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              'Where were you born?\n',
                                                          style: Get.textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  color:
                                                                      blackColor,
                                                                  fontSize:
                                                                      19.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                        )
                                                      ]),
                                                ),
                      SizedBox(height: 3.h),
                      if (onboardController.initialIndex == -1)
                        CongratsScreen(
                          onBoardController: onboardController,
                          onPressed: () {
                            onboardController.rotateImage();
                            onboardController.updateInitialIndex();
                          },
                        ),
                      if (onboardController.initialIndex == 0)
                        OnBoardNameWidget(
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z ]'))
                          ],
                          onBoardController: onboardController,
                          onPressed: () {
                            if (!onboardController.isDisable) {
                              onboardController.updateInitialIndex();
                              onboardController
                                  .updateIcon(onboardController.initialIndex);
                              onboardController.rotateImage();
                              onboardController.StepWiseData['Step'] = 0;
                              onboardController.StepWiseData['Name'] =
                                  onboardController.nameController.text;
                              log('My StepWise Data ${onboardController.StepWiseData}');
                            }
                          },
                        ),
                      if (onboardController.initialIndex == 1)
                        OnBoardPhoneWidget(
                          onBoardController: onboardController,
                          onPressed: () {
                            if (onboardController.phoneController.text.length ==
                                10) {
                              onboardController.updateInitialIndex();
                              onboardController
                                  .updateIcon(onboardController.initialIndex);
                              onboardController.rotateImage();
                              onboardController.StepWiseData['Step'] = 1;
                              onboardController.StepWiseData['Phone'] =
                                  onboardController.phoneController.text;
                              log('My StepWise Data ${onboardController.StepWiseData}');
                            }
                          },
                        ),
                      if (onboardController.initialIndex == 2)
                        OnBoardBirthDateWidget(
                          onBoardController: onboardController,
                          onPressed: () {
                            onboardController.rotateImage();
                            onboardController.updateInitialIndex();
                            onboardController
                                .updateIcon(onboardController.initialIndex);
                            if (onboardController.selectedDate == null) {
                              onboardController.selectedDate = DateTime(1996);
                            }
                            onboardController.StepWiseData['Step'] = 2;
                            onboardController.StepWiseData['BithDate'] =
                                onboardController.selectedDate;
                            log('My StepWise Data ${onboardController.StepWiseData}');
                          },
                        ),
                      if (onboardController.initialIndex == 3)
                        OnBoardBirthTimeWidget(
                          onBoardController: onboardController,
                          onPressed: () {
                            onboardController.updateInitialIndex();
                            onboardController
                                .updateIcon(onboardController.initialIndex);
                            onboardController.rotateImage();
                            onboardController.StepWiseData['Step'] = 3;
                            onboardController.StepWiseData['BirthTime'] =
                                onboardController.selectedTime;
                            log('My StepWise Data ${onboardController.StepWiseData}');
                          },
                        ),
                      if (onboardController.initialIndex == 4)
                        OnBoardGenderWidget(
                          onBoardController: onboardController,
                        ),
                      if (onboardController.initialIndex == 5)
                        OnBordBirthPlaceWidget(
                          onBoardController: onboardController,
                        ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
