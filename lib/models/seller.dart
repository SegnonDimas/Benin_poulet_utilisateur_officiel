import 'package:cloud_firestore/cloud_firestore.dart';

class Seller {
  final String sellerId;
  final String userId;
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final List<String> storeIds;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isActive;
  final Map<String, dynamic>? additionalInfo;

  Seller({
    required this.sellerId,
    required this.userId,
    this.fullName,
    this.email,
    this.phoneNumber,
    List<String>? storeIds,
    DateTime? createdAt,
    this.updatedAt,
    this.isActive = true,
    this.additionalInfo,
  })  : storeIds = storeIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  // Crée un objet Seller à partir d'une Map (depuis Firestore)
  factory Seller.fromMap(Map<String, dynamic> map) {
    return Seller(
      sellerId: map['sellerId'] ?? '',
      userId: map['userId'] ?? '',
      fullName: map['fullName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      storeIds: List<String>.from(map['storeIds'] ?? []),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      isActive: map['isActive'] ?? true,
      additionalInfo: map['additionalInfo'],
    );
  }

  // Convertit l'objet Seller en Map (pour Firestore)
  Map<String, dynamic> toMap() {
    return {
      'sellerId': sellerId,
      'userId': userId,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      'storeIds': storeIds,
      'createdAt': Timestamp.fromDate(createdAt),
      if (updatedAt != null) 'updatedAt': Timestamp.fromDate(updatedAt!),
      'isActive': isActive,
      if (additionalInfo != null) 'additionalInfo': additionalInfo,
    };
  }

  // Crée une copie de l'objet avec des champs mis à jour
  Seller copyWith({
    String? sellerId,
    String? userId,
    String? fullName,
    String? email,
    String? phoneNumber,
    List<String>? storeIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? additionalInfo,
  }) {
    return Seller(
      sellerId: sellerId ?? this.sellerId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      storeIds: storeIds ?? List.from(this.storeIds),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      additionalInfo: additionalInfo ?? this.additionalInfo,
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
