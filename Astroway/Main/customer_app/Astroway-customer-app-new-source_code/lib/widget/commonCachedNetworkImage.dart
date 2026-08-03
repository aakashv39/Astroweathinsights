import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../utils/global.dart' as global;

class CommonCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final double borderRadius;

  const CommonCachedNetworkImage({
    Key? key,
    required this.imageUrl,
    this.height = 150,
    this.width = 150,
    this.borderRadius = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl:  global.buildImageUrl(imageUrl),
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (context, url) => Skeletonizer(
          enabled: true,
          child: Container(
            height: height,
            width: width,
            color: Colors.grey,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          padding: EdgeInsets.all(10),
          child: Image.asset(
            "assets/images/error.png",
            fit: BoxFit.contain,
            color: const Color(0x8F4E0808),
            height: 15,
          ),
        ),
      ),
    );
  }
}
