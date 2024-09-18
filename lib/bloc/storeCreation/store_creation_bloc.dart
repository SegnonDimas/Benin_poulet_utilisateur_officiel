import 'package:flutter_bloc/flutter_bloc.dart';

part 'store_creation_event.dart';
part 'store_creation_state.dart';

class StoreCreationBloc extends Bloc<StoreCreationEvent, StoreCreationState> {
  StoreCreationBloc() : super(StoreCreationInitial()) {
    on<StoreCreationEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
