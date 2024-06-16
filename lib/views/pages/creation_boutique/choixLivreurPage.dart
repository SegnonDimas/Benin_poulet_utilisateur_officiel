import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_textField.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../widgets/app_text.dart';
import '../../colors/app_colors.dart';
import '../../sizes/text_sizes.dart';

class ChoixLivreurPage extends StatefulWidget {
  const ChoixLivreurPage({super.key});

  @override
  State<ChoixLivreurPage> createState() => _ChoixLivreurPageState();
}

class _ChoixLivreurPageState extends State<ChoixLivreurPage> {
  final _controllerOui = SuperTooltipController();
  final _controllerNon = SuperTooltipController();
  final TextEditingController _emplacementController = TextEditingController();
  String _smartSolutions = 'OUI';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            // le choix du livreur
            SizedBox(
              height: appHeightSize(context) * 0.05,
              width: appWidthSize(context) * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SuperTooltip(
                    showBarrier: true,
                    controller: _controllerOui,
                    popupDirection: TooltipDirection.up,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    left: appWidthSize(context) * 0.05,
                    right: appWidthSize(context) * 0.05,
                    arrowTipDistance: 15.0,
                    arrowBaseWidth: 20.0,
                    arrowLength: 15.0,
                    borderWidth: 0.0,
                    constraints: BoxConstraints(
                      minHeight: appHeightSize(context) * 0.03,
                      maxHeight: appHeightSize(context) * 0.3,
                      minWidth: appWidthSize(context) * 0.3,
                      maxWidth: appWidthSize(context) * 0.7,
                    ),
                    showCloseButton: ShowCloseButton.none,
                    touchThroughAreaShape: ClipAreaShape.rectangle,
                    touchThroughAreaCornerRadius: 30,
                    barrierColor: const Color.fromARGB(26, 47, 55, 47),
                    content: AppText(
                      text:
                          'Nous engagerons nos partenaires professionnels pour assurer vos livraisons pour des raisons de sécurité',
                      overflow: TextOverflow.visible,
                    ),
                    child: SizedBox(
                      height: appHeightSize(context) * 0.05,
                      width: appWidthSize(context) * 0.4,
                      child: ListTile(
                        title: AppText(
                          text: 'OUI',
                          fontSize: smallText() * 1.3,
                          fontWeight: _smartSolutions == 'OUI'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _smartSolutions == 'OUI'
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withAlpha(50),
                        ),
                        leading: Radio<String>(
                          value: 'OUI',
                          groupValue: _smartSolutions,
                          activeColor: primaryColor,
                          focusColor: Colors.grey,
                          hoverColor: Colors.grey,
                          onChanged: (String? value) {
                            setState(() {
                              _smartSolutions = value!;
                            });
                          },
                        ),
                        horizontalTitleGap: 0,
                      ),
                    ),
                  ),
                  SuperTooltip(
                    showBarrier: true,
                    controller: _controllerNon,
                    popupDirection: TooltipDirection.up,
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    left: appWidthSize(context) * 0.05,
                    right: appWidthSize(context) * 0.05,
                    arrowTipDistance: 15.0,
                    arrowBaseWidth: 20.0,
                    arrowLength: 15.0,
                    borderWidth: 0.0,
                    constraints: BoxConstraints(
                      minHeight: appHeightSize(context) * 0.03,
                      maxHeight: appHeightSize(context) * 0.3,
                      minWidth: appWidthSize(context) * 0.3,
                      maxWidth: appWidthSize(context) * 0.7,
                    ),
                    showCloseButton: ShowCloseButton.none,
                    touchThroughAreaShape: ClipAreaShape.rectangle,
                    touchThroughAreaCornerRadius: 30,
                    barrierColor: const Color.fromARGB(26, 47, 55, 47),
                    content: AppText(
                      text:
                          'Pour l\'instant vous ne pouvez pas livrer vos produits vous-même',
                      overflow: TextOverflow.visible,
                    ),
                    child: SizedBox(
                      height: appHeightSize(context) * 0.05,
                      width: appWidthSize(context) * 0.4,
                      child: ListTile(
                        title: AppText(
                          text: 'NON',
                          fontSize: smallText() * 1.3,
                          fontWeight: _smartSolutions == 'NON'
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: _smartSolutions == 'NON'
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context)
                                  .colorScheme
                                  .inverseSurface
                                  .withAlpha(50),
                        ),
                        leading: Radio<String>(
                          value: 'NON',
                          groupValue: _smartSolutions,
                          activeColor: primaryColor,
                          focusColor: Colors.grey,
                          hoverColor: Colors.grey,
                          autofocus: true,
                          toggleable: true,
                          onChanged: (String? value) {
                            setState(() {
                              //_smartSolutions = value!;
                            });
                          },
                        ),
                        horizontalTitleGap: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            AppText(
              text:
                  'Pour l\'instant, vous ne pouvez pas livrer vos produits vous-même',
              color: Theme.of(context).colorScheme.inverseSurface.withAlpha(40),
              overflow: TextOverflow.visible,
              fontSize: mediumText() * 0.8,
            ),
            const SizedBox(
              height: 10,
            ),

            // divider
            Divider(
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(
              height: 20,
            ),

            // description de l'emplacement
            AppText(
              text:
                  'Spécifier l\'emplacement de votre boutique pour la récupération des commandes par nos livreurs',
              overflow: TextOverflow.visible,
              fontSize: mediumText() * 0.8,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextField(
              label:
                  '', //'Calavi Kpota dans la von de l\'agence Celtiis Bénin',
              height: appHeightSize(context) * 0.08,
              width: appWidthSize(context) * 0.9,
              controller: _emplacementController,
              prefixIcon: Icons.not_listed_location_rounded,
              color: Theme.of(context).colorScheme.surface,
              //maxLines: 3,
              expands: true,
            ),

            /// CRITIQUÉ : car le vendeur peut être en train de créer son compte hors de sa boutique
            // partage de l'emplacement
            const SizedBox(
              height: 20,
            ),
            AppText(
              text: 'Veuillez partager avec nous votre emplacement',
              overflow: TextOverflow.visible,
              fontSize: mediumText() * 0.8,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(
              height: 10,
            ),
            AppTextField(
              label:
                  '', //'Calavi Kpota dans la von de l\'agence Celtiis Bénin',
              height: appHeightSize(context) * 0.08,
              width: appWidthSize(context) * 0.9,
              controller: _emplacementController,
              prefixIcon: Icons.location_on_outlined,
              color: Theme.of(context).colorScheme.surface,
              maxLines: 3,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
