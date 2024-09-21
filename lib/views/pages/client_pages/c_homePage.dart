import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../bloc/auth/auth_bloc.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage> {
  final List<Widget> _carouselList = const [
    ModelCarouselItem(
      imgPath: 'assets/images/pouletCouveuse.png',
    ),
    ModelCarouselItem(),
    ModelCarouselItem(),
    ModelCarouselItem(
      width: 300,
      imgPath: 'assets/images/pouletCouveuse.png',
      fit: BoxFit.cover,
    ),
    ModelCarouselItem(),
    ModelCarouselItem(
      imgPath: 'assets/images/pouletCouveuse.png',
      fit: BoxFit.cover,
    ),
    ModelCarouselItem(
      width: 300,
      imgPath: 'assets/images/pouletCouveuse.png',
      fit: BoxFit.cover,
    ),
    ModelCarouselItem(),
    ModelCarouselItem(),
    ModelCarouselItem(
      imgPath: 'assets/images/pouletCouveuse.png',
      fit: BoxFit.cover,
    ),
    ModelCarouselItem(),
    ModelCarouselItem(),
  ];
  int pageIndex = 0;
  CarouselSliderController controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state as AuthAuthenticated;
    return Scaffold(
      appBar: AppBar(
        title: AppText(text: authState.userId.replaceAll(' ', '')),
        centerTitle: true,
        actions: const [Icon(Icons.account_circle)],
      ),
      body: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                  items: _carouselList,
                  carouselController: controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      autoPlayCurve: Curves.fastEaseInToSlowEaseOut,
                      aspectRatio: 13 / 6,
                      enlargeFactor: 0.5,
                      onPageChanged: (index, CarouselPageChangedReason c) {
                        //return index;
                        setState(() {
                          pageIndex = index;
                        });
                      })),
              Positioned(
                bottom: 10,
                left: appWidthSize(context) * 0.35,
                right: appWidthSize(context) * 0.35,
                child: Container(
                  alignment: Alignment.center,
                  height: 20,
                  //width: appWidthSize(context) * 0.25,
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20)),
                  child: PageViewDotIndicator(
                    currentItem: pageIndex,
                    count: _carouselList.length,
                    size: const Size(8, 8),
                    unselectedColor: Colors.grey.shade600,
                    selectedColor: Colors.grey.shade100,
                    onItemClicked: (index) {
                      setState(() {
                        pageIndex = index;
                        controller.animateToPage(pageIndex);
                      });
                    },
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

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
                  width: width ?? appWidthSize(context) * 0.85,
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
                              children: [
                                AppText(
                                  text: '1.500F',
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.red,
                                  fontSize: mediumText() * 0.7,
                                  decorationStyle: TextDecorationStyle.solid,
                                ),
                                AppText(
                                  text: '750F',
                                  fontWeight: FontWeight.w600,
                                  fontSize: mediumText() * 0.7,
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
                              color: primaryColor,
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
