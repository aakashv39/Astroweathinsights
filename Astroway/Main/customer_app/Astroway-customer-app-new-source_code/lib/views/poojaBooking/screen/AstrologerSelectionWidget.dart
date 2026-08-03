import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../controllers/bottomNavigationController.dart';
import '../../../model/astrologer_model.dart';

import '../../../utils/global.dart' as global;
import '../../../utils/images.dart';

class AstrologerSelectionWidget extends StatefulWidget {
  final Function(AstrologerModel) onSelect;

  const AstrologerSelectionWidget({Key? key, required this.onSelect})
      : super(key: key);

  @override
  _AstrologerSelectionWidgetState createState() =>
      _AstrologerSelectionWidgetState();
}

class _AstrologerSelectionWidgetState extends State<AstrologerSelectionWidget> {
  final searchController = TextEditingController();
  List<AstrologerModel> filteredAstrologers = [];

  @override
  void initState() {
    super.initState();
    filteredAstrologers =
        Get.find<BottomNavigationController>().astrologercheckoutList;
  }

  void filterAstrologers(String query) {
    log('Inside query: $query');

    setState(() {
      filteredAstrologers = Get.find<BottomNavigationController>()
          .astrologercheckoutList
          .where((astrologer) =>
              astrologer.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });

    log('Filtered Astrologers: ${filteredAstrologers.length}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Column(
            children: [
              //backbutton
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                  const SizedBox(width: 2),
                  Container(
                    height: 5.h,
                    width: 86.w,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search astrologer...',
                        hintStyle: TextStyle(color: Colors.black),
                        prefixIcon:
                            const Icon(Icons.search, color: Colors.black),
                      ),
                      onChanged: (value) {
                        filterAstrologers(value);
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              Expanded(
                child: ListView.builder(
                  itemCount: filteredAstrologers.length,
                  itemBuilder: (context, index) {
                    log('profile image is ${filteredAstrologers[index].profileImage}');
                    return ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundColor:
                            Colors.grey[300], // Background color while loading
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                 global.buildImageUrl('${filteredAstrologers[index].profileImage}'),
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset(Images.deafultUser),
                            fit: BoxFit.cover,
                            width: 50, // Match CircleAvatar size
                            height: 50,
                          ),
                        ),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredAstrologers[index].name ?? '',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Exp : ${filteredAstrologers[index].experienceInYears} yr',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '${filteredAstrologers[index].languageKnown}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        widget.onSelect(filteredAstrologers[index]);
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
