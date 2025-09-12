import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/client/store_client_bloc.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';

class StoreClientPage extends StatefulWidget {
  final dynamic store; // Store object passed from navigation

  StoreClientPage({super.key, required this.store});

  @override
  State<StoreClientPage> createState() => _StoreClientPageState();
}

class _StoreClientPageState extends State<StoreClientPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    context
        .read<StoreClientBloc>()
        .add(LoadStoreDetails(storeId: widget.store.id));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: BlocBuilder<StoreClientBloc, StoreClientState>(
          builder: (context, state) {
            if (state is StoreClientLoading) {
              return Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                // AppBar avec image de fond
                _buildSliverAppBar(),

                // Informations de la boutique
                _buildStoreInfo(state),

                // Onglets
                _buildTabBar(),

                // Contenu des onglets
                _buildTabContent(state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: context.height * 0.35,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              widget.store.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  child: Icon(
                    Icons.store,
                    size: 100,
                    color: Colors.white,
                  ),
                );
              },
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // Informations de la boutique sur l'image
            Positioned(
              bottom: context.mediumText,
              left: context.mediumText,
              right: context.mediumText,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: widget.store.name,
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: context.mediumText,
                      ),
                      SizedBox(width: 4),
                      AppText(
                        text: widget.store.location,
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            _isFavorite ? Icons.favorite : Icons.favorite_border,
            color: _isFavorite ? Colors.red : Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
            context.read<StoreClientBloc>().add(
                  ToggleFavorite(storeId: widget.store.id),
                );
          },
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.white),
          onPressed: () {
            // TODO: Implémenter le partage
          },
        ),
      ],
    );
  }

  Widget _buildStoreInfo(StoreClientState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(context.mediumText),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Note et statistiques
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
                SizedBox(width: 4),
                AppText(
                  text: state is StoreClientLoaded ? 
                      '${state.averageRating.toStringAsFixed(1)}' : 
                      '${widget.store.rating ?? 0.0}',
                  fontSize: context.mediumText,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(width: 8),
                AppText(
                  text:
                      '(${state is StoreClientLoaded ? state.reviewCount : 0} avis)',
                  color: Colors.grey,
                ),
                Spacer(),
                if (state is StoreClientLoaded)
                  AppText(
                    text: '${state.productCount} produits',
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
              ],
            ),

            SizedBox(height: context.mediumText),

            // Description
            AppText(
              text: 'Description',
              fontSize: context.mediumText * 1.1,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: 8),
            AppText(
              text: state is StoreClientLoaded && state.store?.storeDescription != null
                  ? state.store!.storeDescription!
                  : widget.store.description ?? 'Aucune description disponible',
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            ),

            SizedBox(height: context.mediumText),

            // Informations de contact
            _buildContactInfo(),

            SizedBox(height: context.mediumText),

            // Bouton contacter
            SizedBox(
              width: double.infinity,
              child: AppButton(
                onTap: () {
                  // Navigation vers le chat
                  Navigator.pushNamed(context, AppRoutes.CHAT,
                      arguments: widget.store);
                },
                height: context.height * 0.07,
                color: AppColors.primaryColor,
                child: AppText(
                  text: 'Contacter la boutique',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return BlocBuilder<StoreClientBloc, StoreClientState>(
      builder: (context, state) {
        String? phone = '';
        String? email = '';
        String? address = '';
        String? workingHours = '';

        if (state is StoreClientLoaded) {
          // Récupérer le téléphone depuis mobileMoney ou sellerUser
          if (state.sellerUser?.authIdentifier != null && 
              !state.sellerUser!.authIdentifier!.contains('@')) {
            phone = state.sellerUser!.authIdentifier!;
          }
          
          // Récupérer l'email depuis authIdentifier si c'est un email
          if (state.sellerUser?.authIdentifier != null && 
              state.sellerUser!.authIdentifier!.contains('@')) {
            email = state.sellerUser!.authIdentifier!;
          }
          
          // Récupérer l'adresse
          address = state.store?.storeAddress ?? 
                    state.sellerUser?.currentAddress ?? 
                    'Adresse non disponible';
          
          // Récupérer les heures d'ouverture
          if (state.store?.joursOuverture != null && 
              state.store!.joursOuverture!.isNotEmpty) {
            workingHours = state.store!.joursOuverture!.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
          } else {
            workingHours = 'Horaires non disponibles';
          }
        }

        return Container(
          padding: EdgeInsets.all(context.mediumText),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                text: 'Informations de contact',
                fontSize: context.mediumText,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 12),
              if (phone.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primaryColor, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: AppText(text: phone)),
                  ],
                ),
              if (phone.isNotEmpty) SizedBox(height: 8),
              if (email.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.email, color: AppColors.primaryColor, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: AppText(text: email)),
                  ],
                ),
              if (email.isNotEmpty) SizedBox(height: 8),
              if (address.isNotEmpty)
                Row(
                  children: [
                    Icon(Icons.location_on, color: AppColors.primaryColor, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: AppText(text: address)),
                  ],
                ),
              if (address.isNotEmpty) SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, color: AppColors.primaryColor, size: 20),
                  SizedBox(width: 8),
                  Expanded(child: AppText(text: workingHours)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: AppColors.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primaryColor,
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(text: 'Produits'),
            Tab(text: 'Avis'),
            Tab(text: 'À propos'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(StoreClientState state) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(state),
          _buildReviewsTab(state),
          _buildAboutTab(state),
        ],
      ),
    );
  }

  Widget _buildProductsTab(StoreClientState state) {
    if (state is StoreClientLoaded) {
      // Utiliser les vrais produits de la boutique
      final productsToShow = state.realProducts.isNotEmpty ? 
          state.realProducts : state.products;
      
      if (productsToShow.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 64,
                color: Colors.grey.shade400,
              ),
              SizedBox(height: 16),
              AppText(
                text: 'Aucun produit disponible',
                color: Colors.grey.shade600,
              ),
              SizedBox(height: 8),
              AppText(
                text: 'Cette boutique n\'a pas encore de produits',
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: EdgeInsets.all(context.mediumText),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 4,
          mainAxisSpacing: 0,
        ),
        itemCount: productsToShow.length,
        itemBuilder: (context, index) {
          final product = productsToShow[index];
          return _buildProductCard(product);
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          AppText(text: 'Chargement des produits...'),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    // Gérer les deux types de produits (Produit réel ou Product mocké)
    String productName = '';
    String productImage = '';
    double productPrice = 0.0;
    
    if (product.runtimeType.toString() == 'Produit') {
      // Produit réel
      productName = product.productName ?? 'Produit sans nom';
      productImage = product.productImagesPath.isNotEmpty ? product.productImagesPath.first : '';
      productPrice = product.promoPrice ?? product.productUnitPrice ?? 0.0;
    } else {
      // Product mocké
      productName = product.name ?? 'Produit sans nom';
      productImage = product.imageUrl ?? '';
      productPrice = product.price ?? 0.0;
    }

    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                image: productImage.isNotEmpty ? DecorationImage(
                  image: NetworkImage(productImage),
                  fit: BoxFit.cover,
                ) : null,
                color: productImage.isEmpty ? Colors.grey.shade200 : null,
              ),
              child: productImage.isEmpty ? 
                Icon(Icons.image_not_supported, size: 50, color: Colors.grey) : 
                null,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: productName,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    text: '${productPrice.toInt()} FCFA',
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onTap: () {
                        // Navigation vers les détails du produit
                        Navigator.pushNamed(
                          context, 
                          AppRoutes.PRODUCTDETAILS, 
                          arguments: product,
                        );
                      },
                      color: AppColors.primaryColor,
                      height: context.height * 0.042,
                      child: AppText(
                        text: 'Voir détails',
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

  Widget _buildReviewsTab(StoreClientState state) {
    if (state is StoreClientLoaded) {
      if (state.reviews.isEmpty) {
        return Center(
          child: AppText(text: 'Aucun avis pour le moment'),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.all(context.mediumText),
        itemCount: state.reviews.length,
        itemBuilder: (context, index) {
          final review = state.reviews[index];
          return Card(
            margin: EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: EdgeInsets.all(context.mediumText),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(review.userImage),
                        radius: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: review.userName,
                              fontWeight: FontWeight.bold,
                            ),
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  Icons.star,
                                  size: context.mediumText,
                                  color: index < review.rating
                                      ? AppColors.orangeColor
                                      : Colors.grey.shade300,
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      AppText(
                        text: review.date,
                        color: Colors.grey,
                        fontSize: context.smallText,
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  AppText(text: review.comment),
                ],
              ),
            ),
          );
        },
      );
    }

    return Center(
      child: AppText(text: 'Chargement des avis...'),
    );
  }

  Widget _buildAboutTab(StoreClientState state) {
    return Padding(
      padding: EdgeInsets.all(context.mediumText),
      child: ListView(
        children: [
          AppText(
            text: 'À propos de ${widget.store.name}',
            fontSize: context.mediumText * 1.1,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: context.mediumText),
          
          // Description de la boutique
          if (state is StoreClientLoaded && state.store?.storeDescription != null)
            AppText(
              text: state.store!.storeDescription!,
              color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            )
          else
            AppText(
              text: widget.store.description ?? 'Aucune description disponible',
              color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            ),
          
          SizedBox(height: 24),
          AppText(
            text: 'Informations supplémentaires',
            fontSize: context.mediumText,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 12),
          
          // Informations dynamiques basées sur les vraies données
          if (state is StoreClientLoaded) ...[
            if (state.store?.storeSectors != null && state.store!.storeSectors!.isNotEmpty)
              _buildInfoRow('Secteurs', state.store!.storeSectors!.join(', ')),
            if (state.store?.ville != null)
              _buildInfoRow('Ville', state.store!.ville!),
            if (state.store?.pays != null)
              _buildInfoRow('Pays', state.store!.pays!),
            if (state.store?.zoneLivraison != null)
              _buildInfoRow('Zone de livraison', state.store!.zoneLivraison!),
            if (state.store?.tempsLivraison != null)
              _buildInfoRow('Temps de livraison', state.store!.tempsLivraison!),
            if (state.seller?.documentsVerified != null)
              _buildInfoRow('Documents vérifiés', state.seller!.documentsVerified! ? 'Oui' : 'Non'),
            if (state.sellerUser?.createdAt != null)
              _buildInfoRow('Membre depuis', 
                  '${state.sellerUser!.createdAt!.year}-${state.sellerUser!.createdAt!.month.toString().padLeft(2, '0')}'),
          ] else ...[
            // Informations par défaut si pas de données
            _buildInfoRow('Statut', 'Boutique active'),
            _buildInfoRow('Zone de livraison', 'Information non disponible'),
            _buildInfoRow('Moyens de paiement', 'Espèces, Mobile Money'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AppText(
            text: '$label : ',
            fontWeight: FontWeight.w500,
            fontSize: context.smallText * 1.2,
          ),
          Expanded(
            child: AppText(
              text: value,
              overflow: TextOverflow.visible,
              fontSize: context.smallText * 1.2,
              maxLine: 2,
              color:
                  Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
