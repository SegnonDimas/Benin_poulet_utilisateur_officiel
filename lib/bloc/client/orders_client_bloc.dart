import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Modèles temporaires pour les placeholders
class Product {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  final String description;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.description,
    required this.category,
  });
}

class OrderItem {
  final Product product;
  final int quantity;

  OrderItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
}

class Order {
  final String id;
  final String date;
  final String status;
  final List<OrderItem> items;
  final String deliveryAddress;
  final String deliveryMethod;
  final double subtotal;
  final double shippingCost;
  final double total;

  Order({
    required this.id,
    required this.date,
    required this.status,
    required this.items,
    required this.deliveryAddress,
    required this.deliveryMethod,
    required this.subtotal,
    required this.shippingCost,
    required this.total,
  });
}

// Événements
abstract class OrdersClientEvent extends Equatable {
  const OrdersClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadOrders extends OrdersClientEvent {}

class CancelOrder extends OrdersClientEvent {
  final String orderId;

  const CancelOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class TrackOrder extends OrdersClientEvent {
  final String orderId;

  const TrackOrder({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

// États
abstract class OrdersClientState extends Equatable {
  const OrdersClientState();

  @override
  List<Object?> get props => [];
}

class OrdersClientInitial extends OrdersClientState {}

class OrdersClientLoading extends OrdersClientState {}

class OrdersClientLoaded extends OrdersClientState {
  final List<Order> orders;

  const OrdersClientLoaded({required this.orders});

  @override
  List<Object?> get props => [orders];

  OrdersClientLoaded copyWith({
    List<Order>? orders,
  }) {
    return OrdersClientLoaded(
      orders: orders ?? this.orders,
    );
  }
}

class OrdersClientError extends OrdersClientState {
  final String message;

  const OrdersClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class OrdersClientBloc extends Bloc<OrdersClientEvent, OrdersClientState> {
  OrdersClientBloc() : super(OrdersClientInitial()) {
    on<LoadOrders>(_onLoadOrders);
    on<CancelOrder>(_onCancelOrder);
    on<TrackOrder>(_onTrackOrder);
  }

  // Données temporaires pour les placeholders
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Poulet de chair',
      imageUrl: 'https://via.placeholder.com/150',
      price: 2500.0,
      description: 'Poulet de chair frais et de qualité',
      category: 'Poulets',
    ),
    Product(
      id: '2',
      name: 'Œufs frais',
      imageUrl: 'https://via.placeholder.com/150',
      price: 500.0,
      description: 'Œufs frais du jour',
      category: 'Œufs',
    ),
    Product(
      id: '3',
      name: 'Aliment pour volaille',
      imageUrl: 'https://via.placeholder.com/150',
      price: 15000.0,
      description: 'Aliment complet pour volaille',
      category: 'Aliments',
    ),
  ];

  List<Order> _orders = [];

  Future<void> _onLoadOrders(
    LoadOrders event,
    Emitter<OrdersClientState> emit,
  ) async {
    emit(OrdersClientLoading());
    
    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Données temporaires des commandes
      _orders = [
        Order(
          id: 'ORD001',
          date: '15 Mars 2024',
          status: 'En cours',
          items: [
            OrderItem(product: _mockProducts[0], quantity: 2),
            OrderItem(product: _mockProducts[1], quantity: 1),
          ],
          deliveryAddress: '123 Rue de la Paix, Cotonou, Bénin',
          deliveryMethod: 'Livraison standard',
          subtotal: 5500.0,
          shippingCost: 500.0,
          total: 6000.0,
        ),
        Order(
          id: 'ORD002',
          date: '10 Mars 2024',
          status: 'Confirmée',
          items: [
            OrderItem(product: _mockProducts[2], quantity: 1),
          ],
          deliveryAddress: '456 Avenue des Palmiers, Porto-Novo, Bénin',
          deliveryMethod: 'Livraison express',
          subtotal: 15000.0,
          shippingCost: 1000.0,
          total: 16000.0,
        ),
        Order(
          id: 'ORD003',
          date: '5 Mars 2024',
          status: 'Livrée',
          items: [
            OrderItem(product: _mockProducts[0], quantity: 1),
            OrderItem(product: _mockProducts[1], quantity: 2),
          ],
          deliveryAddress: '789 Boulevard Central, Parakou, Bénin',
          deliveryMethod: 'Point relais',
          subtotal: 3500.0,
          shippingCost: 300.0,
          total: 3800.0,
        ),
        Order(
          id: 'ORD004',
          date: '1 Mars 2024',
          status: 'Annulée',
          items: [
            OrderItem(product: _mockProducts[2], quantity: 1),
          ],
          deliveryAddress: '321 Rue du Marché, Abomey, Bénin',
          deliveryMethod: 'Livraison standard',
          subtotal: 15000.0,
          shippingCost: 500.0,
          total: 15500.0,
        ),
      ];
      
      emit(OrdersClientLoaded(orders: _orders));
    } catch (e) {
      emit(OrdersClientError(message: 'Erreur lors du chargement des commandes'));
    }
  }

  Future<void> _onCancelOrder(
    CancelOrder event,
    Emitter<OrdersClientState> emit,
  ) async {
    if (state is OrdersClientLoaded) {
      final currentState = state as OrdersClientLoaded;
      
      // Trouver et annuler la commande
      final orderIndex = _orders.indexWhere((order) => order.id == event.orderId);
      
      if (orderIndex >= 0) {
        // Créer une nouvelle commande avec le statut annulé
        final order = _orders[orderIndex];
        _orders[orderIndex] = Order(
          id: order.id,
          date: order.date,
          status: 'Annulée',
          items: order.items,
          deliveryAddress: order.deliveryAddress,
          deliveryMethod: order.deliveryMethod,
          subtotal: order.subtotal,
          shippingCost: order.shippingCost,
          total: order.total,
        );
        
        emit(OrdersClientLoaded(orders: _orders));
      }
    }
  }

  Future<void> _onTrackOrder(
    TrackOrder event,
    Emitter<OrdersClientState> emit,
  ) async {
    // TODO: Implémenter le suivi de commande
    print('Suivi de la commande: ${event.orderId}');
  }
}
