import 'package:benin_poulet/views/sizes/text_sizes.dart';
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
                    : Colors.grey,
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
                    : Colors.grey,
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
              color: Colors.grey.shade300,
            ),

            // Mobile money
            AppText(
              text: 'Mobile Money',
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
            ),
            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // Celtiis
                ChoiceChip(
                  label: AppText(
                    text: 'Celtiis',
                    color: isCeltiis ? Colors.white : Colors.grey,
                  ),
                  pressElevation: 20,
                  side: BorderSide.none,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  selected: _mobileMoney == 'Celtiis',
                  backgroundColor: Colors.grey.shade200,
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
                ChoiceChip(
                  label: AppText(
                    text: 'MTN',
                    color: isMtn ? Colors.white : Colors.grey,
                  ),
                  pressElevation: 20,
                  side: BorderSide.none,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  selected: _mobileMoney == 'MTN',
                  tooltip: 'Recevoir de l\'argent par MTN Money',
                  backgroundColor: Colors.grey.shade200,
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

                // Moov Africa
                ChoiceChip(
                  label: AppText(
                    text: 'Moov Africa',
                    color: isMoov ? Colors.white : Colors.grey,
                  ),
                  pressElevation: 20,
                  side: BorderSide.none,
                  padding:
                      EdgeInsets.only(top: 15, bottom: 15, left: 15, right: 15),
                  selected: _mobileMoney == 'Moov Africa',
                  tooltip: 'Recevoir de l\'argent par Moov Money',
                  backgroundColor: Colors.grey.shade200,
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
            SizedBox(height: appHeightSize(context) * 0.02),
            AppText(
              text: 'Numéro de paiement',
              fontSize: mediumText(),
              fontWeight: FontWeight.bold,
            ),

            // Numéro de téléphone
            SizedBox(height: 20),
            Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey.shade200,
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
                  selectorTextStyle: const TextStyle(color: Colors.grey),
                  textStyle: const TextStyle(color: Colors.black),
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
            SizedBox(height: 20),

            AppTextField(
              label: 'Nom Prénom',
              height: appHeightSize(context) * 0.08,
              width: appWidthSize(context) * 0.9,
              color: Colors.grey.shade200,
              controller: _nameController,
              prefixIcon: CupertinoIcons.person_alt_circle,
            ),

            SizedBox(height: 20),

            // texte
            SizedBox(
              width: appWidthSize(context) * 0.8,
              child: AppText(
                text:
                    "Vous pouvez faire des modifications après dans les paramètres",
                color: Colors.grey.shade500,
                fontSize: smallText(),
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
