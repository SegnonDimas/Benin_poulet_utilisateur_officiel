import 'package:benin_poulet/bloc/authentification/authentification_bloc.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models_ui/model_resumeTextFormFiel.dart';

class ResumeAuthentificationPage extends StatefulWidget {
  @override
  State<ResumeAuthentificationPage> createState() =>
      _ResumeAuthentificationPageState();
}

class _ResumeAuthentificationPageState
    extends State<ResumeAuthentificationPage> {
  @override
  Widget build(BuildContext context) {
    final sellerinfos = context.watch<AuthentificationBloc>().state
        as AuthentificationGlobalState;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.edit,
                size: mediumText(),
                color: primaryColor,
              ),
              AppText(
                text: "Modifier",
                color: primaryColor,
                fontSize: smallText() * 1.1,
              )
            ],
          ),

          // nom du vendeur
          ModelResumeTextField(
            attribut: 'Nom',
            valeur: sellerinfos.sellerLastName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),

          // prénom du vendeur
          ModelResumeTextField(
            attribut: 'Prenom',
            valeur: sellerinfos.sellerFirstName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),

          // date de naissance du vendeur
          ModelResumeTextField(
            attribut: 'Date et lieu de naissance',
            valeur:
                '${sellerinfos.sellerBirthDate} à ${sellerinfos.sellerBirthPlace}',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),

          // type de pièce d'identité du vendeur
          const ModelResumeTextField(
            attribut: 'Type de pièce',
            valeur: 'Type de pièce',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
