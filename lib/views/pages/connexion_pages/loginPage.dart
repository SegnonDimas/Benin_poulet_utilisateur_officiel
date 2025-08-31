import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/bloc/userRole/user_role_bloc.dart';
import 'package:benin_poulet/constants/app_pages_name.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/core/firebase/firestore/error_report_repository.dart';
import 'package:benin_poulet/models/error_report.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../services/authentification_services.dart';
import '../../../services/navigation_service.dart';
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

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  TextEditingController _passWordController = TextEditingController();
  TextEditingController _phoneNumbercontroller = TextEditingController();
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ', dialCode: "+229");
  bool isLoggedIn = false;
  bool seSouvenir = true;
  bool _shouldInterceptBack = true;
  bool _isPageActive = true;

  //final GoogleSignIn signIn = GoogleSignIn.instance;
  /*void _handleGoogleSignIn(BuildContext context) async {
    final user = await AuthServices.signInWithGoogle();

    // `providerData` est une liste des fournisseurs d'authentification liés au compte
    for (final userInfo in user!.providerData) {
      if (userInfo.providerId == GoogleAuthProvider.PROVIDER_ID) {
        print('Ce compte est lié à Google.');
        AppUtils.showSnackBar(context, "Ce compte est lié à Google.");
      }
      if (userInfo.providerId == EmailAuthProvider.PROVIDER_ID) {
        print('Ce compte est lié à l\'e-mail et au mot de passe.');
        AppUtils.showSnackBar(
            context, "Ce compte est lié à l'e-mail et au mot de passe.");
      }
      // D'autres providerId comme FacebookAuthProvider.PROVIDER_ID, etc.
    }
  }*/

  User? _user;
  Map<String, dynamic>? _userData;
  Future<void> _loadUserData() async {
    _user = FirebaseAuth.instance.currentUser;

    if (_user != null) {
      String userId = _user!.uid;

      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      // Récupérez les données spécifiques de l'utilisateur
      _userData = userSnapshot.data() ?? {};

      // Mettez à jour l'état pour déclencher un réaffichage
      if (mounted) {
        setState(() {});
      }

      _loadUserData();
    }
  }

  final se_souvenir = GetStorage();

  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    _isPageActive = true;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _shouldInterceptBack = true;
      });
    });

    _phoneNumbercontroller = TextEditingController(text: "0152748342");
    _passWordController = TextEditingController(text: "123457");

    se_souvenir.write('se_souvenir', seSouvenir);
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
              body: BlocListener<UserRoleBloc, UserRoleState>(
                listenWhen: (previous, current) {
                  return _isPageActive && _isMounted;
                },
                listener: (context, uRoleState) {
                  // TODO: au cas où...
                },
                child: BlocBuilder<UserRoleBloc, UserRoleState>(
                  builder: (context, uRoleState) {
                    return BlocListener<AuthBloc, AuthState>(
                      listenWhen: (previous, current) {
                        // Ne réagir que si la page est active et montée
                        return _isPageActive && _isMounted;
                      },
                      listener: (context, authState) async {
                        if (authState is AuthFailure) {
                          final errorMsg = authState.errorMessage.toLowerCase();

                          // Cas spécifique : numéro béninois invalide
                          if (errorMsg.contains('bénin') ||
                              errorMsg.contains('01')) {
                            Navigator.pop(
                                context); // fermer le loading de AuthLoading
                            AppUtils.showInfoDialog(
                                context: context,
                                message: authState.errorMessage,
                                type: InfoType.error,
                                barrierDismissible: false
                                //onTitleIconTap: () => Navigator.pop(context)
                                );
                          } else {
                            // Autres cas : snackBar classique
                            /* AppUtils.showSnackBar(
                                context, authState.errorMessage);*/
                            Navigator.pop(
                                context); // fermer le loading de AuthLoading
                            AppUtils.showErrorNotification(
                                context, authState.errorMessage, null);
                          }
                        }

                        if (authState is GoogleLoginRequestFailure) {
                          final errorMsg = authState.errorMessage.toLowerCase();
                          AppUtils.showErrorNotification(
                              context, errorMsg, null);
                        }

                        if (authState is AuthLoading) {
                          AppUtils.showInfoDialog(
                              context: context,
                              type: InfoType.loading,
                              barrierDismissible: false,
                              message: "Patientez...");
                        }

                        if (authState is PhoneLoginRequestSuccess) {
                          try {
                            var _password = _passWordController.text;
                            await AuthServices.signInWithPhone(
                                number, _password);

                            Navigator.pop(
                                context); // fermer le loading de AuthLoading
                            AppUtils.showSuccessNotification(
                                context, 'Connexion Réussie'
                                /*'Utilisateur connecté avec succès',*/
                                );

                            // Redirection basée sur le rôle
                            await NavigationService.redirectBasedOnRole(
                                context);

                            // Nettoyage des champs
                            _passWordController.clear();
                            _phoneNumbercontroller.clear();
                          } on FirebaseAuthException catch (e) {
                            String errorMessage;
                            switch (e.code) {
                              case 'user-not-found':
                                errorMessage =
                                    'Aucun compte trouvé avec ce numéro de téléphone. Veuillez vous inscrire.';
                                // Rediriger vers l'inscription après un délai
                                Future.delayed(const Duration(seconds: 3), () {
                                  if (mounted) {
                                    Navigator.pop(
                                        context); // supprime le dialogue du précédent message d'erreur
                                    NavigationService.redirectToSignup(context,
                                        title: _phoneNumbercontroller.text,
                                        content: errorMessage);
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
                              case 'too-many-requests':
                                errorMessage =
                                    'Trop de tentatives. Veuillez réessayer plus tard.';
                                break;
                              default:
                                errorMessage =
                                    'Erreur de connexion: ${e.message}';
                                break;
                            }

                            Navigator.pop(
                                context); // fermer le loading de AuthLoading

                            e.toString().contains('network') ||
                                    e.toString().contains('internal') ||
                                    e.toString().contains('connect') ||
                                    errorMessage
                                        .toString()
                                        .contains('Erreur de connexion')
                                ? AppUtils.showInfoDialog(
                                    context: context,
                                    message:
                                        "Veuillez verifier votre connexion internet et reessayer",
                                    type: InfoType.networkError)
                                : AppUtils.showInfoDialog(
                                    context: context,
                                    message: errorMessage,
                                    type: InfoType.error,
                                    barrierDismissible: false
                                    //onTitleIconTap: () => Navigator.pop(context)
                                    );
                          } catch (e) {
                            // Enregistrer le rapport d'erreur
                            ErrorReport errorReport = ErrorReport(
                              errorMessage: e.toString(),
                              errorPage: AppPagesName.loginPage,
                              date: DateTime.now(),
                            );

                            Navigator.pop(
                                context); // fermer le loading de AuthLoading
                            AppUtils.showInfoDialog(
                                context: context,
                                message:
                                    'Une erreur inattendue s\'est produite. Veuillez réessayer.',
                                type: InfoType.error,
                                duration: Duration(seconds: 6),
                                barrierDismissible: false
                                //onTitleIconTap: () => Navigator.pop(context)
                                );

                            // temps d'attente avant le dialogue d'envoi du rapport d'erreur
                            Future.delayed(Duration(seconds: 2));

                            // affichier le dialogue d'envoi du rapport d'erreur
                            Navigator.pop(context);
                            AppUtils.showDialog(
                              context: context,
                              barrierDismissible: false,
                              hideContent: true,
                              title: 'Rapport d\'erreur',
                              content: e.toString(),
                              cancelText: 'Fermer',
                              confirmText: 'Envoyer le rapport',
                              cancelTextColor: AppColors.primaryColor,
                              confirmTextColor: AppColors.redColor,
                              onConfirm: () async {
                                await FirebaseErrorReportRepository()
                                    .sendErrorReport(errorReport);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            );
                          }
                        }

                        if (authState is GoogleLoginRequestSuccess) {
                          try {
                            final user = await AuthServices.signInWithGoogle();

                            Navigator.pop(context);

                            if (user != null) {
                              AppUtils.showAwesomeSnackBar(
                                  context,
                                  'Connexion Réussie',
                                  'Utilisateur connecté avec succès',
                                  ContentType.success,
                                  AppColors.primaryColor);

                              // Redirection basée sur le rôle
                              await NavigationService.redirectBasedOnRole(
                                  context);
                            }
                          } on FirebaseAuthException catch (e) {
                            Navigator.pop(context);
                            String errorMessage;
                            switch (e.code) {
                              case 'user-not-found':
                                errorMessage =
                                    'Aucun compte n\'est associé à cette adresse Google. Veuillez vous inscrire.';
                                AppUtils.showInfoDialog(
                                  context: context,
                                  message: errorMessage,
                                  type: InfoType.error,
                                );
                                // Rediriger vers l'inscription après un délai
                                Future.delayed(const Duration(seconds: 3), () {
                                  if (mounted) {
                                    Navigator.pop(
                                        context); // supprime le dialogue du précédent message d'erreur
                                    NavigationService.redirectToSignup(context,
                                        title: 'Connexion échouée',
                                        titleColor: AppColors.redColor,
                                        content: errorMessage);
                                  }
                                });
                                return;
                              case 'account-exists-with-different-credential':
                                errorMessage =
                                    'Un compte existe déjà avec cette adresse email mais avec une méthode de connexion différente.';
                                break;
                              case 'invalid-credential':
                                errorMessage =
                                    'Erreur d\'authentification. Veuillez réessayer.';
                                break;
                              case 'operation-not-allowed':
                                errorMessage =
                                    'La connexion Google n\'est pas activée.';
                                break;
                              case 'user-disabled':
                                errorMessage = 'Ce compte a été désactivé.';
                                break;
                              case 'too-many-requests':
                                errorMessage =
                                    'Trop de tentatives. Veuillez réessayer plus tard.';
                                break;
                              default:
                                errorMessage =
                                    'Erreur de connexion Google: ${e.message}';
                                break;
                            }

                            e.toString().contains('network') ||
                                    e.toString().contains('internal') ||
                                    e.toString().contains('connect') ||
                                    errorMessage
                                        .toString()
                                        .contains('Erreur de connexion')
                                ? AppUtils.showInfoDialog(
                                    context: context,
                                    message:
                                        "Veuillez verifier votre connexion internet et reessayer",
                                    type: InfoType.networkError)
                                : AppUtils.showInfoDialog(
                                    context: context,
                                    message: errorMessage,
                                    type: InfoType.error,
                                    barrierDismissible: false
                                    //onTitleIconTap: () => Navigator.pop(context)
                                    );

                            /*AppUtils.showInfoDialog(
                              context: context,
                              message: errorMessage,
                              type: InfoType.error,
                            );*/
                          } catch (e) {
                            // Enregistrer le rapport d'erreur
                            ErrorReport errorReport = ErrorReport(
                              errorMessage: e.toString(),
                              errorPage: AppPagesName.loginPage,
                              date: DateTime.now(),
                            );

                            Navigator.pop(
                                context); // fermer le loading de AuthLoading
                            AppUtils.showInfoDialog(
                                context: context,
                                message:
                                    'Une erreur inattendue s\'est produite. Veuillez réessayer.',
                                type: InfoType.error,
                                duration: Duration(seconds: 6),
                                barrierDismissible: false
                                //onTitleIconTap: () => Navigator.pop(context)
                                );

                            // temps d'attente avant le dialogue d'envoi du rapport d'erreur
                            Future.delayed(Duration(seconds: 2));

                            // affichier le dialogue d'envoi du rapport d'erreur
                            Navigator.pop(context);
                            AppUtils.showDialog(
                              context: context,
                              barrierDismissible: false,
                              hideContent: true,
                              title: 'Rapport d\'erreur',
                              content: e.toString(),
                              cancelText: 'Fermer',
                              confirmText: 'Envoyer le rapport',
                              cancelTextColor: AppColors.primaryColor,
                              confirmTextColor: AppColors.redColor,
                              onConfirm: () async {
                                await FirebaseErrorReportRepository()
                                    .sendErrorReport(errorReport);
                                if (context.mounted) {
                                  Navigator.pop(context);
                                }
                              },
                            );

                            /*AppUtils.showInfoDialog(
                              context: context,
                              message:
                                  'Une erreur inattendue s\'est produite lors de la connexion Google. Veuillez réessayer.',
                              type: InfoType.error,
                            );*/
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
                                              tag: '1',
                                              child: GradientBall(
                                                  size: Size.square(
                                                      context.screenHeight *
                                                          0.09),
                                                  colors: const [
                                                    //blueColor,
                                                    Colors.deepPurple,
                                                    Colors.purpleAccent
                                                  ]),
                                            ),
                                          ),

                                          // gradient couleur primaire de l'arrière-plan
                                          Positioned(
                                            bottom:
                                                0, //context.screenHeight * 0.8,
                                            right: 10,
                                            child: Hero(
                                              tag: '2',
                                              child: GradientBall(
                                                  size: Size.square(
                                                      context.screenHeight *
                                                          0.1),
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surface,
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
                                                  height: context.screenHeight *
                                                      0.08),

                                              /// texte : Bienvenue
                                              Text(
                                                'Bienvenue !',
                                                style: TextStyle(
                                                    fontSize:
                                                        context.largeText * 1.5,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        AppColors.primaryColor),
                                              ),
                                              const SizedBox(height: 15),

                                              /// Formulaire de connexion

                                              // numéro de téléphone
                                              AppPhoneTextField(
                                                controller:
                                                    _phoneNumbercontroller,
                                                initialCountry: number.isoCode,
                                                fontSize:
                                                    context.mediumText * 0.9,
                                                maxLength: number.dialCode ==
                                                        "+229"
                                                    ? 10
                                                    : 15, // 10 pour le Bénin, 15 pour les autres pays
                                                fontColor: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                                fileColor: Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                    .withOpacity(0.8),
                                                onInputChanged:
                                                    (PhoneNumber number) {
                                                  setState(() {
                                                    this.number = number;
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 20),

                                              // mot de passe
                                              AppTextField(
                                                label: 'Mot de passe',
                                                height:
                                                    context.screenHeight * 0.08,
                                                width:
                                                    context.screenWidth * 0.9,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .background
                                                    .withOpacity(0.8),
                                                isPassword: true,
                                                controller: _passWordController,
                                                fontSize:
                                                    context.mediumText * 0.9,
                                                fontColor: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                              ),
                                              const SizedBox(height: 5),

                                              // Se souvenir / Mot de passe oublié
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                        activeColor: AppColors
                                                            .primaryColor,
                                                        checkColor:
                                                            Colors.white,
                                                        semanticLabel:
                                                            'Se rappeler de cet appareil et vous éviter d\'entrer vos identifiants de connexion la prochaine fois',
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            seSouvenir =
                                                                !seSouvenir;
                                                            se_souvenir.write(
                                                                "se_souvenir",
                                                                seSouvenir);
                                                          });
                                                        },
                                                        child: AppText(
                                                          text: 'Se souvenir',
                                                          color: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary
                                                              .withOpacity(0.4),
                                                          fontSize: context
                                                                  .mediumText *
                                                              0.8,
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
                                                      text:
                                                          'Mot de passe oublié ?',
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize:
                                                          context.mediumText *
                                                              0.8,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // bouton de connexion
                                              GestureDetector(
                                                onTap: () {
                                                  print(
                                                      "::::::::::${number.phoneNumber}");
                                                  se_souvenir.write(
                                                      'se_souvenir',
                                                      seSouvenir);
                                                  context.read<AuthBloc>().add(
                                                      PhoneLoginRequested(
                                                          phoneNumber: number,
                                                          password:
                                                              _passWordController
                                                                  .value.text));
                                                },
                                                child: Container(
                                                    alignment: Alignment.center,
                                                    height:
                                                        context.screenHeight *
                                                            0.07,
                                                    width: context.screenWidth *
                                                        0.9,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: AppColors
                                                            .primaryColor),
                                                    child: authState
                                                            is AuthLoading
                                                        ? const CupertinoActivityIndicator(
                                                            radius:
                                                                20.0, // Taille du spinner
                                                            color: Colors.white,
                                                          )
                                                        : Text(
                                                            'Connexion',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                                      borderColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary
                                                              .withOpacity(0.1),
                                                      bordeurRadius: 7,
                                                      height:
                                                          context.screenHeight *
                                                              0.035,
                                                      child: AppText(
                                                        text:
                                                            "ou continuer avec",
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary
                                                            .withOpacity(0.4),
                                                        fontSize:
                                                            context.smallText *
                                                                1.2,
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
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  //Google
                                                  Hero(
                                                    tag: 'appleTag',
                                                    child:
                                                        ModelOptionDeConnexion(
                                                      onTap: () async {
                                                        context
                                                            .read<AuthBloc>()
                                                            .add(
                                                                GoogleLoginRequested());
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
                                                    child:
                                                        ModelOptionDeConnexion(
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
                                                    child:
                                                        ModelOptionDeConnexion(
                                                      onTap: () {
                                                        setState(() {
                                                          isLoggedIn =
                                                              !isLoggedIn;
                                                          _isMounted = false;
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
                                                    fontSize:
                                                        context.smallText * 1.2,
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
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        color: AppColors
                                                            .primaryColor,
                                                        fontSize:
                                                            context.smallText *
                                                                1.2,
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
                    );
                  },
                ),
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
    _isMounted = false;
    // Ne pas mettre _isPageActive à false ici pour permettre la réactivation
    WidgetsBinding.instance.removeObserver(this);
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
