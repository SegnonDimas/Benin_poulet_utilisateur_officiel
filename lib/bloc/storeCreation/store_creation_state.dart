part of 'store_creation_bloc.dart';

sealed class StoreCreationState {}

final class StoreCreationInitial extends StoreCreationGlobalState {}

// infos boutique
class StoreInfoSubmitted extends StoreCreationGlobalState {
  final String storeName;
  final String storeEmail;

  StoreInfoSubmitted(this.storeName, this.storeEmail);
}

// secteurs et sous-secteurs boutique
class SectoreInfoSubmitted extends StoreCreationState {
  final List<String> storeSectors;
  final List<String> storeSubSectors;

  SectoreInfoSubmitted({
    required this.storeSectors,
    required this.storeSubSectors,
  });
}

// payment info
class PaymentInfoSubmitted extends StoreCreationState {
  final String? storeFiscalType;
  final String? paymentMethod;
  final String? paymentPhoneNumber;
  final String? payementOwnerName;

  PaymentInfoSubmitted(
      {this.storeFiscalType,
      this.paymentMethod,
      this.paymentPhoneNumber,
      this.payementOwnerName});
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

/*
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
*/

// pour le suivi de l'état global
class StoreCreationGlobalState extends StoreCreationState {
  final String? storeName;
  final String? storePhoneNumber;
  final String? storeEmail;
  final List<String>? storeSectors;
  final List<String>? storeSubSectors;
  //TODO final List<String>? storeProducts;
  final String? storeFiscalType;
  final String? paymentMethod;
  final String? paymentPhoneNumber;
  final String? payementOwnerName;
  final bool? sellerOwnDeliver;
  final String? location;
  final String? locationDescription;
  final String? sellerFirstName;
  final String? sellerLastName;
  final String? sellerBirthDate;
  final String? sellerBirthPlace;
  final String? sellerCurrentLocation;
  final String? storeLocation;
  final String? country;
  final String? idendityDocument;
  final String? photoRectoIdendityDocument;
  final String? photoVersoIdendityDocument;
  final String? fullPhoto;
  final AuthentificationGlobalState? sellerGlobalState;

  // Constructeur avec des valeurs par défaut.
  StoreCreationGlobalState({
    this.storeName,
    this.storeEmail,
    this.storePhoneNumber,
    this.storeSectors,
    this.storeSubSectors,
    this.storeFiscalType = 'Particulier',
    this.paymentPhoneNumber,
    this.payementOwnerName,
    this.sellerOwnDeliver = false,
    this.location,
    this.locationDescription,
    this.country = "Benin",
    this.idendityDocument,
    this.photoRectoIdendityDocument,
    this.photoVersoIdendityDocument,
    this.fullPhoto,
    this.sellerFirstName,
    this.sellerLastName,
    this.sellerBirthDate,
    this.sellerBirthPlace,
    this.sellerCurrentLocation,
    this.paymentMethod = 'MTN',
    this.storeLocation,
    this.sellerGlobalState,
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
    String? payementOwnerName,
    bool? sellerOwnDeliver,
    String? location,
    String? locationDescription,
    String? sellerFirstName,
    String? sellerLastName,
    String? sellerBirthDate,
    String? sellerBirthPlace,
    String? sellerCurrentLocation,
    String? storeLocation,
    String? country,
    String? idendityDocument,
    String? photoRectoIdendityDocument,
    String? photoVersoIdendityDocument,
    String? fullPhoto,
    AuthentificationGlobalState? sellerGlobalState,
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
      payementOwnerName: payementOwnerName ?? this.payementOwnerName,
      sellerOwnDeliver: sellerOwnDeliver ?? this.sellerOwnDeliver,
      location: location ?? this.location,
      locationDescription: locationDescription ?? this.locationDescription,
      country: country ?? sellerGlobalState?.country,
      idendityDocument: idendityDocument ?? sellerGlobalState?.idendityDocument,
      photoRectoIdendityDocument: photoRectoIdendityDocument ??
          sellerGlobalState?.photoRectoIdendityDocument,
      photoVersoIdendityDocument: photoVersoIdendityDocument ??
          sellerGlobalState?.photoVersoIdendityDocument,
      sellerFirstName: sellerFirstName ?? sellerGlobalState?.sellerFirstName,
      sellerLastName: sellerLastName ?? sellerGlobalState?.sellerLastName,
      sellerBirthDate: sellerBirthDate ?? sellerGlobalState?.sellerBirthDate,
      sellerCurrentLocation:
          sellerCurrentLocation ?? sellerGlobalState?.sellerCurrentLocation,
      sellerBirthPlace: sellerBirthPlace ?? sellerGlobalState?.sellerBirthPlace,
      storeLocation: storeLocation ?? this.storeLocation,
      fullPhoto: fullPhoto ?? sellerGlobalState?.fullPhoto,
      sellerGlobalState: sellerGlobalState ?? this.sellerGlobalState,
    );
  }
}
