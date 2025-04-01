import 'package:benin_poulet/views/models_ui/model_releveTranslation.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';

class VPortefeuillePage extends StatefulWidget {
  const VPortefeuillePage({super.key});

  @override
  State<VPortefeuillePage> createState() => _VPortefeuillePageState();
}

class _VPortefeuillePageState extends State<VPortefeuillePage> {
  String profilPath = 'assets/images/pouletCouveuse.png';
  String numPortefeuille = '+229 00 00 00 00';
  String shopName = 'Le Poulailler';
  String validity = '06/27';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          /// présentation du portefeuille
          SizedBox(
            height: appHeightSize(context) * 0.49,
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// cercle décoratif
                const Positioned(
                  top: 5,
                  left: 5,
                  child: Hero(
                    tag: '1',
                    child: GradientBall(colors: [
                      Colors.deepOrange,
                      Colors.amber,
                    ]),
                  ),
                ),

                /// cercle décoratif
                Positioned(
                  top: appHeightSize(context) * 0.22,
                  right: 5,
                  child: const Hero(
                    tag: '2',
                    child: GradientBall(
                      size: Size.square(200),
                      colors: [Colors.blue, Colors.purple],
                    ),
                  ),
                ),

                /// carte du portefeuille
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: appHeightSize(context) * 0.00),
                  child: BlurryContainer(
                    blur: 8,
                    height: appHeightSize(context) * 0.3,
                    elevation: 6,
                    padding: const EdgeInsets.all(16),
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.2),
                    //Colors.white.withOpacity(0.15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// image de profil
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'imageProfil',
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Colors.transparent,
                                backgroundImage: AssetImage(
                                  profilPath,
                                ),
                              ),
                            ),
                            AppButton(
                                height: appHeightSize(context) * 0.04,
                                width: appHeightSize(context) * 0.04,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary
                                    .withOpacity(0.2),
                                child: Icon(
                                  Icons.edit,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  size: mediumText() * 1.2,
                                ),
                                onTap: () {})
                          ],
                        ),
                        const Spacer(),

                        /// numéro des translations
                        Text(
                          numPortefeuille,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w200,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),

                        /// nom de la boutique
                        Row(
                          children: [
                            Hero(
                              tag: 'nomBoutique',
                              child: Text(
                                shopName.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "VALID",
                              style: TextStyle(
                                fontWeight: FontWeight.w200,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              validity,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                /// bouton de retour

                Positioned(
                  top: appHeightSize(context) * 0.01,
                  left: 10,
                  child: AppButton(
                      height: appHeightSize(context) * 0.06,
                      width: appHeightSize(context) * 0.06,
                      bordeurRadius: 100,
                      color: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.6),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Theme.of(context).colorScheme.surface,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      }),
                ),

                Positioned(
                  bottom: appHeightSize(context) * 0.01,
                  left: 10,
                  child: Row(
                    //crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppButton(
                            height: appHeightSize(context) * 0.05,
                            width: appHeightSize(context) * 0.05,
                            bordeurRadius: 100,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.3),
                            child: Icon(
                              Icons.send_to_mobile_outlined,
                              //size: smallText() * 1.5,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            onTap: () {}),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: AppButton(
                            height: appHeightSize(context) * 0.05,
                            width: appHeightSize(context) * 0.05,
                            bordeurRadius: 100,
                            color: Theme.of(context)
                                .colorScheme
                                .inversePrimary
                                .withOpacity(0.3),
                            child: Icon(
                              Icons.download,
                              //size: smallText() * 1.5,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                            onTap: () {}),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      AppText(
                        text: 'Effectuez une opération',
                        fontSize: smallText(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// historique des translations
          Expanded(
            child: ListView(
              children: const [
                ModelReleveTranslation(
                    dateTranslation: '08 Sep 2024',
                    heureTranslation: '16:41',
                    montantTranslation: '7500',
                    idTranslation: '8064122275',
                    typeTranslation: 'Entrée',
                    taxeTranslation: '75'),
                ModelReleveTranslation(
                    dateTranslation: '10 Sep 2024',
                    heureTranslation: '16:41',
                    montantTranslation: '7500',
                    idTranslation: '8064122275',
                    typeTranslation: 'Sortie',
                    taxeTranslation: '75'),
                ModelReleveTranslation(
                    dateTranslation: '08 Sep 2024',
                    heureTranslation: '16:41',
                    montantTranslation: '7500',
                    idTranslation: '8064122275',
                    typeTranslation: 'Sortie',
                    taxeTranslation: '75'),
                ModelReleveTranslation(
                    dateTranslation: '08 Sep 2024',
                    heureTranslation: '16:41',
                    montantTranslation: '7500',
                    idTranslation: '8064122275',
                    typeTranslation: 'Entrée',
                    taxeTranslation: '75'),
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class GradientBall extends StatelessWidget {
  final List<Color> colors;
  final Size size;

  const GradientBall({
    Key? key,
    required this.colors,
    this.size = const Size.square(150),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: colors,
        ),
      ),
    );
  }
}
