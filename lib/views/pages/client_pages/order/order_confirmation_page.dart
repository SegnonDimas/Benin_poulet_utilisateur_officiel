import 'package:lanhi/constants/routes.dart';
import 'package:lanhi/utils/app_utils.dart';
import 'package:lanhi/views/colors/app_colors.dart';
import 'package:lanhi/views/sizes/text_sizes.dart';
import 'package:lanhi/widgets/app_button.dart';
import 'package:lanhi/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

/// Page de confirmation de commande
class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  const OrderConfirmationPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Commande confirmée',
          fontSize: context.mediumText,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animation de succès
              Lottie.asset(
                'assets/lotties/add_to_cart_success.json',
                width: 200,
                height: 200,
                repeat: true,
              ),

              const SizedBox(height: 30),

              // Titre
              AppText(
                text: 'Commande confirmée !',
                fontSize: context.largeText * 0.9,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Message
              AppText(
                text: 'Votre commande a été créée avec succès.',
                fontSize: context.mediumText,
                textAlign: TextAlign.center,
                maxLines: 2,
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.5),
              ),

              const SizedBox(height: 8),

              // Numéro de commande
              Container(
                width: context.width * 0.9,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    AppText(
                      text: 'Numéro de commande',
                      fontSize: context.smallText,
                      color: Colors.white54,
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      text: '#${orderId.substring(0, 8).toUpperCase()}',
                      fontSize: context.mediumText,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Message informatif

              AppUtils.showInfo(
                width: context.width * 0.9,
                info:
                    'Le vendeur va valider votre commande sous peu. Vous recevrez une notification.',
              ),

              const SizedBox(height: 40),

              // Boutons d'action
              AppButton(
                height: context.height * 0.06,
                width: context.width * 0.9,
                onTap: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.ORDER_TRACKING,
                    arguments: orderId,
                  );
                },
                color: AppColors.primaryColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.visibility, color: Colors.white),
                    const SizedBox(width: 8),
                    AppText(
                      text: 'Suivre ma commande',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              AppButton(
                height: context.height * 0.06,
                width: context.width * 0.9,
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.HOME,
                    (route) => false,
                  );
                },
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.05),
                borderColor: AppColors.primaryColor,
                child: AppText(
                  text: 'Retour à l\'accueil',
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
