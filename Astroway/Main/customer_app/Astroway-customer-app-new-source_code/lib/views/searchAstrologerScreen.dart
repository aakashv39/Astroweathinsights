// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/search_controller.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/astromall/astromallScreen.dart';
import 'package:AstrowayCustomer/views/astromall/productDetailScreen.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/callIntakeFormScreen.dart';
import 'package:AstrowayCustomer/views/liveAstrologerList.dart';
import 'package:AstrowayCustomer/widget/popular_search_widget.dart';
import 'package:AstrowayCustomer/widget/topServicesWidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import 'package:responsive_sizer/responsive_sizer.dart';
import '../controllers/chatController.dart';
import '../controllers/reviewController.dart';
import '../controllers/walletController.dart';
import '../utils/CornerBanner.dart';
import 'astrologerProfile/astrologerProfile.dart';

class SearchAstrologerScreen extends StatelessWidget {
  final String type;
  SearchAstrologerScreen({Key? key, this.type = 'Chat'}) : super(key: key);
  final chatController = ChatController();
  final walletController = Get.find<WalletController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final callController = Get.find<CallController>();
  final searchControllerr = Get.find<SearchControllerCustom>();
  final historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final searchController = Get.find<SearchControllerCustom>();
        searchController.serachTextController.clear();
        searchController.searchText = "";
        searchController.update();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10.h),
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 10.h,
            margin: EdgeInsets.only(top: 2.h),
            child: AppBar(
              backgroundColor: Colors.white,
              leading: InkWell(
                onTap: () {
                  final searchController = Get.find<SearchControllerCustom>();
                  searchController.serachTextController.clear();
                  searchController.searchText = "";
                  searchController.update();
                  Get.back();
                },
                child: Container(
                  height: 6.h,
                  width: 8.w,
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
              title: GetBuilder<SearchControllerCustom>(
                  builder: (searchController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey, width: 0.1.w),
                  ),
                  width: 86.w,
                  height: 6.h,
                  child: Center(
                    child: TextField(
                      controller: searchController.serachTextController,
                      onSubmitted: (value) async {
                        searchController.searchFnode.unfocus();
                        // global.showOnlyLoaderDialog(context);
                        searchController.astrologerList.clear();
                        searchController.astroProduct.clear();
                        searchController.isAllDataLoaded = false;
                        searchController.isAllDataLoadedForAstromall = false;
                        searchController.searchString =
                            searchController.serachTextController.text;
                        log("searchASTRO");
                        log("${searchController.searchString == ""}");
                        searchController.update();
                        await searchController.getSearchResult(
                            searchController.serachTextController.text,
                            null,
                            false);
                        searchController.update();
                      },
                      onChanged: (value) async {
                        if (value.length == 0) {
                          searchController.astrologerList.clear();
                          searchController.astroProduct.clear();
                        }
                      },
                      focusNode: searchControllerr.searchFnode,
                      decoration: InputDecoration(
                          hintText: tr("Type Here To Search"),
                          hintStyle: TextStyle(fontSize: 16.sp),
                          labelStyle: TextStyle(fontSize: 16.sp),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          suffixIcon: InkWell(
                            onTap: () async {
                              searchController.searchFnode.unfocus();
                              // global.showOnlyLoaderDialog(context);
                              searchController.astrologerList.clear();
                              searchController.astroProduct.clear();
                              searchController.isAllDataLoaded = false;
                              searchController.isAllDataLoadedForAstromall =
                                  false;
                              searchController.searchString =
                                  searchController.serachTextController.text;
                              log("searchASTRO");
                              log("${searchController.searchString == ""}");
                              searchController.update();
                              await searchController.getSearchResult(
                                  searchController.serachTextController.text,
                                  null,
                                  false);
                              searchController.update();
                            },
                            child: Icon(Icons.search),
                          )),
                    ),
                  ),
                );
              }),
              actions: [],
            ),
          ),
        ),
        body: GetBuilder<SearchControllerCustom>(builder: (searchController) {
          return searchController.serachTextController.text == ""
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Text('Top Services').tr(),
                        SizedBox(
                          height: 8,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TopServicesWidget(
                                  icon: Icons.phone,
                                  color: Color.fromARGB(255, 212, 228, 241),
                                  text: 'Call',
                                  onTap: () {
                                    BottomNavigationController
                                        bottomNavigationController =
                                        Get.find<BottomNavigationController>();
                                    bottomNavigationController.setIndex(3, 0);
                                    Get.to(() => BottomNavigationBarScreen(
                                          index: 3,
                                        ));
                                  },
                                ),
                                TopServicesWidget(
                                  icon: Icons.chat,
                                  color: Color.fromARGB(255, 238, 221, 236),
                                  text: 'Chat',
                                  onTap: () {
                                    final bottomNavigationController =
                                        Get.find<BottomNavigationController>();
                                    bottomNavigationController.setIndex(1, 0);
                                    Get.to(() => BottomNavigationBarScreen(
                                          index: 1,
                                        ));
                                  },
                                ),
                                TopServicesWidget(
                                  icon: Icons.live_tv,
                                  color: Color.fromARGB(255, 235, 236, 221),
                                  text: 'Live',
                                  onTap: () {
                                    Get.to(() => LiveAstrologerListScreen());
                                  },
                                ),
                                TopServicesWidget(
                                    icon: Icons.shopping_bag,
                                    color: Color.fromARGB(255, 223, 240, 221),
                                    text: 'Shopping',
                                    onTap: () {
                                      Get.to(() => AstromallScreen());
                                    })
                              ]),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: searchController.searchData.length,
                          itemBuilder: (context, index) {
                            return GetBuilder<SearchControllerCustom>(
                                builder: (searchController) {
                              return GestureDetector(
                                onTap: () {
                                  global.showOnlyLoaderDialog(context);
                                  searchController.selectSearchTab(index);
                                  searchController.astrologerList.clear();
                                  searchController.astroProduct.clear();
                                  searchController.isAllDataLoaded = false;
                                  searchController.isAllDataLoadedForAstromall =
                                      false;
                                  searchController.searchString =
                                      searchController.searchText;
                                  searchController.update();
                                  searchController.getSearchResult(
                                      searchController.searchText, null, false);
                                  global.hideLoader();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Container(
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(top: 10),
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      decoration: BoxDecoration(
                                        color: searchController
                                                .searchData[index].isSelected
                                            ? Color.fromARGB(255, 247, 243, 213)
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: searchController
                                                    .searchData[index]
                                                    .isSelected
                                                ? Get.theme.primaryColor
                                                : Colors.black),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Text(
                                        searchController
                                            .searchData[index].title,
                                        style: TextStyle(
                                          fontSize: 13,
                                        ),
                                      ).tr()),
                                ),
                              );
                            });
                          }),
                    ),
                    searchController.searchTabIndex == 0
                        ? Expanded(
                            child: searchController.astrologerList.isEmpty
                                ? searchResultNotFound()
                                : ListView.builder(
                                    itemCount:
                                        searchController.astrologerList.length,
                                    shrinkWrap: true,
                                    controller:
                                        searchController.searchScrollController,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          Get.find<ReviewController>()
                                              .getReviewData(searchController
                                                  .astrologerList[index].id!);
                                          global.showOnlyLoaderDialog(context);
                                          await bottomNavigationController
                                              .getAstrologerbyId(
                                                  searchController
                                                      .astrologerList[index]
                                                      .id!);
                                          global.hideLoader();
                                          Get.to(() => AstrologerProfile(
                                                index: index,
                                              ));
                                        },
                                        child: Column(
                                          children: [
                                            GetBuilder<SearchControllerCustom>(
                                              builder: (searchController) =>
                                                  Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color:
                                                      bottomNavigationController
                                                                  .astrologerList[
                                                                      index]
                                                                  .isBoosted ==
                                                              Images.ISBOOSTED
                                                          ? Colors.grey.shade300
                                                          : Colors.white,
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    vertical: 0.5.h,
                                                    horizontal: 1.w),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                height: 14.h,
                                                                width: 12.h,
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              2.w),
                                                                  child:
                                                                      CachedNetworkImage(
                                                                    height:
                                                                        14.h,
                                                                    width: 12.h,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    imageUrl: global
                                                                        .buildImageUrl(
                                                                            '${searchController.astrologerList[index].profileImage}'),
                                                                    placeholder: (context,
                                                                            url) =>
                                                                        const Center(
                                                                            child:
                                                                                CircularProgressIndicator()),
                                                                    errorWidget: (context,
                                                                            url,
                                                                            error) =>
                                                                        Image
                                                                            .asset(
                                                                      Images
                                                                          .deafultUser,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      height:
                                                                          14.h,
                                                                      width:
                                                                          12.h,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Positioned(
                                                                right: 4,
                                                                top: 4,
                                                                child:
                                                                    CircleAvatar(
                                                                  radius: 11.sp,
                                                                  backgroundColor: bottomNavigationController
                                                                              .astrologerList[
                                                                                  index]
                                                                              .callStatus ==
                                                                          "Offline"
                                                                      ? Colors
                                                                          .red
                                                                      : bottomNavigationController.astrologerList[index].callStatus ==
                                                                              "Online"
                                                                          ? Colors
                                                                              .green
                                                                          : Colors
                                                                              .grey,
                                                                ),
                                                              ),
                                                              GetBuilder<
                                                                  SearchControllerCustom>(
                                                                builder: (searchcontroller) => searchcontroller
                                                                            .astrologerList[
                                                                                index]
                                                                            .isBoosted ==
                                                                        Images
                                                                            .ISBOOSTED
                                                                    ? Positioned(
                                                                        left: 0,
                                                                        top: 0,
                                                                        child:
                                                                            CornerBanner(
                                                                          bannerPosition:
                                                                              CornerBannerPosition.topLeft,
                                                                          bannerColor:
                                                                              Colors.red,
                                                                          child:
                                                                              Text(
                                                                            "sponsored",
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 13.sp,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                              ),
                                                              Positioned(
                                                                bottom: 1.w,
                                                                right: 1.w,
                                                                left: 1.w,
                                                                child:
                                                                    Container(
                                                                  width: 12.h,
                                                                  height: 3.5.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: getRandomColor(
                                                                        index),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            1.w),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .primarySkill!
                                                                          .split(
                                                                              ',')[0],
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontSize: 14
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  searchController
                                                                              .astrologerList[index]
                                                                              .name!
                                                                              .length >
                                                                          13
                                                                      ? Expanded(
                                                                          child: Container(
                                                                              padding: EdgeInsets.only(right: 20),
                                                                              child: Row(
                                                                                children: [
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Row(
                                                                                        children: [
                                                                                          Text(
                                                                                            searchController.astrologerList[index].name!.length > 13 ? searchController.astrologerList[index].name!.substring(0, 13) : searchController.astrologerList[index].name!,
                                                                                            textAlign: TextAlign.start,
                                                                                            maxLines: 1,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                          ).tr(),
                                                                                        ],
                                                                                      ),
                                                                                      Row(
                                                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                                                        children: [
                                                                                          Text(
                                                                                            searchController.astrologerList[index].name!.length > 20 ? searchController.astrologerList[index].name!.substring(13, 20) + ".." : searchController.astrologerList[index].name!.substring(13),
                                                                                            textAlign: TextAlign.start,
                                                                                            overflow: TextOverflow.ellipsis,
                                                                                            style: TextStyle(
                                                                                              fontFamily: 'Poppins-Regular',
                                                                                            ),
                                                                                          ).tr(),
                                                                                          SizedBox(width: 1.w),
                                                                                          Image.asset(
                                                                                            Images.right,
                                                                                            height: 16.sp,
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              )),
                                                                        )
                                                                      : Row(
                                                                          children: [
                                                                            Container(
                                                                              height: 2.4.h,
                                                                              padding: EdgeInsets.only(right: 10),
                                                                              child: Row(
                                                                                children: [
                                                                                  Row(
                                                                                    children: [
                                                                                      Text(
                                                                                        style: TextStyle(fontFamily: 'Poppins-Regular', color: Colors.black),
                                                                                        searchController.astrologerList[index].name!.isNotEmpty ? searchController.astrologerList[index].name![0].toUpperCase() + searchController.astrologerList[index].name!.substring(1).toLowerCase() : '',
                                                                                        textAlign: TextAlign.start,
                                                                                      ).tr(),
                                                                                      SizedBox(width: 1.w),
                                                                                      Image.asset(
                                                                                        Images.right,
                                                                                        height: 16.sp,
                                                                                      ),
                                                                                    ],
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                ],
                                                              ),
                                                              searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .allSkill ==
                                                                      ""
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      children: [
                                                                        Icon(
                                                                            FontAwesomeIcons
                                                                                .graduationCap,
                                                                            size:
                                                                                14.sp,
                                                                            color: Colors.grey[600]),
                                                                        SizedBox(
                                                                            width:
                                                                                1.w),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            searchController.astrologerList[index].allSkill ??
                                                                                "",
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                              fontFamily: 'Poppins-Regular',
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.grey[600],
                                                                            ),
                                                                          ).tr(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .languageKnown ==
                                                                      ""
                                                                  ? const SizedBox()
                                                                  : Row(
                                                                      children: [
                                                                        Icon(
                                                                            Icons
                                                                                .language,
                                                                            size:
                                                                                14.sp,
                                                                            color: Colors.grey[600]),
                                                                        SizedBox(
                                                                            width:
                                                                                1.w),
                                                                        Flexible(
                                                                          child:
                                                                              Text(
                                                                            searchController.astrologerList[index].languageKnown ??
                                                                                "",
                                                                            textAlign:
                                                                                TextAlign.start,
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            style:
                                                                                Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                              fontFamily: 'Poppins-Regular',
                                                                              fontWeight: FontWeight.w400,
                                                                              color: Colors.grey[600],
                                                                            ),
                                                                          ).tr(),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                      FontAwesomeIcons
                                                                          .briefcase,
                                                                      size:
                                                                          13.sp,
                                                                      color: Colors
                                                                              .grey[
                                                                          600]),
                                                                  SizedBox(
                                                                      width:
                                                                          1.w),
                                                                  global.buildTranslatedText(
                                                                      '${searchController.astrologerList[index].experienceInYears} Years',
                                                                      Get.theme.primaryTextTheme.bodySmall!.copyWith(
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                        color: Colors
                                                                            .grey[600],
                                                                      )),
                                                                ],
                                                              ),
                                                              type == 'Chat'
                                                                  ? SizedBox()
                                                                  : Row(
                                                                      children: [
                                                                        searchController.astrologerList[index].isFreeAvailable ==
                                                                                true
                                                                            ? Text(
                                                                                'FREE',
                                                                                style: Get.theme.textTheme.titleMedium!.copyWith(
                                                                                  fontSize: 12,
                                                                                  fontFamily: 'Poppins-Regular',
                                                                                  fontWeight: FontWeight.w500,
                                                                                  letterSpacing: 0,
                                                                                  color: Color.fromARGB(255, 167, 1, 1),
                                                                                ),
                                                                              ).tr()
                                                                            : const SizedBox(),
                                                                        SizedBox(
                                                                          width: searchController.astrologerList[index].isFreeAvailable == true
                                                                              ? 10
                                                                              : 0,
                                                                        ),
                                                                        Text(
                                                                          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${searchController.astrologerList[index].charge}/min',
                                                                          style: Get
                                                                              .theme
                                                                              .textTheme
                                                                              .titleMedium!
                                                                              .copyWith(
                                                                            fontSize:
                                                                                12,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            fontFamily:
                                                                                'Poppins-Regular',
                                                                            decoration: searchController.astrologerList[index].isFreeAvailable == true
                                                                                ? TextDecoration.lineThrough
                                                                                : null,
                                                                            color: searchController.astrologerList[index].isFreeAvailable == true
                                                                                ? Colors.grey
                                                                                : Color.fromARGB(255, 167, 1, 1),
                                                                            letterSpacing:
                                                                                0,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        children: [
                                                          type == 'Chat'
                                                              ? TextButton(
                                                                  style:
                                                                      ButtonStyle(
                                                                    padding: MaterialStateProperty.all(
                                                                        EdgeInsets.all(
                                                                            0)),
                                                                    fixedSize: MaterialStateProperty.all(
                                                                        Size.fromWidth(
                                                                            90)),
                                                                    backgroundColor: searchController.astrologerList[index].chat_sections.toString() ==
                                                                            "0"
                                                                        ? MaterialStateProperty.all(Colors
                                                                            .grey)
                                                                        : (searchController.astrologerList[index].chatStatus ==
                                                                                "Online"
                                                                            ? MaterialStateProperty.all(Colors.lightBlue)
                                                                            : MaterialStateProperty.all(Colors.orangeAccent)),
                                                                    shape:
                                                                        MaterialStateProperty
                                                                            .all(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    bool
                                                                        isLogin =
                                                                        await global
                                                                            .isLogin();
                                                                    if (isLogin) {
                                                                      if (searchController
                                                                              .astrologerList[index]
                                                                              .chat_sections
                                                                              .toString() ==
                                                                          "0") {
                                                                        Get.snackbar(
                                                                            "Note",
                                                                            "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Chat",
                                                                            backgroundColor:
                                                                                Colors.orange,
                                                                            colorText: Colors.white);
                                                                      } else {
                                                                        double charge = searchController.astrologerList[index].charge !=
                                                                                null
                                                                            ? double.parse(searchController.astrologerList[index].charge.toString())
                                                                            : 0;
                                                                        if (charge * 5 <= global.splashController.currentUser!.walletAmount! ||
                                                                            searchController.astrologerList[index].isFreeAvailable ==
                                                                                true) {
                                                                          await bottomNavigationController.checkAlreadyInReq(searchController
                                                                              .astrologerList[index]
                                                                              .id!);
                                                                          if (bottomNavigationController.isUserAlreadyInChatReq ==
                                                                              false) {
                                                                            if (searchController.astrologerList[index].chatStatus ==
                                                                                "Online") {
                                                                              global.showOnlyLoaderDialog(context);

                                                                              await Get.to(() => CallIntakeFormScreen(
                                                                                    type: type,
                                                                                    // index: index,
                                                                                    astrologerId: searchController.astrologerList[index].id!,
                                                                                    astrologerName: searchController.astrologerList[index].name!,
                                                                                    astrologerProfile: searchController.astrologerList[index].profileImage!,
                                                                                    isFreeAvailable: searchController.astrologerList[index].isFreeAvailable!,
                                                                                    rate: charge.toString(),
                                                                                  ));
                                                                              global.hideLoader();
                                                                            } else if (searchController.astrologerList[index].chatStatus == "Offline" ||
                                                                                searchController.astrologerList[index].chatStatus == "Wait Time" ||
                                                                                searchController.astrologerList[index].chatStatus == "Busy") {
                                                                              bottomNavigationController.dialogForJoinInWaitList(context, searchController.astrologerList[index].name ?? "Astro", true, bottomNavigationController.astrologerbyId[0].chatStatus.toString(), searchController.astrologerList[index].profileImage ?? "");
                                                                            }
                                                                          } else {
                                                                            bottomNavigationController.dialogForNotCreatingSession(context);
                                                                          }
                                                                        } else {
                                                                          global
                                                                              .showOnlyLoaderDialog(context);
                                                                          await walletController
                                                                              .getAmount();
                                                                          global
                                                                              .hideLoader();
                                                                          global.showMinimumBalancePopup(
                                                                              context,
                                                                              (charge * 5).toString(),
                                                                              '${searchController.astrologerList[index].name!}',
                                                                              walletController.payment,
                                                                              'Chat');
                                                                        }
                                                                      }
                                                                    }
                                                                  },
                                                                  child: searchController
                                                                              .astrologerList[index]
                                                                              .isFreeAvailable ==
                                                                          true
                                                                      ? Text(
                                                                          'FREE',
                                                                          style: Get.theme.textTheme.titleMedium!.copyWith(
                                                                              fontSize: 12,
                                                                              fontWeight: FontWeight.w500,
                                                                              letterSpacing: 0,
                                                                              color: Colors.white),
                                                                        ).tr()
                                                                      : Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            Icon(
                                                                              CupertinoIcons.chat_bubble_fill,
                                                                              size: 15,
                                                                              color: Colors.white,
                                                                            ),
                                                                            Text(
                                                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${searchController.astrologerList[index].charge}/min',
                                                                              style: Get.theme.primaryTextTheme.bodySmall!.copyWith(color: Colors.white),
                                                                            ).tr(),
                                                                          ],
                                                                        ),
                                                                )
                                                              : SizedBox(
                                                                  height: 80,
                                                                  width: 80,
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Center(
                                                                              child: GetBuilder<CallController>(
                                                                                builder: (CallController controller) => InkWell(
                                                                                  onTap: () async {
                                                                                    bool isLogin = await global.isLogin();
                                                                                    if (isLogin) {
                                                                                      if (searchController.astrologerList[index].call_sections.toString() == "0") {
                                                                                        Get.snackbar("Note", "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Audio Call", backgroundColor: Colors.orange, colorText: Colors.white);
                                                                                      } else {
                                                                                        double charge = searchController.astrologerList[index].charge != null ? double.parse(searchController.astrologerList[index].charge.toString()) : 0;
                                                                                        if (charge * 5 <= global.splashController.currentUser!.walletAmount! || searchController.astrologerList[index].isFreeAvailable == true) {
                                                                                          await bottomNavigationController.checkAlreadyInReqForCall(searchController.astrologerList[index].id!);
                                                                                          if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                                                                            if (searchController.astrologerList[index].callStatus == "Online") {
                                                                                              global.showOnlyLoaderDialog(context);

                                                                                              await Get.to(() => CallIntakeFormScreen(
                                                                                                    astrologerProfile: searchController.astrologerList[index].profileImage ?? '',
                                                                                                    type: "Call",
                                                                                                    astrologerId: searchController.astrologerList[index].id!,
                                                                                                    astrologerName: searchController.astrologerList[index].name ?? '',
                                                                                                    isFreeAvailable: searchController.astrologerList[index].isFreeAvailable!,
                                                                                                    rate: charge.toString(),
                                                                                                  ));

                                                                                              global.hideLoader();
                                                                                            } else if (searchController.astrologerList[index].callStatus == "Offline" || searchController.astrologerList[index].callStatus == "Wait Time" || searchController.astrologerList[index].callStatus == "Busy") {
                                                                                              bottomNavigationController.dialogForJoinInWaitList(context, searchController.astrologerList[index].name ?? "Astro", true, bottomNavigationController.astrologerbyId[0].callStatus.toString(), searchController.astrologerList[index].profileImage ?? "");
                                                                                            }
                                                                                          } else {
                                                                                            bottomNavigationController.dialogForNotCreatingSession(context);
                                                                                          }
                                                                                        } else {
                                                                                          global.showOnlyLoaderDialog(context);
                                                                                          await walletController.getAmount();
                                                                                          global.hideLoader();
                                                                                          global.showMinimumBalancePopup(context, (charge * 5).toString(), '${searchController.astrologerList[index].name!}', walletController.payment, "Call");
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: CircleAvatar(
                                                                                    radius: 18,
                                                                                    backgroundColor: searchController.astrologerList[index].call_sections.toString() == "0" ? Colors.grey : (searchController.astrologerList[index].callStatus == "Online" ? Colors.green : Colors.orangeAccent),
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.call,
                                                                                        color: Colors.white,
                                                                                        size: 15,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Container(
                                                                            child:
                                                                                Center(
                                                                              child: GetBuilder<CallController>(
                                                                                builder: (CallController controller) => InkWell(
                                                                                  onTap: () async {
                                                                                    bool isLogin = await global.isLogin();
                                                                                    if (isLogin) {
                                                                                      if (searchController.astrologerList[index].call_sections.toString() == "0") {
                                                                                        Get.snackbar("Note", "${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)} disabled Video Call", backgroundColor: Colors.orange, colorText: Colors.white);
                                                                                      } else {
                                                                                        double charge = searchController.astrologerList[index].videoCallRate != null ? double.parse(searchController.astrologerList[index].videoCallRate.toString()) : 0;
                                                                                        if (charge * 5 <= global.splashController.currentUser!.walletAmount! || searchController.astrologerList[index].isFreeAvailable == true) {
                                                                                          await bottomNavigationController.checkAlreadyInReqForCall(searchController.astrologerList[index].id!);
                                                                                          if (bottomNavigationController.isUserAlreadyInCallReq == false) {
                                                                                            if (searchController.astrologerList[index].callStatus == "Online") {
                                                                                              global.showOnlyLoaderDialog(context);

                                                                                              await Get.to(() => CallIntakeFormScreen(
                                                                                                    astrologerProfile: searchController.astrologerList[index].profileImage ?? '',
                                                                                                    type: "Videocall",
                                                                                                    astrologerId: searchController.astrologerList[index].id!,
                                                                                                    astrologerName: searchController.astrologerList[index].name ?? '',
                                                                                                    isFreeAvailable: searchController.astrologerList[index].isFreeAvailable!,
                                                                                                    rate: charge.toString(),
                                                                                                  ));

                                                                                              global.hideLoader();
                                                                                            } else if (searchController.astrologerList[index].callStatus == "Offline" || searchController.astrologerList[index].callStatus == "Busy" || searchController.astrologerList[index].callStatus == "Wait Time") {
                                                                                              bottomNavigationController.dialogForJoinInWaitList(context, searchController.astrologerList[index].name ?? "Astro", true, bottomNavigationController.astrologerbyId[0].callStatus.toString(), searchController.astrologerList[index].profileImage ?? "");
                                                                                            }
                                                                                          } else {
                                                                                            bottomNavigationController.dialogForNotCreatingSession(context);
                                                                                          }
                                                                                        } else {
                                                                                          global.showOnlyLoaderDialog(context);
                                                                                          await walletController.getAmount();
                                                                                          global.hideLoader();
                                                                                          global.showMinimumBalancePopup(context, (charge * 5).toString(), '${searchController.astrologerList[index].name!}', walletController.payment, "Call");
                                                                                        }
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                  child: CircleAvatar(
                                                                                    radius: 18,
                                                                                    backgroundColor: searchController.astrologerList[index].call_sections.toString() == "0" ? Colors.grey : (searchController.astrologerList[index].callStatus == "Online" ? Colors.redAccent : Colors.orangeAccent),
                                                                                    child: Center(
                                                                                      child: Icon(
                                                                                        Icons.video_call,
                                                                                        color: Colors.white,
                                                                                        size: 15,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                          type == "Chat"
                                                              ? (searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .chatStatus ==
                                                                      "Offline"
                                                                  ? (Text(
                                                                      "Currently Offline",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              09),
                                                                    ).tr())
                                                                  : searchController
                                                                              .astrologerList[
                                                                                  index]
                                                                              .chatStatus ==
                                                                          "Wait Time"
                                                                      ? (Text(
                                                                          searchController.astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes > 0
                                                                              ? "Wait till - ${searchController.astrologerList[index].chatWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                                              : "Wait till",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 09),
                                                                        ).tr())
                                                                      : searchController.astrologerList[index].chatStatus ==
                                                                              "Busy"
                                                                          ? Text(
                                                                              "Currently Busy",
                                                                              style: TextStyle(color: Colors.red, fontSize: 09),
                                                                            )
                                                                              .tr()
                                                                          : SizedBox())
                                                              : searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .callStatus ==
                                                                      "Offline"
                                                                  ? (Text(
                                                                      "Currently Offline",
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .red,
                                                                          fontSize:
                                                                              09),
                                                                    ).tr())
                                                                  : searchController
                                                                              .astrologerList[
                                                                                  index]
                                                                              .callStatus ==
                                                                          "Wait Time"
                                                                      ? (Text(
                                                                          searchController.astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes > 0
                                                                              ? "Wait till - ${searchController.astrologerList[index].callWaitTime!.difference(DateTime.now()).inMinutes} min"
                                                                              : "Wait till",
                                                                          style: TextStyle(
                                                                              color: Colors.red,
                                                                              fontSize: 09),
                                                                        ).tr())
                                                                      : searchController.astrologerList[index].callStatus ==
                                                                              "Busy"
                                                                          ? Text(
                                                                              "Currently Busy",
                                                                              style: TextStyle(color: Colors.red, fontSize: 09),
                                                                            ).tr()
                                                                          : SizedBox(),
                                                          RatingBar.builder(
                                                            initialRating:
                                                                searchController
                                                                        .astrologerList[
                                                                            index]
                                                                        .rating ??
                                                                    0.0,
                                                            itemCount: 5,
                                                            allowHalfRating:
                                                                false,
                                                            itemSize: 15,
                                                            ignoreGestures:
                                                                true,
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color: Get.theme
                                                                  .primaryColor,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {},
                                                          ),
                                                          searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .totalOrder ==
                                                                      0 ||
                                                                  searchController
                                                                          .astrologerList[
                                                                              index]
                                                                          .totalOrder ==
                                                                      null
                                                              ? SizedBox()
                                                              : Text(
                                                                  '${searchController.astrologerList[index].totalOrder} orders',
                                                                  style: Get
                                                                      .theme
                                                                      .primaryTextTheme
                                                                      .bodySmall!
                                                                      .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w300,
                                                                    fontSize: 9,
                                                                  ),
                                                                ).tr()
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            searchController
                                                            .isMoreDataAvailable ==
                                                        true &&
                                                    !searchController
                                                        .isAllDataLoaded &&
                                                    searchController
                                                                .astrologerList
                                                                .length -
                                                            1 ==
                                                        index
                                                ? const CircularProgressIndicator()
                                                : const SizedBox(),
                                            if (index == 2 - 1)
                                              const SizedBox(
                                                height: 30,
                                              )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          )
                        : Expanded(
                            child: searchController.astroProduct.isEmpty
                                ? searchResultNotFound()
                                : ListView.builder(
                                    itemCount:
                                        searchController.astroProduct.length,
                                    shrinkWrap: true,
                                    controller: searchController
                                        .searchAstromallScrollController,
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          AstromallController
                                              astromallController =
                                              Get.find<AstromallController>();
                                          global.showOnlyLoaderDialog(context);
                                          print(
                                              'selected product id:- ${searchController.astroProduct[index].id}');
                                          await astromallController
                                              .getproductById(searchController
                                                  .astroProduct[index].id);
                                          global.hideLoader();
                                          Get.to(() => ProductDetailScreen(
                                              index: index));
                                        },
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 38,
                                                      backgroundColor: Get
                                                          .theme.primaryColor,
                                                      child: CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: global
                                                              .buildImageUrl(
                                                                  '${searchController.astroProduct[index].productImage}'),
                                                          imageBuilder: (context,
                                                                  imageProvider) =>
                                                              CircleAvatar(
                                                                  radius: 35,
                                                                  backgroundImage:
                                                                      imageProvider),
                                                          placeholder: (context,
                                                                  url) =>
                                                              const Center(
                                                                  child:
                                                                      CircularProgressIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              Image.asset(
                                                            Images.deafultUser,
                                                            fit: BoxFit.cover,
                                                            height: 50,
                                                            width: 40,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(searchController
                                                                  .astroProduct[
                                                                      index]
                                                                  .name)
                                                              .tr(),
                                                          Text(
                                                            '${searchController.astroProduct[index].features}',
                                                            style: Get.textTheme
                                                                .bodySmall,
                                                          ).tr(),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Text(
                                                                'Starting from: ${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)}${searchController.astroProduct[index].amount}/-',
                                                                style: Get
                                                                    .textTheme
                                                                    .bodySmall,
                                                              ).tr(),
                                                              Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(5),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey,
                                                                      width: 2),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                ),
                                                                child: Text(
                                                                        'Buy Now')
                                                                    .tr(),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            searchController.isMoreDataAvailableForAstromall ==
                                                        true &&
                                                    !searchController
                                                        .isAllDataLoadedForAstromall &&
                                                    searchController
                                                                .astroProduct
                                                                .length -
                                                            1 ==
                                                        index
                                                ? const CircularProgressIndicator()
                                                : const SizedBox(),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                  ],
                );
        }),
      ),
    );
  }

  Widget searchResultNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.red,
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text('oops! No result found').tr(),
          Text('try searching something else').tr(),
          Text(
            'Popular Searches',
            style: Get.textTheme.bodySmall!.copyWith(color: Colors.grey),
          ).tr(),
          FittedBox(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PopularSearchWidget(
                    icon: Icons.phone,
                    color: Color.fromARGB(255, 212, 228, 241),
                    text: 'Call',
                    onTap: () {
                      BottomNavigationController bottomNavigationController =
                          Get.find<BottomNavigationController>();
                      bottomNavigationController.setIndex(3, 0);
                      Get.to(() => BottomNavigationBarScreen(
                            index: 3,
                          ));
                    },
                  ),
                  PopularSearchWidget(
                    icon: Icons.chat,
                    color: Color.fromARGB(255, 238, 221, 236),
                    text: 'Chat',
                    onTap: () {
                      BottomNavigationController bottomNavigationController =
                          Get.find<BottomNavigationController>();
                      bottomNavigationController.setIndex(1, 0);
                      Get.to(() => BottomNavigationBarScreen(
                            index: 1,
                          ));
                    },
                  ),
                  PopularSearchWidget(
                    icon: Icons.live_tv,
                    color: Color.fromARGB(255, 235, 236, 221),
                    text: 'Live',
                    onTap: () {
                      Get.to(() => LiveAstrologerListScreen());
                    },
                  ),
                  PopularSearchWidget(
                      icon: Icons.shopping_bag,
                      color: Color.fromARGB(255, 223, 240, 221),
                      text: 'Shopping',
                      onTap: () {
                        Get.to(() => AstromallScreen());
                      })
                ]),
          ),
        ],
      ),
    );
  }
}
