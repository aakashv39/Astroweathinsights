// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:AstrowayCustomer/utils/images.dart';
import 'package:AstrowayCustomer/widget/CanvasStyle/topWaveCliper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BottomInfoCard extends StatelessWidget {
  const BottomInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: WaveClipper(top: true, bottom: false),
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.black26),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10)
              .copyWith(bottom: 80),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoItem(
                  image: Images.confidential,
                  title: 'Private &\nConfidential',
                  iconheight: 15,
                  color: const Color(0xFF001AFF)),
              _buildInfoItem(
                  image: Images.verifiedAccount,
                  title:
                      'Verified \n${global.getSystemFlagValueForLogin(global.systemFlagNameList.professionTitle)}',
                  isTranslated: false,
                  useGlobalText: true,
                  iconheight: 15,
                  color: const Color(0xFFFF1100)),
              _buildInfoItem(
                  image: Images.payment,
                  title: 'Secure\nPayments',
                  color: const Color(0xFF023D35)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required String image,
    required String title,
    required Color color,
    double? iconheight,
    bool isTranslated = true,
    bool useGlobalText = false,
  }) {
    final textStyle = Get.theme.textTheme.titleMedium!.copyWith(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: color,
      letterSpacing: 0.5,
    );

    Widget textWidget;
    if (useGlobalText) {
      textWidget = global.buildTranslatedText(title, textStyle);
    } else if (isTranslated) {
      textWidget = Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle,
      ).tr();
    } else {
      textWidget = Text(
        title,
        textAlign: TextAlign.center,
        style: textStyle,
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 1),
            color: color.withOpacity(0.1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Image.asset(
              image,
              color: color,
              height: iconheight ?? 42,
            ),
          ),
        ),
        SizedBox(height: 15),
        textWidget,
      ],
    );
  }
}
