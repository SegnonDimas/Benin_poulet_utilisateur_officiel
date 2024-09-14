import 'package:flutter/material.dart';

import '../views/sizes/app_sizes.dart';
import '../views/sizes/text_sizes.dart';
import '../widgets/app_text.dart';

/// session modèle
class ModelSession extends StatefulWidget {
  final String? title;
  final String? imgUrl;
  final double? radius;
  final String? routeName;
  final double? height;
  final double? width;
  final double? padding;
  final int? maxLine;
  final Color? titleColor;
  final Function()? onTap;

  const ModelSession({
    super.key,
    this.title = 'Titre',
    this.imgUrl = 'assets/images/img.png',
    this.radius = 35,
    this.routeName,
    this.height,
    this.width,
    this.padding,
    this.maxLine,
    this.titleColor,
    this.onTap,
  });

  @override
  State<ModelSession> createState() => _ModelSessionState();
}

class _ModelSessionState extends State<ModelSession> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap ??
          () {
            Navigator.pushNamed(
                context, widget.routeName ?? '/defaultRoutePage');
          },
      child: SizedBox(
        width: widget.width ?? appWidthSize(context) / 4,
        height: widget.height ?? appHeightSize(context) * 0.16,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(
                  widget.padding ?? appHeightSize(context) * 0.01),
              child: Container(
                padding: EdgeInsets.all(
                    widget.padding ?? appHeightSize(context) * 0.01),
                height: widget.radius! * 2,
                width: widget.radius! * 2,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10000)),
                child: Container(),
              ),
            ),
            Expanded(
              child: AppText(
                textAlign: TextAlign.center,
                text: widget.title!,
                fontSize: mediumText() * 0.7,
                color: widget.titleColor,
                maxLine: widget.maxLine ?? 2,
              ),
            )
          ],
        ),
      ),
    );
  }
}
