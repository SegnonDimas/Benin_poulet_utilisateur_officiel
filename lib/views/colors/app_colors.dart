import 'package:flutter/material.dart';

class AppColors {
  static Color primaryColor = const Color(0xFF03A63D);
  static Color secondaryColor = const Color.fromARGB(255, 50, 131, 13);
  static Color tertiaryColor = const Color.fromARGB(255, 49, 63, 58);
  static Color purpleShade900Color = Colors.deepPurple.shade900;
  static Color redColor = const Color.fromARGB(179, 255, 0, 0);
  static Color blueColor = const Color.fromARGB(179, 0, 57, 208);
  static Color yellowColor = const Color.fromARGB(179, 255, 255, 0);
  static Color orangeColor = const Color.fromARGB(245, 255, 165, 0);
  static Color deepOrangeColor = Colors.deepOrange;
  static Color purpleColor = const Color.fromARGB(179, 128, 0, 128);
}

// TODO : A supprimer
@Deprecated("Utiliser la classe AppColors à la place : AppColors.primaryColor")
Color primaryColor =
    const Color(0xFF03A63D); //const Color.fromARGB(255, 47, 155, 0);

@Deprecated(
    "Utiliser la classe AppColors à la place : AppColors.secondaryColor")
Color secondaryColor = const Color.fromARGB(255, 50, 131, 13);

@Deprecated("Utiliser la classe AppColors à la place : AppColors.tertiaryColor")
Color tertiaryColor = const Color.fromARGB(255, 49, 63, 58);

@Deprecated("Utiliser la classe AppColors à la place : AppColors.blueColor")
Color blueColor = const Color.fromARGB(179, 0, 96, 216);
