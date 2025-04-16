import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/utils/dialog.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/models_ui/model_ProfilListTile.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VProfilPage extends StatefulWidget {
  const VProfilPage({super.key});

  @override
  State<VProfilPage> createState() => _VProfilPageState();
}

class _VProfilPageState extends State<VProfilPage> {
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
            height: appHeightSize(context) * 0.3,
            width: appWidthSize(context),
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
                      height: appHeightSize(context) * 0.2,
                      width: appWidthSize(context),
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
                      height: appHeightSize(context) * 0.2 + 12,
                      width: appWidthSize(context),
                      borderRadius: BorderRadius.circular(0),
                      blur: 5,

                      /// le trait en bas de l'image floutée
                      child: Container(
                        height: appHeightSize(context) * 0.15,
                        width: appWidthSize(context),
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
                    top: appHeightSize(context) * 0.12,
                    right: appWidthSize(context) * 0.1,
                    left: appWidthSize(context) * 0.1,
                    child: Hero(
                      tag: 'imageProfil',
                      child: Container(
                        alignment: Alignment.bottomRight,
                        height: appHeightSize(context) * 0.17,
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
                  fontSize: largeText(),
                  fontWeight: FontWeight.w800,
                ),
              ),

              /// icone
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.verified_rounded,
                  color: primaryColor,
                ),
              )
            ],
          ),

          /// adresse gmail
          Center(
            child: AppText(
              text: 'lepoulailler@gmail.com',
              fontSize: smallText(),
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
          const ProfilListTile(
              title: 'Compte vérifié ?', leadingIcon: Icons.verified_outlined),
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
            height: appHeightSize(context) * 0.1,
          ),

          /// bouton de déconnexion
          Hero(
            tag: '1',
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: AppButton(
                height: appHeightSize(context) * 0.07,
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
                  fontSize: mediumText(),
                  fontWeight: FontWeight.w800,
                  color: AppColors.redColor,
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
