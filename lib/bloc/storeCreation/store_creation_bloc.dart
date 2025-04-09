import 'package:flutter_bloc/flutter_bloc.dart';

import '../authentification/authentification_bloc.dart';

part 'store_creation_event.dart';
part 'store_creation_state.dart';

class StoreCreationBloc extends Bloc<StoreCreationEvent, StoreCreationState> {
  StoreCreationBloc() : super(StoreCreationInitial()) {
    // infos boutique
    on<SubmitStoreInfo>((event, emit) {
      try {
        final String? storeName = event.storeName;
        final String? storePhoneNumber = event.storePhoneNumber;
        final String? storeEmail = event.storeEmail;
        return emit(StoreCreationGlobalState(
          storeName: storeName,
          storePhoneNumber: storePhoneNumber,
          storeEmail: storeEmail,
        ));
      } catch (e) {
        //Todo: implement
      }
    });

    // secteurs et sous-secteurs boutique
    on<SubmitSectoreInfo>((event, emit) {
      try {
        final List<String> storeSectors = event.storeSectors;
        final List<String> storeSubSectors = event.storeSubSectors;
        return emit(StoreCreationGlobalState(
            storeSectors: storeSectors, storeSubSectors: storeSubSectors));
      } catch (e) {
        // Todo: implement
      }
    });

    // payement infos
    on<SubmitPaymentInfo>((event, emit) {
      try {
        final String? storeFiscalType = event.storeFiscalType;
        final String? paymentMethod = event.paymentMethod;
        final String? paymentPhoneNumber = event.paymentPhoneNumber;
        final String? payementOwnerName = event.payementOwnerName;
        return emit(StoreCreationGlobalState(
            storeFiscalType: storeFiscalType,
            paymentMethod: paymentMethod,
            paymentPhoneNumber: paymentPhoneNumber,
            payementOwnerName: payementOwnerName));
      } catch (e) {
        // Todo: implement
      }
    });

    // infos livraison
    on<SubmitDeliveryInfo>((event, emit) {
      try {
        final bool? sellerOwnDeliver = event.sellerOwnDeliver;
        final String? location = event.location;
        final String? locationDescription = event.locationDescription;
        return emit(StoreCreationGlobalState(
            sellerOwnDeliver: sellerOwnDeliver,
            location: location,
            locationDescription: locationDescription));
      } catch (e) {
        // Todo: implement
      }
    });

    // état général
    on<StoreCreationGlobalEvent>((event, emit) {
      try {
        final String? storeName = event.storeName;
        final String? storePhoneNumber = event.storePhoneNumber;
        final String? storeEmail = event.storeEmail;
        final List<String>? storeSectors = event.storeSectors;
        final List<String>? storeSubSectors = event.storeSubSectors;
        final String? storeFiscalType = event.storeFiscalType;
        final String? paymentMethod = event.paymentMethod;
        final String? paymentPhoneNumber = event.paymentPhoneNumber;
        final String? payementOwnerName = event.payementOwnerName;
        final bool? sellerOwnDeliver = event.sellerOwnDeliver;
        final String? location = event.location;
        final String? locationDescription = event.locationDescription;
        final String? sellerFirstName = event.sellerFirstName;
        final String? sellerLastName = event.sellerLastName;
        final String? sellerBirthDate = event.sellerBirthDate;
        final String? sellerBirthPlace = event.sellerBirthPlace;
        final String? sellerCurrentLocation = event.sellerCurrentLocation;
        final String? storeLocation = event.storeLocation;
        final String? country = event.country;
        final String? idendityDocument = event.idendityDocument;
        final String? photoRectoIdendityDocument =
            event.photoRectoIdendityDocument;
        final String? photoVersoIdendityDocument =
            event.photoVersoIdendityDocument;
        final String? fullPhoto = event.fullPhoto;
        final AuthentificationGlobalState? sellerGlobalState =
            event.sellerGlobalState;

        return emit(StoreCreationGlobalState(
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
        ));
      } catch (e) {
        //Todo: implement
      }
    });

    /* // infos vendeur
    on<SubmitSellerInfo>((event, emit) {
      try {
        final String lastName = event.lastName;
        final String firstName = event.firstName;
        final String birthDate = event.birthday;
        final String birthLocation = event.birthLocation;
        final String currentLocation = event.currentLocation;
        return emit(StoreCreationGlobalState(
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
        return emit(StoreCreationGlobalState(
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
        return emit(StoreCreationGlobalState(
            photoRectoIdendityDocument: photoRectoIdendityDocument,
            photoVersoIdendityDocument: photoVersoIdendityDocument,
            fullPhoto: fullPhoto));
      } catch (e) {
        // Todo: implement
      }
    });*/
  }
}
