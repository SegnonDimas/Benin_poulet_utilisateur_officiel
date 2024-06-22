import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../views/sizes/text_sizes.dart';
import '../widgets/app_text.dart';

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
