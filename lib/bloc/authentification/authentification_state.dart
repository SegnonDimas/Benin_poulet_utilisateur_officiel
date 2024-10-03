part of 'authentification_bloc.dart';

sealed class AuthentificationState {}

final class AuthentificationInitial extends AuthentificationState {}

// info vendeur
class SellerInfoSubmitted extends AuthentificationState {
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
class IdentityDocumentsSubmitted extends AuthentificationState {
  final String country;
  final String idendityDocument;

  IdentityDocumentsSubmitted(
      {required this.country, required this.idendityDocument});
}

// photo pièce d'identité
class PhotoDocumentsSubmitted extends AuthentificationState {
  final String photoRectoIdendityDocument;
  final String photoVersoIdendityDocument;
  final String fullPhoto;

  PhotoDocumentsSubmitted(
      {required this.photoRectoIdendityDocument,
      required this.photoVersoIdendityDocument,
      required this.fullPhoto});
}

// pour le suivi de l'état global
class AuthentificationGlobalState extends AuthentificationState {
  final String? sellerFirstName;
  final String? sellerLastName;
  final String? sellerBirthDate;
  final String? sellerBirthPlace;
  final String? sellerCurrentLocation;
  final String? country;
  final String? idendityDocument;
  final String? photoRectoIdendityDocument;
  final String? photoVersoIdendityDocument;
  final String? fullPhoto;

  // Constructeur avec des valeurs par défaut.
  AuthentificationGlobalState({
    this.country = '',
    this.idendityDocument = '',
    this.photoRectoIdendityDocument = '',
    this.photoVersoIdendityDocument = '',
    this.fullPhoto = '',
    this.sellerFirstName = '',
    this.sellerLastName = '',
    this.sellerBirthDate = '',
    this.sellerBirthPlace = '',
    this.sellerCurrentLocation = '',
  });

  // Copie de l'état avec des mises à jour.
  AuthentificationState copyWith({
    String? sellerFirstName,
    String? sellerLastName,
    String? sellerBirthDate,
    String? sellerBirthPlace,
    String? sellerCurrentLocation,
    String? country,
    String? idendityDocument,
    String? photoRectoIdendityDocument,
    String? photoVersoIdendityDocument,
    String? fullPhoto,
  }) {
    return AuthentificationGlobalState(
        country: country ?? this.country,
        idendityDocument: idendityDocument ?? this.idendityDocument,
        photoRectoIdendityDocument:
            photoRectoIdendityDocument ?? this.photoRectoIdendityDocument,
        photoVersoIdendityDocument:
            photoVersoIdendityDocument ?? this.photoVersoIdendityDocument,
        sellerFirstName: sellerFirstName ?? this.sellerFirstName,
        sellerLastName: sellerLastName ?? this.sellerLastName,
        sellerBirthDate: sellerBirthDate ?? this.sellerBirthDate,
        sellerCurrentLocation:
            sellerCurrentLocation ?? this.sellerCurrentLocation,
        sellerBirthPlace: sellerBirthPlace ?? this.sellerBirthPlace,
        fullPhoto: fullPhoto ?? this.fullPhoto);
  }
}
