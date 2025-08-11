import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../bloc/fiscalty/fiscal_bloc.dart';
import '../../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../../../models/fiscal_info.dart';
import '../../../../widgets/app_phone_textField.dart';
import '../../../../widgets/app_text.dart';

class FiscalitePage extends StatelessWidget {
  const FiscalitePage({super.key});

  void _updateFiscalInfo(BuildContext context, StoreCreationGlobalState state) {
    final bloc = context.read<FiscalBloc>();
    final info = FiscalInfo(
      storeFiscalType: state.storeFiscalType,
      paymentMethod: state.paymentMethod,
      paymentPhoneNumberController: bloc.paymentPhoneNumberController.text,
      payementOwnerNameController: bloc.payementOwnerNameController.text,
    );

    context.read<FiscalBloc>().add(SubmitFiscalInfo(info));

    context.read<StoreCreationBloc>().add(SubmitPaymentInfo(
          storeFiscalType: state.storeFiscalType,
          paymentMethod: state.paymentMethod,
        ));

    context.read<StoreCreationBloc>().add(StoreCreationGlobalEvent(
          storeFiscalType: info.storeFiscalType,
          paymentMethod: info.paymentMethod,
          paymentPhoneNumber: info.paymentPhoneNumberController,
          payementOwnerName: info.payementOwnerNameController,
        ));
  }

  Widget _buildRadioTile({
    required BuildContext context,
    required String value,
    required String groupValue,
    required String title,
    required Function(String?) onChanged,
    Color? color,
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      title: AppText(
        text: title,
        overflow: TextOverflow.visible,
        color: color,
        fontWeight: FontWeight.bold,
      ),
      onChanged: onChanged,
      activeColor: AppColors.primaryColor,
    );
  }

  // pour l'interface des choix d'options de paiement
  Widget _buildChoiceChip({
    required BuildContext context,
    required String label,
    required String selectedValue,
    required void Function(String) onSelected,
  }) {
    final bool isSelected = selectedValue == label;

    return Padding(
      padding: EdgeInsets.only(
          left: context.height * 0.015, right: context.width * 0.015),
      child: Stack(
        children: [
          ChoiceChip(
            label: AppText(
              text: label,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.inverseSurface.withAlpha(50),
            ),
            pressElevation: 20,
            side: BorderSide.none,
            padding:
                const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 7),
            selected: isSelected,
            backgroundColor: Theme.of(context).colorScheme.background,
            shadowColor: Theme.of(context).colorScheme.inversePrimary,
            selectedColor: _getChipColor(label),
            checkmarkColor: Colors.white,
            tooltip: 'Recevoir de l\'argent par $label',
            onSelected: (bool selected) {
              onSelected(label);
            },
          ),
          Container(
            width: 12,
            height: 49,
            decoration: BoxDecoration(
              color: _getChipColor(label),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Fonction pour retourner la couleur spécifique de chaque option
  Color _getChipColor(String label) {
    switch (label) {
      case 'Celtiis':
        return Colors.deepPurpleAccent;
      case 'MTN':
        return Colors.orange;
      case 'Moov Africa':
        return Colors.lightGreen.shade700;
      default:
        return Colors.grey.withOpacity(0.3); //.colorScheme.background;
    }
  }

  @override
  Widget build(BuildContext context) {
    final fiscalBloc = context.read<FiscalBloc>();

    return Scaffold(
      body: BlocConsumer<FiscalBloc, FiscalState>(
        listener: (context, fiscalState) {
          //TODO: implement listener
        },
        builder: (context, fiscalState) {
          return BlocBuilder<StoreCreationBloc, StoreCreationState>(
            builder: (context, storeCreationState) {
              if (storeCreationState is! StoreCreationGlobalState) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  AppText(
                    text:
                        'Sur le plan fiscal, quel type de vendeur êtes-vous ?',
                    fontSize: context.mediumText,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.visible,
                  ),
                  _buildRadioTile(
                    context: context,
                    value: 'Particulier',
                    groupValue: storeCreationState.storeFiscalType ?? '',
                    title: 'Particulier',
                    color: storeCreationState.storeFiscalType == 'Particulier'
                        ? Theme.of(context).colorScheme.inverseSurface
                        : Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.2),
                    onChanged: (val) {
                      context
                          .read<StoreCreationBloc>()
                          .add(StoreCreationGlobalEvent(
                            storeFiscalType: val!,
                            paymentMethod: storeCreationState.paymentMethod,
                            paymentPhoneNumber:
                                storeCreationState.paymentPhoneNumber,
                            payementOwnerName:
                                storeCreationState.payementOwnerName,
                          ));
                    },
                  ),
                  _buildRadioTile(
                    context: context,
                    value: 'Entreprise ou Société individuelle',
                    groupValue: storeCreationState.storeFiscalType ?? '',
                    title: 'Entreprise ou Société individuelle',
                    color: storeCreationState.storeFiscalType ==
                            'Entreprise ou Société individuelle'
                        ? Theme.of(context).colorScheme.inversePrimary
                        : Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.2),
                    onChanged: (val) {
                      context
                          .read<StoreCreationBloc>()
                          .add(StoreCreationGlobalEvent(
                            storeFiscalType: val!,
                            paymentMethod: storeCreationState.paymentMethod,
                            paymentPhoneNumber:
                                storeCreationState.paymentPhoneNumber,
                            payementOwnerName:
                                storeCreationState.payementOwnerName,
                          ));
                    },
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: Theme.of(context).colorScheme.secondary,
                  ),

                  // Mobile money
                  AppText(
                    text: 'Mobile Money',
                    fontSize: context.mediumText,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Liste des options de paiement
                  SizedBox(
                    height: context.height * 0.1,
                    child: ListView(
                      //spacing: 8.0,
                      scrollDirection: Axis.horizontal,
                      children: ['Celtiis', 'MTN', 'Moov Africa'].map((method) {
                        return _buildChoiceChip(
                          context: context,
                          label: method,
                          selectedValue: storeCreationState.paymentMethod ?? '',
                          onSelected: (val) {
                            context
                                .read<StoreCreationBloc>()
                                .add(StoreCreationGlobalEvent(
                                  storeFiscalType:
                                      storeCreationState.storeFiscalType,
                                  paymentMethod: val,
                                  paymentPhoneNumber:
                                      storeCreationState.paymentPhoneNumber,
                                  payementOwnerName:
                                      storeCreationState.payementOwnerName,
                                ));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Champ de saisie pour le numéro de téléphone
                  AppPhoneTextField(
                    controller: fiscalBloc.paymentPhoneNumberController,
                    hintText: 'Numéro de paiement',
                    fontSize: context.mediumText * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                    onInputChanged: (string) {
                      _updateFiscalInfo(context, storeCreationState);
                    },
                    onSeved: (string) {
                      _updateFiscalInfo(context, storeCreationState);
                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },
                    onInputValidated: (isValid) {
                      _updateFiscalInfo(context, storeCreationState);
                    },
                    onFieldSubmitted: (string) {
                      _updateFiscalInfo(context, storeCreationState);
                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },
                    onSubmit: () {
                      _updateFiscalInfo(context, storeCreationState);
                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },
                    validator: (string) {
                      _updateFiscalInfo(context, storeCreationState);
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Champ de saisie pour le nom du titulaire du compte
                  // Nom prénom lié au numéro de paiement
                  AppTextField(
                    label: 'Nom du titulaire du compte',
                    height: context.height * 0.08,
                    width: context.width * 0.9,
                    color: Theme.of(context).colorScheme.background,
                    controller: fiscalBloc.payementOwnerNameController,
                    prefixIcon: CupertinoIcons.person_alt_circle,
                    fontSize: context.mediumText * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                    onChanged: (String string) {
                      _updateFiscalInfo(context, storeCreationState);
                    },
                    onFieldSubmitted: (String? string) {
                      _updateFiscalInfo(context, storeCreationState);
                      FocusScope.of(context)
                          .unfocus(); //force le clavier à valider
                    },
                    onSaved: (string) {
                      _updateFiscalInfo(context, storeCreationState);
                    },
                    onEditingComplete: () {
                      _updateFiscalInfo(context, storeCreationState);
                    },
                  ),

                  const SizedBox(height: 20),

                  // texte
                  SizedBox(
                    width: context.width * 0.8,
                    child: AppText(
                      text:
                          "Vous pouvez faire des modifications après dans les paramètres",
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3),
                      overflow: TextOverflow.visible,
                      fontSize: context.smallText * 1.1,
                    ),
                  ),

                  SizedBox(
                    height: context.height * 0.02,
                  ),

                  // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page CreationBoutiquePage
                  /*SizedBox(
                    height: context.height * 0.07,
                  )*/
                ],
              );
            },
          );
        },
      ),
    );
  }
}
