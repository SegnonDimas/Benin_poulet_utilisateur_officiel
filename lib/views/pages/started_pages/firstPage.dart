
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/connexion_pages/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/transitions.dart';


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
            body: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    /// logo de l'App
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.05,
                          bottom: MediaQuery.of(context).size.height * 0.05),
                      child: AnimatedContainer(
                      alignment: Alignment.center,
                      duration: const Duration(seconds: 2),
                      width: _isLoading ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.25,
                      height: _isLoading ? MediaQuery.of(context).size.height * 0.05 : MediaQuery.of(context).size.height * 0.25,
                      onEnd: (){
                        setState(() {
                          _isLoading = !_isLoading;
                          Navigator.of(context).push(Transitions.glissement(const LoginPage()));
                          _isLoading? logo = 'assets/logos/logoNoir.png' : logo = 'assets/logos/logoBlanc.png';
                          duration = duration + 2;

                        });
                        if(duration == 6){
                          Navigator.pushReplacementNamed(context, '/login');
                          //Navigator.of(context).push(Transitions.rotation(const LoginPage()));
                        }

                      },
                      child:
                       Image.asset(logo, fit: BoxFit.cover,)
                            )),

                    /// le texte : Powered by Smart Solutions Innova
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      Text(
                      'Powered by',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),

                    // le clic devrait conduire sur le site officiel de Smart Solution Innova
                        TextButton(onPressed: null, child: Text(
                          'Smart Solutions Innova',
                          style: TextStyle(color: Color.fromARGB(
                              255, 255, 112, 48), fontSize: 10),
                        )),
                      ],
                    )
                  ],
                ))));
      },
    );
  }
}

