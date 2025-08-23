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
          return ProductServices.showProducts(
              context, list_produits_enAttente_filtre);
        }
        
        // liste de tous les produits enAttente
        if (produitsEnAttenteState is ProductsLoaded) {
          final list_produits_enAttente = produitsEnAttenteState.products
              .where((p) => p.productStatus == 'en attente')
              .toList();
          return ProductServices.showProducts(context, list_produits_enAttente);
        }
        
        // États de chargement et d'erreur
        if (produitsEnAttenteState is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (produitsEnAttenteState is ProductError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Erreur: ${produitsEnAttenteState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }
        
        // État initial ou autres états
        return const Center(
          child: Text('Aucun produit en attente trouvé'),
        );
      },
    );
  }
}
