import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/categoriesList.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/productsList.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class VProduitsListPage extends StatefulWidget {
  const VProduitsListPage({super.key});

  @override
  State<VProduitsListPage> createState() => _VProduitsListPageState();
}

class _VProduitsListPageState extends State<VProduitsListPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  String search = 'un produit';
  List<String> variations = [
    'variation 1',
    'variation 2',
    'variation 3',
    'variation 4'
  ];
  int stockValue = 15;

  bool promotionValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: 'Produits',
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list_outlined,
                color: primaryColor,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/ajoutNouveauProduitPage');
              },
              icon: Icon(
                Icons.add,
                color: primaryColor,
              ))
        ],
      ),
      body: Column(
        children: [
          /// TabBar
          SizedBox(
            height: appHeightSize(context) * 0.1,
            width: appWidthSize(context) * 0.9,
            child: TabBar(
                controller: controller,
                indicatorColor: primaryColor,
                labelColor: primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.primary,
                tabs: [
                  Tab(child: AppText(text: 'Produits')),
                  Tab(
                    child: AppText(text: 'Catégories'),
                  ),
                ]),
          ),

          ///Bar de recherche
          SizedBox(
            width: appWidthSize(context) * 0.9,
            //height: appHeightSize(context) * 0.07,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SearchBar(
                  elevation: const WidgetStatePropertyAll(0),
                  hintText: 'cherchez $search . . . ',
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  hintStyle: WidgetStatePropertyAll(TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.primary,
                  ))),
            ),
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
    );
  }
}
