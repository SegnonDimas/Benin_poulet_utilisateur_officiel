import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../widgets/app_phone_textField.dart';
import '../../../../widgets/app_textField.dart';

class InfoBoutiquePage extends StatelessWidget {
  final infoBoutiqueFormKey = GlobalKey<FormState>();

  final nomBoutiqueController = TextEditingController();

  final numeroBoutiqueController = TextEditingController();

  final adresseEmailController = TextEditingController();

  final String initialCountry = 'BJ';

  final PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<StoreCreationBloc, StoreCreationState>(
          builder: (context, state) {
            final state = context.watch<StoreCreationBloc>().state
                as StoreCreationGlobalState;

            /*final storeInfo = SubmitStoreInfo(
              storeName: state.storeName,
              storeEmail: state.storeEmail,
              storePhoneNumber: state.storePhoneNumber,
            );*/

            final storeInfo = StoreCreationGlobalEvent(
              storeName: nomBoutiqueController.text,
              storeEmail: adresseEmailController.text,
              storePhoneNumber: numeroBoutiqueController.text,
            );

            return Form(
              //key: infoBoutiqueFormKey,
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
                    controller: nomBoutiqueController,
                    prefixIcon: Icons.storefront,
                    color: Theme.of(context).colorScheme.background,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,

                    // à chaque saisie
                    onChanged: (String string) {
                      context.read<StoreCreationBloc>().add(storeInfo);
                    },

                    // à la soumission
                    onFieldSubmitted: (String? string) {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },

                    // à la fin de la saisie
                    onEditingComplete: () {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },

                    // à la sauvegarde
                    onSaved: (String? string) {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  AppText(
                    text:
                        'Voici comment votre boutique apparaitra aux clients dans l\'application Bénin Poulet ',
                    fontSize: smallText() * 1.2,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.3),
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
                    controller: numeroBoutiqueController,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,

                    // à chaque saisie
                    onInputChanged: (phoneNumber) {
                      context.read<StoreCreationBloc>().add(storeInfo);
                    },
                    //  à la soumission
                    onSubmit: () {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },

                    // à la soumission
                    onFieldSubmitted: (String? string) {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },

                    // lorsque le numéro saisi est valide
                    onInputValidated: (bool isValid) {
                      context.read<StoreCreationBloc>().add(storeInfo);
                    },

                    // à la sauvegarde
                    onSeved: (PhoneNumber? phoneNumber) {
                      context.read<StoreCreationBloc>().add(storeInfo);
                    },

                    // à la validation
                    validator: (String? string) {
                      context.read<StoreCreationBloc>().add(storeInfo);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    text: 'Nous appelerons ce numéro en cas de nécessité ',
                    fontSize: smallText() * 1.2,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.3),
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
                    controller: adresseEmailController,
                    prefixIcon: Icons.email_outlined,
                    color: Theme.of(context).colorScheme.background,
                    keyboardType: TextInputType.emailAddress,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,

                    // à chaque saisie
                    onChanged: (String string) {
                      context.read<StoreCreationBloc>().add(storeInfo);
                    },

                    // à la soumission
                    onFieldSubmitted: (String? string) {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },

                    // à la fin de la saisie
                    onEditingComplete: () {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },

                    // à la sauvegarde
                    onSaved: (String? string) {
                      context.read<StoreCreationBloc>().add(storeInfo);

                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AppText(
                    text:
                        'Nous vous enverrons des courriers concernant vos activités sur notre application ',
                    fontSize: smallText() * 1.2,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.3),
                    overflow: TextOverflow.visible,
                  ),

                  // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page InscriptionVendeurPage
                  SizedBox(
                    height: context.height * 0.07,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
