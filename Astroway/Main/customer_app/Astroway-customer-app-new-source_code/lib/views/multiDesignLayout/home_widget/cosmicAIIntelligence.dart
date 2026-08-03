// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/constants/appConstant.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:AstrowayCustomer/controllers/walletController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/views/addMoneyToWallet.dart';
import 'package:AstrowayCustomer/views/chatwithAI/aichatscreen.dart';
import 'package:AstrowayCustomer/views/chatwithAI/controllers/aiChatController.dart';
import 'package:AstrowayCustomer/views/multiDesignLayout/home_widget/rippleAnimation.dart';
import 'package:AstrowayCustomer/views/profile/editUserProfileScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final aicontroller = Get.find<AiChatController>();
final splashController = Get.find<SplashController>();
final walletController = Get.find<WalletController>();

class CosmicAIIntelligence extends StatelessWidget {
  CosmicAIIntelligence({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      color: const Color(0xFFE1F7FF),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 30.w, child: RippleAnimation()),
          Text("CosmicAI",
                  style: Get.theme.textTheme.bodyMedium!.copyWith(
                      color: blackColor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500))
              .tr(),
          Text("Your Personalized AI Intelligence",
                  style: Get.theme.textTheme.bodyMedium!.copyWith(
                      color: blackColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400))
              .tr(),
          SizedBox(height: 20),
          AnimatedHintTextField(
              onTap: () {
                showAiChatDialog(
                    context: context,
                    systemMessage:
                        RandomStringPicker(myStrings).getRandomString());
              },
              controller: aicontroller.messageController),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text("Suggested Cosmic Questions",
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                    color: blackColor,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400)),
          ),
          CosmicQuestionCard(
              text: AppConstants.COSMICAI_MSG1,
              onTap: () {
                showAiChatDialog(
                    context: context,
                    systemMessage: AppConstants.COSMICAI_MSG1);
              }),
          CosmicQuestionCard(
            text: AppConstants.COSMICAI_MSG2,
            onTap: () {
              showAiChatDialog(
                  context: context, systemMessage: AppConstants.COSMICAI_MSG2);
            },
          ),
          CosmicQuestionCard(
            text: AppConstants.COSMICAI_MSG3,
            onTap: () {
              showAiChatDialog(
                  context: context, systemMessage: AppConstants.COSMICAI_MSG3);
            },
          ),
        ],
      ),
    );
  }
}

class CosmicQuestionCard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CosmicQuestionCard({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0D3128),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(CupertinoIcons.bolt, color: Colors.yellowAccent, size: 25),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(CupertinoIcons.forward, color: Colors.yellowAccent, size: 25),
          ],
        ),
      ),
    );
  }
}

Future<dynamic> showAiChatDialog(
    {required BuildContext context, required String systemMessage}) async {
  global.showOnlyLoaderDialog(context);
  await aicontroller.getAIChatAstrologerId();
  await aicontroller.getcharge();
  aicontroller.update();
  global.hideLoader();
  Get.dialog(
    AlertDialog(
      backgroundColor: Colors.white,
      contentPadding:
          const EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 30),
      titlePadding: const EdgeInsets.all(10),
      title: Align(
          alignment: Alignment.center,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Get.theme.primaryColor)),
            child: CircleAvatar(
              radius: 30,
              backgroundColor: Get.theme.primaryColor.withOpacity(0.5),
              child: Icon(
                aicontroller.islowBalance
                    ? aicontroller.aichatcharge!.message ==
                            tr('Please update your profile.')
                        ? Icons.person
                        : Icons.wallet
                    : Icons.question_mark,
                color: Colors.red,
              ),
            ),
          )),
      content: Text(
        '${aicontroller.aichatcharge!.message}',
        style: Get.textTheme.bodyMedium,
      ).tr(),
      actions: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Get.back();
            },
            child: Text(
              'No',
              style: Get.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ).tr()),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () async {
              if (aicontroller.aichatcharge!.message ==
                  "Please update your profile.") {
                Get.back();
                bool isLogin = await global.isLogin();
                if (isLogin) {
                  global.showOnlyLoaderDialog(context);
                  await splashController.getCurrentUserData();
                  global.hideLoader();
                  Get.to(() => EditUserProfile());
                }
              } else if (aicontroller.islowBalance) {
                Get.back();
                bool isLogin = await global.isLogin();
                global.showOnlyLoaderDialog(context);
                await global.splashController.getCurrentUserData();
                await walletController.getAmount();
                walletController.update();
                splashController.update();
                global.hideLoader();
                if (isLogin) {
                  Get.to(() => AddmoneyToWallet());
                }
              } else {
                Get.back();
                Get.to(() => AiChatScreen(
                      name:
                          '${aicontroller.aiAstrologerId?.recordList?.name ?? 'User'}',
                      imagepath:
                          '${aicontroller.aiAstrologerId!.recordList!.image}',
                      id: aicontroller.aiAstrologerId!.recordList!.id,
                      isfromCosmic: true,
                      systemMessage: systemMessage,
                    ));
              }
            },
            child: Text(
              aicontroller.islowBalance
                  ? aicontroller.aichatcharge!.message ==
                          'Please update your profile.'
                      ? tr('Update')
                      : tr('TopUp')
                  : 'Yes',
              style: Get.textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500),
            ).tr())
      ],
    ),
  );
}
