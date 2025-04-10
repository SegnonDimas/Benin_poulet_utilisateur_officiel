import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_bloc.dart';
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_event.dart';
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_state.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../models_ui/model_secteur.dart';

class ChoixCategoriePage extends StatelessWidget {
  const ChoixCategoriePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        //=========================
        // Body
        //=========================
        body: BlocBuilder<SecteurBloc, SecteurState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                AppText(
                  text: "Choix des secteurs",
                  fontSize: context.mediumText,
                ),
                //Liste des secteurs (avec leur catégories (sous-secteurs))
                ...state.sectors.map((sector) {
                  return ExpansionTile(
                    childrenPadding: EdgeInsets.only(bottom: 8),
                    expandedAlignment: Alignment.topLeft,
                    maintainState: true,
                    title: GestureDetector(
                      onTap: () {
                        context
                            .read<SecteurBloc>()
                            .add(ToggleSectorSelection(sector.id));
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
                          }),
                    ),
                    children: [
                      Wrap(
                        children: sector.categories.map((cat) {
                          return ModelSecteur(
                            text: cat.name,
                            isSelected: cat.isSelected,
                            activeColor: Colors.deepPurple.shade900,
                            disabledColor: Colors.grey,
                            onTap: () {
                              context.read<SecteurBloc>().add(
                                  ToggleCategorySelection(sector.id, cat.name));
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
                      state.sectors
                              .expand((s) => s.categories)
                              .where((c) => c.isSelected)
                              .isNotEmpty
                          ?
                          //Lorsque la liste n'est pas vide
                          Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: state.sectors
                                  .expand((s) => s.categories)
                                  .where((c) => c.isSelected)
                                  .map((c) => ModelSecteur(
                                        text: c.name,
                                        isSelected: true,
                                        activeColor: Colors.deepPurple.shade900,
                                        disabledColor: Colors.grey,
                                        onTap: () {
                                          for (int i = 0;
                                              i < state.sectors.length;
                                              i++) {
                                            if (state.sectors[i].categories
                                                .contains(c)) {
                                              context.read<SecteurBloc>().add(
                                                  ToggleCategorySelection(
                                                      state.sectors[i].id,
                                                      c.name));
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
          },
        ),
      ),
    );
  }
}
