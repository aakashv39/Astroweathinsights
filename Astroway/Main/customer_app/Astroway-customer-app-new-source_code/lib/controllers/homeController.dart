import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/model/Allstories.dart';
import 'package:AstrowayCustomer/model/app_review_model.dart';
import 'package:AstrowayCustomer/model/home_Model.dart';
import 'package:AstrowayCustomer/model/viewStories.dart';
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:AstrowayCustomer/widget/freebackGreetings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' as material;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../model/RecommendedPujaListModel.dart';
import '../model/language.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../model/rec_model.dart';

class HomeController extends GetxController {
  int cIndex = 0;

  List<Language> lan = [];
  APIHelper apiHelper = APIHelper();
  var bannerList = <Banners>[];
  var blogList = <Blog>[];
  var astroNews = <AstrotalkInNews>[];
  var astrologyVideo = <AstrologyVideo>[];
  var clientReviews = <AppReviewModel>[];
  var viewSingleStory = <ViewStories>[];
  var allStories = <AllStories>[];
  FocusNode feedbackFocusNode = FocusNode();
  var myOrders = <TopOrder>[];
  final material.TextEditingController feedbackController =
      material.TextEditingController();
  final splashController = Get.find<SplashController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  material.PageController pageController = material.PageController().obs();
  int reviewChange = 0.obs();
  VideoPlayerController? videoPlayerController;
  VideoPlayerController? homeVideoPlayerController;
  YoutubePlayerController? youtubePlayerController;
  final List<String> languageImages = [
    'assets/images/languages/English.png',
    'assets/images/languages/Gujarti.png',
    'assets/images/languages/Hindi.png',
    'assets/images/languages/marati.png',
    'assets/images/languages/Bengli.png',
    'assets/images/languages/Kannada.png',
    'assets/images/languages/malayala.png',
    'assets/images/languages/Tamil.png',
    'assets/images/languages/Telugu.png',
  ];

  @override
  void onInit() async {
    _init();
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(
          '${global.getSystemFlagValueForLogin(global.systemFlagNameList.behindScenes)}'),
    )..initialize().then((_) {
        videoPlayerController!.pause();
        videoPlayerController!.setLooping(true);

        update();
      });

    super.onInit();
  }

  _init() async {
    try {
      await Future.wait<void>([
        getAllStories(),
        getBanner(),
        getBlog(),
        getAstroNews(),
        getMyOrder(),
        getAstrologyVideos(),
        getClientsTestimonals(),
        getrecomendedProductList(),
        getrecomendedPujaList(),
        // bottomNavigationController.getAstrologerListforcheckout(
        //     isLazyLoading: false),
        //     bottomNavigationController.getAstrologerList(
        //   isLazyLoading: false, isShuffle: true)
      ]);
    } catch (e) {
      print("Exception -Homecontroller init future.wait: $e");
    }
  }

  List<RecModel>? recomendedList;
  List<RecommendedPujaListModel>? pujarecomendedList;

  Future<void> gethistorydetails() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getallhistorydetail().then((result) {
            log('getallhistorydetail 1: ${result}');
            if (result.status == "200") {
              global.couponmycode = result!.recordList![0].referralToken;
              print("referal_code ${global.couponmycode}");
              update();
            }
          });
        }
      });
    } catch (e) {
      print('Exception in gethistorydetails():' + e.toString());
    }
  }

  Future<void> getrecomendedProductList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getRecommendedProductsApi().then((result) {
            print("getRecommendedProductsApi ${result.status}");
            print("recomendedList tyep is  ${result.recordList.runtimeType}");

            if (result.status == "200") {
              recomendedList = result.recordList;
              print(" recomendedList length -> ${recomendedList?.length}");
              update();
            } else {
              log("Failed to get Recommended Products");
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getrecomendedProductList():' + e.toString());
    }
  }

  Future<void> getrecomendedPujaList() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getRecommendedPujaApi().then((result) {
            print("getRecommendedPujaApi ${result.status}");
            print(
                "getRecommendedPujaApi tyep is  ${result.recordList.runtimeType}");

            if (result.status == "200") {
              pujarecomendedList = result.recordList;
              print(
                  "getRecommendedPujaApi length -> ${pujarecomendedList?.length}");
              update();
            } else {
              log("Failed to get getRecommendedPujaApi ");
            }
            update();
          });
        }
      });
    } catch (e) {
      print('Exception in getRecommendedPujaApi():' + e.toString());
    }
  }

  DateTime? currentBackPressTime;
  Future<bool> onBackPressed() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      global.showToast(
        message: 'Press again to exit',
        textColor: global.textColor,
        bgColor: global.toastBackGoundColor,
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  void playPauseVideo() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
      update();
    } else {
      videoPlayerController!.play();
      update();
    }
  }

  void blogplayPauseVideo(VideoPlayerController controller) {
    if (controller.value.isPlaying) {
      controller.pause();
      update();
    } else {
      controller.play();
      update();
    }
  }

  Future youtubPlay(String url) async {
    String? videoId;
    videoId = YoutubePlayer.convertUrlToId(url);
    youtubePlayerController = YoutubePlayerController(
        initialVideoId: '$videoId',
        flags: YoutubePlayerFlags(
          autoPlay: true,
          showLiveFullscreenButton: true,
        ));
    update();
  }

  homeBlogVideo(String link) {
    homeVideoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse('$link'),
    )..initialize().then((_) {
        homeVideoPlayerController!.pause();
        homeVideoPlayerController!.setLooping(true);
        update();
      });
  }

  int selectedIndex = 0;
  updateLan(int index) {
    selectedIndex = index;
    lan[index].isSelected = true;
    update();
    for (int i = 0; i < lan.length; i++) {
      if (i == index) {
        continue;
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    update();
  }

  Future<void> updateLanIndex() async {
    global.sp = await SharedPreferences.getInstance();
    var currentLan = global.sp!.getString('currentLanguage') ?? 'en';
    for (int i = 0; i < lan.length; i++) {
      if (lan[i].lanCode == currentLan) {
        selectedIndex = i;
        lan[i].isSelected = true;
        update();
      } else {
        lan[i].isSelected = false;
        update();
      }
    }
    print(selectedIndex);
  }

  bool checkBannerValid(
      {required DateTime startDate, required DateTime endDate}) {
    DateTime now = DateTime.now();
    // end date is after or today and sart date is before or today show add
    if (startDate.isBefore(now) && endDate.isAfter(now)) {
      return true;
    }
    return false;
  }

  Future<void> getBanner() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeBanner().then((result) {
            if (result.status == "200") {
              bannerList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get banner',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBanner:-" + e.toString());
    }
  }

  Future<void> getBlog() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeBlog().then((result) {
            if (result.status == "200") {
              blogList = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Blogs',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getBlog:-" + e.toString());
    }
  }

  Future<void> getAstroNews() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroNews().then((result) {
            if (result.status == "200") {
              astroNews = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get astro news',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstroNews:-" + e.toString());
    }
  }

  Future<void> getMyOrder() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getHomeOrder().then((result) {
            if (result.status == "200") {
              myOrders = result.recordList;
              update();
            }
          });
        }
      });
    } catch (e) {
      myOrders.clear();
      update();
      print("Exception in getMyOrder:-" + e.toString());
    }
  }

  Future<void> getAstrologyVideos() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroVideos().then((result) {
            if (result.status == "200") {
              astrologyVideo = result.recordList;
              update();
            } else {
              global.showToast(
                message: 'Failed to get Astrology video',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstrologyVideos:-" + e.toString());
    }
  }

  Future<void> getClientsTestimonals() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAppReview().then((result) {
            if (result.status == "200") {
              clientReviews = result.recordList;
              update();
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getClientsTestimonals:-" + e.toString());
    }
  }

  incrementBlogViewer(int id) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.viewerCount(id).then((result) {
            if (result.status == "200") {
              print('success');
            } else {
              global.showToast(
                message: 'Faild to increment blog viewer',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in incrementBlogViewer:- " + e.toString());
    }
  }

  addFeedback(String review) async {
    var appReviewModel = {
      "appId": global.appId,
      "review": review,
    };
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.addAppFeedback(appReviewModel).then((result) {
            if (result.status == "200") {
              feedbackController.clear();
              Get.to(() => FreeBackGreetings());
            } else {
              global.showToast(
                message: 'Failed to add feedback',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in addFeedback():- " + e.toString());
    }
  }

  Future<void> getLanguages() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          global.showOnlyLoaderDialog(Get.context);
          await apiHelper.getLanguagesForMultiLanguage().then((result) {
            global.hideLoader();
            if (result.status == "200") {
              lan.addAll(result.recordList);
              update();
            } else {
              global.showToast(
                message: 'Failed to get language!',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getLanguages():- " + e.toString());
    }
  }

  Future<void> getAllStories() async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAllStory().then((result) {
            if (result.status == "200") {
              allStories = result.recordList;
              update();
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAllStories:-" + e.toString());
    }
  }

  Future<void> getAstroStory(String astroId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getAstroStory(astroId).then((result) {
            if (result.status == "200") {
              viewSingleStory = result.recordList;
              update();
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  getAstroStory:-" + e.toString());
    }
  }

  Future<void> viewStory(String storyId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.storyViewed(storyId).then((result) {
            if (result.status == "200") {
              update();
            }
          });
        }
      });
    } catch (e) {
      print("Exception in  viewStory:-" + e.toString());
    }
  }
}
