import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../bloc/client/home_client_bloc.dart';
import '../../../constants/routes.dart';
import '../../../widgets/app_text.dart';
import '../../../widgets/app_textField.dart';
import '../../colors/app_colors.dart';
import '../../models_ui/model_carouselItem.dart';
import '../../models_ui/model_recommandation.dart';

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

  final List<Widget> _populaireList = [
    Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border: BoxBorder.all(color: AppColors.blueColor),
                  borderRadius: BorderRadius.circular(15)),
              child: ListTile(
                //contentPadding: EdgeInsets.zero,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    "assets/images/pouletCouveuse.png",
                    fit: BoxFit.cover,
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 6,
                      child: AppText(
                        text: 'Poule couveuse',
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: AppButton(
                          height: 30,
                          bordeurRadius: 10,
                          color: AppColors.deepOrangeColor.withOpacity(0.1),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 6.0, right: 6.0),
                            child: AppText(
                              text: 'Voir',
                              color: AppColors.deepOrangeColor,
                              fontSize: 12,
                            ),
                          )),
                    )
                  ],
                ),
                subtitle: AppText(
                  text: 'Ne manquez pas',
                  fontSize: 10,
                ),
              ))),
    ),
  ];

  final List<ModelRecomandation> _listRecommandations = const [
    ModelRecomandation(
      shopName: 'Le Poulailler',
      backgroundImage: 'assets/images/pouletCouveuse.png',
    ),
    ModelRecomandation(
      shopName: 'Mike Store',
    ),
    ModelRecomandation(
      shopName: 'Le gros',
      backgroundImage: 'assets/images/pouletCouveuse.png',
    ),
  ];

  int carouselCurrentIndex = 0;
  late TabController _tabController;
  String _selectedCategory = 'Tous';
  String _searchQuery = '';

  final List<String> _categories = [
    'Tous',
    'Poulets',
    'Œufs',
    'Aliments',
    'Équipements',
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: BlocBuilder<HomeClientBloc, HomeClientState>(
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

                _buildPopulaireCarouselSlider(),

                // Filtres par catégorie
                _buildCategoryFilters(),

                // Contenu des onglets
                _buildTabContent(state),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        foregroundColor: Colors.white,
        backgroundColor: AppColors.primaryColor,
        child: Icon(Icons.shopping_cart),
      ),
    );
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

  Widget _buildPopulaireCarouselSlider() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: CarouselSlider(
          items: _populaireList,
          carouselController: controller,
          options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
              aspectRatio: 13 / 3,
              enlargeFactor: 0.2,
              enlargeCenterPage: true,
              //autoPlayAnimationDuration: Duration(milliseconds: 500),
              autoPlayInterval: Duration(milliseconds: 2000),
              viewportFraction: 0.98,
              onPageChanged: (index, CarouselPageChangedReason c) {
                //return index;
                setState(() {
                  carouselCurrentIndex = index;
                });
              })),
    );
  }

  Widget _buildCarousel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: context.height * 0.2,
          child: PageView.builder(
            itemCount: _carouselList.length,
            allowImplicitScrolling: true,
            onPageChanged: (index) {
              setState(() {
                carouselCurrentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: _carouselList[index],
              );
            },
          ),
        ),
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _carouselList.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: carouselCurrentIndex == index
                      ? AppColors.primaryColor
                      : Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
      ],
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
        setState(() {
          _searchQuery = value;
        });
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
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.products.length,
        itemBuilder: (context, index) {
          final product = state.products[index];
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
              trailing: IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: () {
                  context.read<HomeClientBloc>().add(
                        AddToCart(product: product),
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
      );
    }

    return const Center(
      child: AppText(text: 'Aucun produit trouvé'),
    );
  }

  Widget _buildStoresList(HomeClientState state) {
    if (state is HomeClientLoaded) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: state.stores.length,
        itemBuilder: (context, index) {
          final store = state.stores[index];
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
      );
    }

    return const Center(
      child: AppText(text: 'Aucune boutique trouvée'),
    );
  }
}
