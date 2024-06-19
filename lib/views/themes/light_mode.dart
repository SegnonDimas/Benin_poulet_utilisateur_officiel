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
    displayLarge: TextStyle(fontFamily: 'PoppinsBold'),
    displayMedium: TextStyle(fontFamily: 'PoppinsBold'),
    displaySmall: TextStyle(fontFamily: 'PoppinsBold'),
    headlineLarge: TextStyle(fontFamily: 'PoppinsBold'),
    headlineMedium: TextStyle(fontFamily: 'PoppinsBold'),
    headlineSmall: TextStyle(fontFamily: 'PoppinsBold'),
    titleLarge: TextStyle(fontFamily: 'PoppinsBold'),
    titleMedium: TextStyle(fontFamily: 'PoppinsBold'),
    titleSmall: TextStyle(fontFamily: 'PoppinsBold'),
    bodyLarge: TextStyle(fontFamily: 'PoppinsBold'),
    bodyMedium: TextStyle(fontFamily: 'PoppinsBold'),
    bodySmall: TextStyle(fontFamily: 'PoppinsBold'),
    labelLarge: TextStyle(fontFamily: 'PoppinsBold'),
    labelMedium: TextStyle(fontFamily: 'PoppinsBold'),
    labelSmall: TextStyle(fontFamily: 'PoppinsBold'),
  ),

  /// primaryTextTheme
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'PoppinsBold'),
    displayMedium: TextStyle(fontFamily: 'PoppinsBold'),
    displaySmall: TextStyle(fontFamily: 'PoppinsBold'),
    headlineLarge: TextStyle(fontFamily: 'PoppinsBold'),
    headlineMedium: TextStyle(fontFamily: 'PoppinsBold'),
    headlineSmall: TextStyle(fontFamily: 'PoppinsBold'),
    titleLarge: TextStyle(fontFamily: 'PoppinsBold'),
    titleMedium: TextStyle(fontFamily: 'PoppinsBold'),
    titleSmall: TextStyle(fontFamily: 'PoppinsBold'),
    bodyLarge: TextStyle(fontFamily: 'PoppinsBold'),
    bodyMedium: TextStyle(fontFamily: 'PoppinsBold'),
    bodySmall: TextStyle(fontFamily: 'PoppinsBold'),
    labelLarge: TextStyle(fontFamily: 'PoppinsBold'),
    labelMedium: TextStyle(fontFamily: 'PoppinsBold'),
    labelSmall: TextStyle(fontFamily: 'PoppinsBold'),
  ),
);
