import 'package:benin_poulet/core/firebase/firestore/product_repository.dart'
    show FirestoreProductService;
import 'package:benin_poulet/models/produit.dart';
import 'package:benin_poulet/utils/dialog.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';
import 'package:reorderables/reorderables.dart';

import '../../../colors/app_colors.dart';

class AjoutNouveauProduitPage extends StatefulWidget {
  const AjoutNouveauProduitPage({super.key});

  @override
  State<AjoutNouveauProduitPage> createState() =>
      _AjoutNouveauProduitPageState();
}

class _AjoutNouveauProduitPageState extends State<AjoutNouveauProduitPage> {
  Color color = Colors.white;

  Future<List<ImageFile>> pickImagesUsingImagePicker(int pickCount) async {
    final picker = ImagePicker();
    final List<XFile> xFiles;
    if (pickCount > 1) {
      xFiles = await picker.pickMultiImage(
          maxWidth: 1080, maxHeight: 1080, limit: pickCount);
    } else {
      xFiles = [];
      final xFile = await picker.pickImage(
          source: ImageSource.gallery, maxHeight: 1080, maxWidth: 1080);
      if (xFile != null) {
        xFiles.add(xFile);
      }
    }
    if (xFiles.isNotEmpty) {
      return xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
    }
    return [];
  }

  late final multiImagePickerController;
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController prixUnitaireController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();
  TextEditingController promoPrixController = TextEditingController();
  TextEditingController varieteController = TextEditingController();

  final List<String> _categories = [
    'Volaille',
    'Bétaille',
    'Restaurant',
    'Pisciculture'
  ];

  Map<String, String> proprietes = {};

  List<String> varietes = [];

  String _categorySelected = 'Volaille';

  String _sousCategorySelected = 'Poulet';

  int _quantite = 0;

  bool isProductInPromotion = false;

  void incrementerQuantite() {
    setState(() {
      int valeurActuelle = int.tryParse(quantiteController.text) ?? 0;
      valeurActuelle++;
      quantiteController.text = valeurActuelle.toString();
    });
  }

  void decrementerQuantite() {
    int valeurActuelle = int.tryParse(quantiteController.text) ?? 0;
    if (valeurActuelle > 0) {
      setState(() {
        valeurActuelle--;
        quantiteController.text = valeurActuelle.toString();
      });
    }
  }

  final List<String> _sousCategoriesVolaille = [
    'Poulet',
    'Dindon',
    'Pintage',
    'Canard'
  ];
  final List<String> _sousCategoriesBetaille = ['Mouton', 'Boeuf', 'Porc'];
  final List<String> _sousCategoriesRestaurant = [
    'Poulet rôti',
    'Lapin braisé',
    'Porc sec',
    'Schawama'
  ];
  final List<String> _sousCategoriesPisciculture = [
    'Tilapia',
    'Faux bar',
    'Vrai bar',
    'Carpe'
  ];

  String category = '';

  String sousCategory = '';

  final TextEditingController proprieteController = TextEditingController();
  final TextEditingController valeurProprieteController =
      TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    quantiteController.text = '0';

    multiImagePickerController = MultiImagePickerController(
        maxImages: 10,
        picker: (int pickCount, Object? params) async {
          return await pickImagesUsingImagePicker(pickCount);
          /*picker: (allowMultiple) async {
          return await pickImagesUsingImagePicker(allowMultiple);*/
        });
  }

  @override
  Widget build(BuildContext context) {
    var divider = Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.2)),
    );
    Produit produit = Produit(
      productName: productNameController.text,
      productDescription: productDescriptionController.text,
      category: _categorySelected,
      subCategory: _sousCategorySelected,
      productUnitPrice: double.tryParse(prixUnitaireController.text),
      stockValue: int.tryParse(quantiteController.text),
      isInPromotion: isProductInPromotion,
      promoPrice: double.tryParse(promoPrixController.text),
      productProperties: proprietes,
      varieties: varietes,
      //productImagesPath: multiImagePickerController.images,
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            text: 'Ajouter Produit',
          ),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Hero(
                tag: 'ajoutProduit',
                child: AppButton(
                    width: context.width * 0.22,
                    height: context.height * 0.045,
                    bordeurRadius: 25,
                    color: AppColors.primaryColor,
                    child: AppText(
                      text: 'Ajouter',
                      fontSize: context.smallText * 1.2,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      // TODO : ajouter le produit

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AppText(
                            text:
                                'Produit ${produit.productName} ajouté avec succès',
                            //color: Colors.white,
                            overflow: TextOverflow.visible,
                          ),
                          duration: Duration(seconds: 6),
                          showCloseIcon: true,
                          //backgroundColor: AppColors.greenColor,
                        ),
                      );

                      await FirestoreProductService().addProduct(produit);
                    }),
              ),
            )
          ],
        ),
        body: ListView(
          //physics: BouncingScrollPhysics(),
          children: [
            /// images multiples
            SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: MultiImagePickerView(
                  controller: multiImagePickerController,
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  addMoreButton: DefaultAddMoreWidget(
                    icon: Icon(
                      Icons.add,
                      size: 30,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.4),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.background,
                  ),
                  initialWidget: DefaultInitialWidget(
                    centerWidget: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 50,
                          color: Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withOpacity(0.3),
                        ),
                        AppText(
                          text: 'Ajouter des images du produit',
                          fontSize: context.smallText,
                          color: Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withOpacity(0.3),
                        )
                      ],
                    ),
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .background
                        .withOpacity(0.9),
                  ),
                ),
              ),
            ),

            /// nom - catégorie - sous-catégorie
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: context.height * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.5))),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.height * 0.02,
                    ),

                    /// nom
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: SizedBox(
                        //height: context.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppText(
                              text: 'Nom : ',
                              fontWeight: FontWeight.w800,
                            ),
                            Expanded(
                              child: AppTextField(
                                contentPadding: EdgeInsets.zero,
                                //width: context.width * 0.7,
                                maxLines: 1,
                                controller: productNameController,
                                isPrefixIconWidget: true,
                                showFloatingLabel: false,
                                alignment: Alignment.centerRight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,

                    /// catégorie
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(
                            text: 'Catégorie : ',
                            fontWeight: FontWeight.w800,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            height: context.height * 0.05,
                            width: context.width * 0.4,
                            child: DropdownButton<String>(
                              icon: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: context.mediumText,
                                  )
                                ],
                              ),
                              underline: Container(),
                              value: _categorySelected,
                              //focusColor: AppColors.primaryColor,
                              items: List.generate(_categories.length, (index) {
                                return DropdownMenuItem<String>(
                                  value: _categories[index],
                                  child: AppText(
                                    text: _categories[index],
                                  ),
                                );
                              }),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _categorySelected = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    divider,

                    ///Sous-catégorie
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(
                            text: 'Sous-catégorie : ',
                            fontWeight: FontWeight.w800,
                          ),
                          Container(
                            alignment: Alignment.bottomRight,
                            height: context.height * 0.05,
                            width: context.width * 0.4,
                            child: DropdownButton<String>(
                              underline: Container(),
                              icon: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: context.mediumText,
                                  )
                                ],
                              ),
                              alignment: AlignmentDirectional.bottomEnd,
                              value: _sousCategorySelected,
                              items: List.generate(
                                  _sousCategoriesVolaille.length, (index) {
                                return DropdownMenuItem<String>(
                                  value: _sousCategoriesVolaille[index],
                                  child: AppText(
                                    text: _sousCategoriesVolaille[index],
                                  ),
                                );
                              }),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _sousCategorySelected = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    divider,

                    /*const SizedBox(
                      height: 10,
                    ),*/

                    /// Description du produit
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: SizedBox(
                        //height: context.height * 0.21,
                        width: context.width * 0.9,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: 'Description (optionnel) : ',
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.6),
                            ),
                            AppTextField(
                                alignment: Alignment.topLeft,
                                contentPadding: EdgeInsets.zero,
                                //height: context.height * 0.18,
                                width: context.width * 0.98,
                                isPrefixIconWidget: true,
                                minLines: 3,
                                maxLines: 10,
                                fontSize: context.smallText * 1.1,
                                //keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.newline,
                                controller: productDescriptionController),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Prix et stock
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 16.0, bottom: 8.0),
              child: AppText(
                text: 'Prix et Stock',
                fontWeight: FontWeight.w800,
                fontSize: context.mediumText,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: context.height * 0.3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.5))),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.height * 0.02,
                    ),

                    /// prix
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: AppText(
                                text: 'Prix unitaire : ',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Expanded(
                              child: AppTextField(
                                  alignment: Alignment.topRight,
                                  contentPadding: const EdgeInsets.only(
                                    left: 8.0,
                                  ),
                                  isPrefixIconWidget: true,
                                  keyboardType: TextInputType.number,
                                  suffixIcon: AppText(
                                    text: 'F CFA',
                                  ),
                                  minLines: 1,
                                  maxLines: 2,
                                  controller: prixUnitaireController),
                            ),
                          ],
                        ),
                      ),
                    ),
                    divider,

                    /// quantité en stock
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: SizedBox(
                        height: context.height * 0.07,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AppText(
                                text: 'Quantité en stock : ',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(
                              width: context.width * 0.45,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    onPressed: decrementerQuantite,
                                    icon: const Icon(Icons.remove_circle),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: quantiteController,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                      ),
                                      onChanged: (s) {
                                        // éviter les entrées vites (mettre 0 à la place d'un champ vite)
                                        if (quantiteController.text.trim() ==
                                            '') {
                                          setState(() {
                                            quantiteController.text = "0";
                                          });
                                        }

                                        // éviter les Zeros inutils au début (02 => 2)
                                        if (quantiteController.text.length >
                                                1 &&
                                            quantiteController.text
                                                .startsWith('0')) {
                                          setState(() {
                                            quantiteController.text =
                                                quantiteController.text
                                                    .replaceFirst(
                                                        RegExp(r'^0+'), '');
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: incrementerQuantite,
                                    icon: const Icon(Icons.add_circle),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Etat promotionnel du produit
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 16.0, bottom: 8.0),
              child: AppText(
                text: 'Promotion',
                fontWeight: FontWeight.w800,
                fontSize: context.mediumText,
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 8.0, left: 8.0, bottom: 16.0),
              child: Container(
                //height: context.height * 0.3,
                padding: const EdgeInsets.only(bottom: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.5))),
                child: Column(
                  children: [
                    SizedBox(
                      height: context.height * 0.02,
                    ),

                    /// case à cocher
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: SizedBox(
                        height: context.height * 0.05,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: AppText(
                                text: 'Ce produit est-il en promotion ?',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Switch(
                                value: isProductInPromotion,
                                activeColor: AppColors.primaryColor,
                                activeTrackColor:
                                    AppColors.primaryColor.withOpacity(0.4),
                                inactiveThumbColor: Theme.of(context)
                                    .colorScheme
                                    .inverseSurface
                                    .withOpacity(0.5),
                                inactiveTrackColor:
                                    Theme.of(context).colorScheme.background,
                                onChanged: (v) {
                                  setState(() {
                                    isProductInPromotion = v;
                                  });
                                }),
                          ],
                        ),
                      ),
                    ),

                    isProductInPromotion
                        ? divider
                            .animate(delay: Duration(milliseconds: 200))
                            .flipH()
                        : SizedBox(),

                    /// Prix promotionnel
                    isProductInPromotion
                        ? Padding(
                            padding: const EdgeInsets.only(
                              top: 4.0,
                              left: 8.0,
                              right: 8.0,
                              bottom: 6.0,
                            ),
                            child: SizedBox(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  //text
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: AppText(
                                      text: 'Prix promo : ',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),

                                  //champ de saisie du prix promotionnel
                                  Expanded(
                                    child: AppTextField(
                                        alignment: Alignment.topRight,
                                        contentPadding: const EdgeInsets.only(
                                          left: 8.0,
                                        ),
                                        isPrefixIconWidget: true,
                                        keyboardType: TextInputType.number,
                                        suffixIcon: AppText(
                                          text: 'F CFA',
                                        ),
                                        minLines: 1,
                                        maxLines: 2,
                                        controller: promoPrixController),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(delay: Duration(milliseconds: 110)).flipH()
                        : SizedBox(height: 12),
                  ],
                ),
              ),
            ),

            /// Propriétés du produit
            ListTile(
              minTileHeight: 0,
              contentPadding: const EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 16.0, bottom: 0.0),
              title: AppText(
                text: 'Propriétés',
                fontWeight: FontWeight.w800,
                fontSize: context.mediumText,
              ),
              subtitle: AppText(
                text: 'Ajouter le poids, la race, etc. si nécessaire',
                fontWeight: FontWeight.w800,
                fontSize: context.smallText * 0.9,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4),
              ),
              trailing: AppButton(
                  borderColor: AppColors.primaryColor,
                  height: context.height * 0.035,
                  width: context.width * 0.15,
                  bordeurRadius: 7,
                  color: Colors.transparent,
                  child: AppText(
                    text: '+',
                    color: AppColors.primaryColor,
                    fontSize: context.mediumText * 1.1,
                    fontWeight: FontWeight.bold,
                  ) //Theme.of(context).colorScheme.surface.w,
                  ),
              onTap: () {
                proprieteController.clear();
                valeurProprieteController.clear();
                showFormBottomSheet(context,
                    title: 'Ajouter une propriété',
                    subtitle: 'Ex : Poids, Race, Couleur, etc.',
                    proprieteController: proprieteController,
                    valeurProprieteController: valeurProprieteController,
                    onConfirmAdd: () {
                  setState(() {
                    if (proprieteController.text.isNotEmpty &&
                        valeurProprieteController.text.isNotEmpty) {
                      proprietes[proprieteController.text] =
                          valeurProprieteController.text;
                      proprieteController.clear();
                      valeurProprieteController.clear();
                      Navigator.pop(context);
                    } else if (proprieteController.text.trim().isEmpty ||
                        valeurProprieteController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AppText(
                            text:
                                'Veuillez remplir tous les champs : la propriété et sa valeur',
                            color: Colors.white,
                            overflow: TextOverflow.visible,
                          ),
                          duration: Duration(seconds: 6),
                          showCloseIcon: true,
                          backgroundColor: AppColors.redColor,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  });
                });
              },
            ),

            proprietes.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 8.0, left: 8.0, bottom: 16.0),
                    child: Container(
                      //height: context.height * 0.3,
                      //width: context.width * 0.9,
                      padding: const EdgeInsets.only(bottom: 2.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.5))),
                      child: Column(
                        children: [
                          SizedBox(
                            height: context.height * 0.02,
                          ),
                          ReorderableListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: proprietes.length,
                            buildDefaultDragHandles: true,
                            primary: true,
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            itemBuilder: (context, index) {
                              final entry = proprietes.entries.toList()[index];

                              return SizedBox(
                                key: ValueKey(entry
                                    .key), // Obligatoire pour ReorderableListView
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: GestureDetector(
                                            onTap: () {
                                              AppDialog.showDialog(
                                                context: context,
                                                title: 'Suppression',
                                                content:
                                                    'Voulez-vous vraiment supprimer la propriété ${entry.key} ?',
                                                confirmText: 'Oui',
                                                cancelText: 'Non',
                                                onConfirm: () {
                                                  setState(() {
                                                    proprietes
                                                        .remove(entry.key);
                                                  });
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              child: Icon(
                                                Icons.delete,
                                                color: AppColors.redColor,
                                                size: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 10,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  flex: 5,
                                                  child: AppText(
                                                    text: '${entry.key} : ',
                                                    fontWeight: FontWeight.w900,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: AppText(
                                                    text: entry.value,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        context.mediumText *
                                                            0.75,
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: IconButton(
                                            onPressed: () {
                                              proprieteController.text =
                                                  entry.key;
                                              valeurProprieteController.text =
                                                  entry.value;

                                              showFormBottomSheet(
                                                context,
                                                title: 'Modifier une propriété',
                                                subtitle:
                                                    'Ex : Poids, Race, Couleur, etc.',
                                                proprieteController:
                                                    proprieteController,
                                                valeurProprieteController:
                                                    valeurProprieteController,
                                                onConfirmAdd: () {
                                                  if (proprieteController
                                                          .text.isNotEmpty &&
                                                      valeurProprieteController
                                                          .text.isNotEmpty) {
                                                    setState(() {
                                                      proprietes[
                                                              proprieteController
                                                                  .text] =
                                                          valeurProprieteController
                                                              .text;
                                                      if (entry.key !=
                                                          proprieteController
                                                              .text) {
                                                        proprietes
                                                            .remove(entry.key);
                                                      }
                                                      proprieteController
                                                          .clear();
                                                      valeurProprieteController
                                                          .clear();
                                                    });
                                                  } else if (proprieteController
                                                          .text
                                                          .trim()
                                                          .isEmpty ||
                                                      valeurProprieteController
                                                          .text
                                                          .trim()
                                                          .isEmpty) {
                                                    setState(() {
                                                      proprietes
                                                          .remove(entry.key);
                                                      proprieteController
                                                          .clear();
                                                      valeurProprieteController
                                                          .clear();
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.edit,
                                              color: AppColors.primaryColor,
                                              size: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    index != proprietes.length - 1
                                        ? divider
                                        : SizedBox(),
                                  ],
                                ),
                              );
                            },
                            onReorder: (oldIndex, newIndex) {
                              setState(() {
                                if (newIndex > oldIndex) newIndex -= 1;

                                final entries = proprietes.entries.toList();
                                final item = entries.removeAt(oldIndex);
                                entries.insert(newIndex, item);

                                // Recréer la map avec le nouvel ordre
                                proprietes
                                  ..clear()
                                  ..addEntries(entries);
                              });
                            },
                          ),
                          SizedBox(
                            height: context.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),

            proprietes.length >= 2
                ? showInfo(
                    info:
                        'Faites un appui long sur un élément puis glissez pour le déplacer',
                  ).animate(delay: Duration(milliseconds: 500)).flipH()
                : SizedBox(),

            /// Variétés du produit
            ListTile(
              minTileHeight: 0,
              contentPadding: const EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 16.0, bottom: 0.0),
              title: AppText(
                text: 'Variétés',
                fontWeight: FontWeight.w800,
                fontSize: context.mediumText,
              ),
              subtitle: AppText(
                text: 'Ajouter les variétés du produit, si nécessaire',
                fontWeight: FontWeight.w800,
                fontSize: context.smallText * 0.9,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4),
              ),
              trailing: AppButton(
                  borderColor: AppColors.primaryColor,
                  height: context.height * 0.035,
                  width: context.width * 0.15,
                  bordeurRadius: 7,
                  color: Colors.transparent,
                  child: AppText(
                    text: '+',
                    color: AppColors.primaryColor,
                    fontSize: context.mediumText * 1.1,
                    fontWeight: FontWeight.bold,
                  ) //Theme.of(context).colorScheme.surface.w,
                  ),
              onTap: () {
                varieteController.clear();
                showFormBottomSheet(context,
                    title: 'Ajouter une variété',
                    subtitle: 'Ex : Pondeuse, couveuse, etc.',
                    proprieteController: varieteController, onConfirmAdd: () {
                  setState(() {
                    if (varieteController.text.isNotEmpty) {
                      varietes.add(varieteController.text);
                      varieteController.clear();
                      Navigator.pop(context);
                    } else if (varieteController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AppText(
                            text:
                                'Veuillez remplir le champs pour ajouter une variété',
                            color: Colors.white,
                            overflow: TextOverflow.visible,
                          ),
                          duration: Duration(seconds: 6),
                          showCloseIcon: true,
                          backgroundColor: AppColors.redColor,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  });
                });
              },
            ),

            varietes.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, right: 8.0, left: 8.0, bottom: 16.0),
                    child: Container(
                      //height: context.height * 0.3,
                      //width: context.width * 0.9,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.5))),
                      child: ReorderableWrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        needsLongPressDraggable: true,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            final item = varietes.removeAt(oldIndex);
                            varietes.insert(newIndex, item);
                          });
                        },
                        children: List.generate(varietes.length, (index) {
                          final variete = varietes[index];
                          return GestureDetector(
                            key: ValueKey(variete),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      AppDialog.showDialog(
                                        context: context,
                                        title: 'Suppression',
                                        content:
                                            'Voulez-vous vraiment supprimer la variété $variete ?',
                                        confirmText: 'Oui',
                                        cancelText: 'Non',
                                        onConfirm: () {
                                          setState(() {
                                            varietes.removeAt(index);
                                          });
                                          Navigator.pop(context);
                                        },
                                      );
                                    },
                                    child: Icon(
                                      Icons.delete,
                                      color:
                                          AppColors.redColor.withOpacity(0.5),
                                      size: 15,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: AppText(
                                      text: variete,
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w900,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              var key = varietes[index];
                              varieteController.text = key;
                              showFormBottomSheet(
                                context,
                                title: 'Modifier une variété',
                                subtitle: 'Ex : Couveuse, Pondeuse, etc.',
                                proprieteController: varieteController,
                                onConfirmAdd: () {
                                  if (varieteController.text
                                          .trim()
                                          .isNotEmpty &&
                                      varieteController.text != key) {
                                    setState(() {
                                      varietes.add(varieteController.text);
                                      varietes.removeAt(index);
                                    });
                                  } else if (varieteController.text
                                      .trim()
                                      .isEmpty) {
                                    setState(() {
                                      varietes.removeAt(index);
                                      varieteController.clear();
                                    });
                                  }
                                  varieteController.clear();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        }),
                      ),
                    ),
                  )
                : SizedBox(),

            varietes.length >= 2
                ? showInfo(
                        info:
                            'Faites un appui long sur un élément puis glissez a pour réorganiser la liste')
                    .animate(delay: Duration(milliseconds: 500))
                    .flipH()
                : SizedBox(),

            /// Button d'ajout de produit
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 20, top: 20.0),
              child: AppButton(
                  borderColor: AppColors.primaryColor,
                  height: context.height * 0.06,
                  width: context.width * 0.8,
                  bordeurRadius: 10,
                  onTap: () async {
                    // TODO : ajouter le produit

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: AppText(
                          text:
                              'Le produit ${produit.productName} est ajouté avec succès',
                          //color: Colors.white,
                          overflow: TextOverflow.visible,
                        ),
                        duration: Duration(seconds: 6),
                        showCloseIcon: true,
                        //backgroundColor: AppColors.greenColor,
                      ),
                    );

                    await FirestoreProductService().addProduct(produit);
                  },
                  color: Colors.transparent,
                  child: AppText(
                    text: 'Ajoutez le produit',
                    color: AppColors.primaryColor,
                  ) //Theme.of(context).colorScheme.surface.w,
                  ),
            ),

            ///sizebbox
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    multiImagePickerController.dispose();
    productDescriptionController.dispose;
    prixUnitaireController.dispose();
    productNameController.dispose();
    quantiteController.dispose();
    valeurProprieteController.dispose();
    proprieteController.dispose();
    varieteController.dispose();
    promoPrixController.dispose();
    super.dispose();
  }
}

void showFormBottomSheet(BuildContext context,
    {String? title,
    String? subtitle,
    required TextEditingController proprieteController,
    TextEditingController? valeurProprieteController,
    void Function()? onConfirmAdd}) {
  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    enableDrag: true,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          top: 1.0,
          bottom:
              MediaQuery.of(context).viewInsets.bottom + context.height * 0.07,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText(
              text: title ?? 'Ajouter',
              fontSize: context.mediumText * 1.2,
              fontWeight: FontWeight.bold,
            ),
            AppText(
                text: subtitle ?? 'Ex : ...',
                fontSize: context.smallText * 1.2,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4)),
            SizedBox(height: 16),
            TextFormField(
              controller: proprieteController,
              decoration: InputDecoration(
                label: title != null &&
                        title.toLowerCase().trim().contains('propriété')
                    ? Text('Propriété')
                    : Text('Variété'),
                labelStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.6),
                    fontSize: context.smallText * 1.2),
                floatingLabelStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: context.mediumText * 1.2),
                hintText: title != null &&
                        title.toLowerCase().trim().contains('propriété')
                    ? 'ex : Poids'
                    : 'ex : Pondeuse',
                hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 2, color: AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16),
            title != null && title.toLowerCase().trim().contains('propriété')
                ? TextFormField(
                    controller: valeurProprieteController,
                    decoration: InputDecoration(
                      labelText: 'Valeur',
                      labelStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                          fontSize: context.smallText * 1.2),
                      floatingLabelStyle: TextStyle(
                          color: AppColors.primaryColor,
                          fontSize: context.mediumText * 1.2),
                      hintText: 'ex : 2 KG',
                      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.6)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    keyboardType: TextInputType.text,
                  )
                : SizedBox(),
            SizedBox(height: 24),
            AppButton(
              height: context.height * 0.07,
              width: context.width * 0.9,
              onTap: onConfirmAdd ??
                  () {
                    //TODO : Logique pour traiter les données saisies
                    Navigator.pop(context); // Fermer le BottomSheet
                  },
              color: AppColors.primaryColor,
              child: AppText(
                text: 'Confirmer',
                fontSize: context.mediumText * 1.2,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget showInfo({required String info}) {
  return Builder(builder: (context) {
    return Padding(
        padding: const EdgeInsets.only(
            top: 1.0, right: 8.0, left: 8.0, bottom: 16.0),
        child: Container(
          padding:
              EdgeInsets.only(top: 8.0, right: 4.0, left: 8.0, bottom: 8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.info_outline,
                color: Colors.orange,
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: AppText(
                  text: info,
                  fontSize: context.smallText,
                  color: Colors.orange,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
        ));
  });
}
