import 'package:benin_poulet/views/colors/app_colors.dart';
import 'package:benin_poulet/views/sizes/app_sizes.dart';
import 'package:benin_poulet/views/sizes/text_sizes.dart';
import 'package:benin_poulet/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../../models/model_presentationPage.dart';

class PresentationPage extends StatefulWidget {
  const PresentationPage({super.key});

  @override
  State<PresentationPage> createState() => _PresentationPageState();
}

class _PresentationPageState extends State<PresentationPage> {
  late int selectedPage;
  late PageController _pageController = PageController();
  final PageController _pageViewController = PageController();

  // list 'views' contenant les informations des différentes pageView
  List<ModelPresentationPage> views = [
    //pageView 1
    ModelPresentationPage(
        title: "Bénin Poulet",
        description: "Bienvenue sur notre application Bénin Poulet ...",
        image: "assets/images/welcome.png",
        nextMsg: 'Next',
        descriptionTitle: 'Bienvenue'),

    //pageView 2
    ModelPresentationPage(
        title: "Bénin Poulet",
        description:
            "Créez une boutique et faites découvrir votre ferme à travers le monde ...",
        image: "assets/images/shopCreating.png",
        nextMsg: 'Next',
        descriptionTitle: 'Créer'),

    //pageView 3
    ModelPresentationPage(
        title: "Bénin Poulet",
        description:
            "Explorez les produits et boutiques disponibles sur l'app...",
        image: "assets/images/exploration.png",
        nextMsg: 'Next',
        descriptionTitle: 'Explorer'),

    //pageView 4
    ModelPresentationPage(
        title: "Bénin Poulet",
        description:
            "Recherchez des produits et boutiques disponibles à proximité...",
        image: "assets/images/proximiteRecherche.png",
        nextMsg: 'Next',
        descriptionTitle: 'Rechercher'),

    //pageView 5
    ModelPresentationPage(
        title: "Bénin Poulet",
        description:
            "Commandez ce que vous comptez et payer en toute sécurité ...",
        image: "assets/images/paid.png",
        nextMsg: 'Next',
        descriptionTitle: 'Commander'),

    //pageView 6
    ModelPresentationPage(
        title: "Bénin Poulet",
        description: "Soyez livrés en toute sécurité ...",
        image: "assets/images/receive.png",
        nextMsg: 'Next',
        descriptionTitle: 'Être livré'),
  ];

  /// initState
  @override
  void initState() {
    selectedPage = 0;
    _pageController = PageController(initialPage: selectedPage);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,

        /// corps de la page
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // les éléments de la page
                    PageView(
                      controller: _pageViewController,
                      // bloquer le scroll depuis cette pageView
                      physics: const NeverScrollableScrollPhysics(),

                      // liste des pages de la pageView
                      children: List.generate(views.length, (index) {
                        // listView, structure de chaque page de la pageView
                        return ListView(children: [
                          /// logo + titre
                          Padding(
                            padding: EdgeInsets.only(
                                top: appHeightSize(context) * 0.02,
                                right: appWidthSize(context) * 0.1,
                                left: appWidthSize(context) * 0.04),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // logo de Bénin poulet
                                Hero(
                                  tag: 'logoTag',
                                  child: CircleAvatar(
                                    radius: appHeightSize(context) * 0.03,
                                    child: Image.asset(
                                      'assets/logos/logoBlanc.png',
                                      fit: BoxFit.fill,
                                      height: appHeightSize(context) * 0.03,
                                    ),
                                  ),
                                ),

                                // le titre : Bénin Poulet (de la pageView)
                                Text(
                                  views[selectedPage].title,
                                  style: TextStyle(
                                      fontSize: largeText() * 1.3,
                                      color: primaryColor,
                                      fontWeight: FontWeight.w900),
                                ),
                                const SizedBox(
                                  width: 1,
                                )
                              ],
                            ),
                          ),

                          /// texte (Bouton): Passer
                          Padding(
                            padding: EdgeInsets.only(
                                top: appHeightSize(context) * 0.04,
                                bottom: appHeightSize(context) * 0.02,
                                right: appWidthSize(context) * 0.05),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 1,
                                ),
                                selectedPage == views.length - 1
                                    ? SizedBox(
                                        height: appHeightSize(context) * 0.04,
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: AppText(
                                                  text:
                                                      'Que comptez-vous faire sur l\'application ?',
                                                  fontSize: mediumText(),
                                                  maxLine: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: SizedBox(
                                                  height:
                                                      appHeightSize(context) *
                                                          0.17,
                                                  child: Column(
                                                    children: [
                                                      ///VENDRE
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    '/inscriptionVendeurPage');
                                                          },
                                                          child: Container(
                                                            height: appHeightSize(
                                                                    context) *
                                                                0.06,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  primaryColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .monetization_on_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: appWidthSize(
                                                                          context) *
                                                                      0.05,
                                                                ),
                                                                AppText(
                                                                  text:
                                                                      'Vendre',
                                                                  fontSize:
                                                                      mediumText(),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: appWidthSize(
                                                                          context) *
                                                                      0.05,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size:
                                                                      largeText(),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      ///ACHETER
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pushNamed(
                                                                    '/inscriptionPage');
                                                          },
                                                          child: Container(
                                                            height: appHeightSize(
                                                                    context) *
                                                                0.06,
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    primaryColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .shopping_cart_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: appWidthSize(
                                                                          context) *
                                                                      0.05,
                                                                ),
                                                                AppText(
                                                                  text:
                                                                      'Acheter',
                                                                  fontSize:
                                                                      mediumText(),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                SizedBox(
                                                                  width: appWidthSize(
                                                                          context) *
                                                                      0.05,
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .arrow_forward_ios,
                                                                  size:
                                                                      largeText(),
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                icon: CircleAvatar(
                                                    radius:
                                                        appHeightSize(context) *
                                                            0.05,
                                                    child: Icon(
                                                      Icons.question_mark,
                                                      size: largeText() * 2,
                                                      color: Colors.green,
                                                    )),
                                                iconColor: Colors.white,
                                                elevation: 25,
                                                shadowColor: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: AppText(
                                                      text: 'Annuler',
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            height:
                                                appHeightSize(context) * 0.04,
                                            width: appHeightSize(context) * 0.1,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inverseSurface
                                                  .withOpacity(0.05),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: AppText(
                                              text: 'Passer',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary,
                                            )),
                                      )
                              ],
                            ),
                          ),

                          /// corps mutable (scrollable) de la pageView
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.6,
                              child: PageView.builder(
                                  //physics: const NeverScrollableScrollPhysics(),
                                  physics: const ScrollPhysics(),
                                  controller: _pageController,
                                  onPageChanged: (index) {
                                    setState(() {
                                      selectedPage = index;
                                    });
                                    //_pageController.jumpToPage(selectedPage);
                                    _pageController.animateToPage(
                                      selectedPage,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.linear,
                                    );
                                  },
                                  itemCount: views.length,
                                  itemBuilder: (context, index) {
                                    return SizedBox(
                                      // image + description
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          // image caractéristique de chaque page
                                          Image.asset(
                                            views[selectedPage].image,
                                            height:
                                                appHeightSize(context) * 0.3,
                                          ),
                                          //espace
                                          SizedBox(
                                            height:
                                                appHeightSize(context) * 0.05,
                                          ),
                                          //description
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // titre description
                                                Text(
                                                  views[selectedPage]
                                                      .descriptionTitle,
                                                  style: TextStyle(
                                                      fontSize: largeText(),
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      color: primaryColor),
                                                ),
                                                //espace
                                                SizedBox(
                                                  height:
                                                      appHeightSize(context) *
                                                          0.01,
                                                ),
                                                //description
                                                Text(
                                                  views[selectedPage]
                                                      .description,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: mediumText(),
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .inversePrimary),
                                                ),
                                              ],
                                            )),
                                          ),
                                        ],
                                      ),
                                    );
                                  })),

                          /// dots indicators
                          // PageViewDotIndicator (ne l'afficher à cette possition que l'orsqu'on n'est pas sur la dernière page de la pageView)
                          PageViewDotIndicator(
                            /*  onItemClicked: (index) {
                          setState(() {
                            selectedPage = index;
                          });
                          _pageController.animateToPage(
                            selectedPage,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.linear,
                          );
                        },*/
                            currentItem: selectedPage,
                            count: views.length,
                            unselectedColor:
                                Theme.of(context).colorScheme.background,
                            selectedColor: primaryColor,
                            borderRadius: BorderRadius.circular(300),
                            duration: const Duration(milliseconds: 200),
                            size: Size(appWidthSize(context) * 0.1,
                                appHeightSize(context) * 0.012),
                            unselectedSize: Size(appWidthSize(context) * 0.03,
                                appHeightSize(context) * 0.012),
                            boxShape: BoxShape.rectangle,
                          ),

                          //espace
                          SizedBox(
                            height: appHeightSize(context) * 0.06,
                          ),

                          /// le bouton d'INSCRIPTION ou SUIVANT (ne l'afficher que l'orsqu'on est sur la dernière page de la pageView)
                          selectedPage == views.length - 1

                              /// bouton S'INSCRIRE
                              ? GestureDetector(
                                  onTap: () {
                                    /// dialog de choix du profil vendeur/client
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: AppText(
                                            text:
                                                'Que comptez-vous faire sur l\'application ?',
                                            fontSize: mediumText(),
                                            maxLine: 2,
                                            textAlign: TextAlign.center,
                                          ),
                                          content: SizedBox(
                                            height:
                                                appHeightSize(context) * 0.17,
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/inscriptionVendeurPage');
                                                    },
                                                    child: Container(
                                                      height: appHeightSize(
                                                              context) *
                                                          0.06,
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .monetization_on_outlined,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: appWidthSize(
                                                                    context) *
                                                                0.05,
                                                          ),
                                                          AppText(
                                                            text: 'Vendre',
                                                            fontSize:
                                                                mediumText(),
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: appWidthSize(
                                                                    context) *
                                                                0.05,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: largeText(),
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              '/inscriptionPage');
                                                    },
                                                    child: Container(
                                                      height: appHeightSize(
                                                              context) *
                                                          0.06,
                                                      decoration: BoxDecoration(
                                                          color: primaryColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .shopping_cart_outlined,
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: appWidthSize(
                                                                    context) *
                                                                0.05,
                                                          ),
                                                          AppText(
                                                            text: 'Acheter',
                                                            fontSize:
                                                                mediumText(),
                                                            color: Colors.white,
                                                          ),
                                                          SizedBox(
                                                            width: appWidthSize(
                                                                    context) *
                                                                0.05,
                                                          ),
                                                          Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            size: largeText(),
                                                            color: Colors.white,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          icon: CircleAvatar(
                                              radius:
                                                  appHeightSize(context) * 0.05,
                                              child: Icon(
                                                Icons.question_mark,
                                                size: largeText() * 2,
                                                color: Colors.green,
                                              )),
                                          iconColor: Colors.white,
                                          elevation: 25,
                                          shadowColor: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                          actions: <Widget>[
                                            TextButton(
                                              child: AppText(
                                                text: 'Annuler',
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: appWidthSize(context) * 0.05,
                                        right: appWidthSize(context) * 0.05),
                                    child: Container(
                                        height: appHeightSize(context) * 0.06,
                                        width: appHeightSize(context) * 0.3,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          /*shape: BoxShape.circle,*/
                                          border: const Border(),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface)
                                          ],
                                        ),
                                        child: AppText(
                                          text: 'S\'inscrire',
                                          color: Colors.white,
                                          fontSize: largeText(),
                                        )),
                                  ),
                                )

                              /// bouton SUIVANT
                              : GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedPage = selectedPage + 1;
                                    });
                                    ////_pageController.jumpToPage(selectedPage);

                                    _pageController.animateToPage(
                                      selectedPage,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.linear,
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: appWidthSize(context) * 0.05,
                                        right: appWidthSize(context) * 0.05),
                                    child: Container(
                                        height: appHeightSize(context) * 0.06,
                                        width: appHeightSize(context) * 0.3,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          /*shape: BoxShape.circle,*/
                                          border: const Border(),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inversePrimary),
                                            BoxShadow(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .inverseSurface)
                                          ],
                                        ),
                                        child: AppText(
                                          text: 'Suivant',
                                          color: Colors.white,
                                          fontSize: largeText(),
                                        )),
                                  ),
                                ),
                        ]);
                      }),
                    ),

                    // les flèches Avant-Arrière (Suivant-Précédent)
                    Positioned(
                        child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // fléche Arrière (Précédent)
                            selectedPage != 0
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPage = selectedPage - 1;
                                      });
                                      //_pageController.jumpToPage(selectedPage);
                                      _pageController.animateToPage(
                                        selectedPage,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear,
                                      );
                                    },
                                    child: const Icon(Icons.arrow_back_ios))
                                : Container(),

                            // flèche Avant (Suivant)
                            selectedPage != views.length - 1
                                ? GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPage = selectedPage + 1;
                                      });
                                      //_pageController.jumpToPage(selectedPage);
                                      _pageController.animateToPage(
                                        selectedPage,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.linear,
                                      );
                                    },
                                    child: const Icon(Icons.arrow_forward_ios))
                                : Container()
                          ],
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ));
  }
}
