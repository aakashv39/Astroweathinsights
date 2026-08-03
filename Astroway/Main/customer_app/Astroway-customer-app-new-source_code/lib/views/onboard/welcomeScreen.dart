// // ignore_for_file: deprecated_member_use

// import 'package:AstroTreePro/utils/AppColors.dart';
// import 'package:AstroTreePro/utils/images.dart';
// import 'package:AstroTreePro/views/loginScreen.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// class WelcomeScreen extends StatelessWidget {
//   final List<String> zodicImages = [
//     Images.zodic1,
//     Images.zodic3,
//     Images.zodic2,
//     Images.zodic4,
//     Images.zodic5,
//     Images.zodic6,
//   ];
//   final List<double> heights = [120, 250, 250, 120, 120, 250];
//   @override
//   Widget build(BuildContext context) {
//     List<Widget> column1 = [];
//     List<Widget> column2 = [];
//     List<Widget> column3 = [];

//     for (int i = 0; i < heights.length; i++) {
//       Widget box = Container(
//         height: heights[i],
//         margin: const EdgeInsets.only(bottom: 8),
//         padding: const EdgeInsets.all(15),
//         decoration: BoxDecoration(
//           color: Color(0xffFEEBE4),
//           borderRadius: BorderRadius.circular(2.w),
//         ),
//         child: Image.asset(height: 20, zodicImages[i], fit: BoxFit.contain),
//       );
//       if (i < 2) {
//         column1.add(box);
//       } else if (i < 4) {
//         column2.add(box);
//       } else if (i < 6) {
//         column3.add(box);
//       }
//     }

//     return SafeArea(
//       child: Scaffold(
//         body: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Padding(
//               padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 3.w),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(child: Column(children: column1)),
//                   SizedBox(width: 8),
//                   Expanded(child: Column(children: column2)),
//                   SizedBox(width: 8),
//                   Expanded(child: Column(children: column3)),
//                 ],
//               ),
//             ),
//             Container(
//               height: 35.h,
//               padding: const EdgeInsets.only(bottom: 10),
//               alignment: Alignment.bottomCenter,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     Color.fromARGB(27, 255, 244, 232), // Light orange
//                     Color(0xFFFF8C42), // Deep orange
//                   ],
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   SizedBox(height: Get.height * 0.03),
//                   Padding(
//                     padding: EdgeInsets.all(3.w),
//                     child: Text('Discover Your\nDestiny Today!',
//                             style: Get.textTheme.titleMedium!.copyWith(
//                                 color: blackColor,
//                                 fontSize: 18.sp,
//                                 fontWeight: FontWeight.w600),
//                             textAlign: TextAlign.center)
//                         .tr(),
//                   ),
//                   Text('Get personalized astrology insights,\ndaily horoscopes,and expert guidance\nfrom top astrologers',
//                           style: Get.textTheme.titleMedium!.copyWith(
//                               color: blackColor,
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.normal),
//                           textAlign: TextAlign.center)
//                       .tr(),
//                   SizedBox(height: Get.height * 0.03),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 32),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Get.off(() => LoginScreen(),
//                             transition: Transition.rightToLeft);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         foregroundColor: Colors.black,
//                         backgroundColor: whiteColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                         minimumSize: const Size.fromHeight(50),
//                       ),
//                       child: const Text("Get Started"),
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CurvedTopClipper extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     path.lineTo(0, 40);

//     // Create a smooth curve at the top
//     path.quadraticBezierTo(size.width / 2, -40, size.width, 40);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);

//     path.close();
//     return path;
//   }

//   @override
//   bool shouldReclip(CustomClipper<Path> oldClipper) => false;
// }
