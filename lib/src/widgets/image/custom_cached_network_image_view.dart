import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/src/widgets/image/custom_image_view.dart';
import 'package:news_app/utils/color/color_utils.dart';
import 'package:news_app/utils/utils.dart';

class CustomCachedNetworkImageView extends StatelessWidget {
  const CustomCachedNetworkImageView({
    required this.imageUrl,
    this.height,
    this.width,
    this.color,
    this.radius,
    this.boxFit = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  final Color? color;

  final String imageUrl;

  final double? height;

  final double? width;

  final double? radius;

  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        color: color,
        height: height,
        width: width,
        fit: boxFit,
        progressIndicatorBuilder:
            (BuildContext context, String link, dynamic data) {
          return Container(
              color: ColorUtils.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imageUrl: AssetUtilities.newsAppLogo,
                    boxFit: BoxFit.cover,
                    height: height ?? 50,
                  ),
                ],
              ));
        },
        errorWidget: (BuildContext context, String link, dynamic data) {
          return Container(
              color: ColorUtils.whiteColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomImageView(
                    imageUrl: AssetUtilities.newsAppLogo,
                    boxFit: BoxFit.cover,
                    height: height ?? 50,
                  ),
                ],
              ));
        },
      ),
    );
  }
}
