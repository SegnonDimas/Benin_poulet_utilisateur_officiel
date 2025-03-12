import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_button.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../bloc/auth/auth_bloc.dart';
import '../../colors/app_colors.dart';

class CHomePage extends StatefulWidget {
  const CHomePage({super.key});

  @override
  State<CHomePage> createState() => _CHomePageState();
}

class _CHomePageState extends State<CHomePage>
    with SingleTickerProviderStateMixin {
  final List<Widget> _carouselList = const [
    ModelCarouselItem(
      imgPath: 'assets/images/pouletCouveuse.png',
      fit: BoxFit.cover,
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
  final List<RecomandationModel> _listRecommandations = const [
    RecomandationModel(
      shopName: 'Le Poulailler',
      backgroundImage: 'assets/images/pouletCouveuse.png',
    ),
    RecomandationModel(
      shopName: 'Mike Store',
    ),
    RecomandationModel(
      shopName: 'Le gros',
      backgroundImage: 'assets/images/pouletCouveuse.png',
    ),
    RecomandationModel(shopName: 'AcolPro'),
    RecomandationModel(shopName: 'Linge d\'or'),
    RecomandationModel(shopName: 'Smart Solutions Innova'),
    RecomandationModel(shopName: ''),
    RecomandationModel(),
    RecomandationModel(),
  ];

  // index
  int carouselCurrentIndex = 0;
  int currentPage = 0;

  // carouselSliderController
  CarouselSliderController controller = CarouselSliderController();

  // page view controller
  final PageController _pageViewController = PageController(
    initialPage: 0,
  );

  // tabController
  late TabController _tabcontroller;

  // liste des icônes du bottomNavigationBar
  final List<Icon> _bottomNavigationBarItems = [
    const Icon(
      Icons.home_filled,
      //size: largeText() * 1.2,
    ),
    /*Icon(Icons.edit_calendar_rounded, size: largeText() * 1.2),
    Icon(
      Icons.payment,
      size: largeText() * 1.2,
    ),*/
    const Icon(
      //Icons.wechat_rounded,
      Icons.shopping_cart,
      //size: largeText() * 1.2,
    ),
  ];

  // initState
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabcontroller = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state as AuthAuthenticated;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title:
              AppText(text: "@" + authState.userId.replaceAll(' ', '') + "bp"),
          centerTitle: true,
          actions: const [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.notifications),
            )
          ],
        ),

        body: PageView(
          controller: _pageViewController,
          onPageChanged: (index) {
            setState(() {
              currentPage = index;
            });
          },
          children: [
            /// Première page : Page d'Accueil
            SingleChildScrollView(
              child: SizedBox(
                height: appHeightSize(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                aspectRatio: 11 / 5,
                                enlargeFactor: 0.5,
                                viewportFraction: 0.92,
                                onPageChanged:
                                    (index, CarouselPageChangedReason c) {
                                  //return index;
                                  setState(() {
                                    carouselCurrentIndex = index;
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
                              currentItem: carouselCurrentIndex,
                              count: _carouselList.length,
                              size: const Size(8, 8),
                              unselectedColor: Colors.grey.shade600,
                              selectedColor: Colors.grey.shade100,
                              onItemClicked: (index) {
                                setState(() {
                                  carouselCurrentIndex = index;
                                  controller
                                      .animateToPage(carouselCurrentIndex);
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                      child: SizedBox(
                        height: 30,
                        child: AppText(text: 'Recommandations'),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(5),
                        physics: NeverScrollableScrollPhysics(
                            parent: BouncingScrollPhysics()),
                        children: [
                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            runSpacing: 10,
                            //spacing: 60,
                            children: _listRecommandations,
                          ),
                        ],
                      ),
                    ),
                    /*SizedBox(
                      height: 160,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _listRecommandations.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(right: 4.0, left: 4.0),
                              child: _listRecommandations[index],
                            );
                          }),
                    )*/
                  ],
                ),
              ),
            ),

            /// Deuxième Page : Page de Panier
            Column(
              children: [
                /// TabBar
                SizedBox(
                  height: appHeightSize(context) * 0.06,
                  width: appWidthSize(context) * 0.9,
                  child: TabBar(
                      controller: _tabcontroller,
                      indicatorColor: primaryColor,
                      labelColor: primaryColor,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.4),
                      unselectedLabelColor: Theme.of(context)
                          .colorScheme
                          .inversePrimary
                          .withOpacity(0.4),
                      tabs: [
                        Tab(child: AppText(text: 'Produits')),
                        Tab(
                          child: AppText(text: 'Boutiques'),
                        ),
                      ]),
                ),

                /// TabBarView
                Expanded(
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabcontroller,
                      children: [
                        Center(
                          child:
                              AppText(text: 'Votre liste de produits est vide'),
                        ),
                        Center(
                          child: AppText(
                              text: 'Votre liste de boutiques est vide'),
                        )
                      ]),
                ),
              ],
            ),
          ],
        ),

        /// bottomNavigationBar
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          height: appHeightSize(context) * 0.07,
          color: Theme.of(context).colorScheme.background,
          //buttonBackgroundColor: primaryColor,
          //selectedColor: Colors.white,
          //unselectedColor: Theme.of(context).colorScheme.inversePrimary,
          items: _bottomNavigationBarItems,
          index: currentPage,
          onTap: (index) {
            //Handle button tap
            setState(() {
              currentPage = index;
              //_pageViewController.jumpToPage(currentPage);
              _pageViewController.animateToPage(currentPage,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.linear);
            });
          },
        ),
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

/// Recommandations

class RecomandationModel extends StatelessWidget {
  final String? backgroundImage;
  final String? shopName;

  const RecomandationModel({
    super.key,
    this.backgroundImage,
    this.shopName,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SizedBox(
      child: AppButton(
        height: height * 0.2,
        width: width * 0.47,
        color: Colors.black38,
        onTap: () {},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: SizedBox(
                    height: height * 0.12,
                    width: width * 0.47,
                    child: Image.asset(
                        fit: BoxFit.cover,
                        backgroundImage ?? 'assets/images/oeuf2.png')),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    //width: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          text: '4.0',
                          fontSize: smallText(),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.deepOrange,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                  Icon(
                    Icons.verified_sharp,
                    color: Colors.blue.shade900,
                    size: 15,
                  )
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: CircleAvatar(
                radius: 45,
                backgroundImage:
                    AssetImage(backgroundImage ?? 'assets/images/oeuf2.png'),
              ),
            ),*/
            Padding(
              padding:
                  const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 6.0),
              child: AppButton(
                bordeurRadius: 10,
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.7),
                height: height * 0.043,
                width: width * 0.45,
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                  child: AppText(
                    text: shopName?.trim() != ''
                        ? shopName ?? 'Recommandé'
                        : '...',
                    //color: Colors.deepOrange.withOpacity(0.8),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
