import 'package:flutter/material.dart';
import 'package:news_app/utils/utils.dart';

typedef Validator = String? Function(String?)?;

class InputField extends StatelessWidget {
  const InputField({
    required this.controller,
    required this.onChanged,
    required this.lable,
    this.suffixIcon,
    Key? key,
  }) : super(key: key);

  final TextEditingController controller;

  final String lable;
  final Function(String)? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      cursorColor: ColorUtils.whiteColor,
      style: FontUtilities.h16(fontColor: ColorUtils.whiteColor),
      decoration: InputDecoration(
          label: Text(
            lable,
            style: FontUtilities.h16(fontColor: ColorUtils.whiteColor),
          ),
          labelStyle: FontUtilities.h16(fontColor: ColorUtils.whiteColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: ColorUtils.whiteColor, style: BorderStyle.solid),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: ColorUtils.whiteColor, style: BorderStyle.solid),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
                color: ColorUtils.whiteColor, style: BorderStyle.solid),
          ),
          suffix: suffixIcon ?? const SizedBox()),
    );
  }
}
