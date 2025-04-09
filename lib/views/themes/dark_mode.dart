import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  /// colorScheme
  colorScheme: ColorScheme.dark(
    //surface: Colors.grey.shade800,
    //background: Colors.grey.shade900,
    background: const Color.fromRGBO(45, 50, 59, 1.0),
    surface: const Color.fromRGBO(30, 39, 46, 1.0),
    primary: const Color.fromARGB(255, 67, 67, 67),
    secondary: const Color.fromRGBO(47, 50, 60, 1.0),
    tertiary: const Color.fromARGB(255, 68, 68, 68),
    //inversePrimary: Color.fromARGB(255, 37, 37, 37),
    inversePrimary: Colors.grey.shade200,
    //inverseSurface: Colors.grey.shade400),
    inverseSurface: const Color.fromRGBO(220, 220, 220, 1),
  ),

  /// textTheme
  textTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    displayMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    displaySmall: TextStyle(fontFamily: 'PoppinsMedium'),
    headlineLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    headlineMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    headlineSmall: TextStyle(fontFamily: 'PoppinsMedium'),
    titleLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    titleMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    titleSmall: TextStyle(fontFamily: 'PoppinsMedium'),
    bodyLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    bodyMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    bodySmall: TextStyle(fontFamily: 'PoppinsMedium'),
    labelLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    labelMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    labelSmall: TextStyle(fontFamily: 'PoppinsMedium'),
  ),

  textSelectionTheme: TextSelectionThemeData(
    selectionHandleColor: AppColors.primaryColor,
    selectionColor: AppColors.primaryColor.withOpacity(0.3),
    cursorColor: AppColors.primaryColor,
  ),

  /// primaryTextTheme
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    displayMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    displaySmall: TextStyle(fontFamily: 'PoppinsMedium'),
    headlineLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    headlineMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    headlineSmall: TextStyle(fontFamily: 'PoppinsMedium'),
    titleLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    titleMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    titleSmall: TextStyle(fontFamily: 'PoppinsMedium'),
    bodyLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    bodyMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    bodySmall: TextStyle(fontFamily: 'PoppinsMedium'),
    labelLarge: TextStyle(fontFamily: 'PoppinsMedium'),
    labelMedium: TextStyle(fontFamily: 'PoppinsMedium'),
    labelSmall: TextStyle(fontFamily: 'PoppinsMedium'),
  ),
); // ColorScheme.dark
