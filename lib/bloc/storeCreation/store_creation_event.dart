part of 'store_creation_bloc.dart';

sealed class StoreCreationEvent {}

// info boutique
class SubmitStoreInfo extends StoreCreationEvent {
  final String? storeName;
  final String? storePhoneNumber;
  final String? storeEmail;

  /*final String? storeName;
  final String? storePhoneNumber;
  final String? storeEmail;*/

  SubmitStoreInfo({this.storeName, this.storePhoneNumber, this.storeEmail});
}

// secteurs et sous-secteurs boutique
class SubmitSectoreInfo extends StoreCreationEvent {
  final List<String> storeSectors;
  final List<String> storeSubSectors;

  SubmitSectoreInfo({
    required this.storeSectors,
    required this.storeSubSectors,
  });
}

// payment info
class SubmitPaymentInfo extends StoreCreationEvent {
  final String? storeFiscalType;
  final String? paymentMethod;
  final String? paymentPhoneNumber;
  final String? payementOwnerName;

  SubmitPaymentInfo(
      {this.storeFiscalType,
      this.paymentMethod,
      this.paymentPhoneNumber,
      this.payementOwnerName});
}

// info livraison
class SubmitDeliveryInfo extends StoreCreationEvent {
  final bool? sellerOwnDeliver;
  final String? location;
  final String? locationDescription;

  SubmitDeliveryInfo(
      {this.sellerOwnDeliver, this.location, this.locationDescription});
}

// pour le suivi de l'état global
class StoreCreationGlobalEvent extends StoreCreationEvent {
  final String? storeName;
  final String? storePhoneNumber;
  final String? storeEmail;
  final List<String>? storeSectors;
  final List<String>? storeSubSectors;
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
  final String? description;
  final String? zoneLivraison;
  final Map<String, String>? joursOuverture;
  final String? ville;
  final String? pays;
  final String? tempsLivraison;

  // Constructeur avec des valeurs par défaut.
  StoreCreationGlobalEvent({
    this.storeName,
    this.storeEmail,
    this.storePhoneNumber,
    this.storeSectors,
    this.storeSubSectors,
    this.storeFiscalType,
    this.paymentPhoneNumber,
    this.payementOwnerName,
    this.sellerOwnDeliver,
    this.location,
    this.locationDescription,
    this.country,
    this.idendityDocument,
    this.photoRectoIdendityDocument,
    this.photoVersoIdendityDocument,
    this.fullPhoto,
    this.sellerFirstName,
    this.sellerLastName,
    this.sellerBirthDate,
    this.sellerBirthPlace,
    this.sellerCurrentLocation,
    this.paymentMethod,
    this.storeLocation,
    this.sellerGlobalState,
    this.description,
    this.zoneLivraison,
    this.joursOuverture,
    this.ville,
    this.pays,
    this.tempsLivraison,
  });

  // Copie de l'état avec des mises à jour.
  StoreCreationEvent copyWith({
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
    String? description,
    String? zoneLivraison,
    Map<String, String>? joursOuverture,
    String? ville,
    String? pays,
    String? tempsLivraison,
  }) {
    return StoreCreationGlobalEvent(
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
        idendityDocument:
            idendityDocument ?? sellerGlobalState?.idendityDocument,
        photoRectoIdendityDocument: photoRectoIdendityDocument ??
            sellerGlobalState?.photoRectoIdendityDocument,
        photoVersoIdendityDocument: photoVersoIdendityDocument ??
            sellerGlobalState?.photoVersoIdendityDocument,
        sellerFirstName: sellerFirstName ?? sellerGlobalState?.sellerFirstName,
        sellerLastName: sellerLastName ?? sellerGlobalState?.sellerLastName,
        sellerBirthDate: sellerBirthDate ?? sellerGlobalState?.sellerBirthDate,
        sellerCurrentLocation:
            sellerCurrentLocation ?? sellerGlobalState?.sellerCurrentLocation,
        sellerBirthPlace:
            sellerBirthPlace ?? sellerGlobalState?.sellerBirthPlace,
        storeLocation: storeLocation ?? this.storeLocation,
        fullPhoto: fullPhoto ?? sellerGlobalState?.fullPhoto,
        description: description ?? this.description,
        zoneLivraison: zoneLivraison ?? this.zoneLivraison,
        joursOuverture: joursOuverture ?? this.joursOuverture,
        ville: ville ?? this.ville,
        pays: pays ?? this.pays,
        tempsLivraison: tempsLivraison ?? this.tempsLivraison);
  }
}

// soumission de la creation de boutique
class StoreCreationSubmit extends StoreCreationEvent {}

//
class StoreCreationErrorEvent extends StoreCreationEvent {
  final String erroMessage;

  StoreCreationErrorEvent({required this.erroMessage});
}

//
class StoreCreationSuccessEvent extends StoreCreationEvent {}
