import 'package:flutter/material.dart';

/// Classe pour la gestion des tailles d'écran
class AppScreenSize {
  final BuildContext context;

  AppScreenSize(this.context);

  double get height => MediaQuery.of(context).size.height;

  double get width => MediaQuery.of(context).size.width;

  double get statusBarHeight => MediaQuery.of(context).padding.top;

  double get bottomBarHeight => MediaQuery.of(context).padding.bottom;

  double get safeHeight => height - statusBarHeight - bottomBarHeight;
}

/// Extension sur BuildContext : alternative
extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;

  double get screenHeight => MediaQuery.of(this).size.height;

  double get statusBarHeight => MediaQuery.of(this).padding.top;

  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  double get safeHeight => screenHeight - statusBarHeight - bottomBarHeight;
}

// TODO : À supprimer
@Deprecated('''
    Utilser à la place la classe AppScreenSize ou l'extension ScreenSize.
    => AppScreenSize(context).height (pour la classe AppScreenSize).
    => context.screenHeight (pour l'extension ScreenSize).
    ''')
double appHeightSize(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  return height;
}

@Deprecated('''
    Utilser à la place la classe AppScreenSize ou l'extension ScreenSize.
    => AppScreenSize(context).width (pour la classe AppScreenSize).
    => context.screenWidth (pour l'extension ScreenSize).
    ''')
double appWidthSize(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return width;
}
