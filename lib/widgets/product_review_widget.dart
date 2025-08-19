import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/bloc/product_review/product_review_bloc.dart';
import 'package:benin_poulet/models/product_review.dart';
import 'package:intl/intl.dart';

class ProductReviewWidget extends StatefulWidget {
  final String productId;
  final String storeId;
  final String userId;

  const ProductReviewWidget({
    Key? key,
    required this.productId,
    required this.storeId,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProductReviewWidget> createState() => _ProductReviewWidgetState();
}

class _ProductReviewWidgetState extends State<ProductReviewWidget> {
  final TextEditingController _messageController = TextEditingController();
  int _selectedStars = 5;
  bool _hasUserReviewed = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductReviewBloc>().add(LoadProductReviews(widget.productId));
    context.read<ProductReviewBloc>().add(CheckUserProductReview(widget.userId, widget.productId));
    context.read<ProductReviewBloc>().add(GetProductRatingStats(widget.productId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductReviewBloc, ProductReviewState>(
      listener: (context, state) {
        if (state is ProductReviewAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Avis ajouté avec succès!')),
          );
          _messageController.clear();
          setState(() {
            _selectedStars = 5;
            _hasUserReviewed = true;
          });
        } else if (state is ProductReviewError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is UserProductReviewStatus) {
          setState(() {
            _hasUserReviewed = state.hasReviewed;
          });
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Statistiques des avis
          BlocBuilder<ProductReviewBloc, ProductReviewState>(
            builder: (context, state) {
              if (state is ProductRatingStats) {
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
                        hintText: 'Partagez votre expérience avec ce produit...',
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
                                context.read<ProductReviewBloc>().add(
                                  AddProductReview(
                                    userId: widget.userId,
                                    productId: widget.productId,
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
          BlocBuilder<ProductReviewBloc, ProductReviewState>(
            builder: (context, state) {
              if (state is ProductReviewLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductReviewLoaded) {
                if (state.reviews.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Aucun avis pour ce produit',
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
              } else if (state is ProductReviewError) {
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

  Widget _buildReviewCard(ProductReview review) {
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
