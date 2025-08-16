import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/client/review_client_bloc.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_textField.dart';
import '../../colors/app_colors.dart';
import '../../../constants/routes.dart';

class ReviewClientPage extends StatefulWidget {
  final dynamic item; // Product or Store object passed from navigation
  final String type; // 'product' or 'store'

  const ReviewClientPage({
    super.key,
    required this.item,
    required this.type,
  });

  @override
  State<ReviewClientPage> createState() => _ReviewClientPageState();
}

class _ReviewClientPageState extends State<ReviewClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  int _rating = 5;
  bool _isAnonymous = false;

  @override
  void initState() {
    super.initState();
    context.read<ReviewClientBloc>().add(LoadReviewForm(
          itemId: widget.item.id,
          type: widget.type,
        ));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text:
              'Laisser un avis sur ${widget.type == 'product' ? 'le produit' : 'la boutique'}',
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<ReviewClientBloc, ReviewClientState>(
        builder: (context, state) {
          if (state is ReviewClientLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ReviewClientLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Informations sur l'item
                    _buildItemInfo(),

                    const SizedBox(height: 24),

                    // Note
                    _buildRatingSection(),

                    const SizedBox(height: 24),

                    // Commentaire
                    _buildCommentSection(),

                    const SizedBox(height: 24),

                    // Options
                    _buildOptionsSection(),

                    const SizedBox(height: 32),

                    // Bouton soumettre
                    _buildSubmitButton(),
                  ],
                ),
              ),
            );
          }

          if (state is ReviewClientError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: state.message,
                    color: Colors.grey.shade600,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    onTap: () {
                      context.read<ReviewClientBloc>().add(LoadReviewForm(
                            itemId: widget.item.id,
                            type: widget.type,
                          ));
                    },
                    color: AppColors.primaryColor,
                    child: AppText(
                      text: 'Réessayer',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ReviewClientSubmitted) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 100,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  AppText(
                    text: 'Avis soumis avec succès !',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 12),
                  AppText(
                    text:
                        'Merci pour votre avis. Il sera visible après modération.',
                    color: Colors.grey.shade600,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    color: AppColors.primaryColor,
                    child: AppText(
                      text: 'Retour',
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: AppText(text: 'Chargement...'),
          );
        },
      ),
    );
  }

  Widget _buildItemInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                widget.item.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: Icon(
                      widget.type == 'product' ? Icons.image : Icons.store,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: widget.item.name,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  const SizedBox(height: 4),
                  if (widget.type == 'product') ...[
                    AppText(
                      text: '${widget.item.price} FCFA',
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ] else ...[
                    AppText(
                      text: widget.item.location,
                      color: Colors.grey.shade600,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.yellowColor,
                        size: 16,
                      ),
                      AppText(
                        text: ' ${widget.item.rating ?? 0}',
                        fontSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Votre note',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: AppColors.yellowColor,
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),
            Center(
              child: AppText(
                text: _getRatingText(_rating),
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Votre commentaire',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: _commentController,
              label: 'Partagez votre expérience...',
              maxLines: 5,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Le commentaire est requis';
                }
                if (value.trim().length < 10) {
                  return 'Le commentaire doit contenir au moins 10 caractères';
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            AppText(
              text: '${_commentController.text.length}/500 caractères',
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              text: 'Options',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const AppText(text: 'Avis anonyme'),
              subtitle: const AppText(
                text: 'Votre nom ne sera pas affiché avec cet avis',
                fontSize: 12,
                color: Colors.grey,
              ),
              value: _isAnonymous,
              onChanged: (value) {
                setState(() {
                  _isAnonymous = value;
                });
              },
              activeColor: AppColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: AppButton(
        onTap: () {
          if (_formKey.currentState!.validate()) {
            context.read<ReviewClientBloc>().add(
                  SubmitReview(
                    itemId: widget.item.id,
                    type: widget.type,
                    rating: _rating,
                    comment: _commentController.text.trim(),
                    isAnonymous: _isAnonymous,
                  ),
                );
          }
        },
        color: AppColors.primaryColor,
        height: 50,
        child: AppText(
          text: 'Soumettre l\'avis',
          color: Colors.white,
        ),
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Très mauvais';
      case 2:
        return 'Mauvais';
      case 3:
        return 'Moyen';
      case 4:
        return 'Bon';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
