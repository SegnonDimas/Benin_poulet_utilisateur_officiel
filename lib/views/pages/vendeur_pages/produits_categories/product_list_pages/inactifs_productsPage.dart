import 'package:benin_poulet/models/produit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class InactifsProductsPage extends StatelessWidget {
  const InactifsProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsInactifsState) {
        // liste des produits actifs filtrés (par recherche utilisateur)
        if (produitsInactifsState is ProduitFiltre) {
          final list_produits_inactifs_filtre = produitsInactifsState
              .produitsFiltres
              .where((p) => p.productStatus == 'inactif')
              .toList();
          return ProductServices.showProducts(
              context, list_produits_inactifs_filtre);
        }
        // liste de tous les produits actifs
        return ProductServices.showProducts(context, list_produits_inactifs);
      },
    );
  }
}
