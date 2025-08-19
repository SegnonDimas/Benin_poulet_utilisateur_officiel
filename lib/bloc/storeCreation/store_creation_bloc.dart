import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/constants/firebase_collections/sellersCollection.dart';
import 'package:benin_poulet/constants/firebase_collections/storesCollection.dart';
import 'package:benin_poulet/constants/storeState.dart';
import 'package:benin_poulet/constants/storeStatus.dart';

import '../authentification/authentification_bloc.dart';

part 'store_creation_event.dart';
part 'store_creation_state.dart';

class StoreCreationBloc extends Bloc<StoreCreationEvent, StoreCreationState> {
  final FirestoreService _firestoreService = FirestoreService();

  // Fonction utilitaire pour émettre une erreur en préservant l'état
  void _emitErrorWithState(
      Emitter<StoreCreationState> emit, String errorMessage) {
    final currentState = state is StoreCreationGlobalState
        ? state as StoreCreationGlobalState
        : StoreCreationGlobalState();

    emit(StoreCreationError(
      erroMessage: errorMessage,
      storeName: currentState.storeName,
      storePhoneNumber: currentState.storePhoneNumber,
      storeEmail: currentState.storeEmail,
      storeSectors: currentState.storeSectors,
      storeSubSectors: currentState.storeSubSectors,
      storeFiscalType: currentState.storeFiscalType,
      paymentMethod: currentState.paymentMethod,
      paymentPhoneNumber: currentState.paymentPhoneNumber,
      payementOwnerName: currentState.payementOwnerName,
      sellerOwnDeliver: currentState.sellerOwnDeliver,
      location: currentState.location,
      locationDescription: currentState.locationDescription,
      sellerFirstName: currentState.sellerFirstName,
      sellerLastName: currentState.sellerLastName,
      sellerBirthDate: currentState.sellerBirthDate,
      sellerBirthPlace: currentState.sellerBirthPlace,
      sellerCurrentLocation: currentState.sellerCurrentLocation,
      storeLocation: currentState.storeLocation,
      country: currentState.country,
      idendityDocument: currentState.idendityDocument,
      photoRectoIdendityDocument: currentState.photoRectoIdendityDocument,
      photoVersoIdendityDocument: currentState.photoVersoIdendityDocument,
      fullPhoto: currentState.fullPhoto,
      sellerGlobalState: currentState.sellerGlobalState,
      description: currentState.description,
      zoneLivraison: currentState.zoneLivraison,
      joursOuverture: currentState.joursOuverture,
      ville: currentState.ville,
      pays: currentState.pays,
      tempsLivraison: currentState.tempsLivraison,
    ));
  }

  StoreCreationBloc() : super(StoreCreationInitial()) {
    // infos boutique
    on<SubmitStoreInfo>((event, emit) {
      final currentState = state is StoreCreationGlobalState
          ? state as StoreCreationGlobalState
          : StoreCreationGlobalState();
      emit(currentState.copyWith(
        storeName: event.storeName,
        storePhoneNumber: event.storePhoneNumber,
        storeEmail: event.storeEmail,
      ));
    });

    // secteurs et sous-secteurs boutique
    on<SubmitSectoreInfo>((event, emit) {
      try {
        final List<String> storeSectors = event.storeSectors;
        final List<String> storeSubSectors = event.storeSubSectors;
        final currentState = state is StoreCreationGlobalState
            ? state as StoreCreationGlobalState
            : StoreCreationGlobalState();
        return emit(currentState.copyWith(
            storeSectors: storeSectors, storeSubSectors: storeSubSectors));
      } catch (e) {
        _emitErrorWithState(
            emit, 'Erreur lors de la sauvegarde des secteurs: $e');
      }
    });

    // payement infos
    on<SubmitPaymentInfo>((event, emit) {
      try {
        final String? storeFiscalType = event.storeFiscalType;
        final String? paymentMethod = event.paymentMethod;
        final String? paymentPhoneNumber = event.paymentPhoneNumber;
        final String? payementOwnerName = event.payementOwnerName;
        final currentState = state is StoreCreationGlobalState
            ? state as StoreCreationGlobalState
            : StoreCreationGlobalState();
        return emit(currentState.copyWith(
            storeFiscalType: storeFiscalType,
            paymentMethod: paymentMethod,
            paymentPhoneNumber: paymentPhoneNumber,
            payementOwnerName: payementOwnerName));
      } catch (e) {
        _emitErrorWithState(emit,
            'Erreur lors de la sauvegarde des informations de paiement: $e');
      }
    });

    // infos livraison
    on<SubmitDeliveryInfo>((event, emit) {
      try {
        final bool? sellerOwnDeliver = event.sellerOwnDeliver;
        final String? location = event.location;
        final String? locationDescription = event.locationDescription;
        final currentState = state is StoreCreationGlobalState
            ? state as StoreCreationGlobalState
            : StoreCreationGlobalState();
        return emit(currentState.copyWith(
            sellerOwnDeliver: sellerOwnDeliver,
            location: location,
            locationDescription: locationDescription));
      } catch (e) {
        _emitErrorWithState(emit,
            'Erreur lors de la sauvegarde des informations de livraison: $e');
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
        final String? description = event.description;
        final String? zoneLivraison = event.zoneLivraison;
        final Map<String, String>? joursOuverture = event.joursOuverture;
        final String? ville = event.ville;
        final String? pays = event.pays;
        final String? tempsLivraison = event.tempsLivraison;

        final currentState = state is StoreCreationGlobalState
            ? state as StoreCreationGlobalState
            : StoreCreationGlobalState();

        return emit(currentState.copyWith(
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
        ));
      } catch (e) {
        _emitErrorWithState(
            emit, 'Erreur lors de la mise à jour de l\'état: $e');
      }
    });

    // Soumission de la création de boutique
    on<StoreCreationSubmit>((event, emit) async {
      // Récupérer l'état actuel avant de commencer
      final currentState = state is StoreCreationGlobalState
          ? state as StoreCreationGlobalState
          : StoreCreationGlobalState();

      try {
        // Émettre l'état de chargement
        emit(StoreCreationLoading());

        // Vérifier que l'utilisateur est connecté
        if (AuthServices.userId == null) {
          emit(StoreCreationError(
              erroMessage: 'Vous devez être connecté pour créer une boutique'));
          return;
        }

        // Vérifier les champs obligatoires
        if (currentState.storeName == null || currentState.storeName!.isEmpty) {
          emit(StoreCreationError(
              erroMessage: 'Le nom de la boutique est obligatoire'));
          return;
        }

        // Préparer les informations de mobile money
        final mobileMoney = currentState.paymentPhoneNumber != null
            ? [
                {
                  MobileMoney.gsmService: currentState.paymentMethod ?? 'Aucun',
                  MobileMoney.name: currentState.payementOwnerName ?? '',
                  MobileMoney.phone: currentState.paymentPhoneNumber!,
                }
              ]
            : null;

        // Créer la boutique avec toutes les informations
        final storeId = await _firestoreService.createCompleteStore(
          sellerId: AuthServices.userId!,
          storeAddress: currentState.locationDescription,
          storeLocation: currentState.storeLocation,
          storeDescription: currentState.storeName ?? '',
          storeFiscalType: currentState.storeFiscalType,
          sellerOwnDeliver: currentState.sellerOwnDeliver,
          storeSectors: currentState.storeSectors,
          storeSubsectors: currentState.storeSubSectors,
          storeProducts: [],
          storeRatings: [0.0],
          storeComments: [],
          storeState: StoreState.open,
          storeStatus: StoreStatus.active,
          mobileMoney: mobileMoney,
          storeInfos: {
            StoreInfos.name: currentState.storeName!,
            StoreInfos.phone: currentState.storePhoneNumber,
            StoreInfos.email: currentState.storeEmail,
          },
          description: currentState.description ?? currentState.storeName ?? '',
          ville: currentState.ville ?? currentState.location ?? '',
          pays: currentState.pays ?? 'Bénin',
          joursOuverture: currentState.joursOuverture ?? {'default': 'Tous les jours'},
          tempsLivraison: currentState.tempsLivraison ?? '30-60 minutes',
          zoneLivraison: currentState.zoneLivraison ?? 'Zone locale',
        );

        // Mettre à jour le profil vendeur avec les informations de la boutique
        await _firestoreService.updateSellerPreservingStores(
          sellerId: AuthServices.userId!,
          userId: AuthServices.userId!,
          sectors: currentState.storeSectors,
          subSectors: currentState.storeSubSectors,
          mobileMoney: mobileMoney,
          deliveryInfos: {
            DeliveryInfos.location: currentState.location ?? '',
            DeliveryInfos.locationDescription:
                currentState.locationDescription ?? '',
            DeliveryInfos.sellerOwnDeliver: currentState.sellerOwnDeliver,
          },
          fiscality: {
            'fiscalType': currentState.storeFiscalType,
          },
          storeInfos: {
            StoreInfos.name: currentState.storeName!,
            StoreInfos.phone: currentState.storePhoneNumber,
            StoreInfos.email: currentState.storeEmail,
          },
        );

        // Émettre l'état de succès avec l'ID de la boutique créée
        emit(StoreCreationSuccess(storeId: storeId));
      } catch (e) {
        // Déterminer le message d'erreur approprié
        String errorMessage = 'Erreur lors de la création de la boutique';

        if (e.toString().contains('network')) {
          errorMessage =
              'Erreur de connexion. Vérifiez votre connexion internet et réessayez.';
        } else if (e.toString().contains('permission')) {
          errorMessage =
              'Erreur de permission. Vous n\'avez pas les droits nécessaires.';
        } else if (e.toString().contains('timeout')) {
          errorMessage = 'Délai d\'attente dépassé. Veuillez réessayer.';
        } else {
          errorMessage =
              'Erreur lors de la création de la boutique: ${e.toString()}';
        }

        // Préserver l'état actuel lors de l'émission de l'erreur
        _emitErrorWithState(emit, errorMessage);
      }
    });

    on<StoreCreationErrorEvent>((event, emit) {
      emit(StoreCreationError(erroMessage: event.erroMessage));
    });

    on<StoreCreationSuccessEvent>((event, emit) {
      emit(StoreCreationSuccess());
    });
  }
}

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
