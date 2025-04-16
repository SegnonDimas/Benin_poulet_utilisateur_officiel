import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:flutter/material.dart';

class ModelOptionDeConnexion extends StatefulWidget {
  final Function()? onTap;
  final double? height;
  final double? width;
  final Color? backgroundColor;
  final double? bordeurRadius;
  final Widget? child;
  final String? iconImagePath;

  const ModelOptionDeConnexion({
    super.key,
    this.onTap,
    this.height,
    this.width,
    this.backgroundColor,
    this.bordeurRadius,
    this.child,
    this.iconImagePath,
  });

  @override
  State<ModelOptionDeConnexion> createState() => _ModelOptionDeConnexionState();
}

class _ModelOptionDeConnexionState extends State<ModelOptionDeConnexion> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
          height: widget.height ?? appHeightSize(context) * 0.06,
          width: widget.width ?? appHeightSize(context) * 0.07,
          decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(widget.bordeurRadius ?? 15)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: widget.child ??
                Image.asset(
                  widget.iconImagePath ?? 'assets/icons/img.png',
                  fit: BoxFit.contain,
                ),
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
