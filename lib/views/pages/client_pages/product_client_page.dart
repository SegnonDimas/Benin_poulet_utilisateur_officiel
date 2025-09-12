import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/client/cart_client_bloc.dart' as cart_bloc;
import '../../../bloc/client/home_client_bloc.dart';
import '../../../constants/routes.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/product_review_widget.dart';
import '../../colors/app_colors.dart';

class ProductClientPage extends StatefulWidget {
  final dynamic product; // Product object passed from navigation

  const ProductClientPage({super.key, required this.product});

  @override
  State<ProductClientPage> createState() => _ProductClientPageState();
}

class _ProductClientPageState extends State<ProductClientPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedQuantity = 1;
  final PageController _imageController = PageController();

  // Propriétés communes pour gérer les deux types de produits
  String get _productId {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.productId ?? '';
    } else {
      return widget.product.id ?? '';
    }
  }

  String get _productName {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.productName ?? 'Produit sans nom';
    } else {
      return widget.product.name ?? 'Produit sans nom';
    }
  }

  String get _productImage {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.productImagesPath.isNotEmpty
          ? widget.product.productImagesPath.first
          : '';
    } else {
      return widget.product.imageUrl ?? '';
    }
  }

  double get _productPrice {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.promoPrice ??
          widget.product.productUnitPrice ??
          0.0;
    } else {
      return widget.product.price ?? 0.0;
    }
  }

  String get _productDescription {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.productDescription ?? '';
    } else {
      return widget.product.description ?? '';
    }
  }

  String get _productCategory {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.category ?? '';
    } else {
      return widget.product.category ?? '';
    }
  }

  // Propriétés pour les caractéristiques du produit
  Map<String, String> get _productProperties {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.productProperties ?? {};
    } else {
      return widget.product.productProperties ??
          {}; // Le modèle Product a maintenant des propriétés
    }
  }

  // Variétés du produit
  List<String> get _productVarieties {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return widget.product.varieties ?? [];
    } else {
      return widget.product.varieties ??
          []; // Le modèle Product a maintenant des variétés
    }
  }

  // Propriétés pour la boutique
  String get _storeName {
    if (widget.product.runtimeType.toString() == 'Produit') {
      return 'Boutique'; // Nous devrons récupérer le nom depuis la base de données
    } else {
      return widget.product.storeName ?? 'Boutique';
    }
  }

  // Propriétés pour les avis (temporairement statiques)
  double get _productRating => 4.5; // TODO: Récupérer depuis la base de données
  int get _reviewCount => 0; // TODO: Récupérer depuis la base de données

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    // Plus besoin de charger les détails via ProductClientBloc
    // car nous avons déjà toutes les informations du produit
  }

  @override
  void dispose() {
    _tabController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            // AppBar avec images du produit
            _buildSliverAppBar(),

            // Informations du produit
            _buildProductInfo(),

            // Sélecteur de quantité
            _buildQuantitySelector(),

            // Onglets
            _buildTabBar(),

            // Contenu des onglets
            _buildTabContent(),
          ],
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: context.height * 0.35,
      title: AppText(
        text: _productName,
      ),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Images du produit
            PageView.builder(
              controller: _imageController,
              itemCount: 3, // Nombre d'images du produit
              itemBuilder: (context, index) {
                return Image.network(
                  _productImage,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      child: const Icon(
                        Icons.image,
                        size: 100,
                        color: Colors.white,
                      ),
                    );
                  },
                );
              },
            ),
            // Indicateurs d'images
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: index == 0
                          ? AppColors.primaryColor
                          : Colors.white.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      actions: [
        BlocBuilder<HomeClientBloc, HomeClientState>(
          builder: (context, homeState) {
            final isInCart = homeState is HomeClientLoaded &&
                homeState.cartProductIds.contains(_productId);

            return IconButton(
              icon: CircleAvatar(
                backgroundColor: isInCart
                    ? Theme.of(context).colorScheme.inverseSurface
                    : Theme.of(context).colorScheme.background.withOpacity(0.5),
                child: Icon(
                  isInCart
                      ? Icons.add_shopping_cart
                      : Icons.shopping_cart_outlined,
                  color: isInCart
                      ? AppColors.primaryColor
                      : Theme.of(context).colorScheme.surface,
                ),
              ),
              onPressed: () {
                if (isInCart) {
                  // Si déjà dans le panier, retirer
                  context.read<cart_bloc.CartClientBloc>().add(
                        cart_bloc.RemoveFromCart(productId: _productId),
                      );
                  AppUtils.showInfoNotification(
                      context, '${_productName} retiré du panier');
                } else {
                  // Si pas dans le panier, ajouter
                  context.read<cart_bloc.CartClientBloc>().add(
                        cart_bloc.AddToCart(
                          productId: _productId,
                          quantity: _selectedQuantity,
                        ),
                      );
                  AppUtils.showSuccessNotification(
                      context, '${_productName} ajouté au panier');
                }
                // Recharger l'état du panier dans HomeClientBloc
                context.read<HomeClientBloc>().add(LoadCartStatus());
              },
            );
          },
        ),
        IconButton(
          icon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.background,
              child: Icon(Icons.share, color: Colors.white)),
          onPressed: () {
            // TODO: Implémenter le partage
          },
        ),
      ],
    );
  }

  Widget _buildProductInfo() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nom et prix
            Row(
              children: [
                Expanded(
                  child: AppText(
                    text: _productName,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppText(
                  text: '${_productPrice.toInt()} FCFA',
                  fontSize: 20,
                  color: AppColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Note et avis
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.orangeColor,
                  size: 20,
                ),
                const SizedBox(width: 4),
                AppText(
                  text: _productRating.toString(),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 8),
                AppText(
                  text: '($_reviewCount avis)',
                  color: Colors.grey,
                ),
                const Spacer(),
                AppText(
                  text: 'En stock',
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (_productVarieties.isNotEmpty) ...[
              AppText(
                text: 'Variétés disponibles',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _productVarieties
                    .map((variety) => Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primaryColor.withOpacity(0.3)),
                          ),
                          child: AppText(
                            text: variety,
                            color: AppColors.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 24),
            ],

            // Catégorie et boutique
            /*Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    text: _productCategory,
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigation vers la page de la boutique
                      // Pour l'instant, on ne peut pas naviguer car nous n'avons pas l'objet Store complet
                      // TODO: Récupérer les informations complètes de la boutique
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Navigation vers la boutique en cours de développement'),
                          backgroundColor: AppColors.orangeColor,
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Vendu par: ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: "PoppinsMedium",
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: _storeName,
                            style: TextStyle(
                              color: AppColors.orangeColor,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'PoppinsMedium',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),*/

            const SizedBox(height: 16),

            // Description courte
            AppText(
              text: _productDescription,
              color: Colors.grey.shade600,
              fontSize: context.smallText * 1.3,
              //overflow: TextOverflow.visible,
              maxLine: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuantitySelector() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: 'Quantité :',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          if (_selectedQuantity > 1) {
                            setState(() {
                              _selectedQuantity--;
                            });
                          }
                        },
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: AppText(
                          text: '$_selectedQuantity',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _selectedQuantity++;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppText(
              text:
                  'Total: ${(_productPrice * _selectedQuantity).toStringAsFixed(0)} FCFA',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ],
        ),
      ),
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
          tabs: const [
            Tab(text: 'Description'),
            Tab(text: 'Avis'),
            Tab(text: 'Livraison'),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(),
          _buildReviewsTab(),
          _buildDeliveryTab(),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
    // Debug: afficher les propriétés disponibles
    print('=== DEBUG PRODUIT ===');
    print('Type de produit: ${widget.product.runtimeType}');
    print('Propriétés du produit: $_productProperties');
    print('Nombre de propriétés: ${_productProperties.length}');
    print('Variétés du produit: $_productVarieties');
    print('Nombre de variétés: ${_productVarieties.length}');
    print('====================');

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Description détaillée',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          AppText(
            text: _productDescription,
            color: Colors.grey.shade600,
            overflow: TextOverflow.visible,
          ),
          const SizedBox(height: 24),

          // Variétés disponibles
          if (_productVarieties.isNotEmpty) ...[
            AppText(
              text: 'Variétés disponibles',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _productVarieties
                  .map((variety) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.primaryColor.withOpacity(0.3)),
                        ),
                        child: AppText(
                          text: variety,
                          color: AppColors.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Caractéristiques
          AppText(
            text: 'Caractéristiques',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          _buildCharacteristic('Type', _productCategory),
          // Afficher les propriétés dynamiques du produit si disponibles
          if (_productProperties.isNotEmpty)
            ..._productProperties.entries
                .map((entry) => _buildCharacteristic(entry.key, entry.value))
          else
            AppText(
              text: 'Aucune caractéristique supplémentaire disponible',
              color: Colors.grey.shade500,
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
        ],
      ),
    );
  }

  Widget _buildCharacteristic(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          AppText(
            text: '$label: ',
            fontWeight: FontWeight.w500,
          ),
          AppText(
            text: value,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProductReviewWidget(
        productId: _productId,
        storeId: widget.product.runtimeType.toString() == 'Produit'
            ? widget.product.storeId
            : 'unknown',
        userId: FirebaseAuth.instance.currentUser?.uid ??
            'unknow', // À remplacer par l'ID réel de l'utilisateur
      ),
    );
  }

  Widget _buildDeliveryTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: 'Options de livraison',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 16),
          _buildDeliveryOption(
            'Livraison standard',
            '2-3 jours ouvrables',
            '500 FCFA',
            true,
          ),
          GestureDetector(
            onTap: () {
              AppUtils.showInfoDialog(
                  context: context,
                  message: "Cette fonctionnalité arrive bientôt");
            },
            child: _buildDeliveryOption(
              'Livraison express',
              '1 jour ouvrable',
              '1000 FCFA',
              false,
            ),
          ),
          GestureDetector(
            onTap: () {
              AppUtils.showInfoDialog(
                  context: context,
                  message: "Cette fonctionnalité arrive bientôt");
            },
            child: _buildDeliveryOption(
              'Point relais',
              '3-5 jours ouvrables',
              '300 FCFA',
              false,
            ),
          ),
          const SizedBox(height: 24),
          AppText(
            text: 'Informations importantes',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          _buildInfoItem('• Livraison gratuite à partir de 10 000 FCFA'),
          _buildInfoItem('• Paiement à la livraison disponible'),
          _buildInfoItem('• Retour gratuit sous 7 jours'),
        ],
      ),
    );
  }

  Widget _buildDeliveryOption(
      String title, String duration, String price, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? AppColors.primaryColor.withOpacity(0.05) : null,
      ),
      child: Row(
        children: [
          Radio<bool>(
            value: true,
            groupValue: isSelected,
            onChanged: (value) {
              // TODO: Implémenter la sélection de livraison
            },
            activeColor: AppColors.primaryColor,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: title,
                  fontWeight: FontWeight.bold,
                ),
                AppText(
                  text: duration,
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          AppText(
            text: price,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: AppText(
        text: text,
        color: Colors.grey.shade600,
        fontSize: 14,
      ),
    );
  }

  Widget _buildBottomBar() {
    return AppButton(
      height: context.height * 0.065,
      onTap: () {
        // Navigation vers la page de commande
        Navigator.pushNamed(context, AppRoutes.CHECKOUT, arguments: {
          'product': widget.product,
          'quantity': _selectedQuantity,
        });
      },
      color: AppColors.secondaryColor,
      child: AppText(
        text: 'Acheter maintenant',
        color: Colors.white,
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
