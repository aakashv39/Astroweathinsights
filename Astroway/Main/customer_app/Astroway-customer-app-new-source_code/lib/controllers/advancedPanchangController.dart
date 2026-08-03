import 'package:AstrowayCustomer/controllers/astromallController.dart';
import 'package:AstrowayCustomer/model/advancedPanchangModel.dart';
import 'package:AstrowayCustomer/model/vedicApis/vedicPanchangModel.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl/intl.dart';

class PanchangController extends GetxController {
  APIHelper apiHelper = APIHelper();
  PanchangModel? panchangList;
  VedicPanchangModel? vedicPanchangModel;
  String? ipadddress;
  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  DateTime now = DateTime.now();
  late String formattedDate = DateFormat('MMM d, EEEE').format(now);

  final AstromallController astromallController =
      Get.find<AstromallController>();
  _inIt() async {
    ipadddress = await apiHelper.getPublicIPAddress();

    getPanchangVedic(DateTime.now(), ipadddress);
    astromallController.getAstromallCategory(false);
    print("nextDay");
    print("${DateTime.now().add(Duration(days: -1))}");
  }

  getPanchangDetail(
      {int? day,
      int? month,
      int? year,
      int? hour,
      int? min,
      double? lat,
      double? lon,
      double? tzone}) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getAdvancedPanchang(
                  day: day,
                  month: month,
                  year: year,
                  hour: hour,
                  min: min,
                  lat: lat,
                  lon: lon,
                  tzone: tzone)
              .then((result) {
            if (result.status == "200") {
              Map<String, dynamic> map = result;
              panchangList = PanchangModel.fromJson(map);
              update();
            } else {
              global.showToast(
                message: 'Failed to get Panchang',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
            update();
          });
        }
      });
    } catch (e) {
      global.showToast(
        message: 'Failed to get Panchang Details Login First',
        textColor: global.textColor,
        bgColor: global.toastBackGoundColor,
      );
      print('Exception in getPanchangDetail():' + e.toString());
    }
  }

  getPanchangVedic(DateTime date, dynamic ipadddress,
      {bool isloadingshowing = false}) async {
    isloadingshowing ? global.showOnlyLoaderDialog(Get.context) : null;
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getPanchangVedic(ipadddress, date.toString().split(" ").first)
              .then((result) {
            isloadingshowing ? global.hideLoader() : null;
            if (result['status'].toString() == "200") {
              Map<String, dynamic> map = result;
              vedicPanchangModel = VedicPanchangModel.fromJson(map);
              update();
            } else {
              // log('Failed to get Panchang');
              // global.showToast(
              //   message: 'Failed to get Panchang',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getPanchangDetailVedic():' + e.toString());
    }
  }

  int commondate = 0;
  nextDate(bool nextDay) async {
    nextDay ? commondate++ : commondate--;
    update();
    nextDay
        ? getPanchangVedic(
            DateTime.now().add(Duration(days: commondate)), ipadddress,
            isloadingshowing: true)
        : getPanchangVedic(
            DateTime.now().add(Duration(days: commondate)), ipadddress,
            isloadingshowing: true);
  }
}
