import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:benin_poulet/widgets/store_review_widget.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models_ui/model_attributBoutique.dart';
import '../../../bloc/store/store_bloc.dart';
import '../../../core/firebase/auth/auth_services.dart';

class VPresentationBoutiquePage extends StatefulWidget {
  const VPresentationBoutiquePage({super.key});

  @override
  State<VPresentationBoutiquePage> createState() =>
      _VPresentationBoutiquePageState();
}

class _VPresentationBoutiquePageState extends State<VPresentationBoutiquePage> {
  final int pourcentageProfil = 90;
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

  @override
  void initState() {
    super.initState();
    // Charger les données de la boutique du vendeur connecté
    context.read<StoreBloc>().add(LoadVendorStore());
  }

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
      body: BlocBuilder<StoreBloc, StoreState>(
        builder: (context, state) {
          if (state is StoreLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StoreError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  AppText(
                    text: 'Erreur',
                    fontSize: largeText(),
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  AppText(
                    text: state.message,
                    fontSize: mediumText(),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  AppButton(
                    onTap: () {
                      context.read<StoreBloc>().add(LoadVendorStore());
                    },
                    child: AppText(text: 'Réessayer'),
                  ),
                ],
              ),
            );
          }

          if (state is StoreLoaded || state is StoreUpdated) {
            final store = state is StoreLoaded ? state.store : (state as StoreUpdated).store;
            
            return ListView(
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
                          text: store.storeInfos?['name'] ?? 'Nom de la boutique',
                          fontSize: largeText() * 0.9,
                          fontWeight: FontWeight.bold,
                        ),

                        /// description de la boutique
                        if (store.description != null && store.description!.isNotEmpty) ...[
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
                              text: store.description!,
                              fontSize: smallText(),
                              overflow: TextOverflow.visible,
                              color: Theme.of(context)
                                  .colorScheme
                                  .inversePrimary
                                  .withOpacity(0.8),
                            ),
                          ),
                        ],

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
                                  value: store.storeRatings?.isNotEmpty == true 
                                      ? store.storeRatings!.reduce((a, b) => a + b).toStringAsFixed(1)
                                      : "0.0",
                                  description: '${store.storeRatings?.length ?? 0} avis'),
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
                                  value: store.ville ?? 'Non défini',
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
                                  value: store.pays ?? 'Bénin',
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
                                  value: store.tempsLivraison ?? 'Non défini',
                                  description: 'Livraison'),
                            )
                          ],
                        ),

                        /// zone de livraison
                        if (store.zoneLivraison != null && store.zoneLivraison!.isNotEmpty) ...[
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
                                    value: store.zoneLivraison!,
                                    description: 'Zone de livraison'),
                              ),
                            ],
                          ),
                        ],

                        /// les sous-secteurs de la boutique
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            if (store.storeSectors != null)
                              ...store.storeSectors!.map((sector) => AppButton(
                                  height: appHeightSize(context) * 0.04,
                                  width: appWidthSize(context) * 0.25,
                                  color: Theme.of(context).colorScheme.background,
                                  child: AppText(text: sector),
                                  onTap: () {})),
                            if (store.storeSubsectors != null)
                              ...store.storeSubsectors!.map((subsector) => AppButton(
                                  height: appHeightSize(context) * 0.04,
                                  width: appWidthSize(context) * 0.25,
                                  color: Theme.of(context).colorScheme.background,
                                  child: AppText(text: subsector),
                                  onTap: () {})),
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
                    text: store.storeInfos?['name'] ?? 'Nom de la boutique',
                  ),
                  trailing: Icon(
                    Icons.edit_note_rounded,
                    color: primaryColor,
                  ),
                ),

                // Secteurs d'activité
                if (store.storeSectors != null && store.storeSectors!.isNotEmpty)
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
                      children: store.storeSectors!.map((sector) => AppButton(
                          height: appHeightSize(context) * 0.04,
                          width: appWidthSize(context) * 0.25,
                          color: Theme.of(context).colorScheme.background,
                          child: AppText(text: sector),
                          onTap: () {})).toList(),
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
                    text: store.ville ?? store.storeAddress ?? 'Adresse non définie',
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
                  subtitle: store.joursOuverture != null && store.joursOuverture!.isNotEmpty
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: store.joursOuverture!.entries.map((entry) {
                            return AppText(
                              text: '${entry.key}: ${entry.value}',
                              fontSize: smallText(),
                            );
                          }).toList(),
                        )
                      : AppText(
                          text: 'Horaires non définis',
                        ),
                  trailing: Icon(
                    Icons.edit_note_rounded,
                    color: primaryColor,
                  ),
                ),

                // Zone de livraison
                if (store.zoneLivraison != null && store.zoneLivraison!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.delivery_dining),
                    title: AppText(
                      text: 'Zone de livraison',
                      color:
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
                      fontSize: mediumText(),
                    ),
                    subtitle: AppText(
                      text: store.zoneLivraison!,
                    ),
                    trailing: Icon(
                      Icons.edit_note_rounded,
                      color: primaryColor,
                    ),
                  ),

                // Temps de livraison
                if (store.tempsLivraison != null && store.tempsLivraison!.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.access_time),
                    title: AppText(
                      text: 'Temps de livraison',
                      color:
                          Theme.of(context).colorScheme.inversePrimary.withOpacity(0.4),
                      fontSize: mediumText(),
                    ),
                    subtitle: AppText(
                      text: store.tempsLivraison!,
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
            );
          }

          return const Center(
            child: AppText(text: 'Aucune donnée disponible'),
          );
        },
      ),
    );
  }
}
