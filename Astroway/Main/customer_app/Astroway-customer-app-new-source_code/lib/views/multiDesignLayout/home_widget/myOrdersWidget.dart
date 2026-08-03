import 'package:AstrowayCustomer/controllers/IntakeController.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/utils/date_converter.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/astrologerProfile.dart';
import 'package:AstrowayCustomer/views/call/onetooneAudio/call_history_detail_screen.dart';
import 'package:AstrowayCustomer/views/chat/AcceptChatScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:cached_network_image/cached_network_image.dart';

class MyOrdersWidget extends StatelessWidget {
  final HomeController homeController;
  MyOrdersWidget({super.key, required this.homeController});
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final callController = Get.find<CallController>();
  final reviewController = Get.find<ReviewController>();

  @override
  Widget build(BuildContext context) {
    return homeController.myOrders.isEmpty
        ? const SizedBox.shrink()
        : SizedBox(
            height: 160,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title + View All
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My orders',
                          style: Get.theme.primaryTextTheme.titleMedium!
                              .copyWith(fontWeight: FontWeight.w500),
                        ).tr(),
                        GestureDetector(
                          onTap: () async {
                            final historyController =
                                Get.find<HistoryController>();
                            global.showOnlyLoaderDialog(context);
                            historyController.chatHistoryList.clear();
                            historyController.chatAllDataLoaded = false;
                            historyController.update();
                            await historyController.getChatHistory(
                                global.currentUserId!, false);
                            global.hideLoader();
                            bottomNavigationController.setBottomIndex(4, 0);
                            bottomNavigationController.persistentTabController!
                                .jumpToTab(4);
                            callController.tabController!.index = 3;
                            callController.update();
                          },
                          child: Text(
                            'View All',
                            style:
                                Get.theme.primaryTextTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Colors.blue[500],
                            ),
                          ).tr(),
                        ),
                      ],
                    ),
                  ),

                  /// Orders List
                  Expanded(
                    child: ListView.builder(
                      itemCount: homeController.myOrders.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(top: 5, left: 10),
                      itemBuilder: (context, index) {
                        final order = homeController.myOrders[index];
                        return _OrderCard(
                          order: order,
                          index: index,
                          bottomNavigationController:
                              bottomNavigationController,
                          reviewController: reviewController,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class _OrderCard extends StatelessWidget {
  final dynamic order;
  final BottomNavigationController bottomNavigationController;
  final ReviewController reviewController;
  final int index;

  _OrderCard(
      {required this.order,
      required this.index,
      required this.bottomNavigationController,
      required this.reviewController});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Card(
        child: Row(
          children: [
            Container(
              height: 65,
              width: 65,
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Get.theme.primaryColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: order.profileImage == ""
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        Images.deafultUser,
                        fit: BoxFit.cover,
                        height: 65,
                        width: 65,
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: global.buildImageUrl('${order.profileImage}'),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          Images.deafultUser,
                          fit: BoxFit.cover,
                          height: 65,
                          width: 65,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(order.astrologerName ?? "Astrologer").tr(),
                  Text(
                    DateConverter.dateTimeStringToDateOnly(
                        order.createdAt.toString()),
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 5),

                  /// Action Buttons
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => _handleTap(context),
                        child: CircleAvatar(
                          radius: 13,
                          child: order.orderType == "call"
                              ? const Icon(Icons.play_arrow, size: 13)
                              : const Icon(Icons.message, size: 13),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);

                          reviewController
                              .getReviewData(order.astrologerId ?? 0);
                          await bottomNavigationController
                              .getAstrologerbyId(order.astrologerId ?? 0);
                          global.hideLoader();
                          if (bottomNavigationController
                              .astrologerbyId.isNotEmpty) {
                            Get.to(() => AstrologerProfile(index: index));
                          }
                        },
                        child: const CircleAvatar(
                          radius: 13,
                          child: Icon(Icons.call, size: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (order.orderType == "call") {
      if (order.callId != 0) {
        final intakeController = Get.find<IntakeController>();
        final historyController = Get.find<HistoryController>();
        global.showOnlyLoaderDialog(context);
        await intakeController.getFormIntakeData();
        await historyController.getCallHistoryById(order.callId!);
        global.hideLoader();
        Get.to(() => CallHistoryDetailScreen(
              astrologerId: order.astrologerId!,
              astrologerProfile: order.profileImage ?? "",
              index: index,
              callType: order.call_type ?? 0,
            ));
      }
    } else if (order.orderType == "chat") {
      if (order.firebaseChatId != "") {
        final chatController = Get.find<ChatController>();
        global.showOnlyLoaderDialog(context);
        await chatController.getuserReview(order.astrologerId!);
        global.hideLoader();
        Get.to(() => AcceptChatScreen(
              flagId: 0,
              profileImage: order.profileImage ?? "",
              astrologerName: order.astrologerName ?? "Astrologer",
              fireBasechatId: order.firebaseChatId!,
              astrologerId: order.astrologerId!,
              chatId: order.id!,
              duration: int.parse(order.totalMin ?? "100").toString(),
            ));
      }
    }
  }
}
