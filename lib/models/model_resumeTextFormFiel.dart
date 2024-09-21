import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../views/sizes/text_sizes.dart';
import '../widgets/app_text.dart';

class ModelResumeTextField extends StatelessWidget {
  final String? attribut;
  final String? valeur;

  const ModelResumeTextField({super.key, this.attribut, this.valeur});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: appHeightSize(context) * 0.04, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 1,
            child: AppText(
              text: attribut ?? '',
              color:
                  Theme.of(context).colorScheme.inversePrimary.withOpacity(0.5),
              fontSize: smallText() * 1.1,
            ),
          ),
          Flexible(
            flex: 2,
            child: AppText(
                text: valeur ?? '',
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ],
      ),
    );
  }
}
