import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/services/authentification_services.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/userSimplePage.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../constants/routes.dart';
import '../../../tests/blurryContainer.dart';
import '../../../utils/app_utils.dart';
import '../../../utils/wave_painter.dart';
import '../../models_ui/model_optionsDeConnexion.dart';

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
  String phoneNumber = '';
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
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// Image d'arrière-plan
              SizedBox(
                height: context.height * 0.2,
                width: context.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 20,
                      left: 5,
                      child: Hero(
                        tag: '1',
                        child: GradientBall(
                            size: Size.square(context.height * 0.09),
                            colors: const [
                              //blueColor,
                              Colors.deepPurple,
                              Colors.purpleAccent
                            ]),
                      ),
                    ),
                    Positioned(
                      bottom: 0, //context.height * 0.8,
                      right: 10,
                      child: Hero(
                        tag: '2',
                        child: GradientBall(
                            size: Size.square(context.height * 0.06),
                            colors: const [Colors.orange, Colors.yellow]),
                      ),
                    ),

                    // Image d'arrière-plan

                    Positioned(
                      top: context.height * 0.045,
                      child: Image.asset(
                        //'assets/icons/signup.png',
                        "assets/images/login2.png",
                        fit: BoxFit.fitHeight,
                        height: context.height * 0.17,
                        width: context.width * 0.5,
                        //color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              /// Contenu avec forme sinusoïdale
              SizedBox(
                //height: context.height * 0.8,
                child: CustomPaint(
                  painter: WavePainter(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Container(
                    //height: context.height,
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 5, right: 10, left: 10),
                    child: SingleChildScrollView(
                      child: Column(
                        /*mainAxisSize: MainAxisSize.min,*/
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: context.height * 0.07),

                          // texte : 'Bienvenue !'
                          ShaderMask(
                            blendMode: BlendMode.srcATop,
                            shaderCallback: (Rect bounds) {
                              return LinearGradient(
                                colors: [
                                  /*Theme.of(context).colorScheme.inversePrimary,
                                  Theme.of(context).colorScheme.inversePrimary,*/
                                  AppColors.primaryColor,
                                  AppColors.primaryColor,
                                  AppColors.primaryColor,
                                ], // Couleurs de votre dégradé
                                tileMode: TileMode.clamp,
                              ).createShader(bounds);
                            },
                            child: Text(
                              'Bienvenue !',
                              style: TextStyle(
                                  fontSize: context.largeText * 1.5,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryColor),
                            ),
                          ),
                          //const SizedBox(height: 10),

                          /// Formulaire d'inscription

                          SizedBox(
                            height: context.height * 0.35,
                            child: Form(
                              key: _formKey,
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification is OverscrollNotification) {
                                    // Transfère le scroll vers le parent à la fin du scroll
                                    PrimaryScrollController.of(context).jumpTo(
                                      PrimaryScrollController.of(context)
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
                                            AppTextField(
                                              label: 'Nom',
                                              height: context.height * 0.08,
                                              width: context.width * 0.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              controller: _lastNameController,
                                              prefixIcon: CupertinoIcons
                                                  .person_alt_circle,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              onSaved: (value) =>
                                                  lastName = value!,
                                            ),
                                            const SizedBox(height: 10),
                                            //prenom
                                            AppTextField(
                                              label: 'Prénom',
                                              height: context.height * 0.08,
                                              width: context.width * 0.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              controller: _firstNameController,
                                              prefixIcon: CupertinoIcons
                                                  .person_alt_circle,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              onSaved: (value) =>
                                                  firstName = value!,
                                              //minLines: 4,
                                            ),
                                            const SizedBox(height: 10),

                                            // Numéro de téléphone
                                            AppPhoneTextField(
                                              controller:
                                                  _phoneNumbercontroller,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              onFieldSubmitted: (value) =>
                                                  phoneNumber = value,
                                            ),
                                            const SizedBox(height: 10),

                                            // Mot de passe
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
                                              onSaved: (value) =>
                                                  password = value!,
                                            ),
                                            const SizedBox(height: 10),

                                            // Confirmation de mot de passe
                                            AppTextField(
                                              label: 'Confirmer mot de passe',
                                              height: context.height * 0.08,
                                              width: context.width * 0.9,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .background,
                                              isPassword: true,
                                              controller:
                                                  _confirmPassWordController,
                                              fontSize:
                                                  context.mediumText * 0.9,
                                              fontColor: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                              onSaved: (value) =>
                                                  confirmPassword = value!,
                                            ),
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
                                onTap: () {
                                  signUp();
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      isSignUp = !isSignUp;
                                    });
                                    context.read<AuthBloc>().add(
                                          PhoneSignUpRequested(
                                            firstName: firstName,
                                            lastName: lastName,
                                            phoneNumber: phoneNumber,
                                            password: password,
                                            confirmPassword: confirmPassword,
                                          ),
                                        );
                                    print(':::::: Je suis venu ici ::::::::');

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UserSimplePage()));
                                  }
                                },
                                child: isSignUp
                                    ? const CupertinoActivityIndicator(
                                        radius: 20.0, // Taille du spinner
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
                                          Navigator.pushNamed(context,
                                              AppRoutes.SIGNUPWITHEMAILPAGE);
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                                          Navigator.pushReplacementNamed(
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
                        ],
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
          AppColors.primaryColor);
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
