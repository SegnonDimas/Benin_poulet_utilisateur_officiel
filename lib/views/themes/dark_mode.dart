import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  /// colorScheme
  colorScheme: ColorScheme.dark(
    //surface: Colors.grey.shade800,
    //background: Colors.grey.shade900,
    background: const Color.fromRGBO(30, 39, 46, 1.0),
    surface: const Color.fromRGBO(45, 50, 59, 1.0),
    primary: const Color.fromARGB(255, 67, 67, 67),
    secondary: const Color.fromRGBO(47, 50, 60, 1.0),
    tertiary: const Color.fromARGB(255, 68, 68, 68),
    //inversePrimary: Color.fromARGB(255, 37, 37, 37),
    inversePrimary: Colors.grey.shade200,
    //inverseSurface: Colors.grey.shade400),
    inverseSurface: const Color.fromRGBO(220, 221, 225, 150),
  ),

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
); // ColorScheme.dark
