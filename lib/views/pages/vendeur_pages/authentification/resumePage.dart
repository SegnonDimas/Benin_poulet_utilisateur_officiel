import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:super_tooltip/super_tooltip.dart';

class ResumePage extends StatefulWidget {
  @override
  State<ResumePage> createState() => _ResumePageState();
}

class _ResumePageState extends State<ResumePage> {
  final List<Categorie> _categorie = [
    // poulet/volaille
    Categorie(
      activeColor: primaryColor.withOpacity(0.9),
      description: 'Tout produit qui concerne les volailles',
      imgUrl: 'assets/images/poulet.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // boeuf
    Categorie(
      activeColor: primaryColor,
      description:
          'Tout produit qui concerne le bétail, exceptionnellement le Boeuf',
      imgUrl: 'assets/images/boeuf.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // mouton
    Categorie(
      activeColor: primaryColor,
      description:
          'Tout produit qui concerne le bétail, exceptionnellement le Mouton',
      imgUrl: 'assets/images/mouton.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // poisson
    Categorie(
      activeColor: primaryColor,
      description: 'Tout produit qui concerne la pisciculture et la pêche',
      imgUrl: 'assets/images/poisson.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),

    // restaurant
    Categorie(
      activeColor: primaryColor,
      description: 'Lorsque vous êtes un restaurant',
      imgUrl: 'assets/images/restaurant.png',
      isSelected: false,
      height: 90,
      width: 90,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          SizedBox(height: appHeightSize(context) * 0.025),
          AppText(
            text: 'Choisissez votre catégorie',
            fontWeight: FontWeight.bold,
            fontSize: mediumText() * 1.1,
          ),
          SizedBox(height: appHeightSize(context) * 0.05),
          Wrap(
            children: _categorie,
          )
        ]),
      ),
    );
  }
}

class Categorie extends StatefulWidget {
  final String? imgUrl;
  final String? title;
  final double? height;
  final double? width;
  final String? description;
  final Color? activeColor;
  final Color? disabledColor;
  late bool isSelected;

  Categorie({
    super.key,
    this.imgUrl = "assets/logos/img.png",
    this.title = '',
    this.height = 100,
    this.width = 100,
    this.description = '',
    this.activeColor = Colors.green,
    this.disabledColor = Colors.grey,
    required this.isSelected,
  });

  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  final _controller = SuperTooltipController();
  Future<bool> _willPopCallback() async {
    /*Si l'info-bulle est ouverte, nous n'affichons pas la page en appuyant sur le bouton Retour, mais fermons l'info-bulle.*/
    if (_controller.isVisible) {
      await _controller.hideTooltip();
      return false;
    }
    return true;
  }

  bool istap = false;

  @override
  void initState() {
    widget.isSelected = false;
    //widget.disabledColor = Colors.grey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            istap = !istap;
            if (istap) {
              widget.isSelected = true;
            } else {
              widget.isSelected = false;
            }
            _willPopCallback();
          });
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            // images
            Container(
              alignment: Alignment.center,
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                  color: istap
                      ? widget.activeColor
                      : Theme.of(context)
                          .colorScheme
                          .surface, //widget.disabledColor,
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  widget.imgUrl!,
                  fit: BoxFit.contain,
                  color: Colors.black,
                  //color: Theme.of(context).colorScheme.surface,
                ),
              ),
            ),

            // infobulle
            SuperTooltip(
                showBarrier: true,
                controller: _controller,
                popupDirection: TooltipDirection.down,
                backgroundColor: Theme.of(context).colorScheme.surface,
                left: appWidthSize(context) * 0.05,
                right: appWidthSize(context) * 0.05,
                arrowTipDistance: 15.0,
                arrowBaseWidth: 20.0,
                arrowLength: 15.0,
                borderWidth: 0.0,
                constraints: BoxConstraints(
                  minHeight: appHeightSize(context) * 0.03,
                  maxHeight: appHeightSize(context) * 0.3,
                  minWidth: appWidthSize(context) * 0.3,
                  maxWidth: appWidthSize(context) * 0.7,
                ),
                showCloseButton: ShowCloseButton.none,
                touchThroughAreaShape: ClipAreaShape.rectangle,
                touchThroughAreaCornerRadius: 30,
                barrierColor: Color.fromARGB(26, 47, 55, 47),
                content: AppText(
                  text: widget.description!,
                  overflow: TextOverflow.visible,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Icon(Icons.info_outline, color: Colors.white),
                ))
          ],
        ),
      ),
    );
  }
}
