import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../widgets/app_text.dart';

class ModelCommande extends StatelessWidget {
  final String nomClient;
  final String prix;
  final String idCommande;
  final String destination;
  final String? date;
  const ModelCommande(
      {super.key,
      required this.nomClient,
      required this.prix,
      required this.idCommande,
      required this.destination,
      this.date = "3 min"});

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
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.2),
                  blurRadius: 3,
                  offset: const Offset(2, 5),
                  blurStyle: BlurStyle.inner),
              BoxShadow(
                  color: //Colors.red,
                      Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.2),
                  blurRadius: 5,
                  blurStyle: BlurStyle.inner,
                  spreadRadius: 1)
            ]),
        padding: EdgeInsets.only(
          top: appHeightSize(context) * 0.01,
          bottom: appHeightSize(context) * 0.01,
          left: appWidthSize(context) * 0.04,
          right: appWidthSize(context) * 0.02,
        ),
        child: Column(
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
      ),
    );
  }
}
