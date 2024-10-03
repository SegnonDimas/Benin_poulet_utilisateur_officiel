import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentification_event.dart';
part 'authentification_state.dart';

class AuthentificationBloc
    extends Bloc<AuthentificationEvent, AuthentificationState> {
  AuthentificationBloc() : super(AuthentificationInitial()) {
    // infos vendeur
    on<SubmitSellerInfo>((event, emit) {
      try {
        final String? lastName = event.lastName;
        final String? firstName = event.firstName;
        final String? birthDate = event.birthday;
        final String? birthLocation = event.birthLocation;
        final String? currentLocation = event.currentLocation;
        return emit(AuthentificationGlobalState(
            sellerLastName: lastName,
            sellerFirstName: firstName,
            sellerBirthDate: birthDate,
            sellerBirthPlace: birthLocation,
            sellerCurrentLocation: currentLocation));
      } catch (e) {
        // Todo: implement
      }
    });

    // pièces d'identité
    on<SubmitIdentityDocuments>((event, emit) {
      try {
        final String country = event.country;
        final String idendityDocument = event.idendityDocument;
        return emit(AuthentificationGlobalState(
            country: country, idendityDocument: idendityDocument));
      } catch (e) {
        // Todo: implement
      }
    });

    // photo pièce d'identité
    on<SubmitPhotoDocuments>((event, emit) {
      try {
        final String photoRectoIdendityDocument =
            event.photoRectoIdendityDocument;
        final String photoVersoIdendityDocument =
            event.photoVersoIdendityDocument;
        final String fullPhoto = event.fullPhoto;
        return emit(AuthentificationGlobalState(
            photoRectoIdendityDocument: photoRectoIdendityDocument,
            photoVersoIdendityDocument: photoVersoIdendityDocument,
            fullPhoto: fullPhoto));
      } catch (e) {
        // Todo: implement
      }
    });
  }
}
