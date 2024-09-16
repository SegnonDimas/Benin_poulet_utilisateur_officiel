import 'dart:ui';

import 'package:benin_poulet/routes.dart';
import 'package:benin_poulet/tests/blurryContainer.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:flutter/material.dart';

import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';

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
    loading();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    loading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //gestion de l'affichage selon l'orientation du téléphone avec OrientationBuilder()
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          //backgroundColor: Theme.of(context).colorScheme.surface,
          backgroundColor: primaryColor,
          body: Stack(alignment: Alignment.center, children: [
            /*Container(
            height: appHeightSize(context),
            width: appWidthSize(context),
            color: primaryColor,
          ),*/
            Positioned(
              top: 0,
              left: 10,
              child: Hero(
                tag: '2',
                child: GradientBall(
                    size: Size.square(appHeightSize(context) * 0.25),
                    colors: const [Colors.orange, Colors.yellow]),
              ),
            ),
            Positioned(
              bottom: 20,
              right: 10,
              child: Hero(
                tag: '1',
                child: GradientBall(
                    size: Size.square(appHeightSize(context) * 0.17),
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
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05,
                              bottom:
                                  MediaQuery.of(context).size.height * 0.05),
                          child: AnimatedContainer(
                              alignment: Alignment.center,
                              duration: const Duration(seconds: 2),
                              width: _isLoading
                                  ? MediaQuery.of(context).size.height * 0.05
                                  : MediaQuery.of(context).size.height * 0.25,
                              height: _isLoading
                                  ? MediaQuery.of(context).size.height * 0.05
                                  : MediaQuery.of(context).size.height * 0.25,
                              onEnd: () {
                                setState(() {
                                  _isLoading = !_isLoading;

                                  _isLoading
                                      ? logo = 'assets/logos/logoNoir.png'
                                      : logo = 'assets/logos/logoBlanc.png';
                                  duration = duration + 2;
                                });
                                if (duration == 2) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      appRoutes.LOGINPAGE, (route) => false);
                                  //Navigator.of(context).push(Transitions.rotation(const LoginPage()));
                                }
                              },
                              child: Image.asset(
                                logo,
                                fit: BoxFit.cover,
                              ))))),
            ),
            Positioned(
              bottom: 0,
              child:

                  /// le texte : Powered by Smart Solutions Innova
                  SizedBox(
                height: appHeightSize(context) * 0.08,
                width: appWidthSize(context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Powered by',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),

                    // le clic devrait conduire sur le site officiel de Smart Solution Innova
                    TextButton(
                      onPressed: null,
                      child: AppText(
                          text: 'Smart Solutions Innova',
                          color: Colors.white,
                          //color: Color.fromARGB(255, 255, 112, 48),
                          //fontSize: 10,
                          fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            )
          ]),
        );
      },
    );
  }
}
