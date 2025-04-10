import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../storeCreation/store_creation_bloc.dart';

part 'delivery_event.dart';
part 'delivery_state.dart';

class DeliveryBloc extends Bloc<DeliveryEvent, DeliveryState> {
  final emplacementController = TextEditingController();
  final descriptionEmplacementController = TextEditingController();

  DeliveryBloc() : super(DeliveryState(infos: DeliveryInfo())) {
    on<DeliveryInfoEvent>((event, emit) {
      final currentState = state is StoreCreationGlobalState
          ? state as StoreCreationGlobalState
          : StoreCreationGlobalState();
      emit(DeliveryState(infos: event.infos));
      emit(currentState.copyWith(
        sellerOwnDeliver: event.infos.sellerOwnDeliver,
        location: event.infos.location,
        locationDescription: event.infos.locationDescription,
      ) as DeliveryState);
    });
  }

  DeliveryInfo get currentInfo {
    return state.infos;
    //return DeliveryInfo(); // état initial vide
  }
}
