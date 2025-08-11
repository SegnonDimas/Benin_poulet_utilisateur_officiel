import 'package:benin_poulet/constants/firebase_collections/sellersCollection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String sellerId;
  final String userId;
  final DateTime createdAt;
  final Map<String, dynamic>? deliveryInfos;
  final bool? documentsVerified;
  final Map<String, dynamic>? fiscality;
  final Map<String, dynamic>? identyCardUrl;
  final List<Map<String, dynamic>>? mobileMoney;
  final List<String>? sectors;
  final List<String> storeIds;
  final Map<String, dynamic>? storeInfos;
  final List<String>? subSectors;

  Seller({
    required this.sellerId,
    required this.userId,
    DateTime? createdAt,
    this.deliveryInfos,
    this.documentsVerified,
    this.fiscality,
    this.identyCardUrl,
    this.mobileMoney,
    this.sectors,
    List<String>? storeIds,
    this.storeInfos,
    this.subSectors,
  })  : createdAt = createdAt ?? DateTime.now(),
        storeIds = storeIds ?? [];

  // Crée un objet Seller à partir d'une Map (depuis Firestore)
  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      sellerId: map[SellersCollection.sellerId] ?? '',
      userId: map[SellersCollection.userId] ?? '',
      createdAt: (map[SellersCollection.createdAt] as Timestamp?)?.toDate() ??
          DateTime.now(),
      deliveryInfos: map[SellersCollection.deliveryInfos],
      documentsVerified: map[SellersCollection.documentsVerified],
      fiscality: map[SellersCollection.fiscality],
      identyCardUrl: map[SellersCollection.identyCardUrl],
      mobileMoney: map[SellersCollection.mobileMoney] != null
          ? List<Map<String, dynamic>>.from(map[SellersCollection.mobileMoney])
          : null,
      sectors: map[SellersCollection.sectors] != null
          ? List<String>.from(map[SellersCollection.sectors])
          : null,
      storeIds: List<String>.from(map[SellersCollection.storeIds] ?? []),
      storeInfos: map[SellersCollection.storeInfos],
      subSectors: map[SellersCollection.subSectors] != null
          ? List<String>.from(map[SellersCollection.subSectors])
          : null,
    );
  }

  // Convertit l'objet Seller en Map (pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      SellersCollection.sellerId: sellerId,
      SellersCollection.userId: userId,
      SellersCollection.createdAt: Timestamp.fromDate(createdAt),
      SellersCollection.deliveryInfos: deliveryInfos,
      SellersCollection.documentsVerified: documentsVerified,
      SellersCollection.fiscality: fiscality,
      SellersCollection.identyCardUrl: identyCardUrl,
      SellersCollection.mobileMoney: mobileMoney,
      SellersCollection.sectors: sectors,
      SellersCollection.storeIds: storeIds,
      SellersCollection.storeInfos: storeInfos,
      SellersCollection.subSectors: subSectors,
    };
  }

  // Crée une copie de l'objet avec des champs mis à jour
  Seller copyWith({
    String? sellerId,
    String? userId,
    DateTime? createdAt,
    Map<String, dynamic>? deliveryInfos,
    bool? documentsVerified,
    Map<String, dynamic>? fiscality,
    Map<String, dynamic>? identyCardUrl,
    List<Map<String, dynamic>>? mobileMoney,
    List<String>? sectors,
    List<String>? storeIds,
    Map<String, dynamic>? storeInfos,
    List<String>? subSectors,
  }) {
    return Seller(
      sellerId: sellerId ?? this.sellerId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      deliveryInfos: deliveryInfos ?? this.deliveryInfos,
      documentsVerified: documentsVerified ?? this.documentsVerified,
      fiscality: fiscality ?? this.fiscality,
      identyCardUrl: identyCardUrl ?? this.identyCardUrl,
      mobileMoney: mobileMoney ?? this.mobileMoney,
      sectors: sectors ?? this.sectors,
      storeIds: storeIds ?? List.from(this.storeIds),
      storeInfos: storeInfos ?? this.storeInfos,
      subSectors: subSectors ?? this.subSectors,
    );
  }

  // Ajoute un storeId à la liste des boutiques du vendeur
  Seller addStoreId(String storeId) {
    if (storeIds.contains(storeId)) return this;
    final updatedStoreIds = List<String>.from(storeIds)..add(storeId);
    return copyWith(storeIds: updatedStoreIds);
  }

  // Supprime un storeId de la liste des boutiques du vendeur
  Seller removeStoreId(String storeId) {
    if (!storeIds.contains(storeId)) return this;
    final updatedStoreIds = List<String>.from(storeIds)..remove(storeId);
    return copyWith(storeIds: updatedStoreIds);
  }
}

// Classes utilitaires pour les structures de données complexes
class DeliveryInfos {
  final String? location;
  final String? locationDescription;
  final bool? sellerOwnDeliver;

  DeliveryInfos({
    this.location,
    this.locationDescription,
    this.sellerOwnDeliver,
  });

  Map<String, dynamic> toMap() {
    return {
      'location': location,
      'locationDescription': locationDescription,
      'sellerOwnDeliver': sellerOwnDeliver,
    };
  }

  factory DeliveryInfos.fromMap(Map<String, dynamic> map) {
    return DeliveryInfos(
      location: map['location'],
      locationDescription: map['locationDescription'],
      sellerOwnDeliver: map['sellerOwnDeliver'],
    );
  }
}

class IdentityCardUrl {
  final String? recto;
  final String? verso;

  IdentityCardUrl({
    this.recto,
    this.verso,
  });

  Map<String, dynamic> toMap() {
    return {
      'recto': recto,
      'verso': verso,
    };
  }

  factory IdentityCardUrl.fromMap(Map<String, dynamic> map) {
    return IdentityCardUrl(
      recto: map['recto'],
      verso: map['verso'],
    );
  }
}

class MobileMoney {
  final String? gsmService;
  final String? name;
  final String? phone;

  MobileMoney({
    this.gsmService,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'gsmService': gsmService,
      'name': name,
      'phone': phone,
    };
  }

  factory MobileMoney.fromMap(Map<String, dynamic> map) {
    return MobileMoney(
      gsmService: map['gsmService'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}

class StoreInfos {
  final String? email;
  final String? name;
  final String? phone;

  StoreInfos({
    this.email,
    this.name,
    this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
    };
  }

  factory StoreInfos.fromMap(Map<String, dynamic> map) {
    return StoreInfos(
      email: map['email'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}
