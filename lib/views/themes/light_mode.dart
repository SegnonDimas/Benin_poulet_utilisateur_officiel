import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  /// colorScheme
  colorScheme: ColorScheme.light(
    //surface: Colors.grey.shade300,
    //background: Colors.grey.shade100,
    background: const Color.fromRGBO(245, 246, 250, 1.0),
    surface: const Color.fromRGBO(220, 221, 225, 150),
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
    displayLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
    displayMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
    displaySmall: TextStyle(fontFamily: 'MontserratSemiBold'),
    headlineLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
    headlineMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
    headlineSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
    titleLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
    titleMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
    titleSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
    bodyLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
    bodyMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
    bodySmall: TextStyle(fontFamily: 'MontserratSemiBold'),
    labelLarge: TextStyle(fontFamily: 'MontserratSemiBold'),
    labelMedium: TextStyle(fontFamily: 'MontserratSemiBold'),
    labelSmall: TextStyle(fontFamily: 'MontserratSemiBold'),
  ),
);
