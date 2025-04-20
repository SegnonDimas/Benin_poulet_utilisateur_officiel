part of 'product_bloc.dart';

sealed class ProductState {}

final class ProductInitial extends ProductState {}

class ProduitInitial extends ProductState {}

class ProduitFiltre extends ProductState {
  final List<Produit> produitsFiltres;

  ProduitFiltre(this.produitsFiltres);
}
