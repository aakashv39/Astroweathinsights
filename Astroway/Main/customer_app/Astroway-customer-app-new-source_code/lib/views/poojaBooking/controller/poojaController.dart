import 'dart:developer';

import 'package:AstrowayCustomer/views/poojaBooking/model/faqmodel.dart';
import 'package:AstrowayCustomer/views/poojaBooking/model/poojalistmodel.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

import '../../../model/PujaCategoriesListModel.dart';
import '../../../model/custompujamodel.dart';
import '../../../utils/services/api_helper.dart';

class PoojaController extends GetxController {
  APIHelper apiHelper = new APIHelper();
  List<PoojaList>? poojalist;
  List<PujaCategoriesListModel>? poojaCatglist;
  List<FaqList>? faqList;
  bool isLoading = false;
  final List<Map<String, String>> pujaprocessItems = [
    {"title": "Select Puja", "description": "Choose from puja packages."},
    {
      "title": "Add Offerings",
      "description":
          "Enhance your puja experience with optional offerings like Gau Seva, Deep Daan, Vastra Daan, and Anna Daan."
    },
    {
      "title": "Provide Sankalp Details",
      "description": "Enter your Name and Gotra for the Sankalp."
    },
    {
      "title": "Puja Day Updates",
      "description":
          "Our experienced pandits perform the sacred puja. All Sri Mandir devotees' pujas will be conducted collectively on the day of the puja. You will receive real-time updates of the puja on your registered WhatsApp number."
    },
    {
      "title": "Puja Video & Ganga Jal",
      "description":
          "Receive the video of the puja on your WhatsApp number within 3-4 days and receive Ganga Jal as a blessing of Pitru Puja within 8-10 days."
    },
  ];
  List<CustomPujaModel>? custompoojalist;

  getPoojaCategoriesList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isLoading = true;
          update();
          await apiHelper.getPujaCategory().then((result) {
            if (result.status == "200") {
              poojaCatglist = result.recordList;
              log("poojaCatglist ${poojaCatglist?.length}");
              isLoading = false;
              update();
            } else {
              log('FAil to get getPujaCategory');
              isLoading = false;
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getPujaCategory():' + e.toString());
    }
  }

  //delete puja
  deletePooja(dynamic pujaId) async {
    await global.checkBody().then((result) async {
      if (result) {
        isLoading = true;
        update();
        log('delete id ${pujaId}');

        await apiHelper.deletePoojaApi(pujaId).then((result) {
          if (result.status == "200") {
            isLoading = false;
            // update();

            getCustomPujaList();
            update();
            global.showToast(
              message: 'Puja deleted successfully',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          } else {
            isLoading = false;
            update();
            global.showToast(
              message: 'Failed to delete Puja',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  getCustomPujaList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isLoading = true;
          update();
          await apiHelper.getCustompujaApi().then((result) {
            if (result.status == "200") {
              custompoojalist = result.recordList;
              log("custompoojalist ${custompoojalist?.length}");
              isLoading = false;
              update();
            } else {
              log('FAil to get CustomPujaList');
              isLoading = false;
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getCustomPujaList():' + e.toString());
    }
  }

  getPoojaList(String catid) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isLoading = true;
          update();
          await apiHelper.getpuja(catid).then((result) {
            if (result.status == "200") {
              poojalist = result.recordList;
              log("poojalist ${poojalist?.length}");
              isLoading = false;
              update();
            } else {
              log('FAil to get PoojaLis');

              // global.showToast(
              //   message: 'FAil to get PoojaList',
              //   textColor: global.textColor,
              //   bgColor: global.toastBackGoundColor,
              // );
              isLoading = false;
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in getpoojaList():' + e.toString());
    }
  }

  getfaqlist() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          isLoading = true;
          update();
          await apiHelper.getfaq().then((result) {
            if (result.status == "200") {
              faqList = result.recordList;
              // log("poojalist ${poojalist?.length}");
              // log("poojalist 2 ${poojalist?[0].pujaTitle}");
              isLoading = false;

              update();
            } else {
              global.showToast(
                message: 'FAil to get PoojaList',
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
      print('Exception in getFaqList():' + e.toString());
    }
  }
}
