import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/utils/app_attributs.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../models_ui/model_portefeuille.dart';
import '../../models_ui/model_session.dart';

class VHomePage extends StatefulWidget {
  const VHomePage({super.key});

  @override
  State<VHomePage> createState() => _VHomePageState();
}

class _VHomePageState extends State<VHomePage> {
  // liste des sessions
  final List<ModelSession> _sessions = [
    ModelSession(
      title: 'Ma boutique',
      routeName: AppRoutes
          .VENDEURPRESENTATIONBOUTIQUEPAGE /*'/vendeurPresentationBoutiquePage'*/,
      imgUrl: 'assets/icons/shop.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Mes produits',
      routeName:
          AppRoutes.VENDEURPRODUITSLISTPAGE /*'/vendeurProduitsListPage'*/,
      imgUrl: 'assets/icons/produit.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Mes Commandes',
      routeName:
          AppRoutes.VENDEURCOMMANDELISTPAGE /*'/vendeurCommandeListPage'*/,
      imgUrl: 'assets/icons/command.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Campagnes',
      //routeName: '/vendeurPresentationBoutiquePage',
      imgUrl: 'assets/icons/add.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Performances',
      routeName:
          AppRoutes.VENDEURPERFORMANCESPAGE /*'/vendeurPerformancesPage'*/,
      imgUrl: 'assets/icons/performance.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Calculatrice',
      //routeName: '/vendeurPresentationBoutiquePage',
      imgUrl: 'assets/icons/calculator.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Coursiers',
      imgUrl: 'assets/icons/delivery.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
    ModelSession(
      title: 'Mon profil',
      routeName: AppRoutes.VENDEURPROFILPAGE /*'/vendeurProfilPage'*/,
      imgUrl: 'assets/icons/sellerProfil.png',
      backgroundColor: AppColors.primaryColor.withOpacity(0.15),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final storeInfoState =
        context.watch<StoreCreationBloc>().state as StoreCreationGlobalState;
    const SizedBox espace = SizedBox(
      height: 20,
    );

    /// corps de la page
    return Scaffold(
      body: ListView(
        children: [
          /// texte de bienvenue
          SizedBox(
              height: context.height * 0.1,
              width: appWidthSize(context),
              child: ListTile(
                title: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'S',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: context.mediumText * 1.3,
                        fontFamily: AppAttributes.appDefaultFontFamily,
                        fontWeight: FontWeight.w400),
                  ),
                  TextSpan(
                    text: 'alut, ',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: context.mediumText,
                        fontFamily: AppAttributes.appDefaultFontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: storeInfoState.storeName,
                    style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: context.mediumText * 1.2,
                        fontFamily: AppAttributes.appDefaultFontFamily,
                        fontWeight: FontWeight.w900),
                  )
                ])),

                /*
                AppText(
                  text: 'Salut, ${storeInfoState.storeName} service de Dieu!',
                  fontWeight: FontWeight.bold,
                  fontSize: context.mediumText * 1.1,
                  overflow: TextOverflow.visible,
                )
                */

                subtitle: AppText(
                  text: 'Votre boutique est maintenant en ligne',
                  fontSize: smallText(),
                ),
              )),
          //espace,

          /// présentation du portefeuille
          ModelPortefeuille(
            backgroundColor: AppColors.primaryColor.withGreen(150),
            solde: 400000,
            height: context.height * 0.15,
            radius: context.height * 0.15 * 0.22,
            onSession3Tap: () {
              Navigator.pushNamed(context, AppRoutes.VENDEURHISTORIQUEPAGE);
            },
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.VENDEURPORTEFEUILLEPAGE);
            },
          ),

          /// liste des sessions
          SizedBox(
            width: appWidthSize(context),
            //height: context.height * 0.15,
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  //spacing: appWidthSize(context) * 0.001,
                  runSpacing: context.height * 0.0,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: _sessions,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Hero(
        tag: 'ajoutProduit',
        child: AppButton(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.AJOUTNOUVEAUPRODUITPAGE);
          },
          height: context.height * 0.07,
          width: context.height * 0.07,
          bordeurRadius: 17,
          //context.height * 0.2,
          color: AppColors.primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            weight: 20.0,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
