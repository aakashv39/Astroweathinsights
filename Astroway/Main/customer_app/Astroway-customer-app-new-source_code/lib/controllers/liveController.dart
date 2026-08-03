import 'dart:async';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/main.dart';
import 'package:AstrowayCustomer/model/messsage_model_live.dart';
import 'package:AstrowayCustomer/model/live_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

import '../model/wait_list_model.dart';
import '../utils/services/api_helper.dart';
import '../views/live_astrologer/live_astrologer_screen.dart';

class LiveController extends GetxController {
  bool isStartEndingCall = false;
  bool isImInLive = false;
  Timer? timer2;
  bool isImInWaitList = false;
  SplashController splashController = Get.put(SplashController());
  String? astrologerFcmToken;
  int historyIndex = 0;
  final userChatCollectionRef = FirebaseFirestore.instance.collection("chats2");
  APIHelper apiHelper = APIHelper();
  int totalCompletedTime = 0;
  bool isLeaveCalled = false;
  String? chatId;
  int totalCompletedTimeForChat = 0;
  bool isImSplitted = false;
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 180;
  bool isJoinAsChat = false;
  int? callId;
  String joinUserName = global.user.name ?? "User";
  String joinUserProfile = global.user.profile ?? "";
  HMSSDK? hmsSDK;
  int liveCallTalked = 0;

  Future uploadMessage(
      String idUser, int astrologerId, MessageModelLive anonymous) async {
    try {
      final int globalId = global.user.id!;
      log('live chat ID');
      final refMessages = userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(globalId.toString())
          .collection('messages');
      final refMessages1 = userChatCollectionRef
          .doc(idUser)
          .collection('userschat')
          .doc(astrologerId.toString())
          .collection('messages');
      final newMessage1 = anonymous;
      final newMessage2 = anonymous;
      var messageResult =
          await refMessages.add(newMessage1.toJson()).catchError((e) {
        debugPrint('send mess exception $e');
        return e;
      });
      newMessage2.isRead = false;
      var message1Result =
          await refMessages1.add(newMessage2.toJson()).catchError((e) {
        debugPrint('send mess exception $e');
        return e;
      });
      return {
        'user1': messageResult.id,
        'user2': message1Result.id,
      };
    } catch (err) {
      debugPrint('uploadMessage err $err');
    }
  }

  var liveUsers = <LiveUserModel>[];

  Future<dynamic> getWaitList(String? channel) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getWaitList(channel).then((result) {
            global.hideLoader();
            if (result.status == "200") {
              waitList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Fail to getWaitList',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in getAstrologerList :-" + e.toString());
    }
  }

  Future<void> createLiveAstrologerShareLink(
      String astrologerName,
      int astrologerId,
      String token,
      String channelName,
      double charge,
      double videoCallCharge) async {
    try {
      await global.commonShareMethod(
          title:
              "Watch $astrologerName live on ${global.getSystemFlagValue(global.systemFlagNameList.appName)}\n\n https://phpstack-1555706-6027586.cloudwaysapps.com/live?astrologerId=${astrologerId}");
    } catch (e) {
      debugPrint("Exception - global.dart - referAndEarn():" + e.toString());
    }
  }

  Future<dynamic> updateWaitListStatus(int id, String status) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper
              .updateStatusForWaitList(id: id, status: status)
              .then((result) {
            global.hideLoader();
            if (result.status == "200") {
            } else {
              global.showToast(
                message: 'Fail to updateStatusForWaitList',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in getAstrologerList :-" + e.toString());
    }
  }

  Future<dynamic> cutPaymentForLive(int userId, int timeInSecond,
      int astrologerId, String transactionType, String chatId,
      {String? sId1, String? sId2, String? channelName}) async {
    try {
      isStartEndingCall = true;
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .cutPaymentForLiveStream(
                  userId, astrologerId, timeInSecond, transactionType, chatId,
                  sId1: sId1, sId2: sId2, channelName: channelName)
              .then((result) {
            if (result.status == "200") {
              debugPrint("cutPaymentForLive +  ${result.recordList}");
              if (result.recordList.length != 0) {
                callId = result.recordList['callId'];
                debugPrint('after call');
                double deductedMoney =
                    double.parse(result.recordList['deduction'].toString());
                update();
                debugPrint('deducted call Id $callId');
                debugPrint('deducted money $deductedMoney');
                double myTotoalWallteAmout = global.user.walletAmount!;
                myTotoalWallteAmout = myTotoalWallteAmout - deductedMoney;
                global.user.walletAmount = myTotoalWallteAmout;
              } else {
                callId = null;
              }
            } else {
              debugPrint('cut payment not done');

              global.showToast(
                message: 'Fail to cut payment',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in cutPaymentForLive :-" + e.toString());
    }
  }

  Future<dynamic> deleteFromWaitList(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteFromWishList(id).then((result) {
            if (result.status == "200") {
              waitList.removeWhere((element) => element.id == id);
              update();
            } else {
              global.showToast(
                message: 'Fail to deleteFromWishList',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in getAstrologerList :-" + e.toString());
    }
  }

  String secText = "-1";
  String minText = "-1";
  Timer? liveTimmer;

  accpetDeclineContfirmationDialogForLiveStreaming(
      {String? astroName,
      int? astroId,
      String? token,
      String? channel,
      String? requestType,
      int? id,
      double? charge,
      double? videoCallCharge,
      String? astrologerFcmToken2,
      String? astrologerProfile,
      bool? isFollow,
      required String callMethod}) {
    BuildContext context = Get.context!;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            content: Container(
              height: 170,
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Get.theme.primaryColor,
                    child: Center(
                        child: Icon(
                      requestType == "audio" ? Icons.phone : Icons.video_call,
                      color: Colors.black,
                      size: 35,
                    )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "$astroName ${tr("is available for call")}",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Decline",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ).tr(),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            print("id ontab:- ${id}");
                            print("requestType:- ${requestType}");
                            print("callMethod:- ${callMethod}");

                            ///hms code
                            if (callMethod.toString() == "hms") {
                              if (requestType == "audio" ||
                                  requestType == "Audio") {
                                Navigator.pop(context);
                                await updateWaitListStatus(id!, "Running");
                                print("afteupdtaeWailitst");
                                print("id:- ${id}");
                                for (int i = 0; i < waitList.length; i++) {
                                  print("index ${i} ${waitList[i].id}");
                                }

                                int index5 = waitList
                                    .indexWhere((element) => element.id == id);
                                print('index5:- ${index5}');
                                if (index5 != -1) {
                                  print("time:- ${waitList[index5].time}");
                                  endTime = DateTime.now()
                                          .millisecondsSinceEpoch +
                                      1000 * int.parse(waitList[index5].time);
                                  update();
                                  print("endTime:- ${endTime}");
                                }
                                _sendJoinRequest('audio');
                              } else {
                                Navigator.pop(context);
                                await updateWaitListStatus(id!, "Running");
                                int index5 = waitList
                                    .indexWhere((element) => element.id == id);
                                if (index5 != -1) {
                                  endTime = DateTime.now()
                                          .millisecondsSinceEpoch +
                                      1000 * int.parse(waitList[index5].time);
                                  update();
                                }
                                _sendJoinRequest('video');
                              }
                            }
                            //agora
                            else {
                              ///agora code
                              astrologerFcmToken = astrologerFcmToken2;
                              update();
                              if (requestType != "Chat") {
                                Get.back();
                                Get.back();
                                await updateWaitListStatus(id!, "Running");
                                int index5 = waitList
                                    .indexWhere((element) => element.id == id);
                                if (index5 != -1) {
                                  endTime = DateTime.now()
                                          .millisecondsSinceEpoch +
                                      1000 * int.parse(waitList[index5].time);
                                  update();
                                }
                                await global.callOnFcmApiSendPushNotifications(
                                  fcmTokem: ["$astrologerFcmToken"],
                                  title: "For timer and session start for live",
                                  subTitle:
                                      "For timer and session start for live",
                                  waitListId: "${id}",
                                  channelname: channel.toString(),
                                  profile: global.user.profile.toString(),
                                  name: global.user.name ?? "user",
                                );
                                if (liveController.liveUsers.isEmpty) {
                                  await liveController
                                      .getLiveuserData(channel!);
                                }
                                List<String> otherJoinUsersFcmTokens = [];
                                debugPrint("liveController.liveUsers " +
                                    liveController.liveUsers.toString());
                                if (liveController.liveUsers.isNotEmpty) {
                                  for (var i = 0;
                                      i < liveController.liveUsers.length;
                                      i++) {
                                    if (liveController.liveUsers[i].fcmToken !=
                                        null) {
                                      otherJoinUsersFcmTokens.add(liveController
                                          .liveUsers[i].fcmToken!);
                                    }
                                  }
                                }
                                debugPrint("otherJoinUsersFcmTokens" +
                                    otherJoinUsersFcmTokens.toString());
                                await global.callOnFcmApiSendPushNotifications(
                                  fcmTokem: otherJoinUsersFcmTokens,
                                  title:
                                      "For starting the timer in other audions for video and audio",
                                  subTitle:
                                      "For starting the timer in other audions for video and audio",
                                  waitListId: "${id}",
                                  channelname: channel.toString(),
                                  profile: global.user.profile.toString(),
                                  name: global.user.name ?? "user",
                                );
                                //here we will call the methods for sending all other users notification for timer start.
                                isLeaveCalled = false;
                                update();
                                Get.to(
                                  () => LiveAstrologerScreen(
                                    isFollow: isFollow!,
                                    token: token!,
                                    channel: channel!,
                                    astrologerName: astroName!,
                                    astrologerId: astroId!,
                                    isFromHome: false,
                                    charge: charge!,
                                    isForLiveCallAcceptDecline: true,
                                    requesType: requestType,
                                    astrologerProfile: astrologerProfile ?? "",
                                    videoCallCharge: videoCallCharge ?? 0,
                                  ),
                                );
                              } else {
                                Get.back();
                                await updateWaitListStatus(id!, "Running");
                                int index5 = waitList
                                    .indexWhere((element) => element.id == id);
                                if (index5 != -1) {
                                  endTime = DateTime.now()
                                          .millisecondsSinceEpoch +
                                      1000 * int.parse(waitList[index5].time);
                                }
                                isJoinAsChat = true;
                                chatId = "${global.user.id}" + "_" + "$astroId";
                                update();
                                global.callOnFcmApiSendPushNotifications(
                                  fcmTokem: ["$astrologerFcmToken"],
                                  title: "For Live Streaming Chat",
                                  subTitle: "For Live Streaming Chat",
                                  waitListId: "${id}",
                                  liveChatSUserName: global.user.name,
                                  sessionType: "start",
                                  chatId: chatId,
                                );
                                timer2 = Timer.periodic(Duration(seconds: 1),
                                    (timer) {
                                  debugPrint("totalCompletedTimeForChat:" +
                                      totalCompletedTimeForChat.toString());
                                  totalCompletedTimeForChat =
                                      totalCompletedTimeForChat + 1;
                                  update();
                                });
                              }
                            }
                          },
                          child: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(50)),
                            child: Center(
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ).tr(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceBetween,
            actionsPadding:
                const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          );
        });
  }

  void _sendJoinRequest(String type) async {
    log('_sendJoinRequest $type join request');

    try {
      HMSPeer? localPeer = await hmsSDK?.getLocalPeer();
      if (localPeer == null) {
        global.showToast(
            message: "Not connected yet",
            bgColor: Colors.red,
            textColor: Colors.white);
        return;
      }
      // 3. If backend approves, change role using HMS SDK
      List<HMSRole> roles = await hmsSDK!.getRoles();

      HMSRole broadcasterRole;
      // hmsSDK?.changeMetadata(
      //     metadata: json.encode({'type': type, 'userid': currentUserId}));
      ///
      if (type == "audio") {
        log("audio moderator role set ");
        //audio-moderator
        broadcasterRole = roles.firstWhere(
          (r) => r.name == 'audio-moderator',
        );
      } else {
        broadcasterRole = roles.firstWhere(
          (r) => r.name == 'livestreaming',
        );
        int? currentPriority = localPeer.role.priority;
        int? targetPriority = broadcasterRole.priority;

        log('🔍 ROLE PRIORITY ANALYSIS:');
        log('   • Current: ${localPeer.role.name} (priority: $currentPriority)');
        log('   • Target: ${broadcasterRole.name} (priority: $targetPriority)');
      }

      // Change our own role
      await hmsSDK?.changeRoleOfPeer(
        forPeer: localPeer,
        toRole: broadcasterRole,
        force: true,
      );
      global.showToast(
          message: "Request sent to host",
          bgColor: Colors.green,
          textColor: Colors.white);
    } catch (e) {
      log('Error changing role: $e');
      global.showToast(
          message: "Error changing role",
          bgColor: Colors.red,
          textColor: Colors.white);
    }
  }

  Future<dynamic> addToWaitList(
      String channel, String requestType, int astrologerId, String time) async {
    try {
      print("insideaddtowaitlist");
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          debugPrint(global.user.name);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          await apiHelper
              .addToWaitlist(
                  channel: channel,
                  requestType: requestType,
                  time: "${int.parse(time.toString()) * 60}",
                  userId: global.currentUserId,
                  userName: "${global.user.name}",
                  userProfile: "${global.user.profile}",
                  userFcmToken: "$fcmToken",
                  astrologerId: astrologerId)
              .then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              await getWaitList(channel);
            } else {
              global.showToast(
                message: 'failed to add waitlist',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in getAstrologerList :-" + e.toString());
    }
  }

  List<WaitList> waitList = [];

  //live user data
  Future<dynamic> addJoinUsersData(String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          debugPrint(global.user.name);
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          LiveUserModel liveUserModel = LiveUserModel(
            fcmToken: fcmToken,
            channelName: channelName,
          );
          await apiHelper.saveLiveUsers(liveUserModel).then((result) async {
            if (result.status == "200") {
              debugPrint('live user added successfully');
            } else {
              global.showToast(
                message: 'failed to add live user',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in addJoinUsersData :-" + e.toString());
    }
  }

  Future<dynamic> getLiveuserData(String channel) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getLiveUsers(channel).then((result) {
            if (result.status == "200") {
              liveUsers = result.recordList;
              update();
              debugPrint('Live user length ${liveUsers.length}');
            } else {
              global.showToast(
                message: 'failed to get live users',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in getLiveuserData :-" + e.toString());
    }
  }

  Future<dynamic> removeLiveuserData() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteLiveUsers().then((result) {
            if (result.status == "200") {
              debugPrint('live user left successfullY');
            } else {
              global.showToast(
                message: 'failed to remove live users',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in removeLiveuserData :-" + e.toString());
    }
  }

  Future<void> onlineOfflineUser() async {
    for (int i = 0; i < waitList.length; i++) {
      for (int j = 0; j < liveUsers.length; j++) {
        if (waitList[i].userId == liveUsers[j].userId) {
          waitList[i].isOnline = true;
          update();
        }
      }
    }
  }

  Future<dynamic> getRtmToken(String appId, String appCertificate,
      String chatId, String channelName) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .generateRtmToken(appId, appCertificate, chatId, channelName)
              .then((result) {
            if (result.status == "200") {
              global.agoraChatToken = result.recordList['rtmToken'];
              update();
              print('new token is ${global.agoraChatToken}');
            } else {
              global.showToast(
                message: 'failed to get live RTM Token',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in getRtmToken :-" + e.toString());
    }
  }

  Future<dynamic> deleteLiveAstrologer(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.endLiveSession(astrologerId).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              global.showToast(
                message: 'Live session end',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              debugPrint('Live session end length');
              final bottomNavigationController =
                  Get.find<BottomNavigationController>();
              global.showOnlyLoaderDialog(Get.context);
              await bottomNavigationController.getLiveAstrologerList();
              global.hideLoader();
            } else {
              global.showToast(
                message: 'End live session fail',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      debugPrint("Exception in deleteLiveAstrologer :-" + e.toString());
    }
  }
}
