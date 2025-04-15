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
  final String? productStatus; // ex : actif, inactif, en attente, suspendu

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
    this.productStatus,
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
    final String? productStatus, // ex : actif, inactif, en attente, suspendu
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
      productStatus: productStatus ?? this.productStatus,
    );
  }
}

//================================
// Liste fictive de produits
//================================

List<Produit> list_produits = [
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
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
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf1.png', 'assets/images/boeuf2.png'],
    varieteProduitList: [],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
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
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
      'assets/images/poulet2.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Poulet Fermier EntierPoulet Fermier EntierCe poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/poisson1.png',
      'assets/images/poisson2.png'
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poisson1.png',
      'assets/images/poisson2.png',
      'assets/images/poisson1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Chèvre',
    productDescription:
        "Savoureuse et fondante, notre épaule de mouton est parfaite pour les plats mijotés ou au four. Issue d’animaux élevés dans des conditions respectueuses, elle garantit un goût authentique. Riche en protéines, elle convient à une alimentation équilibrée. Qualité boucherie à chaque bouchée.",
    productUnitPrice: 250000,
    productImagesPath: [
      'assets/images/chevre1.png',
      'assets/images/chevre2.png'
    ],
    varieteProduitList: [],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Chevre',
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
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poisson1.png',
      'assets/images/poisson2.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Poisson Rouge',
    productDescription:
        "Nos filets de tilapia sont soigneusement nettoyés et prêts à cuire. Leur chair blanche et ferme se prête à toutes les recettes : grillée, panée ou en sauce. Un poisson doux, riche en protéines et pauvre en matières grasses. Pêché de manière responsable.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/poisson2.png',
      'assets/images/poisson1.png',
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Chèvre',
    productDescription:
        "Savoureuse et fondante, notre épaule de mouton est parfaite pour les plats mijotés ou au four. Issue d’animaux élevés dans des conditions respectueuses, elle garantit un goût authentique. Riche en protéines, elle convient à une alimentation équilibrée. Qualité boucherie à chaque bouchée.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/chevre1.png',
      'assets/images/chevre2.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Chèvre',
    productDescription:
        "Savoureuse et fondante, notre épaule de mouton est parfaite pour les plats mijotés ou au four. Issue d’animaux élevés dans des conditions respectueuses, elle garantit un goût authentique. Riche en protéines, elle convient à une alimentation équilibrée. Qualité boucherie à chaque bouchée.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/chevre1.png',
      'assets/images/chevre2.png'
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf2.png', 'assets/images/boeuf1.png'],
    varieteProduitList: [],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
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
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/poulet1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf2.png', 'assets/images/oeuf1.png'],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf2.png', 'assets/images/boeuf1.png'],
    varieteProduitList: [],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
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
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf2.png', 'assets/images/boeuf1.png'],
    varieteProduitList: [],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
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
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet2.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: ['assets/images/oeuf1.png', 'assets/images/oeuf2.png'],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'inactif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet2.png',
      'assets/images/poulet1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Boeuf ayoussa',
    productDescription:
        "Notre bœuf haché est préparé à partir de morceaux sélectionnés 100 % muscle, sans ajout de gras inutile. Idéal pour les sauces, boulettes ou burgers faits maison. Il offre un goût riche et une texture tendre. Fraîcheur et traçabilité garanties.",
    productUnitPrice: 250000,
    productImagesPath: ['assets/images/boeuf1.png', 'assets/images/boeuf2.png'],
    varieteProduitList: [],
    promotionValue: 'NON',
    productStatus: 'suspendu',
    stockValue: 100,
  ),
  const Produit(
    productName: 'Œufs Poulet',
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
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/pouletCouveuse.png',
      'assets/images/poulet1.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
    promotionValue: 'NON',
    productStatus: 'en attente',
    stockValue: 150,
  ),
  const Produit(
    productName: 'Œufs Poulet',
    productDescription:
        "Nos œufs frais proviennent de poules élevées en liberté et nourries avec des aliments naturels. Leur jaune est riche et leur goût authentique. Idéals pour vos recettes, petits-déjeuners ou pâtisseries. Une source naturelle de protéines et de bons nutriments.",
    productUnitPrice: 1500,
    productImagesPath: [
      'assets/images/oeuf1.png',
      'assets/images/oeuf2.png',
    ],
    varieteProduitList: [
      'Variation1',
      'Variation2',
      'Variation3',
      'Variation4'
    ],
    promotionValue: 'NON',
    productStatus: 'actif',
    stockValue: 15,
  ),
  const Produit(
    productName: 'Poulet Goliath',
    productDescription:
        "Ce poulet fermier élevé en plein air offre une chair tendre et savoureuse. Nourri naturellement, il est idéal pour des repas sains et riches en goût. Parfait pour les grillades, les bouillons ou les plats mijotés. Un produit frais, sans hormones ni additifs.",
    productUnitPrice: 7500,
    productImagesPath: [
      'assets/images/poulet1.png',
      'assets/images/pouletCouveuse.png',
    ],
    varieteProduitList: ['Goliath', 'Couveuse', 'Géant', 'Chair'],
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
