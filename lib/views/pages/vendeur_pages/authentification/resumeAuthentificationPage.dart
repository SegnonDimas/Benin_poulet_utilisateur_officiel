import 'package:benin_poulet/bloc/storeCreation/store_creation_bloc.dart';
import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/model_resumeTextFormFiel.dart';

class ResumeAuthentificationPage extends StatefulWidget {
  @override
  State<ResumeAuthentificationPage> createState() =>
      _ResumeAuthentificationPageState();
}

class _ResumeAuthentificationPageState
    extends State<ResumeAuthentificationPage> {
  @override
  Widget build(BuildContext context) {
    final storeInfoState =
        context.watch<StoreCreationBloc>().state as StoreCreationGlobalState;
    ;
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
          ModelResumeTextField(
            attribut: 'Nom',
            valeur: storeInfoState.sellerLastName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Prenom',
            valeur: storeInfoState.sellerFirstName,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Date et lieu de naissance',
            valeur:
                '${storeInfoState.sellerBirthDate} à ${storeInfoState.sellerBirthPlace}',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          ModelResumeTextField(
            attribut: 'Adresse',
            valeur: storeInfoState.storeEmail,
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
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
}
