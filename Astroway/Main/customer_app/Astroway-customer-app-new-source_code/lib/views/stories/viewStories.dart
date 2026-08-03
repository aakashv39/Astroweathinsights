import 'dart:math';
import 'package:AstrowayCustomer/controllers/bottomNavigationController.dart';
import 'package:AstrowayCustomer/controllers/homeController.dart';
import 'package:AstrowayCustomer/controllers/reviewController.dart';
import 'package:AstrowayCustomer/views/astrologerProfile/astrologerProfile.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:story_view/story_view.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import '../../utils/images.dart';

// ignore: must_be_immutable
class ViewStoriesScreen extends StatefulWidget {
  String? profile;
  String name;
  bool isprofile;
  int astroId;
  ViewStoriesScreen({
    super.key,
    required this.profile,
    required this.name,
    required this.isprofile,
    required this.astroId,
  });

  @override
  State<ViewStoriesScreen> createState() => _ViewStoriesScreenState();
}

class _ViewStoriesScreenState extends State<ViewStoriesScreen> {
  final controller = StoryController();
  List<StoryItem> storyItems = [];
  final homeController = Get.find<HomeController>();
  final bottomNavigationController = Get.find<BottomNavigationController>();

  List<Color> colors = [Colors.red, Colors.blue, Colors.green, Colors.pink];

  @override
  void initState() {
    super.initState();
    homeController.viewSingleStory.forEach((element) {
      if (element.mediaType.toString() == "video") {
        storyItems.add(StoryItem.pageVideo(
          "${element.media}",
          controller: controller,
          //duration: Duration(seconds: (5).toInt()),
        ));
      } else if (element.mediaType.toString() == "image") {
        storyItems.add(StoryItem.pageImage(
          url: "${element.media}",
          controller: controller,
          duration: Duration(
            seconds: (3).toInt(),
          ),
        ));
      } else if (element.mediaType.toString() == "text") {
        storyItems.add(StoryItem.text(
          title: element.media.toString(),
          backgroundColor: colors[Random().nextInt(colors.length)],
          duration: Duration(
            seconds: (3).toInt(),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            StoryView(
                controller: controller,
                repeat: false,
                onStoryShow: (s, index) {
                  homeController.viewStory(
                      homeController.viewSingleStory[index].id.toString());
                },
                onComplete: () async {
                  await homeController.getAllStories();
                  Navigator.pop(context);
                },
                onVerticalSwipeComplete: (direction) {
                  if (direction == Direction.down) {
                    Navigator.pop(context);
                  }
                },
                storyItems:
                    storyItems // To disable vertical swipe gestures, ignore this parameter.
                // Preferrably for inline story view.
                ),
            Positioned(
              top: 20,
              left: 10,
              child: InkWell(
                onTap: () async {
                  if (widget.isprofile) {
                    Navigator.pop(context);
                  } else {
                    Get.find<ReviewController>().getReviewData(widget.astroId);
                    global.showOnlyLoaderDialog(context);
                    await bottomNavigationController
                        .getAstrologerbyId(widget.astroId);
                    global.hideLoader();
                    Get.to(() => AstrologerProfile(
                          index: 0,
                        ));
                  }
                },
                child: Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            )),
                        widget.profile == null || widget.profile == "null"
                            ? CircleAvatar(
                                radius: 23,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(
                                  Images.deafultUser,
                                ),
                              )
                            : CircleAvatar(
                                radius: 23,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    NetworkImage("${widget.profile}"),
                              ),
                        SizedBox(
                          width: 2.w,
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15.sp)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.7.h),
                      child: Text(
                        "Visit Profile",
                        style: TextStyle(color: Colors.white),
                      ).tr(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
