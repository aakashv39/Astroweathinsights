import 'dart:developer';

import 'package:AstrowayCustomer/model/aichatHistoryModel.dart';
import 'package:AstrowayCustomer/model/astromallHistoryModel.dart';
import 'package:AstrowayCustomer/model/callHistoryModel.dart';
import 'package:AstrowayCustomer/model/chatHistoryModel.dart';
import 'package:AstrowayCustomer/model/paymentsLogsModel.dart';
import 'package:AstrowayCustomer/model/reportHistoryModel.dart';
import 'package:AstrowayCustomer/model/walletTransactionHistoryModel.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../model/poojabookingmodel.dart';
import '../model/scheduleCallHistoryModel.dart';

class HistoryController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabControllerHistory;
  bool showHistory = true;
  bool simmerLoader=false;
  var apiHelper = APIHelper();
  int currentIndexHistory = 0;
  var callHistoryList = <CallHistoryModel>[];
  var scheduleCallHisotry = <ApoinmentCallHistory>[];
  var pujaHistoryList = <PujaHistory>[];

  var callHistoryListById = <CallHistoryModel>[];
  var chatHistoryList = <ChatHistoryModel>[];
  var reportHistoryList = <ReportHistoryModel>[];
  var AichatHistoryList = <AiChatHistoryModel>[];
  var paymentLogsList = <PaymentsLogsModel>[];
  var astroMallHistoryList = <AstroMallHistoryModel>[];

  var walletTransactionList = <WalletTransactionHistoryModel>[];
  bool isPlay = false;
  var audioPlayer;
  var audioPlayer2;
  var duration = Duration.zero;
  var position = Duration.zero;
  int? indRepot;
  var historyScrollController = ScrollController();
  int startIndex = 0;
  int fetchRecord = 20;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  bool isloading = false;

  var poojaScrollController = ScrollController();
  int pujaStart = 0;
  int pujaFetch = 20;
  bool poojastartisDataLoaded = false;
  bool poojastartisAllDataLoaded = false;
  bool poojastartisMoreDataAvailable = false;

  var walletScrollController = ScrollController();
  int walletStart = 0;
  int walletFetch = 20;
  bool walletDataLoaded = false;
  bool walletAllDataLoaded = false;
  bool walletMoreDataAvailable = false;

  var paymentScrollController = ScrollController();
  int paymentStart = 0;
  int paymentFetch = 20;
  bool paymentDataLoaded = false;
  bool paymentAllDataLoaded = false;
  bool paymentMoreDataAvailable = false;

  var callScrollController = ScrollController();
  int callStart = 0;
  int callFetch = 20;
  bool callDataLoaded = false;
  bool callAllDataLoaded = false;
  bool callMoreDataAvailable = false;

  var chatScrollController = ScrollController();
  int chatStart = 0;
  int chatFetch = 20;
  bool chatDataLoaded = false;
  bool chatAllDataLoaded = false;
  bool chatMoreDataAvailable = false;

  var reportScrollController = ScrollController();
  int reportStart = 0;
  int reportFetch = 20;
  bool reportDataLoaded = false;
  bool reportAllDataLoaded = false;
  bool reportMoreDataAvailable = false;

  var aiScrollController = ScrollController();
  int aiStart = 0;
  int aiFetch = 20;
  bool aiChatAllDataLoaded = false;
  bool aiChatMoreDataAvailable = false;

  static var index;

  @override
  void onInit() {
    tabControllerHistory = TabController(
        length: 2, vsync: this, initialIndex: currentIndexHistory);
    inIt();
    super.onInit();
  }

  void paginateTask() {
    historyScrollController.addListener(() async {
      if (historyScrollController.position.pixels ==
              historyScrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        update();
        await getAstroMall(global.currentUserId!, true);
      }
      update();
    });
    poojaScrollController.addListener(() async {
      if (historyScrollController.position.pixels ==
              historyScrollController.position.maxScrollExtent &&
          !poojastartisAllDataLoaded) {
        poojastartisMoreDataAvailable = true;
        update();
        await getPujaBooking(global.currentUserId!, true);
      }
      update();
    });

    walletScrollController.addListener(() async {
      if (walletScrollController.position.pixels ==
              walletScrollController.position.maxScrollExtent &&
          !walletAllDataLoaded) {
        walletMoreDataAvailable = true;
        update();
        await getWalletTransaction(global.currentUserId!, true);
      }
      update();
    });
  }

  inIt() {
    audioPlayer = AudioPlayer();
    audioPlayer2 = AudioPlayer();
    paginateTask();
    audioPlayer.onDurationChanged.listen((event) {
      duration = event;
      update();
    });
    audioPlayer.onPositionChanged.listen((event) {
      position = event;
      update();
    });
  }

  disposeAudioPlayer() {
    audioPlayer.dispose();
  }

  disposeAudioPlayer2() {
    audioPlayer2.dispose();
  }

  getPujaBooking(int userId, bool callLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      pujaStart = 0;
      callLazyLoading == false ? isloading = true : isloading = false;
      if (callHistoryList.isNotEmpty) {
        pujaStart = callHistoryList.length;
      }
      if (!callLazyLoading) {
        callDataLoaded = false;
      }
          await apiHelper.getHistory(userId, 0, callFetch).then((result) {
            if (result.status == "200") {
              print("puuja history");
              print("${result.recordList[0]['pujaOrder']}");
              List<dynamic> callHistory =
                  result.recordList[0]['pujaOrder']['pujaHistory'];
              pujaHistoryList.clear();
              pujaHistoryList.addAll(List<PujaHistory>.from(
                  callHistory.map((p) => PujaHistory.fromJson(p))));
              if (result.recordList[0]['pujaOrder']['pujaHistory'].length ==
                  0) {
                poojastartisMoreDataAvailable = false;
                poojastartisAllDataLoaded = true;
              }
              Future.delayed(Duration(milliseconds: 100), () {
                isloading = false;
                update();
              });
              update();
            } else {
              global.showToast(
                message: 'Fail to get Call History ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {
      simmerLoader=false;
      update();
      isloading = false;
      print('Exception in getpujahistory():' + e.toString());
    }
  }

  getCallHistory(int userId, bool callLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      callStart = 0;
      callLazyLoading == false ? isloading = true : isloading = false;
      if (callHistoryList.isNotEmpty) {
        callStart = callHistoryList.length;
      }
      if (!callLazyLoading) {
        callDataLoaded = false;
      }
          await apiHelper
              .getHistory(userId, callStart, callFetch)
              .then((result) {
            if (result.status == "200") {
              List<dynamic> callHistory =
                  result.recordList[0]['callRequest']['callHistory'];

              callHistoryList.addAll(List<CallHistoryModel>.from(
                  callHistory.map((p) => CallHistoryModel.fromJson(p))));

              ///scheduledata
              scheduleCallHisotry.addAll(List<ApoinmentCallHistory>.from(
                  result.recordList[0]['appointments'].map((p) => ApoinmentCallHistory.fromJson(p))));
              print("schedule appoinment:- ${ scheduleCallHisotry.length}");

              if (result.recordList[0]['callRequest']['callHistory'].length ==
                  0) {
                callMoreDataAvailable = false;
                callAllDataLoaded = true;
              }
              Future.delayed(Duration(milliseconds: 100), () {
                isloading = false;
                update();
              });
              update();
            } else {
              global.showToast(
                message: 'Fail to get Call History ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {
      isloading = false;
      simmerLoader=false;
      update();
      print('Exception in getCallHistory():' + e.toString());
    }
  }

  getChatHistory(int userId, bool chatLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      chatStart = 0;
      chatLazyLoading == false ? isloading = true : isloading = false;
      if (chatHistoryList.isNotEmpty) {
        chatStart = chatHistoryList.length;
      }
      if (!chatLazyLoading) {
        chatDataLoaded = false;
      }
          await apiHelper
              .getHistory(userId, chatStart, chatFetch)
              .then((result) {
            if (result.status == "200") {
              List<dynamic> chatHistory =
                  result.recordList[0]['chatRequest']['chatHistory'];
              chatHistoryList.addAll(List<ChatHistoryModel>.from(
                  chatHistory.map((p) => ChatHistoryModel.fromJson(p))));
              global.totallistCount =
                  result.recordList[0]['chatRequest']['totalCount'];
              if (result.recordList[0]['chatRequest']['chatHistory'].length ==
                      0 ||
                  global.totallistCount == chatHistory.length) {
                chatMoreDataAvailable = false;
                chatAllDataLoaded = true;
              }
              Future.delayed(Duration(milliseconds: 100), () {
                isloading = false;
                update();
              });
              update();
            } else {
              global.showToast(
                message: 'Fail to get Call History ',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {

      simmerLoader=false;
      update();
      isloading = false;
      print('Exception in getChatHistory():' + e.toString());
    }
  }

  getReportHistory(int userId, bool reportLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      reportStart = 0;
      if (reportHistoryList.isNotEmpty) {
        reportStart = reportHistoryList.length;
      }
      if (!reportLazyLoading) {
        reportDataLoaded = false;
      }
          await apiHelper
              .getHistory(userId, reportStart, reportFetch)
              .then((result) {
            log('get status is ${result.status}');
            if (result.status == "200") {
              List<dynamic> reportHistory =
                  result.recordList[0]['reportRequest']['reportHistory'];
              reportHistoryList.addAll(List<ReportHistoryModel>.from(
                  reportHistory.map((p) => ReportHistoryModel.fromJson(p))));
              log('report rate is 0 ${reportHistoryList[0].reportRate}');
              log('report rate is 1 ${reportHistoryList[1].reportRate}');
              log('report rate is 2 ${reportHistoryList[2].reportRate}');

              if (result
                      .recordList[0]['reportRequest']['reportHistory'].length ==
                  0) {
                reportMoreDataAvailable = false;
                reportAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get Report History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {
      simmerLoader=false;
      update();
      print('Exception in getReportHistory():' + e.toString());
    }
  }

// ==================== GET AI CHAT HISTORY DATA =======================
  getAiChatHistory(int userId, bool aichatLazyLoading) async {
    try {
      log('AI Chat Method Called Succesfully');
      aiStart = 0;
      if (AichatHistoryList.isNotEmpty) {
        aiStart = AichatHistoryList.length;
      }
      if (!aichatLazyLoading) {
        aiChatAllDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getHistory(userId, aiStart, reportFetch)
              .then((result) {
            if (result.status == "200") {
              log('Get Messages Success');
              List<dynamic> aichatHistory =
                  result.recordList[0]['AichatRequest']['chatHistory'];
              AichatHistoryList.addAll(List<AiChatHistoryModel>.from(
                  aichatHistory.map((p) => AiChatHistoryModel.fromJson(p))));
              if (result.recordList[0]['AichatRequest']['chatHistory'].length ==
                  0) {
                aiChatMoreDataAvailable = false;
                aiChatAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get AI chat History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getReportHistory():' + e.toString());
    }
  }

  getPaymentLogs(int userId, bool paymentLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      paymentStart = 0;
      if (paymentLogsList.isNotEmpty) {
        paymentStart = paymentLogsList.length;
      }
      if (!paymentLazyLoading) {
        paymentDataLoaded = false;
      }
          await apiHelper
              .getHistory(userId, paymentStart, paymentFetch)
              .then((result) {
            if (result.status == "200") {
              List<dynamic> paymentLogsHistory =
                  result.recordList[0]['paymentLogs']['payment'];

              paymentLogsList.addAll(List<PaymentsLogsModel>.from(
                  paymentLogsHistory
                      .map((p) => PaymentsLogsModel.fromJson(p))));

              if (result.recordList[0]['paymentLogs']['payment'].length == 0) {
                paymentMoreDataAvailable = false;
                paymentAllDataLoaded = true;
              }

              update();
            } else {
              global.showToast(
                message: 'Fail to get Payment Logs History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {
      simmerLoader=false;
      update();
      print('Exception in getPaymentLogs():' + e.toString());
    }
  }

  Future getAstroMall(int? userId, bool isLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      startIndex = 0;
      if (astroMallHistoryList.isNotEmpty) {
        startIndex = astroMallHistoryList.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
          await apiHelper
              .getHistory(userId!, startIndex, fetchRecord)
              .then((result) {
            if (result.status == "200") {
              List<dynamic> astroMallHistory =
                  result.recordList[0]['orders']['order'];
              astroMallHistoryList.addAll(List<AstroMallHistoryModel>.from(
                  astroMallHistory
                      .map((p) => AstroMallHistoryModel.fromJson(p))));
              if (result.recordList[0]['orders']['order'].length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {
              global.showToast(
                message: 'Fail to get AstroMall History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {
      simmerLoader=false;
      update();
      print('Exception in getPaymentLogs():' + e.toString());
    }
  }

  Future applyforRefund(dynamic id) async {
    log('puja id is ${id}');
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getPujaRefundApi(id).then((result) async {
            global.hideLoader();
            if (result.status == "200") {
              await Get.find<HistoryController>()
                  .getPujaBooking(global.currentUserId!, false);
              global.showToast(
                  message: '${result.recordList['message']}',
                  textColor: Colors.white,
                  bgColor: Colors.black);

              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in applyforRefund():' + e.toString());
    }
  }

  Future getWalletTransaction(int userId, bool walletLazyLoading) async {
    try {
      simmerLoader=true;
      update();
      walletStart = 0;
      if (walletTransactionList.isNotEmpty) {
        walletStart = walletTransactionList.length;
        update();
      }
      if (!walletLazyLoading) {
        walletDataLoaded = false;
        update();
      }
          await apiHelper
              .getHistory(userId, walletStart, walletFetch)
              .then((result) {
            if (result.status == "200") {
              List<dynamic> walletTransaction =
                  result.recordList[0]['walletTransaction']['wallet'];
              walletTransactionList.addAll(
                  List<WalletTransactionHistoryModel>.from(walletTransaction
                      .map((p) => WalletTransactionHistoryModel.fromJson(p))));
              print(
                  'wallet taransaction length - ${walletTransactionList.length}');
              if (result.recordList[0]['walletTransaction']['wallet'].length ==
                  0) {
                walletMoreDataAvailable = false;
                walletAllDataLoaded = true;
              }

              update();
            } else {

              global.showToast(
                message: 'Fail Payment Logs History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });

      simmerLoader=false;
      update();
    } catch (e) {
      simmerLoader=false;
      update();
      print('Exception in getReportHistory():' + e.toString());
    }
  }

  getCallHistoryById(int callId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getCallHistoryById(callId).then((result) {
            if (result.status == "200") {
              callHistoryListById = List<CallHistoryModel>.from(
                  result.recordList.map((p) => CallHistoryModel.fromJson(p)));
              update();
            } else {
              global.showToast(
                message: 'Fail to get Call History',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getCallHistoryById():' + e.toString());
    }
  }

  cancleOrder(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.cancelAstromallOrder(id).then((result) async {
            if (result.status == "200") {
              double total =
                  double.parse(result.recordList[0].totalPayable.toString());
              global.splashController.currentUser?.walletAmount =
                  (global.splashController.currentUser?.walletAmount ?? 0) +
                      total;
              astroMallHistoryList.clear();
              isAllDataLoaded = false;
              update();
              await getAstroMall(global.currentUserId!, true);
            } else {
              global.showToast(
                message: 'Failed to cancel order please try gain later!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in cancleOrder():' + e.toString());
    }
  }

  deleteAppoinment(String id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.deleteAppoinment(id).then((result) async {
            print("delete appinment:- ${result.status}");
            print("${result.recordList['message']}");
            if (result.status == "200") {
              Fluttertoast.showToast(msg: "${result.recordList['message']}");
              scheduleCallHisotry.clear();
              update();
            } else if(result.status == "403"){
              Fluttertoast.showToast(msg: "${result.recordList['message']}");
            }else {
              global.showToast(
                message: 'Failed to Delete Appointment',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in cancleOrder():' + e.toString());
    }
  }
}
