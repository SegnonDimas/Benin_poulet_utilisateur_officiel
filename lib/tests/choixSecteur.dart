import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/choixCategorie/choix_categorie_bloc.dart';
import '../bloc/choixCategorie/choix_categorie_event.dart';
import '../bloc/choixCategorie/choix_categorie_state.dart';
import '../views/pages/vendeur_pages/creation_boutique/choixCategoriePage.dart';

class ChoixCategoriePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              Text('Choisissez vos secteurs'),
              SizedBox(height: MediaQuery.of(context).size.height * 0.025),
              /*BlocBuilder<ChoixCategorieBloc, ChoixCategorieState>(
                builder: (context, state) {
                  final state = context.watch<ChoixCategorieBloc>().state;
                  return Wrap(
                    children: [
                      ModelSecteur(
                        text: 'Volaille',
                        activeColor: state.color, //Colors.green,
                        onTap: () {
                          context
                              .read<ChoixCategorieBloc>()
                              .add(SecteurToggled('Volaille'));
                        },
                      ),
                      ModelSecteur(
                        text: 'Pisciculture',
                        activeColor: Colors.green,
                        onTap: () {
                          context
                              .read<ChoixCategorieBloc>()
                              .add(SecteurToggled('Pisciculture'));
                        },
                      ),
                    ],
                  );
                },
              ),*/
              BlocBuilder<ChoixCategorieBloc, ChoixCategorieState>(
                builder: (context, state) {
                  return Wrap(
                    children: state.secteursSelectionnes.keys.map((secteur) {
                      final isSelected =
                          state.secteursSelectionnes[secteur] ?? false;
                      return ModelSecteur(
                        text: secteur,
                        isSelected: isSelected,
                        activeColor: Colors.green,
                        disabledColor: Colors.grey,
                        onTap: () {
                          context
                              .read<ChoixCategorieBloc>()
                              .add(SecteurToggled(secteur));
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              Divider(),
              Text('Sélectionnez les catégories de votre activité:'),
              BlocBuilder<ChoixCategorieBloc, ChoixCategorieState>(
                builder: (context, state) {
                  return Wrap(
                    children: state.categories
                        .map((categorie) => ModelCategorie(
                              text: categorie,
                              activeColor: Colors.green,
                              onTap: () {
                                context
                                    .read<ChoixCategorieBloc>()
                                    .add(CategorieToggled(categorie));
                              },
                            ))
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
