import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'choix_categorie_event.dart';
import 'choix_categorie_state.dart';

class ChoixCategorieBloc
    extends Bloc<ChoixCategorieEvent, ChoixCategorieState> {
  final List<String> _secteurVolaille = [
    'Pigeon',
    'Pintarde',
    'Poulet',
    'Dinde',
    'Canards',
    'Oies'
  ];
  final List<String> _secteurPisciculture = [
    'Tilapia',
    'Carpe',
    'Faux barre',
    'Vrai barre',
    'Poissons chat'
  ];
  late List<String> secteurVolaille = [];
  late List<String> secteurPisciculture = [];
  final List<String> secteurs = ['Volaille', 'Pisciculture'];

  ChoixCategorieBloc()
      : super(ChoixCategorieState(
          secteurs: const ['Volaille', 'Pisciculture'],
          secteursSelectionnes: const {
            'Volaille': false,
            'Pisciculture': false,
          },
          categories: [],
        )) {
    //on<SecteurToggled>(_onSecteurToggled);
    on<CategorieToggled>(_onCategorieToggled);
    on<SecteurToggled>((event, emit) {
      final updatedSecteurs =
          Map<String, bool>.from(state.secteursSelectionnes);

      updatedSecteurs
          .updateAll((key, value) => false); // Réinitialise toutes les options
      updatedSecteurs[event.secteur] =
          true; // Sélectionne uniquement l'option cliquée

      emit(state.copyWith(secteursSelectionnes: updatedSecteurs));
    });
  }

  void _onSecteurToggled(
      SecteurToggled event, Emitter<ChoixCategorieState> emit) {
    List<String> updatedCategories = List.from(state.categories);
    List<String> updatedOwnCategories = [];

    if (event.secteur == 'Volaille') {
      // Ajout des éléments de secteurVolaille ou les retirer si déjà présents
      if (updatedCategories.any((item) => _secteurVolaille.contains(item))) {
        // Si les éléments sont déjà présents, on les retire
        updatedCategories
            .removeWhere((item) => _secteurVolaille.contains(item));
        state.color = Colors.grey;
      } else {
        // Si les éléments ne sont pas présents, on les ajoute
        updatedCategories.addAll(_secteurVolaille);
        state.color = primaryColor;
      }
    } else if (event.secteur == 'Pisciculture') {
      // Ajout des éléments de secteurPisciculture ou les retirer si déjà présents
      if (updatedCategories
          .any((item) => _secteurPisciculture.contains(item))) {
        // Si les éléments sont déjà présents, on les retire
        updatedCategories
            .removeWhere((item) => _secteurPisciculture.contains(item));
        state.color = Colors.grey;
      } else {
        // Si les éléments ne sont pas présents, on les ajoute
        updatedCategories.addAll(_secteurPisciculture);
        state.color = primaryColor;
      }
    }

    print('''
  ==========> ${updatedCategories.isEmpty}
  ==========> $updatedCategories''');

    // Émet le nouvel état avec la liste mise à jour
    emit(state.copyWith(categories: updatedCategories));
  }

  void _onCategorieToggled(
      CategorieToggled event, Emitter<ChoixCategorieState> emit) {
    List<String> updatedCategories = List.from(state.categories);
    if (updatedCategories.contains(event.categorie)) {
      updatedCategories.remove(event.categorie);
    } else {
      updatedCategories.add(event.categorie);
    }
    emit(state.copyWith(categories: updatedCategories));
  }
}
