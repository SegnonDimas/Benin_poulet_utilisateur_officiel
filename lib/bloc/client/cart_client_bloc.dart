import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:benin_poulet/services/cart_service.dart';
import 'package:benin_poulet/bloc/client/home_client_bloc.dart';

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
  final String productId;
  final int quantity;

  const AddToCart({required this.productId, this.quantity = 1});

  @override
  List<Object?> get props => [productId, quantity];
}

class RemoveFromCart extends CartClientEvent {
  final String productId;

  const RemoveFromCart({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class LoadCartProducts extends CartClientEvent {
  final List<Product> allProducts;

  const LoadCartProducts({required this.allProducts});

  @override
  List<Object?> get props => [allProducts];
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
  final List<String> cartProductIds;
  final List<Product> cartProducts;
  final List<CartItem> cartItems;
  final double subtotal;
  final double shippingCost;
  final double discount;
  final double total;

  const CartClientLoaded({
    required this.cartProductIds,
    required this.cartProducts,
    required this.cartItems,
    required this.subtotal,
    required this.shippingCost,
    this.discount = 0,
  }) : total = subtotal + shippingCost - discount;

  @override
  List<Object?> get props => [
    cartProductIds,
    cartProducts,
    cartItems,
    subtotal,
    shippingCost,
    discount,
    total,
  ];

  CartClientLoaded copyWith({
    List<String>? cartProductIds,
    List<Product>? cartProducts,
    List<CartItem>? cartItems,
    double? subtotal,
    double? shippingCost,
    double? discount,
  }) {
    return CartClientLoaded(
      cartProductIds: cartProductIds ?? this.cartProductIds,
      cartProducts: cartProducts ?? this.cartProducts,
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
  final CartService _cartService = CartService();

  CartClientBloc() : super(CartClientInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<LoadCartProducts>(_onLoadCartProducts);
    on<ClearCart>(_onClearCart);
  }

  Future<void> _onLoadCart(
    LoadCart event,
    Emitter<CartClientState> emit,
  ) async {
    emit(CartClientLoading());
    
    try {
      final cartProductIds = await _cartService.getCartProductIds();
      
      
      emit(CartClientLoaded(
        cartProductIds: cartProductIds,
        cartProducts: [], // Sera rempli par LoadCartProducts
        cartItems: [], // Sera rempli par LoadCartProducts
        subtotal: 0.0,
        shippingCost: 0.0,
      ));
    } catch (e) {
      emit(CartClientError(message: 'Erreur lors du chargement du panier: $e'));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<CartClientState> emit,
  ) async {
    try {
      final success = await _cartService.addProductToCart(event.productId);
      if (success) {
        // Mettre à jour l'état immédiatement
        if (state is CartClientLoaded) {
          final currentState = state as CartClientLoaded;
          final updatedCartIds = Set<String>.from(currentState.cartProductIds);
          updatedCartIds.add(event.productId);
          
          emit(currentState.copyWith(
            cartProductIds: updatedCartIds.toList(),
          ));
        }
        // Recharger le panier complet
        add(LoadCart());
      } else {
        emit(CartClientError(message: 'Erreur lors de l\'ajout au panier'));
      }
    } catch (e) {
      emit(CartClientError(message: 'Erreur lors de l\'ajout au panier: $e'));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartClientState> emit,
  ) async {
    try {
      final success = await _cartService.removeProductFromCart(event.productId);
      if (success) {
        // Mettre à jour l'état immédiatement
        if (state is CartClientLoaded) {
          final currentState = state as CartClientLoaded;
          final updatedCartIds = List<String>.from(currentState.cartProductIds);
          updatedCartIds.remove(event.productId);
          
          emit(currentState.copyWith(
            cartProductIds: updatedCartIds,
          ));
        }
        // Recharger le panier complet
        add(LoadCart());
      } else {
        emit(CartClientError(message: 'Erreur lors de la suppression du panier'));
      }
    } catch (e) {
      emit(CartClientError(message: 'Erreur lors de la suppression du panier: $e'));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartClientState> emit,
  ) async {
    if (state is CartClientLoaded) {
      final currentState = state as CartClientLoaded;
      
      // Mettre à jour la quantité dans cartItems
      final updatedCartItems = currentState.cartItems.map((item) {
        if (item.product.id == event.productId) {
          return CartItem(
            product: item.product,
            quantity: event.quantity,
          );
        }
        return item;
      }).toList();
      
      // Recalculer les totaux
      final subtotal = updatedCartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      final shippingCost = subtotal > 10000 ? 0.0 : 500.0;
      
      emit(currentState.copyWith(
        cartItems: updatedCartItems,
        subtotal: subtotal,
        shippingCost: shippingCost,
      ));
    }
  }

  Future<void> _onLoadCartProducts(
    LoadCartProducts event,
    Emitter<CartClientState> emit,
  ) async {
    if (state is CartClientLoaded) {
      final currentState = state as CartClientLoaded;
      
      // Filtrer les produits qui sont dans le panier
      final cartProducts = event.allProducts
          .where((product) => currentState.cartProductIds.contains(product.id))
          .toList();
      
      // Créer les CartItems avec quantité par défaut de 1
      final cartItems = cartProducts
          .map((product) => CartItem(product: product, quantity: 1))
          .toList();
      
      // Calculer les totaux
      final subtotal = cartItems.fold<double>(0.0, (sum, item) => sum + item.totalPrice);
      final shippingCost = subtotal > 10000 ? 0.0 : 500.0; // Livraison gratuite au-dessus de 10k
      
      emit(currentState.copyWith(
        cartProducts: cartProducts,
        cartItems: cartItems,
        subtotal: subtotal,
        shippingCost: shippingCost,
      ));
    }
  }

  Future<void> _onClearCart(
    ClearCart event,
    Emitter<CartClientState> emit,
  ) async {
    try {
      final success = await _cartService.clearCart();
      if (success) {
        emit(CartClientLoaded(
          cartProductIds: [],
          cartProducts: [],
          cartItems: [],
          subtotal: 0.0,
          shippingCost: 0.0,
        ));
      } else {
        emit(CartClientError(message: 'Erreur lors du vidage du panier'));
      }
    } catch (e) {
      emit(CartClientError(message: 'Erreur lors du vidage du panier: $e'));
    }
  }
}
