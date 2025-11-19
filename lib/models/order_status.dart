/// Énumération des statuts de commande
enum OrderStatus {
  pendingValidation, // En attente de validation vendeur
  validated, // Validée par le vendeur
  inPreparation, // En préparation
  readyForDelivery, // Prête pour livraison
  inDelivery, // En cours de livraison
  delivered, // Livrée
  completed, // Terminée (confirmée par client)
  rejected, // Refusée par le vendeur
  cancelled, // Annulée
}

/// Extension pour obtenir le label en français
extension OrderStatusExtension on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pendingValidation:
        return 'En attente de validation';
      case OrderStatus.validated:
        return 'Validée';
      case OrderStatus.inPreparation:
        return 'En préparation';
      case OrderStatus.readyForDelivery:
        return 'Prête pour livraison';
      case OrderStatus.inDelivery:
        return 'En cours de livraison';
      case OrderStatus.delivered:
        return 'Livrée';
      case OrderStatus.completed:
        return 'Terminée';
      case OrderStatus.rejected:
        return 'Refusée';
      case OrderStatus.cancelled:
        return 'Annulée';
    }
  }

  String get value {
    return toString().split('.').last;
  }

  /// Obtenir le statut depuis une string
  static OrderStatus fromString(String status) {
    return OrderStatus.values.firstWhere(
      (e) => e.value == status,
      orElse: () => OrderStatus.pendingValidation,
    );
  }
}


