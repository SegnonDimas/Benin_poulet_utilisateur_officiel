import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';

class InactifsProductsPage extends StatefulWidget {
  const InactifsProductsPage({super.key});

  @override
  State<InactifsProductsPage> createState() => _InactifsProductsPageState();
}

class _InactifsProductsPageState extends State<InactifsProductsPage> {
  @override
  void initState() {
    super.initState();
    // Les produits sont déjà chargés par le ProductBloc principal
    // Pas besoin de charger spécifiquement les produits inactifs
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsInactifsState) {
        // liste des produits inactifs filtrés (par recherche utilisateur)
        if (produitsInactifsState is ProduitFiltre) {
          final list_produits_inactifs_filtre = produitsInactifsState.produits;

          if (list_produits_inactifs_filtre.isEmpty) {
            return _buildEmptyState(context, 'Aucun produit inactif trouvé');
          }

          return ProductServices.showProducts(
              context, list_produits_inactifs_filtre);
        }

        // liste de tous les produits inactifs
        if (produitsInactifsState is ProductsLoaded) {
          final list_produits_inactifs = produitsInactifsState.products
              .where((p) => p.productStatus == 'inactive' || p.productStatus == 'inactif')
              .toList();

          if (list_produits_inactifs.isEmpty) {
            return _buildEmptyState(
                context, 'Aucun produit inactif pour le moment');
          }

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
                SelectableText(
                  'Erreur: ${produitsInactifsState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // État initial ou autres états
        return _buildEmptyState(context, 'Aucun produit inactif trouvé');
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
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
            text: 'Vos produits désactivés apparaîtront ici',
            fontSize: context.smallText,
            color: Colors.grey.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
