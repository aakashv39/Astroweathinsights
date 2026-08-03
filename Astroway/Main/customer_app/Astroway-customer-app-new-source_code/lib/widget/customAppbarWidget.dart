import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Function onBackPressed;
  final List<Widget> actions;
  final Color bgColor;
  final TextStyle titleStyle;
  final int flagId;

  final int? flagforCategory;
  CustomAppBar(
      {required this.title,
      required this.bgColor,
      this.flagId = 0,
      required this.onBackPressed,
      required this.actions,
      required this.titleStyle,

      this.flagforCategory});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: bgColor,
      leading: InkWell(
        onTap: () {
          if (flagforCategory == 1) {
            Get.back();
          } else {

          }
        },
        child: Icon(
            flagId == 1
                ? Icons.chat
                : (flagId == 2
                    ? (flagforCategory == 0 ? Icons.phone : Icons.arrow_back)
                    : Icons.menu),
            color: Colors.white //Get.theme.iconTheme.color,
            ),
      ),
      title: Text(
        title,
        style: titleStyle,
      ).tr(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
