import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class CategoriesList extends StatefulWidget {
  const CategoriesList({super.key});

  @override
  State<CategoriesList> createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Center(
              child: AppText(
                text: 'Liste des catégories',
              ),
            );
          }),
    );
  }
}
