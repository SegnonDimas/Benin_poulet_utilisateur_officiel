import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class EnAttenteProductsPage extends StatefulWidget {
  const EnAttenteProductsPage({super.key});

  @override
  State<EnAttenteProductsPage> createState() => _EnAttenteProductsPageState();
}

class _EnAttenteProductsPageState extends State<EnAttenteProductsPage> {
  @override
  void initState() {
    super.initState();
    // Les produits sont déjà chargés par le ProductBloc principal
    // Pas besoin de charger spécifiquement les produits en attente
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsEnAttenteState) {
        // liste des produits enAttente filtrés (par recherche utilisateur)
        if (produitsEnAttenteState is ProduitFiltre) {
          final list_produits_enAttente_filtre = produitsEnAttenteState.produits;

          if (list_produits_enAttente_filtre.isEmpty) {
            return _buildEmptyState(context, 'Aucun produit en attente trouvé');
          }

          return ProductServices.showProducts(
              context, list_produits_enAttente_filtre);
        }

        // liste de tous les produits enAttente
        if (produitsEnAttenteState is ProductsLoaded) {
          final list_produits_enAttente = produitsEnAttenteState.products
              .where((p) => p.productStatus == 'pending' || p.productStatus == 'en attente')
              .toList();

          if (list_produits_enAttente.isEmpty) {
            return _buildEmptyState(
                context, 'Aucun produit en attente pour le moment');
          }

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
                SelectableText(
                  'Erreur: ${produitsEnAttenteState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // État initial ou autres états
        return _buildEmptyState(context, 'Aucun produit en attente trouvé');
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hourglass_top_rounded,
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
            text: 'Vos produits en cours de validation apparaîtront ici',
            fontSize: context.smallText,
            color: Colors.grey.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
