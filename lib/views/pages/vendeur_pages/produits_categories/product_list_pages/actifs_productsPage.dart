import 'package:benin_poulet/models/produit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class ActifsProductsPage extends StatelessWidget {
  const ActifsProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsActifsState) {
        // liste des produits actifs filtrés (par recherche utilisateur)
        if (produitsActifsState is ProduitFiltre) {
          final list_produits_actifs_filtre = produitsActifsState
              .produitsFiltres
              .where((p) => p.productStatus == 'actif')
              .toList();
          return showProducts(context, list_produits_actifs_filtre);
        }
        // liste de tous les produits actifs
        return showProducts(context, list_produits_actifs);
      },
    );
  }
}
