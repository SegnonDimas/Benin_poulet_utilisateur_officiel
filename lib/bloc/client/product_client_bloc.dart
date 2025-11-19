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
abstract class ProductClientEvent extends Equatable {
  const ProductClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetails extends ProductClientEvent {
  final String productId;

  const LoadProductDetails({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class ToggleFavorite extends ProductClientEvent {
  final String productId;

  const ToggleFavorite({required this.productId});

  @override
  List<Object?> get props => [productId];
}

class AddToCart extends ProductClientEvent {
  final Product product;
  final int quantity;

  const AddToCart({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}

class LoadProductReviews extends ProductClientEvent {
  final String productId;

  const LoadProductReviews({required this.productId});

  @override
  List<Object?> get props => [productId];
}

// États
abstract class ProductClientState extends Equatable {
  const ProductClientState();

  @override
  List<Object?> get props => [];
}

class ProductClientInitial extends ProductClientState {}

class ProductClientLoading extends ProductClientState {}

class ProductClientLoaded extends ProductClientState {
  final List<Review> reviews;
  final int reviewCount;
  final bool isFavorite;
  final double averageRating;

  const ProductClientLoaded({
    required this.reviews,
    required this.reviewCount,
    this.isFavorite = false,
    this.averageRating = 4.5,
  });

  @override
  List<Object?> get props => [
        reviews,
        reviewCount,
        isFavorite,
        averageRating,
      ];

  ProductClientLoaded copyWith({
    List<Review>? reviews,
    int? reviewCount,
    bool? isFavorite,
    double? averageRating,
  }) {
    return ProductClientLoaded(
      reviews: reviews ?? this.reviews,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}

class ProductClientError extends ProductClientState {
  final String message;

  const ProductClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class ProductClientBloc extends Bloc<ProductClientEvent, ProductClientState> {
  ProductClientBloc() : super(ProductClientInitial()) {
    on<LoadProductDetails>(_onLoadProductDetails);
    on<ToggleFavorite>(_onToggleFavorite);
    on<AddToCart>(_onAddToCart);
    on<LoadProductReviews>(_onLoadProductReviews);
  }

  // Données temporaires pour les placeholders
  final List<Review> _mockReviews = [
    Review(
      id: '1',
      userName: 'Jean Dupont',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg/960px-Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg',
      rating: 5,
      comment:
          'Excellent produit, très frais et de bonne qualité. Je recommande !',
      date: 'Il y a 2 jours',
    ),
    Review(
      id: '2',
      userName: 'Marie Martin',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg/960px-Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg',
      rating: 4,
      comment:
          'Très satisfaite de mon achat. Le produit correspond parfaitement à la description.',
      date: 'Il y a 1 semaine',
    ),
    Review(
      id: '3',
      userName: 'Pierre Durand',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg/960px-Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg',
      rating: 5,
      comment: 'Prix compétitif et qualité au rendez-vous. Livraison rapide.',
      date: 'Il y a 2 semaines',
    ),
    Review(
      id: '4',
      userName: 'Sophie Bernard',
      userImage:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg/960px-Mark_Zuckerberg_F8_2019_Keynote_%2832830578717%29_%28cropped%29.jpg',
      rating: 4,
      comment: 'Bon rapport qualité-prix. Je recommande ce vendeur.',
      date: 'Il y a 3 semaines',
    ),
  ];

  Future<void> _onLoadProductDetails(
    LoadProductDetails event,
    Emitter<ProductClientState> emit,
  ) async {
    emit(ProductClientLoading());

    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));

      emit(ProductClientLoaded(
        reviews: _mockReviews,
        reviewCount: _mockReviews.length,
        averageRating: 4.5,
      ));
    } catch (e) {
      emit(
          ProductClientError(message: 'Erreur lors du chargement des détails'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductClientState> emit,
  ) async {
    if (state is ProductClientLoaded) {
      final currentState = state as ProductClientLoaded;

      // TODO: Implémenter la logique de favoris avec le backend
      emit(currentState.copyWith(
        isFavorite: !currentState.isFavorite,
      ));
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<ProductClientState> emit,
  ) async {
    // TODO: Implémenter l'ajout au panier
    // Pour l'instant, on ne fait rien
    print(
        'Produit ajouté au panier: ${event.product.name} (quantité: ${event.quantity})');
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviews event,
    Emitter<ProductClientState> emit,
  ) async {
    if (state is ProductClientLoaded) {
      final currentState = state as ProductClientLoaded;

      // TODO: Charger les avis spécifiques au produit
      emit(currentState.copyWith(
        reviews: _mockReviews,
        reviewCount: _mockReviews.length,
      ));
    }
  }
}
