part of 'authentification_bloc.dart';

sealed class AuthentificationState {}

final class AuthentificationInitial extends AuthentificationState {}

// info vendeur
class SellerInfoSubmitted extends AuthentificationState {
  final String fullName;
  final String birthday;
  final String birthLocation;
  final String currentLocation;

  SellerInfoSubmitted(
      {required this.fullName,
      required this.birthday,
      required this.birthLocation,
      required this.currentLocation});
}

// pièces d'identité
class IdentityDocumentsSubmitted extends AuthentificationState {
  final String idDocumentCountry;
  final String idendityDocument;

  IdentityDocumentsSubmitted(
      {required this.idDocumentCountry, required this.idendityDocument});
}

// photo pièce d'identité
class PhotoDocumentsSubmitted extends AuthentificationState {
  final Map<String, String> idDocumentPhoto;

  PhotoDocumentsSubmitted({required this.idDocumentPhoto});
}

// pour le suivi de l'état global
class AuthentificationGlobalState extends AuthentificationState {
  final String? sellerFullName;
  final String? sellerBirthDate;
  final String? sellerBirthPlace;
  final String? sellerCurrentLocation;
  final String? idDocumentCountry;
  final String? idendityDocument;
  final Map<String, String>? idDocumentPhoto;

  // Constructeur avec des valeurs par défaut.
  AuthentificationGlobalState({
    this.idDocumentCountry = '',
    this.idendityDocument = '',
    this.idDocumentPhoto,
    this.sellerFullName = '',
    this.sellerBirthDate = '',
    this.sellerBirthPlace = '',
    this.sellerCurrentLocation = '',
  });

  // Copie de l'état avec des mises à jour.
  AuthentificationGlobalState copyWith({
    String? sellerFullName,
    String? sellerBirthDate,
    String? sellerBirthPlace,
    String? sellerCurrentLocation,
    String? idDocumentCountry,
    String? idendityDocument,
    Map<String, String>? idDocumentPhoto,
  }) {
    return AuthentificationGlobalState(
        idDocumentCountry: idDocumentCountry ?? this.idDocumentCountry,
        idendityDocument: idendityDocument ?? this.idendityDocument,
        idDocumentPhoto: idDocumentPhoto ?? this.idDocumentPhoto,
        sellerFullName: sellerFullName ?? this.sellerFullName,
        sellerBirthDate: sellerBirthDate ?? this.sellerBirthDate,
        sellerCurrentLocation:
            sellerCurrentLocation ?? this.sellerCurrentLocation,
        sellerBirthPlace: sellerBirthPlace ?? this.sellerBirthPlace);
  }
}
