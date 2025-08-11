//============================
//  NOUVEAU CODE
//============================

/*
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../bloc/fiscalty/delivery_bloc.dart';
import '../bloc/storeCreation/store_creation_bloc.dart';
import '../models/fiscal_info.dart';
import '../widgets/app_phone_textField.dart';
import '../widgets/app_text.dart';

class FiscalityPage extends StatelessWidget {
  const FiscalityPage({super.key});

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
  }) {
    return RadioListTile<String>(
      value: value,
      groupValue: groupValue,
      title: Text(title),
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
            height: 50,
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
            builder: (context, storeState) {
              if (storeState is! StoreCreationGlobalState) {
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
                    groupValue: storeState.storeFiscalType ?? '',
                    title: 'Particulier',
                    onChanged: (val) {
                      context
                          .read<StoreCreationBloc>()
                          .add(StoreCreationGlobalEvent(
                            storeFiscalType: val!,
                            paymentMethod: storeState.paymentMethod,
                            paymentPhoneNumber: storeState.paymentPhoneNumber,
                            payementOwnerName: storeState.payementOwnerName,
                          ));
                    },
                  ),
                  _buildRadioTile(
                    context: context,
                    value: 'Entreprise ou Société individuelle',
                    groupValue: storeState.storeFiscalType ?? '',
                    title: 'Entreprise ou Société individuelle',
                    onChanged: (val) {
                      context
                          .read<StoreCreationBloc>()
                          .add(StoreCreationGlobalEvent(
                            storeFiscalType: val!,
                            paymentMethod: storeState.paymentMethod,
                            paymentPhoneNumber: storeState.paymentPhoneNumber,
                            payementOwnerName: storeState.payementOwnerName,
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
                    fontSize: mediumText(),
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
                          selectedValue: storeState.paymentMethod ?? '',
                          onSelected: (val) {
                            context
                                .read<StoreCreationBloc>()
                                .add(StoreCreationGlobalEvent(
                                  storeFiscalType: storeState.storeFiscalType,
                                  paymentMethod: val,
                                  paymentPhoneNumber:
                                      storeState.paymentPhoneNumber,
                                  payementOwnerName:
                                      storeState.payementOwnerName,
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
                      _updateFiscalInfo(context, storeState);
                    },
                    onSeved: (string) {
                      _updateFiscalInfo(context, storeState);
                      //enregistrement global
                    },
                    onInputValidated: (isValid) {
                      _updateFiscalInfo(context, storeState);
                    },
                    onFieldSubmitted: (string) {
                      _updateFiscalInfo(context, storeState);
                    },
                    onSubmit: () {
                      _updateFiscalInfo(context, storeState);
                    },
                    validator: (string) {
                      _updateFiscalInfo(context, storeState);
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
                      _updateFiscalInfo(context, storeState);
                    },
                    onFieldSubmitted: (String? string) {
                      _updateFiscalInfo(context, storeState);
                    },
                    onSaved: (string) {
                      _updateFiscalInfo(context, storeState);
                    },
                    onEditingComplete: () {
                      _updateFiscalInfo(context, storeState);
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
                      fontSize: smallText() * 1.1,
                    ),
                  ),

                  SizedBox(
                    height: context.height * 0.02,
                  ),

                  // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page CreationBoutiquePage
                  SizedBox(
                    height: context.height * 0.07,
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
*/

//============================
//  ANCIEN CODE
//============================

/*
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../bloc/fiscalty/delivery_bloc.dart';
import '../../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../../../models/fiscal_info.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_textField.dart';
import '../../../colors/app_colors.dart';
import '../../../sizes/app_sizes.dart';

class FiscalitePage extends StatefulWidget {
  const FiscalitePage({super.key});

  @override
  State<FiscalitePage> createState() => _FiscalitePageStateState();
}

class _FiscalitePageStateState extends State<FiscalitePage> {
  final String initialCountry = 'BJ';

  final PhoneNumber paymentPhoneNumber = PhoneNumber(isoCode: 'BJ');

  late TextEditingController payementOwnerNameController;
  late TextEditingController paymentPhoneNumberController;
  String? storeFiscalType = 'Particulier';
  String? paymentMethod;

  @override
  void initState() {
    super.initState();
    final fiscalInfo = context.read<FiscalBloc>().currentInfo;
    payementOwnerNameController =
        TextEditingController(text: fiscalInfo.payementOwnerNameController);
    paymentPhoneNumberController =
        TextEditingController(text: fiscalInfo.paymentPhoneNumberController);
    storeFiscalType = fiscalInfo.storeFiscalType;
    paymentMethod = fiscalInfo.paymentMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<FiscalBloc, FiscalState>(
          builder: (context, fiscalState) {
            return BlocConsumer<StoreCreationBloc, StoreCreationState>(
              listener: (context, storeCreationState) {
                // TODO: implement listener
              },
              builder: (context, storeCreationState) {
                //final fiscalityState = context.watch<StoreCreationBloc>()
                final state = context.watch<StoreCreationBloc>().state
                    as StoreCreationGlobalState;
                final fiscalInfo = FiscalInfo(
                  payementOwnerNameController: payementOwnerNameController.text,
                  paymentPhoneNumberController:
                      paymentPhoneNumberController.text,
                  paymentMethod: paymentMethod,
                  storeFiscalType: storeFiscalType,
                );

                final storeFiscalty = StoreCreationGlobalEvent(
                  storeFiscalType: fiscalState.info.storeFiscalType,
                  paymentMethod: fiscalState.info.paymentMethod,
                  paymentPhoneNumber:
                      fiscalState.info.paymentPhoneNumberController,
                  payementOwnerName:
                      fiscalState.info.payementOwnerNameController,
                );

                return ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AppText(
                      text:
                          'Sur le plan fiscal, quel type de vendeur êtes-vous ?',
                      fontSize: mediumText(),
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.visible,
                    ),

                    //Particulier
                    ListTile(
                      title: AppText(
                        text: 'Particulier',
                        fontSize: smallText() * 1.3,
                        fontWeight: state.storeFiscalType == 'Particulier'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: state.storeFiscalType == 'Particulier'
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.3),
                      ),
                      leading: Radio<String>(
                        value: 'Particulier',
                        groupValue: state.storeFiscalType,
                        activeColor: primaryColor,
                        focusColor: Colors.grey,
                        hoverColor: Colors.grey,
                        onChanged: (String? type) {
                          storeFiscalType = 'Particulier';
                          context
                              .read<FiscalBloc>()
                              .add(SubmitFiscalInfo(fiscalInfo));

                          context
                              .read<StoreCreationBloc>()
                              .add(SubmitPaymentInfo(
                                storeFiscalType: storeFiscalType,
                              ));

                          //enregistrement global
                          context.read<StoreCreationBloc>().add(storeFiscalty);
                        },
                      ),
                      horizontalTitleGap: 0,
                      onTap: () {
                        storeFiscalType = 'Particulier';
                        context
                            .read<FiscalBloc>()
                            .add(SubmitFiscalInfo(fiscalInfo));

                        context.read<StoreCreationBloc>().add(SubmitPaymentInfo(
                              storeFiscalType: storeFiscalType,
                            ));

                        //enregistrement global
                        context.read<StoreCreationBloc>().add(storeFiscalty);
                      },
                    ),

                    // Entreprise ou Société individuelle
                    ListTile(
                      title: AppText(
                        text: 'Entreprise ou Société individuelle',
                        fontSize: smallText() * 1.3,
                        overflow: TextOverflow.visible,
                        fontWeight: storeFiscalType ==
                                'Entreprise ou Société individuelle'
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: state.storeFiscalType ==
                                'Entreprise ou Société individuelle'
                            ? Theme.of(context).colorScheme.inversePrimary
                            : Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.3),
                      ),
                      leading: Radio<String>(
                        value: 'Entreprise ou Société individuelle',
                        groupValue: state.storeFiscalType,
                        activeColor: primaryColor,
                        focusColor: Colors.grey,
                        hoverColor: Colors.grey,
                        onChanged: (String? type) {
                          storeFiscalType = type!;
                          context
                              .read<FiscalBloc>()
                              .add(SubmitFiscalInfo(fiscalInfo));

                          context
                              .read<StoreCreationBloc>()
                              .add(SubmitPaymentInfo(
                                storeFiscalType: storeFiscalType,
                              ));

                          //enregistrement global
                          context.read<StoreCreationBloc>().add(storeFiscalty);
                        },
                      ),
                      horizontalTitleGap: 0,
                      onTap: () {
                        storeFiscalType = 'Entreprise ou Société individuelle';
                        context
                            .read<FiscalBloc>()
                            .add(SubmitFiscalInfo(fiscalInfo));

                        context.read<StoreCreationBloc>().add(SubmitPaymentInfo(
                              storeFiscalType: storeFiscalType,
                            ));

                        //enregistrement global
                        context.read<StoreCreationBloc>().add(storeFiscalty);
                      },
                    ),
                    //SizedBox(height: 20),
                    Divider(
                      color: Theme.of(context).colorScheme.secondary,
                    ),

                    // Mobile money
                    AppText(
                      text: 'Mobile Money',
                      fontSize: mediumText(),
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Mobile money options : Celtiis, MTN, Moov
                    SizedBox(
                      height: appHeightSize(context) * 0.08,
                      width: appWidthSize(context),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: appWidthSize(context) * 0.025,
                        ),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            // Celtiis
                            Stack(
                              children: [
                                ChoiceChip(
                                  label: AppText(
                                    text: 'Celtiis',
                                    color: state.paymentMethod == 'Celtiis'
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withAlpha(50),
                                  ),
                                  pressElevation: 20,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10, right: 7),
                                  //selected: paymentMethod == 'Celtiis',
                                  selected: state.paymentMethod == 'Celtiis',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  shadowColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  //selectedColor: primaryColor,
                                  selectedColor: Colors.deepPurpleAccent,
                                  checkmarkColor: Colors.white,
                                  tooltip:
                                      'Recevoir de l\'argent par Celtiis Money',
                                  onSelected: (bool selected) {
                                    paymentMethod = 'Celtiis';
                                    context
                                        .read<FiscalBloc>()
                                        .add(SubmitFiscalInfo(fiscalInfo));

                                    context
                                        .read<StoreCreationBloc>()
                                        .add(SubmitPaymentInfo(
                                          paymentMethod: paymentMethod,
                                        ));

                                    //enregistrement global
                                    context
                                        .read<StoreCreationBloc>()
                                        .add(storeFiscalty);
                                  },
                                ),
                                Container(
                                    width: 12,
                                    height: 50,
                                    decoration: const BoxDecoration(
                                        color: Colors.deepPurpleAccent,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))))
                              ],
                            ),

                            // MTN
                            Padding(
                              padding: EdgeInsets.only(
                                  left: appWidthSize(context) * 0.05,
                                  right: appWidthSize(context) * 0.05),
                              child: Stack(
                                children: [
                                  ChoiceChip(
                                    label: AppText(
                                      text: 'MTN',
                                      color: state.paymentMethod == 'MTN'
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .inverseSurface
                                              .withAlpha(50),
                                    ),
                                    pressElevation: 20,
                                    side: BorderSide.none,
                                    padding: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 15,
                                        left: 10,
                                        right: 7),
                                    selected: state.paymentMethod == 'MTN',
                                    tooltip:
                                        'Recevoir de l\'argent par MTN Money',
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    shadowColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    //selectedColor: primaryColor,
                                    selectedColor: Colors.orange,
                                    checkmarkColor: Colors.white,
                                    onSelected: (bool selected) {
                                      paymentMethod = 'MTN';
                                      context
                                          .read<FiscalBloc>()
                                          .add(SubmitFiscalInfo(fiscalInfo));

                                      context
                                          .read<StoreCreationBloc>()
                                          .add(SubmitPaymentInfo(
                                            paymentMethod: paymentMethod,
                                          ));

                                      //enregistrement global
                                      context
                                          .read<StoreCreationBloc>()
                                          .add(storeFiscalty);
                                    },
                                  ),
                                  Container(
                                      width: 12,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              bottomLeft: Radius.circular(10))))
                                ],
                              ),
                            ),

                            // Moov Africa
                            Stack(
                              children: [
                                ChoiceChip(
                                  label: AppText(
                                    text: 'Moov Africa',
                                    color: state.paymentMethod == 'Moov Africa'
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withAlpha(50),
                                  ),
                                  pressElevation: 20,
                                  side: BorderSide.none,
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15, left: 10, right: 7),
                                  selected:
                                      state.paymentMethod == 'Moov Africa',
                                  tooltip:
                                      'Recevoir de l\'argent par Moov Money',
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  shadowColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  selectedColor: primaryColor,
                                  checkmarkColor: Colors.white,
                                  onSelected: (bool selected) {
                                    paymentMethod = 'Moov Africa';
                                    context
                                        .read<FiscalBloc>()
                                        .add(SubmitFiscalInfo(fiscalInfo));

                                    context
                                        .read<StoreCreationBloc>()
                                        .add(SubmitPaymentInfo(
                                          paymentMethod: paymentMethod,
                                        ));

                                    //enregistrement global
                                    context
                                        .read<StoreCreationBloc>()
                                        .add(storeFiscalty);
                                  },
                                ),
                                Container(
                                    width: 12,
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color:
                                            primaryColor, //Colors.lightGreen,
                                        borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10))))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: appHeightSize(context) * 0.02),

                    */
/*DropdownButton<String>(
                  value: state.paymentMethod,
                  items: ['MTN', 'Moov Africa', 'Celtiis'].map((op) {
                    return DropdownMenuItem(value: op, child: Text(op));
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context
                          .read<StoreCreationBloc>()
                          .add(StoreCreationGlobalEvent(
                            paymentMethod: value,
                          ));
                    }
                  },
                ),*/
/*
//Numéro de translations et nom associé
                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            text: 'Numéro de paiement',
                            fontSize: mediumText(),
                            fontWeight: FontWeight.bold,
                          ),

                          // Numéro de téléphone
                          const SizedBox(height: 20),
                          AppPhoneTextField(
                            controller: paymentPhoneNumberController,
                            fontSize: mediumText() * 0.9,
                            fontColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            onInputChanged: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    paymentPhoneNumber:
                                        paymentPhoneNumberController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onSeved: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    paymentPhoneNumber:
                                        paymentPhoneNumberController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onInputValidated: (isValid) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    paymentPhoneNumber:
                                        paymentPhoneNumberController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onFieldSubmitted: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    paymentPhoneNumber:
                                        paymentPhoneNumberController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onSubmit: () {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    paymentPhoneNumber:
                                        paymentPhoneNumberController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            validator: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    paymentPhoneNumber:
                                        paymentPhoneNumberController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                          ),
                          const SizedBox(height: 20),

                          // Nom prénom lié au numéro de paiement
                          AppTextField(
                            label: 'Nom Prénom',
                            height: appHeightSize(context) * 0.08,
                            width: appWidthSize(context) * 0.9,
                            color: Theme.of(context).colorScheme.background,
                            controller: payementOwnerNameController,
                            prefixIcon: CupertinoIcons.person_alt_circle,
                            fontSize: mediumText() * 0.9,
                            fontColor:
                                Theme.of(context).colorScheme.inversePrimary,
                            onChanged: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    payementOwnerName:
                                        payementOwnerNameController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onFieldSubmitted: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    payementOwnerName:
                                        payementOwnerNameController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onSaved: (string) {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    payementOwnerName:
                                        payementOwnerNameController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                            onEditingComplete: () {
                              context
                                  .read<FiscalBloc>()
                                  .add(SubmitFiscalInfo(fiscalInfo));

                              context
                                  .read<StoreCreationBloc>()
                                  .add(SubmitPaymentInfo(
                                    payementOwnerName:
                                        payementOwnerNameController.text,
                                  ));

                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeFiscalty);
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // texte
                    SizedBox(
                      width: appWidthSize(context) * 0.8,
                      child: AppText(
                        text:
                            "Vous pouvez faire des modifications après dans les paramètres",
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3),
                        overflow: TextOverflow.visible,
                        fontSize: smallText() * 1.1,
                      ),
                    ),

                    SizedBox(
                      height: appHeightSize(context) * 0.02,
                    ),

                    // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page CreationBoutiquePage
                    SizedBox(
                      height: context.height * 0.07,
                    )
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
*/
