// ignore_for_file: deprecated_member_use, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'dart:async';
import 'dart:developer';
import 'package:AstrowayCustomer/views/call/zegocloud/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:zego_uikit_prebuilt_live_streaming/zego_uikit_prebuilt_live_streaming.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import '../../../controllers/liveController.dart';
import '../../../controllers/walletController.dart';
import '../../../utils/global.dart' as global;
import '../../bottomNavigationBarScreen.dart';

class Zegolivescreen extends StatefulWidget {
  final String liveID;
  final bool isHost;
  final String localUserID;
  final String? astrologerID;
  final dynamic charge;
  final dynamic videoCallCharge;
  final String? liveToken;
  const Zegolivescreen({
    Key? key,
    required this.liveID,
    required this.localUserID,
    this.isHost = false,
    this.astrologerID = '',
    required this.charge,
    required this.videoCallCharge,
    required this.liveToken,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => LivePageState();
}

class LivePageState extends State<Zegolivescreen> {
  late ZegoUIKitPrebuiltLiveStreamingConfig audienceConfig;
  Timer? coHostTimer;
  DateTime? coHostStartTime;
  bool coHostAudioOnly = false;
  final liveController = Get.find<LiveController>();
  final walletController = Get.find<WalletController>();
  dynamic charge;
  dynamic videoCallCharge = 0.0;
  List time = [5, 10, 15, 20, 25, 30];
  String? coHostRequestType;
  bool _isProcessingPayment = false;
  bool _hasLeftRoom = false; // Add flag to track if we've already left
  Timer? _paymentCooldownTimer;
  final coHostStartTimeNotifier = ValueNotifier<DateTime?>(null);
  final coHostAudioOnlyNotifier = ValueNotifier<bool>(false);
  final zegoController = ZegoUIKitPrebuiltLiveStreamingController();

  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();
    _hasLeftRoom = false; // Initialize flag

    charge = widget.charge.toDouble();
    videoCallCharge = widget.videoCallCharge.toDouble();
    log('''
        zegoAppId : ${global.getSystemFlagValue(global.systemFlagNameList.zegoAppId)}
        zegoAppSign : ${global.getSystemFlagValue(global.systemFlagNameList.zegoAppSign)}
        localUserID  : ${widget.localUserID}
        liveID  : ${widget.liveID}
        liveToken  : ${widget.liveToken}
        astrologerID  : ${widget.astrologerID}
     ''');
  }

  @override
  Widget build(BuildContext context) {
    audienceConfig = ZegoUIKitPrebuiltLiveStreamingConfig.audience(
      plugins: [ZegoUIKitSignalingPlugin()],
    )
      ..role = ZegoLiveStreamingRole.audience
      ..turnOnCameraWhenJoining = false
      ..turnOnMicrophoneWhenJoining = false
      ..useSpeakerWhenJoining = true

      // for audience
      ..bottomMenuBar.audienceButtons = [
        ZegoLiveStreamingMenuBarButtonName.chatButton,
        ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
        ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
      ]
      // for co-host
      ..bottomMenuBar.coHostButtons = [
        ZegoLiveStreamingMenuBarButtonName.chatButton,
        ZegoLiveStreamingMenuBarButtonName.toggleCameraButton,
        ZegoLiveStreamingMenuBarButtonName.toggleMicrophoneButton,
        ZegoLiveStreamingMenuBarButtonName.switchCameraButton,
      ]
      ..bottomMenuBar.audienceExtendButtons = [
        ZegoMenuBarExtendButton(
          child: Container(
            margin: EdgeInsets.only(right: 8),
            child: FloatingActionButton.small(
              onPressed: _showCallOptions,
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 6,
              shape: CircleBorder(),
              heroTag: 'joincall',
              child: Icon(Icons.group_add, size: 22.sp),
            ),
          ),
        ),
      ]
      ..confirmDialogInfo = null
      ..topMenuBar.showCloseButton = true
      ..coHost.turnOnCameraWhenCohosted = () {
        log("📹 turnOnCameraWhenCohosted called - coHostAudioOnly: ${coHostAudioOnlyNotifier.value}");
        return !coHostAudioOnlyNotifier.value;
      };

    audienceConfig.audioVideoView.showAvatarInAudioMode = false;
    audienceConfig.audioVideoView.showSoundWavesInAudioMode = true;
    audienceConfig.audioVideoView.showUserNameOnView = false;
    audienceConfig.duration = ZegoLiveStreamingDurationConfig(
      isVisible: false,
    );

    final audienceEvents = ZegoUIKitPrebuiltLiveStreamingEvents(
      onError: (ZegoUIKitError error) {
        log('Developer-onError:$error');
      },
      onEnded: (event, defaultAction) async {
        log('audienceEvents onEnded 1');
        await _handleLeaveChannel();
      },
      coHost: ZegoLiveStreamingCoHostEvents(
        coHost: ZegoLiveStreamingCoHostCoHostEvents(
          onLocalConnected: () {
            log("🎤 I became a co-host - Audio Only: ${coHostAudioOnlyNotifier.value}");
            coHostStartTime = DateTime.now();
            coHostStartTimeNotifier.value = coHostStartTime;
            coHostTimer?.cancel();
            coHostTimer = Timer.periodic(const Duration(seconds: 1), (_) {
              coHostStartTimeNotifier.notifyListeners();
            });

            if (!coHostAudioOnlyNotifier.value) {
              log("📹 Enabling camera for video call");
              Future.delayed(Duration(milliseconds: 500), () {
                ZegoUIKit().turnCameraOn(true);
              });
            }
            setState(() {});
          },
          onLocalDisconnected: () async {
            log("❌ I left or was removed as co-host");
            // Only handle payment and state cleanup, don't leave room here
            await leaveLivecutPayment();
            _resetCoHostState();
          },
          onLocalConnectStateUpdated: (state) {
            log('connected state is $state');
          },
        ),
      ),
      audioVideo: ZegoLiveStreamingAudioVideoEvents(
        onCameraTurnOnByOthersConfirmation: (BuildContext context) {
          return onTurnOnAudienceDeviceConfirmation(
            context,
            isCameraOrMicrophone: true,
          );
        },
        onMicrophoneTurnOnByOthersConfirmation: (BuildContext context) {
          return onTurnOnAudienceDeviceConfirmation(
            context,
            isCameraOrMicrophone: false,
          );
        },
      ),
    );

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            ZegoUIKitPrebuiltLiveStreaming(
                appID: int.parse(global
                    .getSystemFlagValueForLogin(
                        global.systemFlagNameList.zegoAppId)
                    .toString()),
                appSign: global.getSystemFlagValueForLogin(
                    global.systemFlagNameList.zegoAppSign),
                userID: widget.localUserID,
                userName: 'user_${widget.localUserID}',
                token: widget.liveToken!,
                liveID: widget.liveID,
                events: audienceEvents,
                config: audienceConfig
                  ..audioVideoView.useVideoViewAspectFill = true
                  ..topMenuBar.buttons = []
                  ..avatarBuilder = customAvatarBuilder),

            // Timer UI overlay - TOP CENTER
            ValueListenableBuilder<DateTime?>(
              valueListenable: coHostStartTimeNotifier,
              builder: (context, startTime, child) {
                if (startTime != null) {
                  return Positioned(
                    top: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _formatElapsedTime(startTime),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Handle leaving channel - called only once
  Future<void> _handleLeaveChannel() async {
    if (_hasLeftRoom) {
      log('⚠️ Already left room, skipping');
      return;
    }

    _hasLeftRoom = true;
    log('🔄 Handling leave channel - STARTED');

    try {
      // 1. Stop co-host FIRST (most important)
      await _stopCoHostBeforeLeaving();

      // 2. Process payment if needed
      await leaveLivecutPayment();

      // 3. Small delay to ensure Zego processes the stopCoHost
      await Future.delayed(Duration(milliseconds: 300));

      // 4. Navigate away (let Zego handle the leave automatically)
      log('🔄 Navigating away');
      Get.off(() => BottomNavigationBarScreen(index: 0));
    } catch (e) {
      log('❌ Error in _handleLeaveChannel: $e');
      _hasLeftRoom = false; // Reset flag on error
    }
  }

  // Stop co-host BEFORE leaving the room
  Future<void> _stopCoHostBeforeLeaving() async {
    log('🛑 Stopping co-host before leaving');

    try {
      // This is the critical call - stop co-host first
      await zegoController.coHost.stopCoHost(showRequestDialog: false);
      log('✅ Co-host stopped successfully');

      // Small delay to let Zego process
      await Future.delayed(Duration(milliseconds: 200));

      // Reset local state
      _resetCoHostState();
    } catch (e) {
      log('❌ Error stopping co-host: $e');
    }
  }

  // Reset co-host state variables
  void _resetCoHostState() async {
    log('🧹 Resetting co-host state');

    // Cancel timers
    coHostTimer?.cancel();
    coHostTimer = null;

    // Reset state variables
    coHostStartTime = null;
    coHostStartTimeNotifier.value = null;
    coHostAudioOnlyNotifier.value = false;

    // Update controller
    liveController.isImInWaitList = false;
    liveController.update();

    // Turn off camera and microphone
    try {
      ZegoUIKit().turnCameraOn(false);
      ZegoUIKit().turnMicrophoneOn(false);

      log('🚪 Leaving Zego room...');
      try {
        await ZegoUIKit().leaveRoom();
        log('✅ Successfully left Zego room');
      } catch (e) {
        log('⚠️ Error while leaving room: $e');
      }
    } catch (e) {
      log('Error turning off camera/mic: $e');
    }

    log('✅ Co-host state reset completed');
  }

  Future<void> leaveLivecutPayment() async {
    if (_isProcessingPayment) {
      log('⏳ Payment already processing, skipping duplicate call');
      return;
    }
    if (_paymentCooldownTimer != null && _paymentCooldownTimer!.isActive) {
      log('⏳ Payment cooldown active, skipping');
      return;
    }
    _isProcessingPayment = true;
    try {
      if (coHostStartTime != null) {
        final totalDuration = DateTime.now().difference(coHostStartTime!);
        final totalSeconds = totalDuration.inSeconds;
        final minutes = totalDuration.inMinutes;
        final seconds = totalSeconds % 60;
        log('🕒 Co-host session ended - Total time: $minutes minutes $seconds seconds');
        int index5 = liveController.waitList
            .indexWhere((element) => element.userId == global.currentUserId);
        if (index5 != -1) {
          await liveController
              .deleteFromWaitList(liveController.waitList[index5].id);
        }

        if (global.user.walletAmount! > 0) {
          await liveController.cutPaymentForLive(
              global.user.id!,
              totalSeconds,
              int.parse(widget.astrologerID.toString()),
              coHostAudioOnlyNotifier.value ? "audio" : "video",
              "",
              sId1: global.agoraSid1,
              sId2: global.agoraSid2,
              channelName: widget.liveID);
          log("✅ Payment processed successfully");
        }
      }
      _paymentCooldownTimer = Timer(Duration(seconds: 15), () {
        log('🔄 Payment cooldown ended');
        _paymentCooldownTimer = null;
      });
    } catch (e) {
      log('❌ Error in payment processing: $e');
    } finally {
      Future.delayed(Duration(seconds: 2), () {
        _isProcessingPayment = false;
      });
    }
  }

  String _formatElapsedTime(DateTime startTime) {
    final duration = DateTime.now().difference(startTime);
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<bool> onTurnOnAudienceDeviceConfirmation(
    BuildContext context, {
    required bool isCameraOrMicrophone,
  }) async {
    const textStyle = TextStyle(
      fontSize: 10,
      color: Colors.white70,
    );
    const buttonTextStyle = TextStyle(
      fontSize: 10,
      color: Colors.black,
    );
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[900]!.withOpacity(0.9),
          title: Text(
              "You have a request to turn on your ${isCameraOrMicrophone ? "camera" : "microphone"}",
              style: textStyle),
          content: Text(
              "Do you agree to turn on the ${isCameraOrMicrophone ? "camera" : "microphone"}?",
              style: textStyle),
          actions: [
            ElevatedButton(
              child: const Text('Cancel', style: buttonTextStyle),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text('OK', style: buttonTextStyle),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCallOptions() {
    log('open showcallotpion dialog');
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Join as',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Audio call option
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                        double totalCharge = charge! * time[0];
                        if (totalCharge <= global.user.walletAmount!) {
                          log("🎤 Requesting AUDIO only co-host");
                          await ZegoUIKitPrebuiltLiveStreamingController()
                              .coHost
                              .audienceSendCoHostRequest(
                                withToast: true,
                                customData: '{"audio":true,"video":false}',
                              );
                          coHostAudioOnlyNotifier.value = true;
                          await liveController.addToWaitList(
                              widget.liveID.toString(),
                              "Audio",
                              int.parse(widget.astrologerID.toString()),
                              time[0].toString());

                          global.showToast(
                            message: 'you have joined in waitlist',
                            textColor: global.textColor,
                            bgColor: global.toastBackGoundColor,
                          );
                          liveController.isImInWaitList = true;
                          liveController.update();
                        } else {
                          global.showOnlyLoaderDialog(context);
                          await walletController.getAmount();
                          global.hideLoader();
                        }
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.mic,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Audio',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                // Video call option
                Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        Get.back();
                        double totalCharge = videoCallCharge * time[0];
                        if (totalCharge <= global.user.walletAmount!) {
                          log("📹 Requesting VIDEO co-host");
                          await ZegoUIKitPrebuiltLiveStreamingController()
                              .coHost
                              .audienceSendCoHostRequest(
                                withToast: true,
                                customData: '{"audio":false,"video":true}',
                              );
                          coHostAudioOnlyNotifier.value = false;
                          await liveController.addToWaitList(
                              widget.liveID,
                              "Video",
                              int.parse(widget.astrologerID.toString()),
                              time[0].toString());

                          global.showToast(
                            message: 'you have joined in waitlist',
                            textColor: global.textColor,
                            bgColor: global.toastBackGoundColor,
                          );
                          liveController.isImInWaitList = true;
                          liveController.update();
                        } else {
                          global.showOnlyLoaderDialog(context);
                          await walletController.getAmount();
                          global.hideLoader();
                        }
                      },
                      child: Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.videocam,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Video',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    log('ondispose - cleaning up all resources');
    WakelockPlus.disable();
    log('ondispose timer canceled');
    coHostTimer?.cancel();
    coHostStartTimeNotifier.dispose();
    coHostAudioOnlyNotifier.dispose();
    _paymentCooldownTimer?.cancel();
    super.dispose();
  }
}
