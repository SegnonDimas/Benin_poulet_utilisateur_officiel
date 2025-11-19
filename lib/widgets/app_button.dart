import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double? bordeurRadius;
  final double? height;
  final double? width;
  final VoidCallback? onTap;
  final List<BoxShadow>? boxShadow;
  final bool? useAligment;

  const AppButton({
    super.key,
    required this.child,
    this.color,
    this.bordeurRadius = 15,
    this.height,
    this.onTap,
    this.width,
    this.borderColor = Colors.transparent,
    this.boxShadow,
    this.useAligment = true,
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
        alignment: widget.useAligment! ? Alignment.center : null,
        height: widget.height /*?? context.height * 0.075*/,
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
            boxShadow: widget.boxShadow),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
