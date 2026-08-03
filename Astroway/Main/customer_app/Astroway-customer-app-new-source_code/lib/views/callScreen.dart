// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/filtterTabController.dart';
import 'package:AstrowayCustomer/controllers/languageController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/skillController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/widget/skeletion_list_loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'multiDesignLayout/callscreen/astrologerCallScreenListing.dart';

class CallScreen extends StatefulWidget {
  int flag;

  CallScreen({super.key, required this.flag});
  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final filtterTabController = Get.find<FiltterTabController>();
  final skillController = Get.find<SkillController>();
  final languageController = Get.find<LanguageController>();
  final reportController = Get.find<ReportController>();
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: widget.flag == 1
            ? AppBar(
                iconTheme: IconThemeData(color: Colors.white),
                title: Text("Call with Astrologer",
                    style: Get.theme.primaryTextTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp,
                        color: Colors.white)),
                backgroundColor: Get.theme.primaryColor,
                leading: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Icon(
                    Icons.arrow_back,
                  ),
                ),
              )
            : null,
        backgroundColor: scaffbgcolor,
        body: DefaultTabController(
          length: chatController.categoryList.length,
          child: Column(
            children: [
              GetBuilder<ChatController>(
                builder: (chatController) => TabBar(
                  tabAlignment: TabAlignment.start,
                  dividerColor: Colors.transparent,
                  padding: EdgeInsets.only(top: 10, left: 2.w),
                  controller: chatController.categoryTab,
                  isScrollable: true,
                  onTap: (value) async {
                    chatController.isSelected = value;
                    chatController.update();
                    if (value == 0) {
                      print("ontab1${value}");
                      bottomNavigationController.astrologerList = [];
                      bottomNavigationController.astrologerList.clear();
                      bottomNavigationController.isAllDataLoaded = false;
                      bottomNavigationController.update();
                      bottomNavigationController.getAstrologerList(
                          isLazyLoading: false);
                    } else {
                      for (var i = 0;
                          i < chatController.categoryList.length;
                          i++) {
                        if (value == i) {
                          bottomNavigationController.astrologerList = [];
                          bottomNavigationController.astrologerList.clear();
                          bottomNavigationController.isAllDataLoaded = false;
                          bottomNavigationController.update();
                          bottomNavigationController.astroCat(
                              id: chatController.categoryList[i].id!,
                              isLazyLoading: false);
                        }
                      }
                    }
                    chatController.update();
                  },
                  indicatorColor: Colors.transparent,
                  labelPadding: EdgeInsets.symmetric(horizontal: 5),
                  tabs: List.generate(chatController.categoryList.length,
                      (index) {
                    return Skeletonizer(
                      enabled: chatController.isAcceptChatLoading,
                      child: SizedBox(
                        height: 30,
                        child: Chip(
                          padding: EdgeInsets.only(bottom: 5),
                          backgroundColor: Color.fromARGB(255, 255, 233, 160),
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                color: chatController.isSelected == index
                                    ? Color(0xFF9F8334)
                                    : Color(0xffFFD440),
                              ),
                              borderRadius: BorderRadius.circular(30.w)),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  height: 20,
                                  width: 20,
                                  imageUrl: global.buildImageUrl(
                                      '${chatController.categoryList[index].image}'),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.grid_view_rounded, size: 20),
                                ),
                                SizedBox(width: 5),
                                global.buildTranslatedText(
                                    chatController.categoryList[index].name,
                                    Get.theme.primaryTextTheme.bodySmall!
                                        .copyWith(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500),
                                    showloading: false),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Expanded(child: GetBuilder<BottomNavigationController>(
                  builder: (bottomNavigationController) {
                if (bottomNavigationController.astrologerList.length == 0) {
                  return SkeletionLoading(length: 6);
                } else {
                  return TabBarView(
                    controller: chatController.categoryTab,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(chatController.categoryList.length,
                        (index) {
                      return RefreshIndicator(
                          onRefresh: () async {
                            _refreshindicator();
                          },
                          child: _getDesignWidget(index));
                    }),
                  );
                }
              }))
            ],
          ),
        ),
      ),
    );
  }

  Widget _getDesignWidget(int index) {
    final designId = global
        .getSystemFlagValueForLogin(global.systemFlagNameList.appDesignId);
    log('design no ${designId}');

    return Astrologercallscreenlisting(
        astrologerList: bottomNavigationController.astrologerList);
  }

  void openBottomSheetFilter(BuildContext context) {
    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.09,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Sort & Filter').tr(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(Icons.close),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, height: 0),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Obx(
                    () => RotatedBox(
                      quarterTurns: 1,
                      child: TabBar(
                        isScrollable: true,
                        indicatorSize: TabBarIndicatorSize.label,
                        controller: filtterTabController.filterTab,
                        indicatorColor: Colors.pink,
                        indicatorPadding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicator: BoxDecoration(),
                        indicatorWeight: 0,
                        unselectedLabelColor: Colors.grey[50],
                        onTap: (index) {
                          filtterTabController.selectedFilterIndex.value =
                              index;
                          filtterTabController.update();
                        },
                        tabs: List.generate(
                          filtterTabController.filtterList.length,
                          (ind) {
                            return RotatedBox(
                              quarterTurns: -1,
                              child: Container(
                                color: filtterTabController
                                            .selectedFilterIndex.value ==
                                        ind
                                    ? Colors.white
                                    : Colors.green[100],
                                height: 50,
                                child: Row(
                                  children: [
                                    Container(
                                      width: 5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(5),
                                          bottomRight: Radius.circular(5),
                                        ),
                                        color: filtterTabController
                                                    .selectedFilterIndex
                                                    .value ==
                                                ind
                                            ? Colors.white
                                            : Colors.green,
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        filtterTabController.filtterList[ind],
                                        style: TextStyle(color: Colors.black54),
                                      ).tr(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: RotatedBox(
                    quarterTurns: 1,
                    child: TabBarView(
                      controller: filtterTabController.filterTab,
                      children: [
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<ReportController>(
                            builder: (reportController) {
                              return GetBuilder<SkillController>(
                                builder: (skillController) {
                                  return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      child: ListView.builder(
                                          itemCount:
                                              reportController.sorting.length,
                                          padding: EdgeInsets.zero,
                                          itemBuilder: (context, index) {
                                            return RadioListTile(
                                              groupValue:
                                                  reportController.groupValue,
                                              controlAffinity:
                                                  ListTileControlAffinity
                                                      .leading,
                                              contentPadding: EdgeInsets.zero,
                                              activeColor: Colors.black,
                                              value: reportController
                                                  .sorting[index].id,
                                              onChanged: (val) {
                                                reportController.groupValue =
                                                    val!;

                                                reportController.update();
                                              },
                                              title: Text(reportController
                                                      .sorting[index].name!)
                                                  .tr(),
                                            );
                                          }));
                                },
                              );
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<SkillController>(
                            builder: (skillController) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount:
                                          skillController.skillList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: skillController
                                              .skillList[index].isSelected,
                                          onChanged: (value) {
                                            skillController.skillList[index]
                                                .isSelected = value!;
                                            skillController.update();
                                          },
                                          title: Text(skillController
                                                  .skillList[index].name)
                                              .tr(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<LanguageController>(
                            builder: (c) {
                              return Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: ListView.builder(
                                      itemCount: languageController
                                          .languageList.length,
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          controlAffinity:
                                              ListTileControlAffinity.leading,
                                          contentPadding: EdgeInsets.zero,
                                          activeColor: Colors.black,
                                          value: languageController
                                              .languageList[index].isSelected,
                                          onChanged: (value) {
                                            languageController
                                                .languageList[index]
                                                .isSelected = value!;
                                            languageController.update();
                                          },
                                          title: Text(languageController
                                                  .languageList[index]
                                                  .languageName)
                                              .tr(),
                                        );
                                      }));
                            },
                          ),
                        )),
                        SizedBox(
                            child: RotatedBox(
                          quarterTurns: -1,
                          child: GetBuilder<FiltterTabController>(builder: (c) {
                            return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: ListView.builder(
                                    itemCount:
                                        filtterTabController.gender.length,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return CheckboxListTile(
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: Colors.black,
                                        value: filtterTabController
                                            .gender[index].isCheck,
                                        onChanged: (value) {
                                          filtterTabController
                                              .gender[index].isCheck = value!;
                                          filtterTabController.update();
                                        },
                                        title: Text(filtterTabController
                                                .gender[index].name)
                                            .tr(),
                                      );
                                    }));
                          }),
                        )),
                        SizedBox()
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Divider(thickness: 2),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                            child: SizedBox(
                          width: 0,
                          child: TextButton(
                            onPressed: () async {
                              skillController.skillFilterList = [];
                              filtterTabController.genderFilterList = [];
                              languageController.languageFilterList = [];
                              reportController.sortingFilter = null;
                              for (var i = 0;
                                  i < skillController.skillList.length;
                                  i++) {
                                skillController.skillList[i].isSelected = false;

                                skillController.update();
                              }
                              for (var i = 0;
                                  i < languageController.languageList.length;
                                  i++) {
                                languageController.languageList[i].isSelected =
                                    false;

                                languageController.update();
                              }
                              for (var i = 0;
                                  i < filtterTabController.gender.length;
                                  i++) {
                                filtterTabController.gender[i].isCheck = false;

                                filtterTabController.update();
                              }
                              Get.back();
                              bottomNavigationController.astrologerList = [];
                              bottomNavigationController.astrologerList.clear();
                              bottomNavigationController.isAllDataLoaded =
                                  false;
                              bottomNavigationController.skillFilterList =
                                  skillController.skillFilterList;
                              bottomNavigationController.genderFilterList =
                                  filtterTabController.genderFilterList;
                              bottomNavigationController.languageFilter =
                                  languageController.languageFilterList;
                              bottomNavigationController.applyFilter = false;
                              bottomNavigationController.update();
                              global.showOnlyLoaderDialog(context);
                              await bottomNavigationController
                                  .getAstrologerList(
                                      skills: skillController.skillFilterList,
                                      gender:
                                          filtterTabController.genderFilterList,
                                      language: languageController
                                          .languageFilterList);

                              global.hideLoader();
                              reportController.groupValue = 0;
                              print('done');
                              reportController.update();
                            },
                            child: Text(
                              'Reset',
                              style: TextStyle(color: Colors.black54),
                            ).tr(),
                          ),
                        )),
                        Expanded(child: GetBuilder<SkillController>(
                          builder: (skillController) {
                            return SizedBox(
                              width: 80,
                              height: 55,
                              child: TextButton(
                                onPressed: () async {
                                  skillController.skillFilterList = [];
                                  filtterTabController.genderFilterList = [];
                                  languageController.languageFilterList = [];
                                  reportController.sortingFilter = null;

                                  for (var i = 0;
                                      i < skillController.skillList.length;
                                      i++) {
                                    if (skillController
                                            .skillList[i].isSelected ==
                                        true) {
                                      skillController.skillFilterList.add(
                                          skillController.skillList[i].id!);
                                      skillController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i < filtterTabController.gender.length;
                                      i++) {
                                    if (filtterTabController
                                            .gender[i].isCheck ==
                                        true) {
                                      filtterTabController.genderFilterList.add(
                                          filtterTabController.gender[i].name);
                                      filtterTabController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i <
                                          languageController
                                              .languageList.length;
                                      i++) {
                                    if (languageController
                                            .languageList[i].isSelected ==
                                        true) {
                                      languageController.languageFilterList.add(
                                          languageController
                                              .languageList[i].id!);
                                      languageController.update();
                                    }
                                  }
                                  for (var i = 0;
                                      i < reportController.sorting.length;
                                      i++) {
                                    if (reportController.groupValue ==
                                        reportController.sorting[i].id) {
                                      reportController.sortingFilter =
                                          reportController.sorting[i].value;
                                      reportController.update();
                                    }
                                  }
                                  Get.back();
                                  global.showOnlyLoaderDialog(context);
                                  bottomNavigationController.astrologerList =
                                      [];
                                  bottomNavigationController.astrologerList
                                      .clear();
                                  bottomNavigationController.isAllDataLoaded =
                                      false;
                                  bottomNavigationController.applyFilter = true;
                                  bottomNavigationController.skillFilterList =
                                      skillController.skillFilterList;
                                  bottomNavigationController.genderFilterList =
                                      filtterTabController.genderFilterList;
                                  bottomNavigationController.languageFilter =
                                      languageController.languageFilterList;
                                  bottomNavigationController.sortingFilter =
                                      reportController.sortingFilter;
                                  bottomNavigationController.update();
                                  await bottomNavigationController
                                      .getAstrologerList(
                                          skills:
                                              skillController.skillFilterList,
                                          gender: filtterTabController
                                              .genderFilterList,
                                          language: languageController
                                              .languageFilterList,
                                          sortBy:
                                              reportController.sortingFilter);
                                  global.hideLoader();
                                },
                                child: Text('Apply').tr(),
                                style: ButtonStyle(
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.all(8)),
                                  backgroundColor: MaterialStateProperty.all(
                                      Get.theme.primaryColor),
                                  foregroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.8),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
    );
  }

  void _refreshindicator() async {
    callController.showLoading = true;
    callController.update();
    callController.startLoadingTimer();
    bottomNavigationController.astrologerList = [];
    bottomNavigationController.astrologerList.clear();
    bottomNavigationController.isAllDataLoaded = false;
    if (bottomNavigationController.genderFilterList != null) {
      bottomNavigationController.genderFilterList!.clear();
    }
    if (bottomNavigationController.languageFilter != null) {
      bottomNavigationController.languageFilter!.clear();
    }
    if (bottomNavigationController.skillFilterList != null) {
      bottomNavigationController.skillFilterList!.clear();
    }
    bottomNavigationController.applyFilter = false;
    bottomNavigationController.update();
    await bottomNavigationController.getAstrologerList(isLazyLoading: false);
  }
}
