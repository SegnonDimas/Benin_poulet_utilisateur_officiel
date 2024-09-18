part of 'store_creation_bloc.dart';

sealed class StoreCreationEvent {}

// info boutique
class SubmitStoreInfo extends StoreCreationEvent {
  final String storeName;
  final String storePhoneNumber;
  final String storeEmail;

  SubmitStoreInfo(
      {required this.storeName,
      required this.storePhoneNumber,
      required this.storeEmail});
}

// secteurs et sous-secteurs boutique
class SubmitSectorInfo extends StoreCreationEvent {
  final List<String> storeSectors;
  final List<String> storeSubSectors;

  SubmitSectorInfo({
    required this.storeSectors,
    required this.storeSubSectors,
  });
}

// payment info
class SubmitPaymentInfo extends StoreCreationEvent {
  final String storeFiscalType;
  final String paymentMethod;
  final String paymentPhoneNumber;
  final String name;

  SubmitPaymentInfo(
      {required this.storeFiscalType,
      required this.paymentMethod,
      required this.paymentPhoneNumber,
      required this.name});
}

// info livraison
class SubmitDeliveryInfo extends StoreCreationEvent {
  final bool sellerOwnDeliver;
  final String location;
  final String locationDescription;

  SubmitDeliveryInfo(
      {required this.sellerOwnDeliver,
      required this.location,
      required this.locationDescription});
}

// info vendeur
class SubmitSellerInfo extends StoreCreationEvent {
  final String lastName;
  final String firstName;
  final String birthday;
  final String birthLocation;
  final String currentLocation;

  SubmitSellerInfo(
      {required this.lastName,
      required this.firstName,
      required this.birthday,
      required this.birthLocation,
      required this.currentLocation});
}

// pièces d'identité
class SubmitIdentityDocuments extends StoreCreationEvent {
  final String country;
  final String idendityDocument;

  SubmitIdentityDocuments(
      {required this.country, required this.idendityDocument});
}

// photo pièce d'identité
class SubmitPhotoDocuments extends StoreCreationEvent {
  final String photoRectoIdendityDocument;
  final String photoVersoIdendityDocument;
  final String fullPhoto;

  SubmitPhotoDocuments(
      {required this.photoRectoIdendityDocument,
      required this.photoVersoIdendityDocument,
      required this.fullPhoto});
}
