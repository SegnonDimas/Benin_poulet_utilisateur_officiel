import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

import '../../../../models/model_resumeTextFormFiel.dart';

class ResumePage extends StatefulWidget {
  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  @override
  Widget build(BuildContext context) {
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
          const ModelResumeTextField(
            attribut: 'Nom',
            valeur: 'Nom',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ModelResumeTextField(
            attribut: 'Prenom',
            valeur: 'Prenom',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ModelResumeTextField(
            attribut: 'Date et lieu de naissance',
            valeur: 'DD/MM/YYYY-Lieu',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ModelResumeTextField(
            attribut: 'Adresse',
            valeur: 'Adresse',
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
