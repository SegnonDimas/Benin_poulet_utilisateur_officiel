import 'package:flutter/material.dart';

class AppColorState {
  late final Color color;

  AppColorState({required this.color});
}

class AppInitialColor extends AppColorState {
  AppInitialColor() : super(color: Colors.blue);
}
