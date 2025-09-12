// import 'package:benin_poulet/widgets/app_button.dart'; // Non utilisé - remplacé par GestureDetector
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/choixCategorie/secteur_bloc.dart';
import '../../../bloc/client/cart_client_bloc.dart' as cart_bloc;
import '../../../bloc/client/home_client_bloc.dart';
import '../../../constants/app_attributs.dart';
import '../../../constants/routes.dart';
import '../../../core/firebase/auth/auth_services.dart';
import '../../../models/sellerSector.dart';
import '../../../services/user_data_service.dart';
import '../../../utils/app_utils.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_textField.dart';
import '../../colors/app_colors.dart';
import '../../models_ui/model_carouselItem.dart';
// import '../../models_ui/model_recommandation.dart'; // Non utilisé pour l'instant

class HomeClientPage extends StatefulWidget {
  const HomeClientPage({super.key});

  @override
  State<HomeClientPage> createState() => _HomeClientPageState();
}

class _HomeClientPageState extends State<HomeClientPage>
    with SingleTickerProviderStateMixin {
  // carouselSliderController
  CarouselSliderController controller = CarouselSliderController();

  final List<Widget> _carouselList = const [
    ModelCarouselItem(
      imgPath: 'assets/images/pouletCouveuse.png',
      fit: BoxFit.cover,
    ),
    ModelCarouselItem(),
    ModelCarouselItem(),
  ];

  int carouselCurrentIndex = 0;
  late TabController _tabController;
  String _selectedCategory = 'Tout';

  // String _searchQuery = ''; // Utilisé dans la barre de recherche

  // Liste des secteurs pour le filtrage

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    context.read<HomeClientBloc>().add(LoadHomeData());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Méthode pour gérer la déconnexion complète
  Future<void> _handleSignOut() async {
    final navigator = Navigator.of(context);
    final currentContext = context;

    try {
      // Afficher un indicateur de chargement
      AppUtils.showInfoDialog(
        context: currentContext,
        message: 'Déconnexion en cours...',
        type: InfoType.loading,
        barrierDismissible: false,
      );

      // Effectuer la déconnexion
      await AuthServices.signOut();

      // Vérifier si le widget est toujours monté
      if (!mounted) return;

      // Fermer l'indicateur de chargement
      if (navigator.canPop()) {
        navigator.pop();
      }

      // Rediriger vers la page de connexion
      navigator.pushNamedAndRemoveUntil(AppRoutes.LOGINPAGE, (route) => false);
    } catch (e) {
      // Vérifier si le widget est toujours monté
      if (!mounted) return;

      // Fermer l'indicateur de chargement en cas d'erreur
      if (navigator.canPop()) {
        navigator.pop();
      }

      // Afficher un message d'erreur
      if (mounted) {
        AppUtils.showErrorNotification(currentContext,
            'Erreur lors de la déconnexion: ${e.toString()}', null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          final shouldPop = await AppUtils.showExitConfirmationDialog(context,
              message: 'Voulez-vous vraiment quitter l\'application ?');
          return shouldPop; // true = autorise le pop, false = bloque
        },
        child: Scaffold(
          appBar: AppBar(
            title: AppText(
                text: AppAttributes.appName,
                fontSize: context.mediumText * 1.2,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor),
            centerTitle: true,
            elevation: 0,
            iconTheme: IconThemeData(color: AppColors.primaryColor),
          ),
          drawer: _buildDrawer(),
          body:
              BlocListener<cart_bloc.CartClientBloc, cart_bloc.CartClientState>(
            listener: (context, cartState) {
              if (cartState is cart_bloc.CartClientLoaded) {
                // Mettre à jour le HomeClientBloc avec les nouveaux IDs du panier
                context.read<HomeClientBloc>().add(LoadCartStatus());
              }
            },
            child: BlocBuilder<HomeClientBloc, HomeClientState>(
              builder: (context, state) {
                if (state is HomeClientLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return NotificationListener<ScrollNotification>(
                  onNotification: (notification) {
                    if (notification is OverscrollNotification) {
                      PrimaryScrollController.of(context).jumpTo(
                        PrimaryScrollController.of(context).offset +
                            notification.overscroll / 2,
                      );
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Barre de recherche
                        _buildSearchBar(),

                        // CarouselSlier
                        _buildPubCarouselSlider(),

                        // Onglets Produits/Boutiques
                        _buildTabBar(),

                        _buildPromotionCarouselSlider(),

                        // Filtres par secteur
                        _buildCategoryFilters(),

                        // Contenu des onglets
                        _buildTabContent(state),
                        //SizedBox(height: context.height * 0.2),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.CART);
            },
            foregroundColor: Colors.white,
            backgroundColor: AppColors.primaryColor,
            child: Icon(Icons.shopping_cart),
          ),
        ));
  }

  Widget _buildPubCarouselSlider() {
    return Stack(
      alignment: Alignment.center,
      children: [
        //products images
        CarouselSlider(
            items: _carouselList,
            carouselController: controller,
            options: CarouselOptions(
                autoPlay: true,
                autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                aspectRatio: 16 / 8,
                enlargeFactor: 0.2,
                enlargeCenterPage: true,
                autoPlayInterval: Duration(milliseconds: 6000),
                viewportFraction: 0.95,
                onPageChanged: (index, CarouselPageChangedReason c) {
                  //return index;
                  setState(() {
                    carouselCurrentIndex = index;
                  });
                })),

        //dots indicator
        /* Positioned(
          bottom: 10,
          left: context.width * 0.35,
          right: context.width * 0.35,
          child: Container(
            alignment: Alignment.center,
            height: 20,
            //width: context.width * 0.25,
            decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
                borderRadius: BorderRadius.circular(20)),
            child: PageViewDotIndicator(
              currentItem: carouselCurrentIndex,
              count: _carouselList.length,
              size: const Size(8, 8),
              unselectedColor: Colors.grey.shade600,
              selectedColor: Colors.grey.shade100,
              onItemClicked: (index) {
                setState(() {
                  carouselCurrentIndex = index;
                  controller.animateToPage(carouselCurrentIndex);
                });
              },
            ),
          ),
        )*/
      ],
    );
  }

  Widget _buildPromotionCarouselSlider() {
    return BlocBuilder<HomeClientBloc, HomeClientState>(
      builder: (context, state) {
        if (state is HomeClientLoaded) {
          // Filtrer les produits en promotion
          final promotionProducts = state.products
              .where((product) => product.isInPromotion)
              .take(5) // Limiter à 5 produits pour le carousel
              .toList();

          if (promotionProducts.isEmpty) {
            return const SizedBox
                .shrink(); // Ne rien afficher s'il n'y a pas de promotions
          }

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: CarouselSlider(
                items: promotionProducts
                    .map((product) => _buildPromotionItem(product))
                    .toList(),
                carouselController: controller,
                options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                    aspectRatio: 13 / 3,
                    enlargeFactor: 0.2,
                    enlargeCenterPage: true,
                    autoPlayInterval: Duration(milliseconds: 3000),
                    viewportFraction: 0.98,
                    onPageChanged: (index, CarouselPageChangedReason c) {
                      setState(() {
                        carouselCurrentIndex = index;
                      });
                    })),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Construit un élément de promotion pour le carousel
  Widget _buildPromotionItem(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Banner(
          message: 'Promo',
          color: AppColors.blueColor,
          location: BannerLocation.topEnd,
          child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: BoxBorder.all(color: AppColors.blueColor),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  // Image du produit
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: product.imageUrl.isNotEmpty
                        ? Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Theme.of(context).colorScheme.background,
                                child: Icon(Icons.image_not_supported,
                                    color: Theme.of(context).colorScheme.error),
                              );
                            },
                          )
                        : Container(
                            width: 60,
                            height: 60,
                            color: Theme.of(context).colorScheme.background,
                            child: Icon(Icons.image_not_supported,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.3)),
                          ),
                  ),
                  const SizedBox(width: 12),
                  // Informations du produit
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nom du produit
                        AppText(
                          text: product.name,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        // Prix normal barré et prix promotionnel
                        if (product.originalPrice != null)
                          Row(
                            children: [
                              // Prix normal barré
                              AppText(
                                text: '${product.originalPrice!.toInt()} FCFA',
                                fontSize: 10,
                                color: Colors.grey[600],
                                decoration: TextDecoration.lineThrough,
                              ),
                              const SizedBox(width: 8),
                              // Prix promotionnel
                              AppText(
                                text: '${product.price.toInt()} FCFA',
                                fontSize: 12,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ],
                          )
                        else
                          // Prix normal (pas de promotion)
                          AppText(
                            text: '${product.price.toInt()} FCFA',
                            fontSize: 12,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Bouton ajouter au panier
                  BlocBuilder<HomeClientBloc, HomeClientState>(
                    builder: (context, homeState) {
                      final isInCart = homeState is HomeClientLoaded &&
                          homeState.cartProductIds.contains(product.id);

                      return GestureDetector(
                        onTap: () {
                          if (isInCart) {
                            // Si déjà dans le panier, retirer
                            context.read<cart_bloc.CartClientBloc>().add(
                                cart_bloc.RemoveFromCart(
                                    productId: product.id));
                            AppUtils.showSuccessNotification(
                                context, '${product.name} retiré du panier');
                          } else {
                            // Si pas dans le panier, ajouter
                            context.read<cart_bloc.CartClientBloc>().add(
                                cart_bloc.AddToCart(productId: product.id));
                            AppUtils.showSuccessNotification(
                                context, '${product.name} ajouté au panier');
                          }
                        },
                        child: Container(
                          height: 30,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: isInCart
                                ? AppColors.primaryColor.withOpacity(0.1)
                                : Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: isInCart
                                  ? AppColors.primaryColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.3),
                              size: 16,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 4),
                  // Bouton voir détails
                  GestureDetector(
                    onTap: () {
                      // Navigation vers la page produit
                      Navigator.pushNamed(context, AppRoutes.PRODUCTDETAILS,
                          arguments: product);
                    },
                    child: Container(
                      height: 30,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.deepOrangeColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: AppText(
                          text: 'Voir',
                          color: AppColors.deepOrangeColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AppTextField(
        height: context.height * 0.07,
        width: context.width * 0.95,
        color: Theme.of(context).colorScheme.background,
        //prefixIcon: Icons.search,
        isPrefixIconWidget: true,
        preficIconWidget: Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: AppButton(
              width: context.width * 0.08,
              height: 45,
              bordeurRadius: 10,
              color: AppColors.primaryColor.withOpacity(0.5),
              child: Icon(
                Icons.search,
                color: Colors.white,
              )),
        ),
        /*suffixIcon: Icon(
        Icons.filter_list,
        color: AppColors.primaryColor,
      ),*/
        showFloatingLabel: false,
        //label: "Rechercher . . .",
        borderRadius: BorderRadius.circular(15),

        onChanged: (value) {
          // setState(() {
          //   _searchQuery = value;
          // });
          context.read<HomeClientBloc>().add(SearchProducts(query: value));
        },
      ),
    );
  }

  Widget _buildCategoryFilters() {
    // Créer une liste avec "Tout" en premier, suivi des secteurs triés
    final allSectors = List<SellerSector>.from(initialSectors)
      ..sort((a, b) => a.name.compareTo(b.name));

    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, bottom: 8, top: 8),
      child: SizedBox(
        height: context.height * 0.12, // Augmenter la hauteur pour les images
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: allSectors.length + 1, // +1 pour "Tout"
          itemBuilder: (context, index) {
            if (index == 0) {
              // Premier élément : "Tout"
              final isSelected = _selectedCategory == 'Tout';
              return Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = 'Tout';
                    });
                    context.read<HomeClientBloc>().add(
                          FilterByCategory(category: 'Tout'),
                        );
                  },
                  child: Container(
                    width: context.width * 0.15,
                    //height: context.height * 0.1,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor.withOpacity(0.5)
                          : Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor.withOpacity(0.7)
                            : Theme.of(context).colorScheme.background,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.all_inclusive,
                          color: isSelected
                              ? Colors.white
                              : Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.5),
                          size: 20,
                        ),
                        const SizedBox(height: 4),
                        AppText(
                          text: 'Tout',
                          color:
                              isSelected ? Colors.white : Colors.grey.shade700,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              // Autres éléments : secteurs avec images
              final sector = allSectors[index - 1];
              final isSelected = _selectedCategory == sector.name;

              return Padding(
                padding: const EdgeInsets.only(right: 8, left: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = sector.name;
                    });
                    context.read<HomeClientBloc>().add(
                          FilterByCategory(category: sector.name),
                        );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image du secteur
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Container(
                          width: context.width * 0.17,
                          height: context.width * 0.17,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Theme.of(context).colorScheme.surface,
                              width: 3,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              sector.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // Fallback si l'image n'existe pas
                                return Icon(
                                  Icons.category,
                                  color: isSelected
                                      ? AppColors.primaryColor
                                      : Colors.grey.shade600,
                                  size: 16,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      // Nom du secteur
                      Expanded(
                        child: SizedBox(
                          width: context.width * 0.17,
                          child: AppText(
                            text: sector.name,
                            maxLine: 2,
                            color: isSelected
                                ? AppColors.primaryColor
                                : Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.5),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: context.smallText * 0.9,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20, left: 8, right: 8),
      height: context.height * 0.045,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.3),
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorWeight: 0,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        //unselectedLabelColor: AppColors.primaryColor,
        labelStyle: TextStyle(color: Colors.white, fontFamily: "PoppinsMedium"),
        tabs: [
          Tab(
            child: Text(
              'Produits',
            ),
          ),
          Tab(
            child: Text(
              'Boutiques',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(HomeClientState state) {
    return SizedBox(
      height: 400,
      child: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsList(state),
          _buildStoresList(state),
        ],
      ),
    );
  }

  Widget _buildProductsList(HomeClientState state) {
    if (state is HomeClientLoaded) {
      // Si "Tout" est sélectionné, regrouper par secteur
      if (_selectedCategory == 'Tout') {
        return _buildProductsGroupedBySector(state);
      } else {
        // Sinon, afficher la liste normale filtrée
        return _buildFilteredProductsList(state);
      }
    }

    return const Center(
      child: AppText(text: 'Aucun produit trouvé'),
    );
  }

  /// Construit la liste des produits regroupés par secteur
  Widget _buildProductsGroupedBySector(HomeClientLoaded state) {
    // Grouper les produits par secteur
    final Map<String, List<Product>> productsBySector = {};

    for (final product in state.products) {
      final sector = product.category;
      if (!productsBySector.containsKey(sector)) {
        productsBySector[sector] = [];
      }
      productsBySector[sector]!.add(product);
    }

    // Créer la liste des secteurs avec des produits
    final sectorsWithProducts = productsBySector.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          PrimaryScrollController.of(context).jumpTo(
            PrimaryScrollController.of(context).offset +
                notification.overscroll / 2,
          );
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: sectorsWithProducts.length,
        itemBuilder: (context, index) {
          final sectorEntry = sectorsWithProducts[index];
          final sectorName = sectorEntry.key;
          final sectorProducts = sectorEntry.value;

          return _buildSectorProductGroup(sectorName, sectorProducts);
        },
      ),
    );
  }

  /// Construit un groupe de produits pour un secteur
  Widget _buildSectorProductGroup(String sectorName, List<Product> products) {
    // Prendre au maximum 4 produits pour la grille
    final displayProducts = products.take(4).toList();
    final hasMoreProducts = products.length > 4;

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête du secteur
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  text: sectorName,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                if (hasMoreProducts)
                  GestureDetector(
                    onTap: () {
                      // Sélectionner le secteur et déclencher le filtre
                      setState(() {
                        _selectedCategory = sectorName;
                      });
                      context.read<HomeClientBloc>().add(
                            FilterByCategory(category: sectorName),
                          );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border:
                            Border.all(color: AppColors.primaryColor, width: 1),
                      ),
                      child: AppText(
                        text: 'Voir tout',
                        color: AppColors.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Grille 2x2 des produits
          _buildProductGrid(displayProducts),
        ],
      ),
    );
  }

  /// Construit une grille 2x2 de produits
  Widget _buildProductGrid(List<Product> products) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8, // Ajuster selon vos besoins
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  /// Construit une carte de produit pour la grille
  Widget _buildProductCard(Product product) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.PRODUCTDETAILS,
              arguments: product);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image du produit
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: product.imageUrl.isNotEmpty
                      ? Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.4),
                              child: Icon(
                                Icons.image_not_supported,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.6),
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Container(
                          width: double.infinity,
                          color: Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withOpacity(0.4),
                          child: Icon(
                            Icons.image_not_supported,
                            color: Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withOpacity(0.6),
                            size: 40,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 8),

              // Nom du produit
              Expanded(
                flex: 1,
                child: AppText(
                  text: product.name,
                  fontSize: context.mediumText * 0.8,
                  fontWeight: FontWeight.w600,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Descriotion du produit
              Expanded(
                flex: 1,
                child: AppText(
                  text: product.description,
                  fontSize: context.smallText * 0.8,
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.6),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Prix et bouton panier
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: AppText(
                        text: '${product.price.toInt()} FCFA',
                        fontSize: 11,
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    BlocBuilder<HomeClientBloc, HomeClientState>(
                      builder: (context, homeState) {
                        final isInCart = homeState is HomeClientLoaded &&
                            homeState.cartProductIds.contains(product.id);

                        return GestureDetector(
                          onTap: () {
                            if (isInCart) {
                              context.read<cart_bloc.CartClientBloc>().add(
                                    cart_bloc.RemoveFromCart(
                                        productId: product.id),
                                  );
                              AppUtils.showInfoNotification(
                                  context, '${product.name} retiré du panier');
                            } else {
                              context.read<cart_bloc.CartClientBloc>().add(
                                    cart_bloc.AddToCart(productId: product.id),
                                  );
                              AppUtils.showSuccessNotification(
                                  context, '${product.name} ajouté au panier');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: isInCart
                                  ? AppColors.primaryColor.withOpacity(0.1)
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.3),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(
                              Icons.add_shopping_cart,
                              color: isInCart
                                  ? AppColors.primaryColor
                                  : Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.6),
                              size: 16,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit la liste filtrée des produits (vue normale)
  Widget _buildFilteredProductsList(HomeClientLoaded state) {
    final filteredProducts = state.products
        .where((product) => product.category == _selectedCategory)
        .toList();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is OverscrollNotification) {
          PrimaryScrollController.of(context).jumpTo(
            PrimaryScrollController.of(context).offset +
                notification.overscroll / 2,
          );
        }
        return false;
      },
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(product.imageUrl),
                radius: 25,
              ),
              title: AppText(text: product.name),
              subtitle: AppText(
                text: '${product.price} FCFA',
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
              ),
              trailing: BlocBuilder<HomeClientBloc, HomeClientState>(
                builder: (context, homeState) {
                  final isInCart = homeState is HomeClientLoaded &&
                      homeState.cartProductIds.contains(product.id);

                  return IconButton(
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: isInCart
                          ? AppColors.primaryColor
                          : Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withOpacity(0.3),
                    ),
                    onPressed: () {
                      if (isInCart) {
                        context.read<cart_bloc.CartClientBloc>().add(
                              cart_bloc.RemoveFromCart(productId: product.id),
                            );
                        AppUtils.showInfoNotification(
                            context, '${product.name} retiré du panier');
                      } else {
                        context.read<cart_bloc.CartClientBloc>().add(
                              cart_bloc.AddToCart(productId: product.id),
                            );
                        AppUtils.showSuccessNotification(
                            context, '${product.name} ajouté au panier');
                      }
                    },
                  );
                },
              ),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.PRODUCTDETAILS,
                    arguments: product);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildStoresList(HomeClientState state) {
    if (state is HomeClientLoaded) {
      // Filtrer les boutiques selon le secteur sélectionné
      // Note: StoreClient n'a pas de propriété secteur, donc on affiche toutes les boutiques pour l'instant
      // TODO: Ajouter la propriété secteur au modèle StoreClient si nécessaire
      final filteredStores = _selectedCategory == 'Tout'
          ? state.stores
          : state.stores; // Pour l'instant, pas de filtrage par secteur

      return NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is OverscrollNotification) {
            // Transfère le scroll vers le parent à la fin du scroll
            PrimaryScrollController.of(context).jumpTo(
              PrimaryScrollController.of(context).offset +
                  notification.overscroll / 2,
            );
          }
          return false;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: filteredStores.length,
          itemBuilder: (context, index) {
            final store = filteredStores[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(store.imageUrl),
                  radius: 25,
                ),
                title: AppText(text: store.name),
                subtitle: AppText(text: store.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      color: AppColors.orangeColor,
                      size: 16,
                    ),
                    AppText(
                      text: ' ${store.rating}',
                      fontSize: 12,
                    ),
                  ],
                ),
                onTap: () {
                  // Navigation vers la page boutique
                  Navigator.pushNamed(context, AppRoutes.STOREDETAILS,
                      arguments: store);
                },
              ),
            );
          },
        ),
      );
    }

    return const Center(
      child: AppText(text: 'Aucune boutique trouvée'),
    );
  }

  /// Construit le Drawer avec les ressources essentielles
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // En-tête du Drawer
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withOpacity(0.8),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 10),
                  AppText(
                    text: 'Bienvenue',
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  FutureBuilder<String?>(
                    future: _getUserName(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data != null) {
                        return AppText(
                          text: snapshot.data!,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        );
                      }
                      return AppText(
                        text: 'Client',
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Menu du Drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Profil
                _buildDrawerItem(
                  icon: Icons.person,
                  title: 'Mon Profil',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.PROFILE);
                  },
                ),

                // Panier
                _buildDrawerItem(
                  icon: Icons.shopping_cart,
                  title: 'Mon Panier',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.CART);
                  },
                ),

                // Favoris
                /*_buildDrawerItem(
                  icon: Icons.favorite,
                  title: 'Mes Favoris',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.FAVORITES);
                  },
                ),*/

                // Commandes
                _buildDrawerItem(
                  icon: Icons.shopping_bag,
                  title: 'Mes Commandes',
                  onTap: () {
                    AppUtils.showInfoDialog(
                        context: context,
                        message: 'Cette fonctionnalité arrive bientôt');
                  },
                ),

                // Divider
                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.3),
                ),

                // Aide et Support
                _buildDrawerItem(
                  icon: Icons.help,
                  title: 'Aide & Support',
                  onTap: () {
                    Navigator.pop(context);
                    _showHelpDialog();
                  },
                ),

                // À propos
                _buildDrawerItem(
                  icon: Icons.info,
                  title: 'À propos',
                  onTap: () {
                    Navigator.pop(context);
                    _showAboutDialog();
                  },
                ),

                // Paramètres
                _buildDrawerItem(
                  icon: Icons.settings,
                  title: 'Paramètres',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, AppRoutes.PROFILE);
                  },
                ),

                Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.3),
                ),

                // Déconnexion
                _buildDrawerItem(
                  icon: Icons.logout,
                  title: 'Déconnexion',
                  onTap: () {
                    Navigator.pop(context);
                    _showLogoutDialog();
                  },
                  textColor: AppColors.redColor,
                  iconColor: AppColors.redColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Construit un élément du menu du Drawer
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primaryColor,
        size: 24,
      ),
      title: AppText(
        text: title,
        color: textColor ??
            Theme.of(context).colorScheme.inverseSurface.withOpacity(0.8),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      onTap: onTap,
      hoverColor: AppColors.primaryColor.withOpacity(0.1),
    );
  }

  /// Récupère le nom de l'utilisateur connecté
  Future<String?> _getUserName() async {
    try {
      final userDataService = UserDataService();
      final user = await userDataService.getCurrentUser();
      return user?.fullName;
    } catch (e) {
      print('Erreur lors de la récupération du nom utilisateur: $e');
      return null;
    }
  }

  /// Affiche la BottomSheet d'aide
  void _showHelpDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      //showDragHandle: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.6),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      color: AppColors.primaryColor,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    AppText(
                      text: 'Aide & Support',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                      overflow: TextOverflow.visible,
                      maxLine: 2,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.close,
                        color: Theme.of(context)
                            .colorScheme
                            .inverseSurface
                            .withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: 'Comment pouvons-nous vous aider ?',
                          fontSize: 16,
                        ),
                        const SizedBox(height: 24),

                        // Contact items
                        _buildContactItem(
                          icon: Icons.phone,
                          title: 'Téléphone',
                          subtitle: AppAttributes.appAuthorPhone,
                          onTap: () {
                            // TODO: Implémenter l'appel téléphonique
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.email,
                          title: 'Email',
                          subtitle: AppAttributes.appAuthorEmail,
                          onTap: () {
                            // TODO: Implémenter l'envoi d'email
                          },
                        ),

                        const SizedBox(height: 16),

                        _buildContactItem(
                          icon: Icons.access_time,
                          title: 'Horaires de support',
                          subtitle: 'Lun - Ven: 8h - 18h\nSam: 9h - 15h',
                          onTap: null,
                        ),

                        const SizedBox(height: 24),

                        // FAQ section
                        AppText(
                          text: 'Questions fréquentes',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                        const SizedBox(height: 12),

                        _buildFAQItem(
                          question: 'Comment passer une commande ?',
                          answer:
                              'Sélectionnez vos produits, ajoutez-les au panier et procédez au paiement.',
                        ),

                        _buildFAQItem(
                          question: 'Comment suivre ma commande ?',
                          answer:
                              'Vous recevrez des notifications par email et SMS sur l\'état de votre commande.',
                        ),

                        _buildFAQItem(
                          question: 'Quels sont les modes de paiement ?',
                          answer:
                              'Nous acceptons les paiements par mobile money, carte bancaire et paiement à la livraison.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Construit un élément de contact
  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primaryColor.withOpacity(0.05)
              : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: onTap != null
                ? AppColors.primaryColor.withOpacity(0.2)
                : Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: title,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    // color: Colors.black87,
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    text: subtitle,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  /// Construit un élément de FAQ
  Widget _buildFAQItem({
    required String question,
    required String answer,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: question,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryColor,
            maxLine: 2,
          ),
          const SizedBox(height: 8),
          AppText(
            text: answer,
            fontSize: 12,
            //color: Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
            overflow: TextOverflow.visible,
          ),
        ],
      ),
    );
  }

  /// Affiche la boîte de dialogue À propos
  void _showAboutDialog() {
    AppUtils.showDialog(
        context: context,
        titleColor: AppColors.primaryColor,
        title: AppAttributes.appName,
        content:
            '${AppAttributes.appVersion}\n\n ${AppAttributes.appDescription}',
        cancelText: "OK",
        onConfirm: () {});
  }

  /// Affiche la boîte de dialogue de déconnexion
  void _showLogoutDialog() {
    AppUtils.showDialog(
      context: context,
      title: "Déconnexion",
      content: 'Êtes-vous sûr de vouloir vous déconnecter ?',
      confirmText: 'Déconnexion',
      cancelText: 'Annuler',
      onConfirm: () {
        _handleSignOut();
      },
    );
  }
}
