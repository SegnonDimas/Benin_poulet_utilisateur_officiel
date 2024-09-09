import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/routes.dart';
import 'package:benin_poulet/services/authentification_services.dart';
import 'package:benin_poulet/utils/snack_bar.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../utils/wave_painter.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({super.key});

  @override
  State<InscriptionPage> createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _confirmPassWordController =
      TextEditingController();
  final TextEditingController _phoneNumbercontroller = TextEditingController();
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');
  bool isSignUp = false;
  double widthS = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          /// Image d'arrière-plan
          Image.asset(
            //'assets/icons/signup.png',
            "assets/icons/login14.png",
            fit: BoxFit.fitHeight,
            height: appHeightSize(context) * 0.15,
            width: appWidthSize(context) * 0.5,
            //color: primaryColor,
          ),

          /// Contenu avec forme sinusoïdale
          CustomPaint(
            painter: WavePainter(),
            child: Container(
              height: appHeightSize(context),
              padding: const EdgeInsets.all(20),
              child: Column(
                /*mainAxisSize: MainAxisSize.min,*/
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: appHeightSize(context) * 0.07),

                  // texte : 'Bienvenue !'
                  ShaderMask(
                    blendMode: BlendMode.srcATop,
                    // Choisissez le mode de fusion selon vos préférences
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          /*Theme.of(context).colorScheme.inversePrimary,
                          Theme.of(context).colorScheme.inversePrimary,*/
                          primaryColor,
                          primaryColor,
                          primaryColor,
                        ], // Couleurs de votre dégradé
                        tileMode: TileMode.clamp,
                      ).createShader(bounds);
                    },
                    child: Text(
                      'Bienvenue !',
                      style: TextStyle(
                          fontSize: largeText() * 1.5,
                          fontWeight: FontWeight.bold,
                          color: primaryColor),
                    ),
                  ),
                  const SizedBox(height: 10),

                  /// Formulaire d'inscription
                  // Nom et Prenom
                  //nom
                  AppTextField(
                    label: 'Nom',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    controller: _lastNameController,
                    prefixIcon: CupertinoIcons.person_alt_circle,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 10),
                  //prenom
                  AppTextField(
                    label: 'Prénom',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    controller: _firstNameController,
                    prefixIcon: CupertinoIcons.person_alt_circle,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                    //minLines: 4,
                  ),
                  const SizedBox(height: 10),

                  // Numéro de téléphone
                  AppPhoneTextField(
                    controller: _phoneNumbercontroller,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 10),

                  // Mot de passe
                  AppTextField(
                    label: 'Mot de passe',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    isPassword: true,
                    controller: _passWordController,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  const SizedBox(height: 10),

                  // Confirmation de mot de passe
                  AppTextField(
                    label: 'Confirmer mot de passe',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Theme.of(context).colorScheme.surface,
                    isPassword: true,
                    controller: _confirmPassWordController,
                    fontSize: mediumText() * 0.9,
                    fontColor: Theme.of(context).colorScheme.inversePrimary,
                  ),
                  SizedBox(height: appHeightSize(context) * 0.03),

                  // bouton de l'inscription
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignUp = !isSignUp;
                        signUp();
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: appHeightSize(context) * 0.07,
                        width: appWidthSize(context) * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor),
                        child: isSignUp
                            ? const CupertinoActivityIndicator(
                                radius: 20.0, // Taille du spinner
                                color: Colors.white,
                              )
                            : Text(
                                'Inscription',
                                style: TextStyle(
                                    color: Colors.white, fontSize: largeText()),
                              )),
                  ),
                  const SizedBox(height: 20),

                  /// Fin du formulaire d'inscription

                  /// Autres options d'inscription

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

                  // divider
                  Divider(
                    color: Colors.grey.shade400,
                  ),

                  // méthodes d'inscription Google et de Apple
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // logo Google
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignUp = !isSignUp;
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

                      // logo Apple
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignUp = !isSignUp;
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

                      //Email
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSignUp = !isSignUp;
                          });
                          Navigator.of(context).pushNamed(
                            '/signupWithEmailPage',
                          );
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
                                'assets/logos/email.png',
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                    ],
                  ),

                  // texte : 'Avez-vous déjà de compte ? Se connecter'
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
                            Navigator.pushNamed(context, AppRoutes().LOGINPAGE);
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
        ],
      ),
    );
  }

  /// signUp()
  Future<void> signUp() async {
    bool passWordConform =
        _passWordController.value == _confirmPassWordController.value;

    print('''
    :::: essai => ${_lastNameController.text}
    :::: nom => ${_lastNameController.text}
    :::: prenom => ${_firstNameController.text}
    :::: numéro => ${_phoneNumbercontroller.text}
    :::: mot de passe => ${_passWordController.text}
    :::: confirmer mot de passe => ${_confirmPassWordController.text}
    :::: passWordConform => $passWordConform
     ''');

    if (_lastNameController.text.isEmpty || _lastNameController.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre nom');
    } else if (_firstNameController.text.isEmpty ||
        _firstNameController.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre prénom');
    } else if (_phoneNumbercontroller.text.isEmpty ||
        _phoneNumbercontroller.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre numéro de téléphone');
    } else if (_passWordController.text.isEmpty ||
        _passWordController.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre mot de passe');
    } else if (_confirmPassWordController.text.isEmpty ||
        _confirmPassWordController.text == "") {
      _showSnackBar(context, 'Veuillez confirmer votre mot de passe');
    } else if (!passWordConform) {
      _showSnackBar(context, 'Les mots de passe ne sont pas identiques');
    } else {
      // fonction pour l'inscription
      AthentificationServices.signup();
      // snack bar
      _showAwesomeSnackBar(
          context,
          'Inscription Réussie',
          'Votre inscription est effectuée avec succès',
          ContentType.success,
          primaryColor);
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
