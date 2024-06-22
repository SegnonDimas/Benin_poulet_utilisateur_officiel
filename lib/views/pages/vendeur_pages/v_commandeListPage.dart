import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../../models/model_commande.dart';

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
