import 'package:benin_poulet/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/client/product_client_bloc.dart';
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
  bool _isFavorite = false;
  final PageController _imageController = PageController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    context
        .read<ProductClientBloc>()
        .add(LoadProductDetails(productId: widget.product.id));
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
        body: BlocBuilder<ProductClientBloc, ProductClientState>(
          builder: (context, state) {
            if (state is ProductClientLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return CustomScrollView(
              slivers: [
                // AppBar avec images du produit
                _buildSliverAppBar(),

                // Informations du produit
                _buildProductInfo(state),

                // Sélecteur de quantité
                _buildQuantitySelector(),

                // Onglets
                _buildTabBar(),

                // Contenu des onglets
                _buildTabContent(state),
              ],
            );
          },
        ),
        bottomNavigationBar: _buildBottomBar(),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: context.height * 0.35,
      title: AppText(
        text: widget.product.name,
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
                  widget.product.imageUrl,
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
        IconButton(
          icon: CircleAvatar(
            child: Icon(
              _isFavorite ? Icons.shopping_cart : Icons.shopping_cart_outlined,
              color: _isFavorite ? AppColors.primaryColor : Colors.white,
            ),
          ),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
            /*context.read<ProductClientBloc>().add(
                    ToggleFavorite(productId: widget.product.id),
                  );*/

            context.read<ProductClientBloc>().add(
                  AddToCart(
                    product: widget.product,
                    quantity: _selectedQuantity,
                  ),
                );
          },
        ),
        IconButton(
          icon:
              const CircleAvatar(child: Icon(Icons.share, color: Colors.white)),
          onPressed: () {
            // TODO: Implémenter le partage
          },
        ),
      ],
    );
  }

  Widget _buildProductInfo(ProductClientState state) {
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
                    text: widget.product.name,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppText(
                  text: '${widget.product.price} FCFA',
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
                  text: '4.5',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 8),
                AppText(
                  text:
                      '(${state is ProductClientLoaded ? state.reviewCount : 0} avis)',
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

            // Catégorie et boutique
            Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AppText(
                    text: widget.product.category,
                    color: AppColors.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                AppText(
                  text: 'Vendu par: ${widget.product.storeName}',
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Description courte
            AppText(
              text: widget.product.description,
              color: Colors.grey.shade600,
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
                  'Total: ${(widget.product.price * _selectedQuantity).toStringAsFixed(0)} FCFA',
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

  Widget _buildTabContent(ProductClientState state) {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(),
          _buildReviewsTab(state),
          _buildDeliveryTab(),
        ],
      ),
    );
  }

  Widget _buildDescriptionTab() {
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
            text: widget.product.description,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 24),
          AppText(
            text: 'Caractéristiques',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 12),
          _buildCharacteristic('Type', widget.product.category),
          _buildCharacteristic('Poids', '1.5 kg'),
          _buildCharacteristic('Conservation', 'Réfrigéré'),
          _buildCharacteristic('Origine', 'Bénin'),
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

  Widget _buildReviewsTab(ProductClientState state) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ProductReviewWidget(
        productId: widget.product.id,
        storeId: widget.product.storeId,
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
