import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/client/favorites_client_bloc.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';
import '../../../constants/routes.dart';

class FavoritesClientPage extends StatefulWidget {
  const FavoritesClientPage({super.key});

  @override
  State<FavoritesClientPage> createState() => _FavoritesClientPageState();
}

class _FavoritesClientPageState extends State<FavoritesClientPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    context.read<FavoritesClientBloc>().add(LoadFavorites());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: 'Mes Favoris'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              _showClearFavoritesDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Onglets
          _buildTabBar(),

          // Contenu des onglets
          Expanded(
            child: BlocBuilder<FavoritesClientBloc, FavoritesClientState>(
              builder: (context, state) {
                if (state is FavoritesClientLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is FavoritesClientLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildProductsList(state.favoriteProducts),
                      _buildStoresList(state.favoriteStores),
                    ],
                  );
                }

                if (state is FavoritesClientError) {
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
                            context
                                .read<FavoritesClientBloc>()
                                .add(LoadFavorites());
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
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.primaryColor,
        tabs: const [
          Tab(text: 'Produits'),
          Tab(text: 'Boutiques'),
        ],
      ),
    );
  }

  Widget _buildProductsList(List<dynamic> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            AppText(
              text: 'Aucun produit favori',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 12),
            AppText(
              text: 'Ajoutez des produits à vos favoris pour les retrouver ici',
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 32),
            AppButton(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.HOME);
              },
              color: AppColors.primaryColor,
              child: AppText(
                text: 'Découvrir des produits',
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(product.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      context.read<FavoritesClientBloc>().add(
                            RemoveFromFavorites(
                              itemId: product.id,
                              type: 'product',
                            ),
                          );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: product.name,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: '${product.price} FCFA',
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onTap: () {
                        context.read<FavoritesClientBloc>().add(
                              AddToCart(product: product),
                            );
                      },
                      color: AppColors.primaryColor,
                      height: 32,
                      child: AppText(
                        text: 'Ajouter au panier',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoresList(List<dynamic> stores) {
    if (stores.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.store_outlined,
              size: 100,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 24),
            AppText(
              text: 'Aucune boutique favorite',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
            const SizedBox(height: 12),
            AppText(
              text:
                  'Ajoutez des boutiques à vos favoris pour les retrouver ici',
              color: Colors.grey.shade500,
            ),
            const SizedBox(height: 32),
            AppButton(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.HOME);
              },
              color: AppColors.primaryColor,
              child: AppText(
                text: 'Découvrir des boutiques',
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return _buildStoreCard(store);
      },
    );
  }

  Widget _buildStoreCard(dynamic store) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                store.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.store, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: store.name,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: store.location,
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: AppColors.yellowColor,
                        size: 16,
                      ),
                      AppText(
                        text: ' ${store.rating}',
                        fontSize: 12,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          context.read<FavoritesClientBloc>().add(
                                RemoveFromFavorites(
                                  itemId: store.id,
                                  type: 'store',
                                ),
                              );
                        },
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                AppButton(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.STOREDETAILS,
                        arguments: store);
                  },
                  color: AppColors.primaryColor,
                  height: 32,
                  child: AppText(
                    text: 'Voir',
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                AppButton(
                  onTap: () {
                    Navigator.pushNamed(context, AppRoutes.CHAT, arguments: store);
                  },
                  color: AppColors.secondaryColor,
                  height: 32,
                  child: AppText(
                    text: 'Contacter',
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showClearFavoritesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const AppText(text: 'Vider les favoris'),
        content: const AppText(
          text: 'Êtes-vous sûr de vouloir supprimer tous vos favoris ?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText(text: 'Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<FavoritesClientBloc>().add(ClearFavorites());
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
