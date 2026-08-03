import 'package:AstrowayCustomer/views/kudali/GetKundliscreens/arrowclipper.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ArrowBoxWidget extends StatelessWidget {
  final List<String> datatitle;
  final int index;
  ArrowBoxWidget({Key? key, required this.datatitle, required this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: ArrowClipper(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(datatitle[index],
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 12.sp,
                    )),
          ),
        ],
      ),
    );
  }
}
