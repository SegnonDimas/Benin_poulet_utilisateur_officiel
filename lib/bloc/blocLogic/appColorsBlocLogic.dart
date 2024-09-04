import 'package:benin_poulet/bloc/events/appColorsEvents.dart';
import 'package:benin_poulet/bloc/states/appColorsStates.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class AppColorsBloc extends Bloc<AppColorsEvent, AppColorState> {
  AppColorsBloc() : super(AppInitialColor()) {
    on((AppRedColorEvent event, emit) {
      emit(AppColorState(color: Colors.red));
    });
    on((AppBlackColorEvent event, emit) {
      emit(AppColorState(color: Colors.black));
    });
    on((AppBlueColorEvent event, emit) {
      emit(AppColorState(color: Colors.blue));
    });
    on((AppGreenColorEvent event, emit) {
      emit(AppColorState(color: Colors.green));
    });
  }
}
