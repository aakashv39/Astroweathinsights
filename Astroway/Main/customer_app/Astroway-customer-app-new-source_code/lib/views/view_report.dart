import 'dart:developer';
import 'package:AstrowayCustomer/controllers/history_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:AstrowayCustomer/utils/config.dart';

// ignore: must_be_immutable
class ViewReportScreen extends StatelessWidget {
  int? index;
  ViewReportScreen({Key? key, this.index}) : super(key: key);
  HistoryController historyController = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    log('pdf url is ${'$websiteUrl/${historyController.reportHistoryList[index!].reportFile}'}');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.theme.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          'View Report',
        ).tr(),
      ),
      body: SfPdfViewer.network(
          '$websiteUrl/${historyController.reportHistoryList[index!].reportFile}',
          enableDocumentLinkAnnotation: false),
    );
  }
}
