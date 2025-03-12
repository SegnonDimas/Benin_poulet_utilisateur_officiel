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
