import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/models/store.dart';
import 'package:benin_poulet/models/seller.dart';
import 'package:benin_poulet/models/user.dart';
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/services/store_details_service.dart';

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

class Review {
  final String id;
  final String userName;
  final String userImage;
  final int rating;
  final String comment;
  final String date;

  Review({
    required this.id,
    required this.userName,
    required this.userImage,
    required this.rating,
    required this.comment,
    required this.date,
  });
}

// Événements
abstract class StoreClientEvent extends Equatable {
  const StoreClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadStoreDetails extends StoreClientEvent {
  final String storeId;

  const LoadStoreDetails({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}

class ToggleFavorite extends StoreClientEvent {
  final String storeId;

  const ToggleFavorite({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}

class AddToCart extends StoreClientEvent {
  final Product product;

  const AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class LoadStoreProducts extends StoreClientEvent {
  final String storeId;

  const LoadStoreProducts({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}

class LoadStoreReviews extends StoreClientEvent {
  final String storeId;

  const LoadStoreReviews({required this.storeId});

  @override
  List<Object?> get props => [storeId];
}

// États
abstract class StoreClientState extends Equatable {
  const StoreClientState();

  @override
  List<Object?> get props => [];
}

class StoreClientInitial extends StoreClientState {}

class StoreClientLoading extends StoreClientState {}

class StoreClientLoaded extends StoreClientState {
  final List<Product> products;
  final List<Review> reviews;
  final List<Produit> realProducts;
  final Store? store;
  final Seller? seller;
  final AppUser? sellerUser;
  final double averageRating;
  final int productCount;
  final int reviewCount;
  final bool isFavorite;

  const StoreClientLoaded({
    required this.products,
    required this.reviews,
    required this.realProducts,
    this.store,
    this.seller,
    this.sellerUser,
    required this.averageRating,
    required this.productCount,
    required this.reviewCount,
    this.isFavorite = false,
  });

  @override
  List<Object?> get props => [
        products,
        reviews,
        realProducts,
        store,
        seller,
        sellerUser,
        averageRating,
        productCount,
        reviewCount,
        isFavorite,
      ];

  StoreClientLoaded copyWith({
    List<Product>? products,
    List<Review>? reviews,
    List<Produit>? realProducts,
    Store? store,
    Seller? seller,
    AppUser? sellerUser,
    double? averageRating,
    int? productCount,
    int? reviewCount,
    bool? isFavorite,
  }) {
    return StoreClientLoaded(
      products: products ?? this.products,
      reviews: reviews ?? this.reviews,
      realProducts: realProducts ?? this.realProducts,
      store: store ?? this.store,
      seller: seller ?? this.seller,
      sellerUser: sellerUser ?? this.sellerUser,
      averageRating: averageRating ?? this.averageRating,
      productCount: productCount ?? this.productCount,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class StoreClientError extends StoreClientState {
  final String message;

  const StoreClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class StoreClientBloc extends Bloc<StoreClientEvent, StoreClientState> {
  final StoreDetailsService _storeDetailsService = StoreDetailsService();

  StoreClientBloc() : super(StoreClientInitial()) {
    on<LoadStoreDetails>(_onLoadStoreDetails);
    on<ToggleFavorite>(_onToggleFavorite);
    on<AddToCart>(_onAddToCart);
    on<LoadStoreProducts>(_onLoadStoreProducts);
    on<LoadStoreReviews>(_onLoadStoreReviews);
  }

  // Données temporaires pour les placeholders
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Poulet de chair',
      imageUrl:
          'https://cdn.pratico-pratiques.com/app/uploads/sites/2/2018/08/29105153/poulet-roti.jpeg',
      price: 2500.0,
      description: 'Poulet de chair frais et de qualité',
      category: 'Poulets',
    ),
    Product(
      id: '2',
      name: 'Œufs frais',
      imageUrl:
          'https://cdn.pratico-pratiques.com/app/uploads/sites/2/2018/08/29105153/poulet-roti.jpeg',
      price: 500.0,
      description: 'Œufs frais du jour',
      category: 'Œufs',
    ),
    Product(
      id: '3',
      name: 'Aliment pour volaille',
      imageUrl:
          'https://cdn.pratico-pratiques.com/app/uploads/sites/2/2018/08/29105153/poulet-roti.jpeg',
      price: 15000.0,
      description: 'Aliment complet pour volaille',
      category: 'Aliments',
    ),
    Product(
      id: '4',
      name: 'Poulet local',
      imageUrl:
          'https://cdn.pratico-pratiques.com/app/uploads/sites/2/2018/08/29105153/poulet-roti.jpeg',
      price: 3000.0,
      description: 'Poulet local élevé en plein air',
      category: 'Poulets',
    ),
  ];

  final List<Review> _mockReviews = [
    Review(
      id: '1',
      userName: 'Jean Dupont',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/f/f4/USAFA_Hosts_Elon_Musk_%28Image_1_of_17%29_%28cropped%29.jpg',
      rating: 5,
      comment:
          'Excellent service et produits de qualité. Je recommande vivement !',
      date: 'Il y a 2 jours',
    ),
    Review(
      id: '2',
      userName: 'Marie Martin',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/f/f4/USAFA_Hosts_Elon_Musk_%28Image_1_of_17%29_%28cropped%29.jpg',
      rating: 4,
      comment: 'Très satisfaite de mes achats. Livraison rapide.',
      date: 'Il y a 1 semaine',
    ),
    Review(
      id: '3',
      userName: 'Pierre Durand',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/f/f4/USAFA_Hosts_Elon_Musk_%28Image_1_of_17%29_%28cropped%29.jpg',
      rating: 5,
      comment: 'Boutique sérieuse avec des prix compétitifs.',
      date: 'Il y a 2 semaines',
    ),
  ];

  Future<void> _onLoadStoreDetails(
    LoadStoreDetails event,
    Emitter<StoreClientState> emit,
  ) async {
    emit(StoreClientLoading());

    try {
      // Récupérer les vraies données de la boutique
      final storeDetails = await _storeDetailsService.getStoreDetails(event.storeId);
      
      if (storeDetails == null) {
        emit(StoreClientError(message: 'Boutique introuvable'));
        return;
      }

      final Store store = storeDetails['store'];
      final Seller seller = storeDetails['seller'];
      final AppUser sellerUser = storeDetails['sellerUser'];
      final List<Produit> realProducts = storeDetails['realProducts'];
      final double averageRating = storeDetails['averageRating'];
      final int productCount = storeDetails['productCount'];
      final int reviewCount = storeDetails['reviewCount'];

      emit(StoreClientLoaded(
        products: _mockProducts, // Garder pour compatibilité avec l'UI existante
        reviews: _mockReviews, // Garder pour compatibilité avec l'UI existante
        realProducts: realProducts,
        store: store,
        seller: seller,
        sellerUser: sellerUser,
        averageRating: averageRating,
        productCount: productCount,
        reviewCount: reviewCount,
      ));
    } catch (e) {
      emit(StoreClientError(message: 'Erreur lors du chargement des détails: $e'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<StoreClientState> emit,
  ) async {
    if (state is StoreClientLoaded) {
      final currentState = state as StoreClientLoaded;

      // TODO: Implémenter la logique de favoris avec le backend
      emit(currentState.copyWith(
        isFavorite: !currentState.isFavorite,
      ));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<StoreClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout au panier
    // Pour l'instant, on ne fait rien
    print('Produit ajouté au panier: ${event.product.name}');
  }

  Future<void> _onLoadStoreProducts(
    LoadStoreProducts event,
    Emitter<StoreClientState> emit,
  ) async {
    if (state is StoreClientLoaded) {
      final currentState = state as StoreClientLoaded;

      // TODO: Charger les produits spécifiques à la boutique
      emit(currentState.copyWith(
        products: _mockProducts,
        productCount: _mockProducts.length,
      ));
    }
  }

  Future<void> _onLoadStoreReviews(
    LoadStoreReviews event,
    Emitter<StoreClientState> emit,
  ) async {
    if (state is StoreClientLoaded) {
      final currentState = state as StoreClientLoaded;

      // TODO: Charger les avis spécifiques à la boutique
      emit(currentState.copyWith(
        reviews: _mockReviews,
        reviewCount: _mockReviews.length,
      ));
    }
  }
}
