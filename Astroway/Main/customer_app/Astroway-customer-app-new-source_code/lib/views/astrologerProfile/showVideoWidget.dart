// // ignore_for_file: deprecated_member_use

// import 'package:AstrowayCustomer/views/astrologerProfile/videoController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';
// import 'package:video_player/video_player.dart';

// class ShowProfileVideo extends StatefulWidget {
//   final String videoUrl;
//   const ShowProfileVideo({super.key, required this.videoUrl});

//   @override
//   _ShowProfileVideoState createState() => _ShowProfileVideoState();
// }

// class _ShowProfileVideoState extends State<ShowProfileVideo> {
  

//   @override
//   void dispose() {
//     profileVideoController.controller.dispose();
//     super.dispose();
//     debugPrint("profile video Controller has been disposed");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<ProfileVideoController>(
//         builder: (profileVideoController) {
//       return Stack(
//         alignment: Alignment.bottomRight,
//         children: [
//           profileVideoController.controller.value.isInitialized
//               ? 
//               : const Center(child: CircularProgressIndicator()),
//           profileVideoController.controller.value.isInitialized
//               ? Positioned(
//                   right: 8,
//                   top: 100,
//                   child: Container(
//                     decoration: BoxDecoration(
//                         color: Colors.black45, shape: BoxShape.circle),
//                     child: IconButton(
//                       icon: Icon(
//                         profileVideoController.isMuted
//                             ? Icons.volume_off
//                             : Icons.volume_up,
//                         color: Colors.white,
//                         size: 20,
//                       ),
//                       onPressed: profileVideoController.toggleSound,
//                     ),
//                   ),
//                 )
//               : SizedBox.shrink(),
//         ],
//       );
//     });
//   }
// }
