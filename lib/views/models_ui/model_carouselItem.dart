import 'package:flutter/material.dart';

import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';
import '../sizes/app_sizes.dart';
import '../sizes/text_sizes.dart';

class ModelCarouselItem extends StatelessWidget {
  final String? imgPath;
  final double? padding;
  final double? borderRadius;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final Gradient? gradient;
  final Function()? onTap;

  const ModelCarouselItem({
    super.key,
    this.imgPath,
    this.padding,
    this.borderRadius,
    this.height,
    this.width,
    this.fit,
    this.gradient,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding ?? 8.0),
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 20)),
          child: Stack(
            children: [
              Image.asset(imgPath ?? 'assets/images/oeuf2.png',
                  width: width ?? appWidthSize(context) * 0.9,
                  height: height ?? appHeightSize(context) * 0.25,
                  fit: fit ?? BoxFit.cover),
              Container(
                padding: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    //                    color: Theme.of(context).colorScheme.surface,
                    //borderRadius: BorderRadius.circular(20),
                    gradient: gradient ??
                        LinearGradient(colors: [
                          Colors.grey.shade900.withOpacity(0.9),
                          Colors.grey.shade800.withOpacity(0.5),
                          Colors.grey.shade700.withOpacity(0.2),
                        ])),
                child: Stack(
                  children: [
                    Positioned(
                        top: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface
                                      .withOpacity(0.4))),
                          child: AppText(
                            text: 'Offre limitéé',
                            fontSize: smallText(),
                          ),
                        )),
                    Positioned(
                        top: appHeightSize(context) * 0.05,
                        left: 10,
                        child: AppText(
                          text: 'Ne ratez pas l\'offre',
                          fontSize: largeText() * 0.8,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                    Positioned(
                        top: appHeightSize(context) * 0.085,
                        left: 10,
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: '1.500F',
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                  fontSize: mediumText(),
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                                AppText(
                                  text: '750F',
                                  fontWeight: FontWeight.w900,
                                  fontSize: mediumText() * 1.2,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            AppText(
                              text: '-50%',
                              fontSize: largeText() * 1.1,
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade300,
                            )
                          ],
                        )),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: AppButton(
                          height: 40,
                          width: 40,
                          bordeurRadius: 10,
                          onTap: () {},
                          child: const Icon(Icons.add)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
