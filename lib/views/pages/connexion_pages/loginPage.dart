import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../core/firebase/auth/auth_services.dart';
import '../../../services/authentification_services.dart';
import '../../../tests/blurryContainer.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/wave_painter.dart';
import '../../../widgets/app_phone_textField.dart';
import '../../models_ui/model_optionsDeConnexion.dart';
import '../started_pages/presentationPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _phoneNumbercontroller = TextEditingController();
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ', dialCode: "+229");
  bool isLoggedIn = false;
  bool seSouvenir = true;
  bool _shouldInterceptBack = true;

  //final GoogleSignIn signIn = GoogleSignIn.instance;
  void _handleGoogleSignIn(BuildContext context) async {
    final user = await AuthServices.signInWithGoogle();
    if (user != null) {
      print('::::::::::: Connexion réussie: ${user.displayName}');
      // Naviguez vers votre écran d'accueil
    } else {
      print('Échec de la connexion');
      // Affichez un message d'erreur à l'utilisateur
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _shouldInterceptBack = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
    );
    return _shouldInterceptBack
        ? WillPopScope(
            onWillPop: () async {
              final shouldPop = await AppUtils.showExitConfirmationDialog(
                  context,
                  message: 'Voulez-vous vraiment quitter l\'application ?');
              return shouldPop; // true = autorise le pop, false = bloque
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthFailure) {
                    final errorMsg = state.errorMessage.toLowerCase();

                    // Cas spécifique : numéro béninois invalide
                    if (errorMsg.contains('bénin') || errorMsg.contains('01')) {
                      AppUtils.showInfoDialog(
                        context: context,
                        message: state.errorMessage,
                        type: InfoType.error,
                      );
                    } else {
                      // Autres cas : snackBar classique
                      AppUtils.showSnackBar(context, state.errorMessage);
                    }
                  }

                  if (state is AuthLoading) {
                  } else if (state is AuthAuthenticated) {
                    _passWordController.clear();
                    _phoneNumbercontroller.clear();
                    AppUtils.showAwesomeSnackBar(
                        context,
                        'Connexion Réussie',
                        'Utilisateur connecté avec succès',
                        ContentType.success,
                        AppColors.primaryColor);
                    Navigator.pushNamed(context, AppRoutes.CLIENTHOMEPAGE);
                  }
                },
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Column(
                          children: [
                            // arriere plan dégradé
                            SizedBox(
                              height: context.screenHeight * 0.2,
                              width: context.screenWidth,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // gradient purple de l'arrière-plan
                                  Positioned(
                                    top: 20,
                                    left: 5,
                                    child: Hero(
                                      tag: '1',
                                      child: GradientBall(
                                          size: Size.square(
                                              context.screenHeight * 0.09),
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
                                      tag: '2',
                                      child: GradientBall(
                                          size: Size.square(
                                              context.screenHeight * 0.1),
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
                                      filter: ImageFilter.blur(
                                          sigmaX: 340, sigmaY: 340),
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
                                height: context.screenHeight * 0.8,
                                padding: const EdgeInsets.all(20),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // floutage de l'arrière-plan
                                      BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 340, sigmaY: 340),
                                          //blur(sigmaX: 100, sigmaY: 100),
                                          child: SizedBox()),
                                      SizedBox(
                                          height: context.screenHeight * 0.08),

                                      /// texte : Bienvenue
                                      Text(
                                        'Bienvenue !',
                                        style: TextStyle(
                                            fontSize: context.largeText * 1.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor),
                                      ),
                                      const SizedBox(height: 15),

                                      /// Formulaire de connexion

                                      // numéro de téléphone
                                      AppPhoneTextField(
                                        controller: _phoneNumbercontroller,
                                        initialCountry: number.isoCode,
                                        fontSize: context.mediumText * 0.9,
                                        maxLength: number.dialCode == "+229"
                                            ? 10
                                            : 15, // 10 pour le Bénin, 15 pour les autres pays
                                        fontColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                        fileColor: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.8),
                                        onInputChanged: (PhoneNumber number) {
                                          setState(() {
                                            this.number = number;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 20),

                                      // mot de passe
                                      AppTextField(
                                        label: 'Mot de passe',
                                        height: context.screenHeight * 0.08,
                                        width: context.screenWidth * 0.9,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background
                                            .withOpacity(0.8),
                                        isPassword: true,
                                        controller: _passWordController,
                                        fontSize: context.mediumText * 0.9,
                                        fontColor: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                      const SizedBox(height: 5),

                                      // Se souvenir / Mot de passe oublié
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                activeColor:
                                                    AppColors.primaryColor,
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
                                                  fontSize:
                                                      context.mediumText * 0.8,
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
                                              color: AppColors.primaryColor,
                                              fontSize:
                                                  context.mediumText * 0.8,
                                            ),
                                          ),
                                        ],
                                      ),
                                      // bouton de connexion
                                      GestureDetector(
                                        onTap: () {
                                          print(
                                              "::::::::::${number.phoneNumber}");
                                          context.read<AuthBloc>().add(
                                              PhoneLoginRequested(
                                                  phoneNumber: number,
                                                  password: _passWordController
                                                      .value.text));
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            height: context.screenHeight * 0.07,
                                            width: context.screenWidth * 0.9,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: AppColors.primaryColor),
                                            child: state is AuthLoading
                                                ? const CupertinoActivityIndicator(
                                                    radius:
                                                        20.0, // Taille du spinner
                                                    color: Colors.white,
                                                  )
                                                : Text(
                                                    'Connexion',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            context.largeText),
                                                  )),
                                      ),
                                      const SizedBox(height: 20),

                                      /// Fin du formulaire de connexion

                                      /// Autres options de connexion

                                      // texte : 'ou continuer avec'
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                              height:
                                                  context.screenHeight * 0.035,
                                              child: AppText(
                                                text: "ou continuer avec",
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary
                                                    .withOpacity(0.4),
                                                fontSize:
                                                    context.smallText * 1.2,
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

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      // méthode de connexion Google, Apple et Email
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          //Google
                                          Hero(
                                            tag: 'appleTag',
                                            child: ModelOptionDeConnexion(
                                              onTap: () async {
                                                /*context.read<AuthBloc>().add(
                                                    GoogleLoginRequested());*/
                                                _handleGoogleSignIn(context);
                                              },
                                              child: Image.asset(
                                                'assets/logos/google.png' /*: 'assets/logos/google2.png'*/,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),

                                          //Apple
                                          Hero(
                                            tag: 'googleTag',
                                            child: ModelOptionDeConnexion(
                                              onTap: () {
                                                AppUtils.showInfoDialog(
                                                  context: context,
                                                  message:
                                                      'Cette fonctionnalité arrive bientôt',
                                                  type: InfoType.info,
                                                );
                                                /* context
                                                    .read<AuthBloc>()
                                                    .add(ICloudLoginRequested());*/
                                              },
                                              child: Image.asset(
                                                'assets/logos/apple.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),

                                          //Email
                                          Hero(
                                            tag: 'emailTag',
                                            child: ModelOptionDeConnexion(
                                              onTap: () {
                                                setState(() {
                                                  isLoggedIn = !isLoggedIn;
                                                });
                                                Navigator.pushNamed(
                                                    context,
                                                    AppRoutes
                                                        .LOGINWITHEMAILPAGE);
                                              },
                                              child: Image.asset(
                                                'assets/logos/email2.png',
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),

                                      // texte : 'Vous n'avez pas encore de compte? S'inscrire'
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AppText(
                                            text:
                                                'Vous n\'avez pas de compte ?',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary
                                                .withOpacity(0.4),
                                            fontSize: context.smallText * 1.2,
                                          ),

                                          // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pushNamed(context,
                                                    AppRoutes.PRESENTATIONPAGE);
                                              },
                                              child: AppText(
                                                text: 'S\'inscrire',
                                                color: AppColors.primaryColor,
                                                fontSize:
                                                    context.smallText * 1.2,
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            //const SizedBox(height: 150),
                          ],
                        ),

                        // Image d'arrière-plan
                        Positioned(
                          top: context.screenHeight * 0.065,
                          child: Hero(
                            tag: 'logoTag',
                            child: Image.asset(
                              'assets/images/login2.png',
                              fit: BoxFit.fitHeight,
                              height: context.screenHeight * 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ))
        : PresentationPage();
  }

  /// login() function
  Future<void> login() async {
    print('''
    :::: numéro => ${_phoneNumbercontroller.text}
    :::: mot de passe => ${_passWordController.text}
     ''');

    if (_phoneNumbercontroller.text.isEmpty ||
        _phoneNumbercontroller.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre numéro de téléphone');
    } else if (_passWordController.text.isEmpty ||
        _passWordController.text == "") {
      _showSnackBar(context, 'Veuillez saisir votre mot de passe');
    } else {
      // fonction pour l'inscription
      AthentificationServices.login();
      // snack bar
      _showAwesomeSnackBar(
          context,
          'Connexion Réussie',
          'Utilisateur connecté avec succès',
          ContentType.success,
          Colors.green);
    }
  }

  @override
  void dispose() {
    _passWordController.dispose();
    _phoneNumbercontroller.dispose();
    super.dispose();
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
