import 'package:benin_poulet/models/produit.dart';
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
        // liste des produits inactifs filtrés (par recherche utilisateur)
        if (produitsInactifsState is ProduitFiltre) {
          final list_produits_inactifs_filtre = produitsInactifsState
              .produitsFiltres
              .where((p) => p.productStatus == 'inactif')
              .toList();
          return ProductServices.showProducts(
              context, list_produits_inactifs_filtre);
        }
        
        // liste de tous les produits inactifs
        if (produitsInactifsState is ProductsLoaded) {
          final list_produits_inactifs = produitsInactifsState.products
              .where((p) => p.productStatus == 'inactif')
              .toList();
          return ProductServices.showProducts(context, list_produits_inactifs);
        }
        
        // États de chargement et d'erreur
        if (produitsInactifsState is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (produitsInactifsState is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur: ${produitsInactifsState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        // État initial ou autres états
        return const Center(
          child: Text('Aucun produit inactif trouvé'),
        );
      },
    );
  }
}
