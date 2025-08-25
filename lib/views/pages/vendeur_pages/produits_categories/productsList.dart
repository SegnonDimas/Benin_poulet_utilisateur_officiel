import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/product_list_pages/actifs_productsPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/product_list_pages/en_attente_productPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/product_list_pages/inactifs_productsPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/product_list_pages/suspendus_productsPage.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  late PageController _pageController;

  List product_pages = [
    ActifsProductsPage(),
    InactifsProductsPage(),
    EnAttenteProductsPage(),
    SuspendusProductsPage(),
  ];

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: product_pages.length,
          itemBuilder: (context, index) {
            return product_pages[index];
          },
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          index: currentIndex,
          height: context.height * 0.07,
          color: Theme.of(context).colorScheme.background,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
            FocusScope.of(context).unfocus(); //force le clavier à se fermer
          },
          items: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.notifications_active_outlined),
                AppText(
                  text: 'Actifs',
                  fontSize: context.smallText * 0.8,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.notifications_off_outlined),
                AppText(
                  text: 'Inactifs',
                  fontSize: context.smallText * 0.8,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_top_rounded),
                AppText(
                  text: 'En attente',
                  fontSize: context.smallText * 0.8,
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.block),
                AppText(
                  text: 'Suspendus',
                  fontSize: context.smallText * 0.8,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class ProductImagesPathIndexProvider extends ChangeNotifier {
  int _indexProductImage = 0;
  int get indexProductImage => _indexProductImage;

  void indexProductImageInitialize() {
    _indexProductImage = 0;
    notifyListeners();
  }

  void indexProductImageNewValue(int newValue) {
    _indexProductImage = newValue;
    notifyListeners();
  }
}
