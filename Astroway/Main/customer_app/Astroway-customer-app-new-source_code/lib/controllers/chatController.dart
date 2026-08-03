// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:get_storage/get_storage.dart';
import 'package:AstrowayCustomer/model/astrologerCategoryModel.dart';
import 'package:AstrowayCustomer/model/astrologer_model.dart';
import 'package:AstrowayCustomer/model/reviewModel.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/views/chat/ChatSession.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/blockkeywordModel.dart';
import '../model/message_model.dart';
import '../model/chat_message_model.dart';
import 'package:pdf/widgets.dart' as pw;

class ChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var categoryList = <AstrologerCategoryModel>[];
  int isSelected = 0.obs();
  TabController? categoryTab;
  var astroList = <AstrologerModel>[];
  var reviewData = <ReviewModel>[];
  bool isEndChat = false;
  int? myindex;
  CountdownTimerController? countdownController;
  bool chatendbyAstro = false;

  int? astrologerId;
  APIHelper apiHelper = APIHelper();
  //agora chat channnelName for current user and current astrologer
  String channelId = "";
  // agora current user id
  String agorauserId = "";
  //  agora current astrologer user id
  double? rating;
  bool isPublic = true;
  TextEditingController reviewController = TextEditingController();

  String agoraAstrologerUserId = "";
  ChatMessageModel chatmessage = ChatMessageModel();
  CollectionReference userChatCollectionRef =
      FirebaseFirestore.instance.collection("chats");
  CollectionReference pujachatCollection =
      FirebaseFirestore.instance.collection("pujachats");
  bool showBottomAcceptChat = false;
  int? bottomAstrologerId;
  String bottomAstrologerName = "Astrologer";
  String? bottomAstrologerProfile;
  String? bottomFirebaseChatId;
  int? bottomChatId;
  String? bottomFcmToken;
  bool? isAstrologerEndedChat;
  bool chatBottom = false;
  bool isInchat = false;
  var pdf = pw.Document();
  String? duration;
  CollectionReference userChatCollectionRefRTM =
      FirebaseFirestore.instance.collection("LiveChats");
  bool isTimerEnded = false;
  ChatMessageModel? replymessage = ChatMessageModel();
  bool isUploading = false;
  final activeSessions = <String, ChatSession>{}.obs;

  void addSession(ChatSession session) {
    activeSessions[session.sessionId] = session;
    saveChatSession(session);
    update();
  }

  bool _isEndingChat = false;
  final box = GetStorage();
  endChatTime(int seconds, int chatIdd, String fromwhere) async {
    try {
      print("from where- ${fromwhere}");
      int? savedStartTime = box.read('saveStartChatTimeoneTime');
      print("savedStartTime- ${savedStartTime}");
      if (savedStartTime == null) {
        print("No start time found");
        return;
      }
      int currentTime = DateTime.now().millisecondsSinceEpoch;
      print("currentTime- ${currentTime}");

      int diffMillis = currentTime - savedStartTime;
      int diffSeconds = (diffMillis / 1000).floor();
      print("Chat lasted: $diffSeconds seconds");
      if (diffSeconds <= 0) {
        print("Invalid time difference. Returning.");
        return;
      }

      await apiHelper
          .saveChattingTime(diffSeconds, chatIdd, fromwhere)
          .then((result) {
        if (result.status == "200") {
          Get.find<SplashController>().currentUser?.walletAmount =
              result.recordList;
          box.remove('saveStartChatTimeoneTime');
          global.ischatended = true;
          global.showToast(
            message: 'Chat ended..',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        }
      });
    } catch (e) {
      print('Exception in endchat : - ${e.toString()}');
    }
  }

  void saveChatSession(ChatSession session) {
    try {
      final box = GetStorage();
      final sessionData = {
        "chatId": session.sessionId,
        "customerId": session.customerId,
        "astrologerId": session.astrologerId,
        "fireBasechatId": session.fireBasechatId,
        "customerName": session.customerName,
        "customerProfile": session.customerProfile,
        "chatDuration": session.chatduration,
        "astroUserId": session.astrouserID,
        "subscriptionId": session.subscriptionId,
        "lastSaved": DateTime.now().toIso8601String(),
      };
      box.write("activeChatSession", sessionData);
      final data = box.read("activeChatSession");
      print("✅ Chat session saved successfully ${data["astrologerId"]}");
    } catch (e, stacktrace) {
      print("❌ Failed to save chat session: $e");
      print(stacktrace);
    }
  }

  void removeSession(String sessionId) {
    global.chatStartedAt = null;
    GetStorage().remove('chatStartedAt');
    GetStorage().remove("activeChatSession");
    global.isCallOrChat = 0;
    activeSessions.remove(sessionId);
    update();
  }

  @override
  void onInit() async {
    await _init();
    super.onInit();
    categoryTab = TabController(
        vsync: this, length: categoryList.length, initialIndex: isSelected);
  }

  Future<void> setOnlineStatus(
      bool isOnline, String firebaseChatId, String currentUserId,
      {String? from}) async {
    log('Call online Status ${from} OnlineStatus = $isOnline CurrentUser= $currentUserId FirebaseChatId= $firebaseChatId');
    try {
      await FirebaseFirestore.instance
          .collection('chats/$firebaseChatId/userschat')
          .doc(currentUserId)
          .collection('status')
          .doc('chatStatus')
          .set({'isInChat': isOnline}, SetOptions(merge: true));
    } catch (err) {
      print("Exception - setOnlineOfflineStatus: ${err.toString()}");
    }
  }

  Future<void> updateTypingStatus(bool isTyping) async {
    try {
      await userisTypingChatCollectionRef
          .doc(global.currentUserId.toString())
          .set({'isusertyping': isTyping}, SetOptions(merge: true));
    } catch (e) {
      log('Exception in updateTypingStatus: ${e.toString()}');
    }
  }

  CollectionReference userisTypingChatCollectionRef =
      FirebaseFirestore.instance.collection("chatTyping");
  Stream<DocumentSnapshot>? getTypingStatusStream({required String partnerID}) {
    // log('firebase  channelID $partnerID');
    try {
      return userisTypingChatCollectionRef.doc(partnerID).snapshots();
    } catch (err) {
      print("Exception - chatcontroller.dart - firebase" + err.toString());
      return null;
    }
  }

  @override
  void dispose() {
    categoryTab?.dispose();
    super.dispose();
  }

  _init() async {
    await getAstrologerCategorys();
  }

  final List<String> myblockedList = [];
  List<Keyword> blockedKeywordList = [];
  Set<String> tempBlockedKeywords = {};

  String addBlockKeywordInList(String text) {
    if (blockedKeywordList[0].type == "offensive-word") {
      List<String> keywords = blockedKeywordList
          .where((keyword) => keyword.pattern != null)
          .expand((keyword) {
            return keyword.pattern!.contains('[')
                ? keyword.pattern!.replaceAll(RegExp(r'[\[\]"]'), '').split(',')
                : [keyword.pattern!];
          })
          .map((word) => word.trim())
          .toList();

      final pattern = RegExp(
          r'\b(' + keywords.map(RegExp.escape).join('|') + r')\b',
          caseSensitive: false);
      text = text.replaceAllMapped(pattern, (match) {
        String keywordMatch = match.group(0)!;
        tempBlockedKeywords.add(keywordMatch);
        return keywordMatch;
      });
    } else {
      print('no patter available');
    }

    if (blockedKeywordList[1].type == "phone" &&
        blockedKeywordList[1].pattern == "true") {
      final phonePattern =
          RegExp(r'\b(?:\+?\d{1,4})?[\s-]?\d{10}\b'); // Match phone numbers
      text = text.replaceAllMapped(phonePattern, (match) {
        String phoneMatch = match.group(0)!;
        tempBlockedKeywords.add(phoneMatch);
        print(
            'added temp keyword is $phoneMatch  in list is $tempBlockedKeywords');

        if (phoneMatch.length > 4) {
          String firstTwo = phoneMatch.substring(0, 2);
          String lastTwo = phoneMatch.substring(phoneMatch.length - 2);
          String maskedMiddle = '*' * (phoneMatch.length - 4);
          return firstTwo + maskedMiddle + lastTwo;
        } else {
          return phoneMatch;
        }
      });
    } else {
      print('phone no is not true');
    }

    // Process email addresses
    if (blockedKeywordList[2].type == "email" &&
        blockedKeywordList[2].pattern == "true") {
      final emailPattern = RegExp(
          r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b'); // Match emails
      text = text.replaceAllMapped(emailPattern, (match) {
        String emailMatch = match.group(0)!;
        tempBlockedKeywords.add(emailMatch);
        int atIndex = emailMatch.indexOf('@');
        if (atIndex > 1) {
          return emailMatch[0] +
              '*' * (atIndex - 1) +
              emailMatch.substring(atIndex);
        } else {
          return '*' * atIndex + emailMatch.substring(atIndex);
        }
      });
    } else {
      print('email no is not true');
    }

    log('Blocked keywords used are $tempBlockedKeywords');

    return text;
  }

  String filterBlockedWordsForSending(String text) {
    List<String> keywords = blockedKeywordList
        .where((keyword) => keyword.pattern != null)
        .expand((keyword) {
          return keyword.pattern!.contains('[')
              ? keyword.pattern!.replaceAll(RegExp(r'[\[\]"]'), '').split(',')
              : [keyword.pattern!];
        })
        .map((word) => word.trim())
        .toList();

    final pattern = RegExp(
        r'\b(' + keywords.map(RegExp.escape).join('|') + r')\b',
        caseSensitive: false);

    text = text.replaceAllMapped(pattern, (match) {
      String matchedWord = match.group(0)!;
      print('Matched Word: $matchedWord');

      if (matchedWord.length > 2) {
        String firstChar = matchedWord[0];
        String lastChar = matchedWord[matchedWord.length - 1];
        String maskedMiddle = '*' * (matchedWord.length - 2); // Mask the middle
        return firstChar + maskedMiddle + lastChar;
      } else {
        return '*' * matchedWord.length;
      }
    });

    if (blockedKeywordList[1].type == "phone" &&
        blockedKeywordList[1].pattern == "true") {
      final phonePattern = RegExp(r'\b(?:\+?\d{1,4})?[\s-]?\d{10}\b');
      text = text.replaceAllMapped(phonePattern, (match) {
        String phoneMatch = match.group(0)!;
        if (phoneMatch.length > 4) {
          String firstTwo = phoneMatch.substring(0, 2);
          String lastTwo = phoneMatch.substring(phoneMatch.length - 2);
          String maskedMiddle = '*' * (phoneMatch.length - 4);
          return firstTwo + maskedMiddle + lastTwo;
        } else {
          return phoneMatch;
        }
      });
    }
    final emailPattern =
        RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    if (blockedKeywordList[2].type == "email" &&
        blockedKeywordList[2].pattern == "true") {
      text = text.replaceAllMapped(emailPattern, (match) {
        String emailMatch = match.group(0)!;
        int atIndex = emailMatch.indexOf('@');
        if (atIndex > 1) {
          return emailMatch[0] +
              '*' * (atIndex - 1) +
              emailMatch.substring(atIndex);
        } else {
          return '*' * atIndex + emailMatch.substring(atIndex);
        }
      });
    }
    return text;
  }

  Future<void> sendReplyMessage(String message, String chatId, int partnerId,
      bool isEndMessage, String replymsg) async {
    debugPrint('chatID $chatId partnerId $partnerId');
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: replymsg,
        );
        update();
        await uploadMessage(chatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  // Update Profile Image on Firebase
  Future<void> updateProfileImage(
      String partnerId, String chatId, String imageUrl) async {
    ChatMessageModel chatMessageModel = ChatMessageModel(
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isDelete: false,
      isRead: true,
      userId1: '${global.currentUserId}',
      userId2: '$partnerId',
      attachementPath: imageUrl,
      isEndMessage: false,
    );
    // Upload the message to Firestore
    await uploadMessage(chatId, '$partnerId', chatMessageModel);
  }

  Future<void> uploadImage(
      File imageFile, String partnerId, String chatId) async {
    try {
      final storageReference = FirebaseStorage.instance.ref().child(
          '$chatId/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
      final uploadTask = await storageReference.putFile(imageFile);
      if (uploadTask.state == TaskState.success) {
        debugPrint('image uploaded');
      }
      String downloadURL = await storageReference.getDownloadURL();
      debugPrint('File Uploaded: $downloadURL');
      updateProfileImage(partnerId, chatId, downloadURL);
    } catch (e) {
      log("Upload image exception:- $e");
      isUploading = false;
      update();
    }
  }

//UPload Files to firebase
  Future<void> sendFiletoFirebase(
    // String message,
    String chatId,
    int partnerId,
    File? file,
  ) async {
    try {
      if (file != null) {
        isUploading = true;
        update();
        uploadImage(file, partnerId.toString(), chatId);
      } else {
        debugPrint('no file to upload on firebase');
      }
    } catch (e) {
      print('Exception in sendMessage (sendFiletoFirebase) ${e.toString()}');
    }
  }

  storedefaultmessage(String msg) async {
    try {
      await global.checkBody().then(
        (result) async {
          if (result) {
            await apiHelper
                .storedefaultmessageApi(msg, blockcustomerid, blockpartnerid)
                .then(
              (result) {
                if (result.status == "200") {
                  update();
                } else {
                  global.showToast(
                      message: 'Failed to send default message',
                      textColor: global.textColor,
                      bgColor: global.toastBackGoundColor);
                }
              },
            );
          }
        },
      );
      update();
    } catch (e) {
      print('Exception:  - storedefaultmessage(): ' + e.toString());
    }
  }

  bool isMeForShare = false;
  shareChat(String chatId, String astrologer) async {
    try {
      await global.commonShareMethod(
          title:
              "${global.getSystemFlagValueForLogin(global.systemFlagNameList.appName)}",
          subject:
              "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career.Check my chat with $astrologer.You should also try and see your future first chat is Free!\n${global.splashController.appShareLinkForLiveSreaming}");
    } catch (e) {
      log('Exception in shareChat $e');
    }
  }

  Future<List<ChatMessageModel?>?> getShareMessages({String? chatId}) async {
    try {
      Stream<List<ChatMessageModel>> m = FirebaseFirestore.instance
          .collection('chats/$chatId/userschat')
          .doc('${global.currentUserId}')
          .collection('messages')
          .orderBy("createdAt", descending: false)
          .snapshots()
          .map((reviews) => reviews.docs
              .map((review) => ChatMessageModel.fromJson(review.data()))
              .toList());
      print(m.length);
      List<ChatMessageModel> mm = await m.first;
      return mm.isNotEmpty ? mm : [];
    } catch (err) {
      print(
          "Exception - apiHelper.dart - getShareMessages() ${err.toString()}");
      return null;
    }
  }

  showBottomAcceptChatRequest(
      {required int? astrologerId,
      required dynamic chatId,
      required String astroName,
      required String fcmToken,
      required String astroProfile,
      required String? firebaseChatId,
      required String duration}) async {
    log("check");
    showBottomAcceptChat = true;
    bottomAstrologerId = astrologerId;
    bottomAstrologerName = astroName;
    bottomAstrologerProfile = astroProfile;
    bottomFirebaseChatId = firebaseChatId;
    bottomChatId = chatId;
    bottomFcmToken = fcmToken;
    duration = duration;
    update();
    print('showBottomAcceptChat:- $showBottomAcceptChat');
    global.sp = await SharedPreferences.getInstance();
    global.sp!.remove('chatBottom');
    // global.sp!.remove('chatBottom');
    await global.sp!.setInt('chatBottom', 1);
    await global.sp!.setInt('bottomAstrologerId', astrologerId ?? 0);
    await global.sp!.setString('bottomAstrologerName', astroName);
    await global.sp!.setString('bottomAstrologerProfile', astroProfile);
    await global.sp!.setString('bottomFirebaseChatId', firebaseChatId ?? '');
    await global.sp!.setString('bottomChatId', chatId);
    await global.sp!.setString('bottomFcmToken', fcmToken);
    await global.sp!.setString('bottomduration', duration);
  }

  bool isAcceptChatLoading = false;

  getAstrologerCategorys() async {
    isAcceptChatLoading = true;
    update();
    try {
      await global.checkBody().then((result) async {
        categoryList = [];
        if (result) {
          await apiHelper.getAstrologerCategory().then((result) {
            isAcceptChatLoading = false;
            update();

            if (result.status == "200") {
              categoryList.add(AstrologerCategoryModel(
                image: '',
                name: 'All',
                id: 1,
              ));
              categoryList.addAll(result.recordList);
              update();
            } else {
              isAcceptChatLoading = false;
              update();

              global.showToast(
                message: 'Failed to get Category',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      isAcceptChatLoading = false;
      update();

      print('Exception in getAstrologerCategory():' + e.toString());
    }
  }

  bool isfreechatwithbalance = false;
  int amountisfreechat = 0;
  String msgisfreechat = '';
  bool requestSuccess = false;

  sendChatRequest(
    int astrologerId,
    bool isFreeSession,
    String time,
    String scheduleType,
    String scheduleTime,
    String scheduleDate,
  ) async {
    try {
      await apiHelper
          .sendAstrologerChatRequest(
        astrologerId,
        isFreeSession,
        time,
        scheduleType,
        scheduleTime,
        scheduleDate,
      )
          .then((response) {
        dynamic rspnse1 = json.decode(response.body)['status'];
        log('chat response status ${rspnse1}');
        log('chat response type ${rspnse1.runtimeType}');

        if (rspnse1 == 200) {
          isfreechatwithbalance = false;
          update();
          // isfreechatwithbalance=false;
          global.showToast(
            message: 'Sending chat request..',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
          requestSuccess = true;
        } else if (rspnse1 == 400) {
          print("400:- ${json.decode(response.body)}");
          print(
              "failed message-  ${json.decode(response.body)['recordList']!['minAmount'] != null}");
          if (json.decode(response.body)['recordList']['minAmount'] != null) {
            String msg = json.decode(response.body)['recordList']["message"];
            dynamic amount =
                json.decode(response.body)['recordList']["minAmount"] ?? 0;
            log('chat amount $amount');
            global.freeRequestMinimum = true;
            global.amountisfreechat = amount;
            msgisfreechat = msg;
            global.showToast(
              message: '${msg}',
              textColor: Colors.white,
              bgColor: Colors.red,
            );
            update();
          } else {
            global.freeRequestMinimum = false;
            update();
            String msg = json.decode(response.body)['recordList']["message"];
            global.showToast(
              message: '${msg}',
              textColor: Colors.white,
              bgColor: Colors.red,
            );
            log('chat msg $msg');
            msgisfreechat = msg;
            Get.back();
            Get.back();
          }

          requestSuccess = false;
          update();
        } else {}
      });
    } catch (e) {
      requestSuccess = true;
      update();
      print('Exception in sendchatRequest : - ${e.toString()}');
    }
  }

  bool isMe = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getChatMessages(
      String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
          .instance
          .collection('chats/$firebaseChatId/userschat')
          .doc('$currentUserId')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
      return null;
    }
  }

  bool pujachatisMe = true;
  Stream<QuerySnapshot<Map<String, dynamic>>>? getPujaChatMessages(
      String firebaseChatId, int? currentUserId) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data = FirebaseFirestore
          .instance
          .collection('pujachats/$firebaseChatId/userschat')
          .doc('$currentUserId')
          .collection('messages')
          .orderBy("createdAt", descending: true)
          .snapshots(); //orderBy("createdAt", descending: true)
      return data;
    } catch (err) {
      print("Exception - apiHelper.dart - getChatMessages()" + err.toString());
      return null;
    }
  }

  Future<void> sendMessage(
      String message, String chatId, int partnerId, bool isEndMessage) async {
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
        );
        update();
        await uploadMessage(chatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage ${e.toString()}');
    }
  }

  uploadMessage(
      String idUser, String partnerId, ChatMessageModel msgModel) async {
    try {
      final String globalId = global.currentUserId.toString();

      final refMessages = userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages');

      final refMessages1 = userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages');

      final newMessage1 = msgModel;
      final newMessage2 = msgModel;

      newMessage2.isRead = false;

      final batch = FirebaseFirestore.instance.batch();

      final messageResult = refMessages.doc();
      batch.set(messageResult, newMessage1.toJson());

      final message1Result1 = refMessages1.doc();
      batch.set(message1Result1, newMessage2.toJson());
      isUploading = false;
      update();
      await batch.commit();
    } catch (err) {
      isUploading = false;
      update();
      log('uploadMessage err $err');
      return {};
    }
  }

  Future<void> sendPujaReplyMessage(String message, String chatId,
      int partnerId, bool isEndMessage, String replymsg) async {
    debugPrint('chatID $chatId partnerId $partnerId');
    try {
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
          replymsg: replymsg,
        );
        update();
        await uploadPujaMessage(chatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage (sendPujaReplyMessage) ${e.toString()}');
    }
  }

  Future<void> sendPujaMessage(
      String message, String chatId, int partnerId, bool isEndMessage) async {
    try {
      debugPrint('chatID $chatId partnerId $partnerId');
      if (message.trim() != '') {
        ChatMessageModel chatMessage = ChatMessageModel(
          message: message,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isDelete: false,
          isRead: true,
          userId1: '${global.currentUserId}',
          userId2: '$partnerId',
          isEndMessage: isEndMessage,
        );
        update();
        await uploadPujaMessage(chatId, '$partnerId', chatMessage);
      } else {}
    } catch (e) {
      print('Exception in sendMessage (sendPujaMessage) ${e.toString()}');
    }
  }

  uploadPujaMessage(
      String idUser, String partnerId, ChatMessageModel msgModel) async {
    try {
      final String globalId = global.currentUserId.toString();

      final refMessages = pujachatCollection
          .doc(idUser)
          .collection('userschat')
          .doc(globalId)
          .collection('messages');

      final refMessages1 = pujachatCollection
          .doc(idUser)
          .collection('userschat')
          .doc(partnerId)
          .collection('messages');

      final newMessage1 = msgModel;
      final newMessage2 = msgModel;

      newMessage2.isRead = false;

      final batch = FirebaseFirestore.instance.batch();

      final messageResult = refMessages.doc();
      batch.set(messageResult, newMessage1.toJson());

      final message1Result1 = refMessages1.doc();
      batch.set(message1Result1, newMessage2.toJson());
      isUploading = false;
      update();
      await batch.commit();
    } catch (err) {
      isUploading = false;
      update();
      log('uploadMessage err $err');
      return {};
    }
  }

  rejectedChat(String cid) async {
    try {
      await apiHelper.rejectChat(cid).then((result) {
        if (result.status == "200") {
          global.showToast(
            message: 'Chat Rejected',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        } else {}
      });
    } catch (e) {
      print("Exception rejectedChat:-" + e.toString());
    }
  }

  BlockKeywordModel? blockkeywordModel;
  dynamic blockcustomerid, blockpartnerid;
  acceptedChat(int chatId) async {
    try {
      debugPrint("Chat Id $chatId");
      await apiHelper.acceptChat(chatId).then((result) {
        if (result.status == "200") {
          print('accept chat result status ${result.status}');
          if (result.status == "200") {
            blockkeywordModel = result.recordList;
            final box = GetStorage();

            if (box.read('saveStartChatTimeoneTime') == null) {
              final now = DateTime.now().millisecondsSinceEpoch;
              box.write('saveStartChatTimeoneTime', now);
              log("Chat start time saved FIRST time only: $now");
            } else {
              log("Chat start time was already saved, skipping...");
            }
            if (blockkeywordModel != null &&
                blockkeywordModel!.keywords!.isNotEmpty) {
              blockcustomerid = blockkeywordModel!.customerId;
              blockpartnerid = blockkeywordModel!.astroUserId;
              blockedKeywordList = blockkeywordModel!.keywords!;
              print('blockedKeywordList ${blockedKeywordList.length}');

              update();
            } else {
              blockedKeywordList = [];
              update();
              global.showToast(
                message: 'Block keyword list is empty',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          }
        } else {
          global.showToast(
            message: 'Failed To Accept Chat',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        }
      });
    } catch (e) {
      print("Exception acceptedChat:-" + e.toString());
    }
  }

  addReview(int astrologerId, String review) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .addAstrologerReview(
            astrologerId,
            rating,
            review,
            !isPublic,
          )
              .then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Thank you!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await getuserReview(astrologerId);
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to add review',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addReview : - ${e.toString()}');
    }
  }

  getuserReview(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getuserReview(global.currentUserId!, astrologerId)
              .then((result) {
            if (result.status == "200") {
              reviewData = result.recordList;
              reviewController.text = reviewData[0].review;
              rating = reviewData[0].rating;
              isPublic = reviewData[0].isPublic == 1 ? false : false;
              update();
            } else {
              global.showToast(
                message: 'Failed to Get Review',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception acceptedChat:-" + e.toString());
    }
  }

  deleteReview(int reviewId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteReview(reviewId).then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your review has been deleted',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              reviewData.clear();
              rating = 0;
              reviewController.clear();
              update();
            } else {
              global.showToast(
                message: 'Delete review failed!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception deleteReview:-" + e.toString());
    }
  }

  updateReview(int reviewId, int astrologerId) async {
    try {
      var basicDetails = {
        "rating": rating,
        "review": reviewController.text == "" ? "" : reviewController.text,
        "astrologerId": astrologerId,
        "isPublic": !isPublic,
      };
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .updateAstrologerReview(reviewId, basicDetails)
              .then((result) async {
            if (result.status == "200") {
              global.showToast(
                message: 'Your review has been updated',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              await getuserReview(astrologerId);
              Get.back();
            } else {
              global.showToast(
                message: 'Failed to update review',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in addReview : - ${e.toString()}');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>>? getMessageRTM(String channelID) {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> data =
          userChatCollectionRefRTM
              .doc(channelID)
              .collection('messages')
              .orderBy('createdAt')
              .snapshots();
      return data;
    } catch (err) {
      print("Exception - chatcontroller.dart - firebase" + err.toString());
      return null;
    }
  }

  Future uploadMessageRTM(String idUser, MessageModel anonymous) async {
    log('messga sending ${anonymous.toJson()}');
    try {
      final refMessages = userChatCollectionRefRTM //SEND BY CURRENT USER
          .doc(idUser)
          .collection('messages');
      var messageResult =
          await refMessages.add(anonymous.toJson()).catchError((e) {
        log('send mess exception' + e);
      });

      return {
        'user1': messageResult.id,
      };
    } catch (err) {
      log('uploadMessage err $err');
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getUserOnlineStatus({
    required String userID,
    String? firebasid,
  }) {
    //  log('getUserOnlineStatus id is $chatId and userID $userID');

    print("firebase:- ${firebasid}");
    print("id:- ${userID}");
    if (firebasid == "null" || firebasid == "") {
      throw Exception('No valid Firebase Chat ID provided');
    }

    return FirebaseFirestore.instance
        .collection('chats/$firebasid/userschat')
        .doc(userID)
        .collection('status')
        .doc('chatStatus')
        .snapshots();
  }
}
