import 'package:lanhi/models/order_model.dart';
import 'package:lanhi/models/order_status.dart';
import 'package:equatable/equatable.dart';

/// Événements du OrderBloc
abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

/// Créer une nouvelle commande
class CreateOrderEvent extends OrderEvent {
  final OrderModel order;

  const CreateOrderEvent(this.order);

  @override
  List<Object?> get props => [order];
}

/// Charger une commande spécifique
class LoadOrderEvent extends OrderEvent {
  final String orderId;

  const LoadOrderEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Charger les commandes d'un client
class LoadClientOrdersEvent extends OrderEvent {
  final String clientId;

  const LoadClientOrdersEvent(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

/// Charger les commandes d'un vendeur
class LoadSellerOrdersEvent extends OrderEvent {
  final String sellerId;

  const LoadSellerOrdersEvent(this.sellerId);

  @override
  List<Object?> get props => [sellerId];
}

/// Charger les commandes d'un vendeur par statut
class LoadSellerOrdersByStatusEvent extends OrderEvent {
  final String sellerId;
  final OrderStatus status;

  const LoadSellerOrdersByStatusEvent(this.sellerId, this.status);

  @override
  List<Object?> get props => [sellerId, status];
}

/// Mettre à jour le statut d'une commande
class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final OrderStatus newStatus;
  final String? comment;
  final String? updatedBy;

  const UpdateOrderStatusEvent({
    required this.orderId,
    required this.newStatus,
    this.comment,
    this.updatedBy,
  });

  @override
  List<Object?> get props => [orderId, newStatus, comment, updatedBy];
}

/// Valider une commande (vendeur)
class ValidateOrderEvent extends OrderEvent {
  final String orderId;
  final String? comment;
  final String? validatedBy;

  const ValidateOrderEvent({
    required this.orderId,
    this.comment,
    this.validatedBy,
  });

  @override
  List<Object?> get props => [orderId, comment, validatedBy];
}

/// Refuser une commande (vendeur)
class RejectOrderEvent extends OrderEvent {
  final String orderId;
  final String reason;
  final String? rejectedBy;

  const RejectOrderEvent({
    required this.orderId,
    required this.reason,
    this.rejectedBy,
  });

  @override
  List<Object?> get props => [orderId, reason, rejectedBy];
}

/// Commencer la préparation
class StartPreparationEvent extends OrderEvent {
  final String orderId;
  final String? startedBy;

  const StartPreparationEvent({
    required this.orderId,
    this.startedBy,
  });

  @override
  List<Object?> get props => [orderId, startedBy];
}

/// Marquer comme prête pour livraison
class MarkReadyForDeliveryEvent extends OrderEvent {
  final String orderId;
  final String? markedBy;

  const MarkReadyForDeliveryEvent({
    required this.orderId,
    this.markedBy,
  });

  @override
  List<Object?> get props => [orderId, markedBy];
}

/// Commencer la livraison
class StartDeliveryEvent extends OrderEvent {
  final String orderId;
  final String? startedBy;

  const StartDeliveryEvent({
    required this.orderId,
    this.startedBy,
  });

  @override
  List<Object?> get props => [orderId, startedBy];
}

/// Marquer comme livrée
class MarkAsDeliveredEvent extends OrderEvent {
  final String orderId;
  final String? deliveredBy;

  const MarkAsDeliveredEvent({
    required this.orderId,
    this.deliveredBy,
  });

  @override
  List<Object?> get props => [orderId, deliveredBy];
}

/// Confirmer la réception (client)
class ConfirmDeliveryEvent extends OrderEvent {
  final String orderId;
  final String? confirmedBy;

  const ConfirmDeliveryEvent({
    required this.orderId,
    this.confirmedBy,
  });

  @override
  List<Object?> get props => [orderId, confirmedBy];
}

/// Annuler une commande
class CancelOrderEvent extends OrderEvent {
  final String orderId;
  final String reason;
  final String? cancelledBy;

  const CancelOrderEvent({
    required this.orderId,
    required this.reason,
    this.cancelledBy,
  });

  @override
  List<Object?> get props => [orderId, reason, cancelledBy];
}

/// Écouter les mises à jour d'une commande en temps réel
class ListenToOrderUpdatesEvent extends OrderEvent {
  final String orderId;

  const ListenToOrderUpdatesEvent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Écouter les commandes d'un client en temps réel
class ListenToClientOrdersEvent extends OrderEvent {
  final String clientId;

  const ListenToClientOrdersEvent(this.clientId);

  @override
  List<Object?> get props => [clientId];
}

/// Écouter les commandes d'un vendeur en temps réel
class ListenToSellerOrdersEvent extends OrderEvent {
  final String sellerId;

  const ListenToSellerOrdersEvent(this.sellerId);

  @override
  List<Object?> get props => [sellerId];
}


