import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';

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
  final Color? backgroundColor;

  const ModelSession({
    super.key,
    this.title = 'Titre',
    this.imgUrl = 'assets/logos/img.png',
    this.radius = 35,
    this.routeName,
    this.height,
    this.width,
    this.padding,
    this.maxLine,
    this.titleColor,
    this.onTap,
    this.backgroundColor,
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
                    color: widget.backgroundColor ??
                        Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10000)),
                child: CircleAvatar(
                  //radius: widget.radius! / 1.5,
                  maxRadius: widget.radius! / 2,
                  minRadius: widget.radius! / 3,
                  backgroundColor: Colors.transparent,
                  child: Image.asset(
                    widget.imgUrl!,
                    height: widget.radius! * 1.1,
                    width: widget.radius! * 1.1,
                    //fit: BoxFit.cover,
                  ),
                ),
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

  @override
  void dispose() {
    super.dispose();
  }
}
