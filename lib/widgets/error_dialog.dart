import 'package:flutter/material.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:get/get.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showRetry;

  const ErrorDialog({
    Key? key,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
    this.showRetry = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: EdgeInsets.all(context.screenWidth * 0.05),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icône d'erreur
            Container(
              width: context.screenWidth * 0.15,
              height: context.screenWidth * 0.15,
              decoration: BoxDecoration(
                color: AppColors.redColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                color: AppColors.redColor,
                size: context.screenWidth * 0.08,
              ),
            ),

            SizedBox(height: context.screenHeight * 0.02),

            // Titre
            AppText(
              text: title,
              fontSize: context.largeText,
              fontWeight: FontWeight.bold,
              color: AppColors.redColor,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.screenHeight * 0.015),

            // Message
            AppText(
              text: message,
              fontSize: context.mediumText,
              color: Colors.grey[700],
              textAlign: TextAlign.center,
            ),

            SizedBox(height: context.screenHeight * 0.025),

            // Boutons d'action
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (showRetry)
                  Expanded(
                    child: AppButton(
                      height: context.screenHeight * 0.06,
                      color: Colors.grey[300],
                      onTap: () => Navigator.of(context).pop(),
                      child: AppText(
                        text: 'Annuler',
                        color: Colors.grey[700],
                        fontSize: context.mediumText,
                      ),
                    ),
                  ),
                if (showRetry && actionText != null)
                  SizedBox(width: context.screenWidth * 0.02),
                if (actionText != null)
                  Expanded(
                    child: AppButton(
                      height: context.screenHeight * 0.06,
                      color: AppColors.primaryColor,
                      onTap: () {
                        Navigator.of(context).pop();
                        onAction?.call();
                      },
                      child: AppText(
                        text: actionText!,
                        color: Colors.white,
                        fontSize: context.mediumText,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Classe utilitaire pour afficher facilement les dialogues d'erreur
class ErrorDialogUtils {
  /// Affiche un dialogue d'erreur simple
  static void showErrorDialog(
    BuildContext context, {
    required String message,
    String title = 'Erreur',
    String? actionText,
    VoidCallback? onAction,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ErrorDialog(
        title: title,
        message: message,
        actionText: actionText,
        onAction: onAction,
      ),
    );
  }

  /// Affiche un dialogue d'erreur de connexion
  static void showLoginErrorDialog(
    BuildContext context, {
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    showErrorDialog(
      context,
      title: 'Erreur de Connexion',
      message: message,
      actionText: actionText ?? 'Réessayer',
      onAction: onAction,
    );
  }

  /// Affiche un dialogue d'erreur réseau
  static void showNetworkErrorDialog(
    BuildContext context, {
    VoidCallback? onRetry,
  }) {
    showErrorDialog(
      context,
      title: 'Erreur de Réseau',
      message: 'Vérifiez votre connexion internet et réessayez.',
      actionText: 'Réessayer',
      onAction: onRetry,
    );
  }

  /// Affiche un dialogue d'erreur d'identifiants
  static void showCredentialErrorDialog(
    BuildContext context, {
    required String message,
    VoidCallback? onRetry,
  }) {
    showErrorDialog(
      context,
      title: 'Identifiants Incorrects',
      message: message,
      actionText: 'Réessayer',
      onAction: onRetry,
    );
  }
}
