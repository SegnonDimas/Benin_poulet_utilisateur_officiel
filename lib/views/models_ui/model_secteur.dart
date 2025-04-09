import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';

class ModelSecteur extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color activeColor;
  final Color disabledColor;
  final Function() onTap;
  final BorderRadiusGeometry? borderRadius;

  const ModelSecteur({
    required this.text,
    required this.isSelected,
    required this.activeColor,
    required this.disabledColor,
    required this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Tooltip(
        message: 'L\'un de vos secteurs d\'intervention est : $text',
        decoration: BoxDecoration(
          color: isSelected ? activeColor : disabledColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isSelected
                  ? activeColor
                  : Theme.of(context).colorScheme.background.withOpacity(0.6),
              borderRadius: borderRadius ?? BorderRadius.circular(15),
            ),
            child: AppText(
              text: text,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
        ),
      ),
    );
  }
}
