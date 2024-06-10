import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/wave_painter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  bool isLoggedIn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: [
          // Image d'arrière-plan
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/login2.png',
              fit: BoxFit.cover,
            ),
          ),
          // Contenu avec forme sinusoïdale
          Positioned(
            top: appHeightSize(context)*0.3, // superposition avec l'image
            left: 0,
            right: 0,

            child: CustomPaint(
              painter: WavePainter(),
              child: Container(
                height: appHeightSize(context)*0.7,
                padding: const EdgeInsets.all(20),
                child: ListView(
                  /*mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,*/
                  children: [
                    SizedBox(height: appHeightSize(context)*0.04),
                    Text(
                      'Bienvenue !',
                      style: TextStyle(
                        fontSize: largeText()*1.5,
                        fontWeight: FontWeight.bold,
                        color: primaryColor
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(label: 'Nom d\'utilisateur', height: appHeightSize(context)*0.07 , width: appWidthSize(context)*0.9, prefixIcon: Icons.account_circle,color: Colors.grey.shade300, controller: _nameController,),
                    const SizedBox(height: 20),
                    AppTextField(label: 'Mot de passe', height: appHeightSize(context)*0.07 , width: appWidthSize(context)*0.9, color: Colors.grey.shade300,isPassword: true, controller: _passWordController,),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {
                              },
                            ),
                            AppText(text: 'Se souvenir', color: Theme.of(context).colorScheme.primary, ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Ajouter une action pour mot de passe oublié
                          },
                          child: AppText(text: 'Mot de passe oublié ?', color: primaryColor,),
                        ),
                      ],
                    ),
                    SizedBox(height: appHeightSize(context)*0.03),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          isLoggedIn = !isLoggedIn;
                        });
                      },
                      child: Container(
                      alignment: Alignment.center,
                      height: appHeightSize(context)*0.07,
                      width: appWidthSize(context)*0.9,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: primaryColor
                      ),
                      child: isLoggedIn
                          ? const CupertinoActivityIndicator(
                        radius: 20.0, // Taille du spinner
                        color: Colors.white,
                      )
                      :  Text('Connexion', style: TextStyle(color: Colors.white, fontSize: largeText()),)),
                    ),
                    const SizedBox(height: 10),
                    Divider(color: Colors.grey.shade400,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap : (){
                            setState(() {
                              isLoggedIn = !isLoggedIn;
                            });
                          },
                          child: Container(
                              height: appHeightSize(context)*0.06,
                              width: appHeightSize(context)*0.07,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/logos/google.png', fit: BoxFit.contain,),
                              )),
                        ),
                        SizedBox(width: appWidthSize(context)*0.15,),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              isLoggedIn = !isLoggedIn;
                            });
                          },
                          child: Container(
                              height: appHeightSize(context)*0.06,
                              width: appHeightSize(context)*0.07,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset('assets/logos/apple.png', fit: BoxFit.contain,),
                              )),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                           text: 'Vous n\'avez pas de compte ?' ,
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                        TextButton(
                            onPressed: (){
                              showDialog(context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: AppText(text: 'Que comptez-vous faire sur l\'application ?', fontSize: mediumText(), maxLine: 2, textAlign: TextAlign.center,),
                                      content: SizedBox(
                                        height: appHeightSize(context)*0.17,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height : appHeightSize(context)*0.06,
                                                decoration : BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius: BorderRadius.circular(15)
                                                  ),
                                                child: Row(
                                                  mainAxisAlignment : MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.monetization_on_outlined, color: Colors.white,),
                                                    SizedBox(width: appWidthSize(context)*0.05,),
                                                    AppText(text: 'Vendre', fontSize: mediumText(), color: Colors.white,),
                                                    SizedBox(width: appWidthSize(context)*0.05,),
                                                    Icon(Icons.arrow_forward_ios,size: largeText(), color: Colors.white,),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height : appHeightSize(context)*0.06,
                                                decoration : BoxDecoration(
                                                    color: primaryColor,
                                                    borderRadius: BorderRadius.circular(15)
                                                ),
                                                child: Row(
                                                  mainAxisAlignment : MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(Icons.shopping_cart_outlined, color: Colors.white,),
                                                    SizedBox(width: appWidthSize(context)*0.05,),
                                                    AppText(text: 'Acheter', fontSize: mediumText(), color: Colors.white,),
                                                    SizedBox(width: appWidthSize(context)*0.05,),
                                                    Icon(Icons.arrow_forward_ios, size: largeText(), color: Colors.white,),

                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      icon: CircleAvatar(
                                        radius: appHeightSize(context)*0.05,
                                          child: Icon(Icons.question_mark, size: largeText()*2, color: Colors.red,)),
                                      iconColor: Colors.green,
                                      elevation: 25,
                                      shadowColor: Theme.of(context).colorScheme.inversePrimary,
                                      actions: <Widget>[
                                        TextButton(
                                          child: AppText(text: 'Annuler', color: Theme.of(context).colorScheme.inversePrimary,),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },);
                            }, child: AppText(
                          text: 'S\'inscrire',
                         color: primaryColor
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
