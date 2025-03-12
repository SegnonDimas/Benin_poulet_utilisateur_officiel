class TextSize {
  double smallText = 10;
  double mediumText = 16;
  double largeText = 22;

  double adjustSize(double textSize, double percentage) {
    return textSize * (1 + percentage / 100);
  }
}

TextSize textSize = TextSize();

// TODO : À supprimer
@Deprecated("Utiliser à la place la classe TextSize : textSize.smallText")
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
