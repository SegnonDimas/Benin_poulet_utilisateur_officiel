import 'package:benin_poulet/routes.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/storeCreation/store_creation_bloc.dart';
import '../../../models/model_portefeuille.dart';
import '../../../models/model_session.dart';

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

  // liste des icônes du bottomNavigationBar
  final List<Icon> _bottomNavigationBarItems = [
    Icon(
      Icons.home_filled,
      size: largeText() * 1.2,
    ),
    /*Icon(Icons.edit_calendar_rounded, size: largeText() * 1.2),
    Icon(
      Icons.payment,
      size: largeText() * 1.2,
    ),*/
    Icon(
      Icons.wechat_rounded,
      size: largeText() * 1.2,
    ),
  ];

  // page view controller
  final PageController _pageViewController = PageController(
    initialPage: 0,
  );

  int currentPage = 0;

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
              height: appHeightSize(context) * 0.1,
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
            backgroundColor: primaryColor.withGreen(150),
            solde: 400000,
            height: appHeightSize(context) * 0.15,
            radius: appHeightSize(context) * 0.15 * 0.22,
            onSession3Tap: () {
              Navigator.pushNamed(context, appRoutes.VENDEURHISTORIQUEPAGE);
            },
            onTap: () {
              Navigator.pushNamed(context, appRoutes.VENDEURPORTEFEUILLEPAGE);
            },
          ),

          /// liste des sessions
          SizedBox(
            width: appWidthSize(context),
            //height: appHeightSize(context) * 0.15,
            child: Column(
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  //spacing: appWidthSize(context) * 0.001,
                  runSpacing: appHeightSize(context) * 0.0,
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
            Navigator.pushNamed(context, AppRoutes().AJOUTNOUVEAUPRODUITPAGE);
          },
          height: appHeightSize(context) * 0.07,
          width: appHeightSize(context) * 0.07,
          bordeurRadius: 17,
          //appHeightSize(context) * 0.2,
          color: primaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            weight: 20.0,
          ),
        ),
      ),

      /// bottomNavigationBar
      /*bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.background,
        //buttonBackgroundColor: primaryColor,
        //selectedColor: Colors.white,
        //unselectedColor: Theme.of(context).colorScheme.inversePrimary,
        items: _bottomNavigationBarItems,
        index: currentPage,
        onTap: (index) {
          //Handle button tap
          setState(() {
            currentPage = index;
            //_pageViewController.jumpToPage(currentPage);
            _pageViewController.animateToPage(currentPage,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut);
          });
        },
      ),*/
    );
  }
}
