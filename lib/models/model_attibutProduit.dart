import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ModelAttributProduit extends StatelessWidget {
  final String? attributLabel;
  final String? attributValue;
  final IconData? attributIcon;
  final Color? attributLabelColor;
  final Color? attributValueColor;
  final Color? attributIconColor;
  final double? size;

  const ModelAttributProduit(
      {super.key,
      this.attributLabel,
      this.attributValue,
      this.attributIcon,
      this.attributLabelColor,
      this.attributValueColor,
      this.attributIconColor,
      this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        /// icon de l'attribut
        Flexible(
          flex: 1,
          child: Icon(
            attributIcon ?? Icons.info_outline,
            color: attributIconColor ?? Theme.of(context).colorScheme.primary,
            size: size ?? mediumText(),
          ),
        ),

        /// label de l'attribut
        Flexible(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 6.0),
            child: SizedBox(
              width: appWidthSize(context) * 0.4,
              child: AppText(
                text: attributLabel ?? '... : ',
                fontSize: smallText() * 0.95,
                color:
                    attributLabelColor ?? Theme.of(context).colorScheme.primary,
                //fontSize: size ?? smallText(),
              ),
            ),
          ),
        ),

        /// valeur de l'attribut
        Flexible(
          flex: 2,
          child: AppText(
            text: attributValue ?? '...',
            fontSize: smallText() * 0.8,
            fontWeight: FontWeight.w600,
            color: attributValueColor ?? Theme.of(context).colorScheme.primary,
            //fontSize: size ?? smallText(),
          ),
        )
      ],
    );
  }
}
