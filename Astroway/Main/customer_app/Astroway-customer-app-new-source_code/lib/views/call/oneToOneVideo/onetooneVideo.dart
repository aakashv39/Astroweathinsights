// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:AstrowayCustomer/views/call/oneToOneVideo/videocallSession.dart';
import 'package:AstrowayCustomer/views/chat/endDialog.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:draggable_widget/draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controllers/splashController.dart';
import '../../../utils/foregroundTaskHandler.dart';
import '../../bottomNavigationBarScreen.dart';
import 'AgoraEventHandler.dart';
import 'Agrommanager.dart';
import 'cohost_screen.dart';
import 'host_screen.dart';

class OneToOneLiveScreen extends StatefulWidget {
  final String channelname;
  final int callId;
  final String fcmToken;
  String end_time;
  bool rejoin;
  OneToOneLiveScreen({
    super.key,
    required this.channelname,
    required this.callId,
    required this.fcmToken,
    required this.end_time,
    this.rejoin = false,
  });
  @override
  State<OneToOneLiveScreen> createState() => OneToOneLiveScreenState();
}

class OneToOneLiveScreenState extends State<OneToOneLiveScreen>
    with WidgetsBindingObserver {
  late RtcEngine agoraEngine; // Agora engine instance
  int conneId = 0;
  late AgoraEventHandler agoraEventHandler;
  ValueNotifier<bool> isMuted = ValueNotifier(false);
  ValueNotifier<bool> isImHost = ValueNotifier(false);
  final dragController = DragController();
  ValueNotifier<bool> isJoined = ValueNotifier(false);
  ValueNotifier<int?> remoteUid = ValueNotifier(null);
  var uid = 0;
  ValueNotifier<bool> isSpeaker = ValueNotifier(true);
  final historyController = Get.find<HistoryController>();
  final _callController = Get.find<CallController>();
  Timer? timer;
  bool isStart = false;
  final bottomNavigationController = Get.find<BottomNavigationController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    global.isCallOrChat = 3;
    global.VideocallStartedAt = DateTime.now().millisecondsSinceEpoch;
    DateTime actualStartTime =
        DateTime.fromMillisecondsSinceEpoch(global.VideocallStartedAt!);
    log('Chat started at: onetoone $actualStartTime');
    print("new duration:- ${widget.end_time.toString()}");
    endTime = DateTime.now().millisecondsSinceEpoch +
        1000 * int.parse(widget.end_time.toString());
    global.isEndCallApiCalled = false;
    if (!widget.rejoin) {
      ForegroundServiceManager.startForegroundTask();
      initagora();
      // global.isEndCallApiCalled = false;
      timer = Timer.periodic(Duration(seconds: 2), (timer) async {
        print('timer call from setup agora in video');
        if (!isStart) {
          setState(() {
            isStart = true;
          });
          await _callController.getAgoraResourceId(
            widget.channelname,
            int.parse(global.myVideoRecordingUid),
          );
        }
      });
    }
    if (widget.rejoin) {
      isJoined = ValueNotifier(true);
      isImHost = ValueNotifier(true);
      remoteUid =
          _callController.videoCallactiveSessions.values.first.remoteUid;
      agoraEngine =
          _callController.videoCallactiveSessions.values.first.agoraEngine;
      isMuted = _callController.videoCallactiveSessions.values.first.isMuted;
      isSpeaker =
          _callController.videoCallactiveSessions.values.first.isSpeaker;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      debugPrint("✅ App is in foreground");
    } else if (state == AppLifecycleState.paused) {
      debugPrint("⏸️ App is in background");
    } else if (state == AppLifecycleState.detached) {
      debugPrint("❌ App is terminated / detached");
      // await leave("form app kill");
      agoraEngine.leaveChannel();
      agoraEngine.release(sync: true);
      agoraEngine.disableAudio();

      global.sp?.setBool("isformKill", true);
      global.sp?.setInt("callId", widget.callId.toInt());
      global.sp?.setString("agorasid1", global.agoraSid1);
      global.sp?.setString("agorasid2", global.agoraSid2);
      global.sp?.setInt("calltime", _callController.totalSeconds);

      // final isFromKill = global.sp?.getBool("isformKill") ?? false;
      // final callId = global.sp?.getInt("callId") ?? 0;
      // final agoraSid1 = global.sp?.getString("agorasid1") ?? '';
      // final agoraSid2 = global.sp?.getString("agorasid2") ?? '';
      // final callTime = global.sp?.getInt("calltime") ?? 0;

      debugPrint("Called from leave detached");
    } else if (state == AppLifecycleState.inactive) {
      global.sp?.setBool("isformKill", true);
      global.sp?.setInt("callId", widget.callId.toInt());
      global.sp?.setString("agorasid1", global.agoraSid1);
      global.sp?.setString("agorasid2", global.agoraSid2);
      global.sp?.setInt("calltime", _callController.totalSeconds);

      final isFromKill = global.sp?.getBool("isformKill") ?? false;
      final callId = global.sp?.getInt("callId") ?? 0;
      final agoraSid1 = global.sp?.getString("agorasid1") ?? '';
      final agoraSid2 = global.sp?.getString("agorasid2") ?? '';
      final callTime = global.sp?.getInt("calltime") ?? 0;

      // Print all values
      print("═══════════════════════════════════");
      print("📦 Stored Call Data from video:");
      print("═══════════════════════════════════");
      print("🔴 isFromKill: $isFromKill");
      print("📞 Call ID: $callId");
      print("🎙️ Agora SID 1: $agoraSid1");
      print("🎙️ Agora SID 2: $agoraSid2");
      print("⏱️ Call Time (seconds): $callTime");
      print("═══════════════════════════════════");
      debugPrint("⚠️ App is inactive (e.g. during call or split screen)");
    }
  }

  disconnectCall() {
    ForegroundServiceManager.stopForegroundTask();

    AgoraManager().leave(
      agoraEngine,
      onchannelLeaveCallback: (isLiveEnded) async {
        debugPrint("Video Leave - 1");
        if (isLiveEnded) {
          if (timer2 != null) {
            timer2?.cancel();
            timer2 = null;
          }
          Future.wait<void>([
            global.isEndCallApiCalled == true
                ? null
                : await _callController.endCall(
                    widget.callId,
                    _callController.totalSeconds,
                    global.agoraSid1,
                    global.agoraSid2,
                  ),
            await Get.find<SplashController>().getCurrentUserData(),
          ]);

          bottomNavigationController.setIndex(0, 0);
        } else {
          log('live not ended');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool) async {
        if (global.isEndCallApiCalled == false) {
          final session = Videocallsession(
              sessionId: widget.callId.toString(),
              callId: widget.callId,
              channelname: widget.channelname,
              fcmToken: widget.fcmToken,
              end_time: widget.end_time,
              savedAt: global.VideocallStartedAt,
              remoteUid: ValueNotifier(remoteUid.value),
              agoraEngine: agoraEngine,
              isMuted: isMuted,
              isSpeaker: isSpeaker);
          log('save and backrpess 0');
          Get.find<CallController>().addVideoCallSession(session); //add session
          // Get.back();

          BottomNavigationController bottomNavigationController =
              Get.find<BottomNavigationController>();
          bottomNavigationController.setIndex(0, 0);
          Get.to(() => BottomNavigationBarScreen(
                index: 0,
              ));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ValueListenableBuilder(
          valueListenable: isJoined,
          builder: (BuildContext context, bool isJoin, Widget? child) =>
              ValueListenableBuilder(
            valueListenable: isImHost,
            builder: (BuildContext context, bool meHost, Widget? child) =>
                Stack(
              alignment: Alignment.bottomCenter,
              children: [
                //BOTTOM BAR MUTE CALL DISCONNECT SPEAKER
                SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //IS USER JOINED LAYOUT
                      isJoin
                          ? SizedBox(
                              width: double.infinity,
                              height: 100.h,
                              child: CoHostWidget(
                                remoteUid: remoteUid.value,
                                agoraEngine: agoraEngine,
                                channelId: widget.channelname,
                              ),
                              //CO-HOST VIDEO
                            )
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Colors.amberAccent,
                              ),
                            ),
                    ],
                  ),
                ),
                //IS IM HOST YES
                meHost
                    ? DraggableWidget(
                        bottomMargin: 10.h,
                        topMargin: 10.h,
                        intialVisibility: true,
                        horizontalSpace: 5.h,
                        shadowBorderRadius: 10.h,
                        initialPosition: AnchoringPosition.topLeft,
                        dragController: dragController,
                        child: SizedBox(
                          height: 25.h,
                          width: 35.w,
                          //HOST CHILD
                          child: HostWidget(agoraEngine: agoraEngine),
                        ),
                      )
                    : Center(child: Text('Joining...')),

                Positioned(
                  top: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    child: status(),
                  ),
                ),

                SizedBox(
                  height: 20.h,
                  width: 100.w,
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 10.h,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                isMuted.value = !isMuted.value;
                                AgoraManager().muteVideoCall(
                                  isMuted.value,
                                  agoraEngine,
                                );
                              },
                              child: ValueListenableBuilder(
                                valueListenable: isMuted,
                                builder: (
                                  BuildContext context,
                                  bool meMuted,
                                  Widget? child,
                                ) =>
                                    CircleAvatar(
                                  radius: 3.h,
                                  backgroundColor:
                                      meMuted ? Colors.black12 : Colors.black38,
                                  child: FaIcon(
                                    meMuted
                                        ? FontAwesomeIcons.microphoneSlash
                                        : FontAwesomeIcons.microphone,
                                    color: meMuted ? Colors.blue : Colors.white,
                                    size: 15.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 2.h),
                          child: SizedBox(
                            height: 10.h,
                            child: InkWell(
                              onTap: () {
                                _callController.isLiveRunnning = false;
                                _callController.update();
                                if (_callController.totalSeconds < 60 &&
                                    remoteUid.value != null) {
                                  Get.dialog(EndDialog());
                                } else {
                                  ForegroundServiceManager.stopForegroundTask();

                                  AgoraManager().leave(
                                    agoraEngine,
                                    onchannelLeaveCallback:
                                        (isLiveEnded) async {
                                      debugPrint("Video Leave - 2");
                                      if (isLiveEnded) {
                                        global.showOnlyLoaderDialog(
                                          context,
                                        );
                                        if (timer2 != null) {
                                          timer2?.cancel();
                                          timer2 = null;
                                          timer!.cancel();
                                        }

                                        Future.wait<void>([
                                          global.isEndCallApiCalled == true
                                              ? null
                                              : await _callController.endCall(
                                                  widget.callId,
                                                  _callController.totalSeconds,
                                                  global.agoraSid1,
                                                  global.agoraSid2,
                                                ),
                                        ]);
                                        await Get.find<SplashController>()
                                            .getCurrentUserData();
                                        bottomNavigationController.setIndex(
                                            0, 0);
                                        global.isCallOrChat = 0;
                                        _callController.removeVideoCallSession(
                                            widget.callId.toString());
                                        //disconnectCall();
                                        global.hideLoader();
                                        Get.back();
                                        Get.back();
                                        Get.to(
                                          () => BottomNavigationBarScreen(
                                            index: 0,
                                          ),
                                        );
                                      } else {
                                        log('live not ended');
                                      }
                                    },
                                  );
                                }
                              },
                              child: Center(
                                child: CircleAvatar(
                                  radius: 4.h,
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    Icons.call_end,
                                    color: Colors.white,
                                    size: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 10.h,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 2.h),
                              child: InkWell(
                                onTap: () {
                                  isSpeaker.value = !isSpeaker.value;
                                  AgoraManager().onVolume(
                                    isSpeaker.value,
                                    agoraEngine,
                                  );
                                },
                                child: ValueListenableBuilder(
                                  valueListenable: isSpeaker,
                                  builder: (
                                    BuildContext context,
                                    bool meSpeaker,
                                    Widget? child,
                                  ) =>
                                      CircleAvatar(
                                    radius: 3.h,
                                    backgroundColor: meSpeaker
                                        ? Colors.black12
                                        : Colors.black38,
                                    child: Icon(
                                      meSpeaker
                                          ? FontAwesomeIcons.volumeHigh
                                          : FontAwesomeIcons.volumeLow,
                                      color: meSpeaker
                                          ? Colors.blue
                                          : Colors.white,
                                      size: 20.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handler() {
    agoraEventHandler.handleEvent(agoraEngine);
  }

  Timer? timer2;

  void initagora() async {
    //FIRST GENERATE TOKEN THEN USE IT FOR VIDEO
    agoraEngine = await AgoraManager().initializeAgora(
      global.getSystemFlagValue(global.systemFlagNameList.agoraAppId),
    );
    AgoraManager().joinChannel(
      widget.fcmToken,
      widget.channelname,
      agoraEngine,
    );
    agoraEventHandler = AgoraEventHandler(
      onJoinChannelSuccessCallback: (isHost, localUid) {
        print("onJoinChannelSuccessCallback");
        isImHost.value = isHost;
        conneId = localUid!;
        setState(() {});
        log('Local ID-> $conneId');
      },
      onUserJoinedCallback: (remoteId, isJoin) async {
        print("onUserJoinedCallback");
        isJoined.value = isJoin!;
        remoteUid.value = remoteId;
        endTime = DateTime.now().millisecondsSinceEpoch +
            1000 * int.parse(widget.end_time);
        _callController.totalSeconds = 0;
        _callController.update();
        timer2 = Timer.periodic(Duration(seconds: 1), (timer) async {
          _callController.totalSeconds = _callController.totalSeconds + 1;
          _callController.update();
          print('totalsecons ${_callController.totalSeconds}');
        });
        _callController.isLeaveCall = false;
        _callController.update();
      },
      onUserMutedCallback: (remoteUid3, muted) {
        print("onUserMutedCallback");
        log('Is muted->  $muted');
        if (remoteUid.value == remoteUid3) {
          if (muted == true) {
            isImHost.value = true;
            log('isimHost in onUserMuteVideo muted $isImHost');
          } else {
            isImHost.value = true;
            log('isimHost in onUserMuteVideo mutede else $isImHost');
          }
        }
      },
      onUserOfflineCallback: (id, reason) {
        print("onUserOfflineCallback");
        debugPrint("User is Offiline reasion is -> $reason");
        remoteUid.value = null;
        if (reason == UserOfflineReasonType.userOfflineQuit) {
          global.isCallOrChat = 0;
          _callController.removeVideoCallSession(widget.callId.toString());
          ForegroundServiceManager.stopForegroundTask();
          AgoraManager().leave(
            agoraEngine,
            onchannelLeaveCallback: (isLiveEnded) async {
              debugPrint("Video Leave - 3");
              if (isLiveEnded) {
                global.showOnlyLoaderDialog(context);
                if (timer2 != null) {
                  timer2?.cancel();
                  timer2 = null;
                  timer!.cancel();
                }
                Future.wait<void>([
                  global.isEndCallApiCalled == true
                      ? null
                      : await _callController.endCall(
                          widget.callId,
                          _callController.totalSeconds,
                          global.agoraSid1,
                          global.agoraSid2,
                        ),
                ]);
                Get.find<SplashController>().getCurrentUserData();
                global.hideLoader();
                bottomNavigationController.setIndex(0, 0);

                // disconnectCall();
                Get.back();
                Get.back();
                Get.off(() => BottomNavigationBarScreen(index: 0));
              }
            },
          );
        } else if (reason == UserOfflineReasonType.userOfflineDropped) {
          ForegroundServiceManager.stopForegroundTask();

          AgoraManager().leave(
            agoraEngine,
            onchannelLeaveCallback: (isLiveEnded) async {
              debugPrint("Video Leave - 4");
              if (isLiveEnded) {
                global.showOnlyLoaderDialog(context);
                if (timer2 != null) {
                  timer2?.cancel();
                  timer2 = null;
                  timer!.cancel();
                }
                Future.wait<void>([
                  global.isEndCallApiCalled == true
                      ? null
                      : await _callController.endCall(
                          widget.callId,
                          _callController.totalSeconds,
                          global.agoraSid1,
                          global.agoraSid2,
                        ),
                ]);
                await Get.find<SplashController>().getCurrentUserData();
                global.hideLoader();
                bottomNavigationController.setIndex(0, 0);
                global.isCallOrChat = 0;
                _callController
                    .removeVideoCallSession(widget.callId.toString());
                // disconnectCall();
                Get.back();
                Get.back();
                Get.off(() => BottomNavigationBarScreen(index: 0));
              }
            },
          );
        }
      },
      onUserLeaveChannelCallback: (con, sc) async {
        print("onUserLeaveChannelCallback");
        debugPrint("onLeaveChannel called id- >${con.localUid}");
        isJoined.value = false;
        remoteUid.value = null;
        agoraEngine.leaveChannel();
        agoraEngine.release();
        await await Get.find<SplashController>().getCurrentUserData();
        ;

        bottomNavigationController.setIndex(0, 0);
        global.isCallOrChat = 0;
        _callController.removeVideoCallSession(widget.callId.toString());
        //disconnectCall();
        Get.back();
        Get.back();
        Get.off(() => BottomNavigationBarScreen(index: 0));
      },
      onAgoraError: (err, msg) {
        log('----------------------------------------------------------');
        log('----------------------------------------------------------');

        log('error agora - $err  and msg is - $msg');

        log('----------------------------------------------------------');
        log('----------------------------------------------------------');
      },
    );
    handler();
  }

  int? endTime;
  Widget status() {
    return endTime == null
        ? Text("Joining..", style: const TextStyle(fontWeight: FontWeight.w500))
        : CountdownTimer(
            endTime: endTime,
            widgetBuilder: (_, CurrentRemainingTime? time) {
              if (time == null) {
                return const Text(
                  'Joining..',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                );
              }
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: time.hours != null && time.hours != 0
                    ? Text(
                        '${time.hours ?? '00'} :${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'} :${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      )
                    : time.min != null
                        ? Text(
                            '${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'} :${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          )
                        : Text(
                            '${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
              );
            },
            onEnd: () async {
              log('in onEnd ${_callController.isLeaveCall}');
              if (_callController.isLeaveCall == false) {
                global.showOnlyLoaderDialog(Get.context);
                remoteUid.value = null;
                if (timer2 != null) {
                  timer2?.cancel();
                  timer2 = null;
                }
                ForegroundServiceManager.stopForegroundTask();

                AgoraManager().leave(
                  agoraEngine,
                  onchannelLeaveCallback: (isLiveEnded) async {
                    debugPrint("Video Leave - 5");
                    if (isLiveEnded) {
                      global.showOnlyLoaderDialog(context);
                      if (timer2 != null) {
                        timer2?.cancel();
                        timer2 = null;
                        timer!.cancel();
                      }
                      ;
                      Future.wait<void>([
                        global.isEndCallApiCalled == true
                            ? null
                            : await _callController.endCall(
                                widget.callId,
                                _callController.totalSeconds,
                                global.agoraSid1,
                                global.agoraSid2,
                              ),
                      ]);
                      await Get.find<SplashController>().getCurrentUserData();
                      global.hideLoader();
                      bottomNavigationController.setIndex(0, 0);
                      global.isCallOrChat = 0;
                      _callController
                          .removeVideoCallSession(widget.callId.toString());
                      //disconnectCall();
                      Get.back();
                      Get.back();
                      Get.off(() => BottomNavigationBarScreen(index: 0));
                    }
                  },
                );
                _callController.isLeaveCall = true;
                log('totalSeconds ${_callController.totalSeconds}');
                global.hideLoader();
              }
            },
          );
  }
}
