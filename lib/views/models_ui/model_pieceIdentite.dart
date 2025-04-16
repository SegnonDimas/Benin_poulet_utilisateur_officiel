import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';
import '../colors/app_colors.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';

class ModelPieceIdentite extends StatefulWidget {
  late bool? isSelected;
  final String? title;
  final String? description;
  final Function()? onTap;

  ModelPieceIdentite(
      {super.key,
      this.isSelected = false,
      this.title = '',
      this.description = '',
      this.onTap});

  @override
  State<ModelPieceIdentite> createState() => _ModelPieceIdentiteState();
}

class _ModelPieceIdentiteState extends State<ModelPieceIdentite> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widget.isSelected = !widget.isSelected!;
        });
      },
      child: Container(
        height: appHeightSize(context) * 0.09,
        width: appWidthSize(context) * 0.9,
        //padding: const EdgeInsets.only(left: 16.0, right: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                  color: !widget.isSelected!
                      ? Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3)
                      : primaryColor),
              bottom: BorderSide(
                  color: !widget.isSelected!
                      ? Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3)
                      : primaryColor),
              left: BorderSide(
                  color: !widget.isSelected!
                      ? Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3)
                      : primaryColor),
              right: BorderSide(
                  color: !widget.isSelected!
                      ? Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.3)
                      : primaryColor),
            ),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              !widget.isSelected!
                  ? GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isSelected = !widget.isSelected!;
                        });
                      },
                      child: Icon(
                        Icons.circle_outlined,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3),
                      ))
                  : GestureDetector(
                      onTap: () {
                        setState(() {
                          widget.isSelected = !widget.isSelected!;
                        });
                      },
                      child: Icon(
                        Icons.circle,
                        color: primaryColor,
                      ),
                    ),
              SizedBox(
                width: appWidthSize(context) * 0.05,
              ),
              SizedBox(
                height: appHeightSize(context) * 0.07,
                width: appWidthSize(context) * 0.7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: widget.title!,
                      fontSize: mediumText() * 0.9,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      width: appWidthSize(context) * 0.7,
                      child: AppText(
                        text: widget.description!,
                        fontSize: smallText(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
