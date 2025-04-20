import 'dart:async';

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
                text: 'Bénin Poulet',
                color: AppColors.primaryColor,
                fontSize: context.largeText * 1.5,
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
