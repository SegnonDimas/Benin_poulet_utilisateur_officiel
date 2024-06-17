import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_shaderMask.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

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
    'chargez la photo',
    'chargez la photo',
    'prendre une photo'
  ];

  final List<String> _trailing = [
    'prendre une photo',
    'prendre une photo',
    'Je suis'
        ''
  ];

  // La variable qui stocke le pays sélectionné
  String? _selectedCountry = 'Bénin';
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
            // sélection pays
            // texte
            AppText(
              text: 'Sélectionnez le pays d\'origine de votre pièce',
              fontSize: smallText() * 1.1,
            ),
            const SizedBox(
              height: 10,
            ),
            //choix pays
            Container(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 10, top: 5, bottom: 5),
              decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                    left: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                    right: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(text: '$_selectedCountry'),
                  AppShaderMask(
                    child: CountryListPick(
                      appBar: AppBar(
                        title: AppText(text: 'Choisissez votre pays'),
                      ),
                      theme: CountryTheme(
                          isShowFlag: false,
                          isShowTitle: false,
                          isShowCode: false,
                          isDownIcon: true,
                          showEnglishName: true,
                          labelColor: primaryColor,
                          alphabetSelectedBackgroundColor: primaryColor,
                          searchHintText: 'Recherchez votre pays...',
                          searchText: 'Rechercher',
                          lastPickText: 'Sélectionné précédemment  ',
                          initialSelection: '+229'),
                      initialSelection: '+229',
                      // or
                      // initialSelection: 'BJ'
                      onChanged: (code) {
                        setState(() {
                          _selectedCountry = code!.name;
                        });
                        print(code!.name);
                        print(code!.code);
                        print(code!.dialCode);
                        print(code!.flagUri);
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // liste des pièces
            SizedBox(
              //height: appHeightSize(context) * 0.05,
              //width: appWidthSize(context) * 0.8,
              child: Column(
                children: List.generate(_titrePiece.length, (index) {
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
            )
          ],
        ),
      ),
    );
  }
}

class ModelPhotoSelecteur extends StatefulWidget {
  late String? trailing;
  final String? title;
  final String? description;
  ModelPhotoSelecteur(
      {super.key, this.trailing = '', this.title = '', this.description = ''});

  @override
  State<ModelPhotoSelecteur> createState() => _ModelPhotoSelecteurState();
}

class _ModelPhotoSelecteurState extends State<ModelPhotoSelecteur> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeightSize(context) * 0.09,
      width: appWidthSize(context) * 0.9,
      //padding: const EdgeInsets.only(left: 16.0, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Theme.of(context).colorScheme.surface),
            bottom: BorderSide(color: Theme.of(context).colorScheme.surface),
            left: BorderSide(color: Theme.of(context).colorScheme.surface),
            right: BorderSide(color: Theme.of(context).colorScheme.surface),
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/icons/img.png',
                height: appHeightSize(context) * 0.07,
                width: appWidthSize(context) * 0.12,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.6)),
            SizedBox(
              width: appWidthSize(context) * 0.005,
            ),
            SizedBox(
                height: appHeightSize(context) * 0.07,
                width: appWidthSize(context) * 0.7,
                child: ListTile(
                    //minVerticalPadding: 0,
                    minTileHeight: 5,
                    //minLeadingWidth: 0,
                    //horizontalTitleGap: 2,

                    title: AppText(
                      text: widget.title!,
                      fontSize: mediumText() * 0.8,
                    ),
                    subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: widget.description!,
                            fontSize: smallText() * 0.8,
                            color: primaryColor,
                          ),
                          AppText(
                            text: '${widget.trailing!}',
                            fontSize: smallText() * 0.8,
                            color: primaryColor,
                          ),
                        ])))
          ],
        ),
      ),
    );
  }
}
