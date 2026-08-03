// ignore_for_file: deprecated_member_use, must_be_immutable
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../controllers/bottomNavigationController.dart';
import '../../../controllers/chatController.dart';
import '../../../controllers/homeController.dart';
import '../../../controllers/liveController.dart';
import '../../../controllers/walletController.dart';
import '../../../model/message_model.dart';
import '../../../utils/global.dart' as global;
import '../../../utils/services/api_helper.dart';
import '../../bottomNavigationBarScreen.dart';
import 'dart:async';

class HMSLiveScreen extends StatefulWidget {
  dynamic hmsToken;
  final dynamic charge;
  final dynamic videoCallCharge;
  final dynamic channel;
  final dynamic astrologerId;
  HMSLiveScreen({super.key, required this.hmsToken, required this.charge, required this.videoCallCharge, required this.channel, required this.astrologerId});

  @override
  State<HMSLiveScreen> createState() => _HMSLiveScreenState();
}

class _HMSLiveScreenState extends State<HMSLiveScreen>
    implements HMSUpdateListener {
  final homeController = Get.find<HomeController>();
  final apiHelper = APIHelper();
  // final liveAstrologerController = Get.find<LiveAstrologerController>();
  final messageController = TextEditingController();
  final chatcontroller = Get.find<ChatController>();
  final walletController = Get.find<WalletController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();
  final liveController = Get.find<LiveController>();
  final ValueNotifier<bool> isAudioModerator = ValueNotifier(false);
  bool _isTimerRunning = false;
  String? reqType, username;
  String peerUserId = "";
  int currentUserId = 0;
  String userName = "";
  String currenUserName = "";
  bool isAlreadyTaking = false;
  String channelName = '';

  // HMS related variables
  HMSPeer? localPeer, hostPeer;
  HMSVideoTrack? localPeerVideoTrack;
  HMSAudioTrack? localPeerAudioTrack;
  final ValueNotifier<bool> isMicMuted = ValueNotifier(false);
  final ValueNotifier<bool> isVideoOn = ValueNotifier(true);
  final ValueNotifier<bool> isSpeakerOn = ValueNotifier(true);
  final ValueNotifier<bool> isJoined = ValueNotifier(false);
  final ValueNotifier<bool> isImHost = ValueNotifier(false);
  final ValueNotifier<String> localName = ValueNotifier("Joining...");
  final ValueNotifier<String> remoteName = ValueNotifier("Waiting...");
  final ValueNotifier<String> currentUserProfile = ValueNotifier<String>('');
  final ValueNotifier<int> myviewerCount = ValueNotifier<int>(1);
  final ValueNotifier<Duration> liveDuration = ValueNotifier(Duration.zero);

  final ValueNotifier<Map<String, HMSVideoTrack>> remoteVideoTracks =
      ValueNotifier({});
  final ValueNotifier<bool> isBroadcaster = ValueNotifier(false);
  final ValueNotifier<String> currentRole = ValueNotifier("viewer");

  // Chat related variables
  final ValueNotifier<List<MessageModel>> reverseMessage = ValueNotifier([]);
  final List<MessageModel> messageList = [];
  final _messageLock = Lock();
  SharedPreferences? sp;

  double? charge;
  double videoCallCharge=0.0;
  List time = [5, 10, 15, 20, 25, 30];
  @override
  void initState() {
    WakelockPlus.enable();
    super.initState();
    charge = widget.charge.toDouble();
    videoCallCharge = widget.videoCallCharge.toDouble();

    initHMSSDK();
  }

  void _startLiveTimer(String calledFromWhere) {
    print("calledFromWhere:- ${calledFromWhere}");
    print("_isTimerRunning:- ${_isTimerRunning}");
    if (_isTimerRunning) {
      print("startlivetimmer called again");
      // return ;
      // log('⚠️ Timer already running, not starting again');
      // log('timmer:- ${liveController.endTime}');
      // log('timmer:- ${liveController.endTime}');
      // // print("updated time:- ${initialSeconds}");
      //
      // // Initialize the minute and second text
      //

      // return;
    }
    else
      {
        _isTimerRunning = true;
        // liveController.minText = Duration(milliseconds: liveController.endTime - DateTime.now().millisecondsSinceEpoch)
        //     .toString()
        //     .split('.')
        //     .first
        //     .substring(2, 7);
        // liveController.update();

        // Start the timer
        liveController.liveTimmer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
          log('Live duration ${liveDuration.value}');
          liveDuration.value = liveDuration.value + const Duration(seconds: 1);
          if (liveController.endTime > 0) {
            liveController.endTime--;
            liveController.liveCallTalked ++; //this is the  time i will share in  api when call end
            liveController.minText = Duration(milliseconds: liveController.endTime - DateTime.now().millisecondsSinceEpoch)
                .toString()
                .split('.')
                .first
                .substring(2, 7);
            liveController.update();
          } else {
            // Timer ends here
            timer.cancel();
            liveController.liveTimmer?.cancel();
            // liveController.onTimerEnd();
          }
        });
        print("startlivetimmer called one");
        //
        // liveController.liveTimmer = Timer.periodic(const Duration(seconds: 1), (timer) {
        //   log('Live duration ${liveDuration.value}');
        //   liveDuration.value = liveDuration.value + const Duration(seconds: 1);
        // });
      }


  }

  void _stopLiveTimer() {
      liveController.liveTimmer?.cancel();
      liveController.liveTimmer = null;
      log('⏹ Live timer stopped');

    _isTimerRunning = false;
  }

  bool _isHostRole(String roleName) {
    final lowerRole = roleName.toLowerCase();
    return lowerRole.contains("livestreaming");
  }

  void initHMSSDK() async {
    liveController.liveCallTalked=0;
    liveController.update();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Generate HMS token for live streaming
      liveController.hmsSDK = HMSSDK();
      await liveController.hmsSDK?.build();
      liveController.hmsSDK?.addUpdateListener(listener: this);
      bool haspermission = await global.getPermissions();
      if (!haspermission) {
        global.showToast(
            message: "Permissions required for live streaming",
            bgColor: Colors.black,
            textColor: Colors.white);
        Get.back();
        return;
      }

      log('viewer token is ${widget.hmsToken}');
      // Join the HMS room
      liveController.hmsSDK?.join(
        config: HMSConfig(
            authToken: widget.hmsToken,
            userName: currenUserName,
            metaData: json.encode({
              'user_id': currentUserId,
              'profile_pic': currentUserProfile.value,
            })),
      );
    });
  }

  Future<void> leaveMeeting() async {
    log('meeting leaved');
    log('isBroadcaster.value ${isBroadcaster.value}');
    try {
      if(isAudioModerator.value )
        {
          await liveController.cutPaymentForLive(
              global.user.id!,
              liveController.liveCallTalked,
              widget.astrologerId!,
              "audio",
              "",
              sId1: "",
              sId2: '',
              channelName: '');
        }
      else if(isBroadcaster.value)
        {
          await liveController.cutPaymentForLive(
              global.user.id!,
              liveController.liveCallTalked,
              widget.astrologerId!,
              "video",
              "",
              sId1: "",
              sId2: '',
              channelName: '');
        }

      _stopLiveTimer();
      liveController.minText="";
      liveController.endTime=0;
      await liveController.hmsSDK?.leave();
      liveController.hmsSDK?.destroy();
      remoteVideoTracks.value.clear();
      bottomNavigationController.setIndex(0, 0);
      await liveController.removeLiveuserData();
      liveController.update();
      Get.off(() => BottomNavigationBarScreen(index: 0));
    } catch (e) {
      debugPrint("Error leaving meeting: $e");
    }
  }

  Future<void> changePeerRole(HMSPeer peer, String roleName) async {
    try {
      if (peer.role.name == roleName) {
        log('The peer already has the role ${roleName}. Not changing the role.');
      }
      List<HMSRole> roles = await liveController.hmsSDK!.getRoles();
      HMSRole toRole = roles.firstWhere((r) => r.name == roleName);
      await liveController.hmsSDK?.changeRoleOfPeer(
        forPeer: peer,
        toRole: toRole,
        force: true,
      );
      log("Role change requested for ${peer.name} → ${toRole.name}");
    } catch (e) {
      debugPrint("Error changing role: $e");
    }
  }

  sendMessage(String messageText) async {
    try {
      String messageWithMetadata = json.encode({
        'message': messageText,
        'userName': global.user.name,
        'profile':"${global.user.profile.toString()}",
        'userId': currentUserId.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      });

      await liveController.hmsSDK?.sendBroadcastMessage(
        message: messageWithMetadata,
        type: "chat",
      );
      MessageModel newUserMessage = MessageModel(
        message: messageText,
        userName: currenUserName,
        profile: currentUserProfile.value,
        isMe: true,
        gift: null,
        createdAt: DateTime.now(),
      );

      messageList.add(newUserMessage);
      reverseMessage.value = messageList.reversed.toList();
    } catch (e) {
      log('Failed to send message: $e');
    }
  }

  // New function to show bottom sheet for call options
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
                      onTap: () async{
                        ///hms
                        // Navigator.pop(context);
                        // _sendJoinRequest('audio');
                        Get.back();
                        double totalCharge = charge! * time[0];
                        if (totalCharge <= global.user.walletAmount!) {
                          await liveController.addToWaitList(
                              widget.channel!,
                              "Audio",
                              widget.astrologerId,
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
                      onTap: () async{
                        // Navigator.pop(context);
                        // _sendJoinRequest('video');


                        Get.back();
                        double totalCharge =
                            videoCallCharge * time[0];
                        if (totalCharge <= global.user.walletAmount!) {
                          await liveController.addToWaitList(
                              widget.channel!,
                              "Video",
                              widget.astrologerId!,
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
                          // openBottomSheetRechrage(
                          //     context, totalCharge, false);
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
  void onJoin({required HMSRoom room}) async {
    for (var peer in room.peers ?? []) {
      log('onJoin role name ${peer.role.name}');
      log('onJoin token is ${widget.hmsToken}');
      if (peer.isLocal) {
        localPeer = peer;
        isImHost.value = true;
        log("onJoin Local peer set as host: ${peer.name}");
      } else {
        // remotePeer = peer;
        log("onJoin Remote peer: ${peer.name} (${peer.role.name})");
        myviewerCount.value = myviewerCount.value + 1;
        if (_isHostRole(peer.role.name)) {
          hostPeer ??= peer;
          log("Host detected: ${hostPeer?.name} (${hostPeer?.peerId})");
        }
      }
    }
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    print("HMSPeerUpdate:- ${HMSPeerUpdate}");
    print("left:- ${HMSPeerUpdate.peerLeft}");
    print("update:- ${update}");
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (!peer.isLocal) {
          log('perrr remote role is ${peer.role.name}');
          if (peer.role.name == "livestreaming" ||
              peer.role.name == "audio-moderator") {
            remoteName.value = peer.name;
            isImHost.value = true;
            // _startLiveTimer("peerJoined");
          }
        } else {
          log('Local peer joined with role: ${peer.role.name}');
        }
        if (mounted) setState(() {});

        break;
      case HMSPeerUpdate.peerLeft:
        remoteVideoTracks.value.remove(peer.peerId);
        log('peer left ${peer.role.name} the room ${peer.name} and isLocal is ${peer.isLocal}');
        if (peer.peerId == hostPeer?.peerId) {
          log("🚨 Host has left the room → force everyone to leave");
          leaveMeeting();
        } else {
          myviewerCount.value = myviewerCount.value - 1;
        }
        if (mounted) setState(() {});

        break;

      case HMSPeerUpdate.roleUpdated:
        log('update roleUpdated ${peer.role.name}');
        log('peer.isLocal ${peer.isLocal}');
        if (peer.isLocal) {
          currentRole.value = peer.role.name;
          isBroadcaster.value = peer.role.name == "livestreaming";
          isAudioModerator.value = peer.role.name == "audio-moderator";
          if (peer.role.name == "livestreaming" ||
              peer.role.name == "audio-moderator") {
            _startLiveTimer("roleUpdated");
            remoteName.value = peer.name;
            isImHost.value = true;
          }
        } else {
          print("peer.role.name:- ${peer.role.name}");
          // START TIMER WHEN LOCAL USER BECOMES BROADCASTER OR AUDIO MODERATOR
          if (peer.role.name == "livestreaming" ||
              peer.role.name == "audio-moderator") {
            _startLiveTimer("isNotlocal");
            remoteName.value = peer.name;
            isImHost.value = true;
          }
        }
        if (mounted) setState(() {});

        break;
      default:
        return;
    }
  }

  @override
  void onTrackUpdate({
    required HMSTrack track,
    required HMSTrackUpdate trackUpdate,
    required HMSPeer peer,
  }) {
    if (track.kind == HMSTrackKind.kHMSTrackKindVideo) {
      log('on kHMSTrackKindVideo ${peer.name}');
      if (peer.isLocal) {
        log('on track Update localPeerVideoTrack is ${peer.name}');
        localPeerVideoTrack = track as HMSVideoTrack;
      } else {
        log('on track Update remotePeerVideoTrack is ${peer.name}');
        remoteVideoTracks.value[peer.peerId] = track as HMSVideoTrack;
      }
      if (mounted) setState(() {});
    } else if (track.kind == HMSTrackKind.kHMSTrackKindAudio) {
      if (peer.isLocal) {
        isMicMuted.value = track.isMute;
      } else {
        // remotePeerAudioTrack = track as HMSAudioTrack;
      }
    }
  }

  @override
  void onMessage({required HMSMessage message}) {
    try {
      final data = json.decode(message.message); // decode JSON
      MessageModel newMessage = MessageModel(
        message: data['message'] ?? "",
        userName: data['userName'] ?? "User",
        profile: data['profile'] ?? "", // image path here
        isMe: false,
        gift: null,
        createdAt: DateTime.parse(data['timestamp']),
      );

      log('Received message: ${newMessage.message}');

      _messageLock.synchronized(() {
        messageList.add(newMessage);
        reverseMessage.value = messageList.reversed.toList();
      });
    } catch (e) {
      log('Message handling error: $e');
    }
  }

  @override
  void onAudioDeviceChanged({
    HMSAudioDevice? currentAudioDevice,
    List<HMSAudioDevice>? availableAudioDevice,
  }) {
    if (currentAudioDevice == HMSAudioDevice.SPEAKER_PHONE) {
      isSpeakerOn.value = true;
    } else {
      isSpeakerOn.value = false;
    }
  }

  @override
  void onSessionStoreAvailable({HMSSessionStore? hmsSessionStore}) {
    log('onSessionStoreAvailable');
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    log('onChangeTrackStateRequest: ${hmsTrackChangeRequest.track.trackDescription}');
  }

  @override
  void onHMSError({required HMSException error}) {
    log('onHMSError: ${error.description}');
    log('onHMSError 1: ${error.action}');

    global.showToast(
        message: error.message!,
        bgColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  void onReconnected() {
    log('onReconnected');
  }

  @override
  void onReconnecting() {
    log('onReconnecting');
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {}
  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    log("Role change requested by: ${roleChangeRequest.suggestedBy?.name}");
    log("Role change requested role: ${roleChangeRequest.suggestedRole.name}");
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // log('onRoomUpdate: ${update.name}');
  }
  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // log('onUpdateSpeakers: ${updateSpeakers.length}');
  }
  @override
  void onPeerListUpdate(
      {required List<HMSPeer> addedPeers,
      required List<HMSPeer> removedPeers}) {}

  

  void _toggleMicMute() async {
    try {
      await liveController.hmsSDK?.toggleMicMuteState();
    } on Exception catch (e) {
      log('Error toggling mic mute state: $e');
    }
  }

  void _toggleVideo() async {
    await liveController.hmsSDK?.toggleCameraMuteState();
  }

  void _toggleSpeaker() async {
    if (isSpeakerOn.value) {
      liveController.hmsSDK?.switchAudioOutput(audioDevice: HMSAudioDevice.EARPIECE);
    } else {
      liveController.hmsSDK?.switchAudioOutput(audioDevice: HMSAudioDevice.SPEAKER_PHONE);
    }
  }

  Widget _buildBottomBar() {
    return Stack(
      children: [
        // Chat input at bottom center
        Positioned(
          bottom: 20,
          left: 20,
          right: 80,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(5.w),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            constraints: const BoxConstraints(
              minHeight: 48,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextField(
                      controller: messageController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        hintText: "Send a message...",
                        hintStyle: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          sendMessage(value);
                          messageController.clear();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8e44ad), Color(0xFF3498db)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.send, color: Colors.white, size: 20),
                    onPressed: () {
                      if (messageController.text.isNotEmpty) {
                        sendMessage(messageController.text);
                        messageController.clear();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // Vertical controls on right side
        Positioned(
          bottom: 20,
          right: 20,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Join as co-host button (only for viewers)
              ValueListenableBuilder<bool>(
                valueListenable: isBroadcaster,
                builder: (_, isBroadcaster, __) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isAudioModerator,
                    builder: (_, isAudioModerator, __) {
                      if (!isBroadcaster && !isAudioModerator) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(Icons.person_add, color: Colors.white),
                            onPressed: _showCallOptions,
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),

              // Mic Button (for broadcasters and audio moderators)
              ValueListenableBuilder<bool>(
                valueListenable: isBroadcaster,
                builder: (_, isBroadcaster, __) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isAudioModerator,
                    builder: (_, isAudioModerator, __) {
                      if (isBroadcaster || isAudioModerator) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: isMicMuted,
                          builder: (_, muted, __) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: muted
                                    ? Colors.red
                                    : Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  muted ? Icons.mic_off : Icons.mic,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleMicMute,
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),

              // Video Button (only for broadcasters, not audio moderators)
              ValueListenableBuilder<bool>(
                valueListenable: isBroadcaster,
                builder: (_, isBroadcaster, __) {
                  if (isBroadcaster) {
                    return ValueListenableBuilder<bool>(
                      valueListenable: isVideoOn,
                      builder: (_, videoOn, __) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: videoOn
                                ? Colors.black.withOpacity(0.7)
                                : Colors.red,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: IconButton(
                            icon: Icon(
                              videoOn ? Icons.videocam : Icons.videocam_off,
                              color: Colors.white,
                            ),
                            onPressed: _toggleVideo,
                          ),
                        );
                      },
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),

              // Speaker Button (for broadcasters and audio moderators)
              ValueListenableBuilder<bool>(
                valueListenable: isBroadcaster,
                builder: (_, isBroadcaster, __) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isAudioModerator,
                    builder: (_, isAudioModerator, __) {
                      if (isBroadcaster || isAudioModerator) {
                        return ValueListenableBuilder<bool>(
                          valueListenable: isSpeakerOn,
                          builder: (_, speakerOn, __) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: speakerOn
                                    ? Colors.black.withOpacity(0.7)
                                    : Colors.red,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                icon: Icon(
                                  speakerOn
                                      ? Icons.volume_up
                                      : Icons.volume_off,
                                  color: Colors.white,
                                ),
                                onPressed: _toggleSpeaker,
                              ),
                            );
                          },
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  );
                },
              ),

              // End Call Button
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.6),
                      blurRadius: 12,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.call_end, color: Colors.white),
                  onPressed: leaveMeeting,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // Dynamic video layout based on role
            ValueListenableBuilder(
              valueListenable: remoteVideoTracks,
              builder: (context, remoteVideoTracks, child) =>
                  ValueListenableBuilder<bool>(
                valueListenable: isBroadcaster,
                builder: (context, isBroadcaster, child) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: isAudioModerator,
                    builder: (context, isAudioModerator, child) {
                      // Show audio moderator UI (no video, just audio controls)
                      if (isAudioModerator) {
                        return Stack(
                          children: [
                            // Background for audio call
                            Container(
                              color: Colors.grey[900],
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: currentUserProfile
                                              .value.isNotEmpty
                                          ? NetworkImage(
                                              currentUserProfile.value)
                                          : AssetImage(
                                                  "assets/images/no_customer_image.png")
                                              as ImageProvider,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      peerUserId,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Audio Call",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              left: 10,
                              child: GetBuilder<LiveController>(
                                  builder: (liveastrologer) {
                                    return Container(
                                      width: 35.w,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.circle,
                                              color: Colors.white, size: 10),
                                          SizedBox(width: 6),
                                          ValueListenableBuilder<Duration>(
                                            valueListenable: liveDuration,
                                            builder: (_, duration, __) {
                                              return Text(
                                                "Time Left • ${liveController.minText}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              ),
                            ),

                            // Show remote video if available (for other broadcasters)
                            if (remoteVideoTracks.isNotEmpty)
                              Positioned(
                                top: 20,
                                right: 20,
                                width: 120,
                                height: 160,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: HMSVideoView(
                                    track: remoteVideoTracks.values.first,
                                    setMirror: false,
                                    scaleType: ScaleType.SCALE_ASPECT_FILL,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }

                      // Rest of your existing video layout logic for broadcasters and viewers
                      if (isBroadcaster &&
                          remoteVideoTracks.isNotEmpty &&
                          localPeerVideoTrack != null) {
                        // Split screen view when user is broadcaster with co-host
                        return Column(
                          children: [
                            // Partner's video (top half)
                            Expanded(
                              child: Stack(
                                children: [
                                  HMSVideoView(
                                    track: remoteVideoTracks.values.first,
                                    setMirror: false,
                                    scaleType: ScaleType.SCALE_ASPECT_FILL,
                                  ),
                                  // Partner name overlay
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: ValueListenableBuilder<String>(
                                        valueListenable: remoteName,
                                        builder: (_, name, __) {
                                          return Text(
                                            name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Divider with live indicator
                            Container(
                              height: 4,
                              color: Colors.red,
                              child: Center(
                                child: Container(
                                  width: 100,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "LIVE",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // User's own video (bottom half)
                            Expanded(
                              child: Stack(
                                children: [
                                  HMSVideoView(
                                    track: localPeerVideoTrack!,
                                    setMirror: true,
                                    scaleType: ScaleType.SCALE_ASPECT_FILL,
                                  ),
                                  // User name overlay with "You" indicator
                                  Positioned(
                                    top: 4.h,
                                    left: 5.w,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            currenUserName,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            "(You)",
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else if (remoteVideoTracks.isNotEmpty) {
                        // Single video view for viewers
                        // Multiple remote video view for viewers
                        final tracks = remoteVideoTracks.values.toList();
                        log('tracks length is ${tracks.length}');

                        return tracks.length > 1
                            ? Column(
                                children: [
                                  Expanded(
                                    child: HMSVideoView(
                                      track: tracks[0],
                                      setMirror: false,
                                      scaleType: ScaleType.SCALE_ASPECT_FILL,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Expanded(
                                    child: HMSVideoView(
                                      track: tracks[1],
                                      setMirror: false,
                                      scaleType: ScaleType.SCALE_ASPECT_FILL,
                                    ),
                                  )
                                ],
                              )
                            : Stack(
                                children: [
                                  HMSVideoView(
                                    track: tracks.first,
                                    setMirror: false,
                                    scaleType: ScaleType.SCALE_ASPECT_FILL,
                                  ),
                                ],
                              );
                      } else if (localPeerVideoTrack != null) {
                        // Only local video (waiting for host)
                        return Stack(
                          children: [
                            HMSVideoView(
                              track: localPeerVideoTrack!,
                              setMirror: true,
                              scaleType: ScaleType.SCALE_ASPECT_FILL,
                            ),
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  "Waiting for host to join...",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container(
                          color: Colors.black,
                          child: Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),

            // Top info bar with live timer and viewer count
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Live status and timer
                    ValueListenableBuilder<bool>(
                      valueListenable: isBroadcaster,
                      builder: (_, isBroadcaster, __) {
                        if (isBroadcaster) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.circle,
                                    color: Colors.white, size: 10),
                                SizedBox(width: 6),
                                ValueListenableBuilder<Duration>(
                                  valueListenable: liveDuration,
                                  builder: (_, duration, __) {
                                    return Text(
                                      "Time Left • ${liveController.minText}",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),

                    // Viewer count
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.remove_red_eye,
                              color: Colors.white, size: 14),
                          SizedBox(width: 6),
                          ValueListenableBuilder<int>(
                            valueListenable: myviewerCount,
                            builder: (_, count, __) {
                              return Text(
                                "$count",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Chat messages
            Positioned(
              bottom: 100,
              left: 10,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ValueListenableBuilder<List<MessageModel>>(
                  valueListenable: reverseMessage,
                  builder: (context, messages, child) => messages.isEmpty
                      ? SizedBox()
                      : SizedBox(
                          height: 200,
                          child: ListView.builder(
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {

                              print("name: ${messages[index].profile}");
                              return Container(
                                margin: EdgeInsets.symmetric(vertical: 4),
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: messages[index]
                                                  .profile ==
                                              ""? NetworkImage(
                                          global.user.profile.toString()
                                      )
                                          : NetworkImage(
                                              messages[index].profile!)
                                         
                                              as ImageProvider,
                                      radius: 15,
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            messages[index].userName!.isEmpty? global.user.name.toString(): messages[index].userName??"User",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            messages[index].message ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ),

            // Bottom bar with controls
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    _stopLiveTimer();
    liveController.hmsSDK?.removeUpdateListener(listener: this);
    liveController.hmsSDK?.destroy();
    super.dispose();
  }
}
