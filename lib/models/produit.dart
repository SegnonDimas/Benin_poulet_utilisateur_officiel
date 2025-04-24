import 'package:benin_poulet/constants/productStatus.dart' show ProductStatus;
import 'package:cloud_firestore/cloud_firestore.dart';

class Produit {
  final String? productId;
  final String? storeId;
  final List<String>? productImagesPath;
  final String? productName;
  final String? category; // ex : Volaille
  final String? subCategory; // ex : Poulet
  final String? productDescription;
  final int? stockValue;
  @Deprecated('Remplacé par isInPromotion (true/false)')
  final String? promotionValue; //utiliser isInPromotion à la place
  final double productUnitPrice;
  final bool? isInPromotion;
  final double?
      promoPrice; // si isInPromotion == true, donner un prix promotionnel relatif
  final List<String>? varieties; // ex : Goliath, Couveuse, Pondeuse etc.
  final Map<String, String>?
      productProperties; // poids : 25Kg, race : libanais, etc.
  final String? productStatus; // ex : actif, inactif, en attente, suspendu

  const Produit({
    this.productId,
    this.storeId,
    this.productImagesPath,
    required this.productName,
    this.category,
    this.subCategory,
    this.productDescription,
    this.varieties = const ['Standard'],
    this.stockValue = 1,
    this.promotionValue,
    required this.productUnitPrice,
    this.isInPromotion = false,
    this.promoPrice = 0,
    this.productProperties,
    this.productStatus = ProductStatus.active,
  });

  ///copyWith

  Produit copyWith({
    final String? productId,
    final String? storeId,
    final List<String>? productImagesPath,
    final String? productName,
    final String? category, // ex : Volaille
    final String? subCategory, // ex : Poulet
    final String? productDescription,
    final int? stockValue,
    final String? promotionValue,
    final double? productUnitPrice,
    final bool? isInPromotion,
    final double? promoPrice,
    final List<String>? varieties,
    final Map<String, String>?
        productProperties, // ex : poids : 25Kg, race : libanais, etc.
    final String? productStatus, // ex : actif, inactif, en attente, suspendu
  }) {
    return Produit(
      productId: productId ?? this.productId,
      storeId: storeId ?? this.storeId,
      productImagesPath: productImagesPath ?? this.productImagesPath,
      productName: productName ?? this.productName,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      productDescription: productDescription ?? this.productDescription,
      stockValue: stockValue ?? this.stockValue,
      promotionValue: promotionValue ?? this.promotionValue,
      productUnitPrice: productUnitPrice ?? this.productUnitPrice,
      isInPromotion: isInPromotion ?? this.isInPromotion,
      promoPrice: promoPrice ?? this.promoPrice,
      varieties: varieties ?? this.varieties,
      productProperties: productProperties ?? this.productProperties,
      productStatus: productStatus ?? this.productStatus,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'storeId': storeId,
      'images': productImagesPath,
      'name': productName,
      'category': category,
      'subCategory': subCategory,
      'description': productDescription,
      'stock': stockValue,
      'price': productUnitPrice,
      'isInPromotion': isInPromotion,
      'promoPrice': promoPrice,
      'varieties': varieties,
      'properties': productProperties,
      'status': productStatus,
    };
  }

  factory Produit.fromMap(Map<String, dynamic> map) {
    return Produit(
      productId: map['productId'] as String?,
      storeId: map['storeId'] as String?,
      productImagesPath: (map['images'] as List<dynamic>?)?.cast<String>(),
      productName: map['name'] as String?,
      category: map['category'] as String?,
      subCategory: map['subCategory'] as String?,
      productDescription: map['description'] as String?,
      stockValue: map['stock'] as int?,
      productUnitPrice: (map['price'] as num?)!.toDouble(),
      isInPromotion: map['isInPromotion'] as bool?,
      promoPrice: (map['promoPrice'] as num?)?.toDouble(),
      varieties: (map['varieties'] as List<dynamic>?)?.cast<String>(),
      productProperties: (map['properties'] as Map?)?.map(
        (key, value) => MapEntry(key.toString(), value.toString()),
      ),
      productStatus: map['status'] as String?,
    );
  }

  factory Produit.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Produit.fromMap(data);
  }
}

//================================
// Liste fictive de produits
//================================

List<Produit> list_produits = [
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Poulet Fermier EntierPoulet Fermier EntierPoulet Fermier Entier",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
      'assets/images/poulet2.png',
      'assets/images/poulet3.png',
      'assets/images/poulet4.png',
      'assets/images/poulet5.png',
      'assets/images/poulet6.png',
      'assets/images/poulet7.png',
      'assets/images/poulet8.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    category: 'Bétail',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf1.png', 'assets/images/boeuf2.png'],
    varieties: [],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf2.png',
      'assets/images/oeuf1.png',
    ],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
      'assets/images/poulet2.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Poulet Fermier EntierPoulet Fermier EntierCe poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    category: 'Pisciculture',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/poisson1.png',
      'assets/images/poisson2.png'
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    category: 'Pisciculture',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poisson1.png',
      'assets/images/poisson2.png',
      'assets/images/poisson1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Chèvre',
    category: "Bétail",
    productDescription:
        "Savoureuse et fondante, notre épaule de mouton est parfaite pour les plats mijotés ou au four. Issue d’animaux élevés dans des conditions respectueuses, elle garantit un goût authentique. Riche en protéines, elle convient à une alimentation équilibrée. Qualité boucherie à chaque bouchée.",
    productUnitPrice: 250000,
    productImagesPath: [
      'assets/images/chevre1.png',
      'assets/images/chevre2.png'
    ],
    varieties: [],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Chevre',
    category: 'Bétail',
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/chevre2.png',
      'assets/images/chevre1.png',
    ],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    category: 'Pisciculture',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poisson1.png',
      'assets/images/poisson2.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    category: 'Pisciculture',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/poisson2.png',
      'assets/images/poisson1.png',
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Chèvre',
    category: "Bétail",
    productDescription:
        "Savoureuse et fondante, notre épaule de mouton est parfaite pour les plats mijotés ou au four. Issue d’animaux élevés dans des conditions respectueuses, elle garantit un goût authentique. Riche en protéines, elle convient à une alimentation équilibrée. Qualité boucherie à chaque bouchée.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/chevre1.png',
      'assets/images/chevre2.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Chèvre',
    category: "Bétail",
    productDescription:
        "Savoureuse et fondante, notre épaule de mouton est parfaite pour les plats mijotés ou au four. Issue d’animaux élevés dans des conditions respectueuses, elle garantit un goût authentique. Riche en protéines, elle convient à une alimentation équilibrée. Qualité boucherie à chaque bouchée.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/chevre1.png',
      'assets/images/chevre2.png'
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    category: 'Bétail',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf2.png', 'assets/images/boeuf1.png'],
    varieties: [],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf2.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/oeuf1.png',
    ],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/poulet1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf2.png', 'assets/images/oeuf1.png'],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    category: 'Bétail',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf2.png', 'assets/images/boeuf1.png'],
    varieties: [],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf2.png',
      'assets/images/oeuf1.png',
    ],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    category: 'Bétail',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf2.png', 'assets/images/boeuf1.png'],
    varieties: [],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet2.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/poulet1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    category: 'Bétail',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf1.png', 'assets/images/boeuf2.png'],
    varieties: [],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf2.png',
      'assets/images/oeuf1.png',
    ],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    category: 'Volaille',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieties: ['Variation1', 'Variation2', 'Variation3', 'Variation4'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    category: 'Volaille',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieties: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
];

List<Produit> list_produits_actifs =
    list_produits.where((p) => p.productStatus == 'actif').toList();

List<Produit> list_produits_enAttente =
    list_produits.where((p) => p.productStatus == 'en attente').toList();

List<Produit> list_produits_inactifs =
    list_produits.where((p) => p.productStatus == 'inactif').toList();

List<Produit> list_produits_suspendus =
    list_produits.where((p) => p.productStatus == 'suspendu').toList();
