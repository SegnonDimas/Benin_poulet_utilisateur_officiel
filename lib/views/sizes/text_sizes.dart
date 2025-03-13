import 'package:flutter/widgets.dart';

class AppTextSize {
  final BuildContext context;

  AppTextSize(this.context);

  double get screenWidth => MediaQuery.of(context).size.width;

  double get smallText => screenWidth * 0.03; // 2.5% de la largeur
  double get mediumText => screenWidth * 0.045; // 4% de la largeur
  double get largeText => screenWidth * 0.06; // 5.5% de la largeur

  double adjust(double baseSize, double factor) {
    return baseSize * factor;
  }
}

extension AdaptiveTextSize on BuildContext {
  double get smallText => MediaQuery.of(this).size.width * 0.03;

  double get mediumText => MediaQuery.of(this).size.width * 0.045;

  double get largeText => MediaQuery.of(this).size.width * 0.06;

  double adjustTextSize(double baseSize, double factor) {
    return baseSize * factor;
  }
}

@Deprecated(
    "Utiliser la classe AppTextSize à la place : AppTextSize(context).[SIZE] ou l'extension AdaptativeTextSize : context.[SIZE]")
class TextSize {
  static double smallText = 10;
  static double mediumText = 16;
  static double largeText = 22;

  double adjustSize(double textSize, double percentage) {
    return textSize * (1 + percentage / 100);
  }
}

// TODO : À supprimer
@Deprecated("Utiliser à la place la classe TextSize : TextSize.smallText")
double smallText() {
  return 10;
}

@Deprecated("Utiliser à la place la classe TextSize : textSize.mediumText")
double mediumText() {
  return 16;
}

@Deprecated("Utiliser à la place la classe TextSize : textSize.largeText")
double largeText() {
  return 22;
}
