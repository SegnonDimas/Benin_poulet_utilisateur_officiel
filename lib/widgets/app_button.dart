import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final Widget child;
  final Color? color;
  final double? radius;
  final double? height;
  final double? width;
  final VoidCallback onTap;

  const AppButton({super.key, required this.child, this.color = Colors.white, this.radius = 15, this.height = 70, required this.onTap, this.width = 140, });

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
          color: widget.color!,
          borderRadius: BorderRadius.circular(widget.radius!),
        ),
        child: widget.child,

      ),
    );
  }
}
