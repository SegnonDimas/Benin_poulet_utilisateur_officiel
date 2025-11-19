import 'package:lanhi/models/order_model.dart';
import 'package:equatable/equatable.dart';

/// États du OrderBloc
abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

/// État initial
class OrderInitial extends OrderState {}

/// Chargement en cours
class OrderLoading extends OrderState {}

/// Commande créée avec succès
class OrderCreated extends OrderState {
  final String orderId;

  const OrderCreated(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Commande chargée
class OrderLoaded extends OrderState {
  final OrderModel order;

  const OrderLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

/// Liste de commandes chargée
class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;

  const OrdersLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

/// Commande mise à jour avec succès
class OrderUpdated extends OrderState {
  final OrderModel order;
  final String message;

  const OrderUpdated(this.order, {this.message = 'Commande mise à jour'});

  @override
  List<Object?> get props => [order, message];
}

/// Statut de commande mis à jour
class OrderStatusUpdated extends OrderState {
  final String orderId;
  final String message;

  const OrderStatusUpdated(this.orderId, this.message);

  @override
  List<Object?> get props => [orderId, message];
}

/// Commande validée
class OrderValidated extends OrderState {
  final String orderId;

  const OrderValidated(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Commande refusée
class OrderRejected extends OrderState {
  final String orderId;
  final String reason;

  const OrderRejected(this.orderId, this.reason);

  @override
  List<Object?> get props => [orderId, reason];
}

/// Commande annulée
class OrderCancelled extends OrderState {
  final String orderId;

  const OrderCancelled(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

/// Erreur
class OrderError extends OrderState {
  final String message;

  const OrderError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Écoute en temps réel active
class OrderListening extends OrderState {
  final OrderModel order;

  const OrderListening(this.order);

  @override
  List<Object?> get props => [order];
}

/// Écoute des commandes en temps réel
class OrdersListening extends OrderState {
  final List<OrderModel> orders;

  const OrdersListening(this.orders);

  @override
  List<Object?> get props => [orders];
}


