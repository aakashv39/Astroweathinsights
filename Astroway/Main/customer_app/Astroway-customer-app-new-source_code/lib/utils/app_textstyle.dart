import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle getAppFont(TextStyle textStyle) {
  return GoogleFonts.nunito(textStyle: textStyle);
}

class AppTextStyle {

  static TextStyle regularTextStyle = getAppFont(const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  ));

}