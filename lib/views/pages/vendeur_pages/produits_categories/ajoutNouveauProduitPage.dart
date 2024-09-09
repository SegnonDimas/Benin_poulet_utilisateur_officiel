import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/material.dart';
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

  Future<List<ImageFile>> pickImagesUsingImagePicker(bool allowMultiple) async {
    final picker = ImagePicker();
    final List<XFile> xFiles;
    if (allowMultiple) {
      xFiles = await picker.pickMultiImage(maxWidth: 1080, maxHeight: 1080);
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

  void incrementerQuantite() {
    setState(() {
      _quantite = _quantite + 1;
      quantiteController.text = _quantite.toString();
    });
  }

  void decrementerQuantite() {
    setState(() {
      _quantite = _quantite - 1;
      quantiteController.text = _quantite.toString();
    });
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
        picker: (allowMultiple) async {
          return await pickImagesUsingImagePicker(allowMultiple);
        });
  }

  @override
  Widget build(BuildContext context) {
    var divider = const Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0),
      child: Divider(),
    );
    return Scaffold(
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
              padding: const EdgeInsets.all(16.0),
              child: MultiImagePickerView(
                controller: multiImagePickerController,
                padding: const EdgeInsets.all(10),
                shrinkWrap: true,
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
                            items: List.generate(_sousCategoriesVolaille.length,
                                (index) {
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

                  const SizedBox(
                    height: 10,
                  ),

                  /// Description du produit
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
                      //height: appHeightSize(context) * 0.1,
                      width: appWidthSize(context) * 0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              width: appWidthSize(context) * 0.9,
                              maxLines: 5,
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
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
                      height: appHeightSize(context) * 0.05,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          AppText(
                            text: 'Prix unitaire : ',
                            fontWeight: FontWeight.w800,
                          ),
                          Expanded(
                            child: AppTextField(
                                keyboardType: TextInputType.number,
                                height: appHeightSize(context) * 0.21,
                                width: appWidthSize(context) * 0.7,
                                suffixIcon: AppText(
                                  text: 'F CFA',
                                ),
                                controller: prixUnitaireController),
                          ),
                        ],
                      ),
                    ),
                  ),
                  divider,

                  /// quantité en stock
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: SizedBox(
                      height: appHeightSize(context) * 0.07,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: AppText(
                              text: 'Quantité : ',
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
                                    icon: const Icon(Icons.remove_circle)),
                                Expanded(
                                  child: TextField(
                                    controller: quantiteController,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                        border: InputBorder.none),
                                  ),
                                ),
                                /*AppTextField(
                                    width: appWidthSize(context) * 0.2,
                                    keyboardType: TextInputType.number,
                                    maxLines: 1,
                                    controller: quantiteController),*/
                                IconButton(
                                    onPressed: incrementerQuantite,
                                    icon: Icon(Icons.add_circle)),
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

          /// Variations

          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 8.0, top: 16.0, bottom: 0.0),
            child: AppText(
              text: 'Variations',
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
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
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
                onTap: () {},
                color: Colors.transparent,
                child: AppText(
                  text: 'Ajoutez variations',
                  color: primaryColor,
                ) //Theme.of(context).colorScheme.surface.w,
                ),
          ),
        ],
      ),
    );
  }
}
