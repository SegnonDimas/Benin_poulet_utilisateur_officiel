import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Événements
abstract class ReviewClientEvent extends Equatable {
  const ReviewClientEvent();

  @override
  List<Object?> get props => [];
}

class LoadReviewForm extends ReviewClientEvent {
  final String itemId;
  final String type; // 'product' ou 'store'

  const LoadReviewForm({required this.itemId, required this.type});

  @override
  List<Object?> get props => [itemId, type];
}

class SubmitReview extends ReviewClientEvent {
  final String itemId;
  final String type;
  final int rating;
  final String comment;
  final bool isAnonymous;

  const SubmitReview({
    required this.itemId,
    required this.type,
    required this.rating,
    required this.comment,
    required this.isAnonymous,
  });

  @override
  List<Object?> get props => [itemId, type, rating, comment, isAnonymous];
}

class UpdateRating extends ReviewClientEvent {
  final int rating;

  const UpdateRating({required this.rating});

  @override
  List<Object?> get props => [rating];
}

// États
abstract class ReviewClientState extends Equatable {
  const ReviewClientState();

  @override
  List<Object?> get props => [];
}

class ReviewClientInitial extends ReviewClientState {}

class ReviewClientLoading extends ReviewClientState {}

class ReviewClientLoaded extends ReviewClientState {
  final String itemId;
  final String type;
  final bool canReview;

  const ReviewClientLoaded({
    required this.itemId,
    required this.type,
    this.canReview = true,
  });

  @override
  List<Object?> get props => [itemId, type, canReview];
}

class ReviewClientSubmitting extends ReviewClientState {}

class ReviewClientSubmitted extends ReviewClientState {
  final String message;

  const ReviewClientSubmitted({required this.message});

  @override
  List<Object?> get props => [message];
}

class ReviewClientError extends ReviewClientState {
  final String message;

  const ReviewClientError({required this.message});

  @override
  List<Object?> get props => [message];
}

// BLoC
class ReviewClientBloc extends Bloc<ReviewClientEvent, ReviewClientState> {
  ReviewClientBloc() : super(ReviewClientInitial()) {
    on<LoadReviewForm>(_onLoadReviewForm);
    on<SubmitReview>(_onSubmitReview);
    on<UpdateRating>(_onUpdateRating);
  }

  Future<void> _onLoadReviewForm(
    LoadReviewForm event,
    Emitter<ReviewClientState> emit,
  ) async {
    emit(ReviewClientLoading());
    
    try {
      // Simulation d'un délai de chargement
      await Future.delayed(const Duration(seconds: 1));
      
      // Vérifier si l'utilisateur peut laisser un avis
      // TODO: Implémenter la logique de vérification avec le backend
      bool canReview = true;
      
      emit(ReviewClientLoaded(
        itemId: event.itemId,
        type: event.type,
        canReview: canReview,
      ));
    } catch (e) {
      emit(ReviewClientError(message: 'Erreur lors du chargement du formulaire'));
    }
  }

  Future<void> _onSubmitReview(
    SubmitReview event,
    Emitter<ReviewClientState> emit,
  ) async {
    emit(ReviewClientSubmitting());
    
    try {
      // Simulation d'un délai de soumission
      await Future.delayed(const Duration(seconds: 2));
      
      // TODO: Implémenter la soumission avec le backend
      print('Avis soumis:');
      print('- Item ID: ${event.itemId}');
      print('- Type: ${event.type}');
      print('- Rating: ${event.rating}');
      print('- Comment: ${event.comment}');
      print('- Anonymous: ${event.isAnonymous}');
      
      emit(ReviewClientSubmitted(
        message: 'Votre avis a été soumis avec succès !',
      ));
    } catch (e) {
      emit(ReviewClientError(message: 'Erreur lors de la soumission de l\'avis'));
    }
  }

  Future<void> _onUpdateRating(
    UpdateRating event,
    Emitter<ReviewClientState> emit,
  ) async {
    // Cet événement peut être utilisé pour mettre à jour l'état local
    // sans émettre de nouvel état si nécessaire
    print('Rating mis à jour: ${event.rating}');
  }
}
