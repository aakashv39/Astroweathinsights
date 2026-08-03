import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:AstrowayCustomer/utils/global.dart' as global;
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final int? maxlen;
  final VoidCallback? onTap;
  final FocusNode? focusNode;
  final bool readyOnly;
  final bool filled;
  final double? borderRadius;
  final Color? filledColor;
  final Icon? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;
  const TextFieldWidget(
      {Key? key,
      this.onTap,
      required this.controller,
      this.labelText,
      this.keyboardType,
      this.maxlen,
      this.inputFormatter,
      this.readyOnly = false,
      this.filled = false,
      this.borderRadius,
      this.filledColor,
      this.focusNode,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: labelText == "Time of Birth" ? 0 : 12),
      child: Container(
        margin: EdgeInsets.only(bottom: 2),
        child: TextFormField(
          readOnly: readyOnly,
          controller: controller,
          focusNode: focusNode,
          cursorColor: global.coursorColor,
          inputFormatters: inputFormatter ?? [],
          textCapitalization: TextCapitalization.words,
          maxLength: maxlen ?? null,
          keyboardType: keyboardType ?? TextInputType.text,
          onTap: onTap,
          decoration: InputDecoration(
            focusColor: Colors.black,
            isDense: true,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 3.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
              borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 1.0),
              borderRadius: BorderRadius.circular(borderRadius ?? 30.0),
            ),
            fillColor: filledColor ?? Colors.grey,
            filled: filled,
            suffixIcon: suffixIcon,
            labelText: tr(labelText.toString()),
            labelStyle: Get.theme.textTheme.bodyMedium!.copyWith(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}
