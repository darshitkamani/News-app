import 'package:flutter/material.dart';

/// This is the widget used for showing images.
class CustomImageView extends StatelessWidget {
  const CustomImageView({
    required this.imageUrl,
    this.height,
    this.width,
    this.color,
    this.isFromAsset = true,
    this.radius,
    this.boxFit = BoxFit.cover,
    Key? key,
  }) : super(key: key);

  final Color? color;
  final String imageUrl;

  final bool isFromAsset;

  final double? height;

  final double? width;

  final double? radius;

  final BoxFit boxFit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius ?? 0),
      child: Image(
        color: color,
        image: isFromAsset
            ? AssetImage(imageUrl) as ImageProvider
            : NetworkImage(imageUrl),
        height: height,
        width: width,
        fit: boxFit,
      ),
    );
  }
}
