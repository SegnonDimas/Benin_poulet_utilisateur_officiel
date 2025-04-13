import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/models_ui/model_secteur.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
import 'package:provider/provider.dart';

import '../../../../models/produit.dart';
import '../../../models_ui/model_produit.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  List<Produit> list_produits = [
    const Produit(
      productName: 'Œufs Poulet',
      productUnitPrice: 1500,
      productImagesPath: ['assets/images/oeuf2.png', 'assets/images/oeuf2.png'],
      varieteProduitList: [
        'Variation1',
        'Variation2',
        'Variation3',
        'Variation4'
      ],
      promotionValue: 'NON',
      stockValue: 15,
    ),
    const Produit(
      productName: 'Poulet Goliath',
      productUnitPrice: 7500,
      productImagesPath: [
        'assets/images/pouletCouveuse.png',
        'assets/images/oeuf2.png',
        'assets/images/pouletCouveuse.png',
        'assets/images/oeuf2.png',
      ],
      varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
      promotionValue: 'NON',
      stockValue: 150,
    ),
    const Produit(
      productName: 'Boeuf ayoussa',
      productUnitPrice: 250000,
      productImagesPath: ['assets/images/boeuf.png', 'assets/images/oeuf2.png'],
      varieteProduitList: [],
      promotionValue: 'NON',
      stockValue: 100,
    ),
    const Produit(
      productName: 'Œufs Poulet',
      productUnitPrice: 1500,
      productImagesPath: [
        'assets/images/pouletCouveuse.png',
        'assets/images/oeuf2.png',
        'assets/images/pouletCouveuse.png',
        'assets/images/oeuf2.png',
      ],
      promotionValue: 'NON',
      stockValue: 15,
    ),
    const Produit(
      productName: 'Poulet Goliath',
      productUnitPrice: 7500,
      productImagesPath: [
        'assets/images/pouletCouveuse.png',
        'assets/images/pouletCouveuse.png',
      ],
      varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
      promotionValue: 'NON',
      stockValue: 150,
    ),
    const Produit(
      productName: 'Œufs Poulet',
      productUnitPrice: 1500,
      productImagesPath: [
        'assets/images/oeuf2.png',
        'assets/images/oeuf2.png',
      ],
      varieteProduitList: [
        'Variation1',
        'Variation2',
        'Variation3',
        'Variation4'
      ],
      promotionValue: 'NON',
      stockValue: 15,
    ),
    const Produit(
      productName: 'Poulet Goliath',
      productUnitPrice: 7500,
      productImagesPath: [
        'assets/images/pouletCouveuse.png',
        'assets/images/oeuf2.png',
        'assets/images/pouletCouveuse.png',
        'assets/images/oeuf2.png',
      ],
      varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
      promotionValue: 'NON',
      stockValue: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
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
                            height: context.height * 0.13,
                            child: ModelProduit(
                                produit: list_produits[index],
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      //backgroundColor: Colors.transparent,
                                      showDragHandle: true,
                                      builder: (context) {
                                        ScrollController scrollController =
                                            ScrollController();

                                        CarouselSliderController
                                            carouselController =
                                            CarouselSliderController();
                                        int carouselCurrentIndex = 0;
                                        return SizedBox(
                                          height: context.height * 0.8,
                                          child: Column(
                                            children: [
                                              // image du produit
                                              Stack(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: CarouselSlider(
                                                      items: List.generate(
                                                          list_produits[index]
                                                              .productImagesPath!
                                                              .length,
                                                          (indexImagePath) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) {
                                                                  return PageView
                                                                      .builder(
                                                                          itemCount: list_produits[index]
                                                                              .productImagesPath!
                                                                              .length,
                                                                          controller:
                                                                              PageController(),
                                                                          onPageChanged:
                                                                              (newPageIndex) {
                                                                            context.read<ProductImagesPathIndexProvider>().indexProductImageNewValue(newPageIndex);
                                                                          },
                                                                          itemBuilder:
                                                                              (context, indexPage) {
                                                                            return Scaffold(
                                                                              body: Stack(
                                                                                alignment: Alignment.center,
                                                                                children: [
                                                                                  // image d'arrière-plan floutée
                                                                                  Positioned(
                                                                                    top: 0,
                                                                                    child: Image.asset(height: context.height, width: context.width, fit: BoxFit.cover, list_produits[index].productImagesPath![context.watch<ProductImagesPathIndexProvider>().indexProductImage]),
                                                                                  ),

                                                                                  // BlurryContainer qui a flouté l'image
                                                                                  Positioned(
                                                                                    top: 0,
                                                                                    child: BlurryContainer(
                                                                                      height: context.height,
                                                                                      width: context.width,
                                                                                      borderRadius: BorderRadius.circular(0),
                                                                                      blur: 50,
                                                                                      child: Container(
                                                                                          /*height: context.height,
                                                                              width: context.width,*/
                                                                                          ),
                                                                                    ),
                                                                                  ),

                                                                                  // image affichée
                                                                                  Positioned(
                                                                                    top: context.height * 0.25,
                                                                                    bottom: context.height * 0.25,
                                                                                    child: ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                      child: Image.asset(height: context.height * 0.5, width: context.width * 0.9, fit: BoxFit.cover, list_produits[index].productImagesPath![context.watch<ProductImagesPathIndexProvider>().indexProductImage]),
                                                                                    ),
                                                                                  ),

                                                                                  // bouton de retour et nom du produit
                                                                                  Positioned(
                                                                                    top: context.height * 0.08,
                                                                                    left: 10,
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(left: 12.0),
                                                                                      child: Row(
                                                                                        children: [
                                                                                          //bouton retour
                                                                                          GestureDetector(
                                                                                            onTap: () {
                                                                                              Navigator.pop(context);
                                                                                            },
                                                                                            child: Container(
                                                                                              alignment: Alignment.center,
                                                                                              height: context.height * 0.06,
                                                                                              width: context.height * 0.06,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  context.height,
                                                                                                ),
                                                                                              ),
                                                                                              child: Icon(
                                                                                                Icons.arrow_back_ios,
                                                                                                color: Theme.of(context).colorScheme.inversePrimary,
                                                                                                size: context.mediumText * 1.5,
                                                                                                weight: 100,
                                                                                              ),
                                                                                            ),
                                                                                          ),

                                                                                          SizedBox(
                                                                                            width: context.width * 0.03,
                                                                                          ),

                                                                                          // nom du produit
                                                                                          Container(
                                                                                            padding: EdgeInsets.only(top: 12, bottom: 12, right: 40, left: 40),
                                                                                            alignment: Alignment.center,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Theme.of(context).colorScheme.surface.withOpacity(0.2),
                                                                                              borderRadius: BorderRadius.circular(10),
                                                                                            ),
                                                                                            child: AppText(
                                                                                              text: list_produits[index].productName!,
                                                                                              fontWeight: FontWeight.w900,
                                                                                              fontSize: context.mediumText * 1.0,
                                                                                              color: Theme.of(context).colorScheme.surface,
                                                                                            ),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            );
                                                                          });
                                                                });
                                                          },
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child: Image.asset(
                                                              list_produits[index]
                                                                          .productImagesPath?[
                                                                      indexImagePath] ??
                                                                  'assets/icons/img.png',
                                                              fit: BoxFit.cover,
                                                              height: context
                                                                      .height *
                                                                  0.35,
                                                              width: context
                                                                      .width *
                                                                  0.9,
                                                              color: list_produits[index]
                                                                              .productImagesPath?[
                                                                          indexImagePath] ==
                                                                      null
                                                                  ? Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .surface
                                                                  : null,
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                      carouselController:
                                                          carouselController,
                                                      options: CarouselOptions(
                                                          autoPlay: true,
                                                          autoPlayCurve: Curves
                                                              .fastEaseInToSlowEaseOut,
                                                          aspectRatio: 9 / 5,
                                                          enlargeFactor: 0.5,
                                                          viewportFraction: 1,
                                                          onPageChanged:
                                                              (indexCarousel,
                                                                  CarouselPageChangedReason
                                                                      c) {
                                                            //return index;
                                                            context
                                                                .read<
                                                                    ProductImagesPathIndexProvider>()
                                                                .indexProductImageNewValue(
                                                                    indexCarousel);
                                                            /*setState(() {
                                                              carouselCurrentIndex =
                                                                  c.index;
                                                            });*/
                                                          }),
                                                    ),
                                                  ),

                                                  //dots indicator
                                                  Positioned(
                                                    bottom: 10,
                                                    left: context.width * 0.35,
                                                    right: context.width * 0.35,
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,

                                                      height: 20,
                                                      //width: context.width * 0.25,
                                                      decoration: BoxDecoration(
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .background
                                                              .withOpacity(0.7),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20)),
                                                      child:
                                                          PageViewDotIndicator(
                                                        currentItem: context
                                                            .watch<
                                                                ProductImagesPathIndexProvider>()
                                                            .indexProductImage,
                                                        count: list_produits[
                                                                index]
                                                            .productImagesPath!
                                                            .length,
                                                        size:
                                                            const Size(10, 10),
                                                        unselectedColor: Colors
                                                            .grey.shade600,
                                                        selectedColor: Colors
                                                            .grey.shade100,
                                                        onItemClicked:
                                                            (indexDot) {
                                                          context
                                                              .read<
                                                                  ProductImagesPathIndexProvider>()
                                                              .indexProductImageNewValue(
                                                                  indexDot);
                                                          carouselController
                                                              .animateToPage(context
                                                                  .read<
                                                                      ProductImagesPathIndexProvider>()
                                                                  .indexProductImage);

                                                          /*setState(() {

                                                            carouselCurrentIndex =
                                                                indexDot;
                                                            carouselController
                                                                .animateToPage(
                                                                    carouselCurrentIndex);
                                                          });*/
                                                        },
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),

                                              //text Détail
                                              AppText(
                                                text: 'Détails du produit',
                                                fontSize: largeText(),
                                              ),

                                              //Nom du produit et variétés
                                              ListTile(
                                                // nom du produit
                                                title: AppText(
                                                  text: list_produits[index]
                                                      .productName!,
                                                  fontSize: context.mediumText,
                                                  fontWeight: FontWeight.w900,
                                                ),

                                                // variétés du produit
                                                subtitle: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0,
                                                          bottom: 8.0),
                                                  child: SizedBox(
                                                    height:
                                                        context.height * 0.06,
                                                    child: Scrollbar(
                                                      controller:
                                                          scrollController,
                                                      thumbVisibility: true,
                                                      trackVisibility: true,
                                                      radius:
                                                          const Radius.circular(
                                                              10),
                                                      thickness: 2,
                                                      child: ListView.builder(
                                                          controller:
                                                              scrollController,
                                                          physics:
                                                              const BouncingScrollPhysics(),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount: list_produits[
                                                                  index]
                                                              .varieteProduitList!
                                                              .length,
                                                          itemBuilder: (context,
                                                              indexVariete) {
                                                            return ModelSecteur(
                                                                text: list_produits[index]
                                                                    .varieteProduitList![
                                                                        indexVariete]
                                                                    .toString(),
                                                                isSelected:
                                                                    true,
                                                                activeColor: AppColors
                                                                    .primaryColor
                                                                    .withOpacity(
                                                                        0.4),
                                                                textColor: AppColors
                                                                    .primaryColor,
                                                                disabledColor:
                                                                    Colors.grey,
                                                                onTap: () {});
                                                          }),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // prix et stock

                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0, right: 16.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    //prix
                                                    Expanded(
                                                      flex: 2,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // prix
                                                          AppText(
                                                              text: 'Prix : '),
                                                          AppText(
                                                            text:
                                                                '${list_produits[index].productUnitPrice} FCFA',
                                                            fontSize: context
                                                                .mediumText,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    //stock
                                                    Flexible(
                                                      flex: 1,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          // stock
                                                          AppText(
                                                              text: 'Stock : '),
                                                          AppText(
                                                            text:
                                                                '${list_produits[index].stockValue}',
                                                            fontSize: context
                                                                .mediumText,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Edit et supprimer
                                              const SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  // supprimer
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: AppColors
                                                        .redColor
                                                        .withOpacity(0.15),
                                                    child: IconButton(
                                                        onPressed: () {
                                                          Get.defaultDialog(
                                                            title:
                                                                'Suppression',
                                                            content: AppText(
                                                                text:
                                                                    'Voulez-vous vraiment supprimer ce produit ?'),
                                                            confirm: AppButton(
                                                                width: context
                                                                        .width *
                                                                    0.3,
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: AppText(
                                                                  text: 'Non',
                                                                  color: AppColors
                                                                      .primaryColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                )),
                                                            cancel: AppButton(
                                                                width: context
                                                                        .width *
                                                                    0.3,
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: AppText(
                                                                    text: 'Oui',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    color: AppColors
                                                                        .redColor)),
                                                            contentPadding:
                                                                const EdgeInsets
                                                                    .all(20),
                                                          );
                                                        },
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: AppColors
                                                              .redColor,
                                                          size: 30,
                                                        )),
                                                  ),

                                                  // edit
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: AppColors
                                                        .blueColor
                                                        .withOpacity(0.15)
                                                    /*Theme.of(context)
                                                            .colorScheme
                                                            .background*/
                                                    ,
                                                    child: IconButton(
                                                        onPressed: () {},
                                                        icon: Icon(
                                                          Icons.edit_calendar,
                                                          color: AppColors
                                                              .blueColor,
                                                          size: 30,
                                                        )),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                })));
                  }),
            ),
          ],
        ),
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          height: context.height * 0.07,
          color: Theme.of(context).colorScheme.background,
          onTap: (index) {
            // index ;
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
      ),
    );
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
