import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/fiscal_info.dart';
import '../storeCreation/store_creation_bloc.dart';

part 'fiscal_event.dart';
part 'fiscal_state.dart';

class FiscalBloc extends Bloc<FiscalEvent, FiscalState> {
  final TextEditingController paymentPhoneNumberController =
      TextEditingController();
  final TextEditingController payementOwnerNameController =
      TextEditingController();

  FiscalBloc() : super(FiscalState(info: FiscalInfo())) {
    on<SubmitFiscalInfo>((event, emit) {
      final currentState = state is StoreCreationGlobalState
          ? state as StoreCreationGlobalState
          : StoreCreationGlobalState();
      emit(FiscalState(info: event.info));
      emit(currentState.copyWith(
        storeFiscalType: event.info.storeFiscalType,
        paymentMethod: event.info.paymentMethod,
        paymentPhoneNumber: event.info.paymentPhoneNumberController,
        payementOwnerName: event.info.payementOwnerNameController,
      ) as FiscalState);
    });
  }

  FiscalInfo get currentInfo {
    return state.info;
    //return FiscalInfo(); // état initial vide
  }
}
