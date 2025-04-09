// =========================
// bloc/secteur_event.dart
// =========================

abstract class SecteurEvent {}

class ToggleSectorSelection extends SecteurEvent {
  final int sectorId;
  ToggleSectorSelection(this.sectorId);
}

class ToggleCategorySelection extends SecteurEvent {
  final int sectorId;
  final String categoryName;
  ToggleCategorySelection(this.sectorId, this.categoryName);
}
