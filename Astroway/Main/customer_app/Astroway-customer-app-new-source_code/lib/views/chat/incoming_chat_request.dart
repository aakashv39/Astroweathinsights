// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/chatController.dart';
import 'package:AstrowayCustomer/utils/config.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/chat/AcceptChatScreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/bottomNavigationController.dart';
import '../../controllers/timer_controller.dart';
import '../bottomNavigationBarScreen.dart';

class IncomingChatRequest extends StatefulWidget {
  final String? profile;
  final String? astrologerName;
  final String? fireBasechatId;
  final int astrologerId;
  final dynamic chatId;
  final String? fcmToken;
  final String? onesignalsubscriptionid;
  String duration;
  IncomingChatRequest({
    super.key,
    this.profile,
    this.astrologerName,
    this.fireBasechatId,
    required this.astrologerId,
    required this.chatId,
    this.fcmToken,
    required this.duration,
    this.onesignalsubscriptionid,
  });

  @override
  State<IncomingChatRequest> createState() => _IncomingChatRequestState();
}

class _IncomingChatRequestState extends State<IncomingChatRequest> {
  final ChatController chatController = Get.find<ChatController>();

  @override
  void initState() {
    super.initState();
    log('subscription id is now dont use fcmtoken ${widget.onesignalsubscriptionid}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                "Incoming chat request from",
                style: Get.textTheme.bodyLarge,
              ).tr(),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Get.theme.primaryColor,
                    backgroundImage: AssetImage('assets/images/splash.png'),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Astroway',
                    style: Get.textTheme.headlineSmall,
                  ).tr(),
                ],
              )
            ],
          ),
          Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: widget.profile == ""
                    ? Image.asset(
                        Images.deafultUser,
                        fit: BoxFit.fill,
                        height: 50,
                        width: 40,
                      )
                    : CachedNetworkImage(
                        imageUrl: '${websiteUrl}${widget.profile}',
                        imageBuilder: (context, imageProvider) => CircleAvatar(
                            radius: 48, backgroundImage: imageProvider),
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          Images.deafultUser,
                          fit: BoxFit.fill,
                          height: 50,
                          width: 40,
                        ),
                      ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.astrologerName == ""
                    ? 'Astrologer'
                    : widget.astrologerName ?? "",
                style: Get.textTheme.headlineSmall,
              ).tr(),
            ],
          ),
          Column(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await chatController.acceptedChat(widget.chatId);
                  // global.sendOneSignalNotification(
                  //   playerId: widget.onesignalsubscriptionid!,
                  //   title: 'Start simple chat timer',
                  // );
                  chatController.isInchat = true;
                  chatController.isEndChat = false;

                  Get.find<TimerController>().startTimer();
                  chatController.update();
                  Get.to(() => AcceptChatScreen(
                        oneSignalSubscriptionID: widget.onesignalsubscriptionid,
                        flagId: 1,
                        astrologerName: widget.astrologerName ?? "Expert",
                        profileImage: '${widget.profile}',
                        fireBasechatId: widget.fireBasechatId ?? "",
                        astrologerId: widget.astrologerId,
                        chatId: widget.chatId,
                        fcmToken: widget.fcmToken,
                        duration: widget.duration.toString(),
                      ));
                },
                icon: Icon(Icons.chat),
                label: Text("Start chat").tr(),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.green),
                  padding: WidgetStateProperty.all(
                      EdgeInsets.symmetric(vertical: 10, horizontal: 30)),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                  global.showOnlyLoaderDialog(context);
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('is_chatdataAvailable', false);
                  await prefs.setString('chatdata', '');
                  await chatController.rejectedChat(widget.chatId.toString());
                  global.hideLoader();
                  global.callOnFcmApiSendPushNotifications(
                      fcmTokem: [widget.fcmToken],
                      title: 'End chat from customer');

                  Get.find<BottomNavigationController>().setIndex(0, 0);
                  Get.to(() => BottomNavigationBarScreen(index: 0));
                },
                child: Text(
                  "Reject Chat Request",
                  style: Get.textTheme.bodyMedium!.copyWith(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ).tr(),
              ),
            ],
          )
        ],
      ),
    ));
  }
}
