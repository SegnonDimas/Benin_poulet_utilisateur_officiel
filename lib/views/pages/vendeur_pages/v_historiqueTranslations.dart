import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../models_ui/model_releveTranslation.dart';

class VHistoriqueTranslations extends StatefulWidget {
  const VHistoriqueTranslations({super.key});

  @override
  State<VHistoriqueTranslations> createState() =>
      _VHistoriqueTranslationsState();
}

class _VHistoriqueTranslationsState extends State<VHistoriqueTranslations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: AppText(text: 'Historique Translations'),
          centerTitle: true,
        ),
        body: ListView(
          children: const [
            ModelReleveTranslation(
                dateTranslation: '08 Sep 2024',
                heureTranslation: '16:41',
                montantTranslation: '7500',
                idTranslation: '8064122275',
                typeTranslation: 'Entrée',
                taxeTranslation: '75'),
            ModelReleveTranslation(
                dateTranslation: '10 Sep 2024',
                heureTranslation: '16:41',
                montantTranslation: '7500',
                idTranslation: '8064122275',
                typeTranslation: 'Sortie',
                taxeTranslation: '75'),
            ModelReleveTranslation(
                dateTranslation: '08 Sep 2024',
                heureTranslation: '16:41',
                montantTranslation: '7500',
                idTranslation: '8064122275',
                typeTranslation: 'Sortie',
                taxeTranslation: '75'),
            ModelReleveTranslation(
                dateTranslation: '08 Sep 2024',
                heureTranslation: '16:41',
                montantTranslation: '7500',
                idTranslation: '8064122275',
                typeTranslation: 'Entrée',
                taxeTranslation: '75'),
          ],
        ));
  }
}
