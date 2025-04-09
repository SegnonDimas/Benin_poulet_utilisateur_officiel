import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';

class ModelResumeTextField extends StatelessWidget {
  final String? attribut;
  final String? valeur;
  final bool? listeValeur;
  final Widget? listeValeurWidget;

  const ModelResumeTextField(
      {super.key,
      this.attribut = '',
      this.valeur = '',
      this.listeValeur = false,
      this.listeValeurWidget = const SizedBox()});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: appHeightSize(context) * 0.04, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //libelé de l'attibut
          Flexible(
            flex: 1,
            child: AppText(
              text: attribut ?? '',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
              fontSize: smallText() * 1.1,
            ),
          ),
          listeValeur! == false
              ? Flexible(
                  flex: 2,
                  child: AppText(
                      text: valeur ?? '',
                      color: Theme.of(context).colorScheme.inversePrimary),
                )
              : Flexible(flex: 2, child: listeValeurWidget ?? SizedBox()),
        ],
      ),
    );
  }
}
