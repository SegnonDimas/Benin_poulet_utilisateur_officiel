import 'package:benin_poulet/models/produit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class EnAttenteProductsPage extends StatelessWidget {
  const EnAttenteProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsEnAttenteState) {
        // liste des produits enAttente filtrés (par recherche utilisateur)
        if (produitsEnAttenteState is ProduitFiltre) {
          final list_produits_enAttente_filtre = produitsEnAttenteState
              .produitsFiltres
              .where((p) => p.productStatus == 'en attente')
              .toList();
          return showProducts(context, list_produits_enAttente_filtre);
        }
        // liste de tous les produits enAttente
        return showProducts(context, list_produits_enAttente);
      },
    );
  }
}
