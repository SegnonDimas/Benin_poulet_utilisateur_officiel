import 'package:bloc/bloc.dart';

import '../../models/produit.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final List<Produit> tousLesProduits;

  ProductBloc(this.tousLesProduits) : super(ProduitFiltre(tousLesProduits)) {
    on<RechercherProduit>((event, emit) {
      final resultats = tousLesProduits.where((produit) {
        final query = event.query.toLowerCase();

        final nomCorrespond =
            produit.productName!.toLowerCase().contains(query);

        final variationCorrespond = produit.varieties!.any(
          (variation) => variation.toLowerCase().contains(query),
        );

        return nomCorrespond || variationCorrespond;
      }).toList();

      emit(ProduitFiltre(resultats));
    });

    on<ReinitialiserRecherche>((event, emit) {
      emit(ProduitFiltre(tousLesProduits));
    });
  }
}
