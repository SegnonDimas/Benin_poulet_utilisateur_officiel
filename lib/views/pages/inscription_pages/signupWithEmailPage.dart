import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../core/firebase/auth/auth_services.dart';
import '../../../tests/blurryContainer.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/wave_painter.dart';
import '../../../widgets/app_button.dart';
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
    Widget divider = Divider(
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Column(
                children: [
                  // arriere plan dégradé
                  SizedBox(
                    height: context.screenHeight * 0.18,
                    width: context.screenWidth,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // gradient purple de l'arrière-plan
                        Positioned(
                          top: 20,
                          left: 5,
                          child: Hero(
                            tag: '1__',
                            child: GradientBall(
                                size: Size.square(context.screenHeight * 0.09),
                                colors: const [
                                  //blueColor,
                                  Colors.deepPurple,
                                  Colors.purpleAccent
                                ]),
                          ),
                        ),

                        // gradient couleur primaire de l'arrière-plan
                        Positioned(
                          bottom: 0, //context.screenHeight * 0.8,
                          right: 10,
                          child: Hero(
                            tag: '2__',
                            child: GradientBall(
                                size: Size.square(context.screenHeight * 0.1),
                                colors: [
                                  /*Colors.orange,
                                            Colors.yellow*/
                                  AppColors.primaryColor,
                                  AppColors.secondaryColor
                                ]),
                          ),
                        ),
                        // floutage de l'arrière-plan
                        BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 340, sigmaY: 340),
                            //blur(sigmaX: 100, sigmaY: 100),
                            child: SizedBox()),
                      ],
                    ),
                  ),

                  // Contenu avec forme sinusoïdale
                  CustomPaint(
                    painter: WavePainter(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: Container(
                      //height: context.height * 0.8,
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 0, right: 20, left: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // floutage de l'arrière-plan
                            BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 340, sigmaY: 340),
                                //blur(sigmaX: 100, sigmaY: 100),
                                child: SizedBox()),
                            SizedBox(height: context.height * 0.07),

                            /// texte : Bienvenue
                            AppText(
                                text: 'Bienvenue !',
                                fontSize: context.largeText * 1.5,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryColor),

                            const SizedBox(height: 0),

                            /// Formulaire de connexion
                            SizedBox(
                              height: context.height * 0.31,
                              child: NotificationListener<ScrollNotification>(
                                  onNotification: (notification) {
                                    if (notification
                                        is OverscrollNotification) {
                                      // Transfère le scroll vers le parent à la fin du scroll
                                      PrimaryScrollController.of(context)
                                          .jumpTo(
                                        PrimaryScrollController.of(context)
                                                .offset +
                                            notification.overscroll / 2,
                                      );
                                    }
                                    return false;
                                  },
                                  child: Scrollbar(
                                    child: ListView(
                                      padding: EdgeInsets.only(top: 20),
                                      children: [
                                        Column(
                                          children: [
                                            // Adresse Email
                                            AppTextField(
                                              label: 'Adresse Email',
                                              height: context.height * 0.08,
                                              width: context.width * 0.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              controller: _emailcontroller,
                                              prefixIcon: Icons.email,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                            const SizedBox(height: 10),

                                            // mot de passe
                                            AppTextField(
                                              label: 'Mot de passe',
                                              height: context.height * 0.08,
                                              width: context.width * 0.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              isPassword: true,
                                              controller: _passWordController,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                            const SizedBox(height: 10),

                                            // confirmation de mot de passe
                                            AppTextField(
                                              label: 'Confirmer mot de passe',
                                              height: context.height * 0.08,
                                              width: context.width * 0.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              isPassword: true,
                                              controller:
                                                  _passWordConfirmController,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            ),
                                            const SizedBox(height: 0),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),

                            //SizedBox(height: context.height * 0.015),

                            // bouton de connexion
                            GestureDetector(
                              onTap: () async {
                                final _email = _emailcontroller.text.trim();
                                final _password =
                                    _passWordController.text.trim();
                                emailSignup(_email, _password);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: context.height * 0.07,
                                width: context.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColors.primaryColor),
                                child: isLoggedIn
                                    ? const CupertinoActivityIndicator(
                                        radius:
                                            20.0, // Taille du spinnerupcolor: Colors.white,
                                      )
                                    : AppText(
                                        text: 'Inscription',
                                        color: Colors.white,
                                        fontSize: context.largeText),
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// Fin du formulaire de connexion

                            // texte : 'ou continuer avec'
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    //width: context.screenWidth * 0.15,
                                    child: divider,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: AppButton(
                                    borderColor: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary
                                        .withOpacity(0.1),
                                    bordeurRadius: 7,
                                    height: context.screenHeight * 0.035,
                                    child: AppText(
                                      text: "ou continuer avec",
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.4),
                                      fontSize: context.smallText * 1.2,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: SizedBox(
                                    //width: context.screenWidth * 0.15,
                                    child: divider,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            /// Autres options de connexion

                            SizedBox(
                              //height: context.height * 0.17,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    // méthode de connexion Google, Apple et Email
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          width: context.width * 0.15,
                                        ),

                                        //Apple
                                        Hero(
                                          tag: 'appleTag',
                                          child: ModelOptionDeConnexion(
                                            onTap: () {
                                              /*setState(() {
                                                isLoggedIn = !isLoggedIn;
                                              });*/
                                              AppUtils.showInfoDialog(
                                                context: context,
                                                message:
                                                    'Cette fonctionnalité arrive bientôt',
                                                type: InfoType.info,
                                              );
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AppText(
                                          text: 'Avez-vous déjà de compte ?',
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary
                                              .withOpacity(0.4),
                                          fontSize: context.smallText * 1.2,
                                        ),

                                        // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, AppRoutes.LOGINPAGE);
                                            },
                                            child: AppText(
                                              text: 'Se connecter',
                                              color: AppColors.primaryColor,
                                              fontSize: context.smallText * 1.2,
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // image d'arrière-plan
              Positioned(
                top: context.height * 0.08,
                child: Hero(
                  tag: 'emailTag',
                  transitionOnUserGestures: true,
                  child: Image.asset(
                    'assets/logos/email2.png',
                    fit: BoxFit.fitHeight,
                    height: context.height * 0.15,
                    //width: context.width * 0.4,
                  ),
                ),
              ),
              // bouton de retour
              Positioned(
                top: context.height * 0.05,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: context.height * 0.055,
                      width: context.height * 0.055,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.3),
                        borderRadius: BorderRadius.circular(
                          context.height,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: context.mediumText,
                        weight: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// emailSignup()
  Future<void> emailSignup(String _email, String _password) async {
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
      try {
        // fonction pour l'inscription
        await AuthServices.createEmailAuth(_email, _password);
        // snack bar
        _showAwesomeSnackBar(
            context,
            'Inscription Réussie',
            'Utilisateur connecté avec succès',
            ContentType.success,
            Colors.green);
        Navigator.pushNamed(context, AppRoutes.CLIENTHOMEPAGE);
      } catch (e) {
        if (e.toString().contains('already')) {
          AppUtils.showSnackBar(
              context, "Cette adresse est deja associee a un compte");
        }
        if (kDebugMode) {
          print(
              '::::::::::::::Erreur lors de la connexion : $e ::::::::::::::');
        }

        /*AppUtils.showSnackBar(
          context, "Cette adresse est deja associee a un compte");*/
      }
    }
  }
}

/// snackbars
void _showSnackBar(BuildContext context, String message) {
  AppUtils.showSnackBar(context, message);
}

void _showAwesomeSnackBar(BuildContext context, String title, String message,
    ContentType contentType, Color? color) {
  AppUtils.showAwesomeSnackBar(context, title, message, contentType, color);
}
