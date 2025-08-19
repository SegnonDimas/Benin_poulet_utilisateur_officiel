import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/store_review_repository.dart';
import 'package:benin_poulet/models/store_review.dart';

// Événements
abstract class StoreReviewEvent {}

class LoadStoreReviews extends StoreReviewEvent {
  final String storeId;
  LoadStoreReviews(this.storeId);
}

class LoadUserStoreReviews extends StoreReviewEvent {
  final String userId;
  LoadUserStoreReviews(this.userId);
}

class AddStoreReview extends StoreReviewEvent {
  final String userId;
  final String storeId;
  final int stars;
  final String message;
  final Map<String, dynamic>? autresInfos;
  
  AddStoreReview({
    required this.userId,
    required this.storeId,
    required this.stars,
    required this.message,
    this.autresInfos,
  });
}

class UpdateStoreReview extends StoreReviewEvent {
  final StoreReview review;
  UpdateStoreReview(this.review);
}

class DeleteStoreReview extends StoreReviewEvent {
  final String reviewId;
  DeleteStoreReview(this.reviewId);
}

class CheckUserReview extends StoreReviewEvent {
  final String userId;
  final String storeId;
  CheckUserReview(this.userId, this.storeId);
}

class GetStoreRatingStats extends StoreReviewEvent {
  final String storeId;
  GetStoreRatingStats(this.storeId);
}

// États
abstract class StoreReviewState {}

class StoreReviewInitial extends StoreReviewState {}

class StoreReviewLoading extends StoreReviewState {}

class StoreReviewLoaded extends StoreReviewState {
  final List<StoreReview> reviews;
  StoreReviewLoaded(this.reviews);
}

class StoreReviewError extends StoreReviewState {
  final String message;
  StoreReviewError(this.message);
}

class StoreReviewAdded extends StoreReviewState {
  final String reviewId;
  StoreReviewAdded(this.reviewId);
}

class StoreReviewUpdated extends StoreReviewState {}

class StoreReviewDeleted extends StoreReviewState {}

class UserReviewStatus extends StoreReviewState {
  final bool hasReviewed;
  UserReviewStatus(this.hasReviewed);
}

class StoreRatingStats extends StoreReviewState {
  final double averageRating;
  final int reviewCount;
  StoreRatingStats(this.averageRating, this.reviewCount);
}

// BLoC
class StoreReviewBloc extends Bloc<StoreReviewEvent, StoreReviewState> {
  final FirestoreStoreReviewService _storeReviewService = FirestoreStoreReviewService();

  StoreReviewBloc() : super(StoreReviewInitial()) {
    on<LoadStoreReviews>(_onLoadStoreReviews);
    on<LoadUserStoreReviews>(_onLoadUserStoreReviews);
    on<AddStoreReview>(_onAddStoreReview);
    on<UpdateStoreReview>(_onUpdateStoreReview);
    on<DeleteStoreReview>(_onDeleteStoreReview);
    on<CheckUserReview>(_onCheckUserReview);
    on<GetStoreRatingStats>(_onGetStoreRatingStats);
  }

  Future<void> _onLoadStoreReviews(
    LoadStoreReviews event,
    Emitter<StoreReviewState> emit,
  ) async {
    emit(StoreReviewLoading());
    try {
      await emit.onEach<List<StoreReview>>(
        _storeReviewService.getStoreReviewsByStore(event.storeId),
        onData: (reviews) => emit(StoreReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(StoreReviewError('Erreur lors du chargement des avis: $e'));
    }
  }

  Future<void> _onLoadUserStoreReviews(
    LoadUserStoreReviews event,
    Emitter<StoreReviewState> emit,
  ) async {
    emit(StoreReviewLoading());
    try {
      await emit.onEach<List<StoreReview>>(
        _storeReviewService.getStoreReviewsByUser(event.userId),
        onData: (reviews) => emit(StoreReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(StoreReviewError('Erreur lors du chargement des avis utilisateur: $e'));
    }
  }

  Future<void> _onAddStoreReview(
    AddStoreReview event,
    Emitter<StoreReviewState> emit,
  ) async {
    emit(StoreReviewLoading());
    try {
      final review = StoreReview(
        reviewId: '',
        userId: event.userId,
        storeId: event.storeId,
        stars: event.stars,
        message: event.message,
        date: DateTime.now(),
        autresInfos: event.autresInfos,
      );

      final reviewId = await _storeReviewService.createStoreReview(review);
      emit(StoreReviewAdded(reviewId));
    } catch (e) {
      emit(StoreReviewError('Erreur lors de l\'ajout de l\'avis: $e'));
    }
  }

  Future<void> _onUpdateStoreReview(
    UpdateStoreReview event,
    Emitter<StoreReviewState> emit,
  ) async {
    emit(StoreReviewLoading());
    try {
      await _storeReviewService.updateStoreReview(event.review);
      emit(StoreReviewUpdated());
    } catch (e) {
      emit(StoreReviewError('Erreur lors de la mise à jour de l\'avis: $e'));
    }
  }

  Future<void> _onDeleteStoreReview(
    DeleteStoreReview event,
    Emitter<StoreReviewState> emit,
  ) async {
    emit(StoreReviewLoading());
    try {
      await _storeReviewService.deleteStoreReview(event.reviewId);
      emit(StoreReviewDeleted());
    } catch (e) {
      emit(StoreReviewError('Erreur lors de la suppression de l\'avis: $e'));
    }
  }

  Future<void> _onCheckUserReview(
    CheckUserReview event,
    Emitter<StoreReviewState> emit,
  ) async {
    try {
      final hasReviewed = await _storeReviewService.hasUserReviewedStore(
        event.userId,
        event.storeId,
      );
      emit(UserReviewStatus(hasReviewed));
    } catch (e) {
      emit(StoreReviewError('Erreur lors de la vérification de l\'avis: $e'));
    }
  }

  Future<void> _onGetStoreRatingStats(
    GetStoreRatingStats event,
    Emitter<StoreReviewState> emit,
  ) async {
    try {
      final averageRating = await _storeReviewService.getAverageStoreRating(event.storeId);
      final reviewCount = await _storeReviewService.getStoreReviewCount(event.storeId);
      emit(StoreRatingStats(averageRating, reviewCount));
    } catch (e) {
      emit(StoreReviewError('Erreur lors du calcul des statistiques: $e'));
    }
  }
}
