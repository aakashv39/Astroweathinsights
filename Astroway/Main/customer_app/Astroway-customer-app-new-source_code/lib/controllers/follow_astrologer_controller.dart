import 'dart:developer';

import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/model/astrologer_model.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/services/api_helper.dart';
import 'package:agora_rtm/agora_rtm.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../model/remote_host_model.dart';

class FollowAstrologerController extends GetxController {
  APIHelper apiHelper = APIHelper();
  var followedAstrologer = <AstrologerModel>[];
  List<RemoteHostModel> remoteIds = [];
  ScrollController scrollController = ScrollController();
  int fetchRecord = 20;
  int startIndex = 0;
  bool isDataLoaded = false;
  bool isAllDataLoaded = false;
  bool isMoreDataAvailable = false;
  onInit() {
    _init();
    super.onInit();
  }

  _init() async {
    paginateTask();
  }

  void paginateTask() {
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !isAllDataLoaded) {
        isMoreDataAvailable = true;
        print('scroll my following');
        update();
        await getFollowedAstrologerList(true);
      }
    });
  }

  getRemoteId(int astroId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.getRemoteId(astroId).then((result) {
            if (result.status == "200") {
              remoteIds = result.recordList;
              update();
            } else {
              remoteIds = [];
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getFollowedAstrologerList :-" + e.toString());
    }
  }

  bool isFollowed = false;
  addFollowers(int astrologerId) async {
    try {
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper.followAstrologer(astrologerId).then((result) {
            if (result.status == "200") {
              global.showToast(
                message:
                    'You will be recived notifed when Astrologer is online and live !',
                textColor: global.textColor,
                bgColor: global.toastBackGoundColor,
              );
              isFollowed = true;
              update();
              BottomNavigationController bottomNavigationController =
                  Get.find<BottomNavigationController>();
              bottomNavigationController.getAstrologerbyId(astrologerId);
            } else {
              if (global.currentUserId != null) {
                global.showToast(
                  message: 'Astrologer not followed please try again later',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              } else {
                global.showToast(
                  message: 'You have to login to follow astrologer',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print("Exception in updateUserProfile:-" + e.toString());
    }
  }

  unFollowAstrologer(int astrologerId) async {
    await global.checkBody().then((result) async {
      if (result) {
        await apiHelper.unFollowAstrologer(astrologerId).then((result) async {
          if (result.status == "200") {
            log('unfollowed successed');
            followedAstrologer.clear();
            isAllDataLoaded = false;
            update();
            await getFollowedAstrologerList(false);
          } else {
            global.showToast(
              message: 'Unfollow failed please try again later',
              textColor: global.textColor,
              bgColor: global.toastBackGoundColor,
            );
          }
        });
      }
    });
  }

  getFollowedAstrologerList(bool isLazyLoading) async {
    try {
      startIndex = 0;
      if (followedAstrologer.isNotEmpty) {
        startIndex = followedAstrologer.length;
      }
      if (!isLazyLoading) {
        isDataLoaded = false;
      }
      await global.checkBody().then((result) async {
        if (result) {
          await apiHelper
              .getFollowedAstrologer(startIndex, fetchRecord)
              .then((result) async {
            if (result.status == "200") {
              followedAstrologer.addAll(result.recordList);
              print(
                  'follow astrologer list length ${followedAstrologer.length} ');
              if (result.recordList.length == 0) {
                isMoreDataAvailable = false;
                isAllDataLoaded = true;
              }
              update();
            } else {
              bool isLogin = await global.isLogin();
              if (isLogin) {
                global.showToast(
                  message: 'Failed to get follower',
                  textColor: global.textColor,
                  bgColor: global.toastBackGoundColor,
                );
              }
            }
          });
        }
      });
    } catch (e) {
      print("Exception in getFollowedAstrologerList :-" + e.toString());
    }
  }

  ValueNotifier<int> viewer = ValueNotifier<int>(0);
  getOnlineUserList(String channelName, RtmClient client) async {
    try {
      var (status, response) = await client.getPresence().getOnlineUsers(
            channelName,
            RtmChannelType.message,
            includeUserId: true,
            includeState: true,
          );

      // ignore: unrelated_type_equality_checks
      if (status.error == true) {
        log(
          '${status.operation} failed, errorCode: ${status.errorCode}, due to ${status.reason}',
        );
      } else {
        // var nextPage = response!.nextPage;
        var count = response!.count;
        viewer.value = count;
        log('There are $count occupants in $channelName channel');
      }
    } catch (e) {
      log('something went wrong: $e');
    }
  }
}
