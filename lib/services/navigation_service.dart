import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';

class NavigationService {
  /// Redirige l'utilisateur vers la page appropriée selon son rôle
  static Future<void> redirectBasedOnRole(BuildContext context) async {
    try {
      print('=== REDIRECTION BASÉE SUR LE RÔLE ===');
      
      final role = await AuthServices.getUserRole();
      print('Rôle récupéré: $role');

      if (role == null) {
        print('Aucun rôle trouvé, redirection vers FIRSTPAGE');
        // Aucun rôle trouvé, rediriger vers la page de sélection de rôle
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.FIRSTPAGE,
          (Route<dynamic> route) => false,
        );
        return;
      }

      String targetRoute;
      switch (role) {
        case UserRoles.SELLER:
          targetRoute = AppRoutes.VENDEURMAINPAGE;
          print('Redirection vers VENDEURMAINPAGE');
          break;
        case UserRoles.BUYER:
          targetRoute = AppRoutes.CLIENTHOMEPAGE;
          print('Redirection vers CLIENTHOMEPAGE');
          break;
        default:
          targetRoute = AppRoutes.FIRSTPAGE;
          print('Redirection vers FIRSTPAGE (rôle par défaut)');
          break;
      }

      print('Route cible: $targetRoute');
      Navigator.pushNamedAndRemoveUntil(
        context,
        targetRoute,
        (Route<dynamic> route) => false,
      );
      print('=== REDIRECTION TERMINÉE ===');
    } catch (e) {
      print('Erreur lors de la redirection: $e');
      // En cas d'erreur, rediriger vers la page d'accueil
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.FIRSTPAGE,
        (Route<dynamic> route) => false,
      );
    }
  }

  /// Redirige vers la page de connexion
  static void redirectToLogin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.LOGINPAGE,
      (Route<dynamic> route) => false,
    );
  }

  /// Redirige vers la page d'inscription
  static void redirectToSignup(BuildContext context,
      {String? content, String? title, Color? titleColor}) {
    //Navigator.pop(context); // fermer le loading de AuthLoading
    AppUtils.showDialog(
        context: context,
        barrierDismissible: false,
        title: title ?? 'Passez à l\'inscription',
        titleColor: titleColor ?? AppColors.primaryColor,
        content: content ??
            'Si vous n\'avez pas encore de compte, veuillez vous inscrire',
        cancelText: 'S\'inscrire',
        confirmText: 'Réessayez',
        cancelTextColor:
            Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
        confirmTextColor: AppColors.primaryColor,
        cancelTextSize: context.smallText,
        confirmTextSize: context.mediumText * 0.95,
        onConfirm: () {
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pushNamed(context, AppRoutes.PRESENTATIONPAGE);
        });

    /*Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.SIGNUPWITHEMAILPAGE,
      (Route<dynamic> route) => false,
    );*/
  }
}
