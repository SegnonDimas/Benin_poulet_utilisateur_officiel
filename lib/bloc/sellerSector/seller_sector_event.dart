/*
part of 'seller_sector_bloc.dart';

sealed class SellerSectorEvent extends Equatable {
  const SellerSectorEvent();
}

//Ajout d'un nouveau secteur
class AddSellerSector extends SellerSectorEvent {
  final SellerSector sellerSector;

  const AddSellerSector({required this.sellerSector});

  @override
  List<Object?> get props => [sellerSector];
}

//Suppression d'un secteur
class RemoveSellerSector extends SellerSectorEvent {
  final String id;

  const RemoveSellerSector({
    required this.id,
  });

  @override
  List<Object?> get props => [id];
}

//Recharge de la liste des secteurs
class FetchSellerSector extends SellerSectorEvent {
  const FetchSellerSector();

  @override
  List<Object?> get props => [];
}
*/
