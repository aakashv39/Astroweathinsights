// ignore_for_file: null_check_always_fails

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:AstrowayCustomer/model/Allstories.dart';
import 'package:AstrowayCustomer/model/amount_model.dart';
import 'package:AstrowayCustomer/model/app_review_model.dart';
import 'package:AstrowayCustomer/model/astavargaDetailModel.dart';
import 'package:AstrowayCustomer/model/astrologerCategoryModel.dart';
import 'package:AstrowayCustomer/model/astrologer_availability_model.dart';
import 'package:AstrowayCustomer/model/astrologer_model.dart';
import 'package:AstrowayCustomer/model/astromall_category_model.dart';
import 'package:AstrowayCustomer/model/astromall_product_model.dart';
import 'package:AstrowayCustomer/model/blocked_astrologe_model.dart';
import 'package:AstrowayCustomer/model/counsellor_model.dart';
import 'package:AstrowayCustomer/model/current_user_model.dart';
import 'package:AstrowayCustomer/model/customer_support_model.dart';
import 'package:AstrowayCustomer/model/dailyHoroscope_model.dart';
import 'package:AstrowayCustomer/model/gift_model.dart';
import 'package:AstrowayCustomer/model/help_and_support_model.dart';
import 'package:AstrowayCustomer/model/help_support_question.dart';
import 'package:AstrowayCustomer/model/help_support_subcat_model.dart';
import 'package:AstrowayCustomer/model/home_Model.dart';
import 'package:AstrowayCustomer/model/hororscopeSignModel.dart';
import 'package:AstrowayCustomer/model/kundli_model.dart';
import 'package:AstrowayCustomer/model/kundlichartModel.dart';
import 'package:AstrowayCustomer/model/language.dart';
import 'package:AstrowayCustomer/model/languageModel.dart';
import 'package:AstrowayCustomer/model/live_asrtrologer_model.dart';
import 'package:AstrowayCustomer/model/live_user_model.dart';
import 'package:AstrowayCustomer/model/notifications_model.dart';
import 'package:AstrowayCustomer/model/remote_host_model.dart';
import 'package:AstrowayCustomer/model/reportModel%20copy.dart';
import 'package:AstrowayCustomer/model/reportTypeModel.dart';
import 'package:AstrowayCustomer/model/reviewModel.dart';
import 'package:AstrowayCustomer/model/skillModel.dart';
import 'package:AstrowayCustomer/model/systemFlagModel.dart';
import 'package:AstrowayCustomer/model/upcommingModel.dart';
import 'package:AstrowayCustomer/model/user_address_model.dart';
import 'package:AstrowayCustomer/model/viewStories.dart';
import 'package:AstrowayCustomer/model/wait_list_model.dart';
import 'package:AstrowayCustomer/utils/services/api_result.dart';
import 'package:AstrowayCustomer/views/chatwithAI/models/aichatingchargemodel.dart';
import 'package:AstrowayCustomer/views/chatwithAI/models/messageResponseModel.dart';
import 'package:AstrowayCustomer/views/poojaBooking/model/poojalistmodel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../controllers/reviewController.dart';
import '../../model/PujaCategoriesListModel.dart';
import '../../model/RecommendedPujaListModel.dart';
import '../../model/allhistorymodel.dart';
import '../../model/assistant_model.dart';
import '../../model/astromallHistoryModel.dart';
import '../../model/basicDetailmodel.dart';
import '../../model/blockkeywordModel.dart';
import '../../model/chartDetailmodel.dart';
import '../../model/customer_support_review_model.dart';
import '../../model/custompujamodel.dart';
import '../../model/dashdetailmodel.dart';
import '../../model/doshaDetailModel.dart';
import '../../model/intake_model.dart';
import '../../model/login_model.dart';
import '../../model/planetreportmodel.dart';
import '../../model/rec_model.dart';
import '../../model/referalmodel.dart';
import '../../views/chatwithAI/models/ai_chatid_Model.dart';
import '../../views/poojaBooking/model/faqmodel.dart';
import '../config.dart';

class APIHelper {
  //getPujaCategory

  Future<dynamic> refreshUserFCM(Map<String, dynamic> fcmData) async {
    try {
      log("user bodydata Info $fcmData");
      final response = await http.post(
        Uri.parse('$baseUrl/deviceDetails'),
        body: json.encode(fcmData),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      log("refreshUserInfo statusCode : ${response.statusCode}");
      log("refreshUserInfo response : ${response.body}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {}
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in refreshUserInfo():-" + e.toString());
    }
  }

  Future<dynamic> getPujaCategory() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getPujaCategory"),
        headers: await global.getApiHeaders(true),
      );
      log('getPujaCategory response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<PujaCategoriesListModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => PujaCategoriesListModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

// In api_helper.dart

  Future<dynamic> startRandomChat({
    required int callDuration, // e.g. 60 for 1 min
  }) async {
    try {
      final url = Uri.parse("$baseUrl/random-chat");

      final body = jsonEncode({
        "call_duration": callDuration,
      });

      final response = await http.post(
        url,
        headers: await global.getApiHeaders(true),
        body: body,
      );

      log("🎯 startRandomChat data: ${body}");

      log("🎯 startRandomChat response: ${response.body}");

      dynamic recordList;
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        recordList = decoded["recordList"] ?? decoded;
      } else {
        recordList = null;
      }

      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("❌ Exception - startRandomChat: $e");
    }
  }

  // login & signup

  Future<dynamic> loginSignUp(LoginModel loginModel) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/loginAppUser'),
        body: json.encode(loginModel),
        headers: await global.getApiHeaders(false),
      );
      dynamic recordList;
      log("loginAppUser response : ${response.body}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else if (response.statusCode == 400) {
        Map<String, dynamic> data = json.decode(response.body);

        data['error']['contactNo'].toString() == "null"
            ? global.showToast(
                message: data['error']['email'].toString(),
                textColor: Colors.white,
                bgColor: Colors.black,
              )
            : global.showToast(
                message: data['error']['contactNo'].toString(),
                textColor: Colors.white,
                bgColor: Colors.black,
              );
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in loginSignUp():-" + e.toString());
    }
  }

  Future<dynamic> checkContact(String phoneno, String countryCode) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkContactNoExistForUser'),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "contactNo": phoneno,
          'fromApp': 'user',
          'type': 'login',
          'countryCode': countryCode
        }),
      );
      dynamic recordList;
      log('checkContact respons ${response.body}');
      recordList = response;
      return recordList;
    } catch (e) {
      debugPrint('Exception:- in checkContact ' + e.toString());
    }
  }

  Future<dynamic> getBasicDetailApi(int? id) async {
    final modelbody = json.encode({
      "id": id,
      "language": Get.locale?.languageCode ?? 'en',
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/basic"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli res is here ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = basicDetailModelFromJson(response.body);
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      debugPrint('Exception in getkundliChart original():' + e.toString());
    }
  }

  Future<AstavargaDetailModel?>? getAstaVargaApi(int? id) async {
    final modelbody = json.encode({
      "id": id,
      "language": Get.locale?.languageCode ?? 'en',
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/astakvarga"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli astakvarga res is here ${response.body}');

      AstavargaDetailModel astavargaChartmodel;
      if (response.statusCode == 200) {
        astavargaChartmodel = astavargaDetailModelFromJson(response.body);
      } else {
        astavargaChartmodel = AstavargaDetailModel();
      }
      return astavargaChartmodel;
    } catch (e) {
      debugPrint('Exception in astakvarga ' + e.toString());
    }
    return null;
  }

  Future<dynamic> getPlanetReportApi(int? id, String planetname) async {
    final modelbody = json.encode({
      "id": id,
      "language": Get.locale?.languageCode ?? 'en',
      "planet": planetname
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/planet-report"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('planet-report chart res is here ${response.body}');

      PlanetReportModel? planetreport;

      if (response.statusCode == 200) {
        planetreport = planetReportModelFromJson(response.body);
      } else {
        planetreport = null;
      }
      return planetreport;
    } catch (e) {
      debugPrint('Exception in planet-report' + e.toString());
    }
  }

  Future<dynamic> getReportApi(int? id) async {
    final modelbody = json.encode({
      "id": id,
      "language": Get.locale?.languageCode ?? 'en',
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/ascendant-report"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('ascendant-report chart res is here ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = reportDetailModelFromJson(response.body);
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      debugPrint('Exception in ascendant-getreport' + e.toString());
    }
  }

  Future<dynamic> getDoshaApi(int? id) async {
    final modelbody = json.encode({
      "id": id,
      "language": Get.locale?.languageCode ?? 'en',
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/dosha"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('getDoshaApi res is here ${response.body}');
      dynamic doshadetailmodel;
      if (response.statusCode == 200) {
        doshadetailmodel = doshaDetailsModelFromJson(response.body);
      } else {
        doshadetailmodel = null;
      }
      return doshadetailmodel;
    } catch (e) {
      debugPrint('Exception in getDoshaApi' + e.toString());
    }
  }

  Future<dynamic> getDashaApi(int? id) async {
    String? langugecode = Get.locale?.languageCode;
    if (langugecode == "mr") {
      langugecode = 'en';
    }
    if (langugecode == "kn") {
      langugecode = 'en';
    }
    if (langugecode == "bn") {
      langugecode = 'en';
    }
    if (langugecode == "es") {
      langugecode = 'en';
    }

    final modelbody = json.encode({
      "id": id,
      "language": langugecode,
    });

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/dasha"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('dasha res is here ${response.body}');
      dynamic dashdetailmodel;
      if (response.statusCode == 200) {
        dashdetailmodel = dashDetailsModelFromJson(response.body);
      } else {
        dashdetailmodel = null;
      }
      return dashdetailmodel;
    } catch (e) {
      debugPrint('Exception in dasha-api ' + e.toString());
    }
  }

  Future<dynamic> getChartDetailsApi(
      int? id, String? div, String? style) async {
    log('basic detail id is here $id');
    final modelbody = json.encode({
      "id": id,
      "div": div,
      "style": style,
      "language": Get.locale?.languageCode ?? 'en',
    });
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/chart"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli chart res is here ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = chartDetailModelFromJson(response.body);
        log('My kundli chart$kundlichartmodel');
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      debugPrint('Exception in getkundliChart original():' + e.toString());
    }
  }

  Future<dynamic> getKundliChart(KundliModel kundlimode) async {
    var id = kundlimode.id;
    var name = kundlimode.name;
    var gender = kundlimode.gender;
    var birthDate = kundlimode.birthDate; // This is a DateTime object
    var birthTime = kundlimode.birthTime;
    var birthPlace = kundlimode.birthPlace;
    var latitude = kundlimode.latitude;
    var longitude = kundlimode.longitude;
    var timezone = kundlimode.timezone;
    var lang = kundlimode.lang ?? "en";
    final modelbody = json.encode({
      "kundali": [
        {
          "id": id,
          "lang": lang,
          "name": name,
          "gender": gender,
          "birthDate": birthDate.toIso8601String(),
          "birthTime": birthTime,
          "birthPlace": birthPlace,
          "latitude": latitude.toString(),
          "longitude": longitude.toString(),
          "timezone": timezone.toString(),
        }
      ]
    });
    try {
      final response = await http.post(
        Uri.parse("${baseUrl}/kundali/addnew"),
        headers: await global.getApiHeaders(true),
        body: modelbody,
      );
      log('kundli res is here ${response.body}');
      dynamic kundlichartmodel;
      if (response.statusCode == 200) {
        kundlichartmodel = kundliChartModelFromJson(response.body);
      } else {
        kundlichartmodel = null;
      }
      return kundlichartmodel;
    } catch (e) {
      debugPrint('Exception in getkundliChart original():' + e.toString());
    }
  }

  // validatesession api
  Future<dynamic> validateSession() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/validateSession"),
        headers: await global.getApiHeaders(true),
      );
      log("validateSession ${response.body}");
      log("validateSession statuscode ${response.statusCode}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            CurrentUserModel.fromJson(json.decode(response.body)["recordList"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception - validateSession(): " + e.toString());
    }
  }

  Future<dynamic> getHororscopeSign() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getHororscopeSign"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HororscopeSignModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => HororscopeSignModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getHororscopeSign():' + e.toString());
    }
  }

  // ================== AI CHATING CHARGE PER MIN ===========================
  Future<dynamic> getAiChatingCharge() async {
    try {
      final response = await http.get(
          Uri.parse("$baseUrl/check-user-balance-api"),
          headers: await global.getApiHeaders(true));
      log('Check meassage Charge body ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = aiChatingChargeModelFromJson(response.body);
      } else if (response.statusCode == 400) {
        recordList = aiChatingChargeModelFromJson(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getHororscopeSign():' + e.toString());
    }
  }

  // ==================== ASK QUESTIONS TO AI BOT =========================
  Future<dynamic> sendMessageToAi(String message) async {
    print('msfsadefs $message');
    try {
      final response = await http.post(Uri.parse("$baseUrl/ask-master"),
          headers: await global.getApiHeaders(true),
          body: jsonEncode({"message": message}));

      log('meassage response body ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = messageResponseModelFromJson(response.body);
        log('My RecordList ${recordList}');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in sendMessageToAi():' + e.toString());
    }
  }

  // ==================== MASTER AI ASTROLOGER ID =========================
  Future<dynamic> aiChatID() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/master-chat-page-api'),
        headers: await global.getApiHeaders(true),
      );
      dynamic aichatidModel;
      log('Master AI Response body ${response.body}');
      if (response.statusCode == 200) {
        aichatidModel = aiChatidModelFromJson(response.body);
      } else {
        aichatidModel = null;
      }
      return aichatidModel;
    } catch (e) {
      debugPrint('Exception:- in aiChatID ' + e.toString());
    }
  }

  // ==================== SEND YOUR CHAT TIME IN SECONDS =======================
  Future<dynamic> saveAIChatTime(int second, int? id) async {
    try {
      log("Ai Astrologer ID $id");
      log('total AI chat sec ${second}');
      final response = await http.post(
        Uri.parse('$baseUrl/store-master-ai-chat-history-api'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologer_id": id, "chat_duration": second}),
      );
      log('AI Chat History Response ${response.body}');
    } catch (e) {
      debugPrint('Exception:- in saveAIChatTime ' + e.toString());
    }
  }

  //Get API
  Future<dynamic> getCurrentUser() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getProfile"),
        headers: await global.getApiHeaders(true),
      );
      log('get profile body buadkfa ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList =
            CurrentUserModel.fromJson(json.decode(response.body)["data"]);
        print("userProfileDtaa");
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getCurrentUser:' + e.toString());
    }
  }

  Future<dynamic> getpuja(String catId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getPujaList"),
        body: json.encode({"category_id": catId}),
        headers: await global.getApiHeaders(true),
      );
      log('pooja body is ${json.encode({"category_id": catId})}');

      log('pooja response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<PoojaList>.from(json
            .decode(response.body)["recordList"]
            .map((x) => PoojaList.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getPuja():' + e.toString());
    }
  }

  // getPujaRefund
  Future<dynamic> getPujaRefundApi(dynamic pujaId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getPujaRefund"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": pujaId}),
      );
      log('getPujaRefundApi response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getPujaRefundApi():' + e.toString());
    }
  }

  //deletePoojaApi

  Future<dynamic> deletePoojaApi(dynamic pujaId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/deleteSuggestedPuja"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": pujaId}),
      );
      log('deletePoojaApi response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getCustompujaApi() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/suggestedAstrologerPuja"),
        headers: await global.getApiHeaders(true),
      );
      log('getCustompujaApi response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CustomPujaModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => CustomPujaModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getfaq() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getPujafaq"),
        headers: await global.getApiHeaders(true),
      );
      log('getPujafaq response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<FaqList>.from(json
            .decode(response.body)["recordList"]
            .map((x) => FaqList.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getPujafaq():' + e.toString());
    }
  }

  Future<dynamic> getKundli() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getkundali"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => KundliModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getPdfKundli(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/kundali/get/$id"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getPdfPrice() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/pdf/price"),
        headers: await global.getApiHeaders(true),
      );
      print("getPdfPrice ${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getHomeBanner() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Banners>.from(json
            .decode(response.body)["banner"]
            .map((x) => Banners.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getHomeBanner():' + e.toString());
    }
  }

  Future<dynamic> getHomeOrder() async {
    try {
      print("$baseUrl/getCustomerHome");
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<TopOrder>.from(json
            .decode(response.body)["topOrders"]
            .map((x) => TopOrder.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getHomeOrder():' + e.toString());
    }
  }

  Future<dynamic> getHomeBlog() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Blog>.from(
            json.decode(response.body)["blog"].map((x) => Blog.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getHomeBlog():' + e.toString());
    }
  }

  Future<dynamic> getAppReview() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/appReview/get"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"appId": 1}),
      );
      dynamic recordList;
      log("getAppReview ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AppReviewModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AppReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAppReview():' + e.toString());
    }
  }

  Future<dynamic> getAllStory() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrologerStory"),
        headers: await global.getApiHeaders(true),
      );
      print("getAstrologerStory ${response.statusCode}");
      print("getAstrologerStory response ${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AllStories>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AllStories.fromJson(x)));
      } else if (response.statusCode == 401) {
        recordList = List<AllStories>.empty();
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAllStory():' + e.toString());
    }
  }

  //getallhistorydetail
  Future<dynamic> getallhistorydetail() async {
    try {
      print('$baseUrl/getUserById');
      print("${json.encode({
            "userId": global.currentUserId,
            "startIndex": 0,
            "fetchRecord": 100,
          })}");
      final response = await http.post(
        Uri.parse('$baseUrl/getUserById'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "userId": global.currentUserId,
          "startIndex": 0,
          "fetchRecord": 100,
        }),
      );

      print("getallhistorydetail ${response.statusCode}");
      print("getallhistorydetail response ${response.body}");
      dynamic recordlist;
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        recordlist = List<Allhistorydetailmodel>.from(jsonData["recordList"]
            .map((x) => Allhistorydetailmodel.fromJson(x)));
      } else {
        recordlist = null;
      }
      return getAPIResult(response, recordlist);
    } catch (e) {
      debugPrint('Exception in getallhistorydetail(): ${e.toString()}');
    }
  }

  Future<dynamic> getAstroStory(String astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getStory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId}),
      );
      print("getAstroStory ${jsonDecode(response.body)}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ViewStories>.from(json
            .decode(response.body)["recordList"]
            .map((x) => ViewStories.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getStory():' + e.toString());
    }
  }

  Future<dynamic> storyViewed(String storyId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/clickStory"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"storyId": storyId}),
      );
      print("viewStory");
      print("${json.encode({"storyId": storyId})}");
      print("${response.statusCode}");
      dynamic recordList;
      if (response.statusCode == 200) {
        // recordList = List<ViewStories>.from(json
        //     .decode(response.body)["recordList"]
        //     .map((x) => ViewStories.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in storyViewed():' + e.toString());
    }
  }

  Future<dynamic> getAstroNews() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      log("My astrologey image form news statuscode ${response.statusCode}");
      log("My astrologey news body ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AstrotalkInNews>.from(json
            .decode(response.body)["astrotalkInNews"]
            .map((x) => AstrotalkInNews.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstroNews():' + e.toString());
    }
  }

  Future<dynamic> getAstroVideos() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCustomerHome"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologyVideo>.from(json
            .decode(response.body)["astrologyVideo"]
            .map((x) => AstrologyVideo.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstroNews():' + e.toString());
    }
  }

  Future<dynamic> getAstrologer({
    int? catId,
    String? sortingKey,
    List<int>? skills,
    List<int>? language,
    List<String>? gender,
    int? startIndex,
    int? fetchRecords,
    bool? isshuffling = false,
  }) async {
    try {
      print("get astro body ${json.encode({
            "userId": global.user.id,
            "astrologerCategoryId": catId,
            "filterData": {
              "skills": skills,
              "languageKnown": language,
              "gender": gender
            },
            "sortBy": sortingKey,
            "startIndex": startIndex,
            "fetchRecord": 100,
            "inRandom": isshuffling
          })}");
      final response = await http.post(Uri.parse('$baseUrl/getAstrologer'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "userId": global.user.id,
            "fetchRecord": 100,
            "astrologerCategoryId": catId,
            "filterData": {
              "skills": skills,
              "languageKnown": language,
              "gender": gender
            },
            "sortBy": sortingKey,
            "startIndex": startIndex,
            "inRandom": isshuffling
          }));

      dynamic recordList;

      // log('getAstrologer response ${response.body}');
      // log('getAstrologer token ${global.sp!.getString("token") ?? global.myToken}');

      log('getAstrologer status ${response.statusCode}');
      log('getAstrologer res ${response.body}');

      global.totallistCount = json.decode(response.body)["totalCount"];

      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstrologer():' + e.toString());
    }
  }

  Future<dynamic> getAstrologerlistforCheckout(
      {int? catId,
      String? sortingKey,
      List<int>? skills,
      List<int>? language,
      List<String>? gender,
      int? startIndex,
      int? fetchRecords}) async {
    log('user id is ${json.encode({
          "userId": global.user.id,
          "astrologerCategoryId": catId,
          "filterData": {
            "skills": skills,
            "languageKnown": language,
            "gender": gender
          },
          "sortBy": sortingKey,
          "startIndex": '',
          "fetchRecord": '',
        })}');

    try {
      final response = await http.post(Uri.parse('$baseUrl/getAstrologer'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "userId": global.user.id,
            "astrologerCategoryId": catId,
            "filterData": {
              "skills": skills,
              "languageKnown": language,
              "gender": gender
            },
            "sortBy": sortingKey,
            "startIndex": '',
            "fetchRecord": '',
          }));

      dynamic recordList;

      log('getAstrologerlistforCheckout res->  ${response.body}');

      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstrologerlistforCheckout():' + e.toString());
    }
  }

  Future<dynamic> checkUserAlreadyInChatReq({int? astorlogerId}) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/checkChatSessionAvailable'),
              headers: await global.getApiHeaders(true),
              body: json.encode({
                "astrologerId": astorlogerId,
              }));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = false;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in checkUserAlreadyInChatReq():' + e.toString());
    }
  }

  Future<dynamic> checkUserAlreadyInCallReq({int? astorlogerId}) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/checkCallSessionAvailable'),
              headers: await global.getApiHeaders(true),
              body: json.encode({
                "astrologerId": astorlogerId,
              }));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = false;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in checkUserAlreadyInCallReq():' + e.toString());
    }
  }

  Future<dynamic> getTokenFromChannel({String? channelName}) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/liveAstrologer/getToken'),
          headers: await global.getApiHeaders(true),
          body: json.encode({"channelName": "$channelName"}));
      dynamic recordList;
      if (response.statusCode == 200) {
        debugPrint("Token : " + json.decode(response.body)["recordList"]);
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getTokenFromChannel():' + e.toString());
    }
  }

  Future<dynamic> getWaitList(String? channel) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/waitlist/get'), body: {
        "channelName": channel,
      });
      dynamic recordList;
      print("waitlist  response:- ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<WaitList>.from(json
            .decode(response.body)["recordList"]
            .map((x) => WaitList.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getWaitList():' + e.toString());
    }
  }

  //checkReferalcodestatus
  Future<dynamic> checkReferalcodestatus(String referalcode) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/checkReferral'), body: {
        "referral_token": referalcode,
      });
      print('referal body is -> ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = ReferalModel.fromJson(json.decode(response.body)["user"]);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getWaitList():' + e.toString());
    }
  }

  Future<dynamic> deleteFromWishList(int id) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/waitlist/delete'), body: {
        "id": id.toString(),
      });
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in deleteFromWishList():' + e.toString());
    }
  }

  Future<dynamic> addToWaitlist(
      {String? channel,
      String? userName,
      String? userProfile,
      int? userId,
      String? time,
      String? requestType,
      String? userFcmToken,
      int? astrologerId}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/waitlist/add'),
        body: {
          "userName": userName != "" ? "$userName" : "User",
          "profile": userProfile != "" ? "$userProfile" : "",
          "time": "$time",
          "channelName": "$channel",
          "requestType": "$requestType",
          "userId": "$userId",
          "userFcmToken": userFcmToken != "" ? "$userFcmToken" : "",
          "status": "Pending",
          "astrologerId": "$astrologerId",
        },
      );
      print("addToWaitlist res ${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in addToWaitlist():' + e.toString());
    }
  }

  Future<dynamic> updateStatusForWaitList({int? id, String? status}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/waitlist/updateStatus'),
        body: {
          "id": id.toString(),
          "status": "$status",
        },
      );

      print("updateStatus ${response.body}");

      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in updateStatusForWaitList():' + e.toString());
    }
  }

  Future<dynamic> getSkill() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getSkill'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<SkillModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => SkillModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getSkill():' + e.toString());
    }
  }

  Future<dynamic> getLanguage() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getLanguage'),
      );
      dynamic recordList;
      log('Lan response ${response.body}');
      if (response.statusCode == 200) {
        recordList = List<LanguageModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => LanguageModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getSkill():' + e.toString());
    }
  }

  Future<dynamic> getAstromallCategory(int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getproductCategory"),
        headers: await global.getApiHeaders(true),
        body:
            json.encode({"startIndex": startIndex, "fetchRecord": fetchRecord}),
      );
      dynamic recordList;
      log("Product categories data ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AstromallCategoryModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstromallCategoryModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstromallCategory():' + e.toString());
    }
  }

  Future<dynamic> getAstromallProduct(
      int id, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstromallProduct"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "productCategoryId": "$id",
          "startIndex": startIndex,
          "fetchRecord": fetchRecord
        }),
      );

      print("getting response${response.body}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstromallProductModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstromallProductModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstromallProduct:' + e.toString());
    }
  }

  Future<dynamic> getProductById(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstromallProductById"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": "$id"}),
      );
      dynamic recordList;
      log('param ${json.encode({"id": "$id"})}');
      log('getproductbyid response code ${response.body}');
      if (response.statusCode == 200) {
        recordList = List<AstromallProductModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstromallProductModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getProductById:' + e.toString());
    }
  }

  Future<dynamic> cancelAstromallOrder(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/userOrder/cancel"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstroMallHistoryModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstroMallHistoryModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in cancleAstromallOrder:' + e.toString());
    }
  }

  Future<dynamic> deleteAppoinment(String id) async {
    try {
      print('$baseUrl/appointment/delete');
      print('${json.encode({"id": "$id"})}');
      final response = await http.delete(
        Uri.parse("$baseUrl/appointment/delete"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": "$id"}),
      );
      print("deleteAppoinment ${jsonDecode(response.body)}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = jsonDecode(response.body);
      } else if (response.statusCode == 403) {
        recordList = jsonDecode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in cancleAstromallOrder:' + e.toString());
    }
  }

  Future<dynamic> getGift() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getGift"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<GiftModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => GiftModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getGift:' + e.toString());
    }
  }

  Future<dynamic> getUserAddress(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getOrderAddress"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"userId": "$id"}),
      );
      dynamic recordList;
      log('getUserAddress:- ${response.body}');
      if (response.statusCode == 200) {
        recordList = List<UserAddressModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => UserAddressModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getUserAddress:' + e.toString());
    }
  }

  Future<dynamic> getKundliById(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/Kundali/show/$id"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<KundliModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => KundliModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> getReview(int id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrologerUserReview"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReviewModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => ReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getReview():' + e.toString());
    }
  }

  Future<dynamic> getAstrologerCategory() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/activeAstrologerCategory"),
        headers: await global.getApiHeaders(true),
      );
      // log('activeAstrologerCategory:- ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerCategoryModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerCategoryModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getAstrologerCategory():' + e.toString());
    }
  }

  Future<dynamic> getRecommendedProductsApi() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getProductRecommend"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "userId": global.user.id,
        }),
      );
      dynamic recordList;
      log('getProductRecommend response ${response.body}');
      if (response.statusCode == 200) {
        recordList = List<RecModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => RecModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getRecommendedProductsApi():' + e.toString());
    }
  }

  //getRecommendedPujaApi

  Future<dynamic> getRecommendedPujaApi() async {
    try {
      log('userid is ${global.user.id}');
      final response = await http.post(
        Uri.parse("$baseUrl/getPujaRecommend"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "userId": global.user.id,
        }),
      );
      dynamic recordList;
      log('getPujaRecommend response ${response.body}');
      if (response.statusCode == 200) {
        recordList = List<RecommendedPujaListModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => RecommendedPujaListModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getRecommendedProductsApi():' + e.toString());
    }
  }

  Future<dynamic> getReportType(
      String? searchString, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getReportType"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "searchString": searchString,
          "startIndex": startIndex,
          "fetchRecord": fetchRecord
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReportTypeModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => ReportTypeModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getReportType():' + e.toString());
    }
  }

  Future<dynamic> getCounsellors(int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getCounsellor"),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "startIndex": startIndex,
          "fetchRecord": fetchRecord,
          "userId": global.user.id,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CounsellorModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => CounsellorModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getCounsellors():' + e.toString());
    }
  }

  Future<dynamic> getFollowedAstrologer(int startIndex, int record) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/getFollower"),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {
              "startIndex": startIndex,
              "fetchRecord": record,
            },
          ));
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getFollowedAstrologer():' + e.toString());
    }
  }

  Future<LiveAstrologerModel?> getLiveAstrologer() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/liveAstrologer/get"),
        headers: await global.getApiHeaders(true),
      );
      log('live astrologer list is ${response.body}');
      if (response.statusCode == 200) {
        return liveAstrologerModelFromJson(response.body);
      } else {
        return LiveAstrologerModel(
          message: "Failed to fetch data",
          status: response.statusCode,
          recordList: [],
          callMethod: null,
        );
      }
    } catch (e) {
      debugPrint('Exception in getLiveAstrologer(): $e');
      return LiveAstrologerModel(
        message: "Exception: $e",
        status: 500,
        recordList: [],
        callMethod: null,
      );
    }
  }

  Future<dynamic> changeCallStatus({int? astrologerId, String? status}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addCallStatus"),
        headers: await global.getApiHeaders(true),
        body: json.encode(
            {"astrologerId": astrologerId, "status": status, "waitTime": null}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:  - changeCallStatus(): ' + e.toString());
    }
  }

  Future<dynamic> changeStatus({int? astrologerId, String? status}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addStatus"),
        headers: await global.getApiHeaders(true),
        body: json.encode(
            {"astrologerId": astrologerId, "status": status, "waitTime": null}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:  - changeStatus(): ' + e.toString());
    }
  }

  Future<dynamic> setRemoteId(int astroId, int remoteId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/addAstrohost"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": "$astroId",
          "hostId": "$remoteId",
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception: - setRemoteId(): " + e.toString());
    }
  }

  Future<dynamic> getRemoteId(int astroId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrohost"),
        body: {
          "astrologerId": astroId.toString(),
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<RemoteHostModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => RemoteHostModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getLiveAstrologer():' + e.toString());
    }
  }

//add API
  Future<dynamic> addKundli(
      List<KundliModel> basicDetails, int amount, bool isMatch) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(
            {"kundali": basicDetails, "amount": amount, "is_match": isMatch}),
      );
      log('addKundli param ${json.encode({
            "kundali": basicDetails,
            "amount": amount,
            "is_match": isMatch
          })}');
      log("addKundli ${response.statusCode}");
      log("addKundli body ${response.body}");

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addKundliadd:- ' + e.toString());
    }
  }

  Future<dynamic> addPlanetKundli(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/addForTrackPlanet'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"id": id}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addPlanetKundli:- ' + e.toString());
    }
  }

  Future<dynamic> addAddress(UserAddressModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orderAddress/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addAddress ' + e.toString());
    }
  }

  Future<dynamic> addAppFeedback(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/appReview/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addAppFeedback:-' + e.toString());
    }
  }

  Future<dynamic> followAstrologer(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/follower/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'astrologerId': '$astrologerId'}),
      );
      log('follow response ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in followAstrologer ' + e.toString());
    }
  }

  Future<dynamic> viewerCount(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addBlogReader'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"blogId": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in viewerCount ' + e.toString());
    }
  }

//update API
  Future<dynamic> updateUserProfile(int id, var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/update/$id'),
        headers: await global.getApiHeaders(true),
        body: jsonEncode(basicDetails),
      );
      dynamic recordList;
      log("My Updated Profile Response ${response.body}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in updateUserProfile:-' + e.toString());
    }
  }

  Future<dynamic> updateKundli(int id, KundliModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in updateKundli:-' + e.toString());
    }
  }

  Future<dynamic> updateAddress(int id, UserAddressModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/orderAddress/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in updateAddress:-' + e.toString());
    }
  }

  Future<dynamic> unFollowAstrologer(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/follower/update'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$astrologerId"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in updateAddress:-' + e.toString());
    }
  }

//delete API
  Future<dynamic> deleteUser(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/delete'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteUser : -" + e.toString());
    }
  }

  Future<dynamic> deleteKundli(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/kundali/delete'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteKundli : -" + e.toString());
    }
  }

  Future<dynamic> sendAstrologerCallRequest(
    int astrologerId,
    bool isFreeSession,
    String type,
    String time,
    String scheduleType,
    String scheduleTime,
    String scheduleDate,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/callRequest/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          'astrologerId': '$astrologerId',
          "isFreeSession": isFreeSession,
          "call_type": type == "Videocall" ? 11 : 10,
          "call_duration": time,
          "IsSchedule": scheduleType == "schedule"
              ? 1
              : 0, //O FOR INSTANT & 1 MEAN SCHEDULE
          "schedule_date": scheduleDate,
          "schedule_time": scheduleTime
        }),
      );
      dynamic recordList;
      log('call respons ${response.body}');
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      recordList = response;
      return recordList;
    } catch (e) {
      debugPrint('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  dynamic getAPIResult<T>(final response, T recordList) {
    try {
      dynamic result;
      result = APIResult.fromJson(json.decode(response.body), recordList);
      return result;
    } catch (e) {
      debugPrint("Exception - getAPIResult():" + e.toString());
    }
  }

//=------------------------------chat----------------->

  Future<dynamic> sendAstrologerChatRequest(
    int astrologerId,
    bool isFreeSession,
    String time,
    String scheduleType,
    String scheduleTime,
    String scheduleDate,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "astrologerId": astrologerId,
          "isFreeSession": isFreeSession,
          "chat_duration": time,
          "schedule_type": scheduleType == "schedule"
              ? 1
              : 0, //O FOR INSTANT & 1 MEAN SCHEDULE
          "schedule_date": scheduleDate,
          "schedule_time": scheduleTime,
        }),
      );
      dynamic recordList;
      log('chat respons ${response.body}');
      recordList = response;
      return recordList;
    } catch (e) {
      debugPrint('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  // Future<dynamic> saveChattingTime(
  //     int second, int chatId, String fromwhere) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/chatRequest/endChat'),
  //       headers: await global.getApiHeaders(true),
  //       body: json.encode({'chatId': '$chatId', 'totalMin': '$second'}),
  //     );
  //     print('ending chat data ${json.encode({
  //           'chatId': '$chatId',
  //           'totalMin': '$second',
  //           'fromwhere': fromwhere
  //         })}');
  //     dynamic recordList;
  //     log('execute end chat response ${response.body}');
  //     if (response.statusCode == 200) {
  //       recordList = json.decode(response.body)['recordList'];
  //     } else {
  //       recordList = null;
  //     }
  //     return getAPIResult(response, recordList);
  //   } catch (e) {
  //     debugPrint('Exception:- in sendAstrologerCallRequest ' + e.toString());
  //   }
  // }

  Future<dynamic> saveChattingTime(
      int second, int chatId, String fromwhere) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/endChat'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'chatId': '$chatId', 'totalMin': '$second'}),
      );
      print('ending chat data ${json.encode({
            'chatId': '$chatId',
            'totalMin': '$second',
            'fromwhere': fromwhere
          })}');
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in sendAstrologerCallRequest ' + e.toString());
    }
  }

  Future<dynamic> orderAdd(
      {int? productCatId,
      int? productId,
      int? addressId,
      double? amount,
      int? gst,
      String? paymentMethod,
      double? totalPay}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userOrder/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          'productCategoryId': productCatId,
          'productId': productId,
          'orderAddressId': addressId,
          'payableAmount': amount,
          'gstPercent': gst,
          'paymentMethod': paymentMethod,
          'totalPayable': totalPay
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in orderAdd ' + e.toString());
    }
  }

  Future<dynamic> placedPujaOrderCustom({
    required int addressid,
    required int pujaid,
    required dynamic pujaprice,
    required dynamic astrologerid,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/placedPujaOrder'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "pujaId": pujaid,
          "payableAmount": pujaprice,
          'orderAddressId': addressid,
          'astrologer_id': astrologerid,
        }),
      );
      log('placedPujaOrderCustom response:- ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      debugPrint('Exception:- in placedPujaOrder ' + e.toString());
    }
  }

  Future<dynamic> placedPujaOrder({
    required int addressid,
    required int pujaid,
    required int packageid,
    required AstrologerModel? selectedAstrologer,
    String? recommendid,
  }) async {
    log('payment recommendid:- ${recommendid}');

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/placedPujaOrder'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "pujaId": pujaid,
          'packageId': packageid,
          'orderAddressId': addressid,
          'astrologer_id':
              selectedAstrologer?.id == null ? 0 : selectedAstrologer!.id,
          'puja_recommend_id': recommendid,
        }),
      );
      log('payment response:- ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      debugPrint('Exception:- in placedPujaOrder ' + e.toString());
    }
  }

  Future<dynamic> addAmountInWallet({
    required double amount,
    int? cashback,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addpayment'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "userId": global.user.id!,
          'amount': amount,
          'cashback_amount': cashback,
        }),
      );
      log('payment response:- ${response.body}');
      return json.decode(response.body);
    } catch (e) {
      debugPrint('Exception:- in addAmountInWallet ' + e.toString());
    }
  }

  Future<dynamic> getAvailability(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAstrologerAvailability"),
        headers: await global.getApiHeaders(false),
        body: json.encode({"astrologerId": "$astrologerId"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerAvailibilityModel>.from(
            json.decode(response.body)["recordList"].map(
                  (x) => AstrologerAvailibilityModel.fromJson(x),
                ));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getKundli():' + e.toString());
    }
  }

  Future<dynamic> acceptChat(int chatId) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/chatRequest/acceptChatRequest'),
          headers: await global.getApiHeaders(true),
          body: json.encode({"chatId": chatId}));
      print('accept chat response is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = BlockKeywordModel.fromJson(
            json.decode(response.body)['recordList']);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in acceptChat : -" + e.toString());
    }
  }

  Future<dynamic> logout() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/logout'),
          headers: await global.getApiHeaders(true));
      debugPrint('done : $response');
      debugPrint('logoutId : ${response.statusCode}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in acceptChat : -" + e.toString());
    }
  }

  Future<dynamic> rejectChat(String cid) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/chatRequest/rejectChatRequest'),
              headers: await global.getApiHeaders(true),
              body: json.encode(
                {"chatId": cid},
              ));
      debugPrint('reject chat : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> cutPaymentForLiveStream(int userId, int astrologerId,
      int timeInSecond, String transactionType, String chatId,
      {String? sId1, String? sId2, String? channelName}) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/chatRequest/endLiveChat'),
              headers: await global.getApiHeaders(true),
              body: json.encode(
                {
                  "userId": userId,
                  "astrologerId": astrologerId,
                  "totalMin": timeInSecond,
                  "transactionType": "$transactionType Live Streaming",
                  "chatId": chatId,
                  "sId": sId1,
                  "sId1": sId2,
                  "channelName": channelName,
                  "callType": "$transactionType"
                },
              ));

      log('endLiveChat response : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["recordList"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> acceptCall(int callId) async {
    try {
      final response = await http.post(
          Uri.parse('$baseUrl/callRequest/acceptCallRequest'),
          headers: await global.getApiHeaders(true),
          body: json.encode({"callId": callId}));
      log('accept response : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in acceptCall : -" + e.toString());
    }
  }

  Future<dynamic> rejectCall(int callId) async {
    try {
      final response =
          await http.post(Uri.parse('$baseUrl/callRequest/rejectCallRequest'),
              headers: await global.getApiHeaders(true),
              body: json.encode(
                {"callId": callId},
              ));
      debugPrint('response reject calll: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> endCall(
      int callId, int second, String? sId, String? sId1) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/callRequest/end'),
          headers: await global.getApiHeaders(true),
          body: json.encode(
            {
              "callId": callId,
              "totalMin": "$second",
              "sId": sId.toString(),
              "sId1": sId1.toString(),
            },
          ));
      dynamic recordList;
      debugPrint("response i am getting:- ${response.body}");
      if (response.statusCode == 200) {
        debugPrint("${response.body}");
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in endCall : -" + e.toString());
    }
  }

  Future<dynamic> getHistory(
      int userId, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/getUserById'),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "userId": userId,
            "startIndex": startIndex,
            "fetchRecord": fetchRecord
          }));

      dynamic recordList;
      log('getUserById response-- > ${response.body}');
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getHistory : -" + e.toString());
    }
  }

  Future<dynamic> getUpcomingList() async {
    try {
      print("$baseUrl/scheduleLive/list");
      final response = await http.get(
        Uri.parse("$baseUrl/scheduleLive/list"),
      );
      dynamic recordList;
      print("getUpcomingList ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<UpcommingListModel>.from(json
            .decode(response.body)["data"]
            .map((x) => UpcommingListModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getUpcomingList():' + e.toString());
    }
  }

  Future<dynamic> remindMeLiveAstrologer(String astrologerId) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/userReminder"),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "astrologerId": astrologerId,
          }));
      dynamic recordList;
      print("userReminder:- ${response.body}");
      print("${response.body}");
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "${jsonDecode(response.body)['message']}");
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in getUpcomingList():' + e.toString());
    }
  }

  //Third Party API
  Future<dynamic> getAdvancedPanchang(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/advanced_panchang"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": 77.2090,
          "tzone": tzone
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      debugPrint('Exception in getAdvancedPanchang():' + e.toString());
    }
  }

  Future<dynamic> getManglic(
      int? dayBoy,
      int? monthBoy,
      int? yearBoy,
      int? hourBoy,
      int? minBoy,
      int? dayGirl,
      int? monthGirl,
      int? yearGirl,
      int? hourGirl,
      int? minGirl) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_manglik_report"),
        body: json.encode({
          "m_day": dayBoy,
          "m_month": monthBoy,
          "m_year": yearBoy,
          "m_hour": hourBoy,
          "m_min": minBoy,
          "m_lat": 19.132,
          "m_lon": 72.342,
          "m_tzone": 5.5,
          "f_day": dayGirl,
          "f_month": monthGirl,
          "f_year": yearGirl,
          "f_hour": hourGirl,
          "f_min": minGirl,
          "f_lat": 19.132,
          "f_lon": 72.342,
          "f_tzone": 5.5
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      debugPrint('Exception in getManglic():' + e.toString());
    }
  }

  Future<String?> getPublicIPAddress() async {
    final urls = [
      'https://api64.ipify.org?format=json',
      'https://api.ipify.org?format=json',
      'https://ifconfig.me/all.json',
      'https://ip.seeip.org/jsonip',
    ];

    for (final url in urls) {
      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);

          final ip = body['ip'] ??
              body['ip_address'] ??
              body['request-ip'] ??
              body['client_ip'] ??
              null;

          if (ip != null) {
            log("Public IP: $ip (source: $url)");
            return ip;
          }
        }
      } catch (e) {
        log("IP fetch failed for $url : ${e.toString()}");
      }
    }

    log("❗ Could not fetch IP from any service");
    return null;
  }

  Future<dynamic> getPanchangVedic(dynamic ipadddress, String date) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/get/panchang"),
          headers: await global.getApiHeaders(true),
          body: json.encode({
            "panchangDate": date,
            "ip": ipadddress,
            "lang": Get.locale?.languageCode == 'kn'
                ? "en"
                : Get.locale?.languageCode ?? "en"
          }));
      log('ip response getpanchang body ${json.encode({
            "panchangDate": date,
            "ip": ipadddress,
            "lang": Get.locale?.languageCode == 'kn'
                ? "en"
                : Get.locale?.languageCode ?? "en"
          })}');

      log('ip response getpanchang is ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = jsonDecode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      debugPrint('Exception in getAdvancedPanchang():' + e.toString());
    }
  }

  Future<dynamic> getKundliBasicDetails(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/birth_details"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": "application/json"
        },
      );
      log("Api URL: https://json.astrologyapi.com/v1/birth_details");
      log("Api URL RESPONSE: ${response.body}");
      log("Api URL: STATUS CODE ${response.statusCode}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      debugPrint('Exception in getKundliBasicDetails():' + e.toString());
    }
  }

  Future<dynamic> getKundliBasicPanchangDetails(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/basic_panchang"),
        body: json.encode({
          "day": day,
          "month": month,
          "year": year,
          "hour": hour,
          "min": min,
          "lat": lat,
          "lon": lon,
          "tzone": tzone
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      debugPrint(
          'Exception in getKundliBasicPanchangDetails():' + e.toString());
    }
  }

  Future<dynamic> getMatching(
      int? dayBoy,
      int? monthBoy,
      int? yearBoy,
      int? hourBoy,
      int? minBoy,
      int? dayGirl,
      int? monthGirl,
      int? yearGirl,
      int? hourGirl,
      int? minGirl) async {
    try {
      final response = await http.post(
        Uri.parse("https://json.astrologyapi.com/v1/match_ashtakoot_points"),
        body: json.encode({
          "m_day": dayBoy,
          "m_month": monthBoy,
          "m_year": yearBoy,
          "m_hour": hourBoy,
          "m_min": minBoy,
          "m_lat": 19.132,
          "m_lon": 72.342,
          "m_tzone": 5.5,
          "f_day": dayGirl,
          "f_month": monthGirl,
          "f_year": yearGirl,
          "f_hour": hourGirl,
          "f_min": minGirl,
          "f_lat": 19.132,
          "f_lon": 72.342,
          "f_tzone": 5.5
        }),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValueForLogin(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }

      return recordList;
    } catch (e) {
      debugPrint('Exception in getMatching():' + e.toString());
    }
  }

  //Search
  Future<dynamic> searchAstrologer(String filterKey, String searchString,
      int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/searchAstro'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "filterKey": filterKey,
          "searchString": searchString,
          "startIndex": startIndex,
          "fetchRecord": fetchRecord,
          "userId": global.user.id,
        }),
      );

      log('searchAstrologer : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        if (filterKey == "astromall") {
          recordList = List<AstromallProductModel>.from(json
              .decode(response.body)["recordList"]
              .map((x) => AstromallProductModel.fromJson(x)));
        } else {
          recordList = List<AstrologerModel>.from(json
              .decode(response.body)["recordList"]
              .map((x) => AstrologerModel.fromJson(x)));
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> searchProductByCategory(
      int productCategoryId, String searchString) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/searchAstromallProductCategory'),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "productCategoryId": "$productCategoryId",
          "searchString": searchString
        }),
      );
      debugPrint('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstromallProductModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstromallProductModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in rejectChat : -" + e.toString());
    }
  }

  Future<dynamic> getBlog(
      String searchString, int startIndex, int fetchRecord) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAppBlog'),
        headers: await global.getApiHeaders(false),
        body: json.encode({
          "searchString": searchString,
          "startIndex": startIndex,
          "fetchRecord": fetchRecord
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Blog>.from(json
            .decode(response.body)["recordList"]
            .map((x) => Blog.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getBlog : -" + e.toString());
    }
  }

  Future<dynamic> getAstrologerById(int astrologerId, int? userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAstrologerForCustomer'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": astrologerId, "userId": userId}),
      );
      dynamic recordList;
      log("astrologer data for me ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getAstrologerById : -" + e.toString());
    }
  }

  //report
  Future<dynamic> addReportIntakeDetail(var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReport/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addReportIntakeDetail:- ' + e.toString());
    }
  }

  //astrologer  review
  Future<dynamic> addAstrologerReview(
      int astrologerId, double? rating, String? review, bool isPublic) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReview/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "rating": rating,
          "review": review,
          "astrologerId": astrologerId,
          "isPublic": isPublic,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addAstrologerReview:- ' + e.toString());
    }
  }

  Future<dynamic> getuserReview(int userId, int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAstrologerUserReview'),
        body:
            json.encode({"userId": "$userId", "astrologerId": "$astrologerId"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<ReviewModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => ReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getuserReview : -" + e.toString());
    }
  }

  Future<dynamic> updateAstrologerReview(int id, var basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReview/update/$id'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in updateAstrologerReview:- ' + e.toString());
    }
  }

  Future<dynamic> deleteReview(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userReview/delete/$id'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteKundli : -" + e.toString());
    }
  }

  Future<dynamic> getHoroscope({int? horoscopeSignId}) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getDailyHoroscope"),
        body: json.encode({
          "horoscopeSignId": horoscopeSignId,
          'langcode': Get.locale?.languageCode ?? 'en'
        }),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      debugPrint('Exception in getHoroscope():' + e.toString());
    }
  }

  //customer support chat
  Future<dynamic> getTickets(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getTicket'),
        body: json.encode({"userId": "$userId"}),
        headers: await global.getApiHeaders(true),
      );
      debugPrint('done : $response');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CustomerSuppportModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => CustomerSuppportModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getTickets : -" + e.toString());
    }
  }

  Future<dynamic> getTimezonOffline({double? lat, double? long}) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://api.geonames.org/timezoneJSON?lat=$lat&lng=$long&username=rocky'),
      );

      log("GeoNames Response: ${response.body}");

      return json.decode(response.body);
    } catch (e) {
      debugPrint("Exception in getTimezonOffline: $e");
    }
  }

  Future<dynamic> geoCoding({double? lat, double? long}) async {
    log('geoCoding lat $lat long $long');
    try {
      final response = await http.post(
        Uri.parse('https://json.astrologyapi.com/v1/timezone_with_dst'),
        body: json.encode({"latitude": lat, "longitude": long}),
        headers: {
          "authorization": "Basic " +
              base64.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiUserId)}:${global.getSystemFlagValue(global.systemFlagNameList.astrologyApiKey)}"
                      .codeUnits),
          "Content-Type": 'application/json'
        },
      );
      dynamic recordList;
      log("timeZone for the Api ${response.body}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in geoCoding : -" + e.toString());
    }
  }

  Future<dynamic> deleteTicket() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/deleteAll'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteTicket : -" + e.toString());
    }
  }

  Future<dynamic> deleteOneTicket(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/delete'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteOneTicket : -" + e.toString());
    }
  }

  Future<dynamic> getHelpAndSupport() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getHelpSupport'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HelpAndSupportModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => HelpAndSupportModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getTickets : -" + e.toString());
    }
  }

  Future<dynamic> getHelpAndSupportQuestion(int helpSupportId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getHelpSupportQuestion'),
        headers: await global.getApiHeaders(true),
        body: json.encode({'helpSupportId': '$helpSupportId'}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HelpSupportQuestionModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => HelpSupportQuestionModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getHelpAndSupportQuestion : -" + e.toString());
    }
  }

  Future<dynamic> getHelpAndSupportQuestionAnswer(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getHelpSupportSubSubCategory'),
        headers: await global.getApiHeaders(false),
        body: json.encode({'helpSupportQuationId': '$id'}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<HelpAndSupportSubcatModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => HelpAndSupportSubcatModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          "Exception in getHelpAndSupportQuestionAnswer : -" + e.toString());
    }
  }

  Future<dynamic> addCustomerSupportReview(
      String review, double rating, int ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/addReview'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "review": "$review",
          "rating": "$rating",
          "ticketId": "$ticketId"
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addCustomerSupportReview:- ' + e.toString());
    }
  }

  Future<dynamic> editCustomerSupportReview(
      String review, double rating, int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/updateReview'),
        headers: await global.getApiHeaders(true),
        body: json
            .encode({"review": "$review", "rating": "$rating", "id": "$id"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in editCustomerSupportReview:- ' + e.toString());
    }
  }

  Future<dynamic> getCustomerSupportReview(int ticketId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/getReview'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"ticketId": "$ticketId"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<CustomerSupportReviewModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => CustomerSupportReviewModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getCustomerSupportReview : -" + e.toString());
    }
  }

  Future<dynamic> getTicketStatus() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkOpenTicket'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in getTicketStatus:- ' + e.toString());
    }
  }

  //create ticket
  Future<dynamic> creaetTicket(CustomerSuppportModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/add'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in creaetTicket:- ' + e.toString());
    }
  }

  Future<dynamic> restratCustomerSupportChat(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/ticket/restart'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in restratCustomerSupportChat : -" + e.toString());
    }
  }

  //send astrologer gift
  Future<dynamic> sendGiftToAstrologer(int giftId, int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sendGift'),
        headers: await global.getApiHeaders(true),
        body:
            json.encode({"giftId": "$giftId", "astrologerId": "$astrologerId"}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in sendGiftToAstrologer:- ' + e.toString());
    }
  }

  //Notifications
  Future<dynamic> getNotifications() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getUserNotification'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<NotificationsModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => NotificationsModel.fromJson(x)));
        log("$recordList");
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getTickets : -" + e.toString());
    }
  }

  Future<dynamic> deleteNotifications(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userNotification/deleteUserNotification'),
        body: json.encode({"id": "$id"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteNotifications : -" + e.toString());
    }
  }

  Future<dynamic> deleteAllNotifications() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/userNotification/deleteAllNotification'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteAllNotifications : -" + e.toString());
    }
  }

  Future<dynamic> reportAndBlockAstrologer(
      int astrologerId, String reason) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reportBlockAstrologer'),
        body:
            json.encode({"astrologerId": "$astrologerId", "reason": "$reason"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      log('reportBlockAstrologer --> body ${response.body} ');
      log('reportBlockAstrologer --> ${response.statusCode} request body ${json.encode({
            "astrologerId": "$astrologerId",
            "reason": "$reason"
          })}');
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in reportAndBlockAstrologer : -" + e.toString());
    }
  }

  Future<dynamic> unblockAstrologer(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/unBlockAstrologer'),
        body: json.encode({"astrologerId": "$astrologerId"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in unblockAstrologer : -" + e.toString());
    }
  }

  Future<dynamic> getBlockAstrologer() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getBlockAstrologer'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<BlockedAstrologerModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => BlockedAstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in reportAndBlockAstrologer : -" + e.toString());
    }
  }

  //agora cloud recording

  Future<dynamic> getResourceId(String cname, int uid) async {
    final appId =
        global.getSystemFlagValue(global.systemFlagNameList.agoraAppId);
    final appKey =
        global.getSystemFlagValue(global.systemFlagNameList.agoraKey);
    final appSecret =
        global.getSystemFlagValue(global.systemFlagNameList.agoraSecret);
    log('Getting Resource ID for agora appId: $appId, appKey: $appKey, appSecret: $appSecret, cname: $cname, uid: $uid');

    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/$appId/cloud_recording/acquire'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({
          "cname": "$cname",
          "uid": "$uid",
          "clientRequest": {"region": "CN", "resourceExpiredHour": 24}
        }),
      );

      log('resource Status Code: ${response.statusCode}');
      log('resource Response: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        log('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      log('Exception in getResourceId: $e');
      return null;
    }
  }

  Future<dynamic> agoraStartCloudVideoRecording(
      String cname, String token, String? uid) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId}/mode/mix/start'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({
          "cname": cname.toString(),
          "uid": uid.toString(),
          "clientRequest": {
            "token": token.toString(),
            "storageConfig": {
              "secretKey":
                  "${global.getSystemFlagValue(global.systemFlagNameList.AWSSecretKey)}",
              "vendor": 1,
              "region": 14,
              "bucket":
                  "${global.getSystemFlagValue(global.systemFlagNameList.AWSBucket)}",
              "accessKey":
                  "${global.getSystemFlagValue(global.systemFlagNameList.AWSAccessKey)}"
            },
            "recordingConfig": {
              "channelType": 0, //
              "streamTypes": 2, //audio 0 video 1 and both 2
            }
          }
        }),
      );
      log('url is ${'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId}/mode/mix/start'})');
      log('response of startvideo status ${response.statusCode}');
      log('response of start video recording ${response.body}');

      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in agoraStartCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> agoraStartCloudRecording(
      String cname, int localUid, String token) async {
    log('agora recording 1 is cname is $cname and localUid is $localUid and token is $token');
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId}/mode/mix/start'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json.encode({
          "cname": cname.toString(),
          "uid": localUid.toString(),
          "clientRequest": {
            "token": token.toString(),
            "storageConfig": {
              "secretKey":
                  "${global.getSystemFlagValue(global.systemFlagNameList.googleSecretKey)}",
              "vendor": 6,
              "region": 1,
              "bucket":
                  "${global.getSystemFlagValue(global.systemFlagNameList.googleBucketName)}",
              "accessKey":
                  "${global.getSystemFlagValue(global.systemFlagNameList.googleAccessKey)}"
            },
            "recordingConfig": {
              "channelType": 0, //
              "streamTypes": 0, //audio 0 video 1 and both 2
              "audioProfile":
                  1, //SPEECH_STANDARD(1): A sampling rate of 32 kHz, audio encoding, mono, and a bitrate of up to 18 Kbps.
            }
          }
        }),
      );

      print("status:- ${response.statusCode}");
      print("body:- ${json.decode(response.body)}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in agoraStartCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> storedefaultmessageApi(
      String msg, int? customerid, int? astrologeruserid) async {
    try {
      log('blocked keyword send to api is msg $msg, and sender is $customerid, and receiver is $astrologeruserid');
      final response = await http.post(
        Uri.parse("$baseUrl/store-defaulter-message"),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "message": msg,
          "sender_id": customerid,
          "sender_type": "user",
          "receiver_id": astrologeruserid,
          "receiver_type": "astrologer",
        }),
      );

      log('response storedefaultmessageApi status ${response.statusCode}');
      log('response storedefaultmessageApi ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.encode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      print('Exception: - storedefaultmessageApi(): ' + e.toString());
    }
  }

  Future<dynamic> agoraStopCloudRecording(String cname, int uid) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId}/sid/${global.agoraSid1}/mode/mix/stop'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json
            .encode({"uid": "$uid", "cname": "$cname", "clientRequest": {}}),
      );
      log('stop recording response ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in agoraStopCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> agoraStopCloudRecording2(String cname, int uid) async {
    debugPrint('api helper stop');
    try {
      final response = await http.post(
        Uri.parse(
            'https://api.agora.io/v1/apps/${global.getSystemFlagValue(global.systemFlagNameList.agoraAppId)}/cloud_recording/resourceid/${global.agoraResourceId2}/sid/${global.agoraSid2}/mode/mix/stop'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "authorization": "Basic " +
              base64.encode(utf8.encode(
                  "${global.getSystemFlagValue(global.systemFlagNameList.agoraKey)}:${global.getSystemFlagValue(global.systemFlagNameList.agoraSecret)}"))
        },
        body: json
            .encode({"uid": "$uid", "cname": "$cname", "clientRequest": {}}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in agoraStopCloudRecording:- ' + e.toString());
    }
  }

  Future<dynamic> stopRecoedingStoreData(
      int callId, String channelName, String sId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/storeCallRecording'),
        body: json.encode({
          "callId": "$callId",
          "channelName": "$channelName",
          "sId": "$sId"
        }),
        headers: await global.getApiHeaders(true),
      );
      debugPrint('stopRecoedingStoreData response: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getLiveUsers : -" + e.toString());
    }
  }

  //intake form

  Future<dynamic> addIntakeDetail(IntakeModel basicDetails) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/addIntakeForm'),
        headers: await global.getApiHeaders(true),
        body: json.encode(basicDetails),
      );
      debugPrint("callintakeformData ${json.encode(basicDetails)}");
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      log('addIntakeDetail response: ${response.body}');
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in addReportIntakeDetail:- ' + e.toString());
    }
  }

  Future<dynamic> getIntakedata() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/chatRequest/getIntakeForm'),
        headers: await global.getApiHeaders(true),
      );
      debugPrint('getIntakedata resp : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = response.body;
      } else {
        recordList = null;
      }
      return recordList;
    } catch (e) {
      debugPrint("Exception in getIntakedata : -" + e.toString());
    }
  }

  //live user
  Future<dynamic> saveLiveUsers(LiveUserModel details) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addLiveUser'),
        body: json.encode(details),
        headers: await global.getApiHeaders(true),
      );
      debugPrint('saveLiveUsers res: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getIntakedata : -" + e.toString());
    }
  }

  Future<dynamic> getLiveUsers(String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getLiveUser'),
        body: json.encode({"channelName": "$channelName"}),
        headers: await global.getApiHeaders(false),
      );
      debugPrint('getLiveUsers res: ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<LiveUserModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => LiveUserModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getLiveUsers : -" + e.toString());
    }
  }

  Future<dynamic> deleteLiveUsers() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteLiveUser'),
        headers: await global.getApiHeaders(true),
      );
      debugPrint('deleteLiveUsers res : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in deleteLiveUsers : -" + e.toString());
    }
  }

  //astrologer assistant chat
  Future<dynamic> storeAssistantFirebaseChatId(
      int userId, int partnerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAssistantChatId'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "customerId": userId,
          "astrologerId": partnerId,
          "senderId": userId,
          "receiverId": partnerId,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          'Exception: - storeAssistantFirebaseChatId(): ' + e.toString());
    }
  }

  Future<dynamic> getAssistantChat() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getAssistantChatHistory'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AssistantModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AssistantModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception: - getAssistantChat(): ' + e.toString());
    }
  }

  Future<dynamic> deleteAssistantChat(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/deleteAssistantChat'),
        headers: await global.getApiHeaders(true),
        body: json.encode(
          {
            "id": id.toString(),
          },
        ),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in deleteAssistantChat():' + e.toString());
    }
  }

  Future<dynamic> checkAstrologerPaidSession(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getCustomerPaidSession'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"astrologerId": "$astrologerId"}),
      );
      dynamic recordList;

      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception: - checkAstrologerPaidSession(): ' + e.toString());
    }
  }

  Future<dynamic> blockAstrologerAssistant(int assistantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/astrologerAssistant/block'),
        body: json.encode({"assistantId": "$assistantId"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in blockAstrologerAssistant : -" + e.toString());
    }
  }

  Future<dynamic> unblockAstrologerAssistant(int assistantId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/astrologerAssistant/unBlock'),
        body: json.encode({"assistantId": "$assistantId"}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in unblockAstrologerAssistant : -" + e.toString());
    }
  }

  //upcomming event search event

  Future<dynamic> liveEventSearch(String? searchString) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/searchLiveAstro"),
        headers: await global.getApiHeaders(true),
        body: json.encode({"searchString": searchString}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<AstrologerModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AstrologerModel.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception in liveEventSearch():' + e.toString());
    }
  }

//report and block astrologer profile review

  Future<dynamic> blockAstrologerProfileReview(
      int id, int? isBlocked, int? isReported) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/blockUserReview'),
        body: json.encode(
            {"id": "$id", "isBlocked": isBlocked, "isReported": isReported}),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        if (json.decode(response.body)["recordList"] != null) {
          ReviewController reviewController = Get.find<ReviewController>();
          reviewController.astrologerId =
              int.parse(json.decode(response.body)["recordList"].toString());
        }
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          "Exception in blockAstrologerProfileReview : -" + e.toString());
    }
  }

  Future<dynamic> getCallHistoryById(int callId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/getCallById'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"callId": callId}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in getCallHistoryById : -" + e.toString());
    }
  }

  Future<dynamic> updetUserProfilePic(String profile) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/user/updateProfile'),
        headers: await global.getApiHeaders(true),
        body: json.encode({"profile": '$profile'}),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint('Exception:- in updetUserProfilePic:-' + e.toString());
    }
  }

  Future<dynamic> generateRtmToken(String agoraAppId,
      String agoraAppCertificate, String chatId, String channelName) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/generateToken'),
        body: json.encode({
          "appID": "$agoraAppId",
          "appCertificate": "$agoraAppCertificate",
          "user": "$chatId",
          "channelName": "$channelName"
        }),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in generateRtmToken : -" + e.toString());
    }
  }

  Future endLiveSession(int astrologerId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/liveAstrologer/endSession"),
        body: {"astrologerId": "$astrologerId"},
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)['recordList'];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          "Exception: api_helper.dart - endLiveSession(): " + e.toString());
    }
  }

  Future getZodiacProfileImg() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getUserProfile"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = List<Zodic>.from(json
            .decode(response.body)["recordList"]
            .map((x) => Zodic.fromJson(x)));
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception: api_helper.dart - getZodiacProfileImg(): " +
          e.toString());
    }
  }

  Future getSystemFlag() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getSystemFlag"),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      log("System Flag api response ${response.body}");
      debugPrint("System Flag api code status ${response.statusCode}");
      if (response.statusCode == 200) {
        recordList = List<SystemFlag>.from(json
            .decode(response.body)["recordList"]
            .map((x) => SystemFlag.fromJson(x)));
        print("${recordList}");
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          "Exception: api_helper.dart - getSystemFlag(): " + e.toString());
    }
  }

  Future getLanguagesForMultiLanguage() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getAppLanguage"),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = (json.decode(response.body)["recordList"] as List)
            .map((x) => Language.fromJson(x))
            .where((lang) => lang.title.toLowerCase() != 'sanskrit')
            .toList();
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          "Exception: api_helper.dart - getLanguagesForMultiLanguage(): " +
              e.toString());
    }
  }

  Future getpaymentAmount() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/getRechargeAmount"),
        headers: await global.getApiHeaders(true),
      );

      dynamic recordList;
      log("Recharege Options ${response.body}");
      if (response.statusCode == 200) {
        recordList = List<AmountModel>.from(json
            .decode(response.body)["recordList"]
            .map((x) => AmountModel.fromJson(x)));
        debugPrint('getpaymentAmount : ${response.statusCode}');
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint(
          "Exception: api_helper.dart - getpaymentAmount(): " + e.toString());
    }
  }

  Future<dynamic> checkFreeSession() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/checkFreeSessionAvailable'),
        headers: await global.getApiHeaders(true),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body)["isAddNewRequest"];
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in checkFreeSession : -" + e.toString());
    }
  }

  Future<dynamic> addFeedBack(String feedbackType, String? feedback) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/addHoroscopeFeedback'),
        body: json
            .encode({"feedbacktype": "$feedbackType", "feedback": feedback}),
        headers: await global.getApiHeaders(true),
      );
      debugPrint('addFeedBack : ${response.body}');
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else {
        recordList = null;
      }
      return getAPIResult(response, recordList);
    } catch (e) {
      debugPrint("Exception in addFeedBack : -" + e.toString());
    }
  }

  Future<dynamic> updateMin(dynamic chatId, dynamic chatDuration) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updatechatMinute'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "chatId": chatId,
          "chat_duration": chatDuration,
        }),
      );
      dynamic recordList;
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else if (response.statusCode == 400) {
        recordList = json.decode(response.body);
      } else {
        recordList = json.decode(response.body);
      }
      return recordList;
    } catch (e) {
      debugPrint('Exception:- in updateMin:- ' + e.toString());
    }
  }

  Future<dynamic> updateCallMin(dynamic callid, dynamic callDuration) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/updatecallMinute'),
        headers: await global.getApiHeaders(true),
        body: json.encode({
          "callId": callid,
          "call_duration": callDuration,
        }),
      );

      dynamic recordList;
      print("My Update titme reda ${json.decode(response.body)}");
      if (response.statusCode == 200) {
        recordList = json.decode(response.body);
      } else if (response.statusCode == 400) {
        recordList = json.decode(response.body);
      } else {
        recordList = json.decode(response.body);
      }
      return recordList;
    } catch (e) {
      debugPrint('Exception:- in updateMin:- ' + e.toString());
    }
  }
}
