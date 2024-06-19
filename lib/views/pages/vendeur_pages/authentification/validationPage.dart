import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ValidationPage extends StatelessWidget {
  const ValidationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final espace = SizedBox(
      height: appHeightSize(context) * 0.03,
    );
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          espace,
          AppText(
            text: 'Bénin Poulet',
            color: primaryColor,
            fontSize: largeText() * 1.5,
          ),
          espace,
          espace,
          espace,
          Center(
            child: Container(
              height: appHeightSize(context) * 0.25,
              width: appHeightSize(context) * 0.25,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(appHeightSize(context)),
                  color: primaryColor),
              child: Icon(
                Icons.hourglass_bottom_outlined,
                color: Colors.white,
                size: largeText() * 3,
              ),
            ),
          ),
          espace,
          AppText(
            text: 'Validation en cours...',
            fontSize: largeText(),
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
              fontSize: smallText(),
            ),
          ),
          espace,
          espace,

          AppButton(
            onTap: () {},
            height: appHeightSize(context) * 0.065,
            width: appWidthSize(context) * 0.9,
            color: primaryColor,
            child: AppText(
              text: 'Nous contacter',
              fontSize: largeText() * 0.9,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AppText(
              text: 'Vous pouvez nous contacter en cas de besoin',
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              fontSize: smallText(),
            ),
          ),
          espace,

          AppButton(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/vendeurMainPage');
            },
            height: appHeightSize(context) * 0.065,
            width: appWidthSize(context) * 0.9,
            color: Theme.of(context).colorScheme.surface,
            borderColor: primaryColor,
            child: AppText(
              text: 'Continuer',
              fontSize: largeText() * 0.9,
              color: primaryColor,
            ),
          )
        ],
      ),
    ));
  }
}
