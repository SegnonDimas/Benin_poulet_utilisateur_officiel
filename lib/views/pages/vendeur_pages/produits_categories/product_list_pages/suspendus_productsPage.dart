import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class SuspendusProductsPage extends StatefulWidget {
  const SuspendusProductsPage({super.key});

  @override
  State<SuspendusProductsPage> createState() => _SuspendusProductsPageState();
}

class _SuspendusProductsPageState extends State<SuspendusProductsPage> {
  @override
  void initState() {
    super.initState();
    // Les produits sont déjà chargés par le ProductBloc principal
    // Pas besoin de charger spécifiquement les produits suspendus
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsSuspendusState) {
        // liste des produits suspendus filtrés (par recherche utilisateur)
        if (produitsSuspendusState is ProduitFiltre) {
          final list_produits_suspendus_filtre = produitsSuspendusState.produits;

          if (list_produits_suspendus_filtre.isEmpty) {
            return _buildEmptyState(context, 'Aucun produit suspendu trouvé');
          }

          return ProductServices.showProducts(
              context, list_produits_suspendus_filtre);
        }

        // liste de tous les produits suspendus
        if (produitsSuspendusState is ProductsLoaded) {
          final list_produits_suspendus = produitsSuspendusState.products
              .where((p) => p.productStatus == 'suspended' || p.productStatus == 'suspendu')
              .toList();

          if (list_produits_suspendus.isEmpty) {
            return _buildEmptyState(
                context, 'Aucun produit suspendu pour le moment');
          }

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
                SelectableText(
                  'Erreur: ${produitsSuspendusState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // État initial ou autres états
        return _buildEmptyState(context, 'Aucun produit suspendu trouvé');
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.block,
            size: 80,
            color: Colors.grey.withOpacity(0.5),
          ),
          SizedBox(height: context.height * 0.02),
          AppText(
            text: message,
            fontSize: context.mediumText,
            color: Colors.grey.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: context.height * 0.02),
          AppText(
            text: 'Vos produits suspendus apparaîtront ici',
            fontSize: context.smallText,
            color: Colors.grey.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
