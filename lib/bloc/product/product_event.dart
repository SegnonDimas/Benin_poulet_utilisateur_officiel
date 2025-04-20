part of 'product_bloc.dart';

sealed class ProductEvent {}

class RechercherProduit extends ProductEvent {
  final String query;

  RechercherProduit(this.query);
}

class ReinitialiserRecherche extends ProductEvent {}
