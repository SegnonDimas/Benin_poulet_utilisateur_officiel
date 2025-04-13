import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/produit.dart';
import 'model_attibutProduit.dart';

class ModelProduit extends StatelessWidget {
  final Function()? onTap;
  final Produit produit;
  final CarouselSliderController? controller;

  const ModelProduit(
      {super.key, required this.produit, this.onTap, this.controller});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: context.height * 0.11,
        width: context.width * 0.95,
        child: Row(
          children: [
            /// image du produit
            Expanded(
              flex: 3,
              child: SizedBox(
                height: context.height * 0.08,
                child: CarouselSlider(
                  items:
                      List.generate(produit.productImagesPath!.length, (index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        produit.productImagesPath?[index] ??
                            'assets/icons/img.png',
                        fit: BoxFit.cover,
                        height: context.height * 0.08,
                        color: produit.productImagesPath?[index] == null
                            ? Theme.of(context).colorScheme.surface
                            : null,
                      ),
                    );
                  }),
                  carouselController: controller ?? CarouselSliderController(),
                  options: CarouselOptions(
                    autoPlay: true,
                    autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                    aspectRatio: 11 / 5,
                    enlargeFactor: 0.5,
                    viewportFraction: 1,
                  ),
                ),
              ),
            ),

            /// informations sur le produit
            Flexible(
                flex: 12,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: context.height * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// nom et prix du produit
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // nom du produit
                            Flexible(
                              flex: 7,
                              child: AppText(
                                text: produit.productName ?? 'Produit...',
                                fontWeight: FontWeight.w900,
                                fontSize: context.mediumText * 1.0,
                              ),
                            ),

                            // prix du produit
                            Flexible(
                                flex: 3,
                                child: AppText(
                                  text:
                                      '${produit.productUnitPrice!.toInt()} F',
                                  fontSize: context.mediumText * 0.8,
                                  fontWeight: FontWeight.w900,
                                )),
                          ],
                        ),

                        /// liste des variétés du produit
                        SizedBox(
                          height: 25,
                          width: context.width * 0.55,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(
                                produit.varieteProduitList!.isNotEmpty
                                    ? produit.varieteProduitList!.length
                                    : 1, (index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 2.0, top: 2, right: 10),
                                child: AppText(
                                  text: produit.varieteProduitList!.isNotEmpty
                                      ? produit.varieteProduitList![index]
                                      : 'Standard',
                                  fontSize: context.smallText * 0.9,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary
                                      .withOpacity(0.6),
                                ),
                              );
                            }),
                          ),
                        ),

                        /// Autres informations sur le produits
                        Row(
                          children: [
                            /// sotock (icon, stock, nombre en stock)
                            Flexible(
                              flex: 1,
                              child: SizedBox(
                                  width: context.width * 0.25,
                                  child: ModelAttributProduit(
                                    attributIcon: Icons.store,
                                    attributLabel: 'Stock',
                                    attributValue: '${produit.stockValue}',
                                    attributLabelColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    attributIconColor: Colors.deepPurpleAccent,
                                    attributValueColor: AppColors.primaryColor,
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
                                  width: context.width * 0.3,
                                  child: ModelAttributProduit(
                                    attributIcon: Icons.flash_on_outlined,
                                    attributLabel: 'Promo',
                                    attributValue:
                                        produit.promotionValue ?? 'NON',
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

            /// status du produit
            Flexible(
                flex: 1,
                child: Icon(
                  Icons.circle,
                  color: produit.productStatus == 'actif'
                      ? Colors.lightGreen.shade600
                      : produit.productStatus == 'inactif'
                          ? Colors
                              .grey //Theme.of(context).colorScheme.background
                          : produit.productStatus == 'en attente'
                              ? Colors.yellow.shade600
                              : produit.productStatus == 'suspendu'
                                  ? Colors.red.shade600
                                  : Colors.transparent,
                  size: context.mediumText,
                ))
          ],
        ),
      ),
    );
  }
}
