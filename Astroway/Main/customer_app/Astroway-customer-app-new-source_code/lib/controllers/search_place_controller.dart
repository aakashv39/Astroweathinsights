import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class AutocompletePrediction {
  final String? description;
  final String? placeId;
  final String? primaryText;

  AutocompletePrediction({this.description, this.placeId, this.primaryText});
}

class SearchPlaceController extends GetxController {
  double? latitude;
  double? longitude;
  List<AutocompletePrediction> predictions = [];
  final searchController = TextEditingController();
  FlutterGooglePlacesSdk? _places;

  @override
  void onInit() {
    super.onInit();
    _initPlaces();
  }

  void _initPlaces() {
    try {
      final apiKey = Platform.isAndroid
          ? global.getSystemFlagValueForLogin(
              global.systemFlagNameList.googleMapApiKeyAndriod)
          : global.getSystemFlagValueForLogin(
              global.systemFlagNameList.googleMapApiKeyIOS);

      _places = FlutterGooglePlacesSdk(apiKey);
    } catch (e) {
      log("Error initializing Places SDK: $e");
    }
  }

  Future<void> autoCompleteSearch(String? value) async {
    if (value != null && value.isNotEmpty) {
      try {
        if (_places == null) _initPlaces();
        final response = await _places!.findAutocompletePredictions(value);
        predictions = response.predictions
            .map((p) => AutocompletePrediction(
                  description: p.fullText,
                  placeId: p.placeId,
                  primaryText: p.primaryText,
                ))
            .toList();

        log('Fetched ${predictions.length} predictions');
        update();
      } catch (e) {
        log('Error fetching places: $e');
        predictions = [];
        update();
      }
    } else {
      predictions = [];
      update();
    }
  }
}
