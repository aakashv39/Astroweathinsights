import 'package:AstrowayCustomer/controllers/themeController.dart';
import 'package:AstrowayCustomer/utils/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

final themeController = Get.find<ThemeController>();
Map<int, Color> color = {
  50: const Color.fromRGBO(198, 29, 36, .1),
  100: const Color.fromRGBO(198, 29, 36, .2),
  200: const Color.fromRGBO(198, 29, 36, .3),
  300: const Color.fromRGBO(198, 29, 36, .4),
  400: const Color.fromRGBO(198, 29, 36, .5),
  500: const Color.fromRGBO(198, 29, 36, .6),
  600: const Color.fromRGBO(198, 29, 36, .7),
  700: const Color.fromRGBO(198, 29, 36, .8),
  800: const Color.fromRGBO(198, 29, 36, .9),
  900: const Color.fromRGBO(198, 29, 36, 1),
};
ThemeData nativeTheme({bool? darkModeEnabled}) {
  final bool isDark = darkModeEnabled ?? false;
  final Color primaryColor = isDark ? Colors.black : themeController.pickColor;
  final Color textColor = isDark ? Colors.white : Colors.black;
  final String fontFamily = 'Outfit'; // Use consistent font family

  return ThemeData(
    appBarTheme: AppBarTheme(
      surfaceTintColor: appbarbgcolor,
      backgroundColor: appbarbgcolor,
      titleSpacing: 1.0,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: isDark ? FontWeight.normal : FontWeight.w600,
        fontSize: 18.sp,
        color: Color(0xFF022420),
      ),
      iconTheme: IconThemeData(size: 20.sp, color: Color(0xFF022420)),
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black54,
          statusBarIconBrightness: Brightness.light),
    ),
    fontFamily: fontFamily,
    primaryColor: primaryColor,
    primaryColorLight: primaryColor,
    primarySwatch: MaterialColor(themeController.pickColorInt, color),
    textTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: fontFamily, color: textColor),
      displayMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      displaySmall: TextStyle(fontFamily: fontFamily, color: textColor),
      headlineMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      headlineSmall: TextStyle(fontFamily: fontFamily, color: textColor),
      titleLarge: TextStyle(fontFamily: fontFamily, color: textColor),
      bodySmall: TextStyle(fontFamily: fontFamily, color: textColor),
      titleMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      titleSmall: TextStyle(fontFamily: fontFamily, color: textColor),
      bodyLarge: TextStyle(fontFamily: fontFamily, color: textColor),
      bodyMedium: TextStyle(fontFamily: fontFamily, color: textColor),
    ),
    primaryTextTheme: TextTheme(
      displayLarge: TextStyle(fontFamily: fontFamily, color: textColor),
      displayMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      displaySmall: TextStyle(fontFamily: fontFamily, color: textColor),
      headlineMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      headlineSmall: TextStyle(fontFamily: fontFamily, color: textColor),
      titleLarge: TextStyle(fontFamily: fontFamily, color: textColor),
      titleMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      titleSmall: TextStyle(fontFamily: fontFamily, color: textColor),
      bodyLarge: TextStyle(fontFamily: fontFamily, color: textColor),
      bodyMedium: TextStyle(fontFamily: fontFamily, color: textColor),
      bodySmall: TextStyle(fontFamily: fontFamily, color: textColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primaryColor),
        foregroundColor: WidgetStateProperty.all(const Color(0xFFF5F5F5)),
      ),
    ),
    colorScheme: ColorScheme.fromSwatch(
      primarySwatch: MaterialColor(themeController.pickColorInt, color),
      brightness: isDark ? Brightness.dark : Brightness.light,
    ),
  );
}
