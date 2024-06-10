import 'package:flutter/material.dart';

class AppDialog{
  final Color? shadowColor;
  final Color? surfaceTintColor;
  final Color? backgroundColor;
  final double? elevation;
  final AlignmentGeometry? alignment;
  final Widget child;

  const AppDialog({
    this.shadowColor,
    this.surfaceTintColor,
    this.backgroundColor,
    this.elevation,
    this.alignment,
    required this.child,
  });
}