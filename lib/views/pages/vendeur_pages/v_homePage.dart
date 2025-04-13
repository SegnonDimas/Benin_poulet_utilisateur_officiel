import 'package:benin_poulet/constants/routes.dart';
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
    const ModelSession(
      title: 'Ma boutique',
      routeName: '/vendeurPresentationBoutiquePage',
    ),
    const ModelSession(
      title: 'Mes produits',
      routeName: '/vendeurProduitsListPage',
    ),
    const ModelSession(
      title: 'Mes Commandes',
      routeName: '/vendeurCommandeListPage',
    ),
    const ModelSession(
      title: 'Campagnes',
      //routeName: '/vendeurPresentationBoutiquePage',
    ),
    const ModelSession(
      title: 'Performances',
      routeName: '/vendeurPerformancesPage',
    ),
    const ModelSession(
      title: 'Calculatrice',
      //routeName: '/vendeurPresentationBoutiquePage',
    ),
    const ModelSession(title: 'Coursiers'),
    const ModelSession(title: 'Mon profil', routeName: '/vendeurProfilPage'),
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
                title: AppText(
                  text: 'Salut, ${storeInfoState.storeName}!',
                  fontWeight: FontWeight.bold,
                ),
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
}
