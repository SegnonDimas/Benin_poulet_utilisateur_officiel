import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/client/cart_client_bloc.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';
import '../../../constants/routes.dart';

class CartClientPage extends StatefulWidget {
  const CartClientPage({super.key});

  @override
  State<CartClientPage> createState() => _CartClientPageState();
}

class _CartClientPageState extends State<CartClientPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartClientBloc>().add(LoadCart());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Mon Panier'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearCartDialog();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartClientBloc, CartClientState>(
        builder: (context, state) {
          if (state is CartClientLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartClientLoaded) {
            if (state.cartItems.isEmpty) {
              return _buildEmptyCart();
            }

            return Column(
              children: [
                // Liste des produits
                Expanded(
                  child: _buildCartItemsList(state),
                ),

                // Résumé et bouton de commande
                _buildCartSummary(state),
              ],
            );
          }

          if (state is CartClientError) {
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
                    child: AppText(
                      text: 'Réessayer',
                      color: Colors.white,
                    ),
                    onTap: () {
                      context.read<CartClientBloc>().add(LoadCart());
                    },
                    color: AppColors.primaryColor,
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

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          AppText(
            text: 'Votre panier est vide',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 12),
          AppText(
            text: 'Ajoutez des produits pour commencer vos achats',
            color: Colors.grey.shade500,
          ),
          const SizedBox(height: 32),
          AppButton(
            child: AppText(
              text: 'Découvrir nos produits',
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.HOME);
            },
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsList(CartClientLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.cartItems.length,
      itemBuilder: (context, index) {
        final cartItem = state.cartItems[index];
        return _buildCartItemCard(cartItem);
      },
    );
  }

  Widget _buildCartItemCard(CartItem cartItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Image du produit
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                cartItem.product.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image, color: Colors.grey),
                  );
                },
              ),
            ),

            const SizedBox(width: 12),

            // Informations du produit
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: cartItem.product.name,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: '${cartItem.product.price} FCFA',
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),

                  // Contrôles de quantité
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (cartItem.quantity > 1) {
                                  context.read<CartClientBloc>().add(
                                        UpdateQuantity(
                                          productId: cartItem.product.id,
                                          quantity: cartItem.quantity - 1,
                                        ),
                                      );
                                }
                              },
                            ),
                            Container(
                              width: 30,
                              alignment: Alignment.center,
                              child: AppText(
                                text: '${cartItem.quantity}',
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                context.read<CartClientBloc>().add(
                                      UpdateQuantity(
                                        productId: cartItem.product.id,
                                        quantity: cartItem.quantity + 1,
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      AppText(
                        text:
                            '${(cartItem.product.price * cartItem.quantity).toStringAsFixed(0)} FCFA',
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bouton supprimer
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                _showRemoveItemDialog(cartItem);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartClientLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Résumé des coûts
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(text: 'Sous-total'),
              AppText(
                text: '${state.subtotal.toStringAsFixed(0)} FCFA',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(text: 'Livraison'),
              AppText(
                text: '${state.shippingCost.toStringAsFixed(0)} FCFA',
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          if (state.discount > 0) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(text: 'Réduction'),
                AppText(
                  text: '-${state.discount.toStringAsFixed(0)} FCFA',
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ],
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                text: 'Total',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              AppText(
                text: '${state.total.toStringAsFixed(0)} FCFA',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Bouton passer commande
          SizedBox(
            width: double.infinity,
            child: AppButton(
              child: AppText(
                text:
                    'Passer la commande (${state.cartItems.length} article${state.cartItems.length > 1 ? 's' : ''})',
                color: Colors.white,
              ),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.CHECKOUT);
              },
              color: AppColors.primaryColor,
              height: 50,
            ),
          ),

          const SizedBox(height: 8),

          // Lien continuer les achats
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.HOME);
            },
            child: AppText(
              text: 'Continuer les achats',
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveItemDialog(CartItem cartItem) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Supprimer l\'article'),
        content: AppText(
          text:
              'Êtes-vous sûr de vouloir supprimer "${cartItem.product.name}" de votre panier ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(text: 'Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartClientBloc>().add(
                    RemoveFromCart(productId: cartItem.product.id),
                  );
            },
            child: AppText(
              text: 'Supprimer',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearCartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Vider le panier'),
        content: const AppText(
          text: 'Êtes-vous sûr de vouloir vider complètement votre panier ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(text: 'Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<CartClientBloc>().add(ClearCart());
            },
            child: AppText(
              text: 'Vider',
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
