import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class VCommandeListPage extends StatefulWidget {
  const VCommandeListPage({super.key});

  @override
  State<VCommandeListPage> createState() => _VCommandeListPageState();
}

class _VCommandeListPageState extends State<VCommandeListPage> {
  final List<String> _statut = [
    'Actifs',
    'En attente',
    'Annulées',
  ];

  final List<ModelCommande> _listCommande = [
    const ModelCommande(
        nomClient: 'Hippolyte',
        prix: '2400',
        idCommande: '350A45',
        destination: 'Zogbadjè'),
    const ModelCommande(
        nomClient: 'Mike',
        prix: '3000',
        idCommande: '4506B1',
        destination: 'Calavi Kpota'),
  ];

  String _statutSelected = 'En attente';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: appHeightSize(context) * 0.06,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: AppText(text: '${_listCommande.length} commandes'),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Container(
                  alignment: Alignment.center,
                  height: appHeightSize(context) * 0.05,
                  width: appWidthSize(context) * 0.4,
                  decoration: BoxDecoration(
                    color: _statutSelected == 'Actifs'
                        ? primaryColor
                        : _statutSelected == 'En attente'
                            ? Colors.amber
                            : _statutSelected == 'Annulées'
                                ? Colors.redAccent
                                : Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButton<String>(
                    hint: AppText(
                      text: _statutSelected,
                      color: Colors.white,
                    ),
                    value: _statutSelected,
                    //focusColor: primaryColor,
                    items: _statut.map((String statut) {
                      return DropdownMenuItem<String>(
                        value: statut,
                        child: AppText(
                          text: statut,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _statutSelected = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: _listCommande,
          ),
        )
      ],
    );
  }
}

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
            AppText(text: nomClient),
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
