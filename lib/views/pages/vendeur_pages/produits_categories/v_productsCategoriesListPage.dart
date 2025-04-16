import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/categoriesList.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/productsList.dart';
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

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmer'),
            content: Text('Voulez-vous vraiment quitter cette page ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('Non'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text('Oui'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    //context.read<ProduitBloc>().add(ReinitialiserRecherche());
  }

  @override
  Widget build(BuildContext context) {
    // Filtrage dynamique en fonction de search
    final List<Produit> produitsFiltres = list_produits.where((produit) {
      return produit.productName!.toLowerCase().contains(search.toLowerCase());
    }).toList();

    return PopScope(
      onPopInvokedWithResult: (p, t) {
        // Réinitialiser l'état de la recherche de produits lorsque l'utilisateur appuie sur le bouton retour
        context.read<ProductBloc>().add(ReinitialiserRecherche());
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: 'Produits',
          ),
          centerTitle: true,
          /*leading: IconButton(
              onPressed: () {
                // Réinitialiser l'état de la recherche de produits lorsque l'utilisateur appuie sur le bouton retour
                context.read<ProductBloc>().add(ReinitialiserRecherche());
                Get.back();
              },
              icon: Icon(Icons.arrow_back_outlined)),*/
          actions: [
            IconButton(
                onPressed: () {},
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
        body: Column(
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
                dividerColor: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4),
                unselectedLabelColor: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4),
                tabs: [
                  Tab(child: AppText(text: 'Produits')),
                  Tab(
                    child: AppText(text: 'Catégories'),
                  ),
                ],
                /*onTap: (index) {
              setState(() {
                index == 0 ? search = 'un produit' : search = 'une catégorie';
              });
            },*/
              ),
            ),

            ///Bar de recherche
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
              child: TabBarView(controller: controller, children: const [
                ProductsList(),
                CategoriesList(),
              ]),
            ),
          ],
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
