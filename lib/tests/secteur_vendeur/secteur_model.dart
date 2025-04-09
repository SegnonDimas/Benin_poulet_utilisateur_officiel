// =========================
// models/seller_sector.dart
// =========================

class SellerSector {
  final int id;
  final String name;
  final String? description;
  final bool isSelected;
  final List<Category> categories;

  const SellerSector({
    required this.id,
    required this.name,
    this.description,
    required this.isSelected,
    required this.categories,
  });

  SellerSector copyWith({
    int? id,
    String? name,
    String? description,
    bool? isSelected,
    List<Category>? categories,
  }) {
    return SellerSector(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
      categories: categories ?? this.categories,
    );
  }
}

class Category {
  final String name;
  final String? description;
  final bool isSelected;

  const Category({
    required this.name,
    this.description,
    required this.isSelected,
  });

  Category copyWith({
    String? name,
    String? description,
    bool? isSelected,
  }) {
    return Category(
      name: name ?? this.name,
      description: description ?? this.description,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
