import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../widgets/app_text.dart';
import '../../../widgets/app_textField.dart';
import '../../colors/app_colors.dart';
import '../../sizes/app_sizes.dart';

class FiscalitePage extends StatefulWidget {
  @override
  FiscalitePageState createState() {
    return FiscalitePageState();
  }
}

class FiscalitePageState extends State<FiscalitePage> {
  String _sellerType = 'Particulier';
  String _mobileMoney = '';
  bool isMtn = false;
  bool isMoov = false;
  bool isCeltiis = false;
  final _paymentNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumbercontroller = TextEditingController();
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
            AppText(
              text: 'Sur le plan fiscal, quel type de vendeur êtes-vous ?',
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.visible,
            ),

            //Particulier
            ListTile(
              title: AppText(
                text: 'Particulier',
                fontSize: smallText() * 1.3,
                fontWeight: _sellerType == 'Particulier'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: _sellerType == 'Particulier'
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.3),
              ),
              leading: Radio<String>(
                value: 'Particulier',
                groupValue: _sellerType,
                activeColor: primaryColor,
                focusColor: Colors.grey,
                hoverColor: Colors.grey,
                onChanged: (String? value) {
                  setState(() {
                    _sellerType = value!;
                  });
                },
              ),
              horizontalTitleGap: 0,
            ),

            // Entreprise ou Société individuelle
            ListTile(
              title: AppText(
                text: 'Entreprise ou Société individuelle',
                fontSize: smallText() * 1.3,
                overflow: TextOverflow.visible,
                fontWeight: _sellerType == 'Entreprise ou Société individuelle'
                    ? FontWeight.bold
                    : FontWeight.normal,
                color: _sellerType == 'Entreprise ou Société individuelle'
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context)
                        .colorScheme
                        .inverseSurface
                        .withOpacity(0.3),
              ),
              leading: Radio<String>(
                value: 'Entreprise ou Société individuelle',
                groupValue: _sellerType,
                activeColor: primaryColor,
                focusColor: Colors.grey,
                hoverColor: Colors.grey,
                onChanged: (String? value) {
                  setState(() {
                    _sellerType = value!;
                  });
                },
              ),
              horizontalTitleGap: 0,
            ),
            //SizedBox(height: 20),
            Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),

            // Mobile money
            AppText(
              text: 'Mobile Money',
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(
              height: 10,
            ),

            SizedBox(
              height: appHeightSize(context) * 0.1,
              width: appWidthSize(context),
              child: ListView(
                scrollDirection: Axis.horizontal,
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Celtiis
                  ChoiceChip(
                    label: AppText(
                      text: 'Celtiis',
                      color: isCeltiis
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withAlpha(50),
                    ),
                    pressElevation: 20,
                    side: BorderSide.none,
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 7, right: 7),
                    selected: _mobileMoney == 'Celtiis',
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shadowColor: Theme.of(context).colorScheme.inversePrimary,
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    tooltip: 'Recevoir de l\'argent par Celtiis Money',
                    onSelected: (bool selected) {
                      setState(() {
                        isCeltiis = selected;
                        isMoov = false;
                        isMtn = false;
                        _mobileMoney = selected ? 'Celtiis' : '';
                      });
                    },
                  ),

                  // MTN
                  Padding(
                    padding: EdgeInsets.only(
                        left: appWidthSize(context) * 0.05,
                        right: appWidthSize(context) * 0.05),
                    child: ChoiceChip(
                      label: AppText(
                        text: 'MTN',
                        color: isMtn
                            ? Colors.white
                            : Theme.of(context)
                                .colorScheme
                                .inverseSurface
                                .withAlpha(50),
                      ),
                      pressElevation: 20,
                      side: BorderSide.none,
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 20, left: 7, right: 7),
                      selected: _mobileMoney == 'MTN',
                      tooltip: 'Recevoir de l\'argent par MTN Money',
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      shadowColor: Theme.of(context).colorScheme.inversePrimary,
                      selectedColor: primaryColor,
                      checkmarkColor: Colors.white,
                      onSelected: (bool selected) {
                        setState(() {
                          isMtn = selected;
                          isMoov = false;
                          isCeltiis = false;
                          print('Celtiis ==>' + '$isCeltiis');
                          print('Mtn ==>' + '$isMtn');
                          print('Moov ==>' + '$isMoov');
                          _mobileMoney = selected ? 'MTN' : '';
                        });
                      },
                    ),
                  ),

                  // Moov Africa
                  ChoiceChip(
                    label: AppText(
                      text: 'Moov Africa',
                      color: isMoov
                          ? Colors.white
                          : Theme.of(context)
                              .colorScheme
                              .inverseSurface
                              .withAlpha(50),
                    ),
                    pressElevation: 20,
                    side: BorderSide.none,
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 7, right: 7),
                    selected: _mobileMoney == 'Moov Africa',
                    tooltip: 'Recevoir de l\'argent par Moov Money',
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    shadowColor: Theme.of(context).colorScheme.inversePrimary,
                    selectedColor: primaryColor,
                    checkmarkColor: Colors.white,
                    onSelected: (bool selected) {
                      setState(() {
                        isMoov = selected;
                        isCeltiis = false;
                        isMtn = false;
                        print('Celtiis ==>' + '$isCeltiis');
                        print('Mtn ==>' + '$isMtn');
                        print('Moov ==>' + '$isMoov');
                        _mobileMoney = selected ? 'Moov Africa' : '';
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: appHeightSize(context) * 0.02),
            AppText(
              text: 'Numéro de paiement',
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
            ),

            // Numéro de téléphone
            const SizedBox(height: 20),
            AppPhoneTextField(
              controller: _phoneNumbercontroller,
              fontSize: mediumText() * 0.9,
              fontColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 20),

            // Nom prénom
            AppTextField(
              label: 'Nom Prénom',
              height: appHeightSize(context) * 0.08,
              width: appWidthSize(context) * 0.9,
              color: Theme.of(context).colorScheme.surface,
              controller: _nameController,
              prefixIcon: CupertinoIcons.person_alt_circle,
              fontSize: mediumText() * 0.9,
              fontColor: Theme.of(context).colorScheme.inversePrimary,
            ),

            const SizedBox(height: 20),

            // texte
            SizedBox(
              width: appWidthSize(context) * 0.8,
              child: AppText(
                text:
                    "Vous pouvez faire des modifications après dans les paramètres",
                color: Theme.of(context)
                    .colorScheme
                    .inverseSurface
                    .withOpacity(0.2),
                overflow: TextOverflow.visible,
                fontSize: smallText() * 1.1,
              ),
            ),

            SizedBox(
              height: appHeightSize(context) * 0.02,
            ),
          ],
        ),
      ),
    );
  }
}
