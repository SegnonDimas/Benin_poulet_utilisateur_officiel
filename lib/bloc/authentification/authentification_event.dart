part of 'authentification_bloc.dart';

sealed class AuthentificationEvent {}

// info vendeur
class SubmitSellerInfo extends AuthentificationEvent {
  final String? fullName;
  final String? birthday;
  final String? birthLocation;
  final String? currentLocation;

  SubmitSellerInfo(
      {this.fullName,
      this.birthday,
      this.birthLocation,
      this.currentLocation});
}

// pièces d'identité
class SubmitIdentityDocuments extends AuthentificationEvent {
  final String idDocumentCountry;
  final String idendityDocument;

  SubmitIdentityDocuments(
      {required this.idDocumentCountry, required this.idendityDocument});
}

// photo pièce d'identité
class SubmitPhotoDocuments extends AuthentificationEvent {
  final Map<String, String> idDocumentPhoto;

  SubmitPhotoDocuments({required this.idDocumentPhoto});
}
