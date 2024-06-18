import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/infoPersonnellePage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/photoPage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/pieceIdentitePage.dart';
import 'package:benin_poulet/views/pages/vendeur_pages/authentification/resumePage.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../widgets/app_timeline_tile.dart';

class AuthentificationVendeurPage extends StatefulWidget {
  const AuthentificationVendeurPage({super.key});

  @override
  State<AuthentificationVendeurPage> createState() =>
      _AuthentificationVendeurPageState();
}

class _AuthentificationVendeurPageState
    extends State<AuthentificationVendeurPage> {
  int pageIndex = 0;

  /*Suivre l'index de la page actuelle. Cela permet d'écouter les changements de valeur et de reconstruire les AppTimelineTile en conséquence.*/
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);
  final PageController _pageViewController = PageController();

  final List<String> _title = [
    'Informations personnelles',
    'Vérification intermédiaire',
    'Vérification intermédiaire',
    'Résumé de vos informations',
  ];

  final List<String> _description = [
    'Mettez des informations correctes et vérifiées',
    'Mettez des informations correctes et vérifiées',
    'Mettez des informations correctes et vérifiées',
    'Rassurez-vous avoir mis des informations correctes, vérifiées et valides',
  ];

  final List<Widget> _pages = [
    // page 1 : infos personnelles
    InfoPersonnellePage(),

    // page 2 : pièce d'identité
    PieceIdentitePage(),

    // page 3 : page photo
    PhotoPage(),

    // page 4 : page Resumé
    ResumePage(),
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
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          child: Stack(
            //crossAxisAlignment: CrossAxisAlignment.start,
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              /// l'en-tête de la page
              Positioned(
                top: appHeightSize(context) * 0.0,
                child: SizedBox(
                  height: appHeightSize(context) * 0.2,
                  child: Column(
                    children: [
                      // timeline_tile
                      SizedBox(
                        height: appHeightSize(context) * 0.06,
                        width: appWidthSize(context) * 0.75,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_pages.length, (index) {
                            /* ValueListenableBuilder : J'ai utilisé ValueListenableBuilder<int> autour de chaque AppTimelineTile pour reconstruire ces tuiles lorsque la valeur de _pageIndexNotifier change.*/
                            return ValueListenableBuilder<int>(
                              valueListenable: _pageIndexNotifier,
                              builder: (context, value, child) {
                                Color tileColor = (value >= index)
                                    ? primaryColor.withAlpha(100)
                                    : Theme.of(context).colorScheme.surface;
                                Color iconColor = (value >= index)
                                    ? primaryColor //Colors.grey.shade200
                                    : Theme.of(context)
                                        .colorScheme
                                        .inverseSurface
                                        .withAlpha(60); //Colors.grey.shade600;
                                Color lineColor = (value > index - 1)
                                    ? primaryColor.withAlpha(100)
                                    : Theme.of(context).colorScheme.surface;

                                return AppTimelineTile(
                                  axis: TimelineAxis.horizontal,
                                  isFirst: index == 0,
                                  isLast: index == _pages.length - 1,
                                  index: index + 1,
                                  icon: _getIconForIndex(index),
                                  iconSize: 15, //mediumText() * 1.5,
                                  iconColor: iconColor,
                                  color: tileColor,
                                  afterLineColor: lineColor,
                                  beforeLineColor: lineColor,
                                  afterLineWeight: 2,
                                  beforeLineWeight: 2,
                                  height: 25,
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

                      // titre et description
                      SizedBox(
                        height: appHeightSize(context) * 0.11,
                        width: appWidthSize(context),
                        child: Wrap(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(1, (index) {
                          return ValueListenableBuilder<int>(
                            valueListenable: _pageIndexNotifier,
                            builder: (context, value, child) {
                              String title = _title[value];
                              String description = _description[value];

                              return SizedBox(
                                  height: appHeightSize(context) * 0.12,
                                  width: appWidthSize(context),
                                  child: Column(
                                    children: [
                                      // Étape n/N
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left:
                                                appHeightSize(context) * 0.02),
                                        child: SizedBox(
                                          height: appHeightSize(context) * 0.02,
                                          width: appWidthSize(context),
                                          child: AppText(
                                              text:
                                                  'Étape ${value + 1}/${_pages.length}'),
                                        ),
                                      ),

                                      // titre et description
                                      SizedBox(
                                        height: appHeightSize(context) * 0.09,
                                        width: appWidthSize(context),
                                        child: ListTile(
                                          //titre
                                          title: AppText(
                                            text: title,
                                            fontSize: mediumText(),
                                            fontWeight: FontWeight.bold,
                                          ),

                                          //description
                                          subtitle: AppText(
                                            text: description,
                                            fontSize: smallText() * 1.2,
                                            overflow: TextOverflow.visible,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary
                                                .withAlpha(200),
                                            maxLine: 2,
                                          ),
                                        ),
                                      ),

                                      // divider
                                      SizedBox(
                                        height: appHeightSize(context) * 0.008,
                                        child: Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .surface,
                                        ),
                                      ),
                                    ],
                                  ));
                            },
                          );
                        })),
                      ),
                    ],
                  ),
                ),
              ),

              /// le corps de la page
              Positioned(
                bottom: appHeightSize(context) * 0.0,
                top: appHeightSize(context) * 0.17,
                child: SizedBox(
                    height: appHeightSize(context) * 0.75,
                    width: appWidthSize(context),
                    child: Stack(
                      children: [
                        /// les sous-pages
                        SizedBox(
                          height: appHeightSize(context) * 0.68,
                          width: appWidthSize(context),
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
                                      child: _pages[_pageIndexNotifier.value]),
                                );
                              }),
                        ),

                        /// bouton Suivant/précédent
                        Positioned(
                          bottom: appHeightSize(context) * 0.0,
                          child: SizedBox(
                            height: appHeightSize(context) * 0.07,
                            width: appWidthSize(context),
                            child: Row(
                              mainAxisAlignment: position == 0
                                  ? MainAxisAlignment.center
                                  : MainAxisAlignment.spaceEvenly,
                              children: [
                                //bouton suivant
                                GestureDetector(
                                  onTap: () {
                                    if (position == _pages.length - 1) {
                                      Navigator.pushReplacementNamed(
                                          context, '/validationPage');
                                    } else {
                                      //_pageController.nextPage(duration: const Duration(microseconds: 3500), curve: Curves.easeIn);
                                      _pageViewController.nextPage(
                                          duration: const Duration(
                                              milliseconds: 1000),
                                          curve: Curves.linear);
                                      position =
                                          _pageViewController.page!.toInt();
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 0, //appWidthSize(context) * 0.03,
                                      right: 0,
                                    ), //appWidthSize(context) * 0.03),
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: appHeightSize(context) * 0.07,
                                        width: position == 0
                                            ? appWidthSize(context) * 0.9
                                            : appWidthSize(context) * 0.9,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: primaryColor),
                                        child: position != _pages.length - 1
                                            ? Text(
                                                'Suivant',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        mediumText() * 1.2),
                                              )
                                            : Text(
                                                'Soumettre',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        mediumText() * 1.2),
                                              )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*Retourne l'icône correspondant à l'index passé en paramètre.*/
  /*Méthode _getIconForIndex pour obtenir l'icône appropriée pour chaque AppTimelineTile en fonction de son index.*/
  /*IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.storefront;
      case 1:
        return Icons.grid_view_rounded;
      case 2:
        return Icons.credit_card;
      case 3:
        return Icons.motorcycle;
      case 4:
        return Icons.fingerprint_sharp;
      default:
        return Icons.circle;
    }
  }*/

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0:
        return Icons.circle;
      case 1:
        return Icons.circle;
      case 2:
        return Icons.circle;
      case 3:
        return Icons.circle;
      case 4:
        return Icons.circle;
      default:
        return Icons.circle;
    }
  }

// Widget page4 = FiscalitePage(indexSuivant: 3);
}
