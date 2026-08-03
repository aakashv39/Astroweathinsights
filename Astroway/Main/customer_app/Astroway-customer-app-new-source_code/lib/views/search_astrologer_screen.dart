// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/languageController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/reportTabFiltter.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/skillController.dart';
import 'package:AstrowayCustomer/views/reportTypeScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import '../controllers/search_controller.dart';
import '../controllers/walletController.dart';
import '../utils/images.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import 'astrologerProfile/astrologerProfile.dart';

// ignore: must_be_immutable
class SeachAstrologerReportScreen extends StatelessWidget {
  SeachAstrologerReportScreen({Key? key}) : super(key: key);

  final reportController = Get.find<ReportController>();
  final reportFilter = Get.find<ReportFilterTabController>();
  final skillController = Get.find<SkillController>();
  final languageController = Get.find<LanguageController>();
  final walletController = Get.find<WalletController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        title: GetBuilder<SearchControllerCustom>(builder: (searchController) {
          return TextField(
            autofocus: true,
            onChanged: (value) async {
              if (value.length > 2) {
                searchController.astrologerList.clear();
                searchController.isAllDataLoaded = false;
                searchController.searchString = value;
                searchController.update();
                await searchController.getSearchResult(
                    value, 'astrologer', false);
              }
            },
            decoration: InputDecoration(
              hintText: 'Search by Name',
              border: OutlineInputBorder(borderSide: BorderSide.none),
            ),
          );
        }),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Get.theme.iconTheme.color,
              ))
        ],
      ),
      body: GetBuilder<SearchControllerCustom>(builder: (searchController) {
        return searchController.astrologerList.isEmpty
            ? Center(
                child: Text('Astrologer not found').tr(),
              )
            : ListView.builder(
                itemCount: searchController.astrologerList.length,
                shrinkWrap: true,
                controller: searchController.searchScrollController,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async {
                      Get.find<ReviewController>().getReviewData(
                          searchController.astrologerList[index].id!);
                      BottomNavigationController bottomNavigationController =
                          Get.find<BottomNavigationController>();
                      global.showOnlyLoaderDialog(context);
                      await bottomNavigationController.getAstrologerbyId(
                          searchController.astrologerList[index].id!);
                      global.hideLoader();
                      Get.to(() => AstrologerProfile(
                            index: index,
                          ));
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child: Container(
                                              height: 65,
                                              width: 65,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(7),
                                                  border: Border.all(
                                                      color: Get
                                                          .theme.primaryColor)),
                                              child: CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                child: CachedNetworkImage(
                                                  height: 55,
                                                  width: 55,
                                                  imageUrl: global.buildImageUrl(
                                                      '${searchController.astrologerList[index].profileImage}'),
                                                  placeholder: (context, url) =>
                                                      const Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                  errorWidget:
                                                      (context, url, error) {
                                                    return CircleAvatar(
                                                        radius: 35,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Image.asset(
                                                          Images.deafultUser,
                                                          fit: BoxFit.fill,
                                                          height: 50,
                                                        ));
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                              right: 0,
                                              child: Image.asset(
                                                Images.right,
                                                height: 18,
                                              ))
                                        ],
                                      ),
                                    ),
                                    RatingBar.builder(
                                      initialRating: 0,
                                      itemCount: 5,
                                      allowHalfRating: false,
                                      itemSize: 15,
                                      ignoreGestures: true,
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Get.theme.primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {},
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          Images.userProfile,
                                          height: 10,
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          '${searchController.astrologerList[index].totalOrder} orders',
                                          style: Get
                                              .theme.primaryTextTheme.bodySmall!
                                              .copyWith(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 9,
                                          ),
                                        ).tr(),
                                      ],
                                    )
                                  ],
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          searchController
                                              .astrologerList[index].name!,
                                        ).tr(),
                                        Text(
                                          searchController
                                              .astrologerList[index].allSkill!,
                                          style: Get
                                              .theme.primaryTextTheme.bodySmall!
                                              .copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ).tr(),
                                        Text(
                                          searchController.astrologerList[index]
                                              .languageKnown!,
                                          style: Get
                                              .theme.primaryTextTheme.bodySmall!
                                              .copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ).tr(),
                                        Text(
                                          'Experience : ${searchController.astrologerList[index].experienceInYears} Years',
                                          style: Get
                                              .theme.primaryTextTheme.bodySmall!
                                              .copyWith(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.grey[600],
                                          ),
                                        ).tr(),
                                        Row(
                                          children: [
                                            Text(
                                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${searchController.astrologerList[index].reportRate}/report',
                                              style: Get
                                                  .theme.textTheme.titleMedium!
                                                  .copyWith(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                letterSpacing: 0,
                                              ),
                                            ).tr(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                TextButton(
                                  style: ButtonStyle(
                                    padding: WidgetStateProperty.all(
                                        EdgeInsets.all(0)),
                                    fixedSize: WidgetStateProperty.all(
                                        Size.fromWidth(90)),
                                    backgroundColor:
                                        WidgetStateProperty.all(Colors.green),
                                    shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                  onPressed: () async {
                                    bool isLogin = await global.isLogin();
                                    if (isLogin) {
                                      double charge = double.parse(
                                          searchController
                                              .astrologerList[index].reportRate
                                              .toString());
                                      if (charge <=
                                          global.splashController.currentUser!
                                              .walletAmount!) {
                                        global.showOnlyLoaderDialog(context);
                                        reportController.searchString = null;
                                        reportController.reportTypeList = [];
                                        reportController.reportTypeList.clear();
                                        reportController.isAllDataLoaded =
                                            false;
                                        reportController.update();
                                        await reportController.getReportTypes(
                                            null, false);
                                        global.hideLoader();
                                        Get.to(() => ReportTypeScreen(
                                              astrologerId: searchController
                                                  .astrologerList[index].id!,
                                              astrologerName: searchController
                                                  .astrologerList[index].name!,
                                            ));
                                      } else {
                                        global.showOnlyLoaderDialog(context);
                                        await walletController.getAmount();
                                        global.hideLoader();
                                        global.showMinimumBalancePopup(
                                            context,
                                            charge.toString(),
                                            '${searchController.astrologerList[index].name!}',
                                            walletController.payment,
                                            "",
                                            isForGift: true);
                                      }
                                    }
                                  },
                                  child: Text(
                                    'Get report',
                                    style: Get.theme.primaryTextTheme.bodySmall!
                                        .copyWith(color: Colors.white),
                                  ).tr(),
                                )
                              ],
                            ),
                          ),
                        ),
                        searchController.isMoreDataAvailable == true &&
                                !searchController.isAllDataLoaded &&
                                searchController.astrologerList.length - 1 ==
                                    index
                            ? const CircularProgressIndicator()
                            : const SizedBox(),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  );
                },
              );
      }),
    );
  }
}
