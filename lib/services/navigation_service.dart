import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:flutter/material.dart';

class NavigationService {
  /// Redirige l'utilisateur vers la page appropriée selon son rôle
  static Future<void> redirectBasedOnRole(BuildContext context) async {
    try {
      final role = await AuthServices.getUserRole();
      
      if (role == null) {
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
          break;
        case UserRoles.BUYER:
          targetRoute = AppRoutes.CLIENTHOMEPAGE;
          break;
        default:
          targetRoute = AppRoutes.FIRSTPAGE;
          break;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        targetRoute,
        (Route<dynamic> route) => false,
      );
    } catch (e) {
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
  static void redirectToSignup(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.SIGNUPWITHEMAILPAGE,
      (Route<dynamic> route) => false,
    );
  }
}
