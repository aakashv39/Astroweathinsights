// ignore_for_file: deprecated_member_use

import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:AstrowayCustomer/views/poojaBooking/screen/poojabookingScreen.dart';
import 'package:AstrowayCustomer/widget/commonCachedNetworkImage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controller/poojaController.dart';

class PujaCategoryScreen extends StatefulWidget {
  const PujaCategoryScreen({super.key});

  @override
  State<PujaCategoryScreen> createState() => _PoojabookingscreenState();
}

class _PoojabookingscreenState extends State<PujaCategoryScreen> {
  final poojaController = Get.find<PoojaController>();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      poojaController.getPoojaCategoriesList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffbgcolor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Get.theme.primaryColor,
        title:
            Text("Puja Category", style: TextStyle(color: Colors.white)).tr(),
      ),
      body: GetBuilder<PoojaController>(
        builder: (poojaController) {
          if (poojaController.poojaCatglist == null ||
              poojaController.poojaCatglist.toString() == "null") {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: 6, // skeleton count
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Skeletonizer(
                    enabled: true,
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: poojaController.poojaCatglist?.length ?? 0,
            itemBuilder: (context, index) {
              final category = poojaController.poojaCatglist![index];
              print("Puja Category image ${category.image}");
              return InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  Get.to(
                      () => Poojabookingscreen(catId: category.id.toString()));
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      CommonCachedNetworkImage(
                          width: double.infinity,
                          height: 200,
                          borderRadius: 3.w,
                          imageUrl: "${category.image}"),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(3.w)),
                            color: Colors.black45),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                category.name ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: whiteColor,
                                  fontSize: 18.sp,
                                ),
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
