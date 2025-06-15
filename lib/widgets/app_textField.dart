import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../views/sizes/text_sizes.dart';

class AppTextField extends StatefulWidget {
  final String? label;
  final IconData? prefixIcon;
  final double? height;
  final double? width;
  final Color? color;
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Color? prefixIconColor;
  final int maxLines;
  final int minLines;
  final bool? expands;
  final double? fontSize;
  final Color? fontColor;
  final InputBorder? border;
  final Color? fileBorderColor;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Function(String?)? onSaved;
  final Function(String?)? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Function(PointerDownEvent?)? onTapOutside;
  final BorderRadius? borderRadius;
  bool? isPassword;
  bool? readOnly;
  bool? showFloatingLabel;
  Function()? onTap;
  AlignmentGeometry? alignment;
  EdgeInsetsGeometry? contentPadding;
  Color? hintTextColor;
  bool? isPrefixIconWidget;
  Widget? preficIconWidget;
  TextInputAction? textInputAction;
  TextCapitalization? textCapitalization; // Default capitalization
  //bool? isLabelDefined;

  AppTextField({
    super.key,
    this.label,
    this.prefixIcon,
    this.suffix,
    this.isPassword = false,
    this.height,
    this.width,
    this.color,
    this.controller,
    this.onChanged,
    this.keyboardType,
    this.prefixIconColor,
    this.hintTextColor,
    this.maxLines = 1,
    this.expands = false,
    this.minLines = 1,
    this.fontSize = 16,
    this.fontColor,
    this.readOnly = false,
    this.onTap,
    this.border,
    this.hintText,
    this.suffixIcon,
    this.onSaved,
    this.fileBorderColor,
    this.onFieldSubmitted,
    this.onEditingComplete,
    this.onTapOutside,
    this.borderRadius,
    this.showFloatingLabel = true,
    this.alignment,
    this.contentPadding,
    this.isPrefixIconWidget = false,
    this.preficIconWidget,
    this.textInputAction,
    this.textCapitalization,

    //this.isLabelDefined = true,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool click = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: widget.alignment ?? Alignment.center,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
          borderRadius: widget.borderRadius ?? BorderRadius.circular(15),
          color: widget.color,
          border:
              Border.all(color: widget.fileBorderColor ?? Colors.transparent)),
      child: widget.isPassword!

          /// mot de passe
          ? Padding(
              padding: widget.contentPadding ?? const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.controller,
                obscureText: !click,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                expands: widget.expands!,
                onEditingComplete: widget.onEditingComplete,
                onFieldSubmitted: widget.onFieldSubmitted,
                onTapOutside: widget.onTapOutside,
                onChanged: widget.onChanged,
                onSaved: widget.onSaved,
                onTap: widget.onTap,
                cursorColor: AppColors.primaryColor,
                style: TextStyle(
                    color: widget.fontColor,
                    //Theme.of(context).colorScheme.inverseSurface,
                    fontSize: widget.fontSize!),
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  border: widget.border ?? InputBorder.none,
                  hintText: widget.hintText,

                  label: Text(
                    widget.label ?? widget.hintText ?? '',
                    style: TextStyle(
                        color: widget.hintTextColor ?? Colors.grey,
                        fontSize: context.mediumText),
                  ),

                  labelStyle: TextStyle(fontSize: context.mediumText),
                  //labelText: widget.label,
                  //hintStyle: TextStyle(fontSize: context.mediumText),
                  //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
                  /* border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),
                ),*/
                  prefixIcon: widget.isPrefixIconWidget!
                      ? widget.preficIconWidget
                      : Icon(
                          Icons.lock,
                          color: widget.prefixIconColor ??
                              Theme.of(context).colorScheme.inverseSurface,
                        ),
                  suffix: widget.suffix,
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        click = !click;
                      });
                    },
                    child: !click
                        ? const Icon(
                            Icons.visibility_off,
                            color: Colors
                                .grey /*Theme.of(context).colorScheme.inversePrimary*/,
                          )
                        : const Icon(
                            Icons.visibility,
                            color: Colors
                                .grey /*Theme.of(context).colorScheme.inversePrimary*/,
                          ),
                  ),
                  floatingLabelStyle: TextStyle(
                      fontSize:
                          widget.showFloatingLabel! ? context.mediumText : 0),
                ),
                textCapitalization:
                    widget.textCapitalization ?? TextCapitalization.none,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
              ),
            )

          /// pas mot de passe
          : Padding(
              padding: widget.contentPadding ?? const EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: false,
                controller: widget.controller,
                keyboardType: widget.keyboardType,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                onFieldSubmitted: widget.onFieldSubmitted,
                onEditingComplete: widget.onEditingComplete,
                onTapOutside: widget.onTapOutside,
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                onSaved: widget.onSaved,
                readOnly: widget.readOnly!,
                scrollPadding: EdgeInsets.zero,
                cursorColor: AppColors.primaryColor,
                style: TextStyle(
                    color: widget.fontColor,
                    fontSize: widget
                        .fontSize, //Theme.of(context).colorScheme.inverseSurface,
                    overflow: TextOverflow.ellipsis),
                decoration: InputDecoration(
                  border: widget.border ?? InputBorder.none,
                  hintText: widget.hintText,
                  //isDense: true,

                  label: widget.label != null || widget.hintText != null
                      ? Text(
                          widget.label ?? widget.hintText ?? '',
                          style: TextStyle(
                              color: widget.hintTextColor ?? Colors.grey,
                              fontSize: context.mediumText),
                        )
                      : null,
                  floatingLabelStyle: TextStyle(
                      fontSize:
                          widget.showFloatingLabel! ? context.mediumText : 0),
                  //labelStyle: TextStyle(color: Colors.white),
                  //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
                  /*border: const OutlineInputBorder(
                  */ /*borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),*/ /*
                ),*/

                  suffix: widget.suffix,
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: widget.isPrefixIconWidget!
                      ? widget.preficIconWidget
                      : Icon(
                          widget.prefixIcon,
                          color: widget.prefixIconColor,
                        ),
                ),
                textCapitalization:
                    widget.textCapitalization ?? TextCapitalization.sentences,
                textInputAction: widget.textInputAction ?? TextInputAction.done,
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
