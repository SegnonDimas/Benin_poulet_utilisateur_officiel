import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/models_ui/model_secteur.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../bloc/choixCategorie/secteur_bloc.dart';
import '../../../../bloc/choixCategorie/secteur_state.dart';
import '../../../models_ui/model_resumeTextFormFiel.dart';

class ResumeCreationBoutiquePage extends StatefulWidget {
  @override
  State<ResumeCreationBoutiquePage> createState() =>
      _ResumeCreationBoutiquePageState();
}

class _ResumeCreationBoutiquePageState
    extends State<ResumeCreationBoutiquePage> {
  ScrollController sectorScrollController = ScrollController();
  ScrollController subSectorScrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    final storeInfoState =
        context.watch<StoreCreationBloc>().state as StoreCreationGlobalState;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          /// résumé infos boutique
          Container(
            height: appHeightSize(context) * 0.05,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 7,
                    child: AppText(text: 'Informations sur votre boutique')),
                Flexible(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: mediumText(),
                        color: primaryColor,
                      ),
                      AppText(
                        text: "Modifier",
                        color: primaryColor,
                        fontSize: smallText() * 1.1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ModelResumeTextField(
            attribut: 'Nom de boutique',
            valeur: storeInfoState.storeName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Tel associé à votre boutique',
            valeur: storeInfoState.storePhoneNumber,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Email boutique',
            valeur: storeInfoState.storeEmail,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),

          //Les secteurs d'activités
          SizedBox(
            width: context.width * 0.92,
            height: appHeightSize(context) * 0.13,
            child: ModelResumeTextField(
              attribut: 'Secteurs d\'activité',
              listeValeur: true,
              valeur: '',
              listeValeurWidget: SizedBox(
                width: context.width * 0.6,
                child: BlocBuilder<SecteurBloc, SecteurState>(
                  builder: (context, sectorState) {
                    return Scrollbar(
                      controller: sectorScrollController,
                      trackVisibility: true,
                      thumbVisibility: true,
                      thickness: 3,
                      radius: Radius.circular(20),
                      child: ListView(
                        controller: sectorScrollController,
                        padding: const EdgeInsets.all(8),
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            sectorState.selectedSectorNames.length, (index) {
                          return ModelSecteur(
                              text: sectorState.selectedSectorNames[index],
                              isSelected: true,
                              activeColor:
                                  AppColors.primaryColor.withOpacity(0.2),
                              disabledColor: Colors.grey,
                              onTap: () {});
                        }),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),

          //Les sous-secteurs d'activités
          SizedBox(
            width: context.width * 0.92,
            height: appHeightSize(context) * 0.13,
            child: ModelResumeTextField(
              attribut: 'Sous Secteurs d\'activité',
              listeValeur: true,
              valeur: '',
              listeValeurWidget: SizedBox(
                width: context.width * 0.6,
                child: BlocBuilder<SecteurBloc, SecteurState>(
                  builder: (context, sectorState) {
                    return Scrollbar(
                      controller: subSectorScrollController,
                      trackVisibility: true,
                      thumbVisibility: true,
                      thickness: 3,
                      radius: Radius.circular(20),
                      child: ListView(
                        controller: subSectorScrollController,
                        padding: const EdgeInsets.all(8),
                        scrollDirection: Axis.horizontal,
                        children: List.generate(
                            sectorState.selectedCategoryNames.length, (index) {
                          return ModelSecteur(
                              text: sectorState.selectedCategoryNames[index],
                              isSelected: true,
                              activeColor:
                                  AppColors.primaryColor.withOpacity(0.2),
                              disabledColor: Colors.grey,
                              onTap: () {});
                        }),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Num translation',
            valeur:
                "${storeInfoState.paymentMethod ?? ""} : ${storeInfoState.paymentPhoneNumber ?? ""} (${storeInfoState.payementOwnerName ?? ""})",
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Statut ficale',
            valeur: storeInfoState.storeFiscalType,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Emplacement',
            valeur: storeInfoState.storeLocation,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),

          //espace
          SizedBox(
            height: 50,
          ),

          /// résumé infos personnelles
          Container(
            height: appHeightSize(context) * 0.05,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    flex: 7,
                    child: AppText(text: 'Vos informations personnelles')),
                Flexible(
                  flex: 2,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit,
                        size: mediumText(),
                        color: primaryColor,
                      ),
                      AppText(
                        text: "Modifier",
                        color: primaryColor,
                        fontSize: smallText() * 1.1,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          ModelResumeTextField(
            attribut: 'Nom',
            valeur: storeInfoState.sellerLastName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Prenom',
            valeur: storeInfoState.sellerFirstName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Date et lieu de naissance',
            valeur:
                '${storeInfoState.sellerBirthDate} à ${storeInfoState.sellerBirthPlace}',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Adresse',
            valeur: storeInfoState.storeEmail,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ModelResumeTextField(
            attribut: 'Type de pièce',
            valeur: 'Type de pièce',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          SizedBox(
            height: appHeightSize(context) * 0.05,
          ),
          // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page InscriptionVendeurPage
          SizedBox(
            height: context.height * 0.07,
          )
        ]),
      ),
    );
  }

  @override
  void dispose() {
    sectorScrollController.dispose();
    subSectorScrollController.dispose();
    super.dispose();
  }
}
