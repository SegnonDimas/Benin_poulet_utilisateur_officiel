import 'package:benin_poulet/constants/firebase_collections/storesCollection.dart';
import 'package:benin_poulet/constants/storeState.dart';
import 'package:benin_poulet/constants/storeStatus.dart';

class Store {
  final String storeId;
  final String sellerId;
  final List<Map<String, dynamic>>? mobileMoney;
  final bool? sellerOwnDeliver;
  final String? storeAddress;
  final List<String>? storeComments;
  final String? storeCoverPath;
  final String? storeDescription;
  final String? storeFiscalType;
  final Map<String, dynamic>? storeInfos;
  final String? storeLocation;
  final String? storeLogoPath;
  final List<String>? storeProducts;
  final List<double>? storeRatings;
  final List<String>? storeSectors;
  final String? storeState;
  final String? storeStatus;
  final List<String>? storeSubsectors;

  Store({
    required this.storeId,
    required this.sellerId,
    this.mobileMoney,
    this.sellerOwnDeliver,
    this.storeAddress,
    this.storeComments,
    this.storeCoverPath,
    this.storeDescription,
    this.storeFiscalType,
    this.storeInfos,
    this.storeLocation,
    this.storeLogoPath,
    this.storeProducts,
    this.storeRatings,
    this.storeSectors,
    this.storeState = StoreState.open,
    this.storeStatus = StoreStatus.active,
    this.storeSubsectors,
  });

  //copyWith
  Store copyWith({
    String? storeId,
    String? sellerId,
    List<Map<String, dynamic>>? mobileMoney,
    bool? sellerOwnDeliver,
    String? storeAddress,
    List<String>? storeComments,
    String? storeCoverPath,
    String? storeDescription,
    String? storeFiscalType,
    Map<String, dynamic>? storeInfos,
    String? storeLocation,
    String? storeLogoPath,
    List<String>? storeProducts,
    List<double>? storeRatings,
    List<String>? storeSectors,
    String? storeState,
    String? storeStatus,
    List<String>? storeSubsectors,
  }) {
    return Store(
      storeId: storeId ?? this.storeId,
      sellerId: sellerId ?? this.sellerId,
      mobileMoney: mobileMoney ?? this.mobileMoney,
      sellerOwnDeliver: sellerOwnDeliver ?? this.sellerOwnDeliver,
      storeAddress: storeAddress ?? this.storeAddress,
      storeComments: storeComments ?? this.storeComments,
      storeCoverPath: storeCoverPath ?? this.storeCoverPath,
      storeDescription: storeDescription ?? this.storeDescription,
      storeFiscalType: storeFiscalType ?? this.storeFiscalType,
      storeInfos: storeInfos ?? this.storeInfos,
      storeLocation: storeLocation ?? this.storeLocation,
      storeLogoPath: storeLogoPath ?? this.storeLogoPath,
      storeProducts: storeProducts ?? this.storeProducts,
      storeRatings: storeRatings ?? this.storeRatings,
      storeSectors: storeSectors ?? this.storeSectors,
      storeState: storeState ?? this.storeState,
      storeStatus: storeStatus ?? this.storeStatus,
      storeSubsectors: storeSubsectors ?? this.storeSubsectors,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      StoresCollection.storeId: storeId,
      StoresCollection.sellerId: sellerId,
      StoresCollection.mobileMoney: mobileMoney,
      StoresCollection.sellerOwnDeliver: sellerOwnDeliver,
      StoresCollection.storeAddress: storeAddress,
      StoresCollection.storeComments: storeComments,
      StoresCollection.storeCoverPath: storeCoverPath,
      StoresCollection.storeDescription: storeDescription,
      StoresCollection.storeFiscalType: storeFiscalType,
      StoresCollection.storeInfos: storeInfos,
      StoresCollection.storeLocation: storeLocation,
      StoresCollection.storeLogoPath: storeLogoPath,
      StoresCollection.storeProducts: storeProducts,
      StoresCollection.storeRatings: storeRatings,
      StoresCollection.storeSectors: storeSectors,
      StoresCollection.storeState: storeState,
      StoresCollection.storeStatus: storeStatus,
      StoresCollection.storeSubsectors: storeSubsectors,
    };
  }

  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      storeId: map[StoresCollection.storeId] ?? '',
      sellerId: map[StoresCollection.sellerId] ?? '',
      mobileMoney: map[StoresCollection.mobileMoney] != null
          ? List<Map<String, dynamic>>.from(map[StoresCollection.mobileMoney])
          : null,
      sellerOwnDeliver: map[StoresCollection.sellerOwnDeliver],
      storeAddress: map[StoresCollection.storeAddress],
      storeComments: map[StoresCollection.storeComments] != null
          ? List<String>.from(map[StoresCollection.storeComments])
          : null,
      storeCoverPath: map[StoresCollection.storeCoverPath],
      storeDescription: map[StoresCollection.storeDescription],
      storeFiscalType: map[StoresCollection.storeFiscalType],
      storeInfos: map[StoresCollection.storeInfos],
      storeLocation: map[StoresCollection.storeLocation],
      storeLogoPath: map[StoresCollection.storeLogoPath],
      storeProducts: map[StoresCollection.storeProducts] != null
          ? List<String>.from(map[StoresCollection.storeProducts])
          : null,
      storeRatings: map[StoresCollection.storeRatings] != null
          ? List<double>.from(map[StoresCollection.storeRatings])
          : null,
      storeSectors: map[StoresCollection.storeSectors] != null
          ? List<String>.from(map[StoresCollection.storeSectors])
          : null,
      storeState: map[StoresCollection.storeState],
      storeStatus: map[StoresCollection.storeStatus],
      storeSubsectors: map[StoresCollection.storeSubsectors] != null
          ? List<String>.from(map[StoresCollection.storeSubsectors])
          : null,
    );
  }

  factory Store.fromDocument(Map<String, dynamic> json) {
    return Store(
      storeId: json[StoresCollection.storeId] ?? '',
      sellerId: json[StoresCollection.sellerId] ?? '',
      mobileMoney: json[StoresCollection.mobileMoney] ?? '',
      sellerOwnDeliver: json[StoresCollection.sellerOwnDeliver] ?? '',
      storeAddress: json[StoresCollection.storeAddress],
      storeCoverPath: json[StoresCollection.storeCoverPath],
      storeDescription: json[StoresCollection.storeDescription],
      storeFiscalType: json[StoresCollection.storeFiscalType],
      storeInfos: json[StoresCollection.storeInfos],
      storeLocation: json[StoresCollection.storeLocation],
      storeLogoPath: json[StoresCollection.storeLogoPath],
      storeState: json[StoresCollection.storeState],
      storeStatus: json[StoresCollection.storeStatus],
      storeSectors: json[StoresCollection.storeSectors] != null
          ? List<String>.from(json[StoresCollection.storeSectors])
          : null,
      storeSubsectors: json[StoresCollection.storeSubsectors] != null
          ? List<String>.from(json[StoresCollection.storeSubsectors])
          : null,
      storeProducts: json[StoresCollection.storeProducts] != null
          ? List<String>.from(json[StoresCollection.storeProducts])
          : null,
      storeRatings: json[StoresCollection.storeRatings] != null
          ? List<double>.from(json[StoresCollection.storeRatings])
          : null,
      storeComments: json[StoresCollection.storeComments] != null
          ? List<String>.from(json[StoresCollection.storeComments])
          : null,
    );
  }
}

// Classes utilitaires pour les structures de données complexes
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
