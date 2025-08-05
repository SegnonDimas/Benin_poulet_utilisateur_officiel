import 'dart:ui';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:benin_poulet/bloc/auth/auth_bloc.dart';
import 'package:benin_poulet/bloc/userRole/user_role_bloc.dart';
import 'package:benin_poulet/constants/app_attributs.dart';
import 'package:benin_poulet/constants/userRoles.dart';
import 'package:benin_poulet/core/firebase/firestore/error_report_repository.dart';
import 'package:benin_poulet/models/error_report.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../constants/routes.dart';
import '../../../core/firebase/auth/auth_services.dart';
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
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _passWordController = TextEditingController();
  TextEditingController _confirmPassWordController = TextEditingController();
  TextEditingController _phoneNumbercontroller = TextEditingController();
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

  /// signUp()
  Future<void> signUp(String email, String password) async {
    try {
      context.read<AuthBloc>().add(
            PhoneSignUpRequested(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phoneNumber: phoneNumber, // déjà formaté
              password: password,
              confirmPassword: _confirmPassWordController.text.trim(),
            ),
          );
    } catch (e) {
      if (kDebugMode) {
        print("::::::::::::Erreur durant l'inscription : $e :::::::::::::::");
      }
    }
  }

  Future<Map> getDeviceInfos() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    return allInfo;
  }

  var deviceInfos = {};

  bool _isMounted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _isMounted = true;

    getDeviceInfos();

    _passWordController = TextEditingController(text: '12345678');
    _confirmPassWordController = TextEditingController(text: '12345678');
    _firstNameController = TextEditingController(text: 'John');
    _lastNameController = TextEditingController(text: 'Doe');
    _phoneNumbercontroller = TextEditingController(text: '0100000000');
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
          },
          listener: (context, userRoleState) {
            // TODO: au cas où...
            print(
                '::::::::::::::::::::::::::${userRoleState.role}!!!!!!!!!!!!');
          },
          builder: (context, userRoleState) {
            return BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) {
                // Ne réagir que si la page est dans l'arborescence de navigation
                return _isMounted;
              },
              listener: (context, authState) async {
                if (authState is AuthFailure) {
                  if (authState.errorMessage.toLowerCase().contains('bénin') ||
                      authState.errorMessage.contains('01')) {
                    AppUtils.showInfoDialog(
                        context: context,
                        message: authState.errorMessage,
                        type: InfoType.error,
                        onTitleIconTap: () => Navigator.pop(context));
                  } else {
                    AppUtils.showSnackBar(context, authState.errorMessage);
                  }
                } else if (authState is AuthLoading) {
                  //
                  /*AppUtils.showInfoDialog(
                      context: context,
                      message: "Veuillez patienter...",
                      type: InfoType.loading);*/
                } else if (authState is PhoneSignUpRequestSuccess) {
                  try {
                    //final _email = _formatEmailFromPhone(phoneNumber);
                    final _password = _passWordController.text;
                    final fullName =
                        '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
                    /*await AuthServices.createEmailAuth(_email, _password,
                    authProvider: AuthProviders.PHONE);*/
                    await AuthServices.createPhoneAuth(phoneNumber, _password,
                        fullName: fullName,
                        password: _passWordController.text,
                        role: userRoleState.role!);
                    //Navigator.pop(context);
                    /*_showAwesomeSnackBar(
                      context,
                      'Inscription Réussie',
                      'Votre inscription est effectuée avec succès',
                      ContentType.success,
                      AppColors.primaryColor,
                    );*/

                    if (userRoleState.role ==
                            UserRoles
                                .SELLER /*&&
                        authState is! AuthLoading*/
                        ) {
                      // proposition de crétation de boutique
                      context.mounted ? _showBottomSheet(context) : null;
                    } else if (userRoleState.role ==
                            UserRoles
                                .BUYER /*&&
                        authState is! AuthLoading*/
                        ) {
                      // rediredction vers la page de destination
                      context.mounted
                          ? Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.CLIENTHOMEPAGE,
                              (Route<dynamic> route) => false)
                          : null;
                    }

                    // Navigator.pushNamed(context, AppRoutes.CLIENTHOMEPAGE);

                    // Réinitialiser les champs
                    /* _passWordController.clear();
                    _phoneNumbercontroller.clear();
                    _confirmPassWordController.clear();
                    _firstNameController.clear();
                    _lastNameController.clear();*/
                  } catch (e) {
                    ErrorReport errorReport = ErrorReport(
                      errorMessage: e.toString(),
                      date: DateTime.now(),
                    );
                    if (context.mounted) {
                      if (e.toString().contains('already')) {
                        AppUtils.showSnackBar(
                          context,
                          "Ce numéro de téléphone est deja associé a un compte",
                          backgroundColor: AppColors.redColor,
                        );
                      }
                      await AppUtils.showDialog(
                        context: context,
                        barrierDismissible: false,
                        title: 'Rapport d\'erreur',
                        content: "e.toString()",
                        cancelText: 'Fermer',
                        confirmText: 'Envoyer le rapport',
                        cancelTextColor: AppColors.primaryColor,
                        confirmTextColor: AppColors.redColor,
                        onConfirm: () async {
                          await FirebaseErrorReportRepository()
                              .sendErrorReport(errorReport);
                        },
                      );
                    }
                    if (kDebugMode) {
                      print(
                          ":::::::::::ERREUR LORS DE L'INSCRIPTION : $e::::::::::");
                    }
                  }
                } else if (authState is GoogleLoginRequestSuccess) {
                  try {
                    await AuthServices.signInWithGoogle(
                      role: userRoleState.role!,
                    );
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
                    ErrorReport errorReport = ErrorReport(
                      errorMessage: e.toString(),
                      date: DateTime.now(),
                    );
                    if (context.mounted) {
                      if (e.toString().contains('already')) {
                        AppUtils.showSnackBar(
                          context,
                          "Cette adresse est deja associée a un compte",
                          backgroundColor: AppColors.redColor,
                        );
                      }
                      await AppUtils.showDialog(
                        context: context,
                        barrierDismissible: false,
                        title: 'Rapport d\'erreur',
                        content: e.toString(),
                        cancelText: 'Fermer',
                        confirmText: 'Envoyer le rapport',
                        cancelTextColor: AppColors.primaryColor,
                        confirmTextColor: AppColors.redColor,
                        onConfirm: () async {
                          await FirebaseErrorReportRepository()
                              .sendErrorReport(errorReport);
                          Navigator.pop(context);
                        },
                      );
                    }
                    if (kDebugMode) {
                      print(
                          ":::::::::::ERREUR LORS DE L'INSCRIPTION : $e::::::::::");
                    }
                  }
                } else {
                  if (kDebugMode) {
                    print("::::::::::::: STATE : $authState ::::::::::::");
                    print("::::::::::VEILLEZ PATIENTER::::::::::");
                  }
                }
                if (kDebugMode) {
                  print("::::::::::::: STATE : $authState ::::::::::::");
                  print("::::::::::::: LISTINER END ::::::::::::");
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

                                  //
                                  SingleChildScrollView(
                                      child: Column(
                                    /*mainAxisSize: MainAxisSize.min,*/
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: context.screenHeight * 0.04),
                                      //SizedBox(height: context.height * 0.07),

                                      /// texte : Bienvenue
                                      Text(
                                        'Bienvenue !',
                                        style: TextStyle(
                                            fontSize: context.largeText * 1.5,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primaryColor),
                                      ),

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
                                                PrimaryScrollController.of(
                                                        context)
                                                    .jumpTo(
                                                  PrimaryScrollController.of(
                                                              context)
                                                          .offset +
                                                      notification.overscroll /
                                                          2,
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
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  children: [
                                                    Column(
                                                      children: [
                                                        //nom
                                                        AppTextField(
                                                          label: 'Nom',
                                                          height:
                                                              context.height *
                                                                  0.08,
                                                          width: context.width *
                                                              0.9,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          controller:
                                                              _lastNameController,
                                                          validator: (value) =>
                                                              value == null ||
                                                                      value
                                                                          .trim()
                                                                          .isEmpty
                                                                  ? 'Veuillez entrer votre nom'
                                                                  : null,
                                                          prefixIcon: CupertinoIcons
                                                              .person_alt_circle,
                                                          fontSize: context
                                                                  .mediumText *
                                                              0.9,
                                                          fontColor: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                          onSaved: (value) =>
                                                              lastName = value!,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                            lastName = value;
                                                          }),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                        ),
                                                        const SizedBox(
                                                            height: 10),
                                                        //prenom
                                                        AppTextField(
                                                          label: 'Prénom',
                                                          height:
                                                              context.height *
                                                                  0.08,
                                                          width: context.width *
                                                              0.9,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .background,
                                                          controller:
                                                              _firstNameController,
                                                          validator: (value) =>
                                                              value == null ||
                                                                      value
                                                                          .trim()
                                                                          .isEmpty
                                                                  ? 'Veuillez entrer votre prénom'
                                                                  : null,
                                                          prefixIcon: CupertinoIcons
                                                              .person_alt_circle,
                                                          fontSize: context
                                                                  .mediumText *
                                                              0.9,
                                                          fontColor: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                          onSaved: (value) =>
                                                              firstName =
                                                                  value!,
                                                          onChanged: (value) =>
                                                              setState(() {
                                                            firstName = value;
                                                          }),
                                                          textInputAction:
                                                              TextInputAction
                                                                  .next,
                                                          //minLines: 4,
                                                        ),
                                                        const SizedBox(
                                                            height: 10),

                                                        // Numéro de téléphone
                                                        AppPhoneTextField(
                                                          controller:
                                                              _phoneNumbercontroller,
                                                          fontSize: context
                                                                  .mediumText *
                                                              0.9,
                                                          fontColor: Theme.of(
                                                                  context)
                                                              .colorScheme
                                                              .inversePrimary,
                                                          onFieldSubmitted:
                                                              (value) =>
                                                                  _phoneNumbercontroller
                                                                          .text =
                                                                      value,
                                                          onInputChanged:
                                                              (PhoneNumber
                                                                  number) {
                                                            setState(() {
                                                              phoneNumber =
                                                                  number;
                                                            });
                                                          },
                                                          validator: (value) =>
                                                              value == null ||
                                                                      value
                                                                          .trim()
                                                                          .isEmpty
                                                                  ? 'Veuillez reseigner votre numéro de téléphone'
                                                                  : null,
                                                        ),
                                                        const SizedBox(
                                                            height: 10),

                                                        // Mot de passe
                                                        AppTextField(
                                                            label:
                                                                'Mot de passe',
                                                            height: context
                                                                    .height *
                                                                0.08,
                                                            width: context
                                                                    .width *
                                                                0.9,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .background,
                                                            isPassword: true,
                                                            controller:
                                                                _passWordController,
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Mot de passe requis';
                                                              }
                                                              if (value.length <
                                                                  6) {
                                                                return 'Au moins 6 caractères';
                                                              }
                                                              return null;
                                                            },
                                                            fontSize: context
                                                                    .mediumText *
                                                                0.9,
                                                            fontColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                            onSaved: (value) =>
                                                                password =
                                                                    value!,
                                                            onChanged:
                                                                (value) =>
                                                                    setState(
                                                                        () {
                                                                      password =
                                                                          value;
                                                                    })),
                                                        const SizedBox(
                                                            height: 10),

                                                        // Confirmation de mot de passe
                                                        AppTextField(
                                                            label:
                                                                'Confirmer mot de passe',
                                                            height: context
                                                                    .height *
                                                                0.08,
                                                            width: context
                                                                    .width *
                                                                0.9,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .background,
                                                            isPassword: true,
                                                            controller:
                                                                _confirmPassWordController,
                                                            validator: (value) {
                                                              if (value !=
                                                                  _passWordController
                                                                      .text) {
                                                                return 'Les mots de passe ne correspondent pas';
                                                              }
                                                              return null;
                                                            },
                                                            fontSize: context
                                                                    .mediumText *
                                                                0.9,
                                                            fontColor: Theme
                                                                    .of(context)
                                                                .colorScheme
                                                                .inversePrimary,
                                                            onSaved: (value) =>
                                                                confirmPassword =
                                                                    value!,
                                                            onChanged:
                                                                (value) =>
                                                                    setState(
                                                                        () {
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
                                            onTap: () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final formattedEmail =
                                                    _formatEmailFromPhone(
                                                        phoneNumber);

                                                // Afficher le dialogue de confirmation du numéro
                                                AppUtils.showDialog(
                                                  context: context,
                                                  title:
                                                      phoneNumber.phoneNumber ??
                                                          '',
                                                  content:
                                                      'Votre numéro est-il correct ?',
                                                  barrierDismissible: false,
                                                  cancelText: 'Oui, continuer',
                                                  confirmText:
                                                      'Non, mettre à jour',
                                                  //
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

                                                  //
                                                  onConfirm: () {
                                                    print(":::::::::::Cancel");
                                                    Navigator.pop(context);
                                                  }, // Modifier le numéro
                                                  onCancel: () async {
                                                    print(
                                                        ":::::::::::Confirm init");
                                                    // Confirmer et lancer inscription

                                                    Navigator.pop(context);
                                                    print(
                                                        ":::::::::::Confirm pop");
                                                    await signUp(
                                                        formattedEmail,
                                                        _passWordController
                                                            .text);

                                                    print(
                                                        "=========STATE : ${authState.runtimeType} ==========");
                                                    //print("=========STATE : ${authState} ==========");
                                                    print(
                                                        ":::::::::::Confirm completed");

                                                    if (authState
                                                            is AuthAuthenticated ||
                                                        authState
                                                            is PhoneSignUpRequestSuccess) {
                                                      print(
                                                          ":::::::::::ICI 1-3");
                                                      try {
                                                        final _email =
                                                            _formatEmailFromPhone(
                                                                phoneNumber);
                                                        final fullName =
                                                            '${_firstNameController.text.trim()} ${_lastNameController.text.trim()}';
                                                        final _password =
                                                            _passWordController
                                                                .text
                                                                .trim();
                                                        await AuthServices
                                                            .createPhoneAuth(
                                                                phoneNumber,
                                                                _password,
                                                                fullName:
                                                                    fullName,
                                                                password:
                                                                    _passWordController
                                                                        .text,
                                                                role:
                                                                    userRoleState
                                                                        .role!);

                                                        //
                                                        context.read<AuthBloc>().add(
                                                            PhoneSignUpRequested(
                                                                firstName:
                                                                    firstName,
                                                                lastName:
                                                                    lastName,
                                                                phoneNumber:
                                                                    phoneNumber,
                                                                password:
                                                                    password,
                                                                confirmPassword:
                                                                    confirmPassword));
                                                        // Réinitialiser les champs
                                                        _passWordController
                                                            .clear();
                                                        _phoneNumbercontroller
                                                            .clear();
                                                        _confirmPassWordController
                                                            .clear();
                                                        _firstNameController
                                                            .clear();
                                                        _lastNameController
                                                            .clear();
                                                      } catch (e) {
                                                        print(
                                                            ":::::::::::ERREUR LORS DE L'INSCRIPTION : $e::::::::::");
                                                      }
                                                    }
                                                  },
                                                );
                                              } else {
                                                AppUtils.showSnackBar(context,
                                                    "Veuillez remplir tous les champs");
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
                                                      text: "ou continuer avec",
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

                                            // méthodes d'inscription Google, Apple et Email
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
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
                                                  fontSize:
                                                      context.smallText * 1.2,
                                                ),

                                                // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator
                                                          .pushReplacementNamed(
                                                              context,
                                                              AppRoutes
                                                                  .LOGINPAGE);
                                                    },
                                                    child: AppText(
                                                      text: 'Se connecter',
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
            );
          },
        ),
      ),
    );
  }

  String _formatEmailFromPhone(PhoneNumber phone) {
    var dialCode = phone.dialCode?.replaceAll('+', '00') ?? '';
    var isoCode = phone.isoCode?.toLowerCase() ?? '';
    var prefix = dialCode + isoCode;
    var number = phone.phoneNumber
            ?.replaceAll(phone.dialCode ?? '', '')
            .replaceAll(' ', '') ??
        '';
    return '$prefix$number@gmail.com';
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
                      top: 4.0, bottom: 8.0, left: 4.0, right: 4.0),
                  child: SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
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
                          height: 200,
                          width: context.width,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35),
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                            //color: Colors.black87,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.9),
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
                                    .withOpacity(0.7),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                                Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.4),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.transparent,
                              ],
                            ),
                            /* color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.7),*/
                          ),
                        ),
                        BlurryContainer(
                            height: 200,
                            width: context.width,
                            blur: 3,
                            child: SizedBox()),
                        Positioned(
                          top: 4,
                          right: 4,
                          left: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 60,
                                ),
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
                        AppRoutes.INSCRIPTIONVENDEURPAGE,
                      );
                    },
                    child: AppText(
                      text: 'Commencer',
                      //fontWeight: FontWeight.w900,
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
