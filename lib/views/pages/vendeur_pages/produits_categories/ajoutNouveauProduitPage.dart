import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

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

  final List<String> _categories = [
    'Volaille',
    'Bétaille',
    'Restaurant',
    'Pisciculture'
  ];
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
                    width: appWidthSize(context) * 0.22,
                    height: appHeightSize(context) * 0.045,
                    bordeurRadius: 25,
                    color: primaryColor,
                    child: AppText(
                      text: 'Ajouter',
                      fontSize: smallText() * 1.2,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    onTap: () {}),
              ),
            )
          ],
        ),
        body: ListView(
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
                //height: appHeightSize(context) * 0.3,
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
                      height: appHeightSize(context) * 0.02,
                    ),

                    /// nom
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: SizedBox(
                        height: appHeightSize(context) * 0.05,
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
                                  width: appWidthSize(context) * 0.7,
                                  maxLines: 1,
                                  controller: productNameController),
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
                            height: appHeightSize(context) * 0.05,
                            width: appWidthSize(context) * 0.4,
                            child: DropdownButton<String>(
                              icon: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: mediumText(),
                                  )
                                ],
                              ),
                              underline: Container(),
                              value: _categorySelected,
                              //focusColor: primaryColor,
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
                            height: appHeightSize(context) * 0.05,
                            width: appWidthSize(context) * 0.4,
                            child: DropdownButton<String>(
                              underline: Container(),
                              icon: Row(
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: mediumText(),
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
                        //height: appHeightSize(context) * 0.21,
                        width: appWidthSize(context) * 0.9,
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
                                //height: appHeightSize(context) * 0.18,
                                width: appWidthSize(context) * 0.98,
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
                fontSize: mediumText(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                //height: appHeightSize(context) * 0.3,
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
                      height: appHeightSize(context) * 0.02,
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
                        height: appHeightSize(context) * 0.07,
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
                              width: appWidthSize(context) * 0.45,
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
                fontSize: mediumText(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  top: 8.0, right: 8.0, left: 8.0, bottom: 16.0),
              child: Container(
                //height: appHeightSize(context) * 0.3,
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
                      height: appHeightSize(context) * 0.02,
                    ),

                    /// case à cocher
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: SizedBox(
                        height: appHeightSize(context) * 0.05,
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
                                        controller: prixUnitaireController),
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

            /// Variations du produit
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 8.0, top: 16.0, bottom: 0.0),
              child: AppText(
                text: 'Propriétés',
                fontWeight: FontWeight.w800,
                fontSize: mediumText(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 8.0, top: 0.0, bottom: 8.0),
              child: AppText(
                text: 'Ajouter le poids, la race, etc. si nécessaire',
                fontWeight: FontWeight.w800,
                fontSize: smallText() * 0.9,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, right: 8.0, bottom: 20, top: 8.0),
              child: AppButton(
                  borderColor: primaryColor,
                  height: appHeightSize(context) * 0.06,
                  width: appWidthSize(context) * 0.8,
                  bordeurRadius: 10,
                  onTap: () {
                    showFormBottomSheet(context);
                  },
                  color: Colors.transparent,
                  child: AppText(
                    text: 'Ajoutez des propriétés',
                    color: primaryColor,
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
    super.dispose();
  }
}

void showFormBottomSheet(BuildContext context) {
  final TextEditingController varieteController = TextEditingController();
  final TextEditingController valeurController = TextEditingController();

  showModalBottomSheet(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    enableDrag: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isScrollControlled: true,
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
              text: 'Ajouter une propriété',
              fontSize: context.mediumText * 1.2,
              fontWeight: FontWeight.bold,
            ),
            AppText(
                text: 'Ex : Poids, Race, Couleur...',
                fontSize: context.smallText,
                fontWeight: FontWeight.bold,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.4)),
            SizedBox(height: 16),
            TextFormField(
              controller: varieteController,
              decoration: InputDecoration(
                labelText: 'propriété',
                hintText: 'ex : Poids',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: valeurController,
              decoration: InputDecoration(
                labelText: 'valeur',
                hintText: 'ex : 2 KG',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 24),
            AppButton(
              height: context.height * 0.07,
              width: context.width * 0.9,
              onTap: () {
                String variete = varieteController.text;
                String valeur = valeurController.text;

                // Logique pour traiter les données saisies
                print(
                    '::::::::::::::::::::::::::Variété: $variete, Valeur: $valeur');

                Navigator.pop(context); // Fermer le BottomSheet
              },
              color: AppColors.primaryColor,
              child: AppText(
                text: 'Ajouter',
                fontSize: context.mediumText * 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
    },
  );
}
