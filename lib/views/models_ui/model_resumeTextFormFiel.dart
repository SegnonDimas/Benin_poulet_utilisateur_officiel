import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/app_text.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';

class ModelResumeTextField extends StatelessWidget {
  final String? attribut;
  final String? valeur;
  final bool? listeValeur;
  final Widget? listeValeurWidget;
  final TextOverflow? valueOverflow;
  final TextOverflow? labelOverflow;
  final double? height;

  const ModelResumeTextField(
      {super.key,
      this.attribut = '',
      this.valeur = '',
      this.listeValeur = false,
      this.listeValeurWidget = const SizedBox(),
      this.valueOverflow,
      this.labelOverflow,
      this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: appHeightSize(context) * 0.01, bottom: 1),
      child: Column(
        children: [
          SizedBox(
            height: height ?? context.height * 0.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //libelé de l'attibut
                Flexible(
                  flex: 1,
                  child: AppText(
                    text: attribut ?? '',
                    color: Theme.of(context)
                        .colorScheme
                        .inversePrimary
                        .withOpacity(0.5),
                    fontSize: smallText() * 1.1,
                    overflow: labelOverflow,
                  ),
                ),
                listeValeur! == false
                    ? Flexible(
                        flex: 2,
                        child: AppText(
                          text: valeur ?? '',
                          color: Theme.of(context).colorScheme.inversePrimary,
                          overflow: valueOverflow,
                        ),
                      )
                    : Flexible(flex: 2, child: listeValeurWidget ?? SizedBox()),
              ],
            ),
          ),
          SizedBox(
            height: 20,
            child: DottedLine(
              dashColor:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}
