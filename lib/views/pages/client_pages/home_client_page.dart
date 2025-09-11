import 'package:benin_poulet/views/sizes/text_sizes.dart';
// import 'package:benin_poulet/widgets/app_button.dart'; // Non utilisé - remplacé par GestureDetector
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../bloc/choixCategorie/secteur_bloc.dart';
import '../../../bloc/client/cart_client_bloc.dart' as cart_bloc;
import '../../../bloc/client/home_client_bloc.dart';
import '../../../constants/routes.dart';
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
  List<String> _categories = ['Tout'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _initializeCategories();
    context.read<HomeClientBloc>().add(LoadHomeData());
  }

  /// Initialise la liste des secteurs pour le filtrage
  void _initializeCategories() {
    // Extraire tous les secteurs et les trier par ordre alphabétique
    final allSectors = initialSectors.map((sector) => sector.name).toList()
      ..sort();

    // Mettre "Tout" au début de la liste
    _categories = ['Tout'] + allSectors;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            title: _buildSearchBar(),
            leadingWidth: context.width * 0.15,
            //centerTitle: true,
            leading: IconButton(
              icon: CircleAvatar(radius: 30, child: const Icon(Icons.person)),
              onPressed: () {
                // Navigation vers le profil de l'utilisateur
                Navigator.pushNamed(context, AppRoutes.PROFILE);
                /* Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => CProfilPage()));*/
              },
            ),
          ),
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

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
        Positioned(
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
        )
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
    return AppTextField(
      height: 50,
      width: context.width * 0.85,
      color: Theme.of(context).colorScheme.background,
      prefixIcon: Icons.search,
      /*suffixIcon: Icon(
        Icons.filter_list,
        color: AppColors.primaryColor,
      ),*/
      showFloatingLabel: false,
      hintText: "Rechercher . . .",
      borderRadius: BorderRadius.circular(15),
      onChanged: (value) {
        // setState(() {
        //   _searchQuery = value;
        // });
        context.read<HomeClientBloc>().add(SearchProducts(query: value));
      },
    );
  }

  Widget _buildCategoryFilters() {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4, bottom: 8, top: 8),
      child: SizedBox(
        height: context.height * 0.045,
        //width: context.width * 0.98,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          //padding: const EdgeInsets.only(left: 8, right: 8),
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            final isSelected = _selectedCategory == category;

            return Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: FilterChip(
                checkmarkColor: Theme.of(context).colorScheme.inverseSurface,
                label: AppText(
                  text: category,
                  color: isSelected
                      ? Theme.of(context).colorScheme.inverseSurface
                      : Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.6),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: context.smallText * 1.1,
                ),
                side: BorderSide(
                    color: Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.0)),
                selected: isSelected,
                selectedColor: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.3),
                backgroundColor: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.1),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = category;
                  });
                  // Déclencher un rebuild du contenu des onglets
                  context.read<HomeClientBloc>().add(
                        FilterByCategory(category: category),
                      );
                },
              ),
            );
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
      // Filtrer les produits selon le secteur sélectionné
      final filteredProducts = _selectedCategory == 'Tout'
          ? state.products
          : state.products
              .where((product) => product.category == _selectedCategory)
              .toList();

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
                          // Si déjà dans le panier, retirer
                          context.read<cart_bloc.CartClientBloc>().add(
                                cart_bloc.RemoveFromCart(productId: product.id),
                              );
                          AppUtils.showInfoNotification(
                              context, '${product.name} retiré du panier');
                        } else {
                          // Si pas dans le panier, ajouter
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
                  // Navigation vers la page produit
                  Navigator.pushNamed(context, AppRoutes.PRODUCTDETAILS,
                      arguments: product);
                },
              ),
            );
          },
        ),
      );
    }

    return const Center(
      child: AppText(text: 'Aucun produit trouvé'),
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
}
