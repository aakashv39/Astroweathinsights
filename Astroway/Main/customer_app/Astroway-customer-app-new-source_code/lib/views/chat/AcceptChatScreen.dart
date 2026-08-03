// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/chat/endDialog.dart';
import 'package:AstrowayCustomer/views/chat/pdfviewerpage.dart';
import 'package:AstrowayCustomer/views/chat/zoomimagewidget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/index.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../controllers/bottomNavigationController.dart';
import '../../controllers/callController.dart';
import '../../controllers/chatController.dart';
import '../../controllers/reviewController.dart';
import '../../controllers/splashController.dart';
import '../../controllers/timer_controller.dart';
import '../../controllers/walletController.dart';
import '../../model/chat_message_model.dart';
import '../../utils/images.dart';
import '../astrologerProfile/astrologerProfile.dart';
import '../bottomNavigationBarScreen.dart';
import '../customDialog.dart';
import '../../utils/config.dart';
import 'ChatSession.dart';

class AcceptChatScreen extends StatefulWidget {
  final int flagId;
  final String profileImage;
  final String astrologerName;
  final String fireBasechatId;
  final int chatId;
  final int astrologerId;
  final String? fcmToken;
  final int? chatStartedAt;
  String duration;
  final String? oneSignalSubscriptionID;
  bool isFromRejoin;

  AcceptChatScreen({
    super.key,
    required this.flagId,
    required this.profileImage,
    required this.astrologerName,
    required this.fireBasechatId,
    required this.astrologerId,
    required this.chatId,
    this.fcmToken,
    this.chatStartedAt,
    required this.duration,
    this.oneSignalSubscriptionID,
    this.isFromRejoin = false,
  });

  @override
  State<AcceptChatScreen> createState() => _AcceptChatScreenState();
}

class _AcceptChatScreenState extends State<AcceptChatScreen> {
  final messageController = TextEditingController();
  final splashController = Get.find<SplashController>();
  final walletController = Get.find<WalletController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final timerController = Get.find<TimerController>();
  final sendtextfocusnode = FocusNode();
  final chatController = Get.find<ChatController>();
  final callController = Get.find<CallController>();
  final historyController = Get.find<HistoryController>();
  bool? previousIsInChat;
  String? currentChatExecutionId;
  bool stopUserLeftListener = false;
  @override
  void dispose() {
    if (chatController.countdownController != null) {
      chatController.countdownController!.dispose();
      chatController.countdownController = null;
      chatController.update();
    }
    timerController.secTimer?.cancel();
    timerController.secTimer = null;
    timerController.update();
    final chatKey = 'chat_${widget.chatId}_ended';
    global.sp?.remove(chatKey);
    super.dispose();
  }

  bool isTimerEnded = false;
  bool _isEndChatExecuted = false;
  bool _shouldExecuteEndChat() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final chatKey = 'chat_${widget.chatId}_ended';
    if (_isEndChatExecuted) {
      log('🛑 End chat already executed for this session');
      return false;
    }
    final lastEndTime = global.sp?.getInt(chatKey) ?? 0;
    if (now - lastEndTime < 5000) {
      log('🛑 End chat executed recently for chat ${widget.chatId}');
      return false;
    }
    return true;
  }

  Future<bool> isTimeDifferenceExceeded() async {
    final prefs = await SharedPreferences.getInstance();
    final savedtime = prefs.getInt("starttime") ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeDifference = currentTime - savedtime;
    debugPrint("Time gap (seconds): $timeDifference");
    return timeDifference <= 60;
  }

  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>? userLeftStream;
  @override
  void initState() {
    super.initState();

    if (widget.flagId != 0) {
      _isEndChatExecuted = false;
      currentChatExecutionId =
          'chat_${widget.chatId}_${DateTime.now().millisecondsSinceEpoch}';

      if (isTimerEnded) {
        return;
      }
      stopUserLeftListener = false;
      global.readMessage = true;
      global.isCallOrChat = 1;
      print("global.isCallOrChat-> ${global.isCallOrChat}");
      global.ischatended = false;
      _initializeChatStartTime();

      if (chatController.countdownController != null) {
        chatController.countdownController!.dispose();
        chatController.countdownController = null;
        chatController.update();
      }
      _initializeCountdownController();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeChatSession();
        _saveCurrenttime();
      });

      if (widget.isFromRejoin == false) {
        userLeftStream = chatController
            .getUserOnlineStatus(
          userID: widget.astrologerId.toString(),
          firebasid: widget.fireBasechatId,
        )
            .listen((snapshot) {
          bool isInChat = snapshot.data()?['isInChat'] ?? false;

          if (previousIsInChat == true && isInChat == false) {
            global.showToast(
              message: 'Astrologer left the chat',
              textColor: Colors.white,
              bgColor: Colors.green,
            );

            exitChat(chatController, true);
          }

          previousIsInChat = isInChat;
        });
      }
    }

    final chatdata = _chatDuration();
    print("From storage $chatdata");
  }

  void _saveCurrenttime() async {
    final prefs = await SharedPreferences.getInstance();
    int? _starttime = prefs.getInt('starttime');
    debugPrint("Start end time $_starttime");
    if (_starttime == null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setInt('starttime', currentTime);
      debugPrint("First time - Current time saved: $currentTime");
    } else {
      debugPrint("Using existing saved time: $_starttime");
    }
  }

  void _initializeChatStartTime() {
    log("storage Time ${GetStorage().read('chatStartedAt')}");
    if (GetStorage().read('chatStartedAt') == null) {
      global.chatStartedAt = DateTime.now().millisecondsSinceEpoch;
      GetStorage().write('chatStartedAt', global.chatStartedAt);
      if (global.originalChatStartedAt != null ||
          global.originalChatStartedAt != 0) {
        global.originalChatStartedAt = global.chatStartedAt;
      }
      DateTime actualStartTime =
          DateTime.fromMillisecondsSinceEpoch(global.chatStartedAt!);
      log('Chat started at init: ${DateFormat('hh:mm a').format(actualStartTime)} and chatStartedAt is ${global.chatStartedAt}');
    } else {
      log('already set global ${global.chatStartedAt}');
    }
  }

  void _initializeCountdownController() {
    final endTime = DateTime.now().millisecondsSinceEpoch +
        1000 * int.parse(widget.duration.toString());

    chatController.countdownController = CountdownTimerController(
      endTime: endTime,
      onEnd: _onChatTimerEnd,
    );
  }

  int? _chatDuration() {
    final startat = GetStorage().read('chatStartedAt');
    print("my time start $startat");
    if (startat == null) return null;
    int start = startat;
    int now = DateTime.now().millisecondsSinceEpoch;
    int diffMs = now - start;
    int diffSeconds = diffMs ~/ 1000;
    print("my talk duration $diffSeconds");
    return diffSeconds;
  }

  void _onChatTimerEnd() async {
    log('_onChatTimerEnd called $isTimerEnded or ${chatController.isTimerEnded}');
    // Prevent multiple executions with deduplication check
    if (isTimerEnded ||
        chatController.isTimerEnded ||
        !_shouldExecuteEndChat()) {
      log('🛑 End chat execution blocked - already in progress or completed');
      return;
    }

    log('✅ Chat timer ended - executing end chat logic');
    isTimerEnded = true;
    chatController.isTimerEnded = true;
    _markEndChatExecuted(); // Mark as executed immediately

    try {
      await _executeEndChatLogic();
    } catch (e) {
      log('Error in onEnd callback: $e');
    }
  }

  void _markEndChatExecuted() {
    _isEndChatExecuted = true;
    final chatKey = 'chat_${widget.chatId}_ended';
    global.sp?.setInt(chatKey, DateTime.now().millisecondsSinceEpoch);
    Future.delayed(Duration(seconds: 10), () {
      global.sp?.remove(chatKey);
    });
  }

  Future<void> _executeEndChatLogic() async {
    Get.find<ChatController>().sendMessage(
      "Your allotted minutes have expired. To join again, recharge your wallet and then join. For any further assistance, contact customer support",
      widget.fireBasechatId,
      widget.astrologerId,
      true,
    );

    Get.find<ChatController>().showBottomAcceptChat = false;
    global.sp = await SharedPreferences.getInstance();
    global.sp!.remove('chatBottom');
    global.sp!.setInt('chatBottom', 0);

    chatController.chatBottom = false;
    chatController.isInchat = false;
    chatController.isAstrologerEndedChat = false;
    chatController.isEndChat = true;
    chatController.update();
    global.isCallOrChat = 0;
    await chatController.endChatTime(
        int.parse(widget.duration.toString()), widget.chatId, 'chat_timer_end');
    await Get.find<SplashController>().getCurrentUserData();
    Get.find<SplashController>().update();
    await bottomNavigationController.getAstrologerList(isLazyLoading: false);
    // Stop timers
    timerController.stopTimer();

    // Clear navigation data
    _clearNavigationData();

    // Set offline status
    global.chatStartedAt = null;
    GetStorage().remove('chatStartedAt');
    chatController.setOnlineStatus(
        false, widget.fireBasechatId, '${global.currentUserId}',
        from: "execute End ChatLogic");

    // End chat time and update data

    splashController.update();
    bottomNavigationController.update();
    chatController.removeSession(widget.chatId.toString());
    bottomNavigationController.setIndex(0, 0);

    // Navigate away
    Get.offAll(() => BottomNavigationBarScreen(index: 0));
  }

  void _clearNavigationData() {
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
  }

  void _initializeChatSession() {
    if (widget.flagId == 1) {
      log('_initializeChatSession chat session');
      // chatController.acceptedChat(widget.chatId);
      chatController.setOnlineStatus(
          true, widget.fireBasechatId, '${global.currentUserId}',
          from: "_initializeChatSession");
      _saveTostorageRejoin();
    } else {
      log('New chat session started');
    }
    chatController.isTimerEnded = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.flagId == 1) {
          _saveTostorageRejoin();
          global.readMessage = false;
          sendtextfocusnode.unfocus(); //add session
          chatController.countdownController?.dispose();
          chatController.countdownController = null;
          chatController.update();
          final bottomNavigationController =
              Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(0, 0);
          Get.to(() => BottomNavigationBarScreen(
                index: 0,
              ));
          return true;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Get.theme.primaryColor,
            title: GestureDetector(
              onTap: () async {
                print('appbar tapped');
                if (widget.flagId == 0) {
                  global.showOnlyLoaderDialog(context);
                  Future.wait<void>([
                    Get.find<ReviewController>()
                        .getReviewData(widget.astrologerId),
                    bottomNavigationController
                        .getAstrologerbyId(widget.astrologerId)
                  ]);
                  global.hideLoader();
                  Get.to(() => AstrologerProfile(index: 0));
                }
              },
              child: Row(
                children: [
                  CircleAvatar(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: '${imgBaseurl}${widget.profileImage}',
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 6.h,
                        backgroundImage: imageProvider,
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Image.asset(
                        Images.deafultUser,
                        height: 6.h,
                        width: 6.h,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.astrologerName.isEmpty ||
                                widget.astrologerName == ''
                            ? 'User'
                            : widget.astrologerName,
                        style: Get.theme.primaryTextTheme.titleLarge!.copyWith(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.normal,
                            color: Colors.white),
                      ).tr(),
                      StreamBuilder<DocumentSnapshot>(
                          stream: chatController.getTypingStatusStream(
                              partnerID: widget.astrologerId.toString()),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const SizedBox();
                            }

                            if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Container();
                            }
                            // Get the typing status
                            bool isTyping =
                                snapshot.data!['ispartnertyping'] ?? false;
                            log('is user typing $isTyping');
                            if (isTyping)
                              return Text(
                                'typing...',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 14.sp,
                                    ),
                              );
                            else {
                              return SizedBox();
                            }
                          })
                    ],
                  ),
                ],
              ),
            ),
            leading: IconButton(
              onPressed: () async {
                if (widget.flagId == 1) {
                  final session = ChatSession(
                    sessionId: '${widget.chatId}',
                    customerId: int.parse(global.currentUserId.toString()),
                    astrologerId: widget.astrologerId,
                    fireBasechatId: widget.fireBasechatId,
                    customerName: widget.astrologerName,
                    customerProfile: widget.profileImage,
                    chatduration: widget.duration,
                    astrouserID: widget.astrologerId,
                    subscriptionId: widget.oneSignalSubscriptionID,
                  );

                  log('save and backrpess 11');
                  Get.find<ChatController>().addSession(session); //add session
                  BottomNavigationController bottomNavigationController =
                      Get.find<BottomNavigationController>();
                  global.readMessage = false; //add session

                  chatController.countdownController?.dispose();
                  chatController.countdownController = null;
                  chatController.update();
                  bottomNavigationController.setIndex(0, 0);
                  Get.to(() => BottomNavigationBarScreen(
                        index: 0,
                      ));
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colors.white),
            ),
            actions: [
              widget.flagId == 0
                  ? IconButton(
                      onPressed: () async {
                        global.showOnlyLoaderDialog(context);
                        await chatController.shareChat(
                            widget.fireBasechatId, widget.astrologerName);
                        global.hideLoader();
                      },
                      icon: Icon(Icons.share, color: Colors.white),
                    )
                  : Builder(builder: (BuildContext context) {
                      if (widget.flagId == 1) {
                        timerController.chatId = widget.chatId;
                        timerController.update();
                      }
                      return GestureDetector(
                        onTap: () async {
                          if (chatController.isAstrologerEndedChat != true) {
                            final shouldExit = await isTimeDifferenceExceeded();
                            debugPrint("chat shouldExit $shouldExit");
                            if (shouldExit) {
                              debugPrint("before 1 min");
                              Get.dialog(
                                EndDialog(),
                              );
                            } else {
                              debugPrint("after 1 min");
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
                                        global.showOnlyLoaderDialog(context);
                                        final prefs = await SharedPreferences
                                            .getInstance();
                                        await prefs.remove('starttime');
                                        chatController.removeSession(
                                            widget.chatId.toString());
                                        chatController.sendMessage(
                                            '${global.user.name == '' ? 'user' : global.user.name} -> ended chat',
                                            widget.fireBasechatId,
                                            widget.astrologerId,
                                            true);
                                        chatController.setOnlineStatus(
                                            false,
                                            widget.fireBasechatId,
                                            '${global.currentUserId}',
                                            from: "from Exit btn");
                                        chatController.showBottomAcceptChat =
                                            false;
                                        global.sp = await SharedPreferences
                                            .getInstance();
                                        chatController.isEndChat = true;
                                        global.sp!.remove('chatBottom');
                                        global.sp!.setInt('chatBottom', 0);
                                        chatController.chatBottom = false;
                                        chatController.isInchat = false;
                                        chatController.isAstrologerEndedChat =
                                            false;

                                        chatController.update();

                                        timerController.secTimer == null
                                            ? null
                                            : timerController.secTimer!
                                                .cancel();
                                        timerController.update();
                                        bottomNavigationController
                                            .astrologerList
                                            .clear();
                                        bottomNavigationController
                                            .isAllDataLoaded = false;
                                        if (bottomNavigationController
                                                .genderFilterList !=
                                            null) {
                                          bottomNavigationController
                                              .genderFilterList!
                                              .clear();
                                        }
                                        if (bottomNavigationController
                                                .languageFilter !=
                                            null) {
                                          bottomNavigationController
                                              .languageFilter!
                                              .clear();
                                        }
                                        if (bottomNavigationController
                                                .skillFilterList !=
                                            null) {
                                          bottomNavigationController
                                              .skillFilterList!
                                              .clear();
                                        }

                                        bottomNavigationController.applyFilter =
                                            false;
                                        bottomNavigationController.update();
                                        log('endchat 3');
                                        global.isCallOrChat = 0;
                                        Future.wait<void>([
                                          chatController.endChatTime(
                                              timerController.totalSeconds,
                                              widget.chatId,
                                              'actionbutton_endchat'),
                                          bottomNavigationController
                                              .getAstrologerList(
                                                  isLazyLoading: false),
                                        ]);
                                        global.hideLoader();
                                        bottomNavigationController.setIndex(
                                            0, 0);
                                        await Get.find<SplashController>()
                                            .getCurrentUserData();
                                        Get.find<SplashController>().update();
                                        Get.back();
                                        Get.back();
                                        Get.to(() => BottomNavigationBarScreen(
                                            index: 0));
                                        final box = GetStorage();
                                        final session =
                                            box.read("activeChatSession");
                                        if (session != null) {
                                          box.remove("activeChatSession");
                                        }
                                      },
                                      child: Text('Exit',
                                              style:
                                                  TextStyle(color: Colors.blue))
                                          .tr(),
                                    ),
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: Text('No',
                                              style:
                                                  TextStyle(color: Colors.blue))
                                          .tr(),
                                    ),
                                  ],
                                ),
                              );
                            }
                          } else {
                            debugPrint("noting 1 min");
                            endchatDialog(context);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 8),
                          height: 35,
                          padding: const EdgeInsets.all(8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 1),
                            borderRadius: BorderRadius.circular(3.w),
                          ),
                          child: Text(
                            'End chat',
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.white),
                          ).tr(),
                        ),
                      );
                    })
            ],
          ),
          body: Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Stack(
              children: [
                GetBuilder<ChatController>(builder: (chatController) {
                  return KeyboardVisibilityBuilder(
                    builder: (p0, isKeyboardVisible) {
                      if (isKeyboardVisible) {
                        log('keyboard is visible');
                        chatController.updateTypingStatus(true);
                      } else {
                        log('keyboard is invisible');
                        chatController.updateTypingStatus(false);
                      }
                      return Column(
                        children: [
                          Expanded(
                            child:
                                StreamBuilder<
                                        QuerySnapshot<Map<String, dynamic>>>(
                                    stream: chatController.getChatMessages(
                                        widget.fireBasechatId,
                                        int.parse(global.user.id.toString())),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return Text(
                                            'snapShotError :- ${snapshot.error}');
                                      } else {
                                        List<ChatMessageModel> messageList = [];

                                        if (snapshot.hasData) {
                                          for (var res in snapshot.data!.docs) {
                                            messageList.add(
                                                ChatMessageModel.fromJson(
                                                    res.data()));
                                          }
                                        } else {
                                          messageList = [];
                                          log('no data for msg');
                                        }
                                        print(
                                            "global.user.id.toString():- ${global.user.id.toString()}, is read${global.readMessage}");

                                        global.readMessage
                                            ? _markMessagesAsRead()
                                            : null;

                                        return ListView.builder(
                                            physics: BouncingScrollPhysics(),
                                            padding: const EdgeInsets.only(
                                                bottom: 50),
                                            itemCount: messageList.length,
                                            shrinkWrap: true,
                                            reverse: true,
                                            itemBuilder: (context, index) {
                                              print(
                                                  "from  index:- ${index} and message is ${messageList[index].message}:-  ${messageList[index].isRead}");
                                              print(
                                                  "user id 1:-  ${messageList[index].userId1}");
                                              print(
                                                  "user id 2:-  ${messageList[index].userId2}");
                                              ChatMessageModel message =
                                                  messageList[index];
                                              chatController.isMe =
                                                  message.userId1 ==
                                                      '${global.currentUserId}';
                                              return messageList[index]
                                                          .isEndMessage ==
                                                      true
                                                  ? Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              247,
                                                              244,
                                                              211),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        messageList[index]
                                                            .message!,
                                                        style: const TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    )
                                                  : Row(
                                                      mainAxisAlignment:
                                                          chatController.isMe
                                                              ? MainAxisAlignment
                                                                  .end
                                                              : MainAxisAlignment
                                                                  .start,
                                                      children: [
                                                        //Swipe Feature
                                                        SwipeTo(
                                                          key: UniqueKey(),
                                                          iconOnLeftSwipe: Icons
                                                              .arrow_forward,
                                                          iconOnRightSwipe:
                                                              Icons.reply,
                                                          onRightSwipe:
                                                              (details) {
                                                            // log("\n Left Swipe Data --> $details");
                                                            log(" data Swipe Data --> ${messageList[index].toJson()}");

                                                            sendtextfocusnode
                                                                .requestFocus();
                                                            chatController
                                                                    .replymessage =
                                                                messageList[
                                                                    index];
                                                            chatController
                                                                .update();
                                                            log(" Swipe details --> ${chatController.replymessage!.toJson()}");
                                                          },
                                                          swipeSensitivity: 5,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                chatController
                                                                        .isMe
                                                                    ? CrossAxisAlignment
                                                                        .end
                                                                    : CrossAxisAlignment
                                                                        .start,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: chatController
                                                                          .isMe
                                                                      ? messageList[index].attachementPath ==
                                                                              ""
                                                                          ? Color(
                                                                              0xFFfbf1f2)
                                                                          : Colors
                                                                              .white
                                                                      : messageList[index].attachementPath ==
                                                                              ""
                                                                          ? Colors
                                                                              .grey
                                                                              .shade100
                                                                          : Colors
                                                                              .white,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft:
                                                                        const Radius
                                                                            .circular(
                                                                            12),
                                                                    topRight:
                                                                        const Radius
                                                                            .circular(
                                                                            12),
                                                                    bottomLeft: chatController
                                                                            .isMe
                                                                        ? const Radius
                                                                            .circular(
                                                                            0)
                                                                        : const Radius
                                                                            .circular(
                                                                            12),
                                                                    bottomRight: chatController
                                                                            .isMe
                                                                        ? const Radius
                                                                            .circular(
                                                                            0)
                                                                        : const Radius
                                                                            .circular(
                                                                            12),
                                                                  ),
                                                                ),
                                                                padding: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        16),
                                                                margin: const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        16,
                                                                    horizontal:
                                                                        8),
                                                                child: messageList[index]
                                                                            .replymsg !=
                                                                        ""
                                                                    ? Column(
                                                                        children: [
                                                                          IntrinsicHeight(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  color: Colors.green,
                                                                                  width: 1.w,
                                                                                ),
                                                                                SizedBox(width: 3.w), //ssd
                                                                                messageList[index].replymsg != null && messageList[index].replymsg!.contains('.png') || messageList[index].replymsg != null && messageList[index].replymsg!.contains('.jpg') || messageList[index].replymsg != null && messageList[index].replymsg!.contains('.jpeg')
                                                                                    ? CachedNetworkImage(
                                                                                        height: 10.h,
                                                                                        width: 30.w,
                                                                                        imageUrl: messageList[index].replymsg!,
                                                                                        imageBuilder: (context, imageProvider) => Image.network(
                                                                                          messageList[index].replymsg!,
                                                                                          width: MediaQuery.of(context).size.width,
                                                                                          fit: BoxFit.fill,
                                                                                        ),
                                                                                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                        errorWidget: (context, url, error) => Image.asset(
                                                                                          'assets/images/close.png',
                                                                                          height: 10.h,
                                                                                          width: 30.w,
                                                                                          fit: BoxFit.fill,
                                                                                        ),
                                                                                      )
                                                                                    : messageList[index].replymsg!.contains('.pdf')
                                                                                        ? SizedBox(
                                                                                            height: 9.h,
                                                                                            width: 9.h,
                                                                                            child: const Image(image: AssetImage('assets/images/pdf.png')),
                                                                                          )
                                                                                        : messageList[index].replymsg != "" || messageList[index].replymsg != null
                                                                                            ? SizedBox(
                                                                                                width: 70.w,
                                                                                                child: Text(
                                                                                                  '${messageList[index].replymsg}',
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.grey,
                                                                                                    fontSize: 15.sp,
                                                                                                  ),
                                                                                                ))
                                                                                            : SizedBox(
                                                                                                width: 70.w,
                                                                                                child: Text(
                                                                                                  '${messageList[index].message}',
                                                                                                  style: TextStyle(
                                                                                                    color: Colors.grey,
                                                                                                    fontSize: 15.sp,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                70.w,
                                                                            child: Align(
                                                                                alignment: Alignment.centerRight,
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${messageList[index].message}',
                                                                                      style: TextStyle(fontSize: 15.sp, color: Colors.black),
                                                                                    ),
                                                                                    SizedBox(height: 2.w),
                                                                                    Text(DateFormat().add_jm().format(messageList[index].createdAt!),
                                                                                        style: const TextStyle(
                                                                                          color: Colors.grey,
                                                                                          fontSize: 9.5,
                                                                                        )),
                                                                                  ],
                                                                                )),
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : messageList[index].attachementPath !=
                                                                            ""
                                                                        ? messageList[index].attachementPath!.toLowerCase().contains('.pdf')
                                                                            ? InkWell(
                                                                                onTap: () {
                                                                                  debugPrint('pdf onclicked');
                                                                                  Get.to(() => PdfViewerPage(url: messageList[index].attachementPath!));
                                                                                },
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      height: 9.h,
                                                                                      width: 9.h,
                                                                                      child: const Image(image: AssetImage('assets/images/pdf.png')),
                                                                                    ),
                                                                                    Text(DateFormat().add_jm().format(messageList[index].createdAt!),
                                                                                        style: const TextStyle(
                                                                                          color: Colors.grey,
                                                                                          fontSize: 9.5,
                                                                                        )),
                                                                                  ],
                                                                                ),
                                                                              )
                                                                            : messageList[index].attachementPath!.toLowerCase().contains('.png') || messageList[index].attachementPath!.toLowerCase().contains('.jpg') || messageList[index].attachementPath!.toLowerCase().contains('.jpeg')
                                                                                ? InkWell(
                                                                                    onTap: () {
                                                                                      Get.to(() => zoomImageWidget(url: messageList[index].attachementPath!));
                                                                                    },
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                                                      children: [
                                                                                        CachedNetworkImage(
                                                                                          height: 10.h,
                                                                                          width: 30.w,
                                                                                          imageUrl: messageList[index].attachementPath!,
                                                                                          imageBuilder: (context, imageProvider) => Image.network(
                                                                                            messageList[index].attachementPath!,
                                                                                            width: MediaQuery.of(context).size.width,
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                                                                          errorWidget: (context, url, error) => Image.asset(
                                                                                            'assets/images/close.png',
                                                                                            height: 10.h,
                                                                                            width: 30.w,
                                                                                            fit: BoxFit.fill,
                                                                                          ),
                                                                                        ),
                                                                                        Text(DateFormat().add_jm().format(messageList[index].createdAt!),
                                                                                            style: const TextStyle(
                                                                                              color: Colors.grey,
                                                                                              fontSize: 9.5,
                                                                                            )),
                                                                                      ],
                                                                                    ),
                                                                                  )
                                                                                : const SizedBox(
                                                                                    child: Icon(Icons.not_interested_outlined),
                                                                                  )
                                                                        : Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.end,
                                                                            children: [
                                                                              Container(
                                                                                constraints: BoxConstraints(maxWidth: Get.width - 100),
                                                                                child: Text(
                                                                                  messageList[index].message!,
                                                                                  style: TextStyle(
                                                                                    color: chatController.isMe ? Colors.black : Colors.black,
                                                                                  ),
                                                                                  textAlign: chatController.isMe ? TextAlign.start : TextAlign.start,
                                                                                ),
                                                                              ),
                                                                              messageList[index].createdAt != null
                                                                                  ? Container(
                                                                                      padding: EdgeInsets.only(top: 1, left: 1.w, right: 1),
                                                                                      child: Row(
                                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                                        children: [
                                                                                          Text(DateFormat().add_jm().format(messageList[index].createdAt!),
                                                                                              style: const TextStyle(
                                                                                                color: Colors.grey,
                                                                                                fontSize: 9.5,
                                                                                              )),
                                                                                        ],
                                                                                      ),
                                                                                    )
                                                                                  : const SizedBox(),
                                                                              chatController.isMe
                                                                                  ? Icon(
                                                                                      Icons.done_all,
                                                                                      color: messageList[index].isRead == true ? Colors.blue : Colors.grey,
                                                                                    )
                                                                                  : SizedBox()
                                                                            ],
                                                                          ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                            });
                                      }
                                    }),
                          ),
                        ],
                      );
                    },
                  );
                }),
                widget.flagId == 2
                    ? const SizedBox()
                    : Align(
                        alignment: Alignment.bottomCenter,
                        child: widget.flagId == 0
                            ? GestureDetector(
                                onTap: () {
                                  debugPrint('clicked');
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return CustomDialog(
                                            astrologerName:
                                                widget.astrologerName,
                                            astrologerProfile:
                                                widget.profileImage,
                                            astrologerId: widget.astrologerId);
                                      });
                                },
                                child: GetBuilder<ChatController>(
                                    builder: (chatController) {
                                  return Card(
                                    elevation: 1,
                                    child: Container(
                                      width: Get.width,
                                      color: Color.fromARGB(255, 228, 224, 193),
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              chatController.reviewData.isEmpty
                                                  ? 'Add Your Review'
                                                  : 'Your Review',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            chatController.reviewData.isEmpty
                                                ? const SizedBox()
                                                : Row(
                                                    children: [
                                                      splashController
                                                                  .currentUser
                                                                  ?.profile ==
                                                              ""
                                                          ? CircleAvatar(
                                                              radius: 22,
                                                              child:
                                                                  CircleAvatar(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundImage:
                                                                    AssetImage(
                                                                        Images
                                                                            .deafultUser),
                                                              ),
                                                            )
                                                          : CachedNetworkImage(
                                                              imageUrl:
                                                                  "${imgBaseurl}${splashController.currentUser?.profile}",
                                                              imageBuilder:
                                                                  (context,
                                                                      imageProvider) {
                                                                return CircleAvatar(
                                                                  radius: 22,
                                                                  backgroundColor:
                                                                      Colors
                                                                          .white,
                                                                  backgroundImage:
                                                                      NetworkImage(
                                                                          "${imgBaseurl}${splashController.currentUser?.profile}"),
                                                                );
                                                              },
                                                              placeholder: (context,
                                                                      url) =>
                                                                  const Center(
                                                                      child:
                                                                          CircularProgressIndicator()),
                                                              errorWidget:
                                                                  (context, url,
                                                                      error) {
                                                                return CircleAvatar(
                                                                    radius: 22,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    child: Image
                                                                        .asset(
                                                                      Images
                                                                          .deafultUser,
                                                                      fit: BoxFit
                                                                          .fill,
                                                                      height:
                                                                          50,
                                                                    ));
                                                              },
                                                            ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                        child: Container(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                splashController
                                                                        .currentUser!
                                                                        .name!
                                                                        .isEmpty
                                                                    ? 'User'
                                                                    : splashController
                                                                            .currentUser!
                                                                            .name ??
                                                                        'User',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      17.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              ).tr(),
                                                              RatingBar(
                                                                initialRating:
                                                                    chatController
                                                                        .reviewData[
                                                                            0]
                                                                        .rating!
                                                                        .toDouble(),
                                                                itemCount: 5,
                                                                allowHalfRating:
                                                                    true,
                                                                itemSize: 15,
                                                                ignoreGestures:
                                                                    true,
                                                                ratingWidget:
                                                                    RatingWidget(
                                                                  full: const Icon(
                                                                      Icons
                                                                          .grade,
                                                                      color: Colors
                                                                          .yellow),
                                                                  half: const Icon(
                                                                      Icons
                                                                          .star_half,
                                                                      color: Colors
                                                                          .yellow),
                                                                  empty: const Icon(
                                                                      Icons
                                                                          .grade,
                                                                      color: Colors
                                                                          .grey),
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating) {},
                                                              ),
                                                              chatController
                                                                          .reviewData[
                                                                              0]
                                                                          .review !=
                                                                      ""
                                                                  ? Container(
                                                                      child:
                                                                          Text(
                                                                        chatController.reviewData[0].review ??
                                                                            "",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              14.sp,
                                                                          fontWeight:
                                                                              FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      // Container(
                                                      //   width: 6.w,
                                                      //   child: PopupMenuButton(
                                                      //     icon: Icon(
                                                      //       Icons.more_vert,
                                                      //       color: Colors.black,
                                                      //       size: 20,
                                                      //     ),
                                                      //     itemBuilder:
                                                      //         (context) => [
                                                      //       PopupMenuItem(
                                                      //         value: "delete",
                                                      //         child: Text(
                                                      //           'Delete Review',
                                                      //           style: Get
                                                      //               .textTheme
                                                      //               .titleMedium!
                                                      //               .copyWith(
                                                      //                   color: Colors
                                                      //                       .red),
                                                      //         ).tr(),
                                                      //       )
                                                      //     ],
                                                      //     onSelected:
                                                      //         (value) async {
                                                      //       if (value ==
                                                      //           "Edit") {
                                                      //         CustomDialog(
                                                      //             astrologerName:
                                                      //                 widget
                                                      //                     .astrologerName,
                                                      //             astrologerProfile:
                                                      //                 widget
                                                      //                     .profileImage,
                                                      //             astrologerId:
                                                      //                 widget
                                                      //                     .astrologerId);
                                                      //       } else if (value =="delete") {
                                                      //         global
                                                      //             .showOnlyLoaderDialog(
                                                      //                 context);
                                                      //         Future.wait<
                                                      //             void>([
                                                      //           chatController.deleteReview(
                                                      //               chatController
                                                      //                   .reviewData[
                                                      //                       0]
                                                      //                   .id!),
                                                      //           chatController
                                                      //               .getuserReview(
                                                      //                   widget
                                                      //                       .astrologerId)
                                                      //         ]);
                                                      //         global
                                                      //             .hideLoader();
                                                      //       }
                                                      //     },
                                                      //   ),
                                                      // ),
                                                      // SizedBox(
                                                      //   width: 2.w,
                                                      // ),
                                                    ],
                                                  ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              )

                            //SEND MSG LAYOUT
                            : GetBuilder<ChatController>(
                                builder: (cllcontroller) => Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    (cllcontroller.replymessage?.message
                                                    ?.isNotEmpty ==
                                                true ||
                                            cllcontroller
                                                    .replymessage
                                                    ?.attachementPath
                                                    ?.isNotEmpty ==
                                                true)
                                        ? _replywidget()
                                        : const SizedBox.shrink(),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(8, 0, 8, 1.h),
                                      child: GetBuilder<ChatController>(
                                          builder: (chatController) {
                                        return Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      bottomLeft:
                                                          Radius.circular(2.w),
                                                      bottomRight:
                                                          Radius.circular(2.w),
                                                    )),
                                                child: TextFormField(
                                                  maxLines: 6,
                                                  minLines: 1,
                                                  focusNode: sendtextfocusnode,
                                                  controller: messageController,
                                                  onChanged: (value) {},
                                                  cursorColor: Colors.black,
                                                  onFieldSubmitted: (value) {
                                                    debugPrint(
                                                        'enter value is $value');
                                                    sendmessageOnTaporEnter();
                                                  },
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  decoration: InputDecoration(
                                                    hintText:
                                                        'Enter message here',
                                                    hintStyle: TextStyle(
                                                        color: Colors
                                                            .grey.shade600),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 2.w),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(
                                                                2.w),
                                                        bottomRight:
                                                            Radius.circular(
                                                                2.w),
                                                      ),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      2.w),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          2.w)),
                                                      borderSide: BorderSide(
                                                          color: Colors.grey),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin:
                                                  EdgeInsets.only(bottom: 1.h),
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Material(
                                                elevation: 3,
                                                color: Colors.transparent,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(100),
                                                ),
                                                child: Container(
                                                    height: 6.h,
                                                    width: 6.h,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          Colors.grey.shade700,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    child: InkWell(
                                                      onTap: () async {
                                                        //! Attachement work
                                                        String? filepicked =
                                                            await pickFiles();
                                                        log('onclick file is ${filepicked}');
                                                        chatController
                                                            .sendFiletoFirebase(
                                                          widget.fireBasechatId,
                                                          widget.astrologerId,
                                                          File(filepicked!),
                                                        );
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5.0),
                                                        child: Icon(
                                                          Icons.file_copy_sharp,
                                                          size: 18.sp,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 3.0),
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 1.h),
                                                height: 6.h,
                                                width: 6.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade700,
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    sendmessageOnTaporEnter();
                                                  },
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: Icon(
                                                      Icons.send,
                                                      size: 18.sp,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                widget.flagId == 0
                    ? SizedBox()
                    : Positioned(
                        top: 0,
                        left: 0,
                        child: SizedBox(
                          height: 5.h,
                          child: Column(
                            children: [
                              Container(
                                height: 4.h,
                                width: 100.w,
                                color: Get.theme.primaryColor.withOpacity(0.8),
                                child: Center(
                                    child: widget.flagId == 1
                                        ? CountdownTimer(
                                            controller: chatController
                                                .countdownController,
                                            widgetBuilder: (_,
                                                CurrentRemainingTime? time) {
                                              if (time == null) {
                                                return Text(
                                                  'Paid minutes: 00:00',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16.sp,
                                                    color: Colors.white,
                                                  ),
                                                );
                                              }
                                              final hours = time.hours ?? 0;
                                              final minutes = time.min ?? 0;
                                              final seconds = time.sec ?? 0;

                                              String displayTime;
                                              if (hours > 0) {
                                                displayTime =
                                                    'Paid minutes: ${hours.toString().padLeft(2, '0')} :${minutes.toString().padLeft(2, '0')} :${seconds.toString().padLeft(2, '0')}';
                                              } else if (minutes > 0) {
                                                displayTime =
                                                    'Paid minutes: ${minutes.toString().padLeft(2, '0')} :${seconds.toString().padLeft(2, '0')}';
                                              } else {
                                                displayTime =
                                                    'Paid minutes: ${seconds.toString().padLeft(2, '0')}';
                                              }
                                              return Text(
                                                displayTime,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 16.sp,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                          )
                                        : SizedBox()),
                              ),
                              GetBuilder<ChatController>(
                                builder: (chatcontroller) =>
                                    chatcontroller.isUploading
                                        ? Container(
                                            height: 1.h,
                                            width: 100.w,
                                            child: LinearProgressIndicator(
                                              color: Colors.green,
                                              backgroundColor: Colors.pink,
                                            ),
                                          )
                                        : SizedBox.shrink(),
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveTostorageRejoin() {
    final session = ChatSession(
      sessionId: '${widget.chatId}',
      customerId: int.parse(global.currentUserId.toString()),
      astrologerId: widget.astrologerId,
      fireBasechatId: widget.fireBasechatId,
      customerName: widget.astrologerName,
      customerProfile: widget.profileImage,
      chatduration: widget.duration,
      astrouserID: widget.astrologerId,
      subscriptionId: widget.oneSignalSubscriptionID,
    );
    log('save and backrpess 12');
    Get.find<ChatController>().addSession(session);
  }

  void openBottomSheetRechrage(BuildContext context, String minBalance,
      String type, String astrologer, String min) {
    log('minBalance $minBalance astrologer $astrologer  type $type  min $min');
    Get.bottomSheet(
      Container(
        height: 40.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: Get.width * 0.85,
                                    child: minBalance != ''
                                        ? Text('Minimum balance of 5 minutes(${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $minBalance) is required to start $type with $astrologer ',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.red))
                                            .tr()
                                        : const SizedBox(),
                                  ),
                                  GestureDetector(
                                    child: Padding(
                                      padding: minBalance == ''
                                          ? const EdgeInsets.only(top: 8)
                                          : const EdgeInsets.only(top: 0),
                                      child: Icon(
                                        Icons.close,
                                        size: 18,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, bottom: 5),
                                child: Text('Recharge Now',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500))
                                    .tr(),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(Icons.lightbulb_rounded,
                                        color: Get.theme.primaryColor,
                                        size: 13),
                                  ),
                                  Expanded(
                                      child: Text(
                                              'Tip:90% users rechage for 10 mins or more.',
                                              style: TextStyle(fontSize: 12))
                                          .tr())
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
                child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 3.8 / 2.3,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(8),
                    shrinkWrap: true,
                    itemCount: walletController.rechrage.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          global.showOnlyLoaderDialog(context);
                          await walletController.getAmount();
                          global.hideLoader();
                          Get.to(() => AddmoneyToWallet());
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                                child: Text(
                              '${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} ${walletController.rechrage[index]}',
                              style: TextStyle(fontSize: 13),
                            )),
                          ),
                        ),
                      );
                    })),
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

  Widget _replywidget() {
    return Container(
      width: 67.w,
      decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(2.w),
            topRight: Radius.circular(2.w),
          )),
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              color: Colors.green,
              width: 1.w,
            ),
            SizedBox(width: 1.w),
            GetBuilder<ChatController>(
              builder: (cllcontroller) => Stack(
                children: [
                  Container(
                      width: 64.w,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(2.w),
                          topRight: Radius.circular(2.w),
                        ),
                      ),
                      //CHECKC WHAT IS YOU SWIPING
                      child: cllcontroller.replymessage!.message != "" &&
                              cllcontroller.replymessage!.message != null
                          ? Text(
                              '${cllcontroller.replymessage!.message}',
                              style: TextStyle(
                                  fontSize: 15.sp, color: Colors.black),
                            )
                          : cllcontroller.replymessage?.attachementPath != null &&
                                  cllcontroller.replymessage!.attachementPath!
                                      .contains('pdf')
                              ? SizedBox(
                                  height: 9.h,
                                  width: 9.h,
                                  child: const Image(
                                      image:
                                          AssetImage('assets/images/pdf.png')),
                                )
                              : cllcontroller.replymessage?.attachementPath !=
                                              null &&
                                          cllcontroller
                                              .replymessage!.attachementPath!
                                              .toLowerCase()
                                              .contains('.png') ||
                                      cllcontroller.replymessage?.attachementPath !=
                                              null &&
                                          cllcontroller
                                              .replymessage!.attachementPath!
                                              .toLowerCase()
                                              .contains('.jpg') ||
                                      cllcontroller.replymessage?.attachementPath !=
                                              null &&
                                          cllcontroller
                                              .replymessage!.attachementPath!
                                              .toLowerCase()
                                              .contains('.jpeg')
                                  ? CachedNetworkImage(
                                      height: 10.h,
                                      width: 30.w,
                                      imageUrl: cllcontroller
                                          .replymessage!.attachementPath!,
                                      imageBuilder: (context, imageProvider) =>
                                          Image.network(
                                        cllcontroller
                                            .replymessage!.attachementPath!,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.fill,
                                      ),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        'assets/images/close.png',
                                        height: 10.h,
                                        width: 30.w,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                  Positioned(
                    top: 1,
                    right: 1,
                    child: GestureDetector(
                      onTap: () {
                        cllcontroller.replymessage!.reset();
                        cllcontroller.update();
                      },
                      child: const Icon(Icons.close),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void endchatDialog(context) {
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
              global.showOnlyLoaderDialog(context);
              final ChatController chatController = Get.find<ChatController>();
              debugPrint(
                  "on exit ${widget.fireBasechatId}, id ${global.currentUserId}");
              chatController.setOnlineStatus(
                  false, widget.fireBasechatId, '${global.currentUserId}',
                  from: "from end chat dialog");
              chatController.sendMessage(
                  '${global.user.name == '' ? 'user' : global.user.name} -> ended chat',
                  widget.fireBasechatId,
                  widget.astrologerId,
                  true);
              global.chatStartedAt = null;
              GetStorage().remove('chatStartedAt');
              chatController.showBottomAcceptChat = false;
              global.sp = await SharedPreferences.getInstance();
              global.sp!.remove('chatBottom');
              global.sp!.setInt('chatBottom', 0);
              chatController.chatBottom = false;
              chatController.isInchat = false;
              chatController.isAstrologerEndedChat = false;
              chatController.isEndChat = true;
              chatController.update();
              timerController.secTimer!.cancel();
              timerController.update();
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
              log('endchat 2');
              global.isCallOrChat = 0;
              Future.wait<void>([
                chatController.endChatTime(timerController.totalSeconds,
                    widget.chatId, 'end_chat_dialog'),
              ]);
              chatController.countdownController?.dispose();
              chatController.countdownController = null;
              chatController.update();

              await Get.find<SplashController>().getCurrentUserData();
              Get.find<SplashController>().update();
              await bottomNavigationController.getAstrologerList(
                  isLazyLoading: false);
              bottomNavigationController.update();
              global.hideLoader();
              bottomNavigationController.setIndex(0, 0);
              Get.back();
              Get.back();
              Get.to(() => BottomNavigationBarScreen(index: 0));
              final box = GetStorage();
              final session = box.read("activeChatSession");
              if (session != null) {
                box.remove("activeChatSession");
              }
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
      ),
    );
  }

  Future<String?> pickFiles() async {
    // Define the allowed file extensions
    List<String> allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png'];
    // Prompt the user to pick files
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );
    try {
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        log('file is ${files[0].path}');
        return files[0].path;
      } else {
        chatController.isUploading = false;
        chatController.update();

        log('selecting file error');
        return '';
      }
    } on Exception catch (e) {
      chatController.isUploading = false;
      chatController.update();

      log('file error $e');
      return '';
    }
  }

  exitChat(ChatController chatController, bool isback) async {
    if (chatController.isEndChat == false) {
      global.showOnlyLoaderDialog(context);
      final ChatController chatController = Get.find<ChatController>();
      chatController.setOnlineStatus(
          false, widget.fireBasechatId, '${global.currentUserId}',
          from: "from end chat dialog");
      chatController.sendMessage(
          '${global.user.name == '' ? 'user' : global.user.name} -> ended chat',
          widget.fireBasechatId,
          widget.astrologerId,
          true);
      global.chatStartedAt = null;
      GetStorage().remove('chatStartedAt');
      chatController.showBottomAcceptChat = false;
      global.sp = await SharedPreferences.getInstance();
      global.sp!.remove('chatBottom');
      global.sp!.setInt('chatBottom', 0);
      chatController.chatBottom = false;
      chatController.isInchat = false;
      chatController.isAstrologerEndedChat = false;
      chatController.isEndChat = true;
      chatController.update();
      timerController.secTimer!.cancel();
      timerController.update();
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
      log('exitChat 3');
      global.isCallOrChat = 0;
      Future.wait<void>([
        chatController.endChatTime(
            timerController.totalSeconds, widget.chatId, 'end_chat_dialog'),
      ]);

      await Get.find<SplashController>().getCurrentUserData();
      Get.find<SplashController>().update();
      await bottomNavigationController.getAstrologerList(isLazyLoading: false);
      bottomNavigationController.update();
      global.hideLoader();
      bottomNavigationController.setIndex(0, 0);
      Get.back();
      Get.back();
      Get.to(() => BottomNavigationBarScreen(index: 0));
      final box = GetStorage();
      final session = box.read("activeChatSession");
      if (session != null) {
        box.remove("activeChatSession");
      }
    } else {
      debugPrint('ischatcontroller ${chatController.isEndChat}');
    }
  }

  void sendmessageOnTaporEnter() async {
    // sendtextfocusnode.unfocus();
    log("May Message controller ${messageController.text}");
    String refinedMessage =
        chatController.addBlockKeywordInList(messageController.text);
    String filtertext =
        chatController.filterBlockedWordsForSending(refinedMessage);
    log('filtered message: $filtertext');
    if (chatController.tempBlockedKeywords.isNotEmpty) {
      log('tempBlockedKeywords is not empty try to send to api for store');
      chatController.storedefaultmessage(messageController.text);
    } else {
      log('no need to blocked content go ahead');
    }
    // Clear temporary blocked keywords
    chatController.tempBlockedKeywords.clear();

    if (chatController.replymessage!.message != null ||
        chatController.replymessage!.attachementPath != "") {
      log('user replyying msg is ${chatController.replymessage!.message}');
      chatController.sendReplyMessage(
        filtertext, //what we are replying
        widget.fireBasechatId,
        widget.astrologerId,
        false,
        chatController.replymessage?.attachementPath != ""
            ? chatController.replymessage!.attachementPath ?? ''
            : chatController.replymessage?.message ?? 'N/A',
      );

      messageController.clear();
    } else {
      if (messageController.text != "") {
        chatController.sendMessage(
            filtertext, widget.fireBasechatId, widget.astrologerId, false);
        messageController.clear();
      }
    }
    chatController.replymessage!.reset(); //clear reply field too
    chatController.update();
  }

  Future<void> _markMessagesAsRead() async {
    try {
      final unreadMessages = await FirebaseFirestore.instance
          .collection('chats/${widget.fireBasechatId}/userschat')
          .doc('${widget.astrologerId}')
          .collection('messages')
          .where('isRead', isEqualTo: false)
          .get();
      final batch = FirebaseFirestore.instance.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
      log("UserSide → Marked ${unreadMessages.docs.length} messages as read.");
    } catch (e) {
      debugPrint('UserSide → Error marking messages as read: $e');
    }
  }
}
