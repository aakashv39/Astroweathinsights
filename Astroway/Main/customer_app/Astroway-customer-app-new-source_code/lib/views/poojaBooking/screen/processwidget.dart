import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controller/poojaController.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;

class processwidget extends StatelessWidget {
  const processwidget({
    super.key,
    required this.poojacontroller,
  });

  final PoojaController poojacontroller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(
        poojacontroller.pujaprocessItems.length,
        (index) {
          return Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 1.5.h,
                      backgroundColor: Colors.blue,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Container(
                      width: 85.w,
                      child: global.buildTranslatedText(
                        '${poojacontroller.pujaprocessItems[index]['title']!}',
                        Get.theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.w),
                Container(
                  width: 100.w,
                  child: global.buildTranslatedText(
                    '${poojacontroller.pujaprocessItems[index]['description']!}',
                    Get.theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
