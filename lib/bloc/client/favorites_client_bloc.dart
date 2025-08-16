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

class Store {
  final String id;
  final String name;
  final String imageUrl;
  final String location;
  final double rating;
  final String description;

  Store({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
    required this.rating,
    required this.description,
  });
}

// Événements
abstract class FavoritesClientEvent extends Equatable {
  const FavoritesClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavorites extends FavoritesClientEvent {}

class AddToFavorites extends FavoritesClientEvent {
  final dynamic item;
  final String type; // 'product' ou 'store'

  const AddToFavorites({required this.item, required this.type});

  @override
  List<Object?> get props => [item, type];
}

class RemoveFromFavorites extends FavoritesClientEvent {
  final String itemId;
  final String type; // 'product' ou 'store'

  const RemoveFromFavorites({required this.itemId, required this.type});

  @override
  List<Object?> get props => [itemId, type];
}

class ClearFavorites extends FavoritesClientEvent {}

class AddToCart extends FavoritesClientEvent {
  final Product product;

  const AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}

// États
abstract class FavoritesClientState extends Equatable {
  const FavoritesClientState();

  @override
  List<Object?> get props => [];
}

class FavoritesClientInitial extends FavoritesClientState {}

class FavoritesClientLoading extends FavoritesClientState {}

class FavoritesClientLoaded extends FavoritesClientState {
  final List<Product> favoriteProducts;
  final List<Store> favoriteStores;

  const FavoritesClientLoaded({
    required this.favoriteProducts,
    required this.favoriteStores,
  });

  @override
  List<Object?> get props => [favoriteProducts, favoriteStores];

  FavoritesClientLoaded copyWith({
    List<Product>? favoriteProducts,
    List<Store>? favoriteStores,
  }) {
    return FavoritesClientLoaded(
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      favoriteStores: favoriteStores ?? this.favoriteStores,
    );
  }
}

class FavoritesClientError extends FavoritesClientState {
  final String message;

  const FavoritesClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class FavoritesClientBloc extends Bloc<FavoritesClientEvent, FavoritesClientState> {
  FavoritesClientBloc() : super(FavoritesClientInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearFavorites>(_onClearFavorites);
    on<AddToCart>(_onAddToCart);
  }

  List<Product> _favoriteProducts = [];
  List<Store> _favoriteStores = [];

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

  final List<Store> _mockStores = [
    Store(
      id: '1',
      name: 'Le Poulailler',
      imageUrl: 'https://via.placeholder.com/150',
      location: 'Cotonou, Bénin',
      rating: 4.5,
      description: 'Spécialiste en volailles',
    ),
    Store(
      id: '2',
      name: 'Mike Store',
      imageUrl: 'https://via.placeholder.com/150',
      location: 'Porto-Novo, Bénin',
      rating: 4.2,
      description: 'Produits avicoles de qualité',
    ),
  ];

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesClientState> emit,
  ) async {
    emit(FavoritesClientLoading());
    
    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Données temporaires des favoris
      _favoriteProducts = [_mockProducts[0], _mockProducts[1]];
      _favoriteStores = [_mockStores[0]];
      
      emit(FavoritesClientLoaded(
        favoriteProducts: _favoriteProducts,
        favoriteStores: _favoriteStores,
      ));
    } catch (e) {
      emit(FavoritesClientError(message: 'Erreur lors du chargement des favoris'));
    }
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<FavoritesClientState> emit,
  ) async {
    if (state is FavoritesClientLoaded) {
      final currentState = state as FavoritesClientLoaded;
      
      if (event.type == 'product') {
        final product = event.item as Product;
        if (!_favoriteProducts.any((p) => p.id == product.id)) {
          _favoriteProducts.add(product);
        }
      } else if (event.type == 'store') {
        final store = event.item as Store;
        if (!_favoriteStores.any((s) => s.id == store.id)) {
          _favoriteStores.add(store);
        }
      }
      
      emit(currentState.copyWith(
        favoriteProducts: _favoriteProducts,
        favoriteStores: _favoriteStores,
      ));
    }
  }

  Future<void> _onRemoveFromFavorites(
    RemoveFromFavorites event,
    Emitter<FavoritesClientState> emit,
  ) async {
    if (state is FavoritesClientLoaded) {
      final currentState = state as FavoritesClientLoaded;
      
      if (event.type == 'product') {
        _favoriteProducts.removeWhere((product) => product.id == event.itemId);
      } else if (event.type == 'store') {
        _favoriteStores.removeWhere((store) => store.id == event.itemId);
      }
      
      emit(currentState.copyWith(
        favoriteProducts: _favoriteProducts,
        favoriteStores: _favoriteStores,
      ));
    }
  }

  Future<void> _onClearFavorites(
    ClearFavorites event,
    Emitter<FavoritesClientState> emit,
  ) async {
    _favoriteProducts.clear();
    _favoriteStores.clear();
    
    emit(FavoritesClientLoaded(
      favoriteProducts: _favoriteProducts,
      favoriteStores: _favoriteStores,
    ));
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<FavoritesClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout au panier
    print('Produit ajouté au panier depuis les favoris: ${event.product.name}');
  }
}
