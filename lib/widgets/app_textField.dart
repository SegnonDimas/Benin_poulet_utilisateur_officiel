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
  bool? isPassword;
  bool? readOnly;
  Function()? onTap;

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
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool click = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: widget.height,
      //MediaQuery.of(context).size.height*0.095,
      width: widget.width,
      //MediaQuery.of(context).size.width*0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: widget.color,
          border:
              Border.all(color: widget.fileBorderColor ?? Colors.transparent)),
      child: widget.isPassword!

          /// mot de passe
          ? Padding(
              padding: const EdgeInsets.all(8.0),
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
                style: TextStyle(
                    color: widget.fontColor,
                    //Theme.of(context).colorScheme.inverseSurface,
                    fontSize: widget.fontSize!),
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  border: widget.border ?? InputBorder.none,
                  hintText: widget.hintText,
                  //isDense: true,
                  label: Text(
                    widget.label ?? '',
                    style:
                        TextStyle(color: Colors.grey, fontSize: mediumText()),
                  ),
                  labelStyle: TextStyle(fontSize: mediumText()),
                  //labelText: widget.label,
                  //hintStyle: TextStyle(fontSize: mediumText()),
                  //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
                  /* border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),
                ),*/
                  prefixIcon: Icon(
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
                            )),
                ),
              ),
            )

          /// pas mot de passe
          : Padding(
              padding: const EdgeInsets.all(8.0),
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
                style: TextStyle(
                    color: widget.fontColor,
                    fontSize: widget
                        .fontSize, //Theme.of(context).colorScheme.inverseSurface,
                    overflow: TextOverflow.ellipsis),
                decoration: InputDecoration(
                  border: widget.border ?? InputBorder.none,
                  hintText: widget.hintText,
                  //isDense: true,
                  label: Text(
                    widget.label ?? '',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  floatingLabelStyle: TextStyle(fontSize: mediumText()),
                  //labelStyle: TextStyle(color: Colors.white),
                  //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
                  /*border: const OutlineInputBorder(
                  */ /*borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),*/ /*
                ),*/
                  suffix: widget.suffix,
                  suffixIcon: widget.suffixIcon,
                  prefixIcon: Icon(
                    widget.prefixIcon,
                    color: widget.prefixIconColor,
                  ),
                ),
              ),
            ),
    );
  }
}
