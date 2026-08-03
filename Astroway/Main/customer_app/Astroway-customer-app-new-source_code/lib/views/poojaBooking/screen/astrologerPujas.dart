import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../utils/global.dart' as global;
import 'addpoojadeveryaddress.dart';

class PujaDetailScreen extends StatelessWidget {
  final dynamic pujaName;
  final dynamic description;
  final List<String>? images;
  final dynamic price;
  final dynamic duration;
  final List<String> benefits;
  final String startTime;
  final dynamic poojadetail;

  const PujaDetailScreen({
    super.key,
    required this.pujaName,
    required this.description,
    required this.images,
    required this.price,
    required this.startTime,
    required this.duration,
    required this.benefits,
    required this.poojadetail,
  });

  /// 🔹 Format String -> DateTime -> 12hr format
  String _formatDateTime(String rawDateTime) {
    try {
      final dateTime = DateTime.parse(rawDateTime); // expects "yyyy-MM-dd HH:mm:ss"
      return DateFormat("dd MMM yyyy, hh:mm a").format(dateTime);
    } catch (e) {
      return rawDateTime; // if parse fails, return as is
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartTime = _formatDateTime(startTime);

    print("image:- ${images}");
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(pujaName),
          backgroundColor: Get.theme.primaryColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Images (swipe if multiple)
              if (images!.isNotEmpty)
                images!.length > 1
                    ? CarouselSlider(
                  options: CarouselOptions(
                    height: 220,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    autoPlay: true,
                  ),
                  items: images!
                      .map((url) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ))
                      .toList(),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    images!.first,
                    height: 220,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
      
              const SizedBox(height: 16),
      
              /// 🔹 Title + Price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(pujaName,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold)),
                    global.getSystemFlagValueForLogin(global.systemFlagNameList.walletType)=="Wallet"?
                    Text("${global.getSystemFlagValueForLogin(global.systemFlagNameList.currency)} $price",
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.green)):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(" ${price.toString().split('.').first}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                        SizedBox(width: 1.w,),
                        Image.network(global.getSystemFlagValueForLogin(global.systemFlagNameList.coinIcon),height: 1.6.h,),

                      ],
                    ),
                  ],
                ),
              ),
      
              const SizedBox(height: 8),

              /// 🔹 Duration + Start Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Duration: $duration",
                        style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 4),
                    Text("Start Time: $formattedStartTime",
                        style: const TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
      
              const Divider(height: 30),
      
              /// 🔹 Description
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text("About Puja",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(description,
                    style: const TextStyle(fontSize: 16, height: 1.5)),
              ),
      
              /// 🔹 Benefits
              if (benefits.isNotEmpty) ...[
                const Divider(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Benefits",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: benefits
                        .map((b) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Text(b,
                                  style: const TextStyle(fontSize: 16))),
                        ],
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ],
      
              const SizedBox(height: 80),
            ],
          ),
        ),
      
        /// 🔹 Bottom Button
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Get.theme.primaryColor,
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              Get.to(
                    () =>
                    AddPoojaDeliveryAddress(
                      selectedpackage:
                      null,
                      poojadetail:
                      poojadetail,
                      index:
                      0,
                      isfrommycustomproduct:
                      true,
                    ),
              );
              // 👉 Navigate to booking/scheduling screen
              // Navigator.push(context, MaterialPageRoute(builder: (_) => BookingScreen()));
            },
            child: const Text("Book Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
