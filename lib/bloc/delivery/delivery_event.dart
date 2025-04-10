part of 'delivery_bloc.dart';

class DeliveryEvent {}

class DeliveryInfoEvent extends DeliveryEvent {
  final DeliveryInfo infos;
  DeliveryInfoEvent(this.infos);
}

// Modele de donnee
class DeliveryInfo {
  final bool? sellerOwnDeliver;
  final String? location;
  final String? locationDescription;

  DeliveryInfo({
    this.sellerOwnDeliver,
    this.location,
    this.locationDescription,
  });

  DeliveryInfo copyWith({
    final bool? sellerOwnDeliver,
    final String? location,
    final String? locationDescription,
  }) {
    return DeliveryInfo(
      sellerOwnDeliver: sellerOwnDeliver,
      location: location,
      locationDescription: locationDescription,
    );
  }
}
