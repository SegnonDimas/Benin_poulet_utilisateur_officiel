import 'dart:async';

import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker_view/multi_image_picker_view.dart';

import '../models/produit.dart';
import '../widgets/app_text.dart';

class ListProduitFirebase extends StatefulWidget {
  const ListProduitFirebase({super.key});

  @override
  State<ListProduitFirebase> createState() => _ListProduitFirebaseState();
}

class _ListProduitFirebaseState extends State<ListProduitFirebase> {
  late Stream<List<Produit>> allProducts;
  final ProductRepository productService =
      ProductRepository(); // ou comme tu récupères ton service
  final StreamController<List<Produit>> streamController = StreamController();

  late final multiImagePickerController;
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
      var images =
          xFiles.map<ImageFile>((e) => convertXFileToImageFile(e)).toList();
      print('::::::xFiles.length: ${xFiles.length}:::::::');
      print('::::::xFiles: ${images}:::::::');
      return images;
    }
    return [];
  }

  @override
  initState() {
    allProducts = ProductRepository().getAllActiveProducts();

    //
    multiImagePickerController = MultiImagePickerController(
        maxImages: 10,
        picker: (int pickCount, Object? params) async {
          return await pickImagesUsingImagePicker(pickCount);
          /*picker: (allowMultiple) async {
          return await pickImagesUsingImagePicker(allowMultiple);*/
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var url =
        'https://img.freepik.com/photos-gratuite/vieux-bateau-peche-rouille-pente-long-rive-du-lac_181624-44902.jpg?semt=ais_hybrid&w=740';
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
      ),
      body: Column(
        children: [
          // multiples images
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
                  backgroundColor:
                      Theme.of(context).colorScheme.background.withOpacity(0.9),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: SizedBox(
              width: context.width * 0.93,
              height: context.height * 0.45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl:
                      'https://img.freepik.com/photos-gratuite/vieux-bateau-peche-rouille-pente-long-rive-du-lac_181624-44902.jpg?semt=ais_hybrid&w=740',
                  placeholder: (context, url) => Center(
                    child: SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator()),
                  ),
                  /*progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(),*/
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 15,
            child: StreamBuilder<List<Produit>>(
                stream: productService.getAllActiveProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                      radius: 30,
                    ));
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur : ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun produit disponible'));
                  }

                  final produits = snapshot.data!;

                  return ListView.builder(
                    itemCount: produits
                        .length, // Remplacez par le nombre réel de produits
                    itemBuilder: (context, index) {
                      final produit = produits[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: CachedNetworkImage(
                            imageUrl: produit.productImagesPath[0],
                            //'https://img.freepik.com/photos-gratuite/vieux-bateau-peche-rouille-pente-long-rive-du-lac_181624-44902.jpg?semt=ais_hybrid&w=740', // Remplacez par l'URL de votre image
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            /*progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(),*/
                            errorWidget: (context, url, error) => Icon(
                              Icons.broken_image_outlined,
                              size: 50,
                              color: Colors.grey.withOpacity(0.1),
                            ),
                          ),
                        ),
                        title: Text(produit.productName!),
                        subtitle: Text(produit
                            .productDescription), // Remplacez par la descrip

                        // suppression/modification du produit
                        trailing: SizedBox(
                          width: 80,
                          child: Row(
                            children: [
                              Flexible(
                                child: IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    // Logique pour modifier le produit
                                    showBottomSheet(
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                          text: produit
                                                              .productName),
                                                ),
                                                TextField(
                                                  controller:
                                                      TextEditingController(
                                                          text: produit
                                                              .productDescription),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    // Logique pour enregistrer les modifications
                                                    ProductRepository()
                                                        .updateProduct(
                                                      produit.productId!,
                                                      {
                                                        'productName': produit.productName,
                                                        'productDescription': produit.productDescription,
                                                      },
                                                    )
                                                        .then((_) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Produit modifié avec succès'),
                                                        ),
                                                      );
                                                      Navigator.pop(context);
                                                    }).catchError((error) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Erreur de modification : $error'),
                                                        ),
                                                      );
                                                    });
                                                  },
                                                  child: Text('Enregistrer'),
                                                ),
                                              ],
                                            ),
                                          );
                                        });
                                  },
                                ),
                              ),
                              Flexible(
                                  child: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  // Logique pour supprimer le produit
                                  ProductRepository()
                                      .deleteProduct(produit.productId!)
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Produit supprimé avec succès'),
                                      ),
                                    );
                                  }).catchError((error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Erreur de suppression : $error'),
                                      ),
                                    );
                                  });
                                },
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () async {},
        child: Icon(Icons.add),
      ),
    );
  }
}
