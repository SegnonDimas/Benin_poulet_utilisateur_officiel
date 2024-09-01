import 'package:flutter_bloc/flutter_bloc.dart';

/// Logique évènements

abstract class CounterEvent {}

class IncrementCounterEvent extends CounterEvent {}

class DecrementCounterEvent extends CounterEvent {}

class ZeroEvent extends CounterEvent {}

///Logique states

abstract class CounterState {
  final int counter;

  CounterState({required this.counter});
}

class CounterSuccessState extends CounterState {
  CounterSuccessState({required super.counter});
}

class CounterErrorState extends CounterState {
  final String errorMessage;

  CounterErrorState({required super.counter, required this.errorMessage});
}

class CounterZeroState extends CounterState {
  CounterZeroState({required super.counter});
}

/// State initial du counter
class CounterInitialState extends CounterState {
  CounterInitialState() : super(counter: 0);
}

/// Logique BLoc

class CounterBloc extends Bloc<CounterEvent, CounterState> {
  CounterBloc() : super(CounterInitialState()) {
    on((IncrementCounterEvent event, emit) {
      if (state.counter < 10) {
        emit(CounterSuccessState(counter: state.counter + 1));
      } else {
        emit(CounterErrorState(
            counter: state.counter,
            errorMessage:
                'La valeur du compteur ne doit pas dépasser ${state.counter}'));
        state.counter - 1;
      }
    });

    on((DecrementCounterEvent event, emit) {
      if (state.counter > 0) {
        emit(CounterSuccessState(counter: state.counter - 1));
      } else {
        emit(CounterErrorState(
            counter: state.counter,
            errorMessage:
                'La valeur du compteur ne doit pas être en dessous de ${state.counter}'));
        //state.counter + 1;
      }
    });

    on((ZeroEvent event, emit) {
      emit(CounterZeroState(counter: state.counter * 0));
    });
  }
}
