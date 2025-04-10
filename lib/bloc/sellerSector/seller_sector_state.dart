/*
part of 'seller_sector_bloc.dart';

sealed class SellerSectorState extends Equatable {
  const SellerSectorState();
}

//État initial
final class SellerSectorInitial extends SellerSectorState {
  @override
  List<Object> get props => [];
}

//État de succès d'ajout
class SellerSectorAddedSuccessfully extends SellerSectorState {
  final String? message;
  final List<SellerSector> sellerSectors;
  const SellerSectorAddedSuccessfully({
    this.message = 'Secteur ajouté avec succès',
    this.sellerSectors = const [],
  });

  @override
  List<Object> get props => [message!, sellerSectors];
}

//État de succès de suppression
class SellerSectorRemovedSuccessfully extends SellerSectorState {
  final String? message;
  final List<SellerSector> sellerSectors;
  const SellerSectorRemovedSuccessfully({
    this.message = 'Secteur ajouté avec succès',
    this.sellerSectors = const [],
  });

  @override
  List<Object> get props => [message!, sellerSectors];
}
*/
