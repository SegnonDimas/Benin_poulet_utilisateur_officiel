import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../constants/routes.dart';
import '../../../services/authentification_services.dart';
import '../../../tests/blurryContainer.dart';
import '../../../utils/snack_bar.dart';
import '../../../utils/wave_painter.dart';
import '../../models_ui/model_optionsDeConnexion.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({super.key});

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage> {
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();

  bool isLoggedIn = false;
  bool seSouvenir = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            AppSnackBar.showSnackBar(context, state.errorMessage);
          }

          if (state is AuthLoading) {
          } else if (state is EmailLoginRequestSuccess) {
            _emailcontroller.clear();
            _passWordController.clear();
            print(':::::::::::::: Je suis ici debut ::::::::::::');
            AppSnackBar.showAwesomeSnackBar(
                context,
                'Connexion Réussie',
                'Utilisateur connecté avec succès',
                ContentType.success,
                primaryColor);

            Navigator.pushNamedAndRemoveUntil(context, AppRoutes.CLIENTHOMEPAGE,
                (Route<dynamic> route) => false);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
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
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
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
                          const SizedBox(height: 20),

                          /// Formulaire de connexion

                          // Adresse Email
                          AppTextField(
                            label: 'Adresse Email',
                            height: appHeightSize(context) * 0.08,
                            width: appWidthSize(context) * 0.9,
                            color: Theme.of(context).colorScheme.background,
                            controller: _emailcontroller,
                            prefixIcon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                            fontSize: mediumText() * 0.9,
                            fontColor:
                                Theme.of(context).colorScheme.inversePrimary,
                          ),
                          const SizedBox(height: 20),

                          // mot de passe
                          AppTextField(
                            label: 'Mot de passe',
                            height: appHeightSize(context) * 0.08,
                            width: appWidthSize(context) * 0.9,
                            color: Theme.of(context).colorScheme.background,
                            isPassword: true,
                            controller: _passWordController,
                            fontSize: mediumText() * 0.9,
                            fontColor:
                                Theme.of(context).colorScheme.inversePrimary,
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
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.4),
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
                              context.read<AuthBloc>().add(EmailLoginRequested(
                                    email: _emailcontroller.value.text,
                                    password: _passWordController.value.text,
                                  ));
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: appHeightSize(context) * 0.07,
                                width: appWidthSize(context) * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: primaryColor),
                                child: state is AuthLoading
                                    ? const CupertinoActivityIndicator(
                                        radius: 20.0, // Taille du spinner
                                        color: Colors.white,
                                      )
                                    : Text(
                                        'Connexion',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: largeText()),
                                      )),
                          ),
                          const SizedBox(height: 50),

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
                          Divider(
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.4),
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
                                text: 'Vous n\'avez pas de compte ?',
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.4),
                                fontSize: smallText() * 1.2,
                              ),

                              // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/presentationPage');
                                  },
                                  child: AppText(
                                    text: 'S\'inscrire',
                                    color: primaryColor,
                                    fontSize: smallText() * 1.2,
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
        },
      ),
    );
  }

  /// emailLogin()
  Future<void> emailLogin() async {
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
      AthentificationServices.emailLogin();
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
