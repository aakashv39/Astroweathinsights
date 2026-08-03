import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../views/call/onetooneAudio/CallSessions.dart';
import '../views/call/oneToOneVideo/videocallSession.dart';

class CallController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  bool? isLiveRunnning = true;
  int currentIndex = 0;
  int totalSeconds = 0;
  bool showBottomAcceptCall = false;
  int? bottomAstrologerId;
  String bottomAstrologerName = "Astrologer";
  String? bottomAstrologerProfile;
  String? bottomToken;
  int? bottomCallId;
  String? bottomChannel;
  String? bottomFcmToken;
  bool callBottom = false;
  APIHelper apiHelper = APIHelper();
  bool isLeaveCall = false;
  String callType = "";
  int duration = 0;
  String call_method = "";
  bool requestSuccess = false;
  var resourceId;
  final activeSessions = <String, Callsessions>{}.obs;
  ValueNotifier<int?> endTime = ValueNotifier(null);
  ValueNotifier<int?> videoEndTime = ValueNotifier(null);
  double? balance;
  double? price;
  double? audiobalance;
  double? audioprice;
  void addSession(Callsessions session) {
    activeSessions[session.sessionId] = session;
    print("${activeSessions}");
    update();
  }

  void removeSession(String sessionId) {
    global.callStartedAt = null;
    activeSessions.remove(sessionId);
    update();
  }

  final videoCallactiveSessions = <String, Videocallsession>{}.obs;
  void addVideoCallSession(Videocallsession session) {
    videoCallactiveSessions[session.sessionId] = session;
    print("${activeSessions}");
    update();
  }

  void removeVideoCallSession(String sessionId) {
    global.VideocallStartedAt = null;
    videoCallactiveSessions.remove(sessionId);
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    tabController = TabController(
      length: 6,
      vsync: this,
      initialIndex: currentIndex,
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  setTabIndex(int index) {
    tabController!.index = index;
    currentIndex = index;
    print('ontapp tab index:- $currentIndex');
    update();
  }

  String msgisfreechat = '';
  sendCallRequest(
    int astrologerId,
    bool isFreeSession,
    String type,
    String mins,
    String scheduleType,
    String scheduleTime,
    String scheduleDate,
  ) async {
    try {
      await apiHelper
          .sendAstrologerCallRequest(astrologerId, isFreeSession, type, mins,
              scheduleType, scheduleTime, scheduleDate)
          .then((response) {
        dynamic rspnse1 = json.decode(response.body)['status'];
        print("call request response:- ${rspnse1}");
        if (rspnse1 == 200) {
          requestSuccess = true;
          if (json.decode(response.body)['message'] ==
              "Scheduled Call Appointment Created Successfully") {
            global.showToast(
              message: json.decode(response.body)['message'],
              textColor: whiteColor,
              bgColor: blackColor,
            );
          } else {
            global.showToast(
              message: 'Sending call request..',
              textColor: whiteColor,
              bgColor: blackColor,
            );
          }
        } else if (rspnse1 == 400) {
          requestSuccess = false;
          if (json.decode(response.body).containsKey('recordList') &&
              json.decode(response.body)['recordList'] != null) {
            final _recordList = json.decode(response.body)['recordList'];
            if (_recordList.containsKey("minAmount")) {
              dynamic amount = _recordList["minAmount"];
              String msg = _recordList["message"];
              global.freeRequestMinimum = true;
              global.amountisfreecall = amount;
              msgisfreechat = msg;
              update();
            } else {
              global.freeRequestMinimum = false;
              update();
              String msg = _recordList['message'];
              global.showToast(
                message: '$msg',
                textColor: Colors.white,
                bgColor: Colors.red,
              );
              // Get.back();
            }
          } else {
            String msg = json.decode(response.body)['message'];
            global.showToast(
              message: '$msg',
              textColor: whiteColor,
              bgColor: Colors.red,
            );
            Get.back();
            Get.back();
          }

          update();
        }
      });
    } catch (e) {
      requestSuccess = false;
      print('Exception in sendCallRequest : - ${e.toString()}');
    }
  }

  acceptedCall(int callId) async {
    try {
      await apiHelper.acceptCall(callId).then((result) {
        if (result.status == "200") {
        } else {
          global.showToast(
            message: 'Call Accepet fail',
            textColor: whiteColor,
            bgColor: blackColor,
          );
        }
      });
    } catch (e) {
      print("Exception acceptedCall:-" + e.toString());
    }
  }

  rejectedCall(int callId) async {
    try {
      await apiHelper.rejectCall(callId).then((result) {
        if (result.status == "200") {
          global.showToast(
            message: 'Call Rejected',
            textColor: whiteColor,
            bgColor: blackColor,
          );
        } else {
          global.showToast(
            message: 'Call Reject fail',
            textColor: whiteColor,
            bgColor: blackColor,
          );
        }
      });
    } catch (e) {
      print("Exception rejectedCall:-" + e.toString());
    }
  }

  Future endCall(int callId, int seconds, String? sId, String? sId1) async {
    try {
      await apiHelper.endCall(callId, seconds, sId, sId1).then((result) {
        print("${result.status}");
        if (result.status == "200") {
          global.showToast(
            message: 'Call Ended',
            textColor: whiteColor,
            bgColor: blackColor,
          );
          return 1;
        } else {
          global.showToast(
            message: 'Call Ended fail',
            textColor: whiteColor,
            bgColor: blackColor,
          );
          return 0;
        }
      });
    } catch (e) {
      print("Exception endCall:-" + e.toString());
    }
  }

  getAgoraResourceId(String cname, int uid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getResourceId(cname, uid).then((result) {
            log('resourceId response 1:- $result');
            global.agoraResourceId = result["resourceId"];
            if (global.agoraResourceId.isEmpty) {
              throw Exception("Resource ID is missing. Call the acquire API");
            }
            log('global agoraResourceId 0 ${global.agoraResourceId}');
          });
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId 1:-" + e.toString());
    }
  }

  bool showLoading = true; // Initial state for loading indicator

  void startLoadingTimer() {
    Timer(const Duration(seconds: 4), () {
      showLoading = false;
      update();
    });
  }

  ///video
  agoraStartVideoRecording(String cname, String token, String? uid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.agoraStartCloudVideoRecording(cname, token, uid).then(
            (result) {
              log('start video recording response:- ${result.recordList}');
              global.agoraSid1 = result.recordList["sid"];
              log('global agoraSId ${global.agoraSid1}');
            },
          );
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId:-" + e.toString());
    }
  }

  agoraStartRecording(String cname, int uid, String token) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.agoraStartCloudRecording(cname, uid, token).then((
            result,
          ) {
            log('start recording response:- ${result.recordList}');
            global.agoraSid1 = result.recordList["sid"];
            log('global agoraSId ${global.agoraSid1}');
          });
        }
      });
    } catch (e) {
      print("Exception getAgoraResourceId:-" + e.toString());
    }
  }

  agoraStopRecording(int callId, String cname, int uid) async {
    try {
      await apiHelper.agoraStopCloudRecording(cname, uid).then((result) async {
        log('stop recording response:- ${result.recordList}');
      });
    } catch (e) {
      print("Exception agoraStopRecording:-" + e.toString());
    }
  }

  stopRecordingStoreData(int callId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .stopRecoedingStoreData(callId, channelName, global.agoraSid1)
              .then((result) {
            if (result.status == "200") {
              log('store sid successfully');
              // global.showToast(
              //   message: 'store sid successfully',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            } else {
              log('store sid failed');
              // global.showToast(
              //   message: 'Failed store sid',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print("Exception stopRecordingStoreData:-" + e.toString());
    }
  }

  Future<bool> updateMin({dynamic callid, dynamic callduration}) async {
    log('chatId is $callid chatDuration $callduration ');
    try {
      bool isSuccessful = false;

      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.updateCallMin(callid, callduration).then((
            result,
          ) async {
            global.hideLoader();
            if (result['status'].toString() == "200") {
              global.showToast(
                message: 'Your current session has been extended',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isSuccessful = true;
              update();
            } else if (result['status'].toString() == "400") {
              log('Status is 400: Insufficient balance');
              Get.back();
              global.showToast(
                message: result['message'],
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isSuccessful = false;
              update();
            } else {
              log('third condition');
              global.showToast(
                message: result['message'],
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isSuccessful = false;
              update();
            }
          });
        }
      });

      return isSuccessful; // Return the status
    } catch (e) {
      print('Exception in updateMin: ${e.toString()}');
      return false; // Return false on exception
    }
  }
}
