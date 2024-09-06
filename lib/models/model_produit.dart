import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

import 'model_attibutProduit.dart';

class ModelProduit extends StatelessWidget {
  final String? imagePath;
  final String? productName;
  final String? attributProductValue;
  final int? stockValue;
  final String? promotionValue;
  final double? productUnitPrice;
  final List<String>? varieteProduitList;

  const ModelProduit({
    super.key,
    this.imagePath,
    required this.productName,
    this.attributProductValue,
    this.varieteProduitList,
    this.stockValue = 1,
    this.promotionValue,
    required this.productUnitPrice,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: appHeightSize(context) * 0.11,
      width: appWidthSize(context) * 0.9,
      child: Row(
        children: [
          /// image du produit
          Flexible(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath ?? 'assets/icons/img.png',
                fit: BoxFit.cover,
                height: appHeightSize(context) * 0.09,
                color: imagePath == null
                    ? Theme.of(context).colorScheme.surface
                    : null,
              ),
            ),
          ),

          Flexible(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: appHeightSize(context) * 0.9,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// nom du produit
                      AppText(
                        text: productName ?? 'Produit...',
                        fontWeight: FontWeight.w900,
                        fontSize: largeText() * 0.9,
                      ),

                      /// liste des variétés du produit
                      SizedBox(
                        height: 25,
                        width: appWidthSize(context) * 0.55,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: List.generate(
                              varieteProduitList?.length ?? 1, (index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 2.0, top: 2, right: 10),
                              child: AppText(
                                text: varieteProduitList?[index] ?? 'standard',
                                fontSize: smallText() * 0.9,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.6),
                              ),
                            );
                          }),
                        ),
                      ),
                      Row(
                        children: [
                          /// sotock (icon, stock, nombre en stock)
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                                width: appWidthSize(context) * 0.25,
                                child: ModelAttributProduit(
                                  attributIcon: Icons.store,
                                  attributLabel: 'Stock',
                                  attributValue: '$stockValue',
                                  attributLabelColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  attributIconColor: Colors.deepPurpleAccent,
                                  attributValueColor: primaryColor,
                                )),
                          ),

                          /// séparateur
                          AppText(
                            text: '  |  ',
                            color: Theme.of(context).colorScheme.primary,
                          ),

                          /// promotion (icon, promotion, état de la promotion (OUI ou NON))
                          Flexible(
                            flex: 1,
                            child: SizedBox(
                                width: appWidthSize(context) * 0.3,
                                child: ModelAttributProduit(
                                  attributIcon: Icons.flash_on_outlined,
                                  attributLabel: 'Promo',
                                  attributValue: promotionValue ?? 'NON',
                                  attributLabelColor: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  attributIconColor: Colors.deepOrangeAccent,
                                  attributValueColor: primaryColor,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )),

          Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// prix unitair du produit
                  Flexible(
                      flex: 4,
                      child: AppText(
                        text: '${productUnitPrice!.toInt()} F',
                        fontSize: smallText(),
                        fontWeight: FontWeight.w900,
                      )),

                  /// bouton de redirection
                  Flexible(
                      flex: 1,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: mediumText(),
                      ))
                ],
              ))
        ],
      ),
    );
  }
}
