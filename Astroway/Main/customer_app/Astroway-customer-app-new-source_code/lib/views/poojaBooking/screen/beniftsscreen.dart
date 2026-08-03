import 'package:AstrowayCustomer/views/poojaBooking/model/poojalistmodel.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class BeniftsScreen extends StatelessWidget {
  const BeniftsScreen({
    super.key,
    required this.poojadetail,
  });

  final PoojaList poojadetail;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: List.generate(
        poojadetail.pujaBenefits!.length,
        (index) {
          return Container(
            padding: EdgeInsets.all(3.w),
            child: Column(
              children: [
                Container(
                  width: 100.w,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    textAlign: TextAlign.start,
                    '${poojadetail.pujaBenefits![index].title}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  '${poojadetail.pujaBenefits![index].description}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          );
        },
      )),
    );
  }
}
