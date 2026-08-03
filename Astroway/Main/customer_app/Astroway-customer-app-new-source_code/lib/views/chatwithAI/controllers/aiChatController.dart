import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../../../utils/services/api_helper.dart';
import '../models/ai_chatid_Model.dart';
import '../models/aichatingchargemodel.dart';
import '../models/messageModel.dart';
import '../models/messageResponseModel.dart';

class AiChatController extends GetxController {
  bool isLoading = false;
  bool islowBalance = false;

  AiChatingChargeModel? aichatcharge;
  MessageResponseModel? messageresponse;
  AiChatidModel? aiAstrologerId;

  List<Message> messageList = [];
  bool isTyping = false;
  final messageController = TextEditingController();

  Timer? secTimer;
  int totalSeconds = 0;
  APIHelper apiHelper = APIHelper();
  int chatId = 0;
  bool endChat = false;
  String totalmin = '';

  @override
  void onInit() async {
    _init();
    super.onInit();
  }

  _init() async {
    //startTimer();
  }

  startTimer() {
    print('Time Started');
    totalSeconds = 0;
    secTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      print("total Second Count:- $totalSeconds");
      totalSeconds += 1;
      update();
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  endAIChatTime(int totalSeconds, int? id) async {
    try {
      await apiHelper.saveAIChatTime(totalSeconds, id).then((result) {
        if (result.status == "200") {
        } else {}
      });
    } catch (e) {
      print('Exception in endAIChatTime : - ${e.toString()}');
    }
  }

  getAIChatAstrologerId() async {
    try {
      await apiHelper.aiChatID().then((aichatidModel) {
        log('status body ${aichatidModel}');
        log('status code ${aichatidModel.status}');
        if (aichatidModel.status == 200) {
          aiAstrologerId = aichatidModel;
          isLoading = false;
          update();
          log("My Ai Astrologer is ${aiAstrologerId!.recordList!.id}");
        } else {
          global.showToast(
            message: 'Failed to Get AI chat Response',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
          isTyping = false;
          update();
        }
      });
    } catch (e) {
      print('Exception in getAIChatAstrologerId : - ${e.toString()}');
    }
  }

  Future<void> addMessages(String message) async {
    if (message.isEmpty) {
      Fluttertoast.showToast(msg: tr("Please Enter a Message"));
    }
    log('This is Typed Message $message');
    messageList.add(Message(text: message, isFromUser: true));
    await sendMessages(message);

    messageList
        .add(Message(text: '${messageresponse!.message}', isFromUser: false));
    isTyping = false;
  }

  getcharge() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isLoading = true;
          update();
          await apiHelper.getAiChatingCharge().then((result) {
            print('result response ${result.status}');
            if (result.status == "200") {
              islowBalance = false;
              aichatcharge = result.recordList;
              islowBalance = false;
              log('AI Charge Recieved ${aichatcharge}');
              isLoading = false;
              update();
            } else if (result.status == "400") {
              islowBalance = true;
              aichatcharge = result.recordList;
              log('Low Balance ${aichatcharge}');
              isLoading = false;
              update();
            } else {
              global.showToast(
                message: 'Failed to Load AI Chat Charge',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isLoading = false;
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getcharge():' + e.toString());
    }
  }

  // Display Querrry Message.....

  sendMessages(String message) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isTyping = true;
          update();
          log('sendMessages $message');
          await apiHelper.sendMessageToAi(message).then((result) {
            if (result.status == "200") {
              messageresponse = result.recordList;
              log('Chat Response ${messageresponse!.message}');
              isTyping = false;
              update();
            } else {
              global.showToast(
                message: 'Failed',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isTyping = false;
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in sendMessages():' + e.toString());
    }
  }

  leavechat(int secondsElapsed) {
    print(secondsElapsed);
  }
}
