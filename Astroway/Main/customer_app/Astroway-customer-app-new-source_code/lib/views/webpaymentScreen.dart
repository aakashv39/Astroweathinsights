// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/callController.dart';
import '../controllers/history_controller.dart';
import '../utils/global.dart' as global;
import '../utils/inapp_review.dart';
import 'bottomNavigationBarScreen.dart';

class PaymentScreen extends StatefulWidget {
  String url;
  PaymentScreen({super.key, required this.url});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late InAppWebViewController _controller;
  final historyController = Get.find<HistoryController>();
  bool _isProcessing = false; // Prevent duplicate handling

  @override
  void initState() {
    super.initState();
    log("lkshfks fjosf ${widget.url}");
  }

  void _handlePaymentSuccess() async {
    if (_isProcessing) return;
    _isProcessing = true;

    log('===== PAYMENT SUCCESS HANDLER CALLED =====');

    await global.splashController.getCurrentUserData();
    await historyController.getChatHistory(global.currentUserId!, false);
    if (global.iscomingFrom == 1) {
      global.iscomingFrom = 0;
      //coming form puja when low balance
      final callController = Get.find<CallController>();
      callController.setTabIndex(0);
      Get.off(() => BottomNavigationBarScreen(index: 4));
      Fluttertoast.showToast(
        msg: "Puja Ordered sucessfully",
        backgroundColor: Get.theme.primaryColor,
        textColor: Colors.white,
      );
    } else {
      //not coming from puja low balance
      Get.off(() => BottomNavigationBarScreen(index: 0));
      await ReviewService.requestForReview();
      Fluttertoast.showToast(
        msg: "Payment Success!",
        backgroundColor: Get.theme.primaryColor,
        textColor: Colors.white,
      );
    }
  }

  void _handlePaymentFailure() {
    if (_isProcessing) return;
    _isProcessing = true;

    log('===== PAYMENT FAILURE HANDLER CALLED =====');

    Get.off(() => BottomNavigationBarScreen(index: 0));
    Fluttertoast.showToast(
      msg: "Payment Failed!",
      backgroundColor: Get.theme.primaryColor,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Returning false disables back button
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            leading: SizedBox(),
            title: Text("Payment"),
            actions: [
              InkWell(
                onTap: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.w),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.w),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Colors.red.shade50, Colors.white],
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Icon with animated container
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.payment,
                                size: 48,
                                color: Colors.red,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Title
                            Text(
                              "Cancel Payment?",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Content
                            Text(
                              "Are you sure you want to cancel this payment?\nThis action cannot be undone.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Buttons in a row
                            Row(
                              children: [
                                // No Button
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: const Text(
                                      "No, Keep It",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      "Yes, Cancel",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                  if (confirm == true) {
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 10,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade300, Colors.red.shade800],
                    ),
                    borderRadius: BorderRadius.circular(30.w),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.cancel, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        "Cancel Payment",
                        style: TextStyle(
                          fontSize: 17.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
        body: InAppWebView(
          initialUrlRequest: URLRequest(url: WebUri(widget.url)),
          initialSettings: InAppWebViewSettings(
            cacheEnabled: true,
            javaScriptEnabled: true,
            javaScriptCanOpenWindowsAutomatically: true,
            useShouldOverrideUrlLoading: true,
            userAgent:
                "Mozilla/5.0 (Linux; Android 14) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/134.0.0.0 Mobile Safari/537.36",
          ),
          onReceivedError: (controller, request, error) {
            print('error url: ${request.url}');
            print('error method: ${request.method}');
            print('error headers: ${request.headers}');
            print('error isRedirect: ${request.isRedirect}');
            print('error : ${error.toString()}');
          },
          onLoadResource: (controller, resource) {
            log('onLoadResource : $resource');
          },
          onLoadStart: (controller, url) {
            log('start url: ${url.toString()}');
          },
          onReceivedHttpError: (controller, request, error) {
            log('http error: ${error.toString()} and req is $request');
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var url = navigationAction.request.url.toString();
            debugPrint("Intercepted URL: $url");
            if (url.startsWith("truecallersdk://")) {
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(
                  Uri.parse(url),
                  mode: LaunchMode.externalApplication,
                );
              }
              return NavigationActionPolicy.CANCEL;
            }
            if (url.startsWith("upi:") ||
                url.startsWith("gpay:") ||
                url.startsWith("phonepe:") ||
                url.startsWith("paytmmp:") ||
                url.startsWith("intent:")) {
              try {
                if (url.startsWith("intent:")) {
                  final regex = RegExp(r'upi://.*?(?=#|$)');
                  final match = regex.firstMatch(url);
                  if (match != null) {
                    url = match.group(0)!;
                  }
                }
                debugPrint("Launching UPI URL: $url");
                final uri = Uri.parse(url);
                print("URI:- ${uri}");
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (e) {
                debugPrint("Error launching UPI app: $e");
              }
              return NavigationActionPolicy.CANCEL;
            }
            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) async {
            final urlString = url.toString();
            log('=====onLoadStop called=====');
            log('Full URL: $urlString');
            if (urlString.contains("payment-success") ||
                urlString.contains("payment_success") ||
                urlString.contains("success=true") ||
                urlString.toLowerCase().contains("paymentsuccess")) {
              log('✅ Payment Success URL detected!');
              _handlePaymentSuccess();
            } else if (urlString.contains("payment-failed") ||
                urlString.contains("payment_failed") ||
                urlString.contains("payment-failure") ||
                urlString.contains("success=false") ||
                urlString.toLowerCase().contains("paymentfailed")) {
              log('❌ Payment Failed URL detected!');
              _handlePaymentFailure();
            } else if (urlString.contains("payment-process")) {
              log('⏳ Payment is still processing at: $urlString');
            } else {
              log('ℹ️ Other URL loaded: $urlString');
            }
          },
          onWebViewCreated: (webviewcontroller) {
            _controller = webviewcontroller;
            log('===== WebView Created =====');

            // JavaScript handler for payment success
            _controller.addJavaScriptHandler(
              handlerName: 'PaymentSuccess',
              callback: (args) {
                log(
                  '✅ JavaScript PaymentSuccess handler called with args: ${args.toString()}',
                );
                _handlePaymentSuccess();
              },
            );

            // JavaScript handler for payment failure
            _controller.addJavaScriptHandler(
              handlerName: 'PaymentFailed',
              callback: (args) {
                log(
                  '❌ JavaScript PaymentFailed handler called with args: ${args.toString()}',
                );
                _handlePaymentFailure();
              },
            );

            // Additional handlers for common Razorpay callbacks
            _controller.addJavaScriptHandler(
              handlerName: 'razorpay_payment_success',
              callback: (args) {
                log('✅ Razorpay success handler called: ${args.toString()}');
                _handlePaymentSuccess();
              },
            );

            _controller.addJavaScriptHandler(
              handlerName: 'razorpay_payment_failed',
              callback: (args) {
                log('❌ Razorpay failure handler called: ${args.toString()}');
                _handlePaymentFailure();
              },
            );
          },
        ),
      ),
    );
  }
}
