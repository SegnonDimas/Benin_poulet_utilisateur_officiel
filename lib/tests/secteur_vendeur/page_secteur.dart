/*
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_bloc.dart';
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_event.dart';
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_state.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../views/models_ui/model_secteur.dart';

class SecteurPage extends StatelessWidget {
  const SecteurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        //=========================
        // AppBar
        //=========================
        appBar: AppBar(
            title: AppText(
          text: "Choix des secteurs",
          fontSize: context.mediumText,
        )),

        //=========================
        // Body
        //=========================
        body: BlocBuilder<SecteurBloc, SecteurState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
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
                                  height: 50,
                                ),
                                Center(
                                  child: Icon(
                                    Icons.grid_view_rounded,
                                    size: 140,
                                    color:
                                        AppColors.primaryColor.withOpacity(0.2),
                                  ),
                                ),
                                AppText(
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.visible,
                                    text:
                                        "Aucune Catégorie sélectionnée\n\nVeuillez cliquer sur une catégorie dans la liste ci-dessus",
                                    color:
                                        AppColors.primaryColor.withOpacity(0.3),
                                    fontSize: 15),
                              ],
                            ),
                      //const SizedBox(height: 10),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
*/
