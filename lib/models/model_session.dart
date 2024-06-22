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
  const ModelSession(
      {super.key,
      this.title = 'Titre',
      this.imgUrl = 'assets/images/img.png',
      this.radius = 35,
      this.routeName});

  @override
  State<ModelSession> createState() => _ModelSessionState();
}

class _ModelSessionState extends State<ModelSession> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, widget.routeName ?? '/vendeurMainPage');
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(appHeightSize(context) * 0.01),
            child: Container(
              padding: EdgeInsets.all(appHeightSize(context) * 0.01),
              height: widget.radius! * 2,
              width: widget.radius! * 2,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10000)),
              child: Container(),
            ),
          ),
          AppText(
            text: widget.title!,
            fontSize: mediumText() * 0.7,
          )
        ],
      ),
    );
  }
}
