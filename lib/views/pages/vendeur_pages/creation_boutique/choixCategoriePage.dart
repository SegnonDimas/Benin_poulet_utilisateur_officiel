import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../bloc/choixCategorie/secteur_bloc.dart';
import '../../../../bloc/choixCategorie/secteur_event.dart';
import '../../../../bloc/choixCategorie/secteur_state.dart';
import '../../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../../models_ui/model_secteur.dart';

class ChoixCategoriePage extends StatelessWidget {
  const ChoixCategoriePage({super.key});

  //final List<String>? storeSectors = [];
  //final List<String>? storeSubSectors = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        //=========================
        // Body
        //=========================
        body: BlocBuilder<SecteurBloc, SecteurState>(
          builder: (context, sectorState) {
            return BlocBuilder<StoreCreationBloc, StoreCreationState>(
                builder: (context, storeCreationState) {
              final storeSectors = StoreCreationGlobalEvent(
                  storeSectors: sectorState.selectedSectorNames,
                  storeSubSectors: sectorState.selectedCategoryNames);
              return ListView(
                padding: const EdgeInsets.all(8.0),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: AppText(
                      text: "Choix des secteurs",
                      fontSize: context.mediumText,
                    ),
                  ),

                  //Liste des secteurs (avec leur catégories (sous-secteurs))
                  ...sectorState.sectors.map((sector) {
                    return ExpansionTile(
                      childrenPadding: EdgeInsets.only(bottom: 8),
                      expandedAlignment: Alignment.topLeft,
                      maintainState: true,
                      title: GestureDetector(
                        onTap: () {
                          context
                              .read<SecteurBloc>()
                              .add(ToggleSectorSelection(sector.id));

                          //enregistrement global
                          context.read<StoreCreationBloc>().add(storeSectors);
                        },
                        child: ModelSecteur(
                            text: sector.name,
                            isSelected: sector.isSelected,
                            activeColor: AppColors.primaryColor,
                            disabledColor: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              context
                                  .read<SecteurBloc>()
                                  .add(ToggleSectorSelection(sector.id));
                              //enregistrement global
                              context
                                  .read<StoreCreationBloc>()
                                  .add(storeSectors);
                            }),
                      ),
                      children: [
                        Wrap(
                          children: sector.categories.map((cat) {
                            return ModelSecteur(
                              text: cat.name,
                              isSelected: cat.isSelected,
                              activeColor: AppColors.blueColor,
                              disabledColor: Colors.grey,
                              onTap: () {
                                context.read<SecteurBloc>().add(
                                    ToggleCategorySelection(
                                        sector.id, cat.name));

                                //enregistrement global
                                context
                                    .read<StoreCreationBloc>()
                                    .add(storeSectors);
                              },
                            );
                          }).toList(),
                        )
                      ],
                    );
                  }).toList(),

                  //espace
                  const SizedBox(height: 50),

                  //Liste des catégories sélectionnées
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Texte d'indication des catégories sélectionnées
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                                child: Divider(
                              color: AppColors.primaryColor,
                            )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: AppText(
                                      text: "Catégories sélectionnées",
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.visible,
                                      color: AppColors.primaryColor,
                                      fontSize: context.smallText,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Flexible(
                                child: Divider(
                              color: AppColors.primaryColor,
                            ))
                          ],
                        ),

                        // Liste des catégories sélectionnées
                        sectorState.sectors
                                .expand((s) => s.categories)
                                .where((c) => c.isSelected)
                                .isNotEmpty
                            ?
                            //Lorsque la liste n'est pas vide
                            Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                //direction: Axis.vertical,
                                children: sectorState.sectors
                                    .expand((s) => s.categories)
                                    .where((c) => c.isSelected)
                                    .map((c) => ModelSecteur(
                                          text: c.name,
                                          isSelected: true,
                                          activeColor:
                                              Colors.deepPurple.shade900,
                                          disabledColor: Colors.grey,
                                          onTap: () {
                                            for (int i = 0;
                                                i < sectorState.sectors.length;
                                                i++) {
                                              if (sectorState
                                                  .sectors[i].categories
                                                  .contains(c)) {
                                                context.read<SecteurBloc>().add(
                                                    ToggleCategorySelection(
                                                        sectorState
                                                            .sectors[i].id,
                                                        c.name));

                                                //enregistrement global
                                                context
                                                    .read<StoreCreationBloc>()
                                                    .add(storeSectors);
                                              }
                                            }
                                          },
                                        ))
                                    .toList(),
                              )
                            :
                            //Lorsque la liste est vide
                            Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Center(
                                    child: Icon(
                                      Icons.grid_view_rounded,
                                      size: 60,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                                  ),
                                  AppText(
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.visible,
                                      fontWeight: FontWeight.bold,
                                      text:
                                          "Aucune Catégorie sélectionnée\nVeuillez cliquer sur une catégorie dans la liste ci-dessus",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontSize: context.mediumText / 1.3),
                                ],
                              ),
                        //const SizedBox(height: 10),
                      ],
                    ),
                  ),

                  // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page InscriptionVendeurPage
                  SizedBox(
                    height: context.height * 0.07,
                  )
                ],
              );
            });
          },
        ),
      ),
    );
  }
}
