part of 'authentification_bloc.dart';

sealed class AuthentificationEvent {}

// info vendeur
class SubmitSellerInfo extends AuthentificationEvent {
  final String? lastName;
  final String? firstName;
  final String? birthday;
  final String? birthLocation;
  final String? currentLocation;

  SubmitSellerInfo(
      {this.lastName,
      this.firstName,
      this.birthday,
      this.birthLocation,
      this.currentLocation});
}

// pièces d'identité
class SubmitIdentityDocuments extends AuthentificationEvent {
  final String country;
  final String idendityDocument;

  SubmitIdentityDocuments(
      {required this.country, required this.idendityDocument});
}

// photo pièce d'identité
class SubmitPhotoDocuments extends AuthentificationEvent {
  final String photoRectoIdendityDocument;
  final String photoVersoIdendityDocument;
  final String fullPhoto;

  SubmitPhotoDocuments(
      {required this.photoRectoIdendityDocument,
      required this.photoVersoIdendityDocument,
      required this.fullPhoto});
}
