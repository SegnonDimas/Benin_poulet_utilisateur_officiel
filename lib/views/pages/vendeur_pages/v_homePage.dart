import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

//import 'package:flutter/cupertino.dart';

class VHomePage extends StatefulWidget {
  const VHomePage({super.key});

  @override
  State<VHomePage> createState() => _VHomePageState();
}

class _VHomePageState extends State<VHomePage> {
  final List<ModelSession> _sessions = [
    const ModelSession(
      title: 'Ma boutique',
    ),
    const ModelSession(title: 'Campage'),
    const ModelSession(title: 'Statistiques'),
    const ModelSession(title: 'Mon profil'),
  ];

  @override
  Widget build(BuildContext context) {
    const SizedBox espace = SizedBox(
      height: 20,
    );
    return ListView(
      children: [
        SizedBox(
            height: appHeightSize(context) * 0.1,
            width: appWidthSize(context),
            child: ListTile(
              title: AppText(
                text: 'Salut, Le Poulailler!',
                fontWeight: FontWeight.bold,
              ),
              subtitle: AppText(
                text: 'Votre boutique est maintenant en ligne',
                fontSize: smallText(),
              ),
            )),
        //espace,
        ModelPortefeuille(
          solde: 400000,
        ),
        SizedBox(
          width: appWidthSize(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _sessions,
          ),
        ),
      ],
    );
  }
}

/// portefeuille modèle
class ModelPortefeuille extends StatefulWidget {
  final double? height;
  final double? width;
  late Color? backgroundColor;
  late Color? foregroundColor;
  final String? title;
  final int? solde;
  ModelPortefeuille({
    super.key,
    this.height = 100,
    this.width = 200,
    this.backgroundColor = const Color.fromARGB(179, 0, 96, 216),
    this.foregroundColor = Colors.white,
    this.title = 'Portefeuille',
    this.solde = 0,
  });

  @override
  State<ModelPortefeuille> createState() => _ModelPortefeuilleState();
}

class _ModelPortefeuilleState extends State<ModelPortefeuille> {
  @override
  void initState() {
    widget.backgroundColor = const Color.fromARGB(179, 0, 96, 216);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(appHeightSize(context) * 0.015),
      child: Container(
        height: widget.height,
        width: widget.width,
        padding: EdgeInsets.all(appHeightSize(context) * 0.01),
        decoration: BoxDecoration(
          color: widget.backgroundColor!.withGreen(10000),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(appHeightSize(context) * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: widget.width! / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.title!,
                      fontSize: smallText() * 0.9,
                      color: widget.foregroundColor,
                    ),
                    AppText(
                      text: '${widget.solde} F',
                      fontSize: mediumText() * 1.2,
                      fontWeight: FontWeight.bold,
                      color: widget.foregroundColor,
                    )
                  ],
                ),
              ),
              SizedBox(
                width: widget.width! / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: widget.width! / 5,
                      child: ListView(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                widget.backgroundColor!.withGreen(1),
                            radius: widget.height! / 3.5,
                          ),
                          AppText(
                            text: 'Recharger',
                            fontSize: smallText(),
                            color: widget.foregroundColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: widget.width! / 5,
                      child: ListView(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                widget.backgroundColor!.withGreen(1),
                            radius: widget.height! / 3.5,
                          ),
                          AppText(
                            text: 'Retrait',
                            fontSize: smallText(),
                            color: widget.foregroundColor,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: widget.width! / 5,
                      child: ListView(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                                widget.backgroundColor!.withGreen(1),
                            radius: widget.height! / 3.5,
                          ),
                          AppText(
                            text: 'Historique',
                            fontSize: smallText(),
                            color: widget.foregroundColor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// session modèle
class ModelSession extends StatefulWidget {
  final String? title;
  final String? imgUrl;
  final double? radius;
  const ModelSession(
      {super.key,
      this.title = 'Titre',
      this.imgUrl = 'assets/images/img.png',
      this.radius = 35});

  @override
  State<ModelSession> createState() => _ModelSessionState();
}

class _ModelSessionState extends State<ModelSession> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(appHeightSize(context) * 0.01),
          child: Container(
            padding: EdgeInsets.all(appHeightSize(context) * 0.01),
            height: widget.radius! * 2,
            width: widget.radius! * 2,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10000)),
            child: Container(),
          ),
        ),
        AppText(
          text: widget.title!,
          fontSize: mediumText() * 0.7,
        )
      ],
    );
  }
}
