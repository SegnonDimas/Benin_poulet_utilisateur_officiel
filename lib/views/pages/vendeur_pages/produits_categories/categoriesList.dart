import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/choixCategorie/secteur_bloc.dart';
import '../../../../bloc/product/product_bloc.dart';
import '../../../../models/produit.dart';
import '../../../../services/products_services.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(
        length: initialSectors.length, vsync: this, initialIndex: 0);
    //context.read<ProduitBloc>().add(ReinitialiserRecherche());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: initialSectors.length + 1,
      child: Scaffold(body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, produitsState) {
          /// filtrage selon les catégories
          Widget categorie_filtre(String categorie) {
            if (produitsState is ProduitFiltre) {
              final list_produits_filtres = produitsState.produitsFiltres
                  .where((p) =>
                      p.category?.toLowerCase().trim() ==
                      categorie.toLowerCase().trim())
                  .toList();
              return showProducts(context, list_produits_filtres);
            }
            return showProducts(context, list_produits);
          }

          return Column(
            children: [
              TabBar(
                  controller: tabController,
                  isScrollable: true,
                  padding: EdgeInsets.zero,
                  tabAlignment: TabAlignment.start,
                  indicatorColor: AppColors.primaryColor,
                  labelColor: AppColors.primaryColor,
                  dividerHeight: 0.0,
                  indicatorWeight: 4,
                  unselectedLabelColor: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.3),
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontFamily: 'PoppinsMedium',
                      color: AppColors.primaryColor),
                  tabs: List.generate(initialSectors.length, (index) {
                    return Text(
                      initialSectors[index].name,
                    );
                  })),
              Expanded(
                child: TabBarView(
                    controller: tabController,
                    children: List.generate(initialSectors.length, (index) {
                      return categorie_filtre(initialSectors[index].name);
                    })),
              )
            ],
          );
        },
      )),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
