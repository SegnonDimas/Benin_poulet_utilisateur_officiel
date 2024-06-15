import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:flutter/material.dart';

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
  //final IconData suffixIcon;
  bool? isPassword;
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
                style: TextStyle(color: Colors.grey.shade800),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  //isDense: true,
                  label: Text(
                    widget.label,
                    style:
                        TextStyle(color: Colors.grey, fontSize: mediumText()),
                  ),
                  floatingLabelStyle: TextStyle(fontSize: mediumText()),
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
                style: TextStyle(
                    color: Colors.grey.shade800,
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
