import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ProfilListTile extends StatefulWidget {
  final String title;
  final IconData leadingIcon;
  final Function()? onTap;

  const ProfilListTile(
      {super.key, required this.title, required this.leadingIcon, this.onTap});

  @override
  State<ProfilListTile> createState() => _ProfilListTileState();
}

class _ProfilListTileState extends State<ProfilListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
          height: appHeightSize(context) * 0.07,
          width: appWidthSize(context) * 0.9,
          child: Row(
            children: [
              /// espace en début de ligne
              const SizedBox(
                width: 15,
              ),

              /// l'icône
              Container(
                height: appHeightSize(context) * 0.05,
                width: appHeightSize(context) * 0.05,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color:
                      Theme.of(context).colorScheme.background.withOpacity(0.8),
                ),
                child: Icon(
                  widget.leadingIcon,
                  color: Theme.of(context)
                      .colorScheme
                      .inversePrimary
                      .withOpacity(0.5),
                ),
              ),

              /// espace
              const SizedBox(
                width: 15,
              ),

              /// le titre
              AppText(
                text: widget.title,
                fontSize: mediumText(),
              )
            ],
          )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
