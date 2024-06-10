import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFFC56E33);
  static const Color primaryColorAlt = Color(0xFFCF8652);
  static const Color secondaryColor = Color(0xFFF51400);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color whiteColorAlt = Color(0xFFFBF6F4);
  static const Color greyColor = Color(0xFFCACACA);
  static const Color blackColor = Color(0xFF0D0D0D);


  // Text
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w800,
    fontSize: 32.0,
    color: blackColor,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w800,
    fontSize: 24.0,
    color: blackColor,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 20.0,
    color: blackColor,
  );

  static const TextStyle headlineTiny = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.bold,
    fontSize: 18.0,
    color: blackColor,
  );

  static const TextStyle bodyTextLarge = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 16.0,
    color: blackColor,
  );

  static const TextStyle bodyTextMedium = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 14.0,
    color: blackColor,
  );

  static const TextStyle bodyTextSmall = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.normal,
    fontSize: 12.0,
    color: blackColor,
  );



  // Buttons
  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
    color: whiteColor,
  );

  static final ButtonStyle textButtonStyle = TextButton.styleFrom(
    backgroundColor: primaryColor,
    padding: const EdgeInsets.symmetric(horizontal: spacing16),
    textStyle: buttonText
  );

  static final ButtonStyle outlinedButtonStyle = OutlinedButton.styleFrom(
    backgroundColor: primaryColor,
    side: const BorderSide(color: primaryColor),
    padding: const EdgeInsets.symmetric(horizontal: spacing16),
    textStyle: buttonText
  );

  // Define your spacing values
  static const double spacing8 = 8.0;
  static const double spacing16 = 16.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  static const double spacing56 = 56.0;
  static const double spacing64 = 64.0;

  // Add more text styles as needed
/*
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: secondaryColor,
      background: Colors.white,
      onBackground: neutralColor,
    ),
    textTheme: const TextTheme(
      headline1: headline1,
      headline2: headline2,
      bodyText1: bodyText1,
      // Add more text styles as needed
    ),
    fontFamily: 'YourFontFamily', // Set the default font family
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: primaryColor,
    colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
      secondary: secondaryColor,
      background: Colors.black,
      onBackground: neutralColor,
    ),
    textTheme: const TextTheme(
      headline1: headline1,
      headline2: headline2,
      bodyText1: bodyText1,
      // Add more text styles as needed
    ),
    fontFamily: 'YourFontFamily', // Set the default font family
  );
*/
}
