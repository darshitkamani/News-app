import 'package:flutter/material.dart';
import 'package:news_app/utils/color/color_utils.dart';
import 'package:news_app/utils/utils.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.onTap,
    required this.title,
    this.height,
    this.width,
    this.color,
    this.titleColor,
    this.borderColor,
    this.textStyle,
    this.suffixIcon,
    Key? key,
  }) : super(key: key);

  final VoidCallback onTap;

  final double? height;

  final double? width;

  final Color? color;

  final Color? titleColor;

  final Color? borderColor;

  final String title;

  final TextStyle? textStyle;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 45,
        width: width ?? 222,
        decoration: BoxDecoration(
            color: color ?? ColorUtils.blackColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: borderColor ?? ColorUtils.blackColor, width: 1.5)),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: textStyle ??
                    FontUtilities.h15(
                        fontColor: titleColor ?? ColorUtils.blackColor,
                        fontWeight: FWT.semiBold),
              ),
              SizedBox(width: suffixIcon != null ? 10 : 0),
              suffixIcon ?? const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
