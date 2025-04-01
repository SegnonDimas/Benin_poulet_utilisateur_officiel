import 'package:equatable/equatable.dart';

abstract class ChoixCategorieEvent extends Equatable {
  const ChoixCategorieEvent();

  @override
  List<Object> get props => [];
}

// basculement d'un secteur
class SecteurToggled extends ChoixCategorieEvent {
  final String secteur;

  const SecteurToggled(this.secteur);

  @override
  List<Object> get props => [secteur];
}

// basculement d'une categorie
class CategorieToggled extends ChoixCategorieEvent {
  final String categorie;

  const CategorieToggled(this.categorie);

  @override
  List<Object> get props => [categorie];
}
