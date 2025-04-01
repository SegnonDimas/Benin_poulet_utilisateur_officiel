import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../../models_ui/model_produit.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<ModelProduit> list_produits = [
    const ModelProduit(
      productName: 'Œufs Poulet',
      productUnitPrice: 1500,
      imagePath: 'assets/images/oeuf2.png',
      varieteProduitList: [
        'Variation1',
        'Variation2',
        'Variation3',
        'Variation4'
      ],
      promotionValue: 'NON',
      stockValue: 15,
    ),
    const ModelProduit(
      productName: 'Poulet Goliath',
      productUnitPrice: 7500,
      imagePath: 'assets/images/pouletCouveuse.png',
      varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
      promotionValue: 'NON',
      stockValue: 150,
    ),
    const ModelProduit(
      productName: 'Boeuf ayoussa',
      productUnitPrice: 250000,
      imagePath: 'assets/images/boeuf.png',
      varieteProduitList: [
        'Variation1',
        'Variation2',
      ],
      promotionValue: 'NON',
      stockValue: 100,
    ),
    const ModelProduit(
      productName: 'Œufs Poulet',
      productUnitPrice: 1500,
      imagePath: 'assets/images/oeuf2.png',
      varieteProduitList: [
        'Variation1',
        'Variation2',
        'Variation3',
        'Variation4'
      ],
      promotionValue: 'NON',
      stockValue: 15,
    ),
    const ModelProduit(
      productName: 'Poulet Goliath',
      productUnitPrice: 7500,
      imagePath: 'assets/images/pouletCouveuse.png',
      varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
      promotionValue: 'NON',
      stockValue: 150,
    ),
    const ModelProduit(
      productName: 'Œufs Poulet',
      productUnitPrice: 1500,
      imagePath: 'assets/images/oeuf2.png',
      varieteProduitList: [
        'Variation1',
        'Variation2',
        'Variation3',
        'Variation4'
      ],
      promotionValue: 'NON',
      stockValue: 15,
    ),
    const ModelProduit(
      productName: 'Poulet Goliath',
      productUnitPrice: 7500,
      imagePath: 'assets/images/pouletCouveuse.png',
      varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
      promotionValue: 'NON',
      stockValue: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: list_produits.length,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, bottom: 0),
                      child: SizedBox(
                          height: appHeightSize(context) * 0.13,
                          child: list_produits[index]));
                }),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.surface,
        onTap: (index) {
          // index;
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active_outlined),
              AppText(
                text: 'Actifs',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_off_outlined),
              AppText(
                text: 'Inactifs',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_top_rounded),
              AppText(
                text: 'En attente',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.block),
              AppText(
                text: 'Suspendus',
                fontSize: smallText() * 0.8,
              ),
            ],
          )
        ],
      ),
    );
  }
}
