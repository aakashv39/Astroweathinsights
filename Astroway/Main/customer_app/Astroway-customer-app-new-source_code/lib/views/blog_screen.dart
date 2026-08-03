import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/controllers/splashController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../utils/images.dart';
import 'newsReadMoreScreen.dart';

// ignore: must_be_immutable
class BlogScreen extends StatelessWidget {
  final String link;
  final String title;
  final String? videoTitle;
  final String? date;
  final String? banner;
  final String? longdescription;
  final YoutubePlayerController? controller;
  BlogScreen(
      {super.key,
      required this.link,
      this.controller,
      this.title = 'News',
      this.date,
      this.banner,
      this.longdescription,
      this.videoTitle});
  final ReviewController reviewController = Get.find<ReviewController>();
  SplashController splashController = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: Text(
            'Astrology $title',
          ).tr(),
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () async {
                splashController.createAstrologerShareLink();
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Get.theme.primaryColor),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        Images.whatsapp,
                        height: 35,
                        width: 35,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Share',
                                style: Get.textTheme.titleMedium!.copyWith(
                                    fontSize: 12,
                                    color: Get.theme.primaryColor))
                            .tr(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ]),
      body: title == "News"
          ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Article Image
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          banner.toString(),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // HTML Description
                            Html(
                              data: videoTitle.toString(),
                              style: {
                                "p": Style(
                                    fontSize: FontSize(14),
                                    color: Colors.black54),
                              },
                            ),

                            SizedBox(height: 15),

                            // Read More Button
                            Align(
                              alignment: Alignment.centerRight,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          Newsreadmorescreen(link: link),
                                    ),
                                  );
                                },
                                child: Text("Read More"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Center(
                      child: YoutubePlayer(
                        aspectRatio: 16 / 13,
                        controller: controller!,
                        showVideoProgressIndicator: true,
                        progressColors: ProgressBarColors(
                          playedColor: Colors.red,
                          handleColor: Colors.grey,
                        ),
                        bottomActions: [
                          CurrentPosition(),
                          ProgressBar(
                            isExpanded: true,
                          ),
                          RemainingDuration(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: Get.width * 0.7,
                              child: Text(
                                '$videoTitle',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20),
                              ).tr(),
                            ),
                            Text(
                              '$date',
                              textAlign: TextAlign.end,
                            ),
                          ],
                        ),
                        Html(
                          data: longdescription.toString(),
                          style: {
                            "p": Style(
                                fontSize: FontSize(14), color: Colors.black54),
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
