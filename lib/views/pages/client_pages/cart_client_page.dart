import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/context_extensions.dart';

import '../../../bloc/client/cart_client_bloc.dart';
import '../../../bloc/client/home_client_bloc.dart';
import '../../../constants/routes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';

class CartClientPage extends StatefulWidget {
  const CartClientPage({super.key});

  @override
  State<CartClientPage> createState() => _CartClientPageState();
}

class _CartClientPageState extends State<CartClientPage> {
  @override
  void initState() {
    super.initState();
    // Charger le panier et les produits
    context.read<CartClientBloc>().add(LoadCart());

    // Essayer de charger les produits immédiatement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCartProducts();
    });

    // Essayer aussi après un délai pour s'assurer que tout est chargé
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        _loadCartProducts();
      }
    });
  }

  void _loadCartProducts() {
    final homeState = context.read<HomeClientBloc>().state;
    if (homeState is HomeClientLoaded) {
      context
          .read<CartClientBloc>()
          .add(LoadCartProducts(allProducts: homeState.products));
    } else {
      // Si les données ne sont pas encore chargées, attendre un peu et réessayer
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          _loadCartProducts();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const AppText(text: 'Mon Panier'),
          centerTitle: true,
          actions: [
            /*IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                _reloadCart();
              },
            ),*/
            IconButton(
              icon: AppButton(
                width: context.width * 0.17,
                height: 30,
                bordeurRadius: 10,
                color: AppColors.redColor.withOpacity(0.9),
                child: AppText(
                  text: "Vider",
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: context.smallText,
                ),
              ),
              onPressed: () {
                _showClearCartDialog();
              },
            ),
          ],
        ),
        body: BlocListener<HomeClientBloc, HomeClientState>(
          listener: (context, homeState) {
            if (homeState is HomeClientLoaded) {
              // Recharger les produits du panier quand les données du home sont disponibles
              final cartState = context.read<CartClientBloc>().state;
              if (cartState is CartClientLoaded &&
                  cartState.cartProductIds.isNotEmpty) {
                context
                    .read<CartClientBloc>()
                    .add(LoadCartProducts(allProducts: homeState.products));
              }
            }
          },
          child: BlocBuilder<CartClientBloc, CartClientState>(
            builder: (context, state) {
              if (state is CartClientLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is CartClientLoaded) {
                if (state.cartProducts.isEmpty) {
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
                        onTap: () {
                          context.read<CartClientBloc>().add(LoadCart());
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

              return const Center(
                child: AppText(text: 'Chargement...'),
              );
            },
          ),
        ),
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
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
          ),
          const SizedBox(height: 24),
          AppText(
            text: 'Votre panier est vide',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
          ),
          const SizedBox(height: 12),
          AppText(
            textAlign: TextAlign.center,
            text: 'Ajoutez des produits pour commencer vos achats',
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.7),
            maxLine: 2,
          ),
          const SizedBox(height: 100),
          AppButton(
            height: context.height * 0.06,
            width: context.width * 0.8,
            bordeurRadius: 10,
            onTap: () {
              Navigator.pushReplacementNamed(context, AppRoutes.HOME);
            },
            color: AppColors.primaryColor,
            child: AppText(
              text: 'Découvrir nos produits',
              color: Colors.white,
            ),
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
      child: InkWell(
        onTap: () {
          // Navigation vers la page des détails du produit
          Navigator.pushNamed(context, AppRoutes.PRODUCTDETAILS,
              arguments: cartItem.product);
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Image du produit
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: cartItem.product.imageUrl.isNotEmpty
                    ? Image.network(
                        cartItem.product.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 80,
                            height: 80,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.1),
                            child: Icon(Icons.image,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.3)),
                          );
                        },
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                        child: Icon(Icons.image,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.3)),
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
                    // Prix avec promotion si applicable
                    if (cartItem.product.originalPrice != null)
                      Row(
                        children: [
                          AppText(
                            text:
                                '${cartItem.product.originalPrice!.toInt()} FCFA',
                            fontSize: 12,
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            text: '${cartItem.product.price.toInt()} FCFA',
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      )
                    else
                      AppText(
                        text: '${cartItem.product.price.toInt()} FCFA',
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    const SizedBox(height: 8),
                    // Contrôles de quantité
                    Row(
                      children: [
                        // Bouton diminuer
                        GestureDetector(
                          onTap: () {
                            if (cartItem.quantity > 1) {
                              context.read<CartClientBloc>().add(
                                    UpdateQuantity(
                                      productId: cartItem.product.id,
                                      quantity: cartItem.quantity - 1,
                                    ),
                                  );
                            }
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: cartItem.quantity > 1
                                  ? AppColors.primaryColor.withOpacity(0.1)
                                  : Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.remove,
                              size: 16,
                              color: cartItem.quantity > 1
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Quantité
                        AppText(
                          text: '${cartItem.quantity}',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(width: 12),
                        // Bouton augmenter
                        GestureDetector(
                          onTap: () {
                            context.read<CartClientBloc>().add(
                                  UpdateQuantity(
                                    productId: cartItem.product.id,
                                    quantity: cartItem.quantity + 1,
                                  ),
                                );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.primaryColor,
                            ),
                          ),
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
                  _showRemoveItemDialog(cartItem.product);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCartSummary(CartClientLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
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
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.CHECKOUT);
              },
              color: AppColors.primaryColor,
              height: 50,
              child: AppText(
                text:
                    'Passer la commande (${state.cartItems.length} article${state.cartItems.length > 1 ? 's' : ''})',
                color: Colors.white,
              ),
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

  void _showRemoveItemDialog(Product product) {
    AppUtils.showDialog(
      context: context,
      title: 'Supprimer l\'article',
      content:
          'Êtes-vous sûr de vouloir supprimer "${product.name}" de votre panier ?',
      cancelText: 'Annuler',
      confirmText: 'Supprimer',
      onConfirm: () {
        context.read<CartClientBloc>().add(
              RemoveFromCart(productId: product.id),
            );
        Navigator.pop(context);
      },
      onCancel: () {
        Navigator.pop(context);
      },
      confirmTextColor: AppColors.primaryColor,
      cancelTextColor: AppColors.redColor,
    );
  }

  void _showClearCartDialog() {
    AppUtils.showDialog(
      context: context,
      title: 'Vider le panier',
      content: 'Êtes-vous sûr de vouloir vider complètement votre panier ?',
      cancelText: 'Annuler',
      confirmText: 'Vider',
      onConfirm: () {
        context.read<CartClientBloc>().add(ClearCart());
        Navigator.pop(context);
      },
      onCancel: () {
        Navigator.pop(context);
      },
      confirmTextColor: AppColors.primaryColor,
      cancelTextColor: AppColors.redColor,
    );
  }
}
