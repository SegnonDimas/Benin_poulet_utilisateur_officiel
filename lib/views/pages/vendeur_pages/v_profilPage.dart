import 'dart:async';

import 'package:benin_poulet/constants/accountStatus.dart';
import 'package:benin_poulet/constants/routes.dart';
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
  String accountStatus = AccountStatus.UNVERIFIED;
  String profilPath = 'assets/images/oeuf2.png';
  String shopName = 'Le Poulailler';

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
              text: 'lepoulailler@gmail.com',
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

          const ProfilListTile(
              title: 'Informations personnelles',
              leadingIcon: Icons.account_circle),
          ProfilListTile(
            title: 'Compte vérifié ?',
            leadingIcon: Icons.verified_outlined,
            onTap: () {
              showAccountState(context, accountStatus: accountStatus);
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
          SizedBox(
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
                            accountStatus = AccountStatus.VERIFIED;
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
                            accountStatus = AccountStatus.UNVERIFIED;
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
                            accountStatus = AccountStatus.PENDING;
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
          ),
        ],
      )),
    );
  }
}

Future showAccountState(
  BuildContext context, {
  String? accountStatus = AccountStatus.UNVERIFIED,
}) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    useSafeArea: true,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: context.height * 0.05,
        ),
        child: SizedBox(
            height: context.height * 0.4,
            width: context.width,
            child: Column(
              children: [
                // lottie indiquant le statut du compte
                accountStatus!.toLowerCase().trim() == AccountStatus.VERIFIED
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
                    : accountStatus!.toLowerCase().trim() ==
                            AccountStatus.PENDING
                        ? Lottie.asset(
                            'assets/lotties/accountAuthentificationPending.json')
                        : Lottie.asset(
                            height: context.height * 0.2,
                            'assets/lotties/accountNotVerified.json'),
                SizedBox(
                  height: context.height * 0.02,
                ),
                AppText(
                  text: accountStatus.toLowerCase().trim() ==
                          AccountStatus.VERIFIED
                      ? 'Votre compte est vérifié'
                      : accountStatus.toLowerCase().trim() ==
                              AccountStatus.PENDING
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
                    accountStatus.toLowerCase().trim() ==
                            AccountStatus.UNVERIFIED
                        ? Navigator.pushReplacementNamed(
                            context, AppRoutes.VENDEURAUTHENTIFICATIONPAGE)
                        : accountStatus.toLowerCase().trim() ==
                                AccountStatus.PENDING
                            ?
                            //TODO: contact support
                            Navigator.pop(context)
                            : Navigator.pop(context); // Fermer le BottomSheet
                  },
                  color: accountStatus.toLowerCase().trim() ==
                          AccountStatus.VERIFIED
                      ? AppColors.primaryColor
                      : accountStatus.toLowerCase().trim() ==
                              AccountStatus.PENDING
                          ? Colors.orange
                          : AppColors.redColor,
                  child: AppText(
                    text: accountStatus == AccountStatus.VERIFIED
                        ? 'Consulter vos informations'
                        : accountStatus == AccountStatus.PENDING
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
