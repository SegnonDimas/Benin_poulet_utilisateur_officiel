import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/constants/authProviders.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/services/navigation_service.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class SignupService {
  /// Inscription avec email et mot de passe
  static Future<void> signUpWithEmail({
    required BuildContext context,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      // Vérifier si l'utilisateur existe déjà
      final userExists = await AuthServices.userExistsWithEmail(email);
      if (userExists) {
        AppUtils.showInfoDialog(
          context: context,
          message: 'Un compte existe déjà avec cette adresse email.',
          type: InfoType.error,
        );
        return;
      }

      // Créer le compte
      await AuthServices.createEmailAuth(
        email,
        password,
        role: role,
        authProvider: AuthProviders.EMAIL,
      );

      AppUtils.showAwesomeSnackBar(
        context,
        'Inscription Réussie',
        'Votre compte a été créé avec succès',
        ContentType.success,
        Colors.green,
      );

      // Redirection basée sur le rôle
      await NavigationService.redirectBasedOnRole(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Un compte existe déjà avec cette adresse email.';
          break;
        case 'weak-password':
          errorMessage = 'Le mot de passe est trop faible. Utilisez au moins 6 caractères.';
          break;
        case 'invalid-email':
          errorMessage = 'L\'adresse email n\'est pas valide.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'L\'inscription par email n\'est pas activée.';
          break;
        default:
          errorMessage = 'Erreur lors de l\'inscription: ${e.message}';
          break;
      }
      
      AppUtils.showInfoDialog(
        context: context,
        message: errorMessage,
        type: InfoType.error,
      );
    } catch (e) {
      AppUtils.showInfoDialog(
        context: context,
        message: 'Une erreur inattendue s\'est produite lors de l\'inscription. Veuillez réessayer.',
        type: InfoType.error,
      );
    }
  }

  /// Inscription avec numéro de téléphone
  static Future<void> signUpWithPhone({
    required BuildContext context,
    required PhoneNumber phoneNumber,
    required String password,
    required String role,
    String? fullName,
  }) async {
    try {
      // Vérifier si l'utilisateur existe déjà
      final userExists = await AuthServices.userExistsWithPhone(phoneNumber.phoneNumber!);
      if (userExists) {
        AppUtils.showInfoDialog(
          context: context,
          message: 'Un compte existe déjà avec ce numéro de téléphone.',
          type: InfoType.error,
        );
        return;
      }

      // Créer le compte
      await AuthServices.createPhoneAuth(
        phoneNumber,
        password,
        role: role,
        authProvider: AuthProviders.PHONE,
        fullName: fullName,
      );

      AppUtils.showAwesomeSnackBar(
        context,
        'Inscription Réussie',
        'Votre compte a été créé avec succès',
        ContentType.success,
        Colors.green,
      );

      // Redirection basée sur le rôle
      await NavigationService.redirectBasedOnRole(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Un compte existe déjà avec ce numéro de téléphone.';
          break;
        case 'weak-password':
          errorMessage = 'Le mot de passe est trop faible. Utilisez au moins 6 caractères.';
          break;
        case 'invalid-phone-number':
          errorMessage = 'Le numéro de téléphone n\'est pas valide.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'L\'inscription par téléphone n\'est pas activée.';
          break;
        default:
          errorMessage = 'Erreur lors de l\'inscription: ${e.message}';
          break;
      }
      
      AppUtils.showInfoDialog(
        context: context,
        message: errorMessage,
        type: InfoType.error,
      );
    } catch (e) {
      AppUtils.showInfoDialog(
        context: context,
        message: 'Une erreur inattendue s\'est produite lors de l\'inscription. Veuillez réessayer.',
        type: InfoType.error,
      );
    }
  }

  /// Inscription avec Google
  static Future<void> signUpWithGoogle({
    required BuildContext context,
    required String role,
  }) async {
    try {
      // Créer le compte
      final user = await AuthServices.signUpWithGoogle(role: role);
      
      if (user != null) {
        AppUtils.showAwesomeSnackBar(
          context,
          'Inscription Réussie',
          'Votre compte a été créé avec succès',
          ContentType.success,
          Colors.green,
        );

        // Redirection basée sur le rôle
        await NavigationService.redirectBasedOnRole(context);
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Un compte existe déjà avec cette adresse email.';
          break;
        case 'account-exists-with-different-credential':
          errorMessage = 'Un compte existe déjà avec cette adresse email mais avec une méthode de connexion différente.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'L\'inscription Google n\'est pas activée.';
          break;
        default:
          errorMessage = 'Erreur lors de l\'inscription Google: ${e.message}';
          break;
      }
      
      AppUtils.showInfoDialog(
        context: context,
        message: errorMessage,
        type: InfoType.error,
      );
    } catch (e) {
      AppUtils.showInfoDialog(
        context: context,
        message: 'Une erreur inattendue s\'est produite lors de l\'inscription Google. Veuillez réessayer.',
        type: InfoType.error,
      );
    }
  }
}
