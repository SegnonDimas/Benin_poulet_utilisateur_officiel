import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/userRole/user_role_bloc.dart';
import 'package:benin_poulet/constants/app_attributs.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/core/firebase/firestore/error_report_repository.dart';
import 'package:benin_poulet/models/error_report.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:benin_poulet/widgets/notification_widgets.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../bloc/auth/auth_bloc.dart';
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
  bool _isMounted = false;
  String currentPage = "Page d'inscription avec Email";

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
    );
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocConsumer<UserRoleBloc, UserRoleState>(
          listenWhen: (previous, current) {
            // Ne réagir que si la page est dans l'arborescence de navigation
            return _isMounted;
            //ModalRoute.of(context)?.isCurrent ?? false;
          },
          listener: (context, userRoleState) {
            // TODO: au cas où...
          },
          builder: (context, userRoleState) {
            return BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) {
                // Ne réagir que si la page est dans l'arborescence de navigation
                return _isMounted;
              },
              listener: (context, authState) async {
                // Lorsqu'il y a une erreur
                if (authState is AuthFailure) {
                  final errorMsg = authState.errorMessage;
                  //AppUtils.showSnackBar(context, authState.errorMessage);
                  Navigator.pop(context);
                  NotificationWidgets.showErrorNotification(
                      context, errorMsg, null);
                }

                // Lorsque l'inscription est en cours
                if (authState is AuthLoading) {
                  AppUtils.showInfoDialog(
                      context: context,
                      type: InfoType.loading,
                      message: "Patientez...");
                }

                // Lorsque l'inscription est effectuée par compte Google
                if (authState is GoogleSignUpRequestSuccess) {
                  try {
                    final user = await AuthServices.signUpWithGoogle(
                      role: userRoleState.role!,
                    );
                    
                    // Si l'utilisateur a annulé la sélection Google
                    if (user == null) {
                      Navigator.pop(context); // Fermer le dialogue de chargement
                      return;
                    }
                    
                    // Fermer le dialogue de chargement
                    Navigator.pop(context);
                    
                    if (userRoleState.role == UserRoles.SELLER) {
                      // proposition de crétation de boutique
                      context.mounted ? _showBottomSheet(context) : null;
                    } else if (userRoleState.role == UserRoles.BUYER) {
                      // rediredction vers la page de destination
                      context.mounted
                          ? Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.CLIENTHOMEPAGE,
                              (Route<dynamic> route) => false)
                          : null;
                    }
                  } catch (e) {
                    // Enregistrer le rapport d'erreur
                    ErrorReport errorReport = ErrorReport(
                      errorMessage: e.toString(),
                      errorPage: currentPage,
                      date: DateTime.now(),
                    );
                    if (context.mounted) {
                      // Fermer le dialogue de chargement
                      Navigator.pop(context);
                      
                      if (e.toString().contains('already')) {
                        AppUtils.showSnackBar(
                          context,
                          "Cette adresse est deja associée a un compte",
                          backgroundColor: AppColors.redColor,
                        );
                      } else {
                        AppUtils.showDialog(
                          context: context,
                          title: 'Rapport d\'erreur',
                          content: e.toString(),
                          hideContent: true,
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

                      if (kDebugMode) {
                        print(
                            ":::::::::::ERREUR LORS DE L'INSCRIPTION : $e::::::::::");
                      }
                    }
                  }
                }

                // Lorsque l'inscription est effectuée par adresse email
                if (authState is EmailSignUpRequestSuccess) {
                  try {
                    final _email = _emailcontroller.text.trim();
                    final _password = _passWordController.text.trim();
                    await AuthServices.createEmailAuth(
                      _email,
                      _password,
                      role: userRoleState.role!,
                    );

                    _passWordController.clear();
                    _passWordConfirmController.clear();
                    _emailcontroller.clear();
                    if (userRoleState.role == UserRoles.SELLER) {
                      // proposition de crétation de boutique
                      context.mounted
                          ? {Navigator.pop(context), _showBottomSheet(context)}
                          : null;
                    } else if (userRoleState.role == UserRoles.BUYER) {
                      // rediredction vers la page de destination
                      context.mounted
                          ? Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.CLIENTHOMEPAGE,
                              (Route<dynamic> route) => false)
                          : null;
                    }
                  } catch (e) {
                    // Enregistrer le rapport d'erreur
                    ErrorReport errorReport = ErrorReport(
                      errorMessage: e.toString(),
                      errorPage: currentPage,
                      date: DateTime.now(),
                    );
                    if (context.mounted) {
                      if (e.toString().contains('already')) {
                        AppUtils.showSnackBar(
                          context,
                          "Cette adresse est deja associée a un compte",
                          backgroundColor: AppColors.redColor,
                        );
                      } else {
                        AppUtils.showDialog(
                          context: context,
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
                    if (kDebugMode) {
                      print(
                          ":::::::::::ERREUR LORS DE L'INSCRIPTION : $e::::::::::");
                    }
                  }

                  // Pour les vendeurs, on ne redirige pas automatiquement car on affiche le bottom sheet
                  // Pour les acheteurs, on redirige vers la page client
                  if (userRoleState.role == UserRoles.BUYER) {
                    Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.CLIENTHOMEPAGE,
                        (Route<dynamic> route) => false);
                  }
                  // Pour les vendeurs, le bottom sheet s'affiche automatiquement
                }
              },
              builder: (context, authState) {
                return SingleChildScrollView(
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
                                  top: 20, bottom: 0, right: 20, left: 20),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // floutage de l'arrière-plan
                                    BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 340, sigmaY: 340),
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
                                      child: NotificationListener<
                                              ScrollNotification>(
                                          onNotification: (notification) {
                                            if (notification
                                                is OverscrollNotification) {
                                              // Transfère le scroll vers le parent à la fin du scroll
                                              PrimaryScrollController.of(
                                                      context)
                                                  .jumpTo(
                                                PrimaryScrollController.of(
                                                            context)
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
                                                      height:
                                                          context.height * 0.08,
                                                      width:
                                                          context.width * 0.9,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      controller:
                                                          _emailcontroller,
                                                      prefixIcon: Icons.email,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      textCapitalization:
                                                          TextCapitalization
                                                              .none,
                                                      fontSize:
                                                          context.mediumText *
                                                              0.9,
                                                      fontColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                    ),
                                                    const SizedBox(height: 10),

                                                    // mot de passe
                                                    AppTextField(
                                                      label: 'Mot de passe',
                                                      height:
                                                          context.height * 0.08,
                                                      width:
                                                          context.width * 0.9,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      isPassword: true,
                                                      controller:
                                                          _passWordController,
                                                      fontSize:
                                                          context.mediumText *
                                                              0.9,
                                                      fontColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                    ),
                                                    const SizedBox(height: 10),

                                                    // confirmation de mot de passe
                                                    AppTextField(
                                                      label:
                                                          'Confirmer mot de passe',
                                                      height:
                                                          context.height * 0.08,
                                                      width:
                                                          context.width * 0.9,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .background,
                                                      isPassword: true,
                                                      controller:
                                                          _passWordConfirmController,
                                                      fontSize:
                                                          context.mediumText *
                                                              0.9,
                                                      fontColor:
                                                          Theme.of(context)
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

                                    // bouton d'inscription
                                    GestureDetector(
                                      onTap: () async {
                                        context
                                            .read<AuthBloc>()
                                            .add(EmailSignUpRequested(
                                              email:
                                                  _emailcontroller.text.trim(),
                                              password: _passWordController.text
                                                  .trim(),
                                              confirmPassword:
                                                  _passWordConfirmController
                                                      .text
                                                      .trim(),
                                            ));
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: context.height * 0.07,
                                        width: context.width * 0.9,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
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
                                                    onTap: () async {
                                                      context.read<AuthBloc>().add(
                                                          GoogleSignUpRequested());
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
                                                  text:
                                                      'Avez-vous déjà de compte ?',
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
                                                          AppRoutes.LOGINPAGE);
                                                    },
                                                    child: AppText(
                                                      text: 'Se connecter',
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
            );
          },
        ),
      ),
    );
  }

  /// emailSignup()
  Future<void> emailSignup(
      String _email, String _password, String _confirmPassword) async {
    context.read<AuthBloc>().add(
          EmailSignUpRequested(
            email: _email,
            password: _password,
            confirmPassword: _confirmPassword,
          ),
        );
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

/// bottom sheet

Future<void> _showBottomSheet(BuildContext context) async {
  DocumentSnapshot doc = await FirebaseFirestore.instance
      .collection('users')
      .doc(AuthServices.userId)
      .get();
  var name = '';
  if (doc.exists) {
    name = doc['fullName'] ?? '';
  }
  context.mounted
      ? showModalBottomSheet(
          context: context,
          // TODO : enableDrag: false,
          // TODO : isDismissible: false,
          //showDragHandle: true,
          builder: (context) {
            return Column(
              children: [
                //SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 1.0, bottom: 8.0, left: 1.0, right: 1.0),
                  child: SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            'assets/images/img_1.png',
                            height: 200,
                            width: context.width,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          height: 180,
                          width: context.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.95),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.95),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.9),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.8),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.6),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        BlurryContainer(
                            height: 180,
                            width: context.width,
                            blur: 2,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            child: SizedBox()),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AppText(
                                  text: 'Créer boutique',
                                  color: AppColors.primaryColor,
                                  fontSize: context.largeText,
                                  fontWeight: FontWeight.bold,
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          AppRoutes.VENDEURMAINPAGE,
                                          (Route<dynamic> route) => false);
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.6),
                                      size: 30,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  textAlign: TextAlign.center,
                                  text:
                                      'Bienvenue sur ${AppAttributes.appName}, $name\n',
                                  color: Colors.white,
                                  fontSize: context.largeText * 0.8,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,
                                ),
                                AppText(
                                  textAlign: TextAlign.center,
                                  text: 'Commençons à créer votre boutique...',
                                  color: Colors.white,
                                  fontSize: context.largeText * 0.7,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.visible,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: context.height * 0.15,
                    child: AppText(
                      textAlign: TextAlign.center,
                      text:
                          'Une boutique est la version numérique de votre ferme physique. Elle est un endroit qui vous permet de vendre vos produits et services. Vous pouvez vendre des produits et services qui vous correspondent et qui vous permettent de gagner de l\'argent.',
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.4),
                      overflow: TextOverflow.visible,
                      fontSize: context.smallText,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: AppButton(
                    color: AppColors.primaryColor,
                    height: context.height * 0.07,
                    width: context.width * 0.9,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.CREATIONBOUTIQUEPAGE,
                      );
                    },
                    child: AppText(
                      text: 'Commencer',
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            );
          })
      : null;
}
