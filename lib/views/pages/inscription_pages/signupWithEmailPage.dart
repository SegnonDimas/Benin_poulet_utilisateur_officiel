import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/constants/routes.dart';
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
import '../../../tests/blurryContainer.dart';
import '../../../utils/snack_bar.dart';
import '../../../utils/wave_painter.dart';
import '../../models_ui/model_optionsDeConnexion.dart';

class SignupWithEmailPage extends StatefulWidget {
  const SignupWithEmailPage({super.key});

  @override
  State<SignupWithEmailPage> createState() => _SignupWithEmailPageState();
}

class _SignupWithEmailPageState extends State<SignupWithEmailPage> {
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _passWordConfirmController =
      TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();

  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');
  bool isLoggedIn = false;
  bool seSouvenir = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* SizedBox(
              height: appHeightSize(context) * 0.02,
            ),

            /// Image d'arrière-plan et bouton de retour
            SizedBox(
              height: appHeightSize(context) * 0.17,
              width: appWidthSize(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // image d'arrière-plan
                  Positioned(
                    top: appHeightSize(context) * 0.04,
                    child: Hero(
                      tag: 'emailTag',
                      transitionOnUserGestures: true,
                      child: Image.asset(
                        'assets/logos/email2.png',
                        fit: BoxFit.fitHeight,
                        height: appHeightSize(context) * 0.12,
                        //width: appWidthSize(context) * 0.5,
                      ),
                    ),
                  ),

                  // bouton de retour
                  Positioned(
                    top: appHeightSize(context) * 0.035,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: appHeightSize(context) * 0.06,
                          width: appHeightSize(context) * 0.06,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                              appHeightSize(context),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            size: mediumText(),
                            weight: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),*/

            /// Image d'arrière-plan et bouton de retour
            SizedBox(
              height: appHeightSize(context) * 0.2,
              width: appWidthSize(context),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 20,
                    left: 5,
                    child: Hero(
                      tag: '2',
                      child: GradientBall(
                          size: Size.square(appHeightSize(context) * 0.09),
                          colors: const [
                            //blueColor,
                            Colors.deepPurple,
                            Colors.purpleAccent
                          ]),
                    ),
                  ),
                  Positioned(
                    bottom: 0, //appHeightSize(context) * 0.8,
                    right: 10,
                    child: Hero(
                      tag: '1',
                      child: GradientBall(
                          size: Size.square(appHeightSize(context) * 0.06),
                          colors: const [Colors.orange, Colors.yellow]),
                    ),
                  ),
                  // image d'arrière-plan
                  Positioned(
                    top: appHeightSize(context) * 0.08,
                    child: Hero(
                      tag: 'emailTag',
                      transitionOnUserGestures: true,
                      child: Image.asset(
                        'assets/logos/email2.png',
                        fit: BoxFit.fitHeight,
                        height: appHeightSize(context) * 0.12,
                        //width: appWidthSize(context) * 0.4,
                      ),
                    ),
                  ),

                  // bouton de retour
                  Positioned(
                    top: appHeightSize(context) * 0.05,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: appHeightSize(context) * 0.055,
                          width: appHeightSize(context) * 0.055,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surface
                                .withOpacity(0.3),
                            borderRadius: BorderRadius.circular(
                              appHeightSize(context),
                            ),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            size: mediumText(),
                            weight: 50,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Contenu avec forme sinusoïdale
            CustomPaint(
              painter: WavePainter(
                color: Theme.of(context).colorScheme.surface,
              ),
              child: Container(
                height: appHeightSize(context) * 0.8,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: appHeightSize(context) * 0.08),

                      /// texte : Bienvenue
                      Text(
                        'Bienvenue !',
                        style: TextStyle(
                            fontSize: largeText() * 1.5,
                            fontWeight: FontWeight.bold,
                            color: primaryColor),
                      ),
                      const SizedBox(height: 0),

                      /// Formulaire de connexion

                      SizedBox(
                        height: appHeightSize(context) * 0.35,
                        child: ListView(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        height: appHeightSize(context) * 0.2,
                                        width: 5,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withOpacity(0.4),
                                        ),
                                      ),
                                      Container(
                                        height: appHeightSize(context) * 0.075,
                                        width: 5,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withOpacity(0.1),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      // Adresse Email
                                      AppTextField(
                                        label: 'Adresse Email',
                                        height: appHeightSize(context) * 0.08,
                                        width: appWidthSize(context) * 0.9,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        controller: _passWordController,
                                        prefixIcon: Icons.email,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        fontSize: mediumText() * 0.9,
                                        fontColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                      const SizedBox(height: 10),

                                      // mot de passe
                                      AppTextField(
                                        label: 'Mot de passe',
                                        height: appHeightSize(context) * 0.08,
                                        width: appWidthSize(context) * 0.9,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        isPassword: true,
                                        controller: _emailcontroller,
                                        fontSize: mediumText() * 0.9,
                                        fontColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                      const SizedBox(height: 10),

                                      // confirmation de mot de passe
                                      AppTextField(
                                        label: 'Confirmer mot de passe',
                                        height: appHeightSize(context) * 0.08,
                                        width: appWidthSize(context) * 0.9,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        isPassword: true,
                                        controller: _passWordConfirmController,
                                        fontSize: mediumText() * 0.9,
                                        fontColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                      const SizedBox(height: 5),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: appHeightSize(context) * 0.015),

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
                                    radius:
                                        20.0, // Taille du spinnerupcolor: Colors.white,
                                  )
                                : Text(
                                    'Inscription',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: largeText()),
                                  )),
                      ),
                      const SizedBox(height: 20),

                      /// Fin du formulaire de connexion
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet:

          /// Autres options de connexion

          // texte : 'ou continuer avec'
          SizedBox(
        height: appHeightSize(context) * 0.17,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 1,
                  ),
                  AppText(
                    text: "ou continuer avec",
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.4),
                    fontSize: smallText() * 1.2,
                  ),
                  const SizedBox(
                    width: 1,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Divider(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.4),
                ),
              ),

              // méthode de connexion Google, Apple et Email
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Google
                  Hero(
                    tag: 'googleTag',
                    child: ModelOptionDeConnexion(
                      onTap: () {
                        setState(() {
                          isLoggedIn = !isLoggedIn;
                        });
                      },
                      child: Image.asset(
                        'assets/logos/google.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),

                  SizedBox(
                    width: appWidthSize(context) * 0.15,
                  ),

                  //Apple
                  Hero(
                    tag: 'appleTag',
                    child: ModelOptionDeConnexion(
                      onTap: () {
                        setState(() {
                          isLoggedIn = !isLoggedIn;
                        });
                      },
                      child: Image.asset(
                        'assets/logos/apple.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),

              // texte : 'Vous n'avez pas encore de compte? S'inscrire'
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    text: 'Avez-vous déjà de compte ?',
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.4),
                    fontSize: smallText() * 1.2,
                  ),

                  // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.LOGINPAGE);
                      },
                      child: AppText(
                        text: 'Se connecter',
                        color: primaryColor,
                        fontSize: smallText() * 1.2,
                      )),
                ],
              ),
            ],
          ),
        ),
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
