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
);
