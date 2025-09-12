// =========================
// bloc/secteur_state.dart
// =========================

import 'package:benin_poulet/models/sellerSector.dart';

class SecteurState {
  final List<SellerSector> sectors;

  const SecteurState({required this.sectors});

  // Liste des noms des secteurs sélectionnés
  List<String> get selectedSectorNames =>
      sectors.where((s) => s.isSelected).map((s) => s.name).toList();

  // Liste des noms des catégories sélectionnées
  List<String> get selectedCategoryNames => sectors
      .expand((s) => s.categories)
      .where((c) => c.isSelected)
      .map((c) => c.name)
      .toList();

  SecteurState copyWith({
    List<SellerSector>? sectors,
  }) {
    return SecteurState(
      sectors: sectors ?? this.sectors,
    );
  }
}
