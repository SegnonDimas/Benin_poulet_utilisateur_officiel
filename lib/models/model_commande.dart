import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../widgets/app_text.dart';

class ModelCommande extends StatelessWidget {
  final String nomClient;
  final String prix;
  final String idCommande;
  final String destination;
  final String? date;
  final int? duree;

  const ModelCommande(
      {super.key,
      required this.nomClient,
      required this.prix,
      required this.idCommande,
      required this.destination,
      this.date = "3 min",
      this.duree});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: appHeightSize(context) * 0.005,
        bottom: appHeightSize(context) * 0.01,
        left: appWidthSize(context) * 0.02,
        right: appWidthSize(context) * 0.02,
      ),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).colorScheme.background,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  blurRadius: 3,
                  offset: const Offset(3, 4),
                  blurStyle: BlurStyle.inner),
              BoxShadow(
                  color: //Colors.red,
                      Theme.of(context).colorScheme.surface.withOpacity(0.9),
                  blurRadius: 1,
                  blurStyle: BlurStyle.inner,
                  spreadRadius: 0)
            ]),
        padding: EdgeInsets.only(
          top: appHeightSize(context) * 0.01,
          bottom: appHeightSize(context) * 0.01,
          left: appWidthSize(context) * 0.04,
          right: appWidthSize(context) * 0.02,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: nomClient,
                  color: primaryColor,
                ),
                SizedBox(
                  //width: appWidthSize(context) * 0.4,
                  child: Row(
                    children: [
                      AppText(text: '${prix}F'),
                      const SizedBox(
                        width: 10,
                      ),
                      AppText(
                        text: '#$idCommande',
                        fontSize: smallText(),
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.5),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  //width: appWidthSize(context) * 0.4,
                  child: Row(
                    children: [
                      AppText(
                        text: destination,
                        fontSize: smallText() * 1.1,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.5),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AppText(
                        text: date!,
                        color: primaryColor,
                      )
                    ],
                  ),
                )
              ],
            ),
            CircularCountDownTimer(
              width: appHeightSize(context) * 0.07,
              height: appHeightSize(context) * 0.07,
              duration: duree ?? 10800,
              isReverse: true,
              fillColor: Theme.of(context).colorScheme.inversePrimary,
              //Theme.of(context).colorScheme.surface,
              ringColor: primaryColor,
              strokeWidth: 3.0,
              textStyle: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontSize: smallText(),
                  fontWeight: FontWeight.w800),
              onChange: (dureeRestante) {
                //print(dureeRestante);
              },
            )
          ],
        ),
      ),
    );
  }
}
