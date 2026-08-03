// ignore_for_file: deprecated_member_use

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../model/basicDetailmodel.dart';

class BasicDetailsWidget extends StatelessWidget {
  final BasicDetailModel? basicDetails;

  const BasicDetailsWidget({
    this.basicDetails,
    super.key,
  });
  String _formatBirthDate(String? birthDate) {
    try {
      final dateTime = DateTime.parse(birthDate!);
      final dateFormat = DateFormat('yyyy-MM-dd');
      return dateFormat.format(dateTime);
    } catch (e) {
      return birthDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final basic = basicDetails?.recordList;
    final panchanglist = basicDetails?.planetDetails?.response?.panchang;
    final ghatakchakrlist = basicDetails?.planetDetails?.response?.ghatkaChakra;

    // Create a list of details for easy rendering
    final List<Map<String, String?>> details = [
      {'label': 'Name', 'value': basic?.name.toString()},
      {'label': 'Gender', 'value': basic?.gender.toString()},
      {
        'label': 'Birth Date',
        'value': _formatBirthDate(basic?.birthDate.toString())
      },
      {'label': 'Birth Time', 'value': basic?.birthTime.toString()},
      {'label': 'Birth Place', 'value': basic?.birthPlace.toString()},
      {'label': 'Timezone', 'value': basic?.timezone.toString()},
    ];

    final List<Map<String, String?>> panchangDetailsList = [
      {'label': 'Ayanamsa name', 'value': panchanglist?.ayanamsaName},
      {'label': 'Day of birth', 'value': panchanglist?.dayOfBirth},
      {'label': 'Day Lord', 'value': panchanglist?.dayLord},
      {'label': 'Karna', 'value': panchanglist?.karana},
      {'label': 'Sunset at birth', 'value': panchanglist?.sunsetAtBirth},
      {'label': 'Sunrise at birth', 'value': panchanglist?.sunriseAtBirth},
      {'label': 'yoga', 'value': panchanglist?.yoga},
      {'label': 'tithi', 'value': panchanglist?.tithi},
    ];
    final List<Map<String, String?>> ghatakDetails = [
      {'label': 'rasi', 'value': ghatakchakrlist?.rasi},
      {'label': 'Day', 'value': ghatakchakrlist?.day},
      {'label': 'Nakshatra', 'value': ghatakchakrlist?.nakshatra},
      {'label': 'tatva', 'value': ghatakchakrlist?.tatva},
      {'label': 'Lord', 'value': ghatakchakrlist?.lord},
      {'label': 'same sex lagna', 'value': ghatakchakrlist?.sameSexLagna},
      {
        'label': 'opposite sex lagna',
        'value': ghatakchakrlist?.oppositeSexLagna
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              width: 100.w,
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text('Birth Details',
                  style:
                      Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Colors.black,
                          )).tr(),
            ),
            Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) => SizedBox(height: 2.0),
                itemCount: details.length,
                itemBuilder: (context, index) {
                  final detail = details[index];
                  final isEven = index % 2 == 0;

                  return Container(
                    color: isEven ? Colors.pink[50] : Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${detail['label']}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).tr(),
                        Text(
                          detail['value'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100.w,
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text('Panchang',
                  style:
                      Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Colors.black,
                          )).tr(),
            ),
            SizedBox(height: 5),
            Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) => SizedBox(height: 2.0),
                itemCount: panchangDetailsList.length,
                itemBuilder: (context, index) {
                  final detail = panchangDetailsList[index];
                  final isEven = index % 2 == 0;

                  return Container(
                    color: isEven ? Colors.pink[50] : Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${detail['label']}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).tr(),
                        Text(
                          detail['value'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Container(
              width: 100.w,
              height: 6.h,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: Text('Avakhada Details',
                  style:
                      Theme.of(context).primaryTextTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18.sp,
                            color: Colors.black,
                          )).tr(),
            ),
            SizedBox(height: 10),
            Container(
              width: 100.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(3.w),
                border: Border.all(color: Colors.grey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 2,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                separatorBuilder: (context, index) => SizedBox(height: 2.0),
                itemCount: ghatakDetails.length,
                itemBuilder: (context, index) {
                  final detail = ghatakDetails[index];
                  final isEven = index % 2 == 0;

                  return Container(
                    color: isEven ? Colors.pink[50] : Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${detail['label']}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ).tr(),
                        Text(
                          detail['value'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
