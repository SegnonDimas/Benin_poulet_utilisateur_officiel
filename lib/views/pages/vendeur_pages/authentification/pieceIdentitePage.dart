import 'package:benin_poulet/bloc/authentification/authentification_bloc.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_shaderMask.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../models_ui/model_pieceIdentite.dart';

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
  String? _selectedDocumentType;
  String initialCountry = 'BJ';

  @override
  void initState() {
    super.initState();
    // Charger les données existantes si disponibles
    _loadExistingData();
  }

  void _loadExistingData() {
    final currentState = context.read<AuthentificationBloc>().state;
    if (currentState is AuthentificationGlobalState) {
      setState(() {
        _selectedDocumentType = currentState.idendityDocument;
        _selectedCountry = currentState.idDocumentCountry;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
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
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3)),
                    bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3)),
                    left: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3)),
                    right: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3)),
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
                        onChanged: (code) {
                          setState(() {
                            _selectedCountry = code!.name;
                          });
                          _updateAuthentificationState();
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
              child: Column(
                children: List.generate(_titrePiece.length, (index) {
                  final isSelected = _selectedDocumentType == _titrePiece[index];
                  return Padding(
                    padding:
                        EdgeInsets.only(bottom: appHeightSize(context) * 0.02),
                    child: ModelPieceIdentite(
                      title: _titrePiece[index],
                      description: _descriptionPiece[index],
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          // Sélection unique : désélectionner tous les autres
                          _selectedDocumentType = _titrePiece[index];
                        });
                        _updateAuthentificationState();
                      },
                      color: isSelected
                          ? AppColors.primaryColor
                          : Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withOpacity(0.3),
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

  void _updateAuthentificationState() {
    print('=== MISE À JOUR ÉTAT AUTHENTIFICATION ===');
    print('Pays sélectionné: $_selectedCountry');
    print('Type de document sélectionné: $_selectedDocumentType');
    
    // Récupérer l'état actuel du BLoC
    final currentState = context.read<AuthentificationBloc>().state;
    if (currentState is AuthentificationGlobalState) {
      // Créer un nouvel événement avec les données mises à jour
      final event = SubmitIdentityDocuments(
        idDocumentCountry: _selectedCountry ?? '',
        idendityDocument: _selectedDocumentType ?? '',
      );
      context.read<AuthentificationBloc>().add(event);
      print('✓ Événement SubmitIdentityDocuments envoyé au BLoC');
    } else {
      // Si pas d'état global, créer un nouvel état
      final event = SubmitIdentityDocuments(
        idDocumentCountry: _selectedCountry ?? '',
        idendityDocument: _selectedDocumentType ?? '',
      );
      context.read<AuthentificationBloc>().add(event);
      print('✓ Nouvel état AuthentificationGlobalState créé');
    }
    print('==========================================');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
