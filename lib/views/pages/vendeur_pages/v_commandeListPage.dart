import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    const ModelCommande(
      nomClient: 'Hippolyte',
      prix: '2400',
      idCommande: '350A45',
      destination: 'Zogbadjè',
      duree: 2000,
    ),
    const ModelCommande(
      nomClient: 'Mike',
      prix: '3000',
      idCommande: '4506B1',
      destination: 'Calavi Kpota',
      duree: 200,
    ),
  ];

  String _statutSelected = 'En attente';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: 'Commandes'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: appHeightSize(context),
          child: Column(
            children: [
              /// nombre de commandes + choix de commandes à afficher
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
                        width: appWidthSize(context) * 0.35,
                        decoration: BoxDecoration(
                          color: _statutSelected == 'Actifs'
                              ? primaryColor
                              : _statutSelected == 'En attente'
                                  ? Colors.amber
                                  : _statutSelected == 'Annulées'
                                      ? Colors.redAccent
                                      : Theme.of(context)
                                          .colorScheme
                                          .background,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: DropdownButton<String>(
                          underline: Container(),
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

              //espace
              SizedBox(
                height: appHeightSize(context) * 0.01,
              ),

              /// liste des commandes
              Expanded(child: ListView(children: _listCommande)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Theme.of(context).colorScheme.background,
        onTap: (index) {
          // index;
        },
        items: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.notifications_active_outlined),
              AppText(
                text: 'Nouvelles',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hourglass_top_rounded),
              AppText(
                text: 'En cours',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.shopping_cart_checkout_outlined),
              AppText(
                text: 'Prêtes',
                fontSize: smallText() * 0.8,
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history_edu_outlined),
              AppText(
                text: 'Historique',
                fontSize: smallText() * 0.8,
              ),
            ],
          )
        ],
      ),
    );
  }
}
