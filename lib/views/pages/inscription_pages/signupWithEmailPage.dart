import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../services/authentification_services.dart';
import '../../../utils/snack_bar.dart';
import '../../../utils/wave_painter.dart';

class SignupWithEmailPage extends StatefulWidget {
  const SignupWithEmailPage({super.key});

  @override
  State<SignupWithEmailPage> createState() => _SignupWithEmailPageState();
}

class _SignupWithEmailPageState extends State<SignupWithEmailPage> {
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passWordConfirmController =
      TextEditingController();
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');
  bool isLoggedIn = false;
  bool seSouvenir = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          ///bouton Retour
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: appHeightSize(context) * 0.05,
                    width: appHeightSize(context) * 0.05,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(
                        appHeightSize(context),
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      size: mediumText(),
                      weight: 50,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Image d'arrière-plan
          Image.asset(
            'assets/logos/email.png',
            fit: BoxFit.fitHeight,
            height: appHeightSize(context) * 0.15,
            //width: appWidthSize(context) * 0.5,
          ),

          // Contenu avec forme sinusoïdale
          CustomPaint(
            painter: WavePainter(),
            child: Container(
              height: appHeightSize(context) * 0.8,
              padding: const EdgeInsets.all(20),
              child: Column(
                /*mainAxisSize: MainAxisSize.min,*/
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: appHeightSize(context) * 0.1),

                  /// Formulaire de connexion

                  // Adresse Email
                  AppTextField(
                    label: 'Adresse Email',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    controller: _emailcontroller,
                    prefixIcon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),

                  // mot de passe
                  AppTextField(
                    label: 'Mot de passe',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    isPassword: true,
                    controller: _passWordController,
                  ),
                  const SizedBox(height: 20),

                  // confirmation de mot de passe
                  AppTextField(
                    label: 'Confirmer mot de passe',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    isPassword: true,
                    controller: _passWordConfirmController,
                  ),
                  const SizedBox(height: 5),

                  // Se souvenir / Mot de passe oublié
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // se souvenir
                      Row(
                        children: [
                          Checkbox(
                            value: seSouvenir,
                            onChanged: (value) {
                              setState(() {
                                seSouvenir = value!;
                              });
                            },
                            activeColor: primaryColor,
                            checkColor: Colors.white,
                            semanticLabel:
                                'Se rappeler de cet appareil et vous éviter d\'entrer vos identifiants de connexion la prochaine fois',
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                seSouvenir = !seSouvenir;
                              });
                            },
                            child: AppText(
                              text: 'Se souvenir',
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),

                      // mot de passe oublié
                      TextButton(
                        onPressed: () {
                          // Ajouter une action pour mot de passe oublié
                        },
                        child: AppText(
                          text: 'Mot de passe oublié ?',
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: appHeightSize(context) * 0.03),

                  // bouton de connexion
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoggedIn = !isLoggedIn;
                        emailSignup();
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: appHeightSize(context) * 0.07,
                        width: appWidthSize(context) * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor),
                        child: isLoggedIn
                            ? const CupertinoActivityIndicator(
                                radius: 20.0, // Taille du spinner
                                color: Colors.white,
                              )
                            : Text(
                                'Connexion',
                                style: TextStyle(
                                    color: Colors.white, fontSize: largeText()),
                              )),
                  ),
                  const SizedBox(height: 20),

                  /// Fin du formulaire de connexion

                  /// Autres options de connexion

                  // texte : 'ou continuer avec'
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 1,
                      ),
                      AppText(
                        text: "ou continuer avec",
                        color: Colors.grey.shade500,
                        fontSize: smallText() * 1.2,
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey.shade400,
                  ),

                  // méthode de connexion Google, Apple et Email
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Google
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoggedIn = !isLoggedIn;
                          });
                        },
                        child: Container(
                            height: appHeightSize(context) * 0.06,
                            width: appHeightSize(context) * 0.07,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/logos/google.png',
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                      SizedBox(
                        width: appWidthSize(context) * 0.15,
                      ),

                      //Apple
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoggedIn = !isLoggedIn;
                          });
                        },
                        child: Container(
                            height: appHeightSize(context) * 0.06,
                            width: appHeightSize(context) * 0.07,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/logos/apple.png',
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                    ],
                  ),

                  // texte : 'Vous n'avez pas encore de compte? S'inscrire'
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Avez-vous déjà de compte ?',
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: smallText() * 1.2,
                      ),

                      // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/loginPage');
                          },
                          child: AppText(
                            text: 'Se connecter',
                            color: primaryColor,
                            fontSize: smallText() * 1.2,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// emailSignup()
  Future<void> emailSignup() async {
    print('''
    :::: numéro => ${_emailcontroller.text}
    :::: mot de passe => ${_passWordController.text}
     ''');

    if (_emailcontroller.text.isEmpty || _emailcontroller.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre adresse email');
    } else if (_passWordController.text.isEmpty ||
        _passWordController.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre mot de passe');
    } else {
      // fonction pour l'inscription
      AthentificationServices.emailSignup();
      // snack bar
      _showAwesomeSnackBar(
          context,
          'Connexion Réussie',
          'Utilisateur connecté avec succès',
          ContentType.success,
          Colors.green);
    }
  }
}

/// snackbars
void _showSnackBar(BuildContext context, String message) {
  AppSnackBar.showSnackBar(context, message);
}

void _showAwesomeSnackBar(BuildContext context, String title, String message,
    ContentType contentType, Color? color) {
  AppSnackBar.showAwesomeSnackBar(context, title, message, contentType, color);
}
