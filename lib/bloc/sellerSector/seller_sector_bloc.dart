/*
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/sellerSector.dart';

part 'seller_sector_event.dart';
part 'seller_sector_state.dart';

class SellerSectorBloc extends Bloc<SellerSectorEvent, SellerSectorState> {
  SellerSectorBloc() : super(SellerSectorInitial()) {
    List<SellerSector> sellerSectors = [];

    // Ajout d'un nouveau secteur
    on<AddSellerSector>((event, emit) {
      try {
        //ajout du seteur à la liste de secteurs
        sellerSectors.add(event.sellerSector);
        //Émission de l'état de succès d'ajout
        emit(SellerSectorAddedSuccessfully(
          sellerSectors: sellerSectors,
          message: "Secteur ${event.sellerSector.name} ajouté avec succès",
        ));
      } catch (e) {
        //TODO : Gérer l'erreur
      }
    });

    // Suppression d'un secteur
    on<RemoveSellerSector>((event, emit) {
      try {
        //ajout du seteur à la liste de secteurs
        sellerSectors
            .removeWhere((sellerSector) => sellerSector.id == event.id);
        //Émission de l'état de succès d'ajout
        emit(SellerSectorRemovedSuccessfully(
          sellerSectors: sellerSectors,
          message: "Secteur supprimé avec succès",
        ));
      } catch (e) {
        //TODO : Gérer l'erreur
      }
    });
  }
}
*/
