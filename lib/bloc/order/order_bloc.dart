import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/order_repository.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/models/order.dart';
import 'package:benin_poulet/services/cache_manager.dart';
import 'package:benin_poulet/services/sync_service.dart';

// Événements
abstract class OrderEvent {}

class LoadVendorOrders extends OrderEvent {
  final String? sellerId;
  final String? status;
  LoadVendorOrders({this.sellerId, this.status});
}

class LoadOrderById extends OrderEvent {
  final String orderId;
  LoadOrderById(this.orderId);
}

class UpdateOrderStatus extends OrderEvent {
  final String orderId;
  final String status;
  UpdateOrderStatus(this.orderId, this.status);
}

class LoadOrderStats extends OrderEvent {
  final String? sellerId;
  LoadOrderStats({this.sellerId});
}

class RefreshOrders extends OrderEvent {
  final String? sellerId;
  final String? status;
  RefreshOrders({this.sellerId, this.status});
}

// États
abstract class OrderState {}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrdersLoaded extends OrderState {
  final List<Order> orders;
  final bool isFromCache;
  OrdersLoaded(this.orders, {this.isFromCache = false});
}

class OrderLoaded extends OrderState {
  final Order order;
  final bool isFromCache;
  OrderLoaded(this.order, {this.isFromCache = false});
}

class OrderStatsLoaded extends OrderState {
  final Map<String, int> stats;
  final double totalRevenue;
  final bool isFromCache;
  OrderStatsLoaded(this.stats, this.totalRevenue, {this.isFromCache = false});
}

class OrderError extends OrderState {
  final String message;
  final bool hasCachedData;
  OrderError(this.message, {this.hasCachedData = false});
}

class OrderUpdated extends OrderState {
  final Order order;
  OrderUpdated(this.order);
}

class OrdersOffline extends OrderState {
  final List<Order> cachedOrders;
  final String message;
  OrdersOffline({required this.cachedOrders, required this.message});
}

// BLoC
class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository = OrderRepository();

  OrderBloc() : super(OrderInitial()) {
    on<LoadVendorOrders>(_onLoadVendorOrders);
    on<LoadOrderById>(_onLoadOrderById);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<LoadOrderStats>(_onLoadOrderStats);
    on<RefreshOrders>(_onRefreshOrders);
  }

  Future<void> _onLoadVendorOrders(
    LoadVendorOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    
    try {
      final sellerId = event.sellerId ?? AuthServices.userId;
      if (sellerId == null) {
        emit(OrderError('Aucun vendeur connecté'));
        return;
      }

      // Vérifier d'abord le cache
      final cachedOrders = CacheManager.getCachedVendorOrders(sellerId);
      if (cachedOrders.isNotEmpty) {
        final filteredOrders = event.status != null 
            ? cachedOrders.where((order) => order.status == event.status).toList()
            : cachedOrders;
        emit(OrdersLoaded(filteredOrders, isFromCache: true));
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (cachedOrders.isNotEmpty) {
          final filteredOrders = event.status != null 
              ? cachedOrders.where((order) => order.status == event.status).toList()
              : cachedOrders;
          emit(OrdersOffline(
            cachedOrders: filteredOrders,
            message: 'Mode hors ligne - Données en cache affichées',
          ));
        } else {
          emit(OrderError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      // Récupérer les données depuis Firestore
      Stream<List<Order>> ordersStream;
      if (event.status != null) {
        _orderRepository.getOrdersBySellerAndStatus(sellerId, event.status!).listen(
          (orders) async {
            await CacheManager.cacheVendorOrders(sellerId, orders as List<Order>);
            emit(OrdersLoaded(orders as List<Order>, isFromCache: false));
          },
          onError: (error) => emit(OrderError('Erreur lors du chargement des commandes: $error')),
        );
      } else {
        _orderRepository.getOrdersBySeller(sellerId).listen(
          (orders) async {
            await CacheManager.cacheVendorOrders(sellerId, orders as List<Order>);
            emit(OrdersLoaded(orders as List<Order>, isFromCache: false));
          },
          onError: (error) => emit(OrderError('Erreur lors du chargement des commandes: $error')),
        );
      }
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final sellerId = event.sellerId ?? AuthServices.userId;
      if (sellerId != null) {
        final cachedOrders = CacheManager.getCachedVendorOrders(sellerId);
        if (cachedOrders.isNotEmpty) {
          final filteredOrders = event.status != null 
              ? cachedOrders.where((order) => order.status == event.status).toList()
              : cachedOrders;
          emit(OrdersOffline(
            cachedOrders: filteredOrders,
            message: 'Erreur de connexion. Données en cache affichées.',
          ));
          return;
        }
      }
      
      emit(OrderError('Erreur lors du chargement des commandes: $e'));
    }
  }

  Future<void> _onLoadOrderById(
    LoadOrderById event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    
    try {
      // Vérifier d'abord le cache
      final cachedOrder = CacheManager.getCachedOrder(event.orderId);
      if (cachedOrder != null) {
        emit(OrderLoaded(cachedOrder, isFromCache: true));
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        if (cachedOrder != null) {
          emit(OrderLoaded(cachedOrder, isFromCache: true));
        } else {
          emit(OrderError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      final order = await _orderRepository.getOrder(event.orderId);
      if (order == null) {
        if (cachedOrder != null) {
          emit(OrderLoaded(cachedOrder, isFromCache: true));
        } else {
          emit(OrderError('Commande non trouvée'));
        }
        return;
      }
      
      // Mettre en cache la commande
      await CacheManager.cacheOrder(order);
      
      emit(OrderLoaded(order, isFromCache: false));
    } catch (e) {
      // En cas d'erreur, essayer d'utiliser le cache
      final cachedOrder = CacheManager.getCachedOrder(event.orderId);
      if (cachedOrder != null) {
        emit(OrderLoaded(cachedOrder, isFromCache: true));
        return;
      }
      
      emit(OrderError('Erreur lors du chargement de la commande: $e'));
    }
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    try {
      final isOnline = await CacheManager.isOnline();
      
      if (isOnline) {
        await _orderRepository.updateOrderStatus(event.orderId, event.status);
        
        // Recharger la commande mise à jour
        final order = await _orderRepository.getOrder(event.orderId);
        if (order != null) {
          await CacheManager.cacheOrder(order);
          emit(OrderUpdated(order));
        }
      } else {
        // Mode hors ligne - ajouter à la file d'attente
        await CacheManager.addOfflineAction({
          'type': 'update_order_status',
          'orderId': event.orderId,
          'status': event.status,
        });
        
        // Mettre à jour le cache local
        final cachedOrder = CacheManager.getCachedOrder(event.orderId);
        if (cachedOrder != null) {
          final updatedOrder = cachedOrder.copyWith(status: event.status);
          await CacheManager.cacheOrder(updatedOrder);
          emit(OrderUpdated(updatedOrder));
        }
      }
    } catch (e) {
      emit(OrderError('Erreur lors de la mise à jour: $e'));
    }
  }

  Future<void> _onLoadOrderStats(
    LoadOrderStats event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    
    try {
      final sellerId = event.sellerId ?? AuthServices.userId;
      if (sellerId == null) {
        emit(OrderError('Aucun vendeur connecté'));
        return;
      }

      // Vérifier la connectivité
      final isOnline = await CacheManager.isOnline();
      if (!isOnline) {
        // En mode hors ligne, calculer les stats depuis le cache
        final cachedOrders = CacheManager.getCachedVendorOrders(sellerId);
        if (cachedOrders.isNotEmpty) {
          final stats = _calculateStatsFromCache(cachedOrders);
          final totalRevenue = _calculateRevenueFromCache(cachedOrders);
          emit(OrderStatsLoaded(stats, totalRevenue, isFromCache: true));
        } else {
          emit(OrderError(
            'Aucune donnée disponible hors ligne. Veuillez vérifier votre connexion.',
            hasCachedData: false,
          ));
        }
        return;
      }

      final stats = await _orderRepository.getOrderStatsBySeller(sellerId);
      final totalRevenue = await _orderRepository.getTotalRevenueBySeller(sellerId);
      
      emit(OrderStatsLoaded(stats, totalRevenue, isFromCache: false));
    } catch (e) {
      emit(OrderError('Erreur lors du chargement des statistiques: $e'));
    }
  }

  Future<void> _onRefreshOrders(
    RefreshOrders event,
    Emitter<OrderState> emit,
  ) async {
    // Forcer le rechargement depuis Firestore
    add(LoadVendorOrders(sellerId: event.sellerId, status: event.status));
  }

  // Méthodes utilitaires pour calculer les stats depuis le cache
  Map<String, int> _calculateStatsFromCache(List<Order> orders) {
    final stats = <String, int>{
      'pending': 0,
      'active': 0,
      'cancelled': 0,
      'completed': 0,
    };

    for (final order in orders) {
      stats[order.status] = (stats[order.status] ?? 0) + 1;
    }

    return stats;
  }

  double _calculateRevenueFromCache(List<Order> orders) {
    return orders
        .where((order) => order.status == 'completed')
        .fold(0.0, (sum, order) => sum + order.totalAmount);
  }
}
