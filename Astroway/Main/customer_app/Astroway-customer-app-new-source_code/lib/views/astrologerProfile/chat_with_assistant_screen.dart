// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/astrologer_assistant_controller.dart';
import 'package:AstrowayCustomer/model/chat_message_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChatWithAstrologerAssistantScreen extends StatelessWidget {
  final int flagId;
  final String profileImage;
  final String astrologerName;
  final String fireBasechatId;
  final int chatId;
  final int astrologerId;
  String fcmtoken;
  ChatWithAstrologerAssistantScreen({
    super.key,
    required this.flagId,
    required this.profileImage,
    required this.astrologerName,
    required this.fireBasechatId,
    required this.astrologerId,
    required this.chatId,
    required this.fcmtoken,
  });
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        global.isInAssistantScreen=false;
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () async {},
              child: Text("$astrologerName's ${tr("Assistant")}"),
            ),
            leading: IconButton(
              onPressed: () async {
                global.isInAssistantScreen=false;
                Get.back();
              },
              icon: Icon(Icons.arrow_back),
            ),
          ),
          body: Container(
            color: Colors.white,
            child: Stack(
              children: [
                GetBuilder<AstrologerAssistantController>(
                    builder: (astrologerAssistantController) {
                      return Column(
                        children: [
                          Expanded(
                            child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                                stream:
                                astrologerAssistantController.getChatMessages(
                                    fireBasechatId, global.currentUserId),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState.name == "waiting") {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else {
                                    if (snapshot.hasError) {
                                      return Text(
                                          'snapShotError :- ${snapshot.error}');
                                    } else {
                                      List<ChatMessageModel> messageList = [];
                                      for (var res in snapshot.data!.docs) {
                                        messageList.add(
                                            ChatMessageModel.fromJson(res.data()));
                                      }
                                      print(messageList.length);
                                      return ListView.builder(
                                          padding:
                                          const EdgeInsets.only(bottom: 50),
                                          itemCount: messageList.length,
                                          shrinkWrap: true,
                                          reverse: true,
                                          itemBuilder: (context, index) {
                                            ChatMessageModel message =
                                            messageList[index];
                                            astrologerAssistantController.isMe =
                                                message.userId1 ==
                                                    '${global.currentUserId}';
                                            return Row(
                                              mainAxisAlignment:
                                              astrologerAssistantController.isMe
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color:
                                                    astrologerAssistantController
                                                        .isMe
                                                        ? Color(0xFFfbf1f2)
                                                        : Colors.grey.shade200,
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(5.w),
                                                      topRight:
                                                      astrologerAssistantController
                                                          .isMe
                                                          ? Radius.circular(5.w)
                                                          : const Radius
                                                          .circular(0),
                                                      bottomLeft:
                                                      astrologerAssistantController
                                                          .isMe
                                                          ? const Radius
                                                          .circular(0)
                                                          : Radius.circular(
                                                          5.w),
                                                      bottomRight:
                                                      astrologerAssistantController
                                                          .isMe
                                                          ? Radius.circular(5.w)
                                                          : Radius.circular(
                                                          5.w),
                                                    ),
                                                  ),
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                                  margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 16),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    astrologerAssistantController
                                                        .isMe
                                                        ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        messageList[index].message!,
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                        ),
                                                        textAlign:
                                                        astrologerAssistantController
                                                            .isMe
                                                            ? TextAlign.end
                                                            : TextAlign.start,
                                                      ),
                                                      messageList[index]
                                                          .createdAt !=
                                                          null
                                                          ? Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(top: 2),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .end,
                                                          children: [
                                                            Text(
                                                                DateFormat()
                                                                    .add_jm()
                                                                    .format(messageList[
                                                                index]
                                                                    .createdAt!),
                                                                style:
                                                                const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                  9.5,
                                                                )),
                                                          ],
                                                        ),
                                                      )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          });
                                    }
                                  }
                                }),
                          ),
                        ],
                      );
                    }),
                SizedBox(height: 2),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 2),
                    padding: const EdgeInsets.all(8),
                    child: GetBuilder<AstrologerAssistantController>(
                        builder: (astrologerAssistantController) {
                          return Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(2.w),
                                        bottomRight: Radius.circular(2.w),
                                      )),
                                  child: TextFormField(
                                    maxLines: 6,
                                    minLines: 1,
                                    controller: messageController,
                                    onChanged: (value) {},
                                    cursorColor: Colors.black,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: 'Enter message here',
                                      hintStyle:
                                      TextStyle(color: Colors.grey.shade600),
                                      contentPadding: EdgeInsets.only(left: 2.w),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(2.w),
                                          bottomRight: Radius.circular(2.w),
                                        ),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(2.w),
                                            bottomRight: Radius.circular(2.w)),
                                        borderSide: BorderSide(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Material(
                                  elevation: 3,
                                  color: Colors.transparent,
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                  child: Container(
                                    height: 49,
                                    width: 49,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade700,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    child: InkWell(
                                      onTap: () {
                                        if (messageController.text != "") {
                                          String sanitizedMessage = maskSensitiveData(messageController.text);
                                          global.callOnFcmApiSendPushNotifications(
                                              fcmTokem: [fcmtoken],
                                              title: "Assistant Chat",
                                              subTitle: "New message from ${global.user.name}",
                                              name: "Assistant Chat"

                                          );
                                          astrologerAssistantController.sendMessage(
                                            sanitizedMessage,
                                            fireBasechatId,
                                            astrologerId,
                                          );
                                          messageController.clear();
                                        }
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.only(left: 5.0),
                                        child: Icon(
                                          Icons.send,
                                          size: 25,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  String maskSensitiveData(String text) {
    // Mask emails
    final emailRegex = RegExp(r'([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})');
    text = text.replaceAllMapped(emailRegex, (match) {
      final email = match.group(0)!;
      final masked =
          '***${email.substring(email.length - 3)}***'; // last 3 visible
      return masked;
    });

    // Mask phone numbers (10–12 digits)
    final phoneRegex = RegExp(r'\b\d{10,12}\b');
    text = text.replaceAllMapped(phoneRegex, (match) {
      final phone = match.group(0)!;
      final masked =
          '***${phone.substring(phone.length - 3)}***'; // last 3 visible
      return masked;
    });

    return text;
  }
}
