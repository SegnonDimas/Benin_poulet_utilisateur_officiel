import 'package:benin_poulet/core/firebase/firestore/error_report_repository.dart';
import 'package:benin_poulet/models/error_report.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../../bloc/product/product_bloc.dart';
import '../../../../../services/products_services.dart';
import '../../../../colors/app_colors.dart';

class ActifsProductsPage extends StatefulWidget {
  const ActifsProductsPage({super.key});

  @override
  State<ActifsProductsPage> createState() => _ActifsProductsPageState();
}

class _ActifsProductsPageState extends State<ActifsProductsPage> {
  @override
  void initState() {
    super.initState();
    // Les produits sont déjà chargés par le ProductBloc principal
    // Pas besoin de charger spécifiquement les produits actifs
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, produitsActifsState) {
        // liste des produits actifs filtrés (par recherche utilisateur)
        if (produitsActifsState is ProduitFiltre) {
          final list_produits_actifs_filtre = produitsActifsState.produits;

          if (list_produits_actifs_filtre.isEmpty) {
            return _buildEmptyState(context, 'Aucun produit actif trouvé');
          }

          return ProductServices.showProducts(
              context, list_produits_actifs_filtre);
        }

        // liste de tous les produits actifs
        if (produitsActifsState is ProductsLoaded) {
          final list_produits_actifs = produitsActifsState.products
              .where((p) => p.productStatus == 'active' || p.productStatus == 'actif')
              .toList();

          if (list_produits_actifs.isEmpty) {
            return _buildEmptyState(
                context, 'Aucun produit actif pour le moment');
          }

          return ProductServices.showProducts(context, list_produits_actifs);
        }

        // États de chargement et d'erreur
        if (produitsActifsState is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (produitsActifsState is ProductError) {
          final e = produitsActifsState.message;
          // Enregistrer le rapport d'erreur
          ErrorReport errorReport = ErrorReport(
            errorMessage: e.toString(),
            errorPage: 'Page des produits actifs',
            date: DateTime.now(),
          );
          AppUtils.showDialog(
            context: context,
            barrierDismissible: false,
            hideContent: true,
            title: 'Rapport d\'erreur',
            content: e.toString(),
            cancelText: 'Fermer',
            confirmText: 'Envoyer le rapport',
            cancelTextColor: AppColors.primaryColor,
            confirmTextColor: AppColors.redColor,
            onConfirm: () async {
              await FirebaseErrorReportRepository()
                  .sendErrorReport(errorReport);
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          );
          print(
              "############ Erreur : ${produitsActifsState.message} #############");

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                SelectableText(
                  'Erreur: ${produitsActifsState.message}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        // État initial ou autres états
        return _buildEmptyState(context, 'Aucun produit actif trouvé');
      },
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_active_outlined,
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
            text: 'Ajoutez vos premiers produits pour commencer à vendre',
            fontSize: context.smallText,
            color: Colors.grey.withOpacity(0.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
