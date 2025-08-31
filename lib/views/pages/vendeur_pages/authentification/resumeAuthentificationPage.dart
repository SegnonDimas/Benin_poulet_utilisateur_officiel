import 'package:benin_poulet/bloc/authentification/authentification_bloc.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/core/firebase/firestore/firestore_service.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/utils/app_utils.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../models_ui/model_resumeTextFormFiel.dart';

class ResumeAuthentificationPage extends StatefulWidget {
  const ResumeAuthentificationPage({super.key});

  @override
  State<ResumeAuthentificationPage> createState() =>
      _ResumeAuthentificationPageState();
}

class _ResumeAuthentificationPageState
    extends State<ResumeAuthentificationPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        /* appBar: AppBar(
          title: AppText(
            text: "Résumé de l'authentification",
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: mediumText(),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0,
        ),*/
        body: BlocBuilder<AuthentificationBloc, AuthentificationState>(
          builder: (context, state) {
            if (state is AuthentificationInitial) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 64,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 16),
                    AppText(
                      textAlign: TextAlign.center,
                      text: "Aucune information d'authentification",
                      overflow: TextOverflow.visible,
                      fontSize: context.mediumText,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 8),
                    AppText(
                      text:
                          "Veuillez d'abord remplir les informations d'authentification",
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      fontSize: context.mediumText * 0.8,
                      color: Theme.of(context)
                          .colorScheme
                          .inverseSurface
                          .withOpacity(0.4),
                    ),
                    SizedBox(height: 24),
                    /*ElevatedButton.icon(
                      onPressed: () => _navigateToModify(),
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: AppText(
                        text: "Commencer l'authentification",
                        color: Colors.white,
                        fontSize: mediumText(),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),*/
                  ],
                ),
              );
            }

            if (state is! AuthentificationGlobalState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            final sellerinfos = state;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(children: [
                      // nom et prénoms du vendeur
                      ModelResumeTextField(
                        attribut: 'Nom et prénoms',
                        valeur: sellerinfos.sellerFullName ?? 'Non renseigné',
                      ),
                      DottedLine(
                        dashColor: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                      ),

                      // date de naissance du vendeur
                      ModelResumeTextField(
                        attribut: 'Date de naissance',
                        valeur: sellerinfos.sellerBirthDate ?? 'Non renseigné',
                      ),
                      DottedLine(
                        dashColor: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                      ),

                      // lieu de naissance du vendeur
                      ModelResumeTextField(
                        attribut: 'Lieu de naissance',
                        valeur: sellerinfos.sellerBirthPlace ?? 'Non renseigné',
                      ),
                      DottedLine(
                        dashColor: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                      ),

                      // adresse actuelle du vendeur
                      ModelResumeTextField(
                        attribut: 'Adresse actuelle',
                        valeur: sellerinfos.sellerCurrentLocation ??
                            'Non renseigné',
                      ),
                      DottedLine(
                        dashColor: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                      ),

                      // type de pièce d'identité du vendeur
                      ModelResumeTextField(
                        attribut: 'Type de pièce d\'identité',
                        valeur: sellerinfos.idendityDocument ?? 'Non renseigné',
                      ),
                      DottedLine(
                        dashColor: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                      ),

                      // pays d'origine
                      ModelResumeTextField(
                        attribut: 'Pays d\'origine',
                        valeur:
                            sellerinfos.idDocumentCountry ?? 'Non renseigné',
                      ),
                      DottedLine(
                        dashColor: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.1),
                      ),
                    ]),
                  ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: // Boutons d'action
            Padding(
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: Row(
            children: [
              // Bouton Modifier
              Expanded(
                child: AppButton(
                  height: context.height * 0.06,
                  onTap: () {
                    _navigateToModify();
                  },
                  color: Theme.of(context)
                      .colorScheme
                      .inverseSurface
                      .withOpacity(0.2),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.inverseSurface,
                          size: context.mediumText,
                        ),
                        AppText(
                          text: "Modifier",
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: context.smallText * 1.1,
                        ),
                      ]),
                ),
              ),
              SizedBox(width: 16),
              // Bouton Soumettre
              Expanded(
                flex: 2,
                child: AppButton(
                  height: context.height * 0.06,
                  onTap: _isSubmitting
                      ? null
                      : () {
                          _submitAuthentication();
                        },
                  color: AppColors.primaryColor,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: _isSubmitting ? "Soumission..." : "Soumettre",
                          color: Colors.white,
                          fontSize: mediumText(),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        _isSubmitting
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Icon(
                                Icons.send,
                                color: Colors.white,
                                size: context.mediumText * 1.1,
                              ),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToModify() {
    Navigator.pop(context);
    // Navigation vers la page de modification des informations personnelles
    Get.toNamed(AppRoutes.VENDEURAUTHENTIFICATIONPAGE);
  }

  Future<void> _submitAuthentication() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final currentState = context.read<AuthentificationBloc>().state;

      if (currentState is! AuthentificationGlobalState) {
        AppUtils.showInfoNotification(context,
            'Veuillez d\'abord remplir toutes les informations d\'authentification');
        /*ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Veuillez d\'abord remplir toutes les informations d\'authentification'),
            backgroundColor: Colors.orange,
          ),
        );*/
        return;
      }

      final sellerinfos = currentState;

      // Récupérer l'utilisateur actuel
      final userDataService = UserDataService();
      final currentUser = await userDataService.getCurrentUser();

      if (currentUser != null) {
        // Vérifier que toutes les informations requises sont remplies
        if (sellerinfos.sellerFullName?.isEmpty ?? true) {
          AppUtils.showInfoNotification(
              context, 'Veuillez remplir votre nom et prénoms');
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Veuillez remplir votre nom et prénoms'),
              backgroundColor: Colors.orange,
            ),
          );*/
          return;
        }

        if (sellerinfos.idendityDocument?.isEmpty ?? true) {
          AppUtils.showInfoNotification(
              context, 'Veuillez sélectionner un type de pièce d\'identité');
          /* ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Veuillez sélectionner un type de pièce d\'identité'),
              backgroundColor: Colors.orange,
            ),
          );*/
          return;
        }

        if (sellerinfos.idDocumentCountry?.isEmpty ?? true) {
          AppUtils.showInfoNotification(
              context, 'Veuillez sélectionner le pays d\'origine');
          /*ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Veuillez sélectionner le pays d\'origine'),
              backgroundColor: Colors.orange,
            ),
          );*/
          return;
        }

        // Utiliser une URL par défaut si aucune photo n'est prise
        final defaultPhotoUrl =
            'https://media.istockphoto.com/id/612650934/fr/vectoriel/carte-didentit%C3%A9-isol%C3%A9e-sur-fond-blanc-ic%C3%B4ne-didentification-de-lentreprise.jpg?s=612x612&w=0&k=20&c=CWx0pfJc9ZaZmDYRbCWO3xi4iZg-YmUGUBM1aMcUSX0=';

        // Créer la Map des photos avec les vraies photos ou l'URL par défaut
        final Map<String, String> finalPhotoMap = {
          'recto': sellerinfos.idDocumentPhoto?['recto'] ?? defaultPhotoUrl,
          'verso': sellerinfos.idDocumentPhoto?['verso'] ?? defaultPhotoUrl,
          'selfie': sellerinfos.idDocumentPhoto?['selfie'] ?? defaultPhotoUrl,
        };

        // Debug: Afficher les données avant soumission
        print('=== DONNÉES D\'AUTHENTIFICATION ===');
        print('fullName: ${sellerinfos.sellerFullName}');
        print('dateOfBirth: ${sellerinfos.sellerBirthDate}');
        print('placeOfBirth: ${sellerinfos.sellerBirthPlace}');
        print('currentAddress: ${sellerinfos.sellerCurrentLocation}');
        print('idDocumentType: ${sellerinfos.idendityDocument}');
        print('idDocumentCountry: ${sellerinfos.idDocumentCountry}');
        print('idDocumentPhoto: ${sellerinfos.idDocumentPhoto}');
        print('=====================================');

        // Mettre à jour les informations d'authentification
        print('=== DÉBUT MISE À JOUR FIREBASE ===');
        print('userId: ${currentUser.userId}');
        print('fullName: ${sellerinfos.sellerFullName}');
        print('dateOfBirth: ${sellerinfos.sellerBirthDate}');
        print('placeOfBirth: ${sellerinfos.sellerBirthPlace}');
        print('currentAddress: ${sellerinfos.sellerCurrentLocation}');
        print('idDocumentType: ${sellerinfos.idendityDocument}');
        print('idDocumentCountry: ${sellerinfos.idDocumentCountry}');
        print('idDocumentPhoto: ${sellerinfos.idDocumentPhoto}');

        await _firestoreService.updateUserAuthenticationInfo(
          userId: currentUser.userId,
          fullName: sellerinfos.sellerFullName,
          dateOfBirth: sellerinfos.sellerBirthDate != null
              ? DateTime.tryParse(sellerinfos.sellerBirthDate!)
              : null,
          placeOfBirth: sellerinfos.sellerBirthPlace,
          currentAddress: sellerinfos.sellerCurrentLocation,
          idDocumentType: sellerinfos.idendityDocument,
          idDocumentCountry: sellerinfos.idDocumentCountry,
          idDocumentPhoto: finalPhotoMap,
        );

        print('=== FIN MISE À JOUR FIREBASE ===');

        // Afficher un message de succès
        AppUtils.showSuccessNotification(
            context, 'Informations d\'authentification soumises avec succès !');
        /* ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Informations d\'authentification soumises avec succès !'),
            backgroundColor: Colors.green,
          ),
        );*/

        // Navigation vers la page suivante ou retour
        //Get.back();
        Navigator.pushReplacementNamed(context, AppRoutes.VALIDATIONPAGE);
      }
    } catch (e) {
      // Afficher un message d'erreur
      AppUtils.showErrorNotification(
          context, 'Erreur lors de la soumission: $e', null);
      /*ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la soumission: $e'),
          backgroundColor: Colors.red,
        ),
      );*/
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
