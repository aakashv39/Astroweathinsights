// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffbgcolor,
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text('Feedback', style: TextStyle(color: Colors.white)).tr(),
        ),
        body: GetBuilder<HomeController>(
          builder: (homeController) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Get.theme.primaryColor.withOpacity(0.8),
                            Get.theme.primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Get.theme.primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.feedback_outlined,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  'We Value Your Opinion',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                ).tr(),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Your feedback helps us create a better experience for you',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14.sp,
                              height: 1.4,
                            ),
                          ).tr(),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Share Your Thoughts',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ).tr(),
                          SizedBox(height: 8),
                          Text(
                            'Tell us what you love or what we can improve',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[600],
                            ),
                          ).tr(),
                          SizedBox(height: 20),

                          // Feedback Input Field
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1.5,
                              ),
                            ),
                            child: TextFormField(
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.black87,
                              ),
                              controller: homeController.feedbackController,
                              maxLines: 10,
                              minLines: 8,
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(15),
                                border: InputBorder.none,
                                hintText:
                                    tr('Start typing your feedback here...'),
                                hintStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[400],
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 20),

                          // Character count (optional)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${homeController.feedbackController.text.length} ',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                                Text(
                                  'characters',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            );
          },
        ),
        bottomSheet: GetBuilder<HomeController>(builder: (homeController) {
          return Container(
            width: double.infinity,
            color: Colors.white,
            padding:
                EdgeInsets.only(left: 4.w, right: 4.w, top: 1.w, bottom: 4.w),
            height: 70,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Get.theme.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.w),
                ),
                shadowColor: Get.theme.primaryColor.withOpacity(0.3),
              ),
              onPressed: () async {
                bool isLogin = await global.isLogin();
                if (isLogin) {
                  if (homeController.feedbackController.text.trim().isEmpty) {
                    global.showToast(
                      message: tr('Please enter your feedback'),
                      textColor: global.textColor,
                      bgColor: global.toastBackGoundColor,
                    );
                  } else {
                    homeController.feedbackFocusNode.unfocus();
                    await homeController.addFeedback(
                      homeController.feedbackController.text.trim(),
                    );
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Submit Feedback',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ).tr(),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
