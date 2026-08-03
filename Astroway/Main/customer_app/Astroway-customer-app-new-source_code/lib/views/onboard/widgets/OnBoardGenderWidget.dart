import 'dart:developer';

import 'package:AstrowayCustomer/controllers/onboardController.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnBoardGenderWidget extends StatelessWidget {
  final OnBoardController onBoardController;

  const OnBoardGenderWidget({Key? key, required this.onBoardController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return GetBuilder<OnBoardController>(builder: (c) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0, left: 18.0),
                      child: InkWell(
                        onTap: () {
                          onBoardController.updateBg(index);
                          onBoardController.updateInitialIndex();
                          onBoardController
                              .updateIcon(onBoardController.initialIndex);
                          onBoardController.rotateImage();
                          onBoardController.StepWiseData['Step'] = 4;
                          onBoardController.StepWiseData['Gender'] =
                              onBoardController.gender[index].isSelected
                                  ? onBoardController.gender[index].title
                                  : 'Male';
                          log('My StepWise Data ${onBoardController.StepWiseData}');
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.w),
                            color: onBoardController.gender[index].isSelected
                                // ignore: deprecated_member_use
                                ? Get.theme.primaryColor.withOpacity(0.2)
                                : Colors.white,
                            border: Border.all(
                              color: onBoardController.gender[index].isSelected
                                  ? Get.theme.primaryColor
                                  : Colors.white,
                            ),
                          ),
                          child: Image.asset(
                            onBoardController.gender[index].image,
                            height: 40,
                            width: 40,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      onBoardController.gender[index].title,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w500),
                    ).tr()
                  ],
                );
              });
            }),
      ),
    );
  }
}
