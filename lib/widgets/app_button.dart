import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? bordeurRadius;
  final double? height;
  final double? width;
  final VoidCallback? onTap;

  const AppButton({
    super.key,
    required this.child,
    this.color,
    this.bordeurRadius = 15,
    this.height = 70,
    this.onTap,
    this.width = 140,
    this.borderColor = Colors.transparent,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        alignment: Alignment.center,
        height: widget.height,
        width: widget.width,
        decoration: BoxDecoration(
          color: widget.color ?? Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(widget.bordeurRadius!),
          border: Border(
            top: BorderSide(color: widget.borderColor!),
            bottom: BorderSide(color: widget.borderColor!),
            left: BorderSide(color: widget.borderColor!),
            right: BorderSide(color: widget.borderColor!),
          ),
        ),
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
