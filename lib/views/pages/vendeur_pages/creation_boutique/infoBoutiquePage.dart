import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../widgets/app_textField.dart';

class InfoBoutiquePage extends StatefulWidget {
  @override
  _InfoBoutiquePageState createState() => _InfoBoutiquePageState();
}

class _InfoBoutiquePageState extends State<InfoBoutiquePage> {
  final _formKey = GlobalKey<FormState>();

  final _nomBoutiqueController = TextEditingController();
  final _numeroBoutiqueController = TextEditingController();
  final _adresseEmailController = TextEditingController();
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              // nom de la boutique
              AppText(
                text: 'Nom de votre boutique',
                fontWeight: FontWeight.bold,
                fontSize: mediumText() * 1.1,
              ),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                label: 'Nom de la boutique',
                height: appHeightSize(context) * 0.08,
                width: appWidthSize(context) * 0.9,
                controller: _nomBoutiqueController,
                prefixIcon: Icons.storefront,
                color: Theme.of(context).colorScheme.surface,
                fontSize: mediumText() * 0.9,
                fontColor: Theme.of(context).colorScheme.inversePrimary,
              ),

              const SizedBox(
                height: 10,
              ),

              AppText(
                text:
                    'Voici comment votre boutique apparaitra aux clients dans l\'application Bénin Poulet ',
                fontSize: smallText() * 1.2,
                color: Theme.of(context).colorScheme.secondary,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(
                height: 10,
              ),

              // Numéro de téléphone
              const SizedBox(height: 20),
              AppText(
                text: 'Numéro de votre boutique',
                fontWeight: FontWeight.bold,
                fontSize: mediumText() * 1.1,
              ),
              const SizedBox(
                height: 10,
              ),
              AppPhoneTextField(
                controller: _numeroBoutiqueController,
                fontSize: mediumText() * 0.9,
                fontColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text: 'Nous appelerons ce numéro en cas de nécessité ',
                fontSize: smallText() * 1.2,
                color: Theme.of(context).colorScheme.secondary,
                overflow: TextOverflow.visible,
              ),
              const SizedBox(height: 20),

              // Adresse email
              AppText(
                text: 'Adresse email',
                fontWeight: FontWeight.bold,
                fontSize: mediumText() * 1.1,
              ),
              const SizedBox(
                height: 10,
              ),
              AppTextField(
                label: 'Adresse email',
                height: appHeightSize(context) * 0.08,
                width: appWidthSize(context) * 0.9,
                controller: _adresseEmailController,
                prefixIcon: Icons.email_outlined,
                color: Theme.of(context).colorScheme.surface,
                keyboardType: TextInputType.emailAddress,
                fontSize: mediumText() * 0.9,
                fontColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text:
                    'Nous vous enverrons des courriers concernant vos activités sur notre application ',
                fontSize: smallText() * 1.2,
                color: Theme.of(context).colorScheme.secondary,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
