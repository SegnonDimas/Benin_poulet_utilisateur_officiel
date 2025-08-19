import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/bloc/store_review/store_review_bloc.dart';
import 'package:benin_poulet/models/store_review.dart';
import 'package:intl/intl.dart';

class StoreReviewWidget extends StatefulWidget {
  final String storeId;
  final String userId;

  const StoreReviewWidget({
    Key? key,
    required this.storeId,
    required this.userId,
  }) : super(key: key);

  @override
  State<StoreReviewWidget> createState() => _StoreReviewWidgetState();
}

class _StoreReviewWidgetState extends State<StoreReviewWidget> {
  final TextEditingController _messageController = TextEditingController();
  int _selectedStars = 5;
  bool _hasUserReviewed = false;

  @override
  void initState() {
    super.initState();
    context.read<StoreReviewBloc>().add(LoadStoreReviews(widget.storeId));
    context.read<StoreReviewBloc>().add(CheckUserReview(widget.userId, widget.storeId));
    context.read<StoreReviewBloc>().add(GetStoreRatingStats(widget.storeId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StoreReviewBloc, StoreReviewState>(
      listener: (context, state) {
        if (state is StoreReviewAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avis ajouté avec succès!')),
          );
          _messageController.clear();
          setState(() {
            _selectedStars = 5;
            _hasUserReviewed = true;
          });
        } else if (state is StoreReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserReviewStatus) {
          setState(() {
            _hasUserReviewed = state.hasReviewed;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistiques des avis
          BlocBuilder<StoreReviewBloc, StoreReviewState>(
            builder: (context, state) {
              if (state is StoreRatingStats) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              state.averageRating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < state.averageRating.floor()
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.reviewCount} avis',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Note moyenne',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          
          const SizedBox(height: 16),
          
          // Formulaire d'ajout d'avis
          if (!_hasUserReviewed) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ajouter un avis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Sélection des étoiles
                    Row(
                      children: [
                        const Text('Note: '),
                        ...List.generate(5, (index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedStars = index + 1;
                              });
                            },
                            child: Icon(
                              index < _selectedStars ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 30,
                            ),
                          );
                        }),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Champ de message
                    TextField(
                      controller: _messageController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Votre avis',
                        border: OutlineInputBorder(),
                        hintText: 'Partagez votre expérience...',
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Bouton de soumission
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _messageController.text.trim().isEmpty
                            ? null
                            : () {
                                context.read<StoreReviewBloc>().add(
                                  AddStoreReview(
                                    userId: widget.userId,
                                    storeId: widget.storeId,
                                    stars: _selectedStars,
                                    message: _messageController.text.trim(),
                                  ),
                                );
                              },
                        child: const Text('Publier l\'avis'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          // Liste des avis
          BlocBuilder<StoreReviewBloc, StoreReviewState>(
            builder: (context, state) {
              if (state is StoreReviewLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is StoreReviewLoaded) {
                if (state.reviews.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Aucun avis pour le moment',
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  );
                }
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Avis (${state.reviews.length})',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...state.reviews.map((review) => _buildReviewCard(review)),
                  ],
                );
              } else if (state is StoreReviewError) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Erreur: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
              
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(StoreReview review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Étoiles
                ...List.generate(5, (index) {
                  return Icon(
                    index < review.stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  );
                }),
                const Spacer(),
                // Date
                Text(
                  DateFormat('dd/MM/yyyy').format(review.date),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              review.message,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
