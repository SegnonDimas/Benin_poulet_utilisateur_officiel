import 'package:flutter_bloc/flutter_bloc.dart';

part 'authentification_event.dart';
part 'authentification_state.dart';

class AuthentificationBloc
    extends Bloc<AuthentificationEvent, AuthentificationState> {
  AuthentificationBloc() : super(AuthentificationInitial()) {
    // infos vendeur
    on<SubmitSellerInfo>((event, emit) {
      try {
        final String? fullName = event.fullName;
        final String? birthDate = event.birthday;
        final String? birthLocation = event.birthLocation;
        final String? currentLocation = event.currentLocation;
        
        // Récupérer l'état actuel pour préserver les données existantes
        if (state is AuthentificationGlobalState) {
          final currentState = state as AuthentificationGlobalState;
          // Préserver l'état existant et mettre à jour seulement les nouvelles données
          return emit(currentState.copyWith(
            sellerFullName: fullName,
            sellerBirthDate: birthDate,
            sellerBirthPlace: birthLocation,
            sellerCurrentLocation: currentLocation,
          ));
        } else {
          // Créer un nouvel état si c'est le premier événement
          return emit(AuthentificationGlobalState(
            sellerFullName: fullName,
            sellerBirthDate: birthDate,
            sellerBirthPlace: birthLocation,
            sellerCurrentLocation: currentLocation,
          ));
        }
      } catch (e) {
        print('Erreur dans SubmitSellerInfo: $e');
      }
    });

    // pièces d'identité
    on<SubmitIdentityDocuments>((event, emit) {
      try {
        final String idDocumentCountry = event.idDocumentCountry;
        final String idendityDocument = event.idendityDocument;
        
        // Récupérer l'état actuel pour préserver les données existantes
        if (state is AuthentificationGlobalState) {
          final currentState = state as AuthentificationGlobalState;
          // Préserver l'état existant et mettre à jour seulement les nouvelles données
          return emit(currentState.copyWith(
            idDocumentCountry: idDocumentCountry,
            idendityDocument: idendityDocument,
          ));
        } else {
          // Créer un nouvel état si c'est le premier événement
          return emit(AuthentificationGlobalState(
            idDocumentCountry: idDocumentCountry,
            idendityDocument: idendityDocument,
          ));
        }
      } catch (e) {
        print('Erreur dans SubmitIdentityDocuments: $e');
      }
    });

    // photo pièce d'identité
    on<SubmitPhotoDocuments>((event, emit) {
      try {
        final Map<String, String> idDocumentPhoto = event.idDocumentPhoto;
        
        // Récupérer l'état actuel pour préserver les données existantes
        if (state is AuthentificationGlobalState) {
          final currentState = state as AuthentificationGlobalState;
          // Préserver l'état existant et mettre à jour seulement les nouvelles données
          return emit(currentState.copyWith(
            idDocumentPhoto: idDocumentPhoto,
          ));
        } else {
          // Créer un nouvel état si c'est le premier événement
          return emit(AuthentificationGlobalState(
            idDocumentPhoto: idDocumentPhoto,
          ));
        }
      } catch (e) {
        print('Erreur dans SubmitPhotoDocuments: $e');
      }
    });
  }
}
