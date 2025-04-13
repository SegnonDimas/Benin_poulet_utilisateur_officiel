class Produit {
  final List<String>? productImagesPath;
  final String? productName;
  final String? category; // ex : Volaille
  final String? subCategory; // ex : Poulet
  final String? productDescription;
  final String? attributProductValue;
  final int? stockValue;
  final String? promotionValue;
  final double? productUnitPrice;
  final bool? isInPromotion;
  final double? promotionalPrice;
  final List<String>? varieteProduitList;
  final List<String>? productVariations; // poids, race, etc.

  const Produit({
    this.productImagesPath,
    required this.productName,
    this.category,
    this.subCategory,
    this.productDescription,
    this.attributProductValue,
    this.varieteProduitList = const [],
    this.stockValue = 1,
    this.promotionValue,
    required this.productUnitPrice,
    this.isInPromotion,
    this.promotionalPrice,
    this.productVariations,
  });

  Produit copyWith({
    final List<String>? productImagesPath,
    final String? productName,
    final String? category, // ex : Volaille
    final String? subCategory, // ex : Poulet
    final String? productDescription,
    final String? attributProductValue,
    final int? stockValue,
    final String? promotionValue,
    final double? productUnitPrice,
    final bool? isInPromotion,
    final double? promotionalPrice,
    final List<String>? varieteProduitList,
    final List<String>? productVariations, // ex : poids, race, etc.
  }) {
    return Produit(
      productImagesPath: productImagesPath ?? this.productImagesPath,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      productDescription: productDescription ?? this.productDescription,
      attributProductValue: attributProductValue ?? this.attributProductValue,
      stockValue: stockValue ?? this.stockValue,
      promotionValue: promotionValue ?? this.promotionValue,
      productUnitPrice: productUnitPrice ?? this.productUnitPrice,
      isInPromotion: isInPromotion ?? this.isInPromotion,
      promotionalPrice: promotionalPrice ?? promotionalPrice,
      varieteProduitList: varieteProduitList ?? this.varieteProduitList,
      productVariations: productVariations ?? this.productVariations,
    );
  }
}
