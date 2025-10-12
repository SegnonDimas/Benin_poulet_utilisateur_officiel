import 'dart:async';
import 'package:benin_poulet/bloc/orders/order_event.dart';
import 'package:benin_poulet/bloc/orders/order_state.dart';
import 'package:benin_poulet/models/order_status.dart';
import 'package:benin_poulet/services/order_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// BLoC pour la gestion des commandes
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderService _orderService;
  StreamSubscription? _orderSubscription;
  StreamSubscription? _ordersSubscription;

  OrderBloc({OrderService? orderService})
      : _orderService = orderService ?? OrderService(),
        super(OrderInitial()) {
    // Enregistrement des handlers d'événements
    on<CreateOrderEvent>(_onCreateOrder);
    on<LoadOrderEvent>(_onLoadOrder);
    on<LoadClientOrdersEvent>(_onLoadClientOrders);
    on<LoadSellerOrdersEvent>(_onLoadSellerOrders);
    on<LoadSellerOrdersByStatusEvent>(_onLoadSellerOrdersByStatus);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<ValidateOrderEvent>(_onValidateOrder);
    on<RejectOrderEvent>(_onRejectOrder);
    on<StartPreparationEvent>(_onStartPreparation);
    on<MarkReadyForDeliveryEvent>(_onMarkReadyForDelivery);
    on<StartDeliveryEvent>(_onStartDelivery);
    on<MarkAsDeliveredEvent>(_onMarkAsDelivered);
    on<ConfirmDeliveryEvent>(_onConfirmDelivery);
    on<CancelOrderEvent>(_onCancelOrder);
    on<ListenToOrderUpdatesEvent>(_onListenToOrderUpdates);
    on<ListenToClientOrdersEvent>(_onListenToClientOrders);
    on<ListenToSellerOrdersEvent>(_onListenToSellerOrders);
  }

  /// Créer une nouvelle commande
  Future<void> _onCreateOrder(
    CreateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final orderId = await _orderService.createOrder(event.order);
      emit(OrderCreated(orderId));
    } catch (e) {
      emit(OrderError('Erreur lors de la création de la commande: $e'));
    }
  }

  /// Charger une commande
  Future<void> _onLoadOrder(
    LoadOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final order = await _orderService.getOrderById(event.orderId);

      if (order != null) {
        emit(OrderLoaded(order));
      } else {
        emit(const OrderError('Commande introuvable'));
      }
    } catch (e) {
      emit(OrderError('Erreur lors du chargement de la commande: $e'));
    }
  }

  /// Charger les commandes d'un client
  Future<void> _onLoadClientOrders(
    LoadClientOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.getOrdersByClientId(event.clientId);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError('Erreur lors du chargement des commandes: $e'));
    }
  }

  /// Charger les commandes d'un vendeur
  Future<void> _onLoadSellerOrders(
    LoadSellerOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.getOrdersBySellerId(event.sellerId);
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError('Erreur lors du chargement des commandes: $e'));
    }
  }

  /// Charger les commandes d'un vendeur par statut
  Future<void> _onLoadSellerOrdersByStatus(
    LoadSellerOrdersByStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      final orders = await _orderService.getOrdersBySellerIdAndStatus(
        event.sellerId,
        event.status,
      );
      emit(OrdersLoaded(orders));
    } catch (e) {
      emit(OrderError('Erreur lors du chargement des commandes: $e'));
    }
  }

  /// Mettre à jour le statut d'une commande
  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.updateOrderStatus(
        orderId: event.orderId,
        newStatus: event.newStatus,
        comment: event.comment,
        updatedBy: event.updatedBy,
      );
      emit(OrderStatusUpdated(
        event.orderId,
        'Statut mis à jour: ${event.newStatus.label}',
      ));
    } catch (e) {
      emit(OrderError('Erreur lors de la mise à jour du statut: $e'));
    }
  }

  /// Valider une commande
  Future<void> _onValidateOrder(
    ValidateOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.validateOrder(
        orderId: event.orderId,
        comment: event.comment,
        validatedBy: event.validatedBy,
      );
      emit(OrderValidated(event.orderId));
    } catch (e) {
      emit(OrderError('Erreur lors de la validation de la commande: $e'));
    }
  }

  /// Refuser une commande
  Future<void> _onRejectOrder(
    RejectOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.rejectOrder(
        orderId: event.orderId,
        reason: event.reason,
        rejectedBy: event.rejectedBy,
      );
      emit(OrderRejected(event.orderId, event.reason));
    } catch (e) {
      emit(OrderError('Erreur lors du refus de la commande: $e'));
    }
  }

  /// Commencer la préparation
  Future<void> _onStartPreparation(
    StartPreparationEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.startPreparation(
        orderId: event.orderId,
        startedBy: event.startedBy,
      );
      emit(OrderStatusUpdated(event.orderId, 'Préparation commencée'));
    } catch (e) {
      emit(OrderError('Erreur lors du démarrage de la préparation: $e'));
    }
  }

  /// Marquer comme prête pour livraison
  Future<void> _onMarkReadyForDelivery(
    MarkReadyForDeliveryEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.markReadyForDelivery(
        orderId: event.orderId,
        markedBy: event.markedBy,
      );
      emit(OrderStatusUpdated(event.orderId, 'Commande prête pour livraison'));
    } catch (e) {
      emit(OrderError('Erreur lors de la mise à jour: $e'));
    }
  }

  /// Commencer la livraison
  Future<void> _onStartDelivery(
    StartDeliveryEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.startDelivery(
        orderId: event.orderId,
        startedBy: event.startedBy,
      );
      emit(OrderStatusUpdated(event.orderId, 'Livraison commencée'));
    } catch (e) {
      emit(OrderError('Erreur lors du démarrage de la livraison: $e'));
    }
  }

  /// Marquer comme livrée
  Future<void> _onMarkAsDelivered(
    MarkAsDeliveredEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.markAsDelivered(
        orderId: event.orderId,
        deliveredBy: event.deliveredBy,
      );
      emit(OrderStatusUpdated(event.orderId, 'Commande livrée'));
    } catch (e) {
      emit(OrderError('Erreur lors de la mise à jour: $e'));
    }
  }

  /// Confirmer la réception
  Future<void> _onConfirmDelivery(
    ConfirmDeliveryEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.confirmDelivery(
        orderId: event.orderId,
        confirmedBy: event.confirmedBy,
      );
      emit(OrderStatusUpdated(event.orderId, 'Réception confirmée'));
    } catch (e) {
      emit(OrderError('Erreur lors de la confirmation: $e'));
    }
  }

  /// Annuler une commande
  Future<void> _onCancelOrder(
    CancelOrderEvent event,
    Emitter<OrderState> emit,
  ) async {
    try {
      emit(OrderLoading());
      await _orderService.cancelOrder(
        orderId: event.orderId,
        reason: event.reason,
        cancelledBy: event.cancelledBy,
      );
      emit(OrderCancelled(event.orderId));
    } catch (e) {
      emit(OrderError('Erreur lors de l\'annulation: $e'));
    }
  }

  /// Écouter les mises à jour d'une commande en temps réel
  Future<void> _onListenToOrderUpdates(
    ListenToOrderUpdatesEvent event,
    Emitter<OrderState> emit,
  ) async {
    await _orderSubscription?.cancel();

    _orderSubscription = _orderService.streamOrder(event.orderId).listen(
      (order) {
        if (order != null) {
          emit(OrderListening(order));
        }
      },
      onError: (error) {
        emit(OrderError('Erreur de synchronisation: $error'));
      },
    );
  }

  /// Écouter les commandes d'un client en temps réel
  Future<void> _onListenToClientOrders(
    ListenToClientOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    print(
        '📡 OrderBloc: Réception ListenToClientOrdersEvent pour: ${event.clientId}');

    await _ordersSubscription?.cancel();

    print('🔄 OrderBloc: Création du stream pour clientId: ${event.clientId}');

    _ordersSubscription =
        _orderService.streamOrdersByClientId(event.clientId).listen(
      (orders) {
        print('📬 OrderBloc: Stream data reçu - ${orders.length} commandes');
        print(
            '🎯 OrderBloc: Émission de OrdersListening avec ${orders.length} commandes');
        emit(OrdersListening(orders));
      },
      onError: (error) {
        print('❌ OrderBloc: Erreur dans le stream: $error');
        emit(OrderError('Erreur de synchronisation: $error'));
      },
    );
  }

  /// Écouter les commandes d'un vendeur en temps réel
  Future<void> _onListenToSellerOrders(
    ListenToSellerOrdersEvent event,
    Emitter<OrderState> emit,
  ) async {
    print(
        '📡 OrderBloc Vendeur: Réception ListenToSellerOrdersEvent pour: ${event.sellerId}');

    await _ordersSubscription?.cancel();

    print(
        '🔄 OrderBloc Vendeur: Création du stream pour sellerId: ${event.sellerId}');

    _ordersSubscription =
        _orderService.streamOrdersBySellerId(event.sellerId).listen(
      (orders) {
        print(
            '📬 OrderBloc Vendeur: Stream data reçu - ${orders.length} commandes');
        print(
            '🎯 OrderBloc Vendeur: Émission de OrdersListening avec ${orders.length} commandes');
        emit(OrdersListening(orders));
      },
      onError: (error) {
        print('❌ OrderBloc Vendeur: Erreur dans le stream: $error');
        emit(OrderError('Erreur de synchronisation: $error'));
      },
    );
  }

  @override
  Future<void> close() {
    _orderSubscription?.cancel();
    _ordersSubscription?.cancel();
    return super.close();
  }
}
