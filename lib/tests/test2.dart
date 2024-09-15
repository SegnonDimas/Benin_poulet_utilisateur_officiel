import 'dart:ui';

import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Test2 extends StatefulWidget {
  const Test2({super.key});

  @override
  State<Test2> createState() => _Test2State();
}

class _Test2State extends State<Test2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Positioned(
        top: 20,
        left: 30,
        right: 30,
        child: Container(
          height: 350,
          width: 350,
          decoration: BoxDecoration(
              color: Colors.orange, borderRadius: BorderRadius.circular(300)),
        ),
      ),
      Positioned(
        left: -50,
        top: -50,
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
              color: blueColor, borderRadius: BorderRadius.circular(300)),
        ),
      ),
      Positioned(
        right: -50,
        top: -50,
        child: Container(
          height: 250,
          width: 250,
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(300)),
        ),
      ),
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
          //blur(sigmaX: 100, sigmaY: 100),
          child: Center(
            child: GestureDetector(
              child: Container(
                  child: Skeletonizer(
                containersColor: Colors.red,
                child: Container(
                  //color: Colors.red,
                  height: appHeightSize(context) * 0.2,
                ),
              )),
            ),
          )),
    ]));
  }
}
