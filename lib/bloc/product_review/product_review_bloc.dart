import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/product_review_repository.dart';
import 'package:benin_poulet/models/product_review.dart';

// Événements
abstract class ProductReviewEvent {}

class LoadProductReviews extends ProductReviewEvent {
  final String productId;
  LoadProductReviews(this.productId);
}

class LoadUserProductReviews extends ProductReviewEvent {
  final String userId;
  LoadUserProductReviews(this.userId);
}

class LoadStoreProductReviews extends ProductReviewEvent {
  final String storeId;
  LoadStoreProductReviews(this.storeId);
}

class AddProductReview extends ProductReviewEvent {
  final String userId;
  final String productId;
  final String storeId;
  final int stars;
  final String message;
  final Map<String, dynamic>? autresInfos;
  
  AddProductReview({
    required this.userId,
    required this.productId,
    required this.storeId,
    required this.stars,
    required this.message,
    this.autresInfos,
  });
}

class UpdateProductReview extends ProductReviewEvent {
  final ProductReview review;
  UpdateProductReview(this.review);
}

class DeleteProductReview extends ProductReviewEvent {
  final String reviewId;
  DeleteProductReview(this.reviewId);
}

class CheckUserProductReview extends ProductReviewEvent {
  final String userId;
  final String productId;
  CheckUserProductReview(this.userId, this.productId);
}

class GetProductRatingStats extends ProductReviewEvent {
  final String productId;
  GetProductRatingStats(this.productId);
}

// États
abstract class ProductReviewState {}

class ProductReviewInitial extends ProductReviewState {}

class ProductReviewLoading extends ProductReviewState {}

class ProductReviewLoaded extends ProductReviewState {
  final List<ProductReview> reviews;
  ProductReviewLoaded(this.reviews);
}

class ProductReviewError extends ProductReviewState {
  final String message;
  ProductReviewError(this.message);
}

class ProductReviewAdded extends ProductReviewState {
  final String reviewId;
  ProductReviewAdded(this.reviewId);
}

class ProductReviewUpdated extends ProductReviewState {}

class ProductReviewDeleted extends ProductReviewState {}

class UserProductReviewStatus extends ProductReviewState {
  final bool hasReviewed;
  UserProductReviewStatus(this.hasReviewed);
}

class ProductRatingStats extends ProductReviewState {
  final double averageRating;
  final int reviewCount;
  ProductRatingStats(this.averageRating, this.reviewCount);
}

// BLoC
class ProductReviewBloc extends Bloc<ProductReviewEvent, ProductReviewState> {
  final FirestoreProductReviewService _productReviewService = FirestoreProductReviewService();

  ProductReviewBloc() : super(ProductReviewInitial()) {
    on<LoadProductReviews>(_onLoadProductReviews);
    on<LoadUserProductReviews>(_onLoadUserProductReviews);
    on<LoadStoreProductReviews>(_onLoadStoreProductReviews);
    on<AddProductReview>(_onAddProductReview);
    on<UpdateProductReview>(_onUpdateProductReview);
    on<DeleteProductReview>(_onDeleteProductReview);
    on<CheckUserProductReview>(_onCheckUserProductReview);
    on<GetProductRatingStats>(_onGetProductRatingStats);
  }

  Future<void> _onLoadProductReviews(
    LoadProductReviews event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(ProductReviewLoading());
    try {
      await emit.onEach<List<ProductReview>>(
        _productReviewService.getProductReviewsByProduct(event.productId),
        onData: (reviews) => emit(ProductReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(ProductReviewError('Erreur lors du chargement des avis: $e'));
    }
  }

  Future<void> _onLoadUserProductReviews(
    LoadUserProductReviews event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(ProductReviewLoading());
    try {
      await emit.onEach<List<ProductReview>>(
        _productReviewService.getProductReviewsByUser(event.userId),
        onData: (reviews) => emit(ProductReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(ProductReviewError('Erreur lors du chargement des avis utilisateur: $e'));
    }
  }

  Future<void> _onLoadStoreProductReviews(
    LoadStoreProductReviews event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(ProductReviewLoading());
    try {
      await emit.onEach<List<ProductReview>>(
        _productReviewService.getProductReviewsByStore(event.storeId),
        onData: (reviews) => emit(ProductReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(ProductReviewError('Erreur lors du chargement des avis de la boutique: $e'));
    }
  }

  Future<void> _onAddProductReview(
    AddProductReview event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(ProductReviewLoading());
    try {
      final review = ProductReview(
        reviewId: '',
        userId: event.userId,
        productId: event.productId,
        storeId: event.storeId,
        stars: event.stars,
        message: event.message,
        date: DateTime.now(),
        autresInfos: event.autresInfos,
      );

      final reviewId = await _productReviewService.createProductReview(review);
      emit(ProductReviewAdded(reviewId));
    } catch (e) {
      emit(ProductReviewError('Erreur lors de l\'ajout de l\'avis: $e'));
    }
  }

  Future<void> _onUpdateProductReview(
    UpdateProductReview event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(ProductReviewLoading());
    try {
      await _productReviewService.updateProductReview(event.review);
      emit(ProductReviewUpdated());
    } catch (e) {
      emit(ProductReviewError('Erreur lors de la mise à jour de l\'avis: $e'));
    }
  }

  Future<void> _onDeleteProductReview(
    DeleteProductReview event,
    Emitter<ProductReviewState> emit,
  ) async {
    emit(ProductReviewLoading());
    try {
      await _productReviewService.deleteProductReview(event.reviewId);
      emit(ProductReviewDeleted());
    } catch (e) {
      emit(ProductReviewError('Erreur lors de la suppression de l\'avis: $e'));
    }
  }

  Future<void> _onCheckUserProductReview(
    CheckUserProductReview event,
    Emitter<ProductReviewState> emit,
  ) async {
    try {
      final hasReviewed = await _productReviewService.hasUserReviewedProduct(
        event.userId,
        event.productId,
      );
      emit(UserProductReviewStatus(hasReviewed));
    } catch (e) {
      emit(ProductReviewError('Erreur lors de la vérification de l\'avis: $e'));
    }
  }

  Future<void> _onGetProductRatingStats(
    GetProductRatingStats event,
    Emitter<ProductReviewState> emit,
  ) async {
    try {
      final averageRating = await _productReviewService.getAverageProductRating(event.productId);
      final reviewCount = await _productReviewService.getProductReviewCount(event.productId);
      emit(ProductRatingStats(averageRating, reviewCount));
    } catch (e) {
      emit(ProductReviewError('Erreur lors du calcul des statistiques: $e'));
    }
  }
}
