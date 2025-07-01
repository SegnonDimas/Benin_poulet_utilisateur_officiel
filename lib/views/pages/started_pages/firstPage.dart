import 'dart:ui';

import 'package:benin_poulet/constants/imagesPaths.dart';
import 'package:benin_poulet/tests/blurryContainer.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../../constants/routes.dart';
import '../../../constants/app_attributs.dart';
import '../../../widgets/app_text.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  bool _isLoading = true;
  int duration = 0;
  String logo = 'assets/logos/logoBlanc.png';

  Future<void> loading() async {
    // Utilisation de Future.delayed pour créer un délai pour l'animation
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = !_isLoading;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loading();
  }

  @override
  Widget build(BuildContext context) {
    //gestion de l'affichage selon l'orientation du téléphone avec OrientationBuilder()
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          //backgroundColor: Theme.of(context).colorScheme.surface,
          //backgroundColor: primaryColor,
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Stack(alignment: Alignment.center, children: [
            /*Container(
            height: context.height,
            width: appWidthSize(context),
            color: <primaryColor>,
          ),*/
            Positioned(
              top: context.screenHeight / 3,
              bottom: context.screenHeight / 3,
              left: context.screenWidth * 0.2,
              right: context.screenWidth * 0.2,
              child: Hero(
                tag: '2',
                child: GradientBall(
                    size: Size.square(context.height * 0.25),
                    colors: const [Colors.deepOrange, Colors.orange]),
              ),
            ).animate(delay: 1000.ms).fadeIn(duration: 2000.ms),
            Positioned(
              bottom: 20,
              right: 10,
              child: Hero(
                tag: '1',
                child: GradientBall(
                    size: Size.square(context.height * 0.17),
                    colors: const [
                      //blueColor,
                      Colors.deepPurple,
                      Colors.purpleAccent
                    ]),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              //blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                  alignment: Alignment.center,
                  //height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.05),
                          child: Image.asset(
                            height: context.screenHeight * 0.1,
                            width: context.screenHeight * 0.15,
                            ImagesPaths.LOGOBLANC,
                            fit: BoxFit.contain,
                          )
                              .animate(
                                  delay: 5000.ms,
                                  onComplete: (animatedCopntroller) {
                                    Navigator.pushReplacementNamed(
                                        context, AppRoutes.LOGINPAGE);
                                  })
                              .fade()))),
            ),
            Positioned(
              bottom: 10,
              right: 5,
              left: 5,
              child: SafeArea(
                  child: Container(
                width: context.screenWidth,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Colors.transparent,
                  Colors.grey.withOpacity(0.3),
                  Colors.transparent,
                ])),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Image.asset(ImagesPaths.POWEREDBYSSI,
                    fit: BoxFit.fitHeight),
              )
                  /*.animate()
                    .slide(
                        begin: const Offset(0, -0.03),
                        end: const Offset(0, -0.25),
                        //curve: Curves.linear,
                        delay: 500.ms,
                        duration: 2000.ms)
                    .fadeIn(duration: 500.ms),*/
                  ),
            ),

            //version de l'app
            Positioned(
                bottom: 13,
                child: SafeArea(
                  child: AppText(
                      text: AppAttributes.appVersion,
                      //color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                ))
          ]),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
