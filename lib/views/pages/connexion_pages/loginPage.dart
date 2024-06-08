import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
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
      backgroundColor: primaryColor,
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
            top: appHeightSize(context)*0.31, // superposition avec l'image
            left: 0,
            right: 0,

            child: CustomPaint(
              painter: WavePainter(),
              child: Container(

                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: appHeightSize(context)*0.1),
                    // Ajustez cette valeur pour laisser de l'espace pour la sinusoïde
                    Text(
                      'Bienvenue !',
                      style: TextStyle(
                        fontSize: largeText()*1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AppTextField(label: 'Nom d\'utilisateur', height: appHeightSize(context)*0.07 , width: appWidthSize(context)*0.9, prefixIcon: Icons.account_circle,color: Colors.grey.shade100, controller: _nameController,),
                    const SizedBox(height: 20),
                    AppTextField(label: 'Mot de passe', height: appHeightSize(context)*0.07 , width: appWidthSize(context)*0.9, color: Colors.grey.shade100,isPassword: true, controller: _passWordController,),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: false,
                              onChanged: (value) {},
                            ),
                            const Text('Se souvenir'),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            // Ajouter une action pour mot de passe oublié
                          },
                          child: const Text('Mot de passe oublié ?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 1,),
                        TextButton(
                          onPressed: () {
                            // Ajouter une action pour le bouton d'inscription
                          },
                          child:
                              const Text("Vous n'avez pas de compte? S'inscrire"),
                        ),
                        SizedBox(width: 1,),
                      ],
                    ),
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
