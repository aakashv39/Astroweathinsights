import 'package:AstrowayCustomer/model/astrologerCategoryModel.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class AstrologerCategoryController extends GetxController {
  APIHelper apiHelper = APIHelper();

  var categoryList = <AstrologerCategoryModel>[];
  @override
  void onInit() {
    _inIt();
    super.onInit();
  }

  _inIt() async {
    print("insideastrologycat");
    Future.microtask(() {
      getAstrologerCategorys();
    });
  }

  getAstrologerCategorys() async {
    try {
      apiHelper.getAstrologerCategory().then((result) {
  
        if (result.status == "200") {
          categoryList = result.recordList;
          print("category reult:- ${categoryList}");
          print("${categoryList[0].astrologers![0].name}");
          update();
        } else {
          global.showToast(
            message: 'Failed to get Category',
            textColor: global.textColor,
            bgColor: global.toastBackGoundColor,
          );
        }
        update();
      });
    } catch (e) {
      print('Exception in getAstrologerCategory():' + e.toString());
    }
  }
}
