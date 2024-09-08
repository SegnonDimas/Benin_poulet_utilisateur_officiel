import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  /// colorScheme
  colorScheme: ColorScheme.light(
    //surface: Colors.grey.shade300,
    //background: Colors.grey.shade100,
    background: const Color.fromRGBO(245, 246, 250, 1.0),
    //surface: const Color.fromRGBO(220, 221, 225, 150),
    surface: Color.fromARGB(238, 229, 231, 235),
    primary: Colors.grey.shade400,
    secondary: const Color.fromRGBO(220, 221, 225, 50),
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade800,
    //inverseSurface: Colors.grey.shade600,
    inverseSurface: const Color.fromRGBO(45, 50, 59, 1.0),
  ),

  /// buttonTheme
  buttonTheme: const ButtonThemeData(),

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
);
