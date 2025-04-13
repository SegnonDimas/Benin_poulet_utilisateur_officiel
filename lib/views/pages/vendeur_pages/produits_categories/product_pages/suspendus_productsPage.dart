import 'package:benin_poulet/models/produit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class SuspendusProductsPage extends StatelessWidget {
  const SuspendusProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsSuspendusState) {
        // liste des produits actifs filtrés (par recherche utilisateur)
        if (produitsSuspendusState is ProduitFiltre) {
          final list_produits_suspendus_filtre = produitsSuspendusState
              .produitsFiltres
              .where((p) => p.productStatus == 'suspendu')
              .toList();
          return showProducts(context, list_produits_suspendus_filtre);
        }
        // liste de tous les produits actifs
        return showProducts(context, list_produits_suspendus);
      },
    );
  }
}
