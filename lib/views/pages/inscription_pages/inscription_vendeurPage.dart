import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/constants/routes.dart';
import 'package:benin_poulet/constants/app_attributs.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../widgets/app_timeline_tile.dart';
import '../../colors/app_colors.dart';
import '../vendeur_pages/creation_boutique/choixCategoriePage.dart';
import '../vendeur_pages/creation_boutique/choixLivreurPage.dart';
import '../vendeur_pages/creation_boutique/fiscalitePage.dart';
import '../vendeur_pages/creation_boutique/infoBoutiquePage.dart';
import '../vendeur_pages/creation_boutique/resumeCreationBoutiquePage.dart';

class InscriptionVendeurPage extends StatefulWidget {
  const InscriptionVendeurPage({super.key});

  @override
  State<InscriptionVendeurPage> createState() => _InscriptionVendeurPageState();
}

class _InscriptionVendeurPageState extends State<InscriptionVendeurPage> {
  int pageIndex = 0;

  /*Suivre l'index de la page actuelle. Cela permet d'écouter les changements de valeur et de reconstruire les AppTimelineTile en conséquence.*/
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);
  final PageController _pageViewController = PageController();

  final List<String> _title = [
    'Commençons à créer votre boutique',
    'Que vendez-vous ?',
    'Où devrions-nous verser vos fonds ?',
    'Pouvons-nous assurer vos livraisons ?',
    //'Vérifions votre identité',
    'Résumé Général'
  ];

  final List<String> _description = [
    'Dites-nous-en plus sur votre boutique',
    'Aidez les clients à comprendre ce que votre boutique offre',
    'Vos informations sont chiffrées de bout en bout',
    'Confiez vos livraisons à notre flotte de livreur expérimentée',
    //'Tous nos vendeurs sont vérifiés pour rassurer nos clients',
    'Vérifiez que toutes les informations sont correctes'
  ];

  final List<Widget> _pages = [
    // page 1 : infos boutique
    InfoBoutiquePage(),

    // page 2 : choix categorie
    ChoixCategoriePage(),

    // page 3 : fiscalité
    FiscalitePage(),

    // page 4 : choix livreur
    ChoixLivreurPage(),

    // page 5 : authetification vendeur
    //const AuthentificationVendeurPage(),

    // page 6 : résumé de creation de boutique
    ResumeCreationBoutiquePage()
  ];

  int indexed = 0;
  int fixedIndex = 0;

  int position = 0;
  int ontapIndex = 0;

  @override
  void initState() {
    _pageViewController.addListener(() {
      setState(() {
        position = _pageViewController.page!.toInt();
      });
    });
    _pageIndexNotifier.value = position;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            body: Stack(
              //crossAxisAlignment: CrossAxisAlignment.start,
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                /// l'en-tête de la page
                Positioned(
                  top: context.height * 0.06,
                  child: SizedBox(
                    height: context.height * 0.23,
                    child: Column(
                      children: [
                        SizedBox(
                          height: context.height * 0.04,
                          width: context.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: AppText(
                              text: AppAttributes.appName,
                              fontSize: context.largeText * 1.3,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: context.height * 0.1,
                          width: context.width,
                          child: Wrap(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(1, (index) {
                            return ValueListenableBuilder<int>(
                              valueListenable: _pageIndexNotifier,
                              builder: (context, value, child) {
                                String title = _title[value];
                                String description = _description[value];

                                return SizedBox(
                                    height: context.height * 0.1,
                                    width: context.width,
                                    child: ListTile(
                                      //titre
                                      title: AppText(
                                        text: title,
                                        fontSize: context.mediumText,
                                        fontWeight: FontWeight.bold,
                                      ),

                                      //description
                                      subtitle: AppText(
                                        text: description,
                                        fontSize: context.smallText * 1.2,
                                        overflow: TextOverflow.visible,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary
                                            .withAlpha(200),
                                        maxLine: 2,
                                      ),
                                    ));
                              },
                            );
                          })),
                        ),
                        SizedBox(
                          height: context.height * 0.08,
                          width: context.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(_pages.length, (index) {
                              /* ValueListenableBuilder : J'ai utilisé ValueListenableBuilder<int> autour de chaque AppTimelineTile pour reconstruire ces tuiles lorsque la valeur de _pageIndexNotifier change.*/
                              return ValueListenableBuilder<int>(
                                valueListenable: _pageIndexNotifier,
                                builder: (context, value, child) {
                                  Color tileColor = (value >= index)
                                      ? AppColors.primaryColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .background;
                                  Color iconColor = (value >= index)
                                      ? Colors.grey.shade200
                                      : Theme.of(context)
                                          .colorScheme
                                          .inverseSurface
                                          .withAlpha(
                                              60); //Colors.grey.shade600;
                                  Color lineColor = (value > index - 1)
                                      ? AppColors.primaryColor
                                      : Theme.of(context)
                                          .colorScheme
                                          .background;

                                  return AppTimelineTile(
                                    axis: TimelineAxis.horizontal,
                                    isFirst: index == 0,
                                    isLast: index == _pages.length - 1,
                                    index: index + 1,
                                    icon: _getIconForIndex(index),
                                    iconSize: context.mediumText * 1.5,
                                    iconColor: iconColor,
                                    color: tileColor,
                                    afterLineColor: lineColor,
                                    beforeLineColor: lineColor,
                                    afterLineWeight: 2,
                                    beforeLineWeight: 2,
                                    height: 40,
                                    onTap: () {
                                      print('''
                                   indexed ==> $index
                                  ''');
                                      setState(() {
                                        position = index;
                                        _pageViewController.jumpToPage(index);
                                        _pageIndexNotifier.value = position;
                                      });
                                    },
                                  );
                                },
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// le corps de la page
                BlocConsumer<StoreCreationBloc, StoreCreationState>(
                  listener: (context, state) {
                    // TODO: implement listener
                  },
                  builder: (context, state) {
                    return Positioned(
                      bottom: context.height * 0.01,
                      top: context.height * 0.26,
                      child: SizedBox(
                          height: context.height * 0.75,
                          width: context.width,
                          child: Stack(
                            children: [
                              /// les sous-pages
                              SizedBox(
                                height: context.height * 0.75,
                                width: context.width,
                                child: PageView.builder(
                                    itemCount: _pages.length,
                                    controller: _pageViewController,
                                    allowImplicitScrolling: true,
                                    onPageChanged: (index) {
                                      position = index;
                                      setState(() {
                                        _pageIndexNotifier.value = index;
                                      });
                                    },
                                    itemBuilder: (BuildContext context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SizedBox(
                                            height: 400,
                                            //width: 100,
                                            child: _pages[
                                                _pageIndexNotifier.value]),
                                      );
                                    }),
                              ),

                              // : Container(),
                            ],
                          )),
                    );
                  },
                ),

                /// bouton Passer
                position == _pages.length - 1
                    ? Container()
                    : Positioned(
                        top: context.height * 0.06,
                        right: 10,
                        child: Row(
                          mainAxisAlignment: position == 0
                              ? MainAxisAlignment.center
                              : MainAxisAlignment.spaceEvenly,
                          children: [
                            //bouton Passer
                            GestureDetector(
                              onTap: () {
                                _pageViewController.nextPage(
                                    duration: const Duration(milliseconds: 10),
                                    curve: Curves.linear);
                                position = _pageViewController.page!.toInt();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.deepOrange),
                                  child: position != _pages.length - 1
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            'Passer',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: context.mediumText),
                                          ),
                                        )
                                      : Text(
                                          'Aller',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: context.mediumText),
                                        )),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                height: context.height * 0.07,
                width: context.width,
                child: Row(
                  mainAxisAlignment: position == 0
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    //bouton suivant
                    GestureDetector(
                      onTap: () {
                        _pageViewController.nextPage(
                          duration: const Duration(milliseconds: 10),
                          curve: Curves.linear,
                        );
                        position = _pageViewController.page!.toInt();
                        if (position == _pages.length - 1) {
                          Navigator.pushNamed(
                              context, AppRoutes.VENDEURMAINPAGE);
                        }
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                            left: 0,
                            //context.width * 0.03,
                            right: 0,
                          ),
                          //context.width * 0.03),
                          child: Container(
                              alignment: Alignment.center,
                              height: context.height * 0.07,
                              width: context.width * 0.9,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: AppColors.primaryColor),
                              child: position != _pages.length - 1
                                  ? Text(
                                      'Suivant',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: context.mediumText * 1.2),
                                    )
                                  : Text(
                                      'Soumettre',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: context.mediumText * 1.2),
                                    ))),
                    ),
                  ],
                ),
              ),
            )));
  }

  /*Retourne l'icône correspondant à l'index passé en paramètre.*/
  /*Méthode _getIconForIndex pour obtenir l'icône appropriée pour chaque AppTimelineTile en fonction de son index.*/
  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.storefront;
      case 1:
        return Icons.grid_view_rounded;
      case 2:
        return Icons.credit_card;
      case 3:
        return Icons.motorcycle;
      /*case 4:
        return Icons.fingerprint_sharp;*/
      case 4:
        return Icons.all_inclusive;
      default:
        return Icons.circle;
    }
  }

// Widget page4 = FiscalitePage(indexSuivant: 3);

  @override
  void dispose() {
    _pageIndexNotifier.dispose();
    _pageViewController.dispose();
    super.dispose();
  }
}
