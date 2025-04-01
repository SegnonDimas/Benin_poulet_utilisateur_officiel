import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import '../colors/app_colors.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';

class ModelPhotoSelecteur extends StatefulWidget {
  late String? trailing;
  final String? title;
  final String? description;

  ModelPhotoSelecteur(
      {super.key, this.trailing = '', this.title = '', this.description = ''});

  @override
  State<ModelPhotoSelecteur> createState() => _ModelPhotoSelecteurState();
}

class _ModelPhotoSelecteurState extends State<ModelPhotoSelecteur> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: appHeightSize(context) * 0.09,
      width: appWidthSize(context),
      //padding: const EdgeInsets.only(left: 16.0, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.3)),
            bottom: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.3)),
            left: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.3)),
            right: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.3)),
          ),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset('assets/icons/img.png',
                height: appHeightSize(context) * 0.07,
                width: appWidthSize(context) * 0.12,
                color: Theme.of(context)
                    .colorScheme
                    .inversePrimary
                    .withOpacity(0.6)),
            /* SizedBox(
              width: appWidthSize(context) * 0.005,
            ),*/
            SizedBox(
                height: appHeightSize(context) * 0.07,
                width: appWidthSize(context) * 0.7,
                child: ListTile(
                    //minVerticalPadding: 0,
                    minTileHeight: 5,
                    //minLeadingWidth: 0,
                    //horizontalTitleGap: 2,

                    title: AppText(
                      text: widget.title!,
                      fontSize: mediumText() * 0.9,
                    ),
                    subtitle: SizedBox(
                      width: appWidthSize(context) * 0.6,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              text: widget.description!,
                              fontSize: smallText() * 0.9,
                              color: primaryColor,
                            ),
                            AppText(
                              text: '${widget.trailing!}',
                              fontSize: smallText() * 0.9,
                              color: primaryColor,
                            ),
                          ]),
                    ))),
            SizedBox(
              height: appHeightSize(context) * 0.08,
            ),
          ],
        ),
      ),
    );
  }
}
