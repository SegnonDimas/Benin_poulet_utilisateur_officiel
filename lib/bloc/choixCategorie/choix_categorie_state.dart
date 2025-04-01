import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ChoixCategorieState extends Equatable {
  final List<String> secteurs;
  final List<String> categories;
  late Color? color;
  final List<List<String>>? listCategories;
  final Map<String, bool> secteursSelectionnes;

  ChoixCategorieState({
    required this.secteurs,
    required this.categories,
    this.color,
    this.listCategories,
    required this.secteursSelectionnes,
  });

  ChoixCategorieState copyWith({
    List<String>? secteurs,
    List<String>? categories,
    Color? color,
    List<List<String>>? listCategories,
    Map<String, bool>? secteursSelectionnes,
  }) {
    return ChoixCategorieState(
      secteurs: secteurs ?? this.secteurs,
      categories: categories ?? this.categories,
      color: color ?? this.color,
      listCategories: listCategories ?? this.listCategories,
      secteursSelectionnes: secteursSelectionnes ?? this.secteursSelectionnes,
    );
  }

  @override
  List<Object> get props => [secteurs, categories, color ?? Colors.grey];
}
