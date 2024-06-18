import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_shaderMask.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';

class PieceIdentitePage extends StatefulWidget {
  @override
  PieceIdentitePageState createState() {
    return PieceIdentitePageState();
  }
}

class PieceIdentitePageState extends State<PieceIdentitePage> {
  final List<String> _titrePiece = [
    'Carte d\'identité',
    'CIP',
    'Permis de conduire',
    'Passeport',
  ];

  final List<String> _descriptionPiece = [
    'Créez votre boutique avec votre carte d\'identité',
    'Créez votre boutique avec votre CIP',
    'Créez votre boutique avec votre Permis de conduire',
    'Créez votre boutique avec votre Passeport',
  ];

  // La variable qui stocke le pays sélectionné
  String? _selectedCountry = 'Bénin';
  String initialCountry = 'BJ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// sélection pays
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
                  // pays sélectionné
                  SizedBox(
                      width: appWidthSize(context) * 0.6,
                      child: AppText(text: '$_selectedCountry')),
                  // sélecteur de pays
                  SizedBox(
                    //width: appWidthSize(context) * 0.25,
                    child: AppShaderMask(
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
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            /// liste des pièces
            SizedBox(
              //height: appHeightSize(context) * 0.05,
              //width: appWidthSize(context) * 0.8,
              child: Column(
                children: List.generate(_titrePiece.length, (index) {
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: appHeightSize(context) * 0.02),
                    child: ModelPieceIdentite(
                      title: _titrePiece[index],
                      description: _descriptionPiece[index],
                    ),
                  );
                }),
              ),
            ),
            SizedBox(
              height: appHeightSize(context) * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}

class ModelPieceIdentite extends StatefulWidget {
  late bool? isSelected;
  final String? title;
  final String? description;
  ModelPieceIdentite(
      {super.key,
      this.isSelected = false,
      this.title = '',
      this.description = ''});

  @override
  State<ModelPieceIdentite> createState() => _ModelPieceIdentiteState();
}

class _ModelPieceIdentiteState extends State<ModelPieceIdentite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeightSize(context) * 0.09,
      width: appWidthSize(context) * 0.9,
      //padding: const EdgeInsets.only(left: 16.0, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: !widget.isSelected!
                    ? Theme.of(context).colorScheme.surface
                    : primaryColor),
            bottom: BorderSide(
                color: !widget.isSelected!
                    ? Theme.of(context).colorScheme.surface
                    : primaryColor),
            left: BorderSide(
                color: !widget.isSelected!
                    ? Theme.of(context).colorScheme.surface
                    : primaryColor),
            right: BorderSide(
                color: !widget.isSelected!
                    ? Theme.of(context).colorScheme.surface
                    : primaryColor),
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !widget.isSelected!
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isSelected = !widget.isSelected!;
                      });
                    },
                    child: Icon(
                      Icons.circle_outlined,
                      color: Theme.of(context).colorScheme.surface,
                    ))
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.isSelected = !widget.isSelected!;
                      });
                    },
                    child: Icon(
                      Icons.circle,
                      color: primaryColor,
                    ),
                  ),
            SizedBox(
              width: appWidthSize(context) * 0.05,
            ),
            SizedBox(
              height: appHeightSize(context) * 0.07,
              width: appWidthSize(context) * 0.7,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    text: widget.title!,
                    fontSize: mediumText() * 0.9,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: appWidthSize(context) * 0.7,
                    child: AppText(
                      text: widget.description!,
                      fontSize: smallText(),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
