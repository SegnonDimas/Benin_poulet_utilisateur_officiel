import 'package:flutter/material.dart';

class AppText extends StatefulWidget {
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final FontStyle? fontStyle;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final Color? color;
  final int? maxLine;
  final String text;
  final TextDecoration? decoration;
  final TextDecorationStyle? decorationStyle;
  BuildContext? context;

  AppText({
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.fontFamily,
    this.fontStyle = FontStyle.normal,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.color,
    this.maxLine,
    this.context,
    this.decoration,
    required this.text,
    this.decorationStyle,
  });

  @override
  State<AppText> createState() => _AppTextState();
}

class _AppTextState extends State<AppText> {
  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).colorScheme.inversePrimary;
    color = widget.color;
    return Text(
      textAlign: widget.textAlign,
      widget.text,
      maxLines: widget.maxLine,
      style: TextStyle(
          fontSize: widget.fontSize,
          fontWeight: widget.fontWeight,
          fontFamily: widget.fontFamily,
          color: widget.color,
          overflow: widget.overflow,
          fontStyle: widget.fontStyle,
          decoration: widget.decoration,
          decorationStyle: widget.decorationStyle

          //color: (widget.context != null && widget.color == null) || (widget.color != null && widget.context == null)
          //? widget.color,
          //: Colors.black,
          ),
    );
  }
}
