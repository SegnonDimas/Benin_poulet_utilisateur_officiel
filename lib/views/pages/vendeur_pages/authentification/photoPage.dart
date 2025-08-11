import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../models_ui/model_photoSelecteur.dart';

class PhotoPage extends StatefulWidget {
  @override
  PhotoPageState createState() {
    return PhotoPageState();
  }
}

class PhotoPageState extends State<PhotoPage> {
  String _sellerType = 'Particulier';
  String _mobileMoney = '';
  bool isMtn = false;
  bool isMoov = false;
  bool isCeltiis = false;

  final List<String> _titrePiece = [
    'Le recto de votre pièce',
    'Le verso de votre pièce',
    'Selfie'
  ];

  final List<String> _descriptionPiece = [
    'charger la photo',
    'charger la photo',
    'prendre une photo'
  ];

  final List<String> _trailing = ['prendre une photo', 'prendre une photo', ''];

  // La variable qui stocke le pays sélectionné
  /*String? _selectedCountry = 'Bénin';
  final _paymentNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumbercontroller = TextEditingController();*/
  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // sélection pays
            // texte
            AppText(
              text: 'Prendre en photo votre pièce',
              fontSize: smallText() * 1.1,
            ),
            const SizedBox(
              height: 10,
            ),

            // liste des pièces
            SizedBox(
              //height: appHeightSize(context) * 0.05,
              //width: appWidthSize(context) * 0.8,
              child: Column(
                children: List.generate(_titrePiece.length - 1, (index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: appHeightSize(context) * 0.02),
                    child: ModelPhotoSelecteur(
                      title: _titrePiece[index],
                      description: _descriptionPiece[index],
                      trailing: _trailing[index],
                    ),
                  );
                }),
              ),
            ),
            // espace
            const SizedBox(
              height: 20,
            ),

            // texte
            AppText(
              text: 'Prendre une photo de vous avec votre pièce',
              fontSize: smallText() * 1.1,
            ),
            // espace
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              //height: appHeightSize(context) * 0.05,
              //width: appWidthSize(context) * 0.8,
              child: Column(
                children: List.generate(1, (index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: appHeightSize(context) * 0.02),
                    child: ModelPhotoSelecteur(
                      title: _titrePiece[2],
                      description: _descriptionPiece[2],
                      trailing: _trailing[2],
                    ),
                  );
                }),
              ),
            ),

            // Espace pour compenser l'espace occupé par le bouton "Suivant" dans la page CreationBoutiquePage
            SizedBox(
              height: context.height * 0.07,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
