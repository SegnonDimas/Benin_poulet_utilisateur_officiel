import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
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
  PhoneNumber number = PhoneNumber(
    isoCode: 'BJ',
  );
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView(
        children: [
          // Image d'arrière-plan
          Image.asset(
            'assets/icons/signup.png',
            fit: BoxFit.fitHeight,
            height: appHeightSize(context) * 0.15,
            width: appWidthSize(context) * 0.5,
            color: primaryColor,
          ),
          // Contenu avec forme sinusoïdale
          CustomPaint(
            painter: WavePainter(),
            child: Container(
              height: appHeightSize(context) * 0.85,
              padding: const EdgeInsets.all(20),
              child: Column(
                /*mainAxisSize: MainAxisSize.min,*/
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: appHeightSize(context) * 0.07),
                  ShaderMask(
                    blendMode: BlendMode
                        .srcATop, // Choisissez le mode de fusion selon vos préférences
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.inversePrimary,
                          Theme.of(context).colorScheme.inversePrimary,
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

                  // Nom et Prenom
                  SizedBox(
                    width: appWidthSize(context) * 0.9,
                    height: appHeightSize(context) * 0.08,
                    child: ListView(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      scrollDirection: Axis.horizontal,
                      children: [
                        AppTextField(
                          label: 'Nom',
                          height: appHeightSize(context) * 0.07,
                          width: appWidthSize(context) * 0.42,
                          prefixIcon: Icons.account_circle,
                          color: Colors.grey.shade300,
                          controller: _firstNameController,
                        ),
                        SizedBox(width: appWidthSize(context) * 0.06),
                        AppTextField(
                          label: 'Prénom',
                          height: appHeightSize(context) * 0.07,
                          width: appWidthSize(context) * 0.42,
                          prefixIcon: Icons.account_circle,
                          color: Colors.grey.shade300,
                          controller: _lastNameController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Numéro de téléphone
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.08,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey.shade300,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InternationalPhoneNumberInput(
                        onInputChanged: (PhoneNumber number) {
                          // le numéro de téléphone saisi.
                          print(number.phoneNumber);
                        },
                        onInputValidated: (bool value) {
                          // true, si le numéro saisi est correct; false sinon.
                          print('Valeur : $value');
                        },
                        hintText: 'Numéro de téléphone',
                        errorMessage: 'Numéro non valide',
                        locale: 'NG',
                        selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.DIALOG,
                            useBottomSheetSafeArea: true,
                            setSelectorButtonAsPrefixIcon: true,
                            leadingPadding: 10),
                        ignoreBlank: false,
                        autoValidateMode: AutovalidateMode.disabled,
                        selectorTextStyle: TextStyle(color: Colors.grey),
                        textStyle: TextStyle(color: Colors.black),
                        initialValue: number,
                        textFieldController: _phoneNumbercontroller,
                        formatInput: true,
                        autoFocus: false,
                        autoFocusSearch: true,
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: true, decimal: true),
                        inputBorder: const OutlineInputBorder(),
                        inputDecoration: InputDecoration(
                          border: InputBorder.none,
                          label: AppText(
                            text: 'Numéro de téléphone',
                            color: Colors.grey,
                          ),
                        ),
                        onSaved: (PhoneNumber number) {
                          print('On Saved: $number');
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Mot de passe
                  AppTextField(
                    label: 'Mot de passe',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Colors.grey.shade300,
                    isPassword: true,
                    controller: _passWordController,
                  ),
                  const SizedBox(height: 20),

                  // Confirmation de mot de passe
                  AppTextField(
                    label: 'Confirmer mot de passe',
                    height: appHeightSize(context) * 0.08,
                    width: appWidthSize(context) * 0.9,
                    color: Colors.grey.shade300,
                    isPassword: true,
                    controller: _confirmPassWordController,
                  ),

                  SizedBox(height: appHeightSize(context) * 0.03),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isLoggedIn = !isLoggedIn;
                      });
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: appHeightSize(context) * 0.07,
                        width: appWidthSize(context) * 0.9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: primaryColor),
                        child: isLoggedIn
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
                  const SizedBox(height: 10),
                  Divider(
                    color: Colors.grey.shade400,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoggedIn = !isLoggedIn;
                          });
                        },
                        child: Container(
                            height: appHeightSize(context) * 0.06,
                            width: appHeightSize(context) * 0.07,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/logos/google.png',
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                      SizedBox(
                        width: appWidthSize(context) * 0.15,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLoggedIn = !isLoggedIn;
                          });
                        },
                        child: Container(
                            height: appHeightSize(context) * 0.06,
                            width: appHeightSize(context) * 0.07,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                'assets/logos/apple.png',
                                fit: BoxFit.contain,
                              ),
                            )),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText(
                        text: 'Avez-vous déjà de compte ?',
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      // le clic devrait conduire sur la page de choix de profil (vendeur / acheteur)
                      TextButton(
                          onPressed: () {
                            _showSnackBar('message');

                            //Navigator.pushNamed(context, '/presentationPage');
                          },
                          child: AppText(
                              text: 'Se connecter', color: primaryColor)),
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
