import 'dart:async';

import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/constants/user_profilStatus.dart';
import 'package:benin_poulet/services/user_data_service.dart';
import 'package:benin_poulet/utils/dialog.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/models_ui/model_ProfilListTile.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VProfilPage extends StatefulWidget {
  const VProfilPage({super.key});

  @override
  State<VProfilPage> createState() => _VProfilPageState();
}

class _VProfilPageState extends State<VProfilPage>
    with SingleTickerProviderStateMixin {
  String profilStatus = UserProfilStatus.unverified;
  String profilPath = 'assets/images/oeuf2.png';
  String shopName = 'Le Poulailler';
  String userEmail = 'lepoulailler@gmail.com';
  String fullName = 'Nom et prénom';
  String dateOfBirth = 'Non renseigné';
  String placeOfBirth = 'Non renseigné';
  String currentAddress = 'Non renseigné';
  String idDocumentType = 'Non renseigné';
  String countryOfOrigin = 'Non renseigné';
  String? idDocumentPhoto;

  final UserDataService _userDataService = UserDataService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Récupérer les données du vendeur connecté
      final seller = await _userDataService.getCurrentSeller();
      final user = await _userDataService.getCurrentUser();

      if (mounted) {
        setState(() {
          // Mettre à jour le nom de la boutique
          if (seller?.storeInfos != null &&
              seller!.storeInfos!['name'] != null) {
            shopName = seller.storeInfos!['name'] as String;
          }

          // Mettre à jour l'email
          if (seller?.storeInfos != null &&
              seller!.storeInfos!['email'] != null) {
            userEmail = seller.storeInfos!['email'] as String;
          } else if (user?.authIdentifier != null) {
            userEmail = user!.authIdentifier!;
          }

          // Mettre à jour les informations personnelles
          if (user?.fullName != null && user!.fullName!.isNotEmpty) {
            fullName = user.fullName!;
          }

          if (user?.dateOfBirth != null) {
            dateOfBirth =
                '${user!.dateOfBirth!.day}/${user.dateOfBirth!.month}/${user.dateOfBirth!.year}';
          }

          if (user?.placeOfBirth != null && user!.placeOfBirth!.isNotEmpty) {
            placeOfBirth = user.placeOfBirth!;
          }

          if (user?.currentAddress != null &&
              user!.currentAddress!.isNotEmpty) {
            currentAddress = user.currentAddress!;
          }

          if (user?.idDocumentType != null &&
              user!.idDocumentType!.isNotEmpty) {
            idDocumentType = user.idDocumentType!;
          }

          if (user?.idDocumentCountry != null &&
              user!.idDocumentCountry!.isNotEmpty) {
            countryOfOrigin = user.idDocumentCountry!;
          }

          if (user?.idDocumentPhoto != null &&
              user!.idDocumentPhoto!.isNotEmpty) {
            // idDocumentPhoto est maintenant une Map, on peut l'afficher différemment
            idDocumentPhoto = user.idDocumentPhoto?.values.firstOrNull;
          }

          // Mettre à jour le statut de vérification
          if (user?.profilStatus != null) {
            profilStatus = user!.profilStatus;
          } else if (seller?.documentsVerified != null) {
            profilStatus = seller!.documentsVerified!
                ? UserProfilStatus.verified
                : UserProfilStatus.unverified;
          }
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des données utilisateur: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          /*appBar: AppBar(
            title: AppText(text: 'Mon profil'),
            centerTitle: true,
          ),*/
          body: ListView(
        padding: EdgeInsets.only(top: 0),
        children: [
          /// image photo de prfil
          SizedBox(
            height: context.height * 0.3,
            width: context.width,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// image d'arrière-plan floutée
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Hero(
                    tag: '2',
                    child: Container(
                      height: context.height * 0.2,
                      width: context.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(profilPath))),
                    ),
                  ),
                ),

                /// BlurryContainer qui a flouté l'image
                Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: BlurryContainer(
                      height: context.height * 0.2 + 12,
                      width: context.width,
                      borderRadius: BorderRadius.circular(0),
                      blur: 5,

                      /// le trait en bas de l'image floutée
                      child: Container(
                        height: context.height * 0.15,
                        width: context.width,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                width: 4,
                                strokeAlign: BorderSide.strokeAlignInside),
                          ),
                        ),
                      ),
                    )),

                /// image du profil (en rond)
                Positioned(
                    top: context.height * 0.12,
                    right: context.width * 0.1,
                    left: context.width * 0.1,
                    child: Hero(
                      tag: 'imageProfil',
                      child: Container(
                        alignment: Alignment.bottomRight,
                        height: context.height * 0.17,
                        decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  width: 4,
                                  strokeAlign: BorderSide.strokeAlignOutside),
                            ),
                            image:
                                DecorationImage(image: AssetImage(profilPath)),
                            shape: BoxShape.circle),
                      ),
                    )),

                Positioned(
                  top: context.height * 0.05,
                  left: 10,
                  child: //bouton retour
                      GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: context.height * 0.06,
                      width: context.height * 0.06,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_back_outlined,
                        color: Theme.of(context).colorScheme.inversePrimary,
                        size: context.mediumText * 1.5,
                        weight: 100,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          /// nom de la boutique + l'icône de vérification
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Hero(
                tag: 'nomBoutique',
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.verified_rounded,
                    color: Colors.transparent,
                  ),
                ),
              ),

              /// nom boutique
              Center(
                child: AppText(
                  text: shopName,
                  fontSize: context.largeText,
                  fontWeight: FontWeight.w800,
                ),
              ),

              /// icone
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.verified_rounded,
                  color: AppColors.primaryColor,
                ),
              )
            ],
          ),

          /// adresse gmail
          Center(
            child: AppText(
              text: userEmail,
              fontSize: context.smallText,
              //fontWeight: FontWeight.w800,
            ),
          ),

          /// divider
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Divider(
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            ),
          ),

          /// liste des items de profil

          ProfilListTile(
              title: 'Informations personnelles',
              leadingIcon: Icons.account_circle,
              onTap: () {
                _showPersonalInfoBottomSheet(context);
              }),
          ProfilListTile(
            title: 'Compte vérifié ?',
            leadingIcon: Icons.verified_outlined,
            onTap: () {
              showProfilState(context, profilStatus: profilStatus);
              //Navigator.pushNamed(context, AppRoutes.VENDEURETATCOMPTEPAGE);
            },
          ),
          const ProfilListTile(
              title: 'Autorisations', leadingIcon: Icons.verified_user_rounded),
          ProfilListTile(
            title: 'Portefeuille',
            leadingIcon: Icons.payment_rounded,
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.VENDEURPORTEFEUILLEPAGE);
            },
          ),
          const ProfilListTile(
              title: 'Paramètres', leadingIcon: Icons.settings),

          SizedBox(
            height: context.height * 0.05,
          ),

          /// bouton de déconnexion
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Hero(
              tag: '1',
              child: AppButton(
                height: context.height * 0.07,
                onTap: () {
                  AppDialog.showDialog(
                    context: context,
                    title: "Deconnexion",
                    content: 'Êtes-vous sûr de vouloir vous déconnecter ?',
                    confirmText: 'Deconnexion',
                    cancelText: 'Annuler',
                    onConfirm: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, AppRoutes.LOGINPAGE, (route) => false);
                    },
                  );
                },
                borderColor: AppColors.redColor,
                color: Colors.transparent,
                child: AppText(
                  textAlign: TextAlign.center,
                  text: 'Se déconnecter',
                  fontSize: context.mediumText,
                  fontWeight: FontWeight.w800,
                  color: AppColors.redColor,
                ),
              ),
            ),
          ),

          /// POUR LES TESTS
          /*SizedBox(
            height: context.height * 0.02,
          ),
          SizedBox(
            height: context.height * 0.1,
            child: Column(
              children: [
                AppText(
                  text: 'Juste pour les tests',
                  color: Colors.grey.withOpacity(0.6),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          setState(() {
                            profilStatus = UserProfilStatus.verified;
                          });
                        },
                        child: AppText(
                          text: 'Verifié',
                          fontSize: context.smallText,
                          color: Colors.green,
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            profilStatus = UserProfilStatus.unverified;
                          });
                        },
                        child: AppText(
                          text: 'Non verifié',
                          fontSize: context.smallText,
                          color: Colors.red,
                        )),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            profilStatus = UserProfilStatus.pending;
                          });
                        },
                        child: AppText(
                          text: 'En Cours',
                          fontSize: context.smallText,
                          color: Colors.amber,
                        )),
                  ],
                )
              ],
            ),
          ),*/
        ],
      )),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: label,
            fontSize: context.smallText,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.5),
          ),
          const SizedBox(height: 5),
          AppText(
            text: value,
            fontSize: context.mediumText,
          ),
          Divider(
            color:
                Theme.of(context).colorScheme.inverseSurface.withOpacity(0.05),
          ),
        ],
      ),
    );
  }

  Future showProfilState(
    BuildContext context, {
    String? profilStatus = UserProfilStatus.unverified,
  }) async {
    final user = await _userDataService.getCurrentUser();
    profilStatus = user!.profilStatus;
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: context.height * 0.02,
          ),
          child: SizedBox(
              height: context.height * 0.4,
              width: context.width,
              child: Column(
                children: [
                  // lottie indiquant le statut du compte
                  profilStatus!.toLowerCase().trim() ==
                          UserProfilStatus.verified
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: context.height * 0.13,
                              width: context.height * 0.13,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(10000),
                              ),
                            ),
                            Lottie.asset(
                                height: context.height * 0.2,
                                'assets/lotties/accountVerified.json'),
                          ],
                        )
                      : profilStatus.toLowerCase().trim() ==
                              UserProfilStatus.pending
                          ? Lottie.asset(
                              'assets/lotties/accountAuthentificationPending.json')
                          : Lottie.asset(
                              height: context.height * 0.2,
                              'assets/lotties/accountNotVerified.json'),
                  SizedBox(
                    height: context.height * 0.02,
                  ),
                  AppText(
                    text: profilStatus.toLowerCase().trim() ==
                            UserProfilStatus.verified
                        ? 'Votre compte est vérifié'
                        : profilStatus.toLowerCase().trim() ==
                                UserProfilStatus.pending
                            ? 'Votre compte est en cours de vérification'
                            : 'Votre compte n\'est pas encore vérifié',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: context.height * 0.07,
                  ),
                  AppButton(
                    height: context.height * 0.07,
                    width: context.width * 0.9,
                    onTap: () {
                      profilStatus?.toLowerCase().trim() ==
                              UserProfilStatus.unverified
                          ? Navigator.pushReplacementNamed(
                              context, AppRoutes.VENDEURAUTHENTIFICATIONPAGE)
                          : profilStatus?.toLowerCase().trim() ==
                                  UserProfilStatus.pending
                              ?
                              //TODO: contact support
                              Navigator.pop(context)
                              : {
                                  Navigator.pop(context),
                                  _showPersonalInfoBottomSheet(context)
                                }; // Fermer le BottomSheet
                    },
                    color: profilStatus.toLowerCase().trim() ==
                            UserProfilStatus.verified
                        ? AppColors.primaryColor
                        : profilStatus.toLowerCase().trim() ==
                                UserProfilStatus.pending
                            ? Colors.orange
                            : AppColors.redColor,
                    child: AppText(
                      text: profilStatus == UserProfilStatus.verified
                          ? 'Consulter vos informations'
                          : profilStatus == UserProfilStatus.pending
                              ? 'Nous contacter'
                              : 'Commencer la vérification',
                      fontSize: context.mediumText * 0.9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }

  void _showPersonalInfoBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: context.height * 0.8,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.inverseSurface,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: AppText(
                text: 'Informations personnelles',
                fontSize: context.largeText,
                fontWeight: FontWeight.bold,
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Nom et prénom', fullName),
                    _buildInfoRow('Date de naissance', dateOfBirth),
                    _buildInfoRow('Lieu de naissance', placeOfBirth),
                    _buildInfoRow('Adresse actuelle', currentAddress),
                    _buildInfoRow('Type de pièce d\'identité', idDocumentType),
                    _buildInfoRow('Pays d\'origine', countryOfOrigin),
                    if (idDocumentPhoto != null) ...[
                      const SizedBox(height: 20),
                      AppText(
                        text: 'Photo de la pièce d\'identité',
                        fontSize: context.mediumText,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withOpacity(0.3)),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GestureDetector(
                            onTap: () {},
                            child: Image.network(
                              //TODO:
                              // idDocumentPhoto ??
                              "https://www.shutterstock.com/image-vector/idea-personal-identity-id-card-600nw-1182870613.jpg",
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.1),
                                  child: Icon(
                                    Icons.image_not_supported,
                                    size: 50,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface
                                        .withOpacity(0.3),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
