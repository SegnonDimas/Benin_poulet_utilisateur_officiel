import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../widgets/app_textField.dart';

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
                color: Colors.grey.shade200,
              ),

              const SizedBox(
                height: 10,
              ),

              AppText(
                text:
                    'Voici comment votre boutique apparaitra aux clients dans l\'application Bénin Poulet ',
                fontSize: smallText() * 1.2,
                color: Colors.grey.shade400,
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
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade200,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InternationalPhoneNumberInput(
                    onInputChanged: (PhoneNumber number) {
                      // le numéro de téléphone saisi.
                      print(number.phoneNumber);
                    },
                    onInputValidated: (bool value) {
                      // true, si le numéro saisi est correct; false sinon.
                      print('Valeur : $value');
                    },
                    hintText: '',
                    errorMessage: 'Numéro non valide',
                    selectorConfig: const SelectorConfig(
                        selectorType: PhoneInputSelectorType.DIALOG,
                        useBottomSheetSafeArea: true,
                        setSelectorButtonAsPrefixIcon: true,
                        leadingPadding: 10),
                    ignoreBlank: false,
                    autoValidateMode: AutovalidateMode.disabled,
                    selectorTextStyle: const TextStyle(color: Colors.grey),
                    textStyle: const TextStyle(color: Colors.black),
                    initialValue: number,
                    textFieldController: _numeroBoutiqueController,
                    formatInput: true,
                    autoFocus: false,
                    autoFocusSearch: true,
                    keyboardType: const TextInputType.numberWithOptions(
                        signed: true, decimal: true),
                    inputBorder: const OutlineInputBorder(),
                    inputDecoration: const InputDecoration(
                      border: InputBorder.none,
                      /*label: AppText(
                        text: 'Numéro de téléphone',
                        color: Colors.grey,
                      ),*/
                    ),
                    onSaved: (PhoneNumber number) {
                      print('On Saved: $number');
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text: 'Nous appelerons ce numéro en cas de nécessité ',
                fontSize: smallText() * 1.2,
                color: Colors.grey.shade400,
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
                color: Colors.grey.shade200,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              AppText(
                text:
                    'Nous vous enverrons des courriers concernant vos activités sur notre application ',
                fontSize: smallText() * 1.2,
                color: Colors.grey.shade400,
                overflow: TextOverflow.visible,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
