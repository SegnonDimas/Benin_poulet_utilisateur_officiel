import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
abstract class HomeClientEvent extends Equatable {
  const HomeClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadHomeData extends HomeClientEvent {}

class SearchProducts extends HomeClientEvent {
  final String query;

  const SearchProducts({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterByCategory extends HomeClientEvent {
  final String category;

  const FilterByCategory({required this.category});

  @override
  List<Object?> get props => [category];
}

class AddToCart extends HomeClientEvent {
  final Product product;

  const AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class AddToFavorites extends HomeClientEvent {
  final dynamic item; // Product ou Store
  final String type; // 'product' ou 'store'

  const AddToFavorites({required this.item, required this.type});

  @override
  List<Object?> get props => [item, type];
}

// États
abstract class HomeClientState extends Equatable {
  const HomeClientState();

  @override
  List<Object?> get props => [];
}

class HomeClientInitial extends HomeClientState {}

class HomeClientLoading extends HomeClientState {}

class HomeClientLoaded extends HomeClientState {
  final List<Product> products;
  final List<Store> stores;
  final List<Product> filteredProducts;
  final List<Store> filteredStores;
  final String? searchQuery;
  final String? selectedCategory;

  const HomeClientLoaded({
    required this.products,
    required this.stores,
    required this.filteredProducts,
    required this.filteredStores,
    this.searchQuery,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [
        products,
        stores,
        filteredProducts,
        filteredStores,
        searchQuery,
        selectedCategory,
      ];

  HomeClientLoaded copyWith({
    List<Product>? products,
    List<Store>? stores,
    List<Product>? filteredProducts,
    List<Store>? filteredStores,
    String? searchQuery,
    String? selectedCategory,
  }) {
    return HomeClientLoaded(
      products: products ?? this.products,
      stores: stores ?? this.stores,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      filteredStores: filteredStores ?? this.filteredStores,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

class HomeClientError extends HomeClientState {
  final String message;

  const HomeClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class HomeClientBloc extends Bloc<HomeClientEvent, HomeClientState> {
  HomeClientBloc() : super(HomeClientInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<AddToCart>(_onAddToCart);
    on<AddToFavorites>(_onAddToFavorites);
  }

  // Données temporaires pour les placeholders
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Poulet de chair',
      imageUrl:
          'https://img-3.journaldesfemmes.fr/vFEM-3POiKT8i8NmZvqwIZiG9kg=/1500x/smart/1a712856aaaf419dbfa5d24cc9808e03/ccmcms-jdf/35925017.jpg',
      price: 2500.0,
      description: 'Poulet de chair frais et de qualité',
      category: 'Poulets',
    ),
    Product(
      id: '2',
      name: 'Œufs frais',
      imageUrl:
          'https://img-3.journaldesfemmes.fr/vFEM-3POiKT8i8NmZvqwIZiG9kg=/1500x/smart/1a712856aaaf419dbfa5d24cc9808e03/ccmcms-jdf/35925017.jpg',
      price: 500.0,
      description: 'Œufs frais du jour',
      category: 'Œufs',
    ),
    Product(
      id: '3',
      name: 'Aliment pour volaille',
      imageUrl:
          'https://img-3.journaldesfemmes.fr/vFEM-3POiKT8i8NmZvqwIZiG9kg=/1500x/smart/1a712856aaaf419dbfa5d24cc9808e03/ccmcms-jdf/35925017.jpg',
      price: 15000.0,
      description: 'Aliment complet pour volaille',
      category: 'Aliments',
    ),
  ];

  final List<Store> _mockStores = [
    Store(
      id: '1',
      name: 'Le Poulailler',
      imageUrl:
          'https://img-3.journaldesfemmes.fr/vFEM-3POiKT8i8NmZvqwIZiG9kg=/1500x/smart/1a712856aaaf419dbfa5d24cc9808e03/ccmcms-jdf/35925017.jpg',
      location: 'Cotonou, Bénin',
      rating: 4.5,
      description: 'Spécialiste en volailles',
    ),
    Store(
      id: '2',
      name: 'Mike Store',
      imageUrl:
          'https://img-3.journaldesfemmes.fr/vFEM-3POiKT8i8NmZvqwIZiG9kg=/1500x/smart/1a712856aaaf419dbfa5d24cc9808e03/ccmcms-jdf/35925017.jpg',
      location: 'Porto-Novo, Bénin',
      rating: 4.2,
      description: 'Produits avicoles de qualité',
    ),
    Store(
      id: '3',
      name: 'Le gros',
      imageUrl:
          'https://img-3.journaldesfemmes.fr/vFEM-3POiKT8i8NmZvqwIZiG9kg=/1500x/smart/1a712856aaaf419dbfa5d24cc9808e03/ccmcms-jdf/35925017.jpg',
      location: 'Parakou, Bénin',
      rating: 4.8,
      description: 'Grossiste en volailles',
    ),
  ];

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeClientState> emit,
  ) async {
    emit(HomeClientLoading());

    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));

      emit(HomeClientLoaded(
        products: _mockProducts,
        stores: _mockStores,
        filteredProducts: _mockProducts,
        filteredStores: _mockStores,
      ));
    } catch (e) {
      emit(HomeClientError(message: 'Erreur lors du chargement des données'));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;

      List<Product> filteredProducts = _mockProducts;
      List<Store> filteredStores = _mockStores;

      if (event.query.isNotEmpty) {
        filteredProducts = _mockProducts.where((product) {
          return product.name
                  .toLowerCase()
                  .contains(event.query.toLowerCase()) ||
              product.description
                  .toLowerCase()
                  .contains(event.query.toLowerCase());
        }).toList();

        filteredStores = _mockStores.where((store) {
          return store.name.toLowerCase().contains(event.query.toLowerCase()) ||
              store.description
                  .toLowerCase()
                  .contains(event.query.toLowerCase());
        }).toList();
      }

      emit(currentState.copyWith(
        filteredProducts: filteredProducts,
        filteredStores: filteredStores,
        searchQuery: event.query,
      ));
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<HomeClientState> emit,
  ) async {
    if (state is HomeClientLoaded) {
      final currentState = state as HomeClientLoaded;

      List<Product> filteredProducts = _mockProducts;

      if (event.category != 'Tous') {
        filteredProducts = _mockProducts.where((product) {
          return product.category == event.category;
        }).toList();
      }

      emit(currentState.copyWith(
        filteredProducts: filteredProducts,
        selectedCategory: event.category,
      ));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<HomeClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout au panier
    // Pour l'instant, on ne fait rien
    print('Produit ajouté au panier: ${event.product.name}');
  }

  Future<void> _onAddToFavorites(
    AddToFavorites event,
    Emitter<HomeClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout aux favoris
    // Pour l'instant, on ne fait rien
    print('Ajouté aux favoris: ${event.type}');
  }
}
