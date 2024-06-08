import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final IconData? prefixIcon;
  final double height;
  final double width;
  final Color? color;
  final TextEditingController controller;
  //final IconData suffixIcon;
  bool? isPassword;
  AppTextField({super.key, required this.label, this.prefixIcon = Icons.home, /*required this.suffixIcon,*/ this.isPassword = false, required this.height, required this.width, this.color = Colors.white, required this.controller});

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool click = false;
  @override
  Widget build(BuildContext context) {
    return
        Container(
          alignment: Alignment.center,
          height: widget.height,//MediaQuery.of(context).size.height*0.095,
          width: widget.width,//MediaQuery.of(context).size.width*0.95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.color!
            //border: Border.all(color: Colors.red)
          ),
          child:  widget.isPassword!? Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.controller,
              obscureText: !click,
              style: TextStyle(color: Colors.grey.shade800),
              decoration: InputDecoration(
                border: InputBorder.none,
                //isDense: true,
                label: Text(widget.label, style: const TextStyle(color: Colors.grey),),
                //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
               /* border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),
                ),*/
                prefixIcon: const Icon(Icons.lock, color: Colors.grey/*Theme.of(context).colorScheme.inversePrimary*/,),
                suffixIcon: GestureDetector(
                    onTap: (){
                      setState(() {
                        click = !click;
                      });
                    },
                    child:
                    !click?
                    const Icon(Icons.visibility_off, color: Colors.grey/*Theme.of(context).colorScheme.inversePrimary*/,)
                        : const Icon(Icons.visibility, color: Colors.grey/*Theme.of(context).colorScheme.inversePrimary*/,)
                ),
              ),
            ),
          )
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                              obscureText: false,
                              style: TextStyle(color: Colors.grey.shade800),
                              decoration: InputDecoration(
                              border: InputBorder.none,
                //isDense: true,
                label: Text(widget.label, style: const TextStyle(color: Colors.grey),),
                //labelStyle: TextStyle(color: Colors.white),
                //icon: Icon(Icons.account_circle_rounded, color: Theme.of(context).colorScheme.inversePrimary,),
                /*border: const OutlineInputBorder(
                  *//*borderRadius: BorderRadius.all(Radius.circular(15.0),
                  ),*//*
                ),*/
                prefixIcon: Icon(widget.prefixIcon, color: Colors.grey /*Theme.of(context).colorScheme.primary*/,),
                              ),
                            ),
              ),
        );
  }
}
