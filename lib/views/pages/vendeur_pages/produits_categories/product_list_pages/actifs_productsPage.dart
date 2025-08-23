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
          return ProductServices.showProducts(
              context, list_produits_actifs_filtre);
        }
        
        // liste de tous les produits actifs
        if (produitsActifsState is ProductsLoaded) {
          final list_produits_actifs = produitsActifsState.products
              .where((p) => p.productStatus == 'actif')
              .toList();
          return ProductServices.showProducts(context, list_produits_actifs);
        }
        
        // États de chargement et d'erreur
        if (produitsActifsState is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (produitsActifsState is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur: ${produitsActifsState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        // État initial ou autres états
        return const Center(
          child: Text('Aucun produit actif trouvé'),
        );
      },
    );
  }
}
