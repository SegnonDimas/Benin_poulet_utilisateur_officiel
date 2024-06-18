import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';

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
          const ResumeTextField(
            attribut: 'Nom',
            valeur: 'Nom',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ResumeTextField(
            attribut: 'Prenom',
            valeur: 'Prenom',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ResumeTextField(
            attribut: 'Date et lieu de naissance',
            valeur: 'DD/MM/YYYY-Lieu',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ResumeTextField(
            attribut: 'Adresse',
            valeur: 'Adresse',
          ),
          DottedLine(
            dashColor:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
          ),
          const ResumeTextField(
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

class ResumeTextField extends StatelessWidget {
  final String? attribut;
  final String? valeur;
  const ResumeTextField({super.key, this.attribut, this.valeur});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: appHeightSize(context) * 0.04, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(
            text: attribut!,
            color:
                Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
          ),
          AppText(
              text: valeur!,
              color: Theme.of(context).colorScheme.inversePrimary),
        ],
      ),
    );
  }
}
