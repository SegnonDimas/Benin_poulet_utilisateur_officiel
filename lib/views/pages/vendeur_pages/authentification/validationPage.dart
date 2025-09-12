import 'dart:async';

import 'package:benin_poulet/constants/app_attributs.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../constants/routes.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_text.dart';
import '../../../colors/app_colors.dart';

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage>
    with SingleTickerProviderStateMixin {
  int delai = 10;
  late Timer _timer;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _startDecompte();
    _rotationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(); // fait tourner indéfiniment
  }

  void _startDecompte() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (delai > 0) {
        setState(() {
          delai--;
        });
      } else {
        timer.cancel();
        _rotationController.stop();
        Navigator.pushReplacementNamed(context, AppRoutes.VENDEURPROFILPAGE);
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final espace = SizedBox(
      height: context.height * 0.03,
    );
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          espace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 23,
              ),
              AppText(
                text: AppAttributes.appName,
                color: AppColors.primaryColor,
                fontSize: context.largeText * 1.2,
                fontWeight: FontWeight.w900,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: AppText(
                  text: '$delai',
                  fontWeight: FontWeight.w900,
                  fontSize: context.mediumText * 1.2,
                ),
              )
            ],
          ),
          espace,
          espace,
          RotationTransition(
            turns: _rotationController,
            child: Hero(
              tag: '1',
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                ),
                child: const Icon(
                  Icons.hourglass_bottom_rounded,
                  color: Colors.white,
                  size: 90,
                ),
              ),
            ),
          ),
          espace,
          AppText(
            text: 'Validation en cours...',
            fontSize: context.largeText,
            fontWeight: FontWeight.bold,
          ),
          //espace,
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppText(
              text:
                  'Notre équipe analyse vos informations d\'inscription avec soin. Nous nous efforçons de traiter votre demande dans un délai raisonnable.\n\nVous recevrez une notification de l\'état de votre authentification',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontSize: context.smallText,
            ),
          ),
          espace,
          espace,

          AppButton(
            onTap: () {
              Navigator.pushReplacementNamed(
                  context, AppRoutes.VENDEURPROFILPAGE);
              Navigator.pop(context);
            },
            height: context.height * 0.065,
            width: context.width * 0.9,
            color: AppColors.primaryColor,
            //borderColor: AppColors.primaryColor,
            child: AppText(
              text: 'Continuer',
              fontSize: context.largeText * 0.9,
              color: Colors.white,
            ),
          ),
          espace,

          Hero(
            tag: 'imageProfil',
            child: AppButton(
              onTap: () {
                Navigator.pop(context);
                _showHelpDialog();
              },
              height: context.height * 0.065,
              width: context.width * 0.9,
              color: Theme.of(context).colorScheme.background,
              borderColor: AppColors.primaryColor,
              child: AppText(
                text: 'Nous contacter',
                fontSize: context.largeText * 0.9,
                //color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppText(
              text: 'Vous pouvez nous contacter en cas de besoin',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontSize: context.smallText,
            ),
          ),
        ],
      ),
    ));
  }

  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      text: 'Aide & Support',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      overflow: TextOverflow.visible,
                      maxLine: 2,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Comment pouvons-nous vous aider ?',
                          fontSize: 16,
                        ),
                        const SizedBox(height: 24),

                        // Contact items
                        _buildContactItem(
                          icon: Icons.phone,
                          title: 'Téléphone',
                          subtitle: AppAttributes.appAuthorPhone,
                          onTap: () {
                            // TODO: Implémenter l'appel téléphonique
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: AppAttributes.appAuthorEmail,
                          onTap: () {
                            // TODO: Implémenter l'envoi d'email
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.access_time,
                          title: 'Horaires de support',
                          subtitle: 'Lun - Ven: 8h - 18h\nSam: 9h - 15h',
                          onTap: null,
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construit un élément de contact
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primaryColor.withOpacity(0.05)
              : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onTap != null
                ? AppColors.primaryColor.withOpacity(0.2)
                : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // color: Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: subtitle,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }
}
