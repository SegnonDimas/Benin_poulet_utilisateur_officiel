import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/models/order_model.dart';
import 'package:benin_poulet/views/pages/client_pages/order/delivery_info_page.dart';
import 'package:benin_poulet/views/pages/client_pages/order/payment_method_page.dart';
import 'package:benin_poulet/views/pages/client_pages/order/order_summary_page.dart';
import 'package:flutter/material.dart';

/// Helper pour gérer le processus de checkout
class CheckoutHelper {
  /// Lancer le processus de checkout depuis le panier
  static Future<void> startCheckout({
    required BuildContext context,
    required List<OrderItem> items,
    required double totalAmount,
    required String sellerId, // ID du vendeur propriétaire
    required String storeId, // ID de la boutique
    required String sellerName,
  }) async {
    try {
      // Étape 1: Informations de livraison
      final deliveryInfo = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => const DeliveryInfoPage(),
        ),
      );

      if (deliveryInfo == null) return; // Utilisateur a annulé

      // Étape 2: Mode de paiement
      final paymentInfo = await Navigator.push<Map<String, dynamic>>(
        context,
        MaterialPageRoute(
          builder: (context) => const PaymentMethodPage(),
        ),
      );

      if (paymentInfo == null) return; // Utilisateur a annulé

      // Mettre à jour les frais de livraison si fourni
      if (paymentInfo.containsKey('deliveryFee')) {
        deliveryInfo['deliveryFee'] = paymentInfo['deliveryFee'];
      }

      // Étape 3: Récapitulatif et confirmation
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummaryPage(
            items: items,
            totalAmount: totalAmount,
            deliveryInfo: deliveryInfo,
            paymentInfo: paymentInfo,
            sellerId: sellerId, // ID du vendeur
            storeId: storeId, // ID de la boutique
            sellerName: sellerName,
          ),
        ),
      );
    } catch (e) {
      print('Erreur lors du checkout: $e');
    }
  }

  /// Afficher les détails d'une commande
  static void showOrderDetails({
    required BuildContext context,
    required String orderId,
  }) {
    Navigator.pushNamed(
      context,
      AppRoutes.ORDER_TRACKING,
      arguments: orderId,
    );
  }
}
