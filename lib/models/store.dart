import 'package:benin_poulet/constants/storeState.dart';
import 'package:benin_poulet/constants/storeStatus.dart';

class Store {
  final String storeName;
  final String? storeId;
  final String sellerId;
  final String? storeLocation;
  final String? storeAddress;
  final String? storePhone;
  final String? storeEmail;
  final String? storeDescription;
  final String? storeLogoPath;
  final String? storeCoverPath;
  final String? storeStatus;
  final String? storeState;
  final String? storeFiscalType;
  final String? paymentMethod;
  final String? payementOwnerName;
  final String? paymentPhoneNumber;
  final bool? sellerOwnDeliver;
  final List<String?>? storeSectors;
  final List<String?>? storeSubsectors;
  final List<String?>? storeProducts;
  final List<double?>? storeRatings;
  final List<String?>? storeComments;

  Store(
      {required this.storeName,
      this.storeId,
      required this.sellerId,
      this.storeAddress,
      this.storeLocation,
      this.storePhone,
      this.storeEmail,
      this.storeDescription,
      this.storeLogoPath,
      this.storeCoverPath,
      this.storeStatus = StoreStatus.active,
      this.storeState = StoreState.open,
      this.storeFiscalType,
      this.paymentMethod,
      this.payementOwnerName,
      this.paymentPhoneNumber,
      this.sellerOwnDeliver,
      this.storeSectors,
      this.storeSubsectors,
      this.storeProducts,
      this.storeRatings,
      this.storeComments});

  //copyWith
  Store copyWith({
    String? storeName,
    String? storeId,
    String? sellerId,
    String? storeLocation,
    String? storeAddress,
    String? storePhone,
    String? storeEmail,
    String? storeDescription,
    String? storeLogoPath,
    String? storeCoverPath,
    String? storeState,
    String? storeStatus,
    String? storeFiscalType,
    String? paymentMethod,
    String? payementOwnerName,
    String? paymentPhoneNumber,
    bool? sellerOwnDeliver,
    List<String?>? storeSectors,
    List<String?>? storeSubsectors,
    List<String?>? storeProducts,
    List<double?>? storeRatings,
    List<String?>? storeComments,
  }) {
    return Store(
      storeName: storeName ?? this.storeName,
      storeId: storeId ?? this.storeId,
      sellerId: sellerId ?? this.sellerId,
      storeLocation: storeLocation ?? this.storeLocation,
      storeAddress: storeAddress ?? this.storeAddress,
      storePhone: storePhone ?? this.storePhone,
      storeEmail: storeEmail ?? this.storeEmail,
      storeDescription: storeDescription ?? this.storeDescription,
      storeLogoPath: storeLogoPath ?? this.storeLogoPath,
      storeCoverPath: storeCoverPath ?? this.storeCoverPath,
      storeState: storeState ?? this.storeState,
      storeStatus: storeStatus ?? this.storeStatus,
      storeFiscalType: storeFiscalType ?? this.storeFiscalType,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      payementOwnerName: payementOwnerName ?? this.payementOwnerName,
      paymentPhoneNumber: paymentPhoneNumber ?? this.paymentPhoneNumber,
      sellerOwnDeliver: sellerOwnDeliver ?? this.sellerOwnDeliver,
      storeSectors: storeSectors ?? this.storeSectors,
      storeSubsectors: storeSubsectors ?? this.storeSubsectors,
      storeProducts: storeProducts ?? this.storeProducts,
      storeRatings: storeRatings ?? this.storeRatings,
      storeComments: storeComments ?? this.storeComments,
    );
  }

  //
  Map<String, dynamic> toMap() {
    return {
      'storeName': storeName,
      'storeId': storeId,
      'sellerId': sellerId,
      'storeLocation': storeLocation,
      'storeAddress': storeAddress,
      'storePhone': storePhone,
      'storeEmail': storeEmail,
      'storeDescription': storeDescription,
      'storeLogoPath': storeLogoPath,
      'storeCoverPath': storeCoverPath,
      'storeState': storeState,
      'storeStatus': storeStatus,
      'storeFiscalType': storeFiscalType,
      'paymentMethod': paymentMethod,
      'payementOwnerName': payementOwnerName,
      'paymentPhoneNumber': paymentPhoneNumber,
      'sellerOwnDeliver': sellerOwnDeliver,
      'storeSectors': storeSectors,
      'storeSubsectors': storeSubsectors,
      'storeProducts': storeProducts,
      'storeRatings': storeRatings,
      'storeComments': storeComments,
    };
  }

  //
  factory Store.fromMap(Map<String, dynamic> map) {
    return Store(
      storeName: map['storeName'],
      storeId: map['storeId'],
      sellerId: map['sellerId'],
      storeLocation: map['storeLocation'],
      storeAddress: map['storeAddress'],
      storePhone: map['storePhone'],
      storeEmail: map['storeEmail'],
      storeDescription: map['storeDescription'],
      storeLogoPath: map['storeLogoPath'],
      storeCoverPath: map['storeCoverPath'],
      storeState: map['storeState'],
      storeStatus: map['storeStatus'],
      storeFiscalType: map['storeFiscalType'],
      paymentMethod: map['paymentMethod'],
      payementOwnerName: map['payementOwnerName'],
      paymentPhoneNumber: map['paymentPhoneNumber'],
      sellerOwnDeliver: map['sellerOwnDeliver'],
      storeSectors: List<String?>.from(map['storeSectors']),
      storeSubsectors: List<String?>.from(map['storeSubsectors']),
      storeProducts: List<String?>.from(map['storeProducts']),
      storeRatings: List<double?>.from(map['storeRatings']),
      storeComments: List<String?>.from(map['storeComments']),
    );
  }

  //
  factory Store.fromDocument(Map<String, dynamic> json) {
    return Store(
      storeName: json['storeName'],
      storeId: json['storeId'],
      sellerId: json['sellerId'],
      storeAddress: json['storeAddress'],
      storePhone: json['storePhone'],
      storeEmail: json['storeEmail'],
      storeDescription: json['storeDescription'],
      storeLogoPath: json['storeLogoPath'],
      storeCoverPath: json['storeCoverPath'],
      storeState: json['storeState'],
      storeStatus: json['storeStatus'],
      storeSectors: List<String?>.from(json['storeSectors']),
      storeSubsectors: List<String?>.from(json['storeSubsectors']),
      storeProducts: List<String?>.from(json['storeProducts']),
      storeRatings: List<double?>.from(json['storeRatings']),
      storeComments: List<String?>.from(json['storeComments']),
    );
  }
}
