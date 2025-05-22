import 'dart:async';

import 'package:benin_poulet/core/firebase/firestore/product_repository.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/produit.dart';

class ListProduitFirebase extends StatefulWidget {
  const ListProduitFirebase({super.key});

  @override
  State<ListProduitFirebase> createState() => _ListProduitFirebaseState();
}

class _ListProduitFirebaseState extends State<ListProduitFirebase> {
  late Stream<List<Produit>> allProducts;
  final FirestoreProductService productService =
      FirestoreProductService(); // ou comme tu récupères ton service
  final StreamController<List<Produit>> streamController = StreamController();

  @override
  initState() {
    allProducts = FirestoreProductService().getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produits'),
      ),
      body: StreamBuilder<List<Produit>>(
          stream: productService.getAllProducts(),
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
              itemCount:
                  produits.length, // Remplacez par le nombre réel de produits
              itemBuilder: (context, index) {
                final produit = produits[index];
                return ListTile(
                  title: Text(produit.productName!),
                  subtitle: Text(produit
                      .productDescription), // Remplacez par la description du produit
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      // Logique pour supprimer le produit
                      FirestoreProductService()
                          .deleteProduct(produit.productId!)
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Produit supprimé avec succès'),
                          ),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Erreur de suppression : $error'),
                          ),
                        );
                      });
                    },
                  ),
                );
              },
            );
          }),
    );
  }
}
