part of 'store_creation_bloc.dart';

sealed class StoreCreationState {}

final class StoreCreationInitial extends StoreCreationState {}

class StoreInfoSubmitted extends StoreCreationState {
  final String storeName;
  final String storeEmail;

  StoreInfoSubmitted(this.storeName, this.storeEmail);
}

// secteurs et sous-secteurs boutique
class SectorInfoSubmitted extends StoreCreationState {
  final List<String> storeSectors;
  final List<String> storeSubSectors;

  SectorInfoSubmitted({
    required this.storeSectors,
    required this.storeSubSectors,
  });
}

// payment info
class PaymentInfoSubmitted extends StoreCreationState {
  final String storeFiscalType;
  final String paymentMethod;
  final String paymentPhoneNumber;
  final String name;

  PaymentInfoSubmitted(
      {required this.storeFiscalType,
      required this.paymentMethod,
      required this.paymentPhoneNumber,
      required this.name});
}

// info livraison
class DeliveryInfoSubmitted extends StoreCreationState {
  final bool sellerOwnDeliver;
  final String location;
  final String locationDescription;

  DeliveryInfoSubmitted(
      {required this.sellerOwnDeliver,
      required this.location,
      required this.locationDescription});
}

// info vendeur
class SellerInfoSubmitted extends StoreCreationState {
  final String lastName;
  final String firstName;
  final String birthday;
  final String birthLocation;
  final String currentLocation;

  SellerInfoSubmitted(
      {required this.lastName,
      required this.firstName,
      required this.birthday,
      required this.birthLocation,
      required this.currentLocation});
}

// pièces d'identité
class IdentityDocumentsSubmitted extends StoreCreationState {
  final String country;
  final String idendityDocument;

  IdentityDocumentsSubmitted(
      {required this.country, required this.idendityDocument});
}

// photo pièce d'identité
class PhotoDocumentsSubmitted extends StoreCreationState {
  final String photoRectoIdendityDocument;
  final String photoVersoIdendityDocument;
  final String fullPhoto;

  PhotoDocumentsSubmitted(
      {required this.photoRectoIdendityDocument,
      required this.photoVersoIdendityDocument,
      required this.fullPhoto});
}

// pour le suivi de l'état global
class StoreCreationGlobalState extends StoreCreationState {
  final String storeName;
  final String storePhoneNumber;
  final String storeEmail;
  final List<String> storeSectors;
  final List<String> storeSubSectors;
  final String storeFiscalType;
  final String paymentMethod;
  final String paymentPhoneNumber;
  final String name;
  final bool sellerOwnDeliver;
  final String location;
  final String locationDescription;
  final String sellerName;
  final String sellerBirthDate;
  final String sellerBirthPlace;
  final String storeLocation;
  final String country;
  final String idendityDocument;
  final String photoRectoIdendityDocument;
  final String photoVersoIdendityDocument;
  final String fullPhoto;

  // Constructeur avec des valeurs par défaut.
  StoreCreationGlobalState({
    this.storeName = '',
    this.storeEmail = '',
    this.storePhoneNumber = '',
    this.storeSectors = const [],
    this.storeSubSectors = const [],
    this.storeFiscalType = '',
    this.paymentPhoneNumber = '',
    this.name = '',
    this.sellerOwnDeliver = false,
    this.location = '',
    this.locationDescription = '',
    this.country = '',
    this.idendityDocument = '',
    this.photoRectoIdendityDocument = '',
    this.photoVersoIdendityDocument = '',
    this.fullPhoto = '',
    this.sellerName = '',
    this.sellerBirthDate = '',
    this.sellerBirthPlace = '',
    this.paymentMethod = '',
    this.storeLocation = '',
  });

  // Copie de l'état avec des mises à jour.
  StoreCreationState copyWith({
    String? storeName,
    String? storePhoneNumber,
    String? storeEmail,
    List<String>? storeSectors,
    List<String>? storeSubSectors,
    String? storeFiscalType,
    String? paymentMethod,
    String? paymentPhoneNumber,
    String? name,
    bool? sellerOwnDeliver,
    String? location,
    String? locationDescription,
    String? sellerName,
    String? sellerBirthDate,
    String? sellerBirthPlace,
    String? storeLocation,
    String? country,
    String? idendityDocument,
    String? photoRectoIdendityDocument,
    String? photoVersoIdendityDocument,
    String? fullPhoto,
  }) {
    return StoreCreationGlobalState(
        storeName: storeName ?? this.storeName,
        storePhoneNumber: storePhoneNumber ?? this.storePhoneNumber,
        storeEmail: storeEmail ?? this.storeEmail,
        storeSectors: storeSectors ?? this.storeSectors,
        storeSubSectors: storeSubSectors ?? this.storeSubSectors,
        storeFiscalType: storeFiscalType ?? this.storeFiscalType,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        paymentPhoneNumber: paymentPhoneNumber ?? this.paymentPhoneNumber,
        name: name ?? this.name,
        sellerOwnDeliver: sellerOwnDeliver ?? this.sellerOwnDeliver,
        location: location ?? this.location,
        locationDescription: locationDescription ?? this.locationDescription,
        country: country ?? this.country,
        idendityDocument: idendityDocument ?? this.idendityDocument,
        photoRectoIdendityDocument:
            photoRectoIdendityDocument ?? this.photoRectoIdendityDocument,
        photoVersoIdendityDocument:
            photoVersoIdendityDocument ?? this.photoVersoIdendityDocument,
        sellerName: sellerName ?? this.sellerName,
        sellerBirthDate: sellerBirthDate ?? this.sellerBirthDate,
        sellerBirthPlace: sellerBirthPlace ?? this.sellerBirthPlace,
        storeLocation: storeLocation ?? this.storeLocation,
        fullPhoto: fullPhoto ?? this.fullPhoto);
  }
}
