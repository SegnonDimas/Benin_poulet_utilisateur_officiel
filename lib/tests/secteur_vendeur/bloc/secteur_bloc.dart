/*
// =========================
// bloc/secteur_bloc.dart
// =========================

import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_event.dart';
import 'package:benin_poulet/tests/secteur_vendeur/bloc/secteur_state.dart';
import 'package:benin_poulet/tests/secteur_vendeur/secteur_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecteurBloc extends Bloc<SecteurEvent, SecteurState> {
  SecteurBloc() : super(SecteurState(sectors: initialSectors)) {
    on<ToggleSectorSelection>((event, emit) {
      final updatedSectors = state.sectors.map((sector) {
        if (sector.id == event.sectorId) {
          final newIsSelected = !sector.isSelected;
          final updatedCategories = sector.categories
              .map((cat) => cat.copyWith(isSelected: newIsSelected))
              .toList();

          return sector.copyWith(
            isSelected: newIsSelected,
            categories: updatedCategories,
          );
        }
        return sector;
      }).toList();

      emit(state.copyWith(sectors: updatedSectors));
    });

    on<ToggleCategorySelection>((event, emit) {
      final updatedSectors = state.sectors.map((sector) {
        if (sector.id == event.sectorId) {
          final updatedCategories = sector.categories.map((cat) {
            if (cat.name == event.categoryName) {
              return cat.copyWith(isSelected: !cat.isSelected);
            }
            return cat;
          }).toList();

          // Règle 1 : le secteur est sélectionné si au moins une catégorie l'est
          final isSectorSelected =
              updatedCategories.any((cat) => cat.isSelected);

          return sector.copyWith(
              categories: updatedCategories, isSelected: isSectorSelected);
        }
        return sector;
      }).toList();

      emit(state.copyWith(sectors: updatedSectors));
    });
  }
}

// =========================
// dummy_data.dart
// =========================

final initialSectors = <SellerSector>[
  SellerSector(
    id: 1,
    name: 'Volaille',
    isSelected: false,
    image: 'assets/images/sectors/volaille.png',
    categories: [
      Category(name: 'Poulet', isSelected: false),
      Category(name: 'Pigeon', isSelected: false),
      Category(name: 'Pintade', isSelected: false),
      Category(name: 'Dinde', isSelected: false),
      Category(name: 'Accessoires', isSelected: false),
      Category(name: 'Provende', isSelected: false),
    ],
  ),
  SellerSector(
    id: 2,
    name: 'Pisciculture',
    isSelected: false,
    image: 'assets/images/sectors/pisciculture.png',
    categories: [
      Category(name: 'Tilapia', isSelected: false),
      Category(name: 'Carpe', isSelected: false),
      Category(name: 'Faux Bar', isSelected: false),
      Category(name: 'Poisson Chat', isSelected: false),
    ],
  ),
];
*/
