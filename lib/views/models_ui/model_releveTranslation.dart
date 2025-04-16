import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ModelReleveTranslation extends StatefulWidget {
  final String dateTranslation;
  final String heureTranslation;
  final String montantTranslation;
  final String idTranslation;
  final String typeTranslation;
  final String taxeTranslation;

  const ModelReleveTranslation(
      {super.key,
      required this.dateTranslation,
      required this.heureTranslation,
      required this.montantTranslation,
      required this.idTranslation,
      required this.typeTranslation,
      required this.taxeTranslation});

  @override
  State<ModelReleveTranslation> createState() => _ModelReleveTranslationState();
}

class _ModelReleveTranslationState extends State<ModelReleveTranslation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: appHeightSize(context) * 0.17,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  blurRadius: 3.0,
                  spreadRadius: 1.0,
                  offset: const Offset(1, 1.5),
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.5)),
            ],
            color: Theme.of(context).colorScheme.surface),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// date de translation et montant
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppText(
                    text:
                        '${widget.dateTranslation} | ${widget.heureTranslation}',
                    fontWeight: FontWeight.w800,
                    fontSize: mediumText(),
                  ),
                  AppText(
                    text: widget.typeTranslation.toLowerCase() != 'sortie'
                        ? '+ ${widget.montantTranslation} F CFA'
                        : '- ${widget.montantTranslation} F CFA',
                    fontWeight: FontWeight.w800,
                    color: widget.typeTranslation.toLowerCase() != 'sortie'
                        ? primaryColor
                        : Colors.red.shade700,
                    fontSize: mediumText(),
                  ),
                ],
              ),
            ),

            /// les attributs de la translations
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  /// le trait vertical
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: appHeightSize(context) * 0.07,
                      width: 3,
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.7),
                    ),
                  ),

                  /// les différents attributs de la translation
                  Column(
                    children: [
                      SizedBox(
                        width: appWidthSize(context) * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Translation ID:',
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.7),
                              fontSize: smallText() * 1.1,
                            ),
                            AppText(
                              text: widget.idTranslation,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.7),
                              fontSize: smallText() * 1.1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: appWidthSize(context) * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Type de translation:',
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.7),
                              fontSize: smallText() * 1.1,
                            ),
                            AppText(
                              text: widget.typeTranslation,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.7),
                              fontSize: smallText() * 1.1,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: appWidthSize(context) * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: 'Taxe:',
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.7),
                              fontSize: smallText() * 1.1,
                            ),
                            AppText(
                              text: '${widget.taxeTranslation} F CFA',
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.7),
                              fontSize: smallText() * 1.1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
