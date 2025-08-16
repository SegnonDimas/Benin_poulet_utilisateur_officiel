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

class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;
}

// Événements
abstract class CartClientEvent extends Equatable {
  const CartClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadCart extends CartClientEvent {}

class AddToCart extends CartClientEvent {
  final Product product;
  final int quantity;

  const AddToCart({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class RemoveFromCart extends CartClientEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class UpdateQuantity extends CartClientEvent {
  final String productId;
  final int quantity;

  const UpdateQuantity({required this.productId, required this.quantity});

  @override
  List<Object?> get props => [productId, quantity];
}

class ClearCart extends CartClientEvent {}

// États
abstract class CartClientState extends Equatable {
  const CartClientState();

  @override
  List<Object?> get props => [];
}

class CartClientInitial extends CartClientState {}

class CartClientLoading extends CartClientState {}

class CartClientLoaded extends CartClientState {
  final List<CartItem> cartItems;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;

  const CartClientLoaded({
    required this.cartItems,
    required this.subtotal,
    required this.shippingCost,
    this.discount = 0,
  }) : total = subtotal + shippingCost - discount;

  @override
  List<Object?> get props => [
    cartItems,
    subtotal,
    shippingCost,
    discount,
    total,
  ];

  CartClientLoaded copyWith({
    List<CartItem>? cartItems,
    double? subtotal,
    double? shippingCost,
    double? discount,
  }) {
    return CartClientLoaded(
      cartItems: cartItems ?? this.cartItems,
      subtotal: subtotal ?? this.subtotal,
      shippingCost: shippingCost ?? this.shippingCost,
      discount: discount ?? this.discount,
    );
  }
}

class CartClientError extends CartClientState {
  final String message;

  const CartClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class CartClientBloc extends Bloc<CartClientEvent, CartClientState> {
  CartClientBloc() : super(CartClientInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
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

  List<CartItem> _cartItems = [];

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartClientState> emit,
  ) async {
    emit(CartClientLoading());
    
    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Données temporaires du panier
      _cartItems = [
        CartItem(product: _mockProducts[0], quantity: 2),
        CartItem(product: _mockProducts[1], quantity: 1),
      ];
      
      final subtotal = _cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      final shippingCost = subtotal > 10000 ? 0.0 : 500.0; // Livraison gratuite au-dessus de 10k
      
      emit(CartClientLoaded(
        cartItems: _cartItems,
        subtotal: subtotal,
        shippingCost: shippingCost,
      ));
    } catch (e) {
      emit(CartClientError(message: 'Erreur lors du chargement du panier'));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartClientState> emit,
  ) async {
    if (state is CartClientLoaded) {
      final currentState = state as CartClientLoaded;
      
      // Vérifier si le produit est déjà dans le panier
      final existingIndex = _cartItems.indexWhere(
        (item) => item.product.id == event.product.id,
      );
      
      if (existingIndex >= 0) {
        // Mettre à jour la quantité
        _cartItems[existingIndex] = CartItem(
          product: _cartItems[existingIndex].product,
          quantity: _cartItems[existingIndex].quantity + event.quantity,
        );
      } else {
        // Ajouter un nouvel article
        _cartItems.add(CartItem(
          product: event.product,
          quantity: event.quantity,
        ));
      }
      
      final subtotal = _cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      final shippingCost = subtotal > 10000 ? 0.0 : 500.0;
      
      emit(CartClientLoaded(
        cartItems: _cartItems,
        subtotal: subtotal,
        shippingCost: shippingCost,
      ));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartClientState> emit,
  ) async {
    if (state is CartClientLoaded) {
      _cartItems.removeWhere((item) => item.product.id == event.productId);
      
      final subtotal = _cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      final shippingCost = subtotal > 10000 ? 0.0 : 500.0;
      
      emit(CartClientLoaded(
        cartItems: _cartItems,
        subtotal: subtotal,
        shippingCost: shippingCost,
      ));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartClientState> emit,
  ) async {
    if (state is CartClientLoaded) {
      final index = _cartItems.indexWhere(
        (item) => item.product.id == event.productId,
      );
      
      if (index >= 0) {
        if (event.quantity <= 0) {
          _cartItems.removeAt(index);
        } else {
          _cartItems[index] = CartItem(
            product: _cartItems[index].product,
            quantity: event.quantity,
          );
        }
        
        final subtotal = _cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
        final shippingCost = subtotal > 10000 ? 0.0 : 500.0;
        
        emit(CartClientLoaded(
          cartItems: _cartItems,
          subtotal: subtotal,
          shippingCost: shippingCost,
        ));
      }
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartClientState> emit,
  ) async {
    _cartItems.clear();
    
    emit(CartClientLoaded(
      cartItems: _cartItems,
      subtotal: 0,
      shippingCost: 0,
    ));
  }
}
