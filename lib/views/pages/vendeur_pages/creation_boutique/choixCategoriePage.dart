import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../../../models/model_categorie.dart';

class ChoixCategoriePage extends StatefulWidget {
  @override
  State<ChoixCategoriePage> createState() => _ChoixCategoriePageState();
}

class _ChoixCategoriePageState extends State<ChoixCategoriePage> {
  final List<ModelCategorie> _categorie = [
    // poulet/volaille
    ModelCategorie(
      activeColor: primaryColor.withOpacity(0.9),
      description: 'Tout produit qui concerne les volailles',
      imgUrl: 'assets/images/poulet.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // boeuf
    ModelCategorie(
      activeColor: primaryColor,
      description:
          'Tout produit qui concerne le bétail, exceptionnellement le Boeuf',
      imgUrl: 'assets/images/boeuf.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // mouton
    ModelCategorie(
      activeColor: primaryColor,
      description:
          'Tout produit qui concerne le bétail, exceptionnellement le Mouton',
      imgUrl: 'assets/images/mouton.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // poisson
    ModelCategorie(
      activeColor: primaryColor,
      description: 'Tout produit qui concerne la pisciculture et la pêche',
      imgUrl: 'assets/images/poisson.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // restaurant
    ModelCategorie(
      activeColor: primaryColor,
      description: 'Lorsque vous êtes un restaurant',
      imgUrl: 'assets/images/restaurant.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          SizedBox(height: appHeightSize(context) * 0.025),
          AppText(
            text: 'Choisissez votre catégorie',
            fontWeight: FontWeight.bold,
            fontSize: mediumText() * 1.1,
          ),
          SizedBox(height: appHeightSize(context) * 0.05),
          Wrap(
            children: _categorie,
          )
        ]),
      ),
    );
  }
}
