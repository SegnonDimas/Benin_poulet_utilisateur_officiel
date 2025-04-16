import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';
import 'model_session.dart';

/// portefeuille modèle
class ModelPortefeuille extends StatefulWidget {
  final double? height;
  final double? width;
  final double? radius;
  final Color? backgroundColor;
  late Color? foregroundColor;
  final String? titrePrincipal;
  final String? titreSession1;
  final String? titreSession2;
  final String? titreSession3;
  final Function()? onTap;
  final Function()? onSession1Tap;
  final Function()? onSession2Tap;
  final Function()? onSession3Tap;
  final int? solde;

  ModelPortefeuille({
    super.key,
    this.height = 100,
    this.width = 200,
    this.backgroundColor, // = const Color.fromARGB(179, 0, 96, 216),
    this.foregroundColor = Colors.white,
    this.titrePrincipal = 'Portefeuille',
    this.solde = 0,
    this.radius,
    this.titreSession1 = 'Recharger ',
    this.titreSession2 = 'Retrait',
    this.titreSession3 = 'Historique',
    this.onTap,
    this.onSession1Tap,
    this.onSession2Tap,
    this.onSession3Tap,
  });

  @override
  State<ModelPortefeuille> createState() => _ModelPortefeuilleState();
}

class _ModelPortefeuilleState extends State<ModelPortefeuille> {
  @override
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(appHeightSize(context) * 0.015),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          height: widget.height,
          width: widget.width,
          padding: EdgeInsets.all(appHeightSize(context) * 0.01),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? blueColor.withGreen(10000),
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
                        onTap: widget.onSession1Tap,
                        maxLine: 1,
                        padding: 2,
                        imgUrl: 'assets/icons/recharge.png',
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                      ),
                      ModelSession(
                        radius: widget.radius ?? 30,
                        height: widget.height! / 1.1,
                        width: widget.width! / 3.5,
                        title: widget.titreSession2,
                        titleColor: Colors.white,
                        onTap: widget.onSession2Tap,
                        maxLine: 1,
                        padding: 2,
                        imgUrl: 'assets/icons/retrait.png',
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                      ),
                      ModelSession(
                        radius: widget.radius ?? 30,
                        height: widget.height! / 1.1,
                        width: widget.width! / 3.5,
                        title: widget.titreSession3,
                        onTap: widget.onSession3Tap,
                        titleColor: Colors.white,
                        maxLine: 1,
                        padding: 2,
                        imgUrl: 'assets/icons/historique2.png',
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.5),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
