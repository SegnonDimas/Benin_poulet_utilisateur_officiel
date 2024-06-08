import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';


class AppShaderMask extends StatelessWidget {
  final Widget child;
  const AppShaderMask({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
        blendMode: BlendMode.srcATop, // Choisissez le mode de fusion selon vos préférences
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            colors: [primaryColor,secondaryColor,primaryColor,secondaryColor], // Couleurs de votre dégradé
            tileMode: TileMode.clamp,
          ).createShader(bounds);
        },
        child: child
    );
  }
}
