import 'package:AstrowayCustomer/controllers/settings_controller.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BlockedAstrologerBanner extends StatelessWidget {
  final int astrologerId;
  final SettingsController settingsController;

  const BlockedAstrologerBanner({
    Key? key,
    required this.astrologerId,
    required this.settingsController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.red),
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'You have blocked the astrologer',
            style:
                Get.theme.textTheme.bodyMedium!.copyWith(color: Colors.white),
          ).tr(),
          InkWell(
            onTap: () async {
              global.showOnlyLoaderDialog(context);
              await settingsController.unblockAstrologer(astrologerId);
              global.hideLoader();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.w),
                  color: Colors.white12,
                  border: Border.all(color: Colors.white, width: 0.5)),
              child: Text(
                'Unblock',
                style: Get.theme.primaryTextTheme.bodySmall!
                    .copyWith(color: Colors.white),
              ).tr(),
            ),
          )
        ],
      ),
    );
  }
}
