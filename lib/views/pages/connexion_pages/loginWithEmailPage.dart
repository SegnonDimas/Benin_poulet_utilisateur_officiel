import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/bloc/userRole/user_role_bloc.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../services/authentification_services.dart';
import '../../../services/navigation_service.dart';
import '../../../tests/blurryContainer.dart';
import '../../../utils/wave_painter.dart';
import '../../../widgets/app_button.dart';
import '../../models_ui/model_optionsDeConnexion.dart';

class LoginWithEmailPage extends StatefulWidget {
  const LoginWithEmailPage({super.key});

  @override
  State<LoginWithEmailPage> createState() => _LoginWithEmailPageState();
}

class _LoginWithEmailPageState extends State<LoginWithEmailPage>
    with WidgetsBindingObserver {
  final TextEditingController _passWordController = TextEditingController();
  final TextEditingController _emailcontroller = TextEditingController();

  bool isLoggedIn = false;
  bool seSouvenir = true;
  bool _isPageActive = true;

  @override
  void initState() {
    super.initState();
    _isPageActive = true;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      _isPageActive = false;
    } else if (state == AppLifecycleState.resumed) {
      _isPageActive = true;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Réactiver la page quand elle redevient visible
    if (mounted && !_isPageActive) {
      _isPageActive = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vérifier si la route est active et réactiver si nécessaire
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          ModalRoute.of(context)?.isCurrent == true &&
          !_isPageActive) {
        setState(() {
          _isPageActive = true;
        });
      }
    });

    Widget divider = Divider(
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocListener<UserRoleBloc, UserRoleState>(
          listenWhen: (previous, current) {
            return _isPageActive;
          },
          listener: (context, userRoleState) {
            //TODO : au cas où...
          },
          child: BlocBuilder<UserRoleBloc, UserRoleState>(
            builder: (context, userRoleState) {
              return BlocListener<AuthBloc, AuthState>(
                listenWhen: (previous, current) {
                  // Ne réagir que si la page est active
                  return _isPageActive;
                },
                listener: (context, authState) async {
                  if (authState is AuthFailure) {
                    String errorMessage = authState.errorMessage;

                    // Améliorer les messages d'erreur pour une meilleure UX
                    if (errorMessage.toLowerCase().contains('user-not-found')) {
                      errorMessage =
                          'Aucun compte n\'est associé à cette adresse. Veuillez vous inscrire.';
                      // Rediriger vers l'inscription après un délai
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted) {
                          NavigationService.redirectToSignup(context);
                        }
                      });
                    } else if (errorMessage
                        .toLowerCase()
                        .contains('wrong-password')) {
                      errorMessage = 'Mot de passe incorrect. Réessayez.';
                    } else if (errorMessage
                        .toLowerCase()
                        .contains('invalid-credential')) {
                      errorMessage =
                          'Identifiants invalides. Veuillez vérifier vos informations.';
                    } else if (errorMessage
                        .toLowerCase()
                        .contains('too-many-requests')) {
                      errorMessage =
                          'Trop de tentatives. Veuillez réessayer plus tard.';
                    }

                    Navigator.pop(context);
                    AppUtils.showErrorNotification(context, errorMessage, null);
                  }

                  if (authState is AuthLoading) {
                    // Ne pas afficher de dialog de chargement pour éviter le blocage
                    // Le chargement sera géré par l'état du bouton
                    AppUtils.showInfoDialog(
                        context: context,
                        type: InfoType.loading,
                        barrierDismissible: false,
                        message: "Patientez...");
                  }
                  if (authState is AuthAuthenticated ||
                      authState is EmailLoginRequestSuccess) {
                    try {
                      // Connexion avec email
                      await AuthServices.signInWithEmailAndPassword(
                          _emailcontroller.text, _passWordController.text);

                      // Redirection basée sur le rôle
                      await NavigationService.redirectBasedOnRole(context);

                      // Nettoyage des champs de saisie
                      _emailcontroller.clear();
                      _passWordController.clear();
                    } on FirebaseAuthException catch (e) {
                      String errorMessage;
                      switch (e.code) {
                        case 'user-not-found':
                          errorMessage =
                              'Aucun compte trouvé avec cette adresse email. Veuillez vous inscrire.';
                          // Rediriger vers l'inscription après un délai
                          Future.delayed(const Duration(seconds: 3), () {
                            if (mounted) {
                              //Navigator.pop(context);
                              NavigationService.redirectToSignup(context);
                            }
                          });
                          break;
                        case 'wrong-password':
                          errorMessage =
                              'Mot de passe incorrect. Veuillez réessayer.';
                          break;
                        case 'invalid-credential':
                          errorMessage =
                              'Identifiants invalides. Veuillez vérifier vos informations.';
                          break;
                        case 'user-disabled':
                          errorMessage = 'Ce compte a été désactivé.';
                          break;
                        case 'too-many-requests':
                          errorMessage =
                              'Trop de tentatives. Veuillez réessayer plus tard.';
                          break;
                        default:
                          errorMessage = 'Erreur de connexion: ${e.message}';
                          break;
                      }
                      //Navigator.pop(context);
                      AppUtils.showErrorNotification(
                          context, errorMessage, null);
                    } catch (e) {
                      AppUtils.showInfoDialog(
                        context: context,
                        message:
                            'Une erreur inattendue s\'est produite. Veuillez réessayer.',
                        type: InfoType.error,
                      );
                    }
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
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
                                        tag: '1__',
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
                                        tag: '2__',
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
                                  //height: context.height * 0.8,
                                  padding: const EdgeInsets.only(
                                      right: 20, left: 20),
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
                                            height: context.screenHeight * 0.1),

                                        /// texte : Bienvenue
                                        Text(
                                          'Bienvenue !',
                                          style: TextStyle(
                                              fontSize: context.largeText * 1.5,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.primaryColor),
                                        ),
                                        const SizedBox(height: 20),

                                        /// Formulaire de connexion

                                        // Adresse Email
                                        AppTextField(
                                          label: 'Adresse Email',
                                          height: context.screenHeight * 0.08,
                                          width: context.screenWidth * 0.9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
                                          controller: _emailcontroller,
                                          prefixIcon: Icons.email,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          fontSize: context.mediumText * 0.9,
                                          fontColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          textCapitalization:
                                              TextCapitalization.none,
                                        ),
                                        const SizedBox(height: 20),

                                        // mot de passe
                                        AppTextField(
                                          label: 'Mot de passe',
                                          height: context.screenHeight * 0.08,
                                          width: context.screenWidth * 0.9,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
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
                                                        context.mediumText *
                                                            0.8,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            // mot de passe oublié
                                            TextButton(
                                              onPressed: () {
                                                // Ajouter une action pour mot de passe oublié
                                                AppUtils.showInfoDialog(
                                                  context: context,
                                                  message:
                                                      'Cette fonctionnalité arrive bientôt',
                                                  type: InfoType.info,
                                                );
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
                                        const SizedBox(height: 20),

                                        // bouton de connexion
                                        GestureDetector(
                                          onTap: () {
                                            context.read<AuthBloc>().add(
                                                EmailLoginRequested(
                                                    email:
                                                        _emailcontroller.text,
                                                    password:
                                                        _passWordController
                                                            .value.text));
                                          },
                                          child: Container(
                                              alignment: Alignment.center,
                                              height:
                                                  context.screenHeight * 0.07,
                                              width: context.screenWidth * 0.9,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color:
                                                      AppColors.primaryColor),
                                              child: authState is AuthLoading
                                                  ? const CupertinoActivityIndicator(
                                                      radius: 20.0,
                                                      color: Colors.white,
                                                    )
                                                  : Text(
                                                      'Connexion',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: context
                                                              .largeText),
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
                                                height: context.screenHeight *
                                                    0.035,
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
                                                child: divider,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20),

                                        // méthode de connexion Google, Apple et Email
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            //Google
                                            Hero(
                                              tag: 'appleTag',
                                              child: ModelOptionDeConnexion(
                                                onTap: () async {
                                                  context.read<AuthBloc>().add(
                                                      GoogleLoginRequested());
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
                                              tag: 'googleTag',
                                              child: ModelOptionDeConnexion(
                                                onTap: () {
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
                                                  Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .PRESENTATIONPAGE);
                                                },
                                                child: AppText(
                                                  text: 'S\'inscrire',
                                                  fontWeight: FontWeight.w900,
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
                            ],
                          ),

                          // image d'arrière-plan
                          Positioned(
                            top: context.screenHeight * 0.08,
                            child: Hero(
                              tag: 'emailTag',
                              transitionOnUserGestures: true,
                              child: Image.asset(
                                'assets/logos/email2.png',
                                fit: BoxFit.fitHeight,
                                height: context.screenHeight * 0.15,
                              ),
                            ),
                          ),
                          // bouton de retour
                          Positioned(
                            top: context.screenHeight * 0.05,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.back();
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: context.screenHeight * 0.055,
                                  width: context.screenHeight * 0.055,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(
                                      context.screenHeight,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                    size: context.mediumText,
                                    weight: 50,
                                  ),
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
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passWordController.dispose();
    _emailcontroller.dispose();
    // Ne pas mettre _isPageActive à false ici pour permettre la réactivation
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
  AppUtils.showSnackBar(context, message);
}

void _showAwesomeSnackBar(BuildContext context, String title, String message,
    ContentType contentType, Color? color) {
  AppUtils.showAwesomeSnackBar(context, title, message, contentType, color);
}
