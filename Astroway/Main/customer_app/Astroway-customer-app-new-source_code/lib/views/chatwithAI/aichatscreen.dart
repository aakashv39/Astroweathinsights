// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/chat/endDialog.dart';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../controllers/history_controller.dart';
import '../../controllers/splashController.dart';
import '../../controllers/walletController.dart';
import '../../utils/images.dart';
import '../addMoneyToWallet.dart';
import 'controllers/aiChatController.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class AiChatScreen extends StatefulWidget {
  final String? name;
  final String? imagepath;
  final int? id;
  final bool isfromCosmic;
  final String systemMessage;
  AiChatScreen(
      {super.key,
      required this.name,
      this.isfromCosmic = false,
      this.systemMessage = "",
      required this.imagepath,
      required this.id});

  @override
  _AiChatScreenState createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final aicontroller = Get.put(AiChatController());
  final historyController = Get.put(HistoryController());
  final walletController = Get.find<WalletController>();
  final splashController = Get.find<SplashController>();

  @override
  void dispose() {
    aicontroller.secTimer!.cancel();
    aicontroller.messageList.clear();
    aicontroller.update();
    FocusScope.of(context).unfocus();
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      aicontroller.startTimer();
      aicontroller.update();
    });
    _initSystemMessage();
    super.initState();
  }

  _initSystemMessage() {
    if (widget.isfromCosmic) {
      aicontroller.addMessages(widget.systemMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (aicontroller.totalSeconds <= 60) {
            Get.dialog(
              EndDialog(),
            );
          } else {
            Get.dialog(
              barrierDismissible: false,
              chat_exitdialog(context),
            );
          }
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: Row(
              children: [
                SizedBox(
                  width: 2.w,
                ),
                CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: global.buildImageUrl('${widget.imagepath}'),
                  imageBuilder: (context, imageProvider) => CircleAvatar(
                    radius: 2.3.h,
                    backgroundImage: imageProvider,
                  ),
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Image.asset(
                    Images.deafultUser,
                    height: 2.5.h,
                    width: 2.5.h,
                  ),
                ),
              ],
            ),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    widget.name == null || widget.name == ''
                        ? tr('Chat With AI Astrologer')
                        : '${widget.name}',
                    style: Get.theme.primaryTextTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    )),
                GetBuilder<AiChatController>(builder: (aicontroller) {
                  return Text(
                    aicontroller.formatTime(aicontroller.totalSeconds),
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }),
              ],
            ),
            actions: [
              InkWell(
                onTap: () async {
                  bool isLogin = await global.isLogin();
                  global.showOnlyLoaderDialog(context);
                  await global.splashController.getCurrentUserData();
                  await walletController.getAmount();
                  walletController.update();
                  splashController.update();
                  global.hideLoader();
                  if (isLogin) {
                    Get.to(() => AddmoneyToWallet());
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.white),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(2.w, 1.w, 2.w, 1.w),
                    child: Row(
                      children: [
                        Text(
                            '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ',
                            style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        Text(
                          splashController.currentUser == null
                              ? "00"
                              : "${splashController.currentUser!.walletAmount ?? "00"}",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 12, right: 10),
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(0),
                    ),
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      if (aicontroller.totalSeconds <= 60) {
                        Get.dialog(
                          EndDialog(),
                        );
                      } else {
                        Get.dialog(
                          barrierDismissible: false,
                          CupertinoAlertDialog(
                            title: Text(
                              "Are you sure you want to end chat?",
                              style: Get.textTheme.titleMedium,
                            ).tr(),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () async {
                                  Get.back();
                                  aicontroller.secTimer!.cancel();
                                  await aicontroller.endAIChatTime(
                                      aicontroller.totalSeconds, widget.id);
                                  await historyController.getAiChatHistory(
                                      global.currentUserId!, false);
                                  historyController.update();

                                  Get.back();
                                },
                                child: Text('Exit',
                                        style: TextStyle(color: Colors.blue))
                                    .tr(),
                              ),
                              CupertinoDialogAction(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text('No',
                                        style: TextStyle(color: Colors.blue))
                                    .tr(),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.flag, color: Colors.red),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled:
                          true, // allows full height & keyboard push
                      builder: (context) {
                        TextEditingController messageController =
                            TextEditingController();

                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context)
                                .viewInsets
                                .bottom, // adjust for keyboard
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text("Offensive content"),
                                    onTap: () =>
                                        submitReport("Offensive content"),
                                  ),
                                  ListTile(
                                    title: Text("Spam or misleading"),
                                    onTap: () =>
                                        submitReport("Spam or misleading"),
                                  ),
                                  ListTile(
                                    title: Text("Harassment or bullying"),
                                    onTap: () =>
                                        submitReport("Harassment or bullying"),
                                  ),
                                  Divider(),
                                  TextField(
                                    controller: messageController,
                                    decoration: InputDecoration(
                                      labelText: "Other (please describe)",
                                      border: OutlineInputBorder(),
                                    ),
                                    maxLines: 3,
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      if (messageController.text
                                          .trim()
                                          .isNotEmpty) {
                                        submitReport(
                                            "Other: ${messageController.text.trim()}");
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Text("Submit"),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
          body: GetBuilder<AiChatController>(builder: (aicontroller) {
            return Column(
              children: [
                aicontroller.messageList.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/Ai_chat_icons.gif',
                                height: 15.h,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'Astroway \nYour Personalized AI Astrology Expert...',
                                style: Get.theme.primaryTextTheme.titleSmall!
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black.withOpacity(0.5),
                                ),
                                textAlign: TextAlign.center,
                              ).tr()
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          reverse: true,
                          children:
                              aicontroller.messageList.reversed.map((message) {
                            // Check if the message is the last one in the list (latest message)
                            bool isLastMessage =
                                message == aicontroller.messageList.last;

                            return Align(
                              alignment: message.isFromUser
                                  ? Alignment.topRight
                                  : Alignment.topLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 8.0),
                                child: Container(
                                  margin: message.isFromUser
                                      ? EdgeInsets.only(left: 10.w)
                                      : EdgeInsets.only(right: 10.w),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: message.isFromUser
                                        ? Get.theme.primaryColor
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: message.isFromUser
                                      ? Text(
                                          message.text,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        )
                                      : isLastMessage
                                          ? AnimatedTextKit(
                                              isRepeatingAnimation: false,
                                              repeatForever: false,
                                              displayFullTextOnTap: true,
                                              totalRepeatCount: 1,
                                              animatedTexts: [
                                                TyperAnimatedText(
                                                  message.text,
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              message.text,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                              ),
                                            ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: aicontroller.isTyping
                        ? SpinKitThreeBounce(
                            color: Get.theme.primaryColor,
                            size: 18,
                          )
                        : SizedBox()),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: aicontroller.messageController,
                          decoration: InputDecoration(
                            isDense: true,
                            hintText: tr('Chat With AI Astrologers...'),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Get.theme.primaryColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Get.theme.primaryColor),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 23,
                        backgroundColor: Get.theme.primaryColor,
                        child: IconButton(
                            icon: const Icon(Icons.send),
                            color: Colors.white,
                            onPressed: () {
                              log('Not in Message list');
                              if (aicontroller
                                  .messageController.text.isNotEmpty) {
                                log('Got Down To Message...');
                                aicontroller.addMessages(
                                    aicontroller.messageController.text);
                                log('Gone Below Down');
                                aicontroller.messageController.text = '';
                                FocusScope.of(context).unfocus();
                              } else {
                                Fluttertoast.showToast(
                                    msg: 'Please Enter a Message');
                              }
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  CupertinoAlertDialog chat_exitdialog(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(
        "Are you sure you want to end chat?",
        style: Get.textTheme.titleMedium,
      ).tr(),
      actions: [
        CupertinoDialogAction(
          onPressed: () async {
            Get.back();
            global.showOnlyLoaderDialog(context);
            aicontroller.secTimer!.cancel();
            await aicontroller.endAIChatTime(
                aicontroller.totalSeconds, widget.id);
            await historyController.getAiChatHistory(
                global.currentUserId!, false);
            global.hideLoader();
            aicontroller.messageList.clear();
            Get.find<BottomNavigationController>().setIndex(0, 0);
            Get.to(() => BottomNavigationBarScreen(
                  index: 0,
                ));
          },
          child: Text('Exit', style: TextStyle(color: Colors.blue)).tr(),
        ),
        CupertinoDialogAction(
          onPressed: () {
            Get.back();
          },
          child: Text('No', style: TextStyle(color: Colors.blue)).tr(),
        ),
      ],
    );
  }

  void submitReport(String reason) {
    Get.back();
    // send to backend or Firebase
    Fluttertoast.showToast(
        msg: "We’ve received your report. Our team will review it shortly.");
  }
}
