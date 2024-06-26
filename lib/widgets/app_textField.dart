import 'package:flutter/material.dart';

import '../views/sizes/text_sizes.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final IconData? prefixIcon;
  final double height;
  final double width;
  final Color? color;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Color? prefixIconColor;
  final int maxLines;
  final int minLines;
  final bool? expands;
  final double? fontSize;
  final Color? fontColor;
  bool? isPassword;
  bool? readOnly;
  Function()? onTap;

  AppTextField({
    super.key,
    required this.label,
    this.prefixIcon = Icons.home,
    /*required this.suffixIcon,*/
    this.isPassword = false,
    required this.height,
    required this.width,
    this.color = Colors.white,
    required this.controller,
    this.onChanged,
    this.keyboardType,
    this.prefixIconColor = Colors.grey,
    this.maxLines = 1,
    this.expands = false,
    this.minLines = 1,
    this.fontSize = 16,
    this.fontColor = Colors.black,
    this.readOnly = false,
    this.onTap,
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
      height: widget.height, //MediaQuery.of(context).size.height*0.095,
      width: widget.width, //MediaQuery.of(context).size.width*0.95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), color: widget.color!
          //border: Border.all(color: Colors.red)
          ),
      child: widget.isPassword!

          /// mot de passe
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: widget.controller,
                obscureText: !click,
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                expands: widget.expands!,
                style: TextStyle(
                    color: widget.fontColor,
                    //Theme.of(context).colorScheme.inverseSurface,
                    fontSize: widget.fontSize!),
                decoration: InputDecoration(
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  border: InputBorder.none,
                  //isDense: true,
                  label: Text(
                    widget.label,
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
                    color: widget.prefixIconColor,
                  ),
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
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                readOnly: widget.readOnly!,
                style: TextStyle(
                    color: widget.fontColor,
                    fontSize: widget
                        .fontSize, //Theme.of(context).colorScheme.inverseSurface,
                    overflow: TextOverflow.ellipsis),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //isDense: true,
                  label: Text(
                    widget.label,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  floatingLabelStyle: TextStyle(fontSize: mediumText()),
                  //labelStyle: TextStyle(color: Colors.white),
                  //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
                  /*border: const OutlineInputBorder(
                  */ /*borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),*/ /*
                ),*/
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
