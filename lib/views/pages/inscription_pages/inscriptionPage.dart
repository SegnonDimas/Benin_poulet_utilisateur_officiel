import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/core/firebase/auth/auth_services.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../constants/routes.dart';
import '../../../tests/blurryContainer.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/wave_painter.dart';
import '../../models_ui/model_optionsDeConnexion.dart';
import '../userSimplePage.dart';

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
  final _formKey = GlobalKey<FormState>();

  ScrollController _scrollController = ScrollController();

  String firstName = '';
  String lastName = '';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'BJ', dialCode: "+229");
  String password = '';
  String confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    Widget divider = Divider(
      color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
    );
    return SafeArea(
      top: false,
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
                        height: context.screenHeight * 0.21,
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
                                    size:
                                        Size.square(context.screenHeight * 0.1),
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
                                filter:
                                    ImageFilter.blur(sigmaX: 340, sigmaY: 340),
                                //blur(sigmaX: 100, sigmaY: 100),
                                child: SizedBox()),
                          ],
                        ),
                      ),

                      /// Contenu avec forme sinusoïdale
                      CustomPaint(
                        painter: WavePainter(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                        child: Container(
                          height: context.screenHeight * 0.8,
                          /*padding: const EdgeInsets.only(
                              top: 20, bottom: 5, right: 0, left: 0),*/
                          padding: const EdgeInsets.all(20),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              // floutage de l'arrière-plan
                              BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 500, sigmaY: 500),
                                  //blur(sigmaX: 100, sigmaY: 100),
                                  child: SizedBox(
                                    width: context.width,
                                  )),
                              SingleChildScrollView(
                                  child: Column(
                                /*mainAxisSize: MainAxisSize.min,*/
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: context.screenHeight * 0.04),
                                  //SizedBox(height: context.height * 0.07),

                                  /// texte : Bienvenue
                                  Text(
                                    'Bienvenue !',
                                    style: TextStyle(
                                        fontSize: context.largeText * 1.5,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryColor),
                                  ),
                                  //const SizedBox(height: 15),
                                  //const SizedBox(height: 10),

                                  /// Formulaire d'inscription

                                  SizedBox(
                                    height: context.height * 0.3,
                                    child: Form(
                                      key: _formKey,
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification: (notification) {
                                          if (notification
                                              is OverscrollNotification) {
                                            // Transfère le scroll vers le parent à la fin du scroll
                                            PrimaryScrollController.of(context)
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
                                            controller: _scrollController,
                                            //thumbVisibility: true,
                                            trackVisibility: true,
                                            child: ListView(
                                              //shrinkWrap: true,
                                              controller: _scrollController,
                                              padding: EdgeInsets.only(top: 10),
                                              children: [
                                                Column(
                                                  children: [
                                                    //nom
                                                    AppTextField(
                                                        label: 'Nom',
                                                        height: context.height *
                                                            0.08,
                                                        width:
                                                            context.width * 0.9,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                        controller:
                                                            _lastNameController,
                                                        prefixIcon: CupertinoIcons
                                                            .person_alt_circle,
                                                        fontSize:
                                                            context.mediumText *
                                                                0.9,
                                                        fontColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                        onSaved: (value) =>
                                                            lastName = value!,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                              lastName = value;
                                                            })),
                                                    const SizedBox(height: 10),
                                                    //prenom
                                                    AppTextField(
                                                        label: 'Prénom',
                                                        height: context.height *
                                                            0.08,
                                                        width:
                                                            context.width * 0.9,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                        controller:
                                                            _firstNameController,
                                                        prefixIcon: CupertinoIcons
                                                            .person_alt_circle,
                                                        fontSize:
                                                            context.mediumText *
                                                                0.9,
                                                        fontColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                        onSaved: (value) =>
                                                            firstName = value!,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                              firstName = value;
                                                            })
                                                        //minLines: 4,
                                                        ),
                                                    const SizedBox(height: 10),

                                                    // Numéro de téléphone
                                                    AppPhoneTextField(
                                                      controller:
                                                          _phoneNumbercontroller,
                                                      fontSize:
                                                          context.mediumText *
                                                              0.9,
                                                      fontColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                      onFieldSubmitted: (value) =>
                                                          _phoneNumbercontroller
                                                              .text = value,
                                                      onInputChanged:
                                                          (PhoneNumber number) {
                                                        setState(() {
                                                          phoneNumber = number;
                                                        });
                                                      },
                                                    ),
                                                    const SizedBox(height: 10),

                                                    // Mot de passe
                                                    AppTextField(
                                                        label: 'Mot de passe',
                                                        height: context.height *
                                                            0.08,
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
                                                        onSaved: (value) =>
                                                            password = value!,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                              password = value;
                                                            })),
                                                    const SizedBox(height: 10),

                                                    // Confirmation de mot de passe
                                                    AppTextField(
                                                        label:
                                                            'Confirmer mot de passe',
                                                        height: context.height *
                                                            0.08,
                                                        width:
                                                            context.width * 0.9,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .background,
                                                        isPassword: true,
                                                        controller:
                                                            _confirmPassWordController,
                                                        fontSize:
                                                            context.mediumText *
                                                                0.9,
                                                        fontColor:
                                                            Theme.of(context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                        onSaved: (value) =>
                                                            confirmPassword =
                                                                value!,
                                                        onChanged: (value) =>
                                                            setState(() {
                                                              confirmPassword =
                                                                  value;
                                                            })),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: context.height * 0.03),

                                  // bouton de l'inscription
                                  Center(
                                    child: AppButton(
                                        height: context.height * 0.07,
                                        width: context.width * 0.9,
                                        color: AppColors.primaryColor,
                                        onTap: () async {
                                          try {
                                            var dialCode = phoneNumber.dialCode
                                                ?.replaceAll('+', '00');
                                            var isCode = phoneNumber.isoCode
                                                    ?.toLowerCase() ??
                                                '';
                                            var prefix = dialCode! + isCode;
                                            var number = phoneNumber
                                                .phoneNumber!
                                                .toString()
                                                .trim()
                                                .replaceAll(
                                                    phoneNumber.dialCode
                                                        .toString(),
                                                    '');
                                            //var number = phoneNumber.nationalNumber;
                                            final _telEmail =
                                                '${prefix + number}@gmail.com';

                                            //

                                            if (_formKey.currentState!
                                                .validate()) {
                                              _formKey.currentState!.save();
                                              //_formKey.currentState!.reset();
                                              setState(() {
                                                isSignUp = !isSignUp;
                                              });
                                              context.read<AuthBloc>().add(
                                                    PhoneSignUpRequested(
                                                      firstName: firstName,
                                                      lastName: lastName,
                                                      phoneNumber: phoneNumber,
                                                      password: password,
                                                      confirmPassword:
                                                          confirmPassword,
                                                    ),
                                                  );
                                              AppUtils.showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                title:
                                                    '${phoneNumber.phoneNumber}',
                                                cancelText: 'Oui, continuer',
                                                confirmText:
                                                    'Non, mettre à jour',
                                                content:
                                                    'Votre numéro est-il correct ?',
                                                cancelTextSize:
                                                    context.smallText * 0.8,
                                                confirmTextSize:
                                                    context.smallText,
                                                cancelTextColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .inversePrimary
                                                        .withOpacity(0.4),
                                                titleColor:
                                                    AppColors.primaryColor,

                                                // annulation pour correction du numéro
                                                onConfirm: () async {
                                                  Navigator.pop(context);
                                                },

                                                //Confirmation du numéro de téléphone et inscription
                                                onCancel: () async {
                                                  Navigator.pop(context);
                                                  await signUp(
                                                      _telEmail, password);
                                                },
                                              );
                                              /* FirebaseAuth.instance
                                                  .signInWithPhoneNumber(
                                                      _phoneNumbercontroller
                                                          .text);*/
                                              print(
                                                  ':::::: Je suis venu ici ::::::::');
                                            }
                                          } catch (e) {
                                            AppUtils.showSnackBar(context,
                                                "Veuillez vérifier que vous avez rempli tous les champs ; ou vérifier votre connexion internet",
                                                backgroundColor:
                                                    AppColors.redColor,
                                                messageColor: Colors.white,
                                                closeIconColor: Colors.white);
                                            if (kDebugMode) {
                                              print(
                                                  "::::::::::::::EREURE : $e ::::::::::::::");
                                            }
                                          }
                                        },
                                        child: isSignUp
                                            ? const CupertinoActivityIndicator(
                                                radius:
                                                    20.0, // Taille du spinner
                                                color: Colors.white,
                                              )
                                            : AppText(
                                                text: 'Inscription',
                                                fontSize: context.largeText,
                                                color: Colors.white,
                                              )),
                                  ),

                                  const SizedBox(height: 20),

                                  /// Fin du formulaire d'inscription

                                  /// Autres options d'inscription
                                  SizedBox(
                                    //height: context.height * 0.17,
                                    child: Column(
                                      children: [
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
                                                //width: context.screenWidth * 0.15,
                                                child: divider,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(
                                          height: 20,
                                        ),

                                        // méthodes d'inscription Google, Apple et Email
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            //Google
                                            Hero(
                                              tag: 'appleTag',
                                              child: ModelOptionDeConnexion(
                                                onTap: () {
                                                  setState(() {
                                                    isSignUp = !isSignUp;
                                                  });
                                                },
                                                child: Image.asset(
                                                  'assets/logos/google.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),

                                            //Apple
                                            Hero(
                                              tag: 'googleTag',
                                              child: ModelOptionDeConnexion(
                                                onTap: () {
                                                  /*setState(() {
                                                    isSignUp = !isSignUp;
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

                                            //Email
                                            Hero(
                                              tag: 'emailTag',
                                              child: ModelOptionDeConnexion(
                                                onTap: () {
                                                  setState(() {
                                                    isSignUp = !isSignUp;
                                                  });
                                                  Navigator.pushNamed(
                                                      context,
                                                      AppRoutes
                                                          .SIGNUPWITHEMAILPAGE);
                                                },
                                                child: Image.asset(
                                                  'assets/logos/email2.png',
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),

                                        // texte : 'Avez-vous déjà de compte ? Se connecter'
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
                                              fontSize: context.smallText * 1.2,
                                            ),

                                            // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                                            TextButton(
                                                onPressed: () {
                                                  Navigator
                                                      .pushReplacementNamed(
                                                          context,
                                                          AppRoutes.LOGINPAGE);
                                                },
                                                child: AppText(
                                                  text: 'Se connecter',
                                                  color: AppColors.primaryColor,
                                                  fontSize:
                                                      context.smallText * 1.2,
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
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
      ),
    );
  }

  /// signUp()
  Future<void> signUp(String _telEmail, String _password) async {
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
      try {
        // fonction pour l'inscription
        //AthentificationServices.signup();
        await AuthServices.createEmailAuth(_telEmail, _password);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const UserSimplePage()));
        // snack bar
        _showAwesomeSnackBar(
            context,
            'Inscription Réussie',
            'Votre inscription est effectuée avec succès',
            ContentType.success,
            AppColors.primaryColor);
      } catch (e) {
        print("::::::::::::ERREUR : $e::::::::::::::");
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
