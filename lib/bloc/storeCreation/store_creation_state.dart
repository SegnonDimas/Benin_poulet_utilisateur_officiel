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
  final String? description;
  final String? zoneLivraison;
  final Map<String, String>? joursOuverture;
  final String? ville;
  final String? pays;
  final String? tempsLivraison;

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
    this.description,
    this.zoneLivraison,
    this.joursOuverture,
    this.ville,
    this.pays,
    this.tempsLivraison,
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
    String? description,
    String? zoneLivraison,
    Map<String, String>? joursOuverture,
    String? ville,
    String? pays,
    String? tempsLivraison,
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
              country: country ?? sellerGlobalState?.idDocumentCountry,
      idendityDocument: idendityDocument ?? sellerGlobalState?.idendityDocument,
              photoRectoIdendityDocument: photoRectoIdendityDocument ??
            sellerGlobalState?.idDocumentPhoto?['recto'],
        photoVersoIdendityDocument: photoVersoIdendityDocument ??
            sellerGlobalState?.idDocumentPhoto?['verso'],
      sellerFirstName: sellerFirstName ?? sellerGlobalState?.sellerFullName?.split(' ').first,
      sellerLastName: sellerLastName ?? sellerGlobalState?.sellerFullName?.split(' ').skip(1).join(' '),
      sellerBirthDate: sellerBirthDate ?? sellerGlobalState?.sellerBirthDate,
      sellerCurrentLocation:
          sellerCurrentLocation ?? sellerGlobalState?.sellerCurrentLocation,
      sellerBirthPlace: sellerBirthPlace ?? sellerGlobalState?.sellerBirthPlace,
      storeLocation: storeLocation ?? this.storeLocation,
      fullPhoto: fullPhoto ?? sellerGlobalState?.idDocumentPhoto?['selfie'],
      sellerGlobalState: sellerGlobalState ?? this.sellerGlobalState,
      description: description ?? this.description,
      zoneLivraison: zoneLivraison ?? this.zoneLivraison,
      joursOuverture: joursOuverture ?? this.joursOuverture,
      ville: ville ?? this.ville,
      pays: pays ?? this.pays,
      tempsLivraison: tempsLivraison ?? this.tempsLivraison,
    );
  }
}

// creation en cours d'exécution
class StoreCreationLoading extends StoreCreationGlobalState {}

// creation réussie
class StoreCreationSuccess extends StoreCreationGlobalState {
  final String? storeId;

  StoreCreationSuccess({this.storeId});
}

// erreur de creation - préserve toutes les données de l'état précédent
class StoreCreationError extends StoreCreationGlobalState {
  final String? erroMessage;

  StoreCreationError({
    String? erroMessage,
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
    String? description,
    String? zoneLivraison,
    Map<String, String>? joursOuverture,
    String? ville,
    String? pays,
    String? tempsLivraison,
  })  : erroMessage = erroMessage ??
            'Erreur lors de la creation de votre boutique, veuillez réessayer',
        super(
          storeName: storeName,
          storePhoneNumber: storePhoneNumber,
          storeEmail: storeEmail,
          storeSectors: storeSectors,
          storeSubSectors: storeSubSectors,
          storeFiscalType: storeFiscalType,
          paymentMethod: paymentMethod,
          paymentPhoneNumber: paymentPhoneNumber,
          payementOwnerName: payementOwnerName,
          sellerOwnDeliver: sellerOwnDeliver,
          location: location,
          locationDescription: locationDescription,
          sellerFirstName: sellerFirstName,
          sellerLastName: sellerLastName,
          sellerBirthDate: sellerBirthDate,
          sellerBirthPlace: sellerBirthPlace,
          sellerCurrentLocation: sellerCurrentLocation,
          storeLocation: storeLocation,
          country: country,
          idendityDocument: idendityDocument,
          photoRectoIdendityDocument: photoRectoIdendityDocument,
          photoVersoIdendityDocument: photoVersoIdendityDocument,
          fullPhoto: fullPhoto,
          sellerGlobalState: sellerGlobalState,
          description: description,
          zoneLivraison: zoneLivraison,
          joursOuverture: joursOuverture,
          ville: ville,
          pays: pays,
          tempsLivraison: tempsLivraison,
        );
}
