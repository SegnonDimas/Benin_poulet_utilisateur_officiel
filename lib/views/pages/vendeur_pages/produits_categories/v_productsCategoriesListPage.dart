import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/categoriesList.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/productsList.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../bloc/product/product_bloc.dart';
import '../../../../models/produit.dart';

class VProduitsListPage extends StatefulWidget {
  const VProduitsListPage({super.key});

  @override
  State<VProduitsListPage> createState() => _VProduitsListPageState();
}

class _VProduitsListPageState extends State<VProduitsListPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  String search = '';

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (p, t) {
        // Réinitialiser l'état de la recherche de produits lorsque l'utilisateur appuie sur le bouton retour
        context.read<ProductBloc>().add(ReinitialiserRecherche());
      },
      child: SafeArea(
        top: false,
        child: Scaffold(
          appBar: AppBar(
            title: AppText(
              text: 'Produits',
            ),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      controller.index = 1;
                    });
                  },
                  icon: Icon(
                    Icons.filter_list_outlined,
                    color: AppColors.primaryColor,
                  )),
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, AppRoutes.AJOUTNOUVEAUPRODUITPAGE);
                  },
                  icon: Icon(
                    Icons.add,
                    color: AppColors.primaryColor,
                  ))
            ],
          ),
          body: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, produitsState) {
              // Filtrage dynamique en fonction de search
              List<Produit> produitsFiltres = [];
              
              if (produitsState is ProductsLoaded) {
                produitsFiltres = produitsState.products.where((produit) {
                  return produit.productName.toLowerCase().contains(search.toLowerCase());
                }).toList();
              } else if (produitsState is ProduitFiltre) {
                produitsFiltres = produitsState.produitsFiltres.where((produit) {
                  return produit.productName.toLowerCase().contains(search.toLowerCase());
                }).toList();
              }
              
              // États de chargement et d'erreur
              if (produitsState is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (produitsState is ProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Erreur: ${produitsState.message}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }
              
              return Column(
                children: [
                  /// TabBar
                  SizedBox(
                    height: context.height * 0.07,
                    width: context.width * 0.9,
                    child: TabBar(
                      controller: controller,
                      indicatorColor: AppColors.primaryColor,
                      labelColor: AppColors.primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontFamily: 'PoppinsMedium',
                        fontSize: context.mediumText,
                      ),
                      unselectedLabelStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PoppinsMedium',
                        fontSize: context.mediumText * 0.8,
                      ),
                      dividerColor: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.4),
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.4),
                      tabs: [
                        Tab(child: Text('Produits')),
                        Tab(
                          child: Text('Catégories'),
                        ),
                      ],
                      /*onTap: (index) {
                    setState(() {
                      index == 0 ? search = 'un produit' : search = 'une catégorie';
                    });
                  },*/
                    ),
                  ),

                  ///Barre de recherche
                  SizedBox(
                    width: context.width * 0.9,
                    //height: context.height * 0.07,
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchBar(
                            elevation: const WidgetStatePropertyAll(0),
                            hintText: 'Rechercher . . . ',
                            leading: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.search,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.4),
                              ),
                            ),
                            onChanged: (value) {
                              context
                                  .read<ProductBloc>()
                                  .add(RechercherProduit(value.trim()));
                            },
                            hintStyle: WidgetStatePropertyAll(TextStyle(
                              fontSize: 13,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.4),
                            )))),
                  ),

                  /// TabBarView
                  Expanded(
                    child: TabBarView(
                        controller: controller,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                          ProductsList(),
                          CategoriesList(),
                        ]),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
