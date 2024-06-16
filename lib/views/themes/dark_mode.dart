import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: ColorScheme.dark(
      //surface: Colors.grey.shade800,
      //background: Colors.grey.shade900,
      background: const Color.fromRGBO(30, 39, 46, 1.0),
      surface: const Color.fromRGBO(45, 50, 59, 1.0),
      primary: const Color.fromARGB(255, 67, 67, 67),
      secondary: const Color.fromARGB(255, 56, 56, 56),
      tertiary: const Color.fromARGB(255, 68, 68, 68),
      //inversePrimary: Color.fromARGB(255, 37, 37, 37),
      inversePrimary: Colors.grey.shade200,
      inverseSurface: Colors.grey.shade400),

  // textTheme
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
); // ColorScheme.dark
