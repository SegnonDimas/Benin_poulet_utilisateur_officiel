import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../widgets/app_timeline_tile.dart';

class TimelineTilePage extends StatefulWidget {
  const TimelineTilePage({super.key});

  @override
  State<TimelineTilePage> createState() => _TimelineTilePageState();
}

class _TimelineTilePageState extends State<TimelineTilePage> {
  int pageIndex = 0;

  /*Suivre l'index de la page actuelle. Cela permet d'écouter les changements de valeur et de reconstruire les AppTimelineTile en conséquence.*/
  final ValueNotifier<int> _pageIndexNotifier = ValueNotifier<int>(0);

  final List<String> _title = [
    'Commençons à créer votre boutique',
    'Que vendez-vous ?',
    'Où devrions-nous verser vos fonds ?',
    'Pouvons-nous assurer vos livraisons ?',
    'Vérifions votre identité',
  ];

  final List<String> _description = [
    'Dites-nous-en plus sur votre boutique',
    'Aidez les clients à comprendre ce que votre boutique offre',
    'Vos informations sont chiffrées de bout en bout',
    'Confier vos livraisons à notre flotte de livreur expérimentée',
    'Tous nos vendeurs sont vérifiés pour rassurer nos clients',
  ];

  final List<Widget> _pages = [
    Container(
      color: Colors.grey.shade300,
      height: 200,
      width: 300,
    ),
    Container(
      color: Colors.grey,
      height: 200,
      width: 300,
    ),
    Container(
      color: Colors.grey.shade400,
      height: 400,
      width: 300,
    ),
    Container(
      color: Colors.grey.shade300,
      height: 200,
      width: 100,
    ),
    Container(
      color: Colors.grey.shade400,
      height: 200,
      width: 200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: AppText(
              text: 'Bénin Poulet',
              fontSize: largeText() * 1.2,
              color: primaryColor,
            ),
          ),
          SizedBox(
            height: appHeightSize(context) * 0.1,
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
                      height: appHeightSize(context) * 0.1,
                      width: appWidthSize(context),
                      child: ListTile(
                        title: AppText(
                          text: title,
                          fontSize: mediumText(),
                          fontWeight: FontWeight.bold,
                        ),
                        subtitle: AppText(
                          text: description,
                          fontSize: smallText() * 1.2,
                        ),
                      ));
                },
              );
            })),
          ),
          SizedBox(
            height: appHeightSize(context) * 0.07,
            width: appWidthSize(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                /* ValueListenableBuilder : J'ai utilisé ValueListenableBuilder<int> autour de chaque AppTimelineTile pour reconstruire ces tuiles lorsque la valeur de _pageIndexNotifier change.*/
                return ValueListenableBuilder<int>(
                  valueListenable: _pageIndexNotifier,
                  builder: (context, value, child) {
                    Color tileColor =
                        (value >= index) ? primaryColor : Colors.grey.shade300;
                    Color iconColor = (value >= index)
                        ? Colors.grey.shade200
                        : Colors.grey.shade600;
                    Color lineColor = (value > index - 1)
                        ? primaryColor
                        : Colors.grey.shade300;

                    return AppTimelineTile(
                      axis: TimelineAxis.horizontal,
                      isFirst: index == 0,
                      isLast: index == 4,
                      index: index + 1,
                      icon: _getIconForIndex(index),
                      iconColor: iconColor,
                      color: tileColor,
                      afterLineColor: lineColor,
                      beforeLineColor: lineColor,
                      height: 40,
                    );
                  },
                );
              }),
            ),
          ),
          SizedBox(
              height: appHeightSize(context) * 0.8,
              width: appWidthSize(context),
              child: PageView.builder(
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    _pageIndexNotifier.value = index;
                  },
                  itemBuilder: (BuildContext context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 400, width: 100, child: _pages[index]),
                    );
                  })),
        ],
      ),
    );
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
        return Icons.euro;
      case 3:
        return Icons.motorcycle;
      case 4:
        return Icons.fingerprint_sharp;
      default:
        return Icons.circle;
    }
  }
}
