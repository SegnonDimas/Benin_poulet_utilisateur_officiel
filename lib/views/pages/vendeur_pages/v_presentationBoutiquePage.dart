import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/store_review_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

import '../../models_ui/model_attributBoutique.dart';

class VPresentationBoutiquePage extends StatefulWidget {
  const VPresentationBoutiquePage({super.key});

  @override
  State<VPresentationBoutiquePage> createState() =>
      _VPresentationBoutiquePageState();
}

class _VPresentationBoutiquePageState extends State<VPresentationBoutiquePage> {
  final int pourcentageProfil = 90;
  final String nomBoutique = 'Le Poulailler';
  final double shopNote = 4.5;
  final double balanceMonetaire = 45000;
  final int dureeMin = 20;
  final int dureeMax = 35;
  final List<String> avisClients = [
    'Service client bien rendu',
    'Livraison rapide',
    'Le produit livré est de qualité meilleure. Je compte revenir pour d\'autres produits' +
        'Le produit livré est de qualité meilleure. Je compte revenir pour d\'autres produits' +
        'Le produit livré est de qualité meilleure. Je compte revenir pour d\'autres produits',
    'Super',
    'Je recommande vivement',
    'je suis satisfait'
  ];
  bool voirAvisClient = false;

  // Nouvelles données pour les champs manquants
  final String description =
      'Boutique spécialisée dans la vente de poulets frais et de qualité. Nous proposons une large gamme de produits avicoles pour satisfaire tous vos besoins.';
  final String ville = 'Cotonou';
  final String pays = 'Bénin';
  final String zoneLivraison = 'Cotonou, Abomey-Calavi, Ouidah';
  final String tempsLivraison = '30-60 minutes';
  final Map<String, String> joursOuverture = {
    'Lundi': '08:00-18:00',
    'Mardi': '08:00-18:00',
    'Mercredi': '08:00-18:00',
    'Jeudi': '08:00-18:00',
    'Vendredi': '08:00-18:00',
    'Samedi': '08:00-18:00',
    'Dimanche': '08:00-18:00',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// appBar
      appBar: AppBar(
        title: AppText(
          text: 'Ma boutique',
        ),
      ),

      /// corps de la page
      body: ListView(
        children: [
          /// les attributs de la boutique (profil, miniature, attibuts, sous-secteurs....)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              //height: appHeightSize(context) * 0.5,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// niveau du profil
                  SizedBox(
                    //width: appWidthSize(context) * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AppText(text: 'Compléter votre profil'),
                        AppText(
                          text: '$pourcentageProfil% complété',
                          color: primaryColor,
                          fontSize: smallText(),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  /// indicateur du niveau du profil
                  LinearProgressIndicator(
                    value: pourcentageProfil.toDouble() / 100,
                    backgroundColor: primaryColor.withOpacity(0.15),
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(20),
                    minHeight: 8,
                  ),

                  /// miature et logo de la boutique
                  Padding(
                    padding:
                        EdgeInsets.only(top: appHeightSize(context) * 0.01),
                    child: SizedBox(
                      height: appHeightSize(context) * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          alignment: Alignment.bottomLeft,
                          children: [
                            // miniature
                            Positioned(
                              top: 0,
                              bottom: appHeightSize(context) * 0.06,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: appHeightSize(context) * 0.3,
                                //width: appWidthSize(context) * 0.85,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary
                                          .withOpacity(0.7)),
                                  image: const DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'assets/images/pouletCouveuse.png',
                                    ),
                                  ),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),

                            // texte : miniature
                            Positioned(
                                right: appWidthSize(context) * 0.05,
                                top: appHeightSize(context) * 0.02,
                                child: AppButton(
                                    height: appHeightSize(context) * 0.035,
                                    width: appWidthSize(context) * 0.22,
                                    bordeurRadius: 5,
                                    borderColor: primaryColor,
                                    color: primaryColor.withOpacity(0.5),
                                    child: AppText(
                                      text: 'Miniature',
                                      fontSize: smallText(),
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                    onTap: () {})),

                            // logo boutique
                            Positioned(
                              bottom: 0,
                              left: appWidthSize(context) * 0.06,
                              //right: 0,
                              child: Container(
                                height: appHeightSize(context) * 0.12,
                                width: appHeightSize(context) * 0.125,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Positioned(
                                      left: 0,
                                      bottom: appHeightSize(context) * 0.01,
                                      top: 0,
                                      child: DottedBorder(
                                        color: primaryColor.withOpacity(0.8),
                                        // Couleur de la bordure
                                        strokeWidth: 1.5,
                                        // Largeur de la bordure
                                        dashPattern: const [5, 6],
                                        // Modèle des pointillés : longueur et espace
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(20),
                                        // Rayon des coins pour un effet arrondi
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: appHeightSize(context) * 0.11,
                                          width: appHeightSize(context) * 0.11,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Theme.of(context)
                                                .colorScheme
                                                .background,
                                            image: const DecorationImage(
                                              fit: BoxFit.cover,
                                              image: AssetImage(
                                                'assets/images/oeuf2.png',
                                              ),
                                            ),
                                          ),
                                          child: AppText(
                                            text: 'Logo',
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: CircleAvatar(
                                        radius: largeText() / 1.3,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .background,
                                        child: Icon(
                                          Icons.add_circle_outline_outlined,
                                          size: largeText() * 1.5,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// le nom de la boutique
                  AppText(
                    text: nomBoutique,
                    fontSize: largeText() * 0.9,
                    fontWeight: FontWeight.bold,
                  ),

                  /// description de la boutique
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Description',
                    fontSize: mediumText(),
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.7),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outline
                            .withOpacity(0.3),
                      ),
                    ),
                    child: AppText(
                      text: description,
                      fontSize: smallText(),
                      overflow: TextOverflow.visible,
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.8),
                    ),
                  ),

                  /// les attributs de la boutique
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.25,
                            icon: const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            value: "$shopNote",
                            description: '${avisClients.length} avis'),
                      ),
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.35,
                            icon: Icon(
                              Icons.recycling,
                              color: primaryColor,
                            ),
                            value: "$balanceMonetaire F",
                            description: 'Livraison'),
                      ),
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.35,
                            icon: const Icon(
                              Icons.timer_rounded,
                              color: Colors.deepPurple,
                            ),
                            value: "$dureeMin-$dureeMax",
                            description: 'Mins'),
                      )
                    ],
                  ),

                  /// nouveaux attributs de la boutique
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.25,
                            icon: Icon(
                              Icons.location_city,
                              color: primaryColor,
                            ),
                            value: ville,
                            description: 'Ville'),
                      ),
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.35,
                            icon: Icon(
                              Icons.public,
                              color: primaryColor,
                            ),
                            value: pays,
                            description: 'Pays'),
                      ),
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.35,
                            icon: Icon(
                              Icons.access_time,
                              color: primaryColor,
                            ),
                            value: tempsLivraison,
                            description: 'Livraison'),
                      )
                    ],
                  ),

                  /// zone de livraison
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: ModelAttributBoutique(
                            width: appWidthSize(context) * 0.5,
                            icon: Icon(
                              Icons.delivery_dining,
                              color: primaryColor,
                            ),
                            value: zoneLivraison,
                            description: 'Zone de livraison'),
                      ),
                    ],
                  ),

                  /// les sous-secteurs de la boutique
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      AppButton(
                          height: appHeightSize(context) * 0.04,
                          width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: 'Poulet'),
                          onTap: () {}),
                      AppButton(
                          height: appHeightSize(context) * 0.04,
                          width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: 'Boeuf'),
                          onTap: () {}),
                      AppButton(
                          height: appHeightSize(context) * 0.04,
                          width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: 'Restaurant'),
                          onTap: () {}),
                      AppButton(
                          height: appHeightSize(context) * 0.04,
                          //width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: 'Poulet gauliath'),
                          onTap: () {}),
                      AppButton(
                          height: appHeightSize(context) * 0.04,
                          width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: 'mouton'),
                          onTap: () {}),
                      AppButton(
                          height: appHeightSize(context) * 0.04,
                          width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: 'oeuf'),
                          onTap: () {}),
                    ],
                  )
                ],
              ),
            ),
          ),

          /// infos boutique
          // nom boutique
          ListTile(
            leading: const Icon(Icons.storefront),
            title: AppText(
              text: 'Nom de la boutique',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
              fontSize: mediumText(),
            ),
            subtitle: AppText(
              text: nomBoutique,
            ),
            trailing: Icon(
              Icons.edit_note_rounded,
              color: primaryColor,
            ),
          ),

          // Secteurs d'activité
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: AppText(
              text: 'Secteurs d\'activité',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
              fontSize: mediumText(),
            ),
            subtitle: Wrap(
              spacing: 5,
              runSpacing: 5,
              children: [
                AppButton(
                    height: appHeightSize(context) * 0.04,
                    width: appWidthSize(context) * 0.25,
                    color: Theme.of(context).colorScheme.background,
                    child: AppText(text: 'Poulet'),
                    onTap: () {}),
                AppButton(
                    height: appHeightSize(context) * 0.04,
                    width: appWidthSize(context) * 0.25,
                    color: Theme.of(context).colorScheme.background,
                    child: AppText(text: 'Boeuf'),
                    onTap: () {}),
                AppButton(
                    height: appHeightSize(context) * 0.04,
                    width: appWidthSize(context) * 0.25,
                    color: Theme.of(context).colorScheme.background,
                    child: AppText(text: 'Restaurant'),
                    onTap: () {}),
                AppButton(
                    height: appHeightSize(context) * 0.04,
                    //width: appWidthSize(context) * 0.25,
                    color: Theme.of(context).colorScheme.background,
                    child: AppText(text: 'Poulet gauliath'),
                    onTap: () {}),
                AppButton(
                    height: appHeightSize(context) * 0.04,
                    width: appWidthSize(context) * 0.25,
                    color: Theme.of(context).colorScheme.background,
                    child: AppText(text: 'mouton'),
                    onTap: () {}),
                AppButton(
                    height: appHeightSize(context) * 0.04,
                    width: appWidthSize(context) * 0.25,
                    color: Theme.of(context).colorScheme.background,
                    child: AppText(text: 'oeuf'),
                    onTap: () {}),
              ],
            ),
            isThreeLine: true,
          ),

          // Adresse boutique
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: AppText(
              text: 'Adresse de la boutique',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
              fontSize: mediumText(),
            ),
            subtitle: AppText(
              text: ville,
            ),
            trailing: Icon(
              Icons.edit_note_rounded,
              color: primaryColor,
            ),
          ),

          // Horaire boutique
          ListTile(
            leading: const Icon(Icons.timer_rounded),
            title: AppText(
              text: 'Heures d\'activité',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
              fontSize: mediumText(),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: joursOuverture.entries.map((entry) {
                return AppText(
                  text: '${entry.key}: ${entry.value}',
                  fontSize: smallText(),
                );
              }).toList(),
            ),
            trailing: Icon(
              Icons.edit_note_rounded,
              color: primaryColor,
            ),
          ),

          // Zone de livraison
          ListTile(
            leading: const Icon(Icons.delivery_dining),
            title: AppText(
              text: 'Zone de livraison',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
              fontSize: mediumText(),
            ),
            subtitle: AppText(
              text: zoneLivraison,
            ),
            trailing: Icon(
              Icons.edit_note_rounded,
              color: primaryColor,
            ),
          ),

          // Temps de livraison
          ListTile(
            leading: const Icon(Icons.access_time),
            title: AppText(
              text: 'Temps de livraison',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
              fontSize: mediumText(),
            ),
            subtitle: AppText(
              text: tempsLivraison,
            ),
            trailing: Icon(
              Icons.edit_note_rounded,
              color: primaryColor,
            ),
          ),

          /// avis clients
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              expandedAlignment: Alignment.topLeft,
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              leading: Icon(
                Icons.emoji_emotions_outlined,
                color: primaryColor,
                //color: Theme.of(context).colorScheme.background,
              ),
              title: AppText(
                text: 'Voir avis clients (${avisClients.length})',
                color: primaryColor,
              ),
              children: List.generate(avisClients.length, (index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: 'Avis ${index + 1}',
                        fontSize: smallText() * 1.1,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.4),
                      ),
                      AppText(
                        text: avisClients[index],
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          /// widget d'avis interactif
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: 'Système d\'avis interactif',
                  fontSize: mediumText(),
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.7),
                ),
                const SizedBox(height: 16),
                // Temporairement commenté en attendant la création de l'index Firestore
                // StoreReviewWidget(
                //   storeId:
                //       'store_id_example', // À remplacer par l'ID réel de la boutique
                //   userId:
                //       'user_id_example', // À remplacer par l'ID réel de l'utilisateur
                // ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                  ),
                  child: AppText(
                    text: 'Système d\'avis en cours de configuration...',
                    fontSize: smallText(),
                    color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
