// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:developer';

import 'package:AstrowayCustomer/controllers/dropDownController.dart';
import 'package:AstrowayCustomer/controllers/kundliMatchingController.dart';
import 'package:AstrowayCustomer/model/getPdfKundali_model.dart';
import 'package:AstrowayCustomer/model/getPdfPrice_model.dart';
import 'package:AstrowayCustomer/model/kundli.dart';
import 'package:AstrowayCustomer/model/kundliBasicDetailMode.dart';
import 'package:AstrowayCustomer/model/kundli_model.dart';
import 'package:AstrowayCustomer/model/kundlichartModel.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/views/kudali/GetKundliDetailScreen.dart';
import 'package:date_format/date_format.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:ui' as ui;

import '../model/astavargaDetailModel.dart';
import '../model/basicDetailmodel.dart';
import '../model/chartDetailmodel.dart';
import '../model/dashdetailmodel.dart';
import '../model/doshaDetailModel.dart';
import '../model/planetreportmodel.dart';
import '../model/reportModel copy.dart';

class KundliController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TextEditingController userNameController = TextEditingController();
  TextEditingController birthKundliPlaceController = TextEditingController();

  TextEditingController editNameController = TextEditingController();
  TextEditingController editGenderController = TextEditingController();
  TextEditingController editBirthDateController = TextEditingController();
  TextEditingController editBirthTimeController = TextEditingController();
  TextEditingController editBirthPlaceController = TextEditingController();
  AstavargaDetailModel? astavargaDetailModel;
  List<String> ashtakvargaList = [];
  List<int> ashtakvargaTotal = [];
  List<List<dynamic>> ashtakvargaPoints = [];
  int? maxRows;
  var columns;
  String? selectedGender;
  DateTime? selectedDate;
  String? selectedTime;
  double? lat;
  double? long;
  double? timeZone;
  var pdf = pw.Document();
  bool isDataLoaded = false;
  Map<String, String> chartNames = {
    'D1': 'Rasi',
    'D2': 'Hora',
    'D3': 'Drekkana',
    'D4': 'Chaturthamsa',
    'D5': 'Panchamamsa',
    'D6': 'Shastamsa',
    'D7': 'Saptamsa',
    'D8': 'Astamsa',
    'D9': 'Navamsa',
    'D10': 'Dasamsa',
    'D11': 'Rudramsa',
    'D12': 'Dwadasamsa',
    'D16': 'Shodasamsa',
    'D20': 'Vimsamsa',
    'D24': 'Siddhamsa',
    'D27': 'Nakshatramsa',
    'D30': 'Trimsamsa',
    'D40': 'Khavedamsa',
    'D45': 'Akshavedamsa',
    'D60': 'Shastyamsa',
    'chalit': 'Chalit',
    'sun': 'Sun',
    'moon': 'Moon',
    'kp_chalit': 'Kp Chalit',
  };
  GetPdfKundaliModel? pdfKundaliData;
  List<ui.Image>? svgImages; // Change to nullable type
  String? rawsvg;
  List<String> svgList = [];
  List<String> keyList = [];

  String emptyScreenText = "You haven\'t added any kundli yet!";
  var dashaindextable = 0;
  var tableindex = 0;

  var yagnidashaindextable = 0;
  var yagnitableindex = 0;
  List<String> yaginiaddedItemsTable = [];
  final Map<String, String> astrologicalMap = {
    'D1': 'Rasi',
    'D9': 'Navamsa',
    'D2': 'Hora',
    'D3': 'Drekkana',
    'D4': 'Chaturthamsa',
    'D5': 'Panchamamsa',
    'D6': 'Shastamsa',
    'D7': 'Saptamsa',
    'D8': 'Astamsa',
    'D10': 'Dasamsa',
    'D11': 'Rudramsa',
    'D12': 'Dwadasamsa',
    'D16': 'Shodasamsa',
    'D20': 'Vimsamsa',
    'D24': 'Siddhamsa',
    'D27': 'Nakshatramsa',
    'D30': 'Trimsamsa',
    'D40': 'Khavedamsa',
    'D45': 'Akshavedamsa',
    'D60': 'Shastyamsa',
    'chalit': 'Chalit',
    'sun': 'Sun',
    'moon': 'Moon',
  };

  var tabIndex = 0;
  bool isNakshatraTapped = false;
  ui.Image? svgImage; // Change to nullable type

  ui.Image? svgImageKp; // Change to nullable type
  List<String> addedItemsTable = [];
  bool isDisable = true;
  bool isTimeOfBirthKnow = false;
  bool isSelectedLanEng = true;
  bool isSelectedLanHin = false;
  bool isNorthIn = true;
  bool isSouthIn = false;
  bool isShowMore = false;
  bool isDataTable = false;
  int kundliTabInitialIndex = 5;

  var kundliList = <KundliModel>[];
  var kundaliBasicList = <KundliBasicModel>[];
  var searchKundliList = <KundliModel>[];
  KundliBasicDetail? kundliBasicDetail;
  KundliBasicPanchangDetail? kundliBasicPanchangDetail;
  KundliAvakhdaDetail? kundliAvakhadaDetail;
  KundliPlanetsDetail? kundliPlanetsDetail;
  GemstoneModel? gemstoneList;
  DropDownController dropDownController = Get.find<DropDownController>();
  List<List<VimshattariModel>>? vimshattariList = [];
  var planetList = [];
  TabController? tabController;
  KundliPlanetsDetail sunDetails = KundliPlanetsDetail();
  KundliPlanetsDetail moonDetails = KundliPlanetsDetail();
  KundliPlanetsDetail marsDetails = KundliPlanetsDetail();
  KundliPlanetsDetail mercuryDetails = KundliPlanetsDetail();
  KundliPlanetsDetail jupiterDetails = KundliPlanetsDetail();
  KundliPlanetsDetail venusDetails = KundliPlanetsDetail();
  KundliPlanetsDetail saturnDetails = KundliPlanetsDetail();
  KundliPlanetsDetail rahuDetails = KundliPlanetsDetail();
  KundliPlanetsDetail ketuDetails = KundliPlanetsDetail();
  KundliPlanetsDetail ascendantDetails = KundliPlanetsDetail();
  bool? isSadesati;
  bool? isKalsarpa;
  String? generalDesc;
  GetPdfPrice? pdfPriceData;

  List _kundaliData = [];
  List get kundaliData => _kundaliData;
  int startHouse = 0;

  List name = [];

  APIHelper apiHelper = new APIHelper();
  String prefix = '';
  List<KundliGender> gender = [
    KundliGender(title: 'Male', isSelected: false, image: Images.male),
    KundliGender(title: 'Female', isSelected: false, image: Images.female),
    KundliGender(title: 'Other', isSelected: false, image: Images.otherGender),
  ];
  int initialIndex = 0;
  List kundliTitle = [
    'Hey there! \nWhat is Your name ?',
    'What is your gender?',
    'Enter your birth date',
    'Enter your birth time',
    'Where were you born?',
  ];
  List<Kundli> listIcon = [
    Kundli(icon: Icons.person, isSelected: true),
    Kundli(icon: Icons.search, isSelected: false),
    Kundli(icon: Icons.calendar_month, isSelected: false),
    Kundli(icon: Icons.punch_clock_outlined, isSelected: false),
    Kundli(icon: Icons.location_city, isSelected: false),
  ];
  String selectedDirection = 'north'; // Default direction
  String selecteddashaoption = 'vimshottari'; // Default direction
  KundliChartModel? kundliChartModel;

  List<String> celestialBodies = [
    'Sun',
    'Moon',
    'Mercury',
    'Venus',
    'Mars',
    'Saturn',
    'Jupiter',
    'Rahu',
    'Ketu',
  ];
  PlanetReportModel? planetreport;
  ReportDetailModel? reportDeatilmodel;
  var reportdeatils;
  List<Map<String, String?>>? reportDetailList;
  Future getReport(int? id) async {
    log("getReport $id ");
    try {
      await apiHelper.getReportApi(id).then((result) {
        print("getReportApi");
        print("getReportApi chart status -> ${result.status}");
        if (result.status == 200) {
          reportDeatilmodel = null;
          isDataLoaded = true;
          update();

          reportDeatilmodel = result;
          reportdeatils = reportDeatilmodel?.ascendant?.response?[0];
          reportDetailList = [
            {
              'label': 'Ascendant',
              'value': reportdeatils?.ascendant.toString(),
            },
            {
              'label': 'Ascendant lord',
              'value': reportdeatils?.ascendantLord.toString(),
            },
            {
              'label': 'Ascendant lord location',
              'value': reportdeatils?.ascendantLordLocation.toString(),
            },
            {
              'label': 'Ascendant lord house location',
              'value': reportdeatils?.ascendantLordHouseLocation.toString(),
            },
            {'label': 'Symbol', 'value': reportdeatils?.symbol.toString()},
            {
              'label': 'Zoadiac Characterstics',
              'value': reportdeatils?.zodiacCharacteristics.toString(),
            },
            {'label': 'Lucky Gem', 'value': reportdeatils?.luckyGem.toString()},
            {
              'label': 'Day of Fasting',
              'value': reportdeatils?.dayForFasting.toString(),
            },
            {
              'label': 'Good Quality',
              'value': reportdeatils?.goodQualities.toString(),
            },
            {
              'label': 'Bad Quality',
              'value': reportdeatils?.badQualities.toString(),
            },
            {
              'label': 'Spiritual Advice',
              'value': reportdeatils?.spiritualityAdvice.toString(),
            },
            {
              'label': 'General prediction',
              'value': reportdeatils?.generalPrediction.toString(),
            },
            {
              'label': 'Personalized Prediction',
              'value': reportdeatils?.personalisedPrediction.toString(),
            },
          ];

          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get charts',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  Future getPlanetReport(int? id, String planetname) async {
    log("getReport $id ");
    try {
      await apiHelper.getPlanetReportApi(id, planetname).then((result) {
        print("getPlanetReportApi");
        print("getPlanetReportApi chart status -> ${result.status}");
        if (result.status == 200) {
          planetreport = null;
          isDataLoaded = true;
          update();

          planetreport = result;

          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get getPlanetReport',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  DashDetailsModel? dashaDeatilmodel;

  DoshaDetailsModel? doshaDeatilmodel;
  Future getDosha(int? id) async {
    log("getDosha $id ");
    try {
      await apiHelper.getDoshaApi(id).then((result) {
        print("getDoshaApi");
        print("getDoshaApi chart status -> ${result.status}");
        if (result.status == 200) {
          doshaDeatilmodel = null;
          isDataLoaded = true;
          update();
          doshaDeatilmodel = result;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get getDoshaApi',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getDashaApi- $e");
    }
  }

  ChartDetailModel? chartDeatilmodel;
  Future getChartDetails(
    int? id,
    String div,
    String style, {
    bool firstloding = false,
  }) async {
    log("getChartDetails $id and $div and $style");
    try {
      await apiHelper.getChartDetailsApi(id, div, style).then((result) {
        firstloding ? global.hideLoader() : null;
        print("getChartDetails");
        print("getChartDetails chart status -> ${result.status}");
        if (result.status == 200) {
          chartDeatilmodel = null;
          isDataLoaded = true;
          update();

          chartDeatilmodel = result;
          log("My data is here1${chartDeatilmodel!.chartDetails}");
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get charts',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  Future getDasha(int? id) async {
    log("getDasha $id ");
    try {
      await apiHelper.getDashaApi(id).then((result) {
        print("getDashaApi");
        print("getDashaApi chart status -> ${result.status}");
        if (result.status == 200) {
          dashaDeatilmodel = null;
          isDataLoaded = true;
          update();
          dashaDeatilmodel = result;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get getDashaApi',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getDashaApi- $e");
    }
  }

  Map<String, List<int>>? binnashtakvargaData = {};

  Future<void> getAstaVarga(int? id) async {
    log("getAstaVarga $id");
    try {
      AstavargaDetailModel? result = await apiHelper.getAstaVargaApi(id);
      print("getAstaVarga");
      print("getAstaVarga -> ${result?.status}");
      if (result?.status == 200) {
        ashtakvargaList.clear();
        ashtakvargaTotal.clear();
        ashtakvargaPoints.clear();
        binnashtakvargaData = {};

        astavargaDetailModel = result;
        ashtakvargaList = result?.ashtakvarga?.response?.ashtakvargaOrder ?? [];
        ashtakvargaTotal =
            result?.ashtakvarga?.response?.ashtakvargaTotal ?? [];
        ashtakvargaPoints =
            result?.ashtakvarga?.response?.ashtakvargaPoints ?? [];
        // Parse binnashtakvarga
        if (result?.binnashtakvarga?.response != null) {
          final binnashtakvargaResponse = result!.binnashtakvarga!.response!;
          binnashtakvargaData = {
            'Ascendant': binnashtakvargaResponse.ascendant!,
            'Sun': binnashtakvargaResponse.sun!,
            'Moon': binnashtakvargaResponse.moon!,
            'Mars': binnashtakvargaResponse.mars!,
            'Mercury': binnashtakvargaResponse.mercury!,
            'Jupiter': binnashtakvargaResponse.jupiter!,
            'Saturn': binnashtakvargaResponse.saturn!,
            'Venus': binnashtakvargaResponse.venus!,
          };
          log('binnashtakvargaData -> $binnashtakvargaData');
        }
        columns = binnashtakvargaData?.keys.toList();
        maxRows = binnashtakvargaData?[columns[0]]!.length;
        update();
      } else {
        if (global.currentUserId != null) {
          global.showToast(
            message: 'Failed to get charts',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        }
        pdfKundaliData = null;
      }
    } catch (e) {
      print("getChartDetails- $e");
    }
  }

  BasicDetailModel? basicDeatilmodel;
  Future getBasicDetailChart(int? id) async {
    print("kundliAddNew $id");
    try {
      await apiHelper.getBasicDetailApi(id).then((result) {
        global.hideLoader();
        print("kundliAddNew");
        print("kundli chart status -> ${result.status}");
        if (result.status == 200) {
          basicDeatilmodel = result;
          update();
          Get.to(
            () => GetKundliDetailScreen(
              userid: id,
              pdflink: basicDeatilmodel?.recordList?.pdfLink,
            ),
          );
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getpdfKundali():- $e");
    }
  }

  List<KundliDetailTab> reportTab = [
    KundliDetailTab(title: 'General', isSelected: true),
  ];

  List<KundliDetailTab> remediesTab = [
    KundliDetailTab(title: 'Gemstones', isSelected: false),
  ];
  List<KundliDetailTab> rudrakshaTab = [
    KundliDetailTab(title: '3-Mukhi', isSelected: true),
    KundliDetailTab(title: '12-Mukhi', isSelected: false),
    KundliDetailTab(title: '11-Mukhi', isSelected: false),
  ];
  List<KundliDetailTab> doshaTab = [
    KundliDetailTab(title: 'Manglik', isSelected: true),
    KundliDetailTab(title: 'Kalsarpa', isSelected: false),
    KundliDetailTab(title: 'Sadesati', isSelected: false),
  ];

  List<KundliDetailTab> dashaTab = [
    KundliDetailTab(title: 'Vimshattari', isSelected: true),
  ];

  List<KundliDetailTab> ashtakvargaTab = [
    KundliDetailTab(title: 'Sav', isSelected: true),
    KundliDetailTab(title: 'Asc', isSelected: false),
    KundliDetailTab(title: 'jupiter', isSelected: false),
    KundliDetailTab(title: 'Mars', isSelected: false),
    KundliDetailTab(title: 'Mercury', isSelected: false),
    KundliDetailTab(title: 'Moon', isSelected: false),
    KundliDetailTab(title: 'Saturn', isSelected: false),
    KundliDetailTab(title: 'Sun', isSelected: false),
    KundliDetailTab(title: 'Venus', isSelected: false),
  ];

  List<KundliDetailTab> divisionalTab = [
    KundliDetailTab(title: 'Chalit', isSelected: true),
    KundliDetailTab(title: 'Sun', isSelected: false),
    KundliDetailTab(title: 'Moon', isSelected: false),
    KundliDetailTab(title: 'Hora(D-2)', isSelected: false),
    KundliDetailTab(title: 'Drekkana(D-3)', isSelected: false),
    KundliDetailTab(title: 'Chaturthamsa(D-4)', isSelected: false),
    KundliDetailTab(title: 'Scaptamsa(D-7)', isSelected: false),
    KundliDetailTab(title: 'Dasamsa(D-10)', isSelected: false),
    KundliDetailTab(title: 'Dwadasamsa(D-12)', isSelected: false),
    KundliDetailTab(title: 'Shodasamsa(D-16)', isSelected: false),
    KundliDetailTab(title: 'Vimsamsa(D-20)', isSelected: false),
    KundliDetailTab(title: 'Chaturvimsamsa', isSelected: false),
    KundliDetailTab(title: 'Saptavisamsa', isSelected: false),
    KundliDetailTab(title: 'Trimsamsa(D-30)', isSelected: false),
    KundliDetailTab(title: 'Khavedamsa(D-40)', isSelected: false),
    KundliDetailTab(title: 'Akshavedamsa(D-45)', isSelected: false),
    KundliDetailTab(title: 'Shastiamsa(D-60)', isSelected: false),
  ];

  List<KundliDetailTab> chartKundliTab = [
    KundliDetailTab(title: 'General', isSelected: true),
    KundliDetailTab(title: 'Planetary', isSelected: false),
    KundliDetailTab(title: 'Yoga', isSelected: false),
  ];
  List<KundliDetailTab> planetTab = [
    KundliDetailTab(title: 'Sign', isSelected: true),
    KundliDetailTab(title: 'Nakshatra', isSelected: false),
  ];
  List<KundliDetails> basicDetails = [
    KundliDetails(title: 'Name', value: 'Yami'),
    KundliDetails(title: 'Date', value: '02 january 1996'),
    KundliDetails(title: 'Time', value: '01:46 PM'),
    KundliDetails(title: 'Place', value: 'New Delhi,Delhi,india'),
    KundliDetails(title: 'Latitude', value: '28.64'),
    KundliDetails(title: 'Longitude', value: '77.22'),
    KundliDetails(title: 'Timezone', value: 'GMT+5.5'),
    KundliDetails(title: 'Sunrise', value: '7:14:02AM'),
    KundliDetails(title: 'Sunset', value: '5:34:02PM'),
    KundliDetails(title: 'Ayanamsha', value: '23.80117'),
  ];
  List<KundliDetails> panchangDetails = [
    KundliDetails(title: 'Tithi', value: 'Shuklakadashi'),
    KundliDetails(title: 'Karan', value: 'Vishti'),
    KundliDetails(title: 'Yog', value: 'Sadhya'),
    KundliDetails(title: 'Nakshtra', value: 'Krittika'),
    KundliDetails(title: 'Timezone', value: 'GMT+5.5'),
    KundliDetails(title: 'Sunrise', value: '7:14:02AM'),
    KundliDetails(title: 'Sunset', value: '5:34:02PM'),
  ];

  List<KundliDetails> avakhadaDetails = [
    KundliDetails(title: 'Varna', value: 'Kshattriya'),
    KundliDetails(title: 'Vashya', value: 'Chatushpada'),
    KundliDetails(title: 'Yoni', value: 'Chaga'),
    KundliDetails(title: 'GAn', value: 'NewRakshasa'),
    KundliDetails(title: 'Nadi', value: 'Antya'),
    KundliDetails(title: 'Sign', value: 'Aries'),
    KundliDetails(title: 'Sign Lord', value: 'Mars'),
    KundliDetails(title: 'Nakshatra-charan', value: 'Krittika'),
    KundliDetails(title: 'Yog', value: 'Dashya'),
    KundliDetails(title: 'Karan', value: 'Cishti'),
    KundliDetails(title: 'Tithi', value: 'Shuklakadashi'),
    KundliDetails(title: 'Tatva', value: 'Fire'),
    KundliDetails(title: 'Name alphabet', value: 'S'),
    KundliDetails(title: 'Paya', value: 'Iron'),
  ];

  final List<Map<String, String>> listOfVishattari = [
    {"planet": "SU", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "MO", "start": "6-Jun-2000", "end": "16-Feb-2001"},
    {"planet": "MA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "RA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "JU", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "SA", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "ME", "start": "16-Feb-1996", "end": "16-Feb-1998"},
    {"planet": "VE", "start": "16-Feb-1996", "end": "16-Feb-1998"},
  ];

  final List<Map<String, String>> listOfPlanets = [
    {
      "planet": "SU",
      "cups": "6",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "planet": "Moon",
      "cups": "4",
      "sign": "Libra",
      "signLord": "sa",
      "starLord": "Ve",
      "subLord": "Ve",
    },
    {
      "planet": "Mars",
      "cups": "2",
      "sign": "Libra",
      "signLord": "Ju",
      "starLord": "Me",
      "subLord": "Ma",
    },
    {
      "planet": "Rahu",
      "cups": "6",
      "sign": "Gemni",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "planet": "Jupiter",
      "cups": "10",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Sa",
      "subLord": "Ra",
    },
    {
      "planet": "Saturn",
      "cups": "1",
      "sign": "Libra",
      "signLord": "Me",
      "starLord": "Ma",
      "subLord": "Sa",
    },
    {
      "planet": "Mercury",
      "cups": "12",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "planet": "Ketu",
      "cups": "1",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Su",
    },
    {
      "planet": "Venus",
      "cups": "6",
      "sign": "Libra",
      "signLord": "Ma",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "planet": "Neptune",
      "cups": "10",
      "sign": "Aries",
      "signLord": "Ve",
      "starLord": "Ju",
      "subLord": "Ju",
    },
    {
      "planet": "Uranus",
      "cups": "8",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "planet": "Pluto",
      "cups": "7",
      "sign": "capricorn",
      "signLord": "Me",
      "starLord": "Ju",
      "subLord": "Me",
    },
  ];
  final List<Map<String, String>> listOfCups = [
    {
      "cups": "1",
      "degree": "9.86",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "cups": "2",
      "degree": "40.6",
      "sign": "Libra",
      "signLord": "sa",
      "starLord": "Ve",
      "subLord": "Ve",
    },
    {
      "cups": "3",
      "degree": "65.16",
      "sign": "Libra",
      "signLord": "Ju",
      "starLord": "Me",
      "subLord": "Ma",
    },
    {
      "cups": "4",
      "degree": "88.66",
      "sign": "Gemni",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "cups": "5",
      "degree": "111.26",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Sa",
      "subLord": "Ra",
    },
    {
      "cups": "6",
      "degree": "88.61",
      "sign": "Libra",
      "signLord": "Me",
      "starLord": "Ma",
      "subLord": "Sa",
    },
    {
      "cups": "7",
      "degree": "115.12",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "cups": "8",
      "degree": "116.21",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Su",
    },
    {
      "cups": "9",
      "degree": "116.26",
      "sign": "Libra",
      "signLord": "Ma",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "cups": "10",
      "degree": "210.67",
      "sign": "Aries",
      "signLord": "Ve",
      "starLord": "Ju",
      "subLord": "Ju",
    },
    {
      "cups": "11",
      "degree": "278.99",
      "sign": "Libra",
      "signLord": "Ve",
      "starLord": "Ma",
      "subLord": "Me",
    },
    {
      "cups": "12",
      "degree": "328.90",
      "sign": "capricorn",
      "signLord": "Me",
      "starLord": "Ju",
      "subLord": "Me",
    },
  ];
  final List<Map<String, String>> listOfPlanetsSign = [
    {
      "planet": "Ascendant",
      "sign": "Aries",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1",
    },
    {
      "planet": "Venus",
      "sign": "Aries",
      "signLord": "Jupiter",
      "degree": "22 \u00b0",
      "house": "11",
    },
    {
      "planet": "Ascendant",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "9",
    },
    {
      "planet": "Moon",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "10",
    },
    {
      "planet": "Ascendant",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1",
    },
    {
      "planet": "Venus",
      "sign": "Aries",
      "signLord": "Jupiter",
      "degree": "22 \u00b0",
      "house": "8",
    },
    {
      "planet": "Rahu",
      "sign": "Capricorn",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1",
    },
    {
      "planet": "Rahu",
      "sign": "Aries",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1",
    },
    {
      "planet": "Ketu",
      "sign": "Capricorn",
      "signLord": "Saturn",
      "degree": "22 \u00b0",
      "house": "1",
    },
    {
      "planet": "Ascendant",
      "sign": "Aries",
      "signLord": "Saturn",
      "degree": "22 \u00b0",
      "house": "7",
    },
    {
      "planet": "Ascendant",
      "sign": "Aries",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "1",
    },
    {
      "planet": "pluto",
      "sign": "Scorpio",
      "signLord": "Mars",
      "degree": "22 \u00b0",
      "house": "10",
    },
  ];
  DateTime editDOB = DateTime.now();
  @override
  void onInit() async {
    tabController = TabController(vsync: this, length: 6);
    // birthPlaceController.text = 'New Delhi, Delhi, India';
    _init();
    //getKundliList();
    super.onInit();
  }

  _init() async {
    await getKundliList();
  }

  backStepForCreateKundli(int index) {
    initialIndex = index;
  }

  updateIcon(index) {
    listIcon[index].isSelected = true;
    for (int i = 0; i < listIcon.length; i++) {
      if (i == index) {
        listIcon[index].isSelected = true;
        continue;
      } else {
        listIcon[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectTab(index) {
    reportTab[index].isSelected = true;
    for (int i = 0; i < reportTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        reportTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  shareKundli(String pdfLink) async {
    try {
      await global.commonShareMethod(
        title:
            "Hey! I am using ${global.getSystemFlagValue(global.systemFlagNameList.appName)} to get predictions related to marriage/career.Check my Kundali with .You should also try and see your Kundali!\n\n$pdfLink\n\n${global.splashController.appShareLinkForLiveSreaming}",
      );
    } catch (e) {
      print('Excpetion in share kundli $e');
    }
  }

  selectRemediesTab(int index) {
    remediesTab[index].isSelected = true;
    for (int i = 0; i < remediesTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        remediesTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectRudrakshaTab(index) {
    rudrakshaTab[index].isSelected = true;
    for (int i = 0; i < rudrakshaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        rudrakshaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDoshaTab(int index) {
    doshaTab[index].isSelected = true;
    for (int i = 0; i < doshaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        doshaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDashaTab(int index) {
    dashaTab[index].isSelected = true;
    for (int i = 0; i < dashaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        dashaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectashtakvargaTab(int index) {
    ashtakvargaTab[index].isSelected = true;
    for (int i = 0; i < ashtakvargaTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        ashtakvargaTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectDivisionTab(int index) {
    divisionalTab[index].isSelected = true;
    for (int i = 0; i < divisionalTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        divisionalTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectPlanetTab(int index) {
    planetTab[index].isSelected = true;
    for (int i = 0; i < planetTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        planetTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  selectChartKundliTab(int index) {
    chartKundliTab[index].isSelected = true;
    for (int i = 0; i < chartKundliTab.length; i++) {
      if (i == index) {
        continue;
      } else {
        chartKundliTab[i].isSelected = false;
        update();
      }
    }
    update();
  }

  updateBg(int index) {
    selectedGender = gender[index].title;
    for (int i = 0; i < gender.length; i++) {
      if (i == index) {
        continue;
      } else {
        gender[i].isSelected = false;
      }
    }
    gender[index].isSelected = true;
    update();
  }

  updateAllBg() {
    for (int i = 0; i < gender.length; i++) {
      gender[i].isSelected = false;
    }

    update();
  }

  updateIsDisable() {
    // ignore: unrelated_type_equality_checks
    if (userNameController.text != "") {
      isDisable = false;
      update();
    } else {
      isDisable = true;
      update();
    }
  }

  updateCheck(value) {
    isTimeOfBirthKnow = value;
    update();
  }

  updateInitialIndex() {
    if (initialIndex < 5) {
      initialIndex = initialIndex + 1;
    } else {
      initialIndex = 0;
    }
    update();
  }

  updateListIndex(int index) {
    if (index < 5) {
      index += 1;
    } else {
      index = 0;
    }
  }

  langugeUpdate({required bool isEng, required bool isHin}) {
    isSelectedLanEng = isEng;
    isSelectedLanHin = isHin;
    update();
  }

  northSouthUpdate({required bool isNorth, required bool isSouth}) {
    isNorthIn = isNorth;
    isSouthIn = isSouth;
    update();
  }

  changeTapIndex(int index) {
    kundliTabInitialIndex = index;
    update();
  }

  showMoreText() {
    isShowMore = !isShowMore;
    update();
  }

  String? dropDownGender;
  List item = ['Male', 'Female', 'Other'];
  String innitialValue(int callId, List<String> item) {
    if (callId == 1) {
      return dropDownGender ?? item[0];
    } else {
      return 'no data';
    }
  }

  void genderChoose(String value) {
    dropDownGender = value;
    update();
  }

  getKundliList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getKundli().then((result) {
            if (result.status == "200") {
              kundliList = result.recordList;
              searchKundliList = kundliList;
              print("getKundaliList");
              update();
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'FAil to get kundli',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  Future<int> pdfPrice() async {
    int value = 0;
    try {
      await apiHelper.getPdfPrice().then((result) {
        if (result.status == "200") {
          Map<String, dynamic> data = jsonDecode(result.recordList);
          pdfPriceData = GetPdfPrice.fromJson(data);
          value = 1;
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          value = 0;
          // pdfKundaliData=null;
        }
      });
    } catch (e) {
      print("getpdfprice():- $e");
      value = 0;
    }
    return value;
  }

  Future pdfKundali(String id) async {
    try {
      await apiHelper.getPdfKundli(id).then((result) {
        if (result.status == "200") {
          Map<String, dynamic> data = jsonDecode(result.recordList);
          pdfKundaliData = GetPdfKundaliModel.fromJson(data);
          update();
        } else {
          if (global.currentUserId != null) {
            global.showToast(
              message: 'FAil to get kundli',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
          pdfKundaliData = null;
        }
      });
    } catch (e) {
      print("getpdfKundali():- $e");
    }
  }

  getKundliListById(int index) async {
    try {
      editNameController.text = searchKundliList[index].name;
      editBirthDateController.text = formatDate(
        searchKundliList[index].birthDate,
        [dd, '-', mm, '-', yyyy],
      );
      editBirthTimeController.text = searchKundliList[index].birthTime
          .toString();
      editBirthPlaceController.text = searchKundliList[index].birthPlace
          .toString();
      editDOB = searchKundliList[index].birthDate;
      update();
      genderChoose(searchKundliList[index].gender);
    } catch (e) {
      print('Exception in getKundliList():' + e.toString());
    }
  }

  String? userName;
  getName(String text) {
    userName = text;
    update();
  }

  getselectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  getSelectedTime(DateTime date) {
    selectedTime = DateFormat.Hm().format(date);
    update();
  }

  addKundliData(String pdfType, int amount) async {
    List<KundliModel> kundliModel = [
      KundliModel(
        name: userName!,
        gender: selectedGender!,
        birthDate: selectedDate ?? DateTime(1996),
        birthTime: isTimeOfBirthKnow
            ? DateFormat('HH:mm').format(DateTime(2020, 1, 1, 12, 0))
            : selectedTime ?? DateFormat.jm().format(DateTime.now()),
        birthPlace: birthKundliPlaceController.text,
        latitude: lat,
        longitude: long,
        timezone: timeZone ?? 5.3,
        pdf_type: pdfType,
        forMatch: 0,
        lang: dropDownController.kundaliLang.toString() == "English"
            ? 'en'
            : (dropDownController.kundaliLang.toString() == "Tamil"
                  ? 'ta'
                  : (dropDownController.kundaliLang.toString() == "Kannada"
                        ? 'ka'
                        : (dropDownController.kundaliLang.toString() == "Telugu"
                              ? 'te'
                              : (dropDownController.kundaliLang.toString() ==
                                        "hindi"
                                    ? 'hi'
                                    : (dropDownController.kundaliLang
                                                  .toString() ==
                                              "Malayalam"
                                          ? 'ml'
                                          : (dropDownController.kundaliLang
                                                        .toString() ==
                                                    "Spanish"
                                                ? 'sp'
                                                : (dropDownController
                                                              .kundaliLang
                                                              .toString() ==
                                                          "French"
                                                      ? 'fr'
                                                      : 'en'))))))),
      ),
    ];
    print("languageselect");
    print("${dropDownController.kundaliLang.toString()}");
    update();

    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.addKundli(kundliModel, amount, false).then((result) {
          if (result.status == "200") {
            print('success');
          } else {
            global.showToast(
              message: 'Failed to create kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  getGeoCodingLatLong({
    double? latitude,
    double? longitude,
    int? flagId,
    KundliMatchingController? kundliMatchingController,
  }) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getTimezonOffline(lat: latitude, long: longitude)
              .then((result) {
                double offset = double.parse(result['rawOffset'].toString());
                log('GMT offset--->$offset');
                if (flagId == 1) {
                  kundliMatchingController!.boyTimezone = offset;
                } else if (flagId == 2) {
                  kundliMatchingController!.girlTimezone = offset;
                } else {
                  timeZone = offset;
                }

                // if (flagId == 1) {
                //   kundliMatchingController!.boyTimezone =
                //       double.parse(result.recordList['timezone'].toString());
                //   kundliMatchingController.update();
                // } else if (flagId == 2) {
                //   kundliMatchingController!.girlTimezone =
                //       double.parse(result.recordList['timezone'].toString());
                //   kundliMatchingController.update();
                // } else {
                //   timeZone =
                //       double.parse(result.recordList['timezone'].toString());
                // }

                update();
              });
        }
      });
    } catch (e) {
      print('Exception in getGeoCodingLatLong():' + e.toString());
    }
  }

  DateTime? pickedDate;
  updateKundliData(int id) async {
    Duration offset = DateTime.now().timeZoneOffset;
    String formatedtimeZone =
        '${offset.inHours.abs().toString()}.${(offset.inMinutes % 60).obs.toString()}';
    KundliModel kundliModel = KundliModel(
      name: editNameController.text,
      gender: dropDownGender!,
      birthDate: pickedDate ?? editDOB,
      birthTime: editBirthTimeController.text,
      birthPlace: editBirthPlaceController.text,
      latitude: lat,
      longitude: long,
      timezone: formatedtimeZone,
    );
    update();
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.updateKundli(id, kundliModel).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Your kundli has been updated',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: 'Failed to update kundli please try again later!',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  deleteKundli(int id) async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.deleteKundli(id).then((result) {
          if (result.status == "200") {
            global.showToast(
              message: 'Deleted Successfully',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            global.showToast(
              message: 'Deleted Fail',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  searchKundli(String kundliName) {
    List<KundliModel> result = [];
    if (kundliName.isEmpty) {
      result = kundliList;
    } else {
      result = kundliList
          .where(
            (element) => element.name.toString().toLowerCase().contains(
              kundliName.toLowerCase(),
            ),
          )
          .toList();
    }
    searchKundliList = result;
    if (searchKundliList.isEmpty) {
      emptyScreenText = "Search result not found";
    }
    update();
  }

  getBasicDetail({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getKundliBasicDetails(
                day: day,
                month: month,
                year: year,
                hour: hour,
                min: min,
                lat: lat,
                lon: lon,
                tzone: tzone,
              )
              .then((result) {
                if (result != null) {
                  Map<String, dynamic> map = result;
                  kundliBasicDetail = KundliBasicDetail.fromJson(map);
                  update();
                } else {
                  global.showToast(
                    message: 'Fail to getKundliBasicDetails ',
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                }
                update();
              });
        }
      });
    } catch (e) {
      print('Exception in getBasicDetail():' + e.toString());
    }
  }

  getBasicPanchangDetail({
    int? day,
    int? month,
    int? year,
    int? hour,
    int? min,
    double? lat,
    double? lon,
    double? tzone,
  }) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getKundliBasicPanchangDetails(
                day: day,
                month: month,
                year: year,
                hour: hour,
                min: min,
                lat: lat,
                lon: lon,
                tzone: tzone,
              )
              .then((result) {
                if (result != null) {
                  Map<String, dynamic> map = result;
                  kundliBasicPanchangDetail =
                      KundliBasicPanchangDetail.fromJson(map);
                  update();
                } else {
                  global.showToast(
                    message: 'Fail to getKundliBasicPanchangDetails',
                    textColor: global.textColor,
                    bgColor: global.toastBackGoundColor,
                  );
                }
                update();
              });
        }
      });
    } catch (e) {
      print('Exception in getBasicPanchangDetail():' + e.toString());
    }
  }
}
