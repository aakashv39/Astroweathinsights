// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:developer';
import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';

class KundliDetailsScreen extends StatefulWidget {
  String pdfLink;
  KundliDetailsScreen({required this.pdfLink}) : super();
  @override
  State<KundliDetailsScreen> createState() => _KundliDetailsScreenState();
}

class _KundliDetailsScreenState extends State<KundliDetailsScreen> {
  final kundliController = Get.find<KundliController>();
  final splashController = Get.find<SplashController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Kundli').tr(),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () async {
              await Share.share(
                "Hey! I am using AstrowayPro to get predictions related to marriage/career.Check my Kundali with .You should also try and see your Kundali ! \n\n\n\n"
                "${widget.pdfLink}",
              );
            },
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(5)),
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.4.h),
              child: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    "Share",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          SizedBox(width: 2.w),
          InkWell(
              onTap: () async {
                if (await canLaunch(widget.pdfLink)) {
                  await launchUrl(
                    mode: LaunchMode.externalApplication,
                    Uri.parse(widget.pdfLink),
                  );
                } else {
                  print("error in laucnhing url");
                }
              },
              child: CircleAvatar(
                  radius: 17,
                  backgroundColor: Colors.black,
                  child:
                      Icon(Icons.download, color: Colors.white, size: 18.sp))),
          SizedBox(width: 4.w),
        ],
      ),
      body: Container(
        child: SfPdfViewer.network(
          widget.pdfLink,
          onDocumentLoadFailed: (e) {
            Fluttertoast.showToast(msg: "PDF Failed to Load");
            Get.back();
          },
          onDocumentLoaded: (e) {
            log('error in loading pdf ${e}');
          },
        ),
      ),
    );
  }
}
