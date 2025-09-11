import 'package:benin_poulet/bloc/product/product_bloc.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/utils/dialog.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/produits_categories/ajoutNouveauProduitPage.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../models/produit.dart';
import '../views/colors/app_colors.dart';
import '../views/models_ui/model_produit.dart';
import '../views/models_ui/model_secteur.dart';
import '../views/pages/vendeur_pages/produits_categories/productsList.dart';
import '../widgets/app_text.dart';

class ProductServices {
  static int _getValidCurrentItem(int currentItem, int count) {
    if (count == 0) return 0;
    if (currentItem < 0) return 0;
    if (currentItem >= count) return count - 1;
    return currentItem;
  }

  //==============================
  //AFFICHAGE DE PRODUIT DANS L'UI
  //==============================
  static Widget showProducts(BuildContext context, List<Produit> list) {
    return Scaffold(
      body: list.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    color: AppColors.primaryColor,
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    edgeOffset: 40,
                    onRefresh: () async {
                      //TODO : actualiser la liste des produits
                    },
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 0),
                              child: SizedBox(
                                  height: context.height * 0.13,
                                  child: ModelProduit(
                                      produit: list[index],
                                      onTap: () {
                                        context
                                            .read<
                                                ProductImagesPathIndexProvider>()
                                            .indexProductImageInitialize();

                                        showModalBottomSheet(
                                            context: context,
                                            isScrollControlled: true,
                                            useSafeArea: true,
                                            //backgroundColor: Colors.transparent,
                                            showDragHandle: true,
                                            builder: (context) {
                                              ScrollController
                                                  scrollController =
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
                                                              BorderRadius
                                                                  .circular(10),
                                                          child: CarouselSlider(
                                                            items: List.generate(
                                                                list[index]
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
                                                                        return PageView.builder(
                                                                            itemCount: list[index].productImagesPath!.length,
                                                                            controller: PageController(),
                                                                            onPageChanged: (newPageIndex) {
                                                                              context.read<ProductImagesPathIndexProvider>().indexProductImageNewValue(newPageIndex);
                                                                            },
                                                                            itemBuilder: (context, indexPage) {
                                                                              return Scaffold(
                                                                                body: Stack(
                                                                                  alignment: Alignment.center,
                                                                                  children: [
                                                                                    // image d'arrière-plan floutée
                                                                                    Positioned(
                                                                                      top: 0,
                                                                                      child: Image.asset(height: context.height, width: context.width, fit: BoxFit.cover, list[index].productImagesPath![context.watch<ProductImagesPathIndexProvider>().indexProductImage]),
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
                                                                                      top: context.height * 0.15,
                                                                                      bottom: context.height * 0.15,
                                                                                      child: ClipRRect(
                                                                                        borderRadius: BorderRadius.circular(20),
                                                                                        child: Image.asset(height: context.height * 0.7, width: context.width * 0.9, list[index].productImagesPath![context.watch<ProductImagesPathIndexProvider>().indexProductImage]),
                                                                                      ),
                                                                                    ),

                                                                                    // bouton de retour et nom du produit
                                                                                    Positioned(
                                                                                      top: context.height * 0.08,
                                                                                      left: 10,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(left: 12.0),
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                                                    10,
                                                                                                  ),
                                                                                                ),
                                                                                                child: Icon(
                                                                                                  Icons.arrow_back_outlined,
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
                                                                                              width: context.width * 0.7,
                                                                                              padding: EdgeInsets.only(top: 12, bottom: 12, right: 40, left: 40),
                                                                                              alignment: Alignment.center,
                                                                                              decoration: BoxDecoration(
                                                                                                color: Theme.of(context).colorScheme.surface.withOpacity(0.4),
                                                                                                borderRadius: BorderRadius.circular(10),
                                                                                              ),
                                                                                              child: AppText(
                                                                                                text: list[index].productName!,
                                                                                                fontWeight: FontWeight.w900,
                                                                                                fontSize: context.mediumText * 1.0,
                                                                                                color: Theme.of(context).colorScheme.inversePrimary,
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
                                                                child:
                                                                    ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  child: Image
                                                                      .asset(
                                                                    list[index].productImagesPath?[
                                                                            indexImagePath] ??
                                                                        'assets/icons/img.png',
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    height: context
                                                                            .height *
                                                                        0.35,
                                                                    width: context
                                                                            .width *
                                                                        0.9,
                                                                    color: list[index].productImagesPath?[indexImagePath] ==
                                                                            null
                                                                        ? Theme.of(context)
                                                                            .colorScheme
                                                                            .surface
                                                                        : null,
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                            carouselController:
                                                                carouselController,
                                                            options:
                                                                CarouselOptions(
                                                                    autoPlay:
                                                                        true,
                                                                    autoPlayCurve:
                                                                        Curves
                                                                            .fastEaseInToSlowEaseOut,
                                                                    aspectRatio:
                                                                        9 / 5,
                                                                    enlargeFactor:
                                                                        0.5,
                                                                    viewportFraction:
                                                                        1,
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
                                                          left: context.width *
                                                              0.35,
                                                          right: context.width *
                                                              0.35,
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,

                                                            height: 20,
                                                            //width: context.width * 0.25,
                                                            decoration: BoxDecoration(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .background
                                                                    .withOpacity(
                                                                        0.7),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20)),
                                                            child: list[index]
                                                                    .productImagesPath
                                                                    .isNotEmpty
                                                                ? PageViewDotIndicator(
                                                                    currentItem:
                                                                        _getValidCurrentItem(
                                                                      context
                                                                          .watch<
                                                                              ProductImagesPathIndexProvider>()
                                                                          .indexProductImage,
                                                                      list[index]
                                                                          .productImagesPath
                                                                          .length,
                                                                    ),
                                                                    count: list[
                                                                            index]
                                                                        .productImagesPath
                                                                        .length,
                                                                    size:
                                                                        const Size(
                                                                            10,
                                                                            10),
                                                                    unselectedSize:
                                                                        const Size(
                                                                            7,
                                                                            7),
                                                                    unselectedColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade600,
                                                                    selectedColor:
                                                                        Colors
                                                                            .grey
                                                                            .shade100,
                                                                    onItemClicked:
                                                                        (indexDot) {
                                                                      context
                                                                          .read<
                                                                              ProductImagesPathIndexProvider>()
                                                                          .indexProductImageNewValue(
                                                                              indexDot);
                                                                      carouselController.animateToPage(context
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
                                                                  )
                                                                : const SizedBox
                                                                    .shrink(),
                                                          ),
                                                        )
                                                      ],
                                                    ),

                                                    SizedBox(
                                                      height: 10,
                                                    ),

                                                    //text Variantes
                                                    AppText(
                                                      text: list[index]
                                                          .productName!,
                                                      fontSize:
                                                          context.largeText,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),

                                                    //Nom du produit et variantes
                                                    ListTile(
                                                      // nom du produit
                                                      title: AppText(
                                                        text: "Variantes",
                                                        fontSize:
                                                            context.smallText,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: Colors.grey,
                                                      ),

                                                      // variantes du produit
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 8.0,
                                                                bottom: 8.0),
                                                        child: SizedBox(
                                                          height:
                                                              context.height *
                                                                  0.06,
                                                          child: Scrollbar(
                                                            controller:
                                                                scrollController,
                                                            thumbVisibility:
                                                                true,
                                                            trackVisibility:
                                                                true,
                                                            radius: const Radius
                                                                .circular(10),
                                                            thickness: 2,
                                                            child: ListView
                                                                .builder(
                                                                    controller:
                                                                        scrollController,
                                                                    physics:
                                                                        const BouncingScrollPhysics(),
                                                                    scrollDirection:
                                                                        Axis
                                                                            .horizontal,
                                                                    itemCount: list[index].varieties!.length !=
                                                                            0
                                                                        ? list[index]
                                                                            .varieties!
                                                                            .length
                                                                        : 1,
                                                                    itemBuilder:
                                                                        (context,
                                                                            indexVariete) {
                                                                      return list[index].varieties!.length !=
                                                                              0
                                                                          ? ModelSecteur(
                                                                              text: list[index].varieties![indexVariete].toString(),
                                                                              isSelected: true,
                                                                              activeColor: AppColors.primaryColor.withOpacity(0.4),
                                                                              textColor: AppColors.primaryColor,
                                                                              disabledColor: Colors.grey,
                                                                              contentAligment: Alignment.center,
                                                                              onTap: () {})
                                                                          : ModelSecteur(text: 'Standard', isSelected: true, activeColor: AppColors.primaryColor.withOpacity(0.4), textColor: AppColors.primaryColor, disabledColor: Colors.grey, contentAligment: Alignment.center, onTap: () {});
                                                                    }),
                                                          ),
                                                        ),
                                                      ),

                                                      minTileHeight: 0,
                                                      horizontalTitleGap: 0,
                                                      minVerticalPadding: 0,
                                                    ),

                                                    // prix et stock
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0),
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
                                                                    text:
                                                                        'Prix : '),
                                                                AppText(
                                                                  text:
                                                                      '${list[index].productUnitPrice} FCFA',
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
                                                                    text:
                                                                        'Stock : '),
                                                                AppText(
                                                                  text:
                                                                      '${list[index].stockValue}',
                                                                  fontSize: context
                                                                      .mediumText,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),

                                                    //description produit
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              right: 5.0,
                                                              left: 5.0,
                                                              bottom: 15),
                                                      child: SizedBox(
                                                        height: context.height *
                                                            0.15,
                                                        child: ListTile(
                                                          title: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    bottom:
                                                                        8.0),
                                                            child: AppText(
                                                              text:
                                                                  "Description",
                                                              fontSize: context
                                                                  .smallText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          subtitle: Scrollbar(
                                                            thumbVisibility:
                                                                true,
                                                            trackVisibility:
                                                                true,
                                                            child:
                                                                SingleChildScrollView(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8.0),
                                                                child: AppText(
                                                                  text: list[
                                                                          index]
                                                                      .productDescription,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .visible,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),

                                                    // Edit et supprimer
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: context.height *
                                                              0.03),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          // supprimer
                                                          CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                AppColors
                                                                    .redColor
                                                                    .withOpacity(
                                                                        0.15),
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  AppDialog.showDialog(
                                                                      context: context,
                                                                      title: 'Suppression',
                                                                      content: 'Voulez-vous vraiment supprimer ce produit ?',
                                                                      confirmText: 'Oui',
                                                                      cancelText: 'Non',
                                                                      onConfirm: () async {
                                                                        // Supprimer le produit
                                                                        try {
                                                                          context
                                                                              .read<ProductBloc>()
                                                                              .add(DeleteProduct(list[index].productId!));
                                                                          Navigator.pop(
                                                                              context);

                                                                          showMessage(
                                                                            context:
                                                                                context,
                                                                            message:
                                                                                'Produit supprimé avec succès',
                                                                            backgroundColor:
                                                                                AppColors.primaryColor,
                                                                          );
                                                                        } catch (e) {
                                                                          showMessage(
                                                                            context:
                                                                                context,
                                                                            message:
                                                                                'Erreur lors de la suppression: $e',
                                                                            backgroundColor:
                                                                                AppColors.redColor,
                                                                          );
                                                                        }
                                                                      });
                                                                },
                                                                icon: Icon(
                                                                  Icons.delete,
                                                                  color: AppColors
                                                                      .redColor,
                                                                  size: 25,
                                                                )),
                                                          ),

                                                          // edit
                                                          CircleAvatar(
                                                            radius: 25,
                                                            backgroundColor:
                                                                AppColors
                                                                    .blueColor
                                                                    .withOpacity(
                                                                        0.15)
                                                            /*Theme.of(context)
                                                                .colorScheme
                                                                .background*/
                                                            ,
                                                            child: IconButton(
                                                                onPressed: () {
                                                                  // Rediriger vers la page d'ajout de produit avec les données préremplies
                                                                  Navigator
                                                                      .pushNamed(
                                                                    context,
                                                                    AppRoutes
                                                                        .AJOUTNOUVEAUPRODUITPAGE,
                                                                    arguments: {
                                                                      'isEditing':
                                                                          true,
                                                                      'product':
                                                                          list[
                                                                              index],
                                                                    },
                                                                  );
                                                                },
                                                                icon: Icon(
                                                                  Icons
                                                                      .edit_calendar,
                                                                  color: AppColors
                                                                      .blueColor,
                                                                  size: 25,
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      })));
                        }),
                  ),
                ),
              ],
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lotties/animatedSearchLottie.json'),
                    AppText(
                      text: 'Aucun produit disponible',
                      fontSize: context.mediumText * 1.1,
                      color: Colors.grey,
                    )
                  ],
                ),
              ),
            ),
    );
  }

  //==============================================
  //FONCTION D'AJOUT DE NOUVEAU PRODUIT À FIREBASE
  //==============================================

  //==============================================
  //FONCTION DE RÉCUPÉRATION DES PRODUITS DU VENDEUR
  //==============================================
  static Stream<List<Produit>> getVendorProducts() {
    final currentUserId = AuthServices.userId;
    if (currentUserId == null) {
      print(
          ":::::::::::::::ERREUR : Aucun utilisateur connecté :::::::::::::::::");
      return Stream.value([]);
    }

    print(
        ":::::::::::::::RÉCUPÉRATION PRODUITS : sellerId=$currentUserId :::::::::::::::::");
    return ProductRepository().getProductsBySeller(currentUserId);
  }

  static Future<void> updateProduct(
      BuildContext context, Produit product) async {
    try {
      if (product.productId == null) {
        AppUtils.showErrorNotification(
            context, 'Erreur: ID du produit manquant', null);
        return;
      }

      // Utiliser le ProductBloc pour mettre à jour le produit
      context.read<ProductBloc>().add(UpdateProduct(product.productId!, {
            'name': product.productName,
            'description': product.productDescription,
            'category': product.category,
            'subCategory': product.subCategory,
            'price': product.productUnitPrice,
            'stock': product.stockValue,
            'isInPromotion': product.isInPromotion,
            'promoPrice': product.promoPrice,
            'properties': product.productProperties,
            'varieties': product.varieties,
          }));
      AppUtils.showSuccessNotification(
        context,
        'Produit "${product.productName}" mis à jour avec succès.',
      );
    } catch (e) {
      AppUtils.showErrorNotification(
          context, 'Erreur lors de la mise à jour du produit: $e', null);
    }
  }

  static Future<void> addProduct(BuildContext context, Produit product) async {
    try {
      // Vérifications individuelles pour des messages clairs
      if (product.productName.trim().isEmpty) {
        AppUtils.showErrorNotification(
            context, 'Veuillez renseigner le nom du produit.', null);

        return;
      }

      if (product.category.trim().isEmpty) {
        AppUtils.showErrorNotification(context,
            'Veuillez sélectionner une catégorie pour le produit.', null);
        return;
      }

      if (product.productUnitPrice <= 0) {
        AppUtils.showInfoNotification(
          context,
          'Le prix unitaire doit être supérieur à 0.',
        );

        return;
      }

      if (product.stockValue <= 0) {
        AppUtils.showInfoNotification(
          context,
          'La quantité en stock doit être supérieure à 0.',
        );
        return;
      }

      // Gestion des cas de promotion
      if (product.isInPromotion == true) {
        if (product.promoPrice == null || product.promoPrice! <= 0) {
          AppUtils.showErrorNotification(
              context, 'Veuillez définir un prix promotionnel valide.', null);

          return;
        }

        if (product.promoPrice! >= product.productUnitPrice) {
          AppUtils.showErrorNotification(
              context,
              'Le prix promotionnel doit être inférieur au prix unitaire.',
              null);
          return;
        }
      }

      // Tout est bon → Envoi vers la base de données (désactivé pour l’instant)
      // Vérification du sellerId (CRITIQUE)
      final currentUserId = AuthServices.auth.currentUser?.uid;
      if (currentUserId == null) {
        AppUtils.showErrorNotification(
            context, 'Erreur: Aucun utilisateur connecté', null);
        return;
      }

      // Utiliser le ProductBloc pour ajouter le produit
      context.read<ProductBloc>().add(AddProduct(product));

      AppUtils.showSuccessNotification(
        context,
        'Produit "${product.productName}" ajouté avec succès.',
      );
    } catch (e) {
      print(":::::::::::::::ERREUR : $e :::::::::::::::::");
      AppUtils.showErrorNotification(
          context, 'Erreur lors de l\'ajout du produit: $e', null);
    }
  }
}
