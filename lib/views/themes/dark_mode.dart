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
    displayLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    displayMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    displaySmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    headlineLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    headlineMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    headlineSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    titleLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    titleMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    titleSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    bodyLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    bodyMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    bodySmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    labelLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    labelMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    labelSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
  ),

  /// primaryTextTheme
  primaryTextTheme: const TextTheme(
    displayLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    displayMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    displaySmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    headlineLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    headlineMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    headlineSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    titleLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    titleMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    titleSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    bodyLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    bodyMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    bodySmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
    labelLarge: TextStyle(fontFamily: 'PoppinsSemiBold'),
    labelMedium: TextStyle(fontFamily: 'PoppinsSemiBold'),
    labelSmall: TextStyle(fontFamily: 'PoppinsSemiBold'),
  ),
); // ColorScheme.dark
