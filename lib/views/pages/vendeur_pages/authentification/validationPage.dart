import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ValidationPage extends StatelessWidget {
  const ValidationPage({super.key});

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
          AppText(
            text: 'Bénin Poulet',
            color: AppColors.primaryColor,
            fontSize: context.largeText * 1.5,
            fontWeight: FontWeight.w900,
          ),
          espace,
          espace,
          Center(
            child: Container(
              height: context.height * 0.3,
              width: context.height * 0.3,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.height),
                  color: Colors.orange),
              child: Icon(
                Icons.hourglass_bottom_rounded,
                color: Colors.white,
                size: context.largeText * 5,
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
                  'Notre équipe analyse vos informations d\'inscription avec soin. Nous nous efforçons de traiter votre demande dans un délai raisonnable.\nVous recevrez une notification de l\'état de votre authentification',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontSize: context.smallText,
            ),
          ),
          espace,
          espace,

          AppButton(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/vendeurMainPage');
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

          AppButton(
            onTap: () {},
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
}
