import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_phone_textField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../../../widgets/app_text.dart';
import '../../../../widgets/app_textField.dart';
import '../../../colors/app_colors.dart';
import '../../../sizes/app_sizes.dart';

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

  String initialCountry = 'BJ';
  PhoneNumber number = PhoneNumber(isoCode: 'BJ');

  @override
  Widget build(BuildContext context) {
    TextEditingController _nameController = TextEditingController(
        text: StoreCreationGlobalState().payementOwnerName);
    final TextEditingController _phoneNumbercontroller =
        TextEditingController(text: SubmitPaymentInfo().paymentPhoneNumber);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<StoreCreationBloc, StoreCreationState>(
          listener: (context, state) {
            // TODO: implement listener
          },
          builder: (context, state) {
            return ListView(
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
                        context.read<StoreCreationBloc>().add(SubmitPaymentInfo(
                              storeFiscalType: _sellerType,
                            ));
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
                    fontWeight:
                        _sellerType == 'Entreprise ou Société individuelle'
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
                        context.read<StoreCreationBloc>().add(SubmitPaymentInfo(
                              storeFiscalType: _sellerType,
                            ));
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
                  height: appHeightSize(context) * 0.08,
                  width: appWidthSize(context),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: appWidthSize(context) * 0.025,
                    ),
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Celtiis
                        Stack(
                          children: [
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
                                  top: 15, bottom: 15, left: 10, right: 7),
                              selected: _mobileMoney == 'Celtiis',
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              shadowColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              //selectedColor: primaryColor,
                              selectedColor: Colors.deepPurpleAccent,
                              checkmarkColor: Colors.white,
                              tooltip:
                                  'Recevoir de l\'argent par Celtiis Money',
                              onSelected: (bool selected) {
                                setState(() {
                                  isCeltiis = selected;
                                  isMoov = false;
                                  isMtn = false;
                                  _mobileMoney = selected ? 'Celtiis' : '';
                                });
                              },
                            ),
                            Container(
                                width: 12,
                                height: 50,
                                decoration: const BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))))
                          ],
                        ),

                        // MTN
                        Padding(
                          padding: EdgeInsets.only(
                              left: appWidthSize(context) * 0.05,
                              right: appWidthSize(context) * 0.05),
                          child: Stack(
                            children: [
                              ChoiceChip(
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
                                    top: 15, bottom: 15, left: 10, right: 7),
                                selected: _mobileMoney == 'MTN',
                                tooltip: 'Recevoir de l\'argent par MTN Money',
                                backgroundColor:
                                    Theme.of(context).colorScheme.background,
                                shadowColor: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                //selectedColor: primaryColor,
                                selectedColor: Colors.orange,
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
                              Container(
                                  width: 12,
                                  height: 50,
                                  decoration: const BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10))))
                            ],
                          ),
                        ),

                        // Moov Africa
                        Stack(
                          children: [
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
                                  top: 15, bottom: 15, left: 10, right: 7),
                              selected: _mobileMoney == 'Moov Africa',
                              tooltip: 'Recevoir de l\'argent par Moov Money',
                              backgroundColor:
                                  Theme.of(context).colorScheme.background,
                              shadowColor:
                                  Theme.of(context).colorScheme.inversePrimary,
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
                            Container(
                                width: 12,
                                height: 50,
                                decoration: BoxDecoration(
                                    color: primaryColor, //Colors.lightGreen,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10))))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: appHeightSize(context) * 0.02),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                        onInputChanged: (string) {
                          context
                              .read<StoreCreationBloc>()
                              .add(SubmitPaymentInfo(
                                paymentPhoneNumber:
                                    _phoneNumbercontroller.value.text,
                              ));
                        },
                      ),
                      const SizedBox(height: 20),

                      // Nom prénom
                      AppTextField(
                        label: 'Nom Prénom',
                        height: appHeightSize(context) * 0.08,
                        width: appWidthSize(context) * 0.9,
                        color: Theme.of(context).colorScheme.background,
                        controller: _nameController,
                        prefixIcon: CupertinoIcons.person_alt_circle,
                        fontSize: mediumText() * 0.9,
                        fontColor: Theme.of(context).colorScheme.inversePrimary,
                        onChanged: (string) {
                          context.read<StoreCreationBloc>().add(
                              SubmitPaymentInfo(
                                  payementOwnerName:
                                      _nameController.value.text));
                        },
                      ),
                    ],
                  ),
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
                        .inversePrimary
                        .withOpacity(0.3),
                    overflow: TextOverflow.visible,
                    fontSize: smallText() * 1.1,
                  ),
                ),

                SizedBox(
                  height: appHeightSize(context) * 0.02,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
