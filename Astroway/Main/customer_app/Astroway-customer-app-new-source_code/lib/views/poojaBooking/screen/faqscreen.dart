import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controller/poojaController.dart';

class FAQScreen extends StatefulWidget {
  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final poojacontroller = Get.put(PoojaController());
  @override
  void initState() {
    super.initState();
    getfaqlist();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PoojaController>(
      builder: (poojacontroller) => poojacontroller.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : poojacontroller.faqList == null ||
                  poojacontroller.faqList?.isEmpty == true
              ? Center(
                  child: Text("No FaQ's Available").tr(),
                )
              : ListView.builder(
                  itemCount: poojacontroller.faqList!.length,
                  itemBuilder: (context, index) {
                    return ExpansionTile(
                      title: Text(
                        poojacontroller.faqList![index].title!,
                        style: Get.theme.textTheme.bodyMedium!.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            poojacontroller.faqList![index].description!,
                            style: Get.theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
    );
  }

  void getfaqlist() async {
    await poojacontroller.getfaqlist();
  }
}
