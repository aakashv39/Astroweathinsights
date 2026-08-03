import 'package:AstrowayCustomer/controllers/IntakeController.dart';
import 'package:AstrowayCustomer/controllers/callController.dart';
import 'package:AstrowayCustomer/controllers/onboardController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:flutter/foundation.dart';
import 'package:AstrowayCustomer/controllers/kundliController.dart';
import 'package:AstrowayCustomer/controllers/kundliMatchingController.dart';
import 'package:AstrowayCustomer/controllers/reportController.dart';
import 'package:AstrowayCustomer/controllers/search_controller.dart';
import 'package:AstrowayCustomer/controllers/search_place_controller.dart';
import 'package:AstrowayCustomer/controllers/userProfileController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

class PlaceOfBirthSearchScreen extends StatelessWidget {
  final int? flagId;
  PlaceOfBirthSearchScreen({Key? key, this.flagId}) : super(key: key);
  final userProfileController = Get.find<UserProfileController>();
  final kundliController = Get.find<KundliController>();
  final callIntakeController = Get.find<IntakeController>();
  final reportController = Get.find<ReportController>();
  final kundliMatchingController = Get.find<KundliMatchingController>();
  final callController = Get.find<CallController>();
  final searchController = Get.find<SearchControllerCustom>();
  final onBoardController = Get.find<OnBoardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffbgcolor,
      appBar: AppBar(title: Text('Place of Birth').tr()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            GetBuilder<SearchPlaceController>(builder: (searchPlaceController) {
          return Column(
            children: [
              SizedBox(
                height: 40,
                child: TextField(
                  onChanged: (value) async {
                    await searchPlaceController.autoCompleteSearch(value);
                  },
                  controller: searchPlaceController.searchController,
                  decoration: InputDecoration(
                      isDense: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Get.theme.iconTheme.color,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                      hintText: tr('Search City'),
                      hintStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: searchPlaceController.predictions!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Get.theme.primaryColor,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(searchPlaceController
                          .predictions![index].description!),
                      onTap: () async {
                        List<Location> location;
                        if (kIsWeb) {
                          List<Map<String, double>> hardcodedData = [
                            {'latitude': 40.7128, 'longitude': -74.0060},
                            {'latitude': 40.7128, 'longitude': -74.0060},
                          ];
                          location = hardcodedData.map((data) {
                            return Location(
                                latitude: data['latitude']!,
                                longitude: data['longitude']!,
                                timestamp: DateTime.now());
                          }).toList();
                        } else {
                          print("timezone");
                          print(
                              "${searchPlaceController.predictions![index].description.toString()}");
                          location = await locationFromAddress(
                            searchPlaceController
                                .predictions![index].description
                                .toString(),
                          );
                        }
                        kundliController.lat = location[0].latitude;
                        kundliController.long = location[0].longitude;
                        kundliMatchingController.lat = location[0].latitude;
                        kundliMatchingController.long = location[0].longitude;
                        print('latitude ${location[0].latitude} :- location');
                        print('longitude ${location[0].longitude} :- location');
                        await kundliController.getGeoCodingLatLong(
                            latitude: location[0].latitude,
                            longitude: location[0].longitude,
                            flagId: flagId,
                            kundliMatchingController: kundliMatchingController);
                        searchPlaceController.searchController.text =
                            searchPlaceController
                                .predictions![index].description!;
                        searchPlaceController.update();
                        kundliController.birthKundliPlaceController.text =
                            searchPlaceController
                                .predictions![index].description!;
                        kundliController.update();

                        kundliController.editBirthPlaceController.text =
                            searchPlaceController
                                .predictions![index].description!;
                        kundliController.update();
                        if (flagId == 1) {
                          kundliMatchingController.cBoysBirthPlace.text =
                              searchPlaceController
                                  .predictions![index].description!;
                          kundliMatchingController.boyLat =
                              location[0].latitude;
                          kundliMatchingController.boyLong =
                              location[0].longitude;
                          kundliMatchingController.update();
                        }
                        if (flagId == 2) {
                          kundliMatchingController.cGirlBirthPlace.text =
                              searchPlaceController
                                  .predictions![index].description!;
                          kundliMatchingController.girlLat =
                              location[0].latitude;
                          kundliMatchingController.girlLong =
                              location[0].longitude;
                          kundliMatchingController.update();
                        }
                        if (flagId == 4) {
                          userProfileController.addressController.text =
                              searchPlaceController
                                  .predictions![index].description!;
                        }
                        if (flagId == 3) {
                          userProfileController.placeBirthController.text =
                              searchPlaceController
                                  .predictions![index].description!;
                        }
                        if (flagId == 5) {
                          callIntakeController.lat = location[0].latitude;
                          callIntakeController.long = location[0].longitude;
                          callIntakeController.getGeoCodingLatLong(
                              latitude: callIntakeController.lat,
                              longitude: callIntakeController.long);
                          callIntakeController.placeController.text =
                              searchPlaceController
                                  .predictions![index].description!;
                        }
                        if (flagId == 6) {
                          callIntakeController.partnerPlaceController.text =
                              searchPlaceController
                                  .predictions![index].description!;
                        }
                        if (flagId == 7) {
                          reportController.placeController.text =
                              searchPlaceController
                                  .predictions![index].description!;
                          reportController.update();
                        }
                        if (flagId == 8) {
                          reportController.partnerPlaceController.text =
                              searchPlaceController
                                  .predictions![index].description!;
                          reportController.update();
                        }
                        if (flagId == 9) {
                          onBoardController.birthPlaceController.text =
                              "${searchPlaceController.predictions![index].description}";
                          onBoardController.update();
                        }
                        callIntakeController.update();
                        Get.back();
                      },
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
