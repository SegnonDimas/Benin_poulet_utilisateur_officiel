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
    var widthSpace = const SizedBox(
      width: 5,
    );
    return SizedBox(
      height: height ?? appHeightSize(context) * 0.1,
      child: SizedBox(
        width: width ?? appWidthSize(context) * 0.33,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  icon,
                  widthSpace,
                  Expanded(
                    child: AppText(
                      text: value,
                      fontSize: valueSize ?? mediumText(),
                      color: valueColor ??
                          Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ],
              ),
              Row(
                //mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  widthSpace,
                  widthSpace,
                  widthSpace,
                  widthSpace,
                  widthSpace,
                  widthSpace,
                  Expanded(
                    child: AppText(
                      text: description,
                      fontSize: descriptionSize ?? smallText() * 1.1,
                      color: descriptionColor ??
                          Theme.of(context)
                              .colorScheme
                              .inversePrimary
                              .withAlpha(100),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
