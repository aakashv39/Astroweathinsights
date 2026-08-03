// ignore_for_file: must_be_immutable, deprecated_member_use
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/views/bottomNavigationBarScreen.dart';
import 'package:AstrowayCustomer/views/call/onetooneAudio/CallSessions.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../controllers/bottomNavigationController.dart';
import '../../../controllers/history_controller.dart';
import '../../../controllers/splashController.dart';
import '../../../controllers/trackingchatController.dart';
import '../../../controllers/walletController.dart';
import '../../../utils/config.dart';
import '../../../utils/foregroundTaskHandler.dart';
import '../../chat/endDialog.dart';

class AcceptCallScreen extends StatefulWidget {
  final String? astrologerName;
  final int? astrologerId;
  final String? astrologerProfile;
  final String? token;
  final String? callChannel;
  final int? callId;
  bool isfromnotification;
  String? duration;

  AcceptCallScreen({
    super.key,
    this.astrologerName,
    this.callId,
    this.astrologerId,
    this.astrologerProfile,
    this.token,
    this.callChannel,
    this.duration,
    this.isfromnotification = false,
  });

  @override
  State<AcceptCallScreen> createState() => _AcceptCallScreenState();
}

class _AcceptCallScreenState extends State<AcceptCallScreen>
    with WidgetsBindingObserver {
  final _callController = Get.find<CallController>();
  final bottomNavicontroller = Get.find<BottomNavigationController>();
  final trackingController = Get.find<TrackingChatController>();
  int uid = 0;
  int? remoteID;
  RtcEngine? agoraEngine;
  bool isJoined = false;
  bool isCalling = true;
  Timer? timer;
  Timer? secTimer;
  bool isMuted = false;
  bool isSpeaker = false;
  int callVolume = 50;
  int? min;
  int? sec;
  int totalSecond = 0;
  bool isHostJoin = false;
  int? localUserId;
  bool isStart = false;
  List time = [5, 10, 15, 20, 25, 30, 60, 120];
  final walletController = Get.find<WalletController>();
  final historyController = Get.find<HistoryController>();
  Timer? callTimer;

  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _saveCurrenttime();
    global.isCallOrChat = 2;
    global.isEndCallApiCalled = false;
    if (global.callStartedAt == null) {
      global.callStartedAt = DateTime.now().millisecondsSinceEpoch;
      DateTime actualStartTime =
          DateTime.fromMillisecondsSinceEpoch(global.callStartedAt!);
      log('Chat started at: $actualStartTime');
      print("new duration:- ${widget.duration.toString()}");
      print("from notification tap ${widget.isfromnotification}");
      if (widget.isfromnotification == false) {
        ForegroundServiceManager.startForegroundTask();
        setupAgora();
      } else {
        print("rejoin");
        final sessionKey = widget.callId?.toString();
        final session = sessionKey != null
            ? _callController.activeSessions[sessionKey]
            : null;
        if (session != null) {
          agoraEngine = session.agoraEngine;
          isMuted = session.isMuted;
          isSpeaker = session.isSpeaker;
          callTimer = session.callTimer;
          remoteID = session.remoteID;
          isJoined = session.isJoined;
          log('Rejoining existing session from notification: $sessionKey');
        }
        _callController.endTime.value = int.parse(widget.duration.toString());
      }
    } else {
      final sessionKey = widget.callId?.toString();
      final session = sessionKey != null
          ? _callController.activeSessions[sessionKey]
          : null;
      if (session != null) {
        agoraEngine = session.agoraEngine;
        isMuted = session.isMuted;
        isSpeaker = session.isSpeaker;
        callTimer = session.callTimer;
        remoteID = session.remoteID;
        isJoined = session.isJoined;
        log('Rejoining existing session from notification: $sessionKey');
      }
      // _callController.endTime.value = int.parse(widget.duration.toString());
    }
  }

  void _saveCurrenttime() async {
    final prefs = await SharedPreferences.getInstance();
    int? _starttime = prefs.getInt('callStarttime');
    debugPrint("Start end time $_starttime");
    if (_starttime == null) {
      final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setInt('callStarttime', currentTime);
      debugPrint("First time - Current time saved: $currentTime");
    } else {
      debugPrint("Using existing saved time: $_starttime");
    }
  }

  Future<bool> isTimeDifferenceExceeded() async {
    final prefs = await SharedPreferences.getInstance();
    final savedtime = prefs.getInt("callStarttime") ?? 0;
    final currentTime = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final timeDifference = currentTime - savedtime;
    debugPrint("Time gap (seconds): $timeDifference");
    return timeDifference <= 60;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_callController.isLeaveCall == false) {
            final session = Callsessions(
              sessionId: widget.callId.toString(),
              astrologerId: int.parse(widget.astrologerId.toString()),
              astrologerName: widget.astrologerName.toString(),
              astrologerProfile: widget.astrologerProfile.toString(),
              token: widget.token.toString(),
              callChannel: widget.callChannel.toString(),
              callId: widget.callId.toString(),
              isfromnotification: widget.isfromnotification,
              duration: trackingController.updatedTime.toString(),
              savedAt: global.callStartedAt,
              remoteID: remoteID,
              isJoined: isJoined,
              isMuted: isMuted,
              isSpeaker: isSpeaker,
              agoraEngine: agoraEngine,
            );
            log('save and backrpess ${jsonDecode.toString()}');
            _callController.addSession(session);
            final bottomNavigationController =
                Get.find<BottomNavigationController>();
            bottomNavigationController.setIndex(0, 0);
            Get.to(() => BottomNavigationBarScreen(index: 0));
          }
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  color: Get.theme.primaryColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.astrologerName ?? 'User',
                              style: Get.textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  color: Colors.white),
                            ),
                            SizedBox(
                              child: status(),
                            ),
                            const SizedBox(height: 15),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(bottom: Get.height * 0.1),
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 60,
                        child: widget.astrologerProfile == null
                            ? Image.asset(
                                Images.deafultUser,
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                height: 12.h,
                                width: 12.h,
                                imageUrl:
                                global.buildImageUrl('${widget.astrologerProfile}'),
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  radius: 5.h,
                                  backgroundColor: Colors.transparent,
                                  child: Image.network(
                                    height: 12.h,
                                    width: 12.h,
                                    global.buildImageUrl('${widget.astrologerProfile}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Image.asset(
                                  Images.deafultUser,
                                  fit: BoxFit.contain,
                                  height: 60,
                                  width: 40,
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomSheet: Container(
              height: Get.height * 0.1,
              padding: EdgeInsets.all(10),
              color: Get.theme.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        callVolume = 100;
                        isSpeaker = !isSpeaker;
                      });
                      onVolume(isSpeaker);
                    },
                    child: Icon(
                      Icons.volume_up,
                      color: isSpeaker ? Colors.blue : Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final shouldExit = await isTimeDifferenceExceeded();
                      if (shouldExit) {
                        Get.dialog(
                          EndDialog(),
                        );
                      } else {
                        print('leave call from cut');
                        global.showOnlyLoaderDialog(Get.context);
                        await leave("endcallbutton");
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('callStarttime');
                        global.hideLoader();
                        log('leave call from cut');
                        trackingController.stopTimer();
                        Get.back();
                        Get.back();
                        BottomNavigationController bottomNavigationController =
                            Get.find<BottomNavigationController>();
                        bottomNavigationController.setIndex(0, 0);
                        Get.to(() => BottomNavigationBarScreen(index: 0));
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        isMuted = !isMuted;
                        log('mute $isMuted');
                      });
                      onMute(isMuted);
                    },
                    child: Icon(
                      Icons.mic_off,
                      color: isMuted ? Colors.blue : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  void stopTimer() {
    callTimer?.cancel();
    print("CallTimer Stoped");
  }

  Future<void> createLocalClient() async {
    try {
      agoraEngine = await createAgoraRtcEngine();
      await agoraEngine!.initialize(
        RtcEngineContext(
          appId: global.getSystemFlagValue(
            global.systemFlagNameList.agoraAppId,
          ),
        ),
      );
    } catch (e) {
      print('Exception in createLocalClient:- ${e.toString()}');
    }
  }

  Future<void> setupVoiceSDKEngine() async {
    await [
      Permission.microphone,
      Permission.camera,
    ].request();
    try {
      await createLocalClient();
    } catch (e) {
      print('Exception in setupVoiceSDKEngine:- ${e.toString()}');
    }
    agoraEngine?.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) async {
          debugPrint("Inside agora method onJoinChannelSuccess");
          debugPrint("Inside agora localUid ${connection.localUid}");
          debugPrint("Inside agora localUserId ${localUserId}");
          setState(() {
            isJoined = true;
            localUserId = connection.localUid;
            global.localUid = localUserId;
            print('userid : - ${connection.localUid}');
          });
        },
        onUserJoined:
            (RtcConnection connection, int remoteUId, int elapsed) async {
          debugPrint("Inside agora method onUserJoined $remoteUId");
          setState(() {
            isHostJoin = true;
            remoteID = remoteUId;
            _callController.endTime.value =
                DateTime.now().millisecondsSinceEpoch +
                    1000 * int.parse(widget.duration.toString());
            _callController.update();
            trackingController.updatedTime = _callController.endTime.value;
            _callController.totalSeconds = 0;
            _callController.update();
          });
          callTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
            _callController.totalSeconds = _callController.totalSeconds + 1;

            _callController.update();
            print('totalsecons ${_callController.totalSeconds}');
          });

          _callController.isLeaveCall = false;
          _callController.update();
          print("RemoteId for call" + remoteID.toString());
        },
        onUserOffline: (RtcConnection connection, int remoteUId,
            UserOfflineReasonType reason) async {
          print('leave call from userOffline ${global.isEndCallApiCalled}');
          global.isEndCallApiCalled == true
              ? null
              : await leave("onuserOffline");
          log('leave call from cut');
          Get.back();
          Get.back();
          bottomNavicontroller.setIndex(0, 0);
          Get.to(() => BottomNavigationBarScreen(index: 0));
        },
        onRtcStats: (connection, stats) {
          debugPrint("Inside agora method onRtcStats");
        },
      ),
    );
    debugPrint("going for enable Volume");
    onVolume(isSpeaker);
    onMute(isMuted);
    debugPrint("mirophone mutteed itself");
    join();
  }

  void join() async {
    // Set channel options including the client role and channel profile
    ChannelMediaOptions options = const ChannelMediaOptions(
      clientRoleType: ClientRoleType.clientRoleBroadcaster,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    );
    await agoraEngine?.joinChannel(
      token: widget.token!,
      channelId: widget.callChannel!,
      options: options,
      uid: uid,
    );
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
      agoraEngine?.leaveChannel();
      agoraEngine?.release(sync: true);
      agoraEngine?.disableAudio();

      global.sp?.setBool("isformKill", true);
      global.sp?.setInt("callId", widget.callId!.toInt());
      global.sp?.setString("agorasid1", global.agoraSid1);
      global.sp?.setString("agorasid2", global.agoraSid2);
      global.sp?.setInt("calltime", _callController.totalSeconds);

      debugPrint("Called from leave detached");
    } else if (state == AppLifecycleState.inactive) {
      debugPrint("⚠️ App is inactive (e.g. during call or split screen)");
    }
  }

  Future startRecord() async {
    await _callController.agoraStartRecording(widget.callChannel!,
        int.parse(global.myAudioRecordingUid.toString()), widget.token!);
  }

  Future stopRecord() async {
    await _callController.agoraStopRecording(widget.callId!,
        widget.callChannel!, int.parse(global.myAudioRecordingUid.toString()));
  }

  void onMute(bool mute) {
    agoraEngine?.muteLocalAudioStream(mute);
  }

  void onVolume(bool isSpeaker) {
    agoraEngine?.setEnableSpeakerphone(isSpeaker);
  }

  Future<void> leave(String callfrom) async {
    print("call from:- $callfrom");
    global.isCallOrChat = 0;
    _callController.removeSession(widget.callId.toString());
    ForegroundServiceManager.stopForegroundTask();
    _callController.showBottomAcceptCall = false;
    _callController.callBottom = false;
    _callController.isLeaveCall = true;
    global.sp!.remove('callBottom');
    global.sp!.setInt('callBottom', 0);
    _callController.callBottom = false;
    _callController.update();
    await stopRecord();
    global.showOnlyLoaderDialog(Get.context);
    if (timer != null) {
      timer?.cancel();
      timer = null;
    }
    callTimer?.cancel();

    Future.wait<void>([
      _callController.endCall(widget.callId!, _callController.totalSeconds,
          global.agoraSid1, global.agoraSid2),
    ]);
    await Get.find<SplashController>().getCurrentUserData();
    global.hideLoader();
    global.localUid = null;
    _callController.endTime.value = null;
    if (mounted) {
      setState(() {
        isJoined = false;
        remoteID = null;
        global.localUid = null;
      });
    }
    try {
      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      print("endAllCalls error: $e");
    }
    final sessionKey = widget.callId?.toString();
    final session =
        sessionKey != null ? _callController.activeSessions[sessionKey] : null;
    RtcEngine? sessionEngine = session?.agoraEngine ?? agoraEngine;
    if (sessionEngine != null) {
      try {
        await sessionEngine.leaveChannel();
      } catch (e) {
        print("leaveChannel error: $e");
      }
      try {
        await sessionEngine.release(sync: true);
      } catch (e) {
        print("agora release error: $e");
      }
    }
  }

  @override
  void dispose() {
    if (timer != null) {
      timer?.cancel();
      print('stop timer in despose');
      global.localUid = null;
    }
    if (secTimer != null) {
      secTimer?.cancel();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget status() {
    return ValueListenableBuilder<int?>(
      valueListenable: _callController.endTime,
      builder: (context, value, child) {
        if (value == null) {
          return Text(
            "Joining..",
            style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.sp),
          );
        }

        return CountdownTimer(
          key: ValueKey(value),
          endTime: value,
          widgetBuilder: (_, CurrentRemainingTime? time) {
            if (time == null) {
              return Text(
                '00:00:00',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 16.sp,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(left: 0),
              child: time.hours != null && time.hours != 0
                  ? Text(
                      '${time.hours ?? '00'}:${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'}:${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 16.sp,
                      ),
                    )
                  : time.min != null
                      ? Text(
                          '${time.min! <= 9 ? '0${time.min}' : time.min ?? '00'}:${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        )
                      : Text(
                          '00:${time.sec! <= 9 ? '0${time.sec}' : time.sec}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                            fontSize: 16.sp,
                          ),
                        ),
            );
          },
          onEnd: () async {
            ///no logic
          },
        );
      },
    );
  }

  void setupAgora() {
    if (widget.isfromnotification == false) {
      ForegroundServiceManager.startForegroundTask();
      _requestNotificationPermissions();
      setupVoiceSDKEngine();
      trackingController.selectTime = 0;

      timer = Timer.periodic(Duration(seconds: 3), (timer) async {
        print('timer calling form setup agora');
        if (!isStart) {
          setState(() {
            isStart = true;
          });
          await _callController.getAgoraResourceId(widget.callChannel!,
              int.parse(global.myAudioRecordingUid.toString()));
          await startRecord();
        }
      });
      print('After Call Timmer data $timer');
    } else {
      log('you are coming from notificaiotn');
    }
  }

  Future _requestNotificationPermissions() async {
    log('request permission enableing notification');
    PermissionStatus status = await Permission.notification.status;
    log('request permission status ${status.isGranted}');
    if (!status.isGranted || status.isDenied || status.isPermanentlyDenied) {
      await FlutterCallkitIncoming.requestFullIntentPermission();
    }
  }
}
