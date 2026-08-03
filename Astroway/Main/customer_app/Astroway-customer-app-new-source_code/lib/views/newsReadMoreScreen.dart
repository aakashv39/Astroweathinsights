// ignore_for_file: must_be_immutable

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class Newsreadmorescreen extends StatelessWidget {
  String link;

   Newsreadmorescreen({super.key,required this.link});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(
          title: Text(
            'Astrology News',
          ).tr(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
         ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(link)),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
          transparentBackground: true,
        ),
        onProgressChanged: (controller, progress) {
          debugPrint('onProgressChanged progress$progress');
        },
        onReceivedError: (controller, request, error) {
          debugPrint('Terms condition error: $error');
        },
        onLoadStop: (controller, url) {},
        onWebViewCreated: (controller) {},
        onConsoleMessage: (controller, consoleMessage) {
          debugPrint('console web $consoleMessage');
        },
      ),
    );
  }
}
