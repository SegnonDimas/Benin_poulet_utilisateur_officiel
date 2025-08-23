import 'package:benin_poulet/models/produit.dart';
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
        // liste des produits suspendus filtrés (par recherche utilisateur)
        if (produitsSuspendusState is ProduitFiltre) {
          final list_produits_suspendus_filtre = produitsSuspendusState
              .produitsFiltres
              .where((p) => p.productStatus == 'suspendu')
              .toList();
          return ProductServices.showProducts(
              context, list_produits_suspendus_filtre);
        }
        
        // liste de tous les produits suspendus
        if (produitsSuspendusState is ProductsLoaded) {
          final list_produits_suspendus = produitsSuspendusState.products
              .where((p) => p.productStatus == 'suspendu')
              .toList();
          return ProductServices.showProducts(context, list_produits_suspendus);
        }
        
        // États de chargement et d'erreur
        if (produitsSuspendusState is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (produitsSuspendusState is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur: ${produitsSuspendusState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        // État initial ou autres états
        return const Center(
          child: Text('Aucun produit suspendu trouvé'),
        );
      },
    );
  }
}
