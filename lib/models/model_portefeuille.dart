import 'package:benin_poulet/models/model_session.dart';
import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../views/sizes/text_sizes.dart';
import '../widgets/app_text.dart';

/// portefeuille modèle
class ModelPortefeuille extends StatefulWidget {
  final double? height;
  final double? width;
  final double? radius;
  late Color? backgroundColor;
  late Color? foregroundColor;
  final String? titrePrincipal;
  final String? titreSession1;
  final String? titreSession2;
  final String? titreSession3;
  final int? solde;

  ModelPortefeuille({
    super.key,
    this.height = 100,
    this.width = 200,
    this.backgroundColor = const Color.fromARGB(179, 0, 96, 216),
    this.foregroundColor = Colors.white,
    this.titrePrincipal = 'Portefeuille',
    this.solde = 0,
    this.radius,
    this.titreSession1 = 'Recharger ',
    this.titreSession2 = 'Retrait',
    this.titreSession3 = 'Historique',
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
                      text: widget.titrePrincipal!,
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
                    ModelSession(
                      radius: widget.radius ?? 30,
                      height: widget.height! / 1.1,
                      width: widget.width! / 3.5,
                      title: widget.titreSession1,
                      titleColor: Colors.white,
                      maxLine: 1,
                      padding: 2,
                    ),
                    ModelSession(
                      radius: widget.radius ?? 30,
                      height: widget.height! / 1.1,
                      width: widget.width! / 3.5,
                      title: widget.titreSession2,
                      titleColor: Colors.white,
                      maxLine: 1,
                      padding: 2,
                    ),
                    ModelSession(
                      radius: widget.radius ?? 30,
                      height: widget.height! / 1.1,
                      width: widget.width! / 3.5,
                      title: widget.titreSession3,
                      titleColor: Colors.white,
                      maxLine: 1,
                      padding: 2,
                    ),

                    /*SizedBox(
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
                    ),*/
                    /*SizedBox(
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
                    ),*/

                    /*SizedBox(
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
                    )*/
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
