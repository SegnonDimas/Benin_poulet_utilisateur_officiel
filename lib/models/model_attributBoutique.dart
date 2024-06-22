import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../views/sizes/text_sizes.dart';
import '../widgets/app_text.dart';

/// ModelAttributBoutique
class ModelAttributBoutique extends StatelessWidget {
  final Widget icon;
  final String value;
  final String description;
  final double? height;
  final double? width;
  final Color? valueColor;
  final Color? descriptionColor;
  final double? valueSize;
  final double? descriptionSize;
  const ModelAttributBoutique(
      {super.key,
      required this.icon,
      required this.value,
      required this.description,
      this.height,
      this.width,
      this.valueColor,
      this.descriptionColor,
      this.valueSize,
      this.descriptionSize});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? appHeightSize(context) * 0.1,
      child: SizedBox(
        width: width ?? appWidthSize(context) * 0.25,
        child: ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon,
              AppText(
                text: value,
                fontSize: valueSize ?? mediumText(),
                color:
                    valueColor ?? Theme.of(context).colorScheme.inversePrimary,
              ),
            ],
          ),
          subtitle: AppText(
            text: description,
            fontSize: descriptionSize ?? smallText() * 1.1,
            color: descriptionColor ??
                Theme.of(context).colorScheme.inversePrimary.withAlpha(100),
          ),
        ),
      ),
    );
  }
}
