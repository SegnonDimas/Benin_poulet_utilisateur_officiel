import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

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
    const ModelSession(title: 'Campage'),
    const ModelSession(title: 'Statistiques'),
    const ModelSession(title: 'Mon profil'),
  ];

  @override
  Widget build(BuildContext context) {
    const SizedBox espace = SizedBox(
      height: 20,
    );

    /// corps de la page
    return ListView(
      children: [
        /// texte de bienvenue
        SizedBox(
            height: appHeightSize(context) * 0.1,
            width: appWidthSize(context),
            child: ListTile(
              title: AppText(
                text: 'Salut, Le Poulailler!',
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
          solde: 400000,
        ),

        /// liste des sessions
        SizedBox(
          width: appWidthSize(context),
          height: appHeightSize(context) * 0.15,
          child: ListView(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.only(
                left: appWidthSize(context) * 0.05,
                right: appWidthSize(context) * 0.05),
            children: _sessions,
          ),
        ),
      ],
    );
  }
}
