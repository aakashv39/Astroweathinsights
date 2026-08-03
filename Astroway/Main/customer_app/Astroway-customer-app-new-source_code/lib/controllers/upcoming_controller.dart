import 'package:AstrowayCustomer/model/astrologer_model.dart';
import 'package:AstrowayCustomer/model/availableTimes_model.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:intl/intl.dart';

import '../model/upcommingModel.dart';

class UpcomingController extends GetxController {
  APIHelper apiHelper = APIHelper();
   var upComingList = <UpcommingListModel>[];
  var searchUpComing = <AstrologerModel>[];
  @override
  void onInit() {
    _inIt();
    super.onInit();
  }
  _inIt() async {
    getUpcomming();
  }


  getUpcomming() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getUpcomingList().then((result) {
            print("${result.status}");
            print("${result.recordList}");
            if (result.status == "200") {
              print("upComingList:- ${result.recordList}");
              upComingList=result.recordList;
              update();

            } else {
              print("Live upcomming screen ${result.status}");
              // global.showToast(
              //   message: 'failed to get event',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getUpcomming():-  $e' + e.toString());
    }
  }

  getSearchResult(String searchString) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.liveEventSearch(searchString).then((result) {
            if (result.status == "200") {
              searchUpComing = result.recordList;
              update();
              if (searchUpComing.isNotEmpty) {
                String todayDay = DateFormat("EEEE").format(DateTime.now());
                for (var i = 0; i < searchUpComing.length; i++) {
                  if (searchUpComing[i].availability!.isNotEmpty) {
                    List<AvailableTimes>? times = [];
                    times = searchUpComing[i].availability!.firstWhere((element) => element.day == todayDay).time;
                    if (times!.isNotEmpty) {
                      searchUpComing[i].isTimeSlotAvailable = true;
                      searchUpComing[i].availableTimes = times;
                    } else {
                      searchUpComing[i].isTimeSlotAvailable = false;
                    }
                  } else {
                    searchUpComing[i].isTimeSlotAvailable = false;
                  }
                }
                update();
              }
            } else {
              global.showToast(
                message: 'failed to search event',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getSearchResult() upcoming: $e' + e.toString());
    }
  }

  remindMe(String astroId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.remindMeLiveAstrologer(astroId).then((result) {
            print("${result.status}");
            print("${result.recordList}");
            if (result.status == "200") {
            } else {
              // print("Live upcomming screen ${result.status}");
              // global.showToast(
              //   message: 'failed to get event',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getUpcomming():-  $e' + e.toString());
    }
  }
}
